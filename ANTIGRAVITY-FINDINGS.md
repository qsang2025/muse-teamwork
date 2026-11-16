# ANTIGRAVITY-FINDINGS.md — Comprehensive Review & Optimization Blueprint for `muse-teamwork`

- **Date:** 2026-11-16 (22:15, Vietnam Time / UTC+7)
- **Reviewer:** Antigravity Teamwork & Architecture Sentinel (Executor Sub-agent)
- **Target Repository:** [qsang2025/muse-teamwork](https://github.com/qsang2025/muse-teamwork) (`main` @ `cc4a96d`)
- **Review Branch:** `feature/antigravity-review`
- **Scope & Protocol:** In strict accordance with `docs/ANTIGRAVITY-REVIEW.md` (§5 Requirements, §6 Hard Constraints, §8 Core Questions Q1–Q6).

---

## Executive Summary

The `muse-teamwork` repository establishes a lightweight, zero-dependency, asynchronous multi-agent coordination system across three distributed Claude/LLM instances (`muse-main`, `muse-1`, `muse-2`) owned by Anh Dương Nguyễn Quốc Sáng.

### Key Conclusions:
1. **Architectural Viability (Pass with Caveats):** The **GitHub-first** model is **the only viable zero-cost, zero-infrastructure architecture** given that `muse-main` is hosted on a client-only VM (unable to accept inbound Tailscale connections) and workers `muse-1`/`muse-2` have no exposed ports.
2. **Critical Flaw (P0 - Toxic Unpushed Commit):** `scripts/claim-task.sh:60-63` suffers from a fatal unhandled push rejection. If Agent A and Agent B concurrently claim the same task, Agent B's `git push` is rejected. Because `set -e` aborts the script immediately without rolling back the local commit (`git reset --hard HEAD~1`), Agent B's local workspace is left 1 commit ahead of remote. On the next `git pull --rebase`, Git attempts to replay Agent B's invalid claim over Agent A's remote claim, resulting in an unrecoverable **Merge Conflict in `tasks/<id>.json`**, completely locking up Agent B's automated pipeline.
3. **Data Disconnect (P0 - Hub/Git Split-Brain):** `hub/server.js:37` writes to `hub/data/tasks.json` while git tracks individual `tasks/<id>.json` files. If Hub is activated, claims on Hub are never propagated to GitHub files, and claims on GitHub are invisible to Hub.
4. **Single Point of Failure (SPOF):** `muse-main` is currently the sole entity capable of running device tests and merging to `Qsang_vbook`. When scaling from 3 to 7 agents (3 Muse + 4 Antigravity), this single review/device-test bottleneck will saturate immediately.

---

## 1. Architectural Verification (§5.a, §8.Q1, §8.Q3)

### 1.1 Empirical Verification of Network Realities
- **`muse-main` (VM Linux, 100.114.114.44):**
  - Confirmed `can_host_hub: false` in `agents.yaml:26`.
  - The node is on a restrictive NAT/overlay network where incoming Tailscale connections are dropped or cannot be bound without root/daemon reconfiguration.
- **`muse-1` (100.85.79.92) & `muse-2` (100.126.2.102):**
  - Empirical probe on 2026-11-16 ~21:44 via proxy port 3130 (`docs/SETUP-HUB.md:8-10`, `agents.yaml:45,63`):
    ```bash
    curl -m 5 --proxy "$tunnel_proxy" http://100.85.79.92:80 (or 8080/18080/3000/8787) -> timeout 5s, HTTP code 000
    curl -m 5 --proxy "$tunnel_proxy" http://100.126.2.102:80 (or 8080/18080/3000/8787) -> timeout 5s, HTTP code 000
    ```
  - Result: No worker is running any listener daemon. While Tailscale coordinates node discovery, peer-to-peer ingress is entirely absent.

### 1.2 Evaluation of Coordination Topologies
| Architecture | Zero Infra? | Resilient to Network Splits? | Real-Time Latency | Concurrency Safety | Complexity | Verdict |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Plan A: GitHub-first (`tasks/*.json`)** | **YES** | **YES (Async)** | ~1–5 mins (polling) | Optimistic concurrency (Git push) | Minimal | **RECOMMENDED & SUFFICIENT** |
| **Plan B: Tailscale Hub (`hub/server.js`)** | NO (Requires live host & port forward) | NO (Single host failure halts hub) | <100ms (HTTP) | Centralized mutex | Low | **DEFER until host is permanent** |
| **Plan C: GitHub IssueOps (Labels/API)** | **YES** | **YES** | ~5–10s (Webhook / REST) | Atomic labels via GitHub REST API | Medium (API rate limits) | Viable for >7 agents |
| **Plan D: Free Cloudflare Worker + KV** | NO (External account required) | High | <50ms | Atomic KV transactions | Low-Medium | Unnecessary overhead for 3 agents |

### 1.3 Answer to §8.Q1 & §8.Q3
- **Answer to Q1 (Is GitHub-first enough for 3 agents?):**
  **YES, GitHub-first is 100% sufficient for 3 agents.**
  The missing pieces are operational, not architectural:
  1. Automated rollback on failed claim push (`claim-task.sh`).
  2. An automated sweep script (`sweep-expired.sh`) so expired claims do not require manual human cleaning.
  3. A console status visualizer (`status-board.sh`) so agents and Anh can see current workload without parsing raw JSON.
- **Answer to Q3 (Should Tailscale Hub be turned on now?):**
  **NO, DO NOT turn on Tailscale Hub for tasks 087/088.**
  GitHub-only is completely sufficient. Turning on Hub right now introduces split-brain risk because `hub/server.js` does not synchronize with `tasks/*.json`. If Hub is ever desired in the future, it should only be hosted on Anh's PC (Plan C in `docs/SETUP-HUB.md:49`) because it has a persistent desktop environment.

---

## 2. Vulnerability Audit & Failure Mode Simulation (§5.b, §8.Q2, §8.Q4)

### 2.1 The "Toxic Unpushed Commit" Race Condition (`scripts/claim-task.sh:36-63`)
In `scripts/claim-task.sh`:
```bash
33: echo "Đang git pull để lấy trạng thái mới nhất..."
36: git pull --rebase || { echo "git pull lỗi — kiểm tra mạng rồi chạy lại."; exit 1; }
...
61: git add "$FILE"
62: git commit -m "claim: $ID -> $AGENT" -q
63: git push -q
```

#### Simulation of Concurrent Claim:
1. Task `087` is `open`.
2. **Time $T_0$:** Agent 1 runs `claim-task.sh 087 muse-1`. It pulls latest `main`, edits JSON, creates local commit $C_1$, and begins pushing to remote.
3. **Time $T_0 + 500\text{ms}$:** Agent 2 runs `claim-task.sh 087 muse-2`. It pulls latest `main` (which does NOT yet have $C_1$), edits JSON, creates local commit $C_2$.
4. **Time $T_0 + 1000\text{ms}$:** Agent 1's push succeeds. Remote `main` advances to $C_1$.
5. **Time $T_0 + 1200\text{ms}$:** Agent 2 executes `git push -q`.
   - **Result:** Git rejects the push: `[rejected] main -> main (fetch first)`.
   - Because `set -e` is active (line 10), the script terminates immediately with exit code 1.
6. **The Toxic State:**
   - Commit $C_2$ (`claim: 087 -> muse-2`) remains in Agent 2's local branch.
   - On the next command or next script invocation (e.g. attempting to claim task 088 or pulling for updates), `claim-task.sh` executes line 36: `git pull --rebase`.
   - Git attempts to rebase commit $C_2$ on top of remote $C_1$.
   - Both commits modify the exact same lines in `tasks/087-novelnext-retest.json` (`status`, `assignee`, `claimed_at`).
   - **Git throws a Hard Merge Conflict (`CONFLICT (content): Merge conflict in tasks/087-novelnext-retest.json`)**.
   - Agent 2 is now stuck in an interactive rebase state (`Rebasing (1/1)`). Subsequent git commands fail with `fatal: rebase in progress`.
7. **Empirical Reproduction Output:**
   ```
   Agent 2 push returncode: 1
   Agent 2 push stderr:
    ! [rejected]        main -> main (fetch first)
   Agent 2 git status:
    Your branch is ahead of 'origin/main' by 1 commit.
   Agent 2 pull --rebase returncode: 1
   CONFLICT (content): Merge conflict in tasks/task.json
   error: could not apply 551970e... claim agent-2
   ```

### 2.2 Hub vs. Git Split-Brain Desynchronization
- In `hub/server.js:36-37`:
  ```javascript
  const DATA_DIR = path.join(__dirname, 'data');
  const DATA_FILE = path.join(DATA_DIR, 'tasks.json');
  ```
- `hub/server.js` maintains a completely isolated JSON database at `hub/data/tasks.json` (which is in `.gitignore`).
- Meanwhile, the git repository stores tasks individually in `tasks/*.json`.
- There is **zero synchronization logic** between `server.js` and `tasks/*.json`.
- **Consequence:** If an agent claims a task via `hub/client.js claim 087`, the task status in `tasks/087-novelnext-retest.json` remains `open`. Another agent using `scripts/claim-task.sh` will claim the same task on GitHub and push successfully.

### 2.3 Claim Expiration Deadlock in GitHub-Only Mode
- In `hub/server.js:72-86`, `sweepExpired` automatically runs on every incoming HTTP request.
- In GitHub-only mode, there is no running process.
- If `muse-1` claims task `087` but crashes, loses internet, or hangs:
  - Task status remains `"status": "claimed"` indefinitely.
  - `PROTOCOL.md:40-43` notes that other agents are forbidden from touching claimed tasks until `muse-main` manually cleans them.
  - This creates an indefinite pipeline deadlock if `muse-main` is not actively monitoring.

### 2.4 Merge Conflicts on Task Files During Status Updates
- If two agents finish different tasks simultaneously and update their respective task files:
  - Agent 1 modifies `tasks/087.json`.
  - Agent 2 modifies `tasks/088.json`.
  - `git pull --rebase` automatically rebases without conflict because different files are touched.
- However, if two agents attempt to append to a shared file (e.g. `ROADMAP.md` or a shared log), rebase conflicts occur. The single-file-per-task architecture (`tasks/<id>.json`) is sound and properly prevents cross-task merge conflicts.

### 2.5 Single Point of Failure (SPOF) at `muse-main`
- Under `PROTOCOL.md §4` and `agents.yaml:25-33`:
  - `can_merge_qsang_vbook: true` is granted **exclusively** to `muse-main`.
  - `device-test` is available **only** on `muse-main` (connected to Anh's phone).
- If `muse-main`'s VM restarts, hits API limits, or hangs:
  - Worker agents (`muse-1`, `muse-2`) continue building branches, but all completed work piles up in `review`.
  - No code can be merged into `Qsang_vbook`.

### 2.6 Answer to §8.Q2 & §8.Q4
- **Answer to Q2 (Single biggest weakness of current design):**
  **The unhandled `git push` rejection in `scripts/claim-task.sh` leaving a dirty local commit that causes fatal rebase lockups on subsequent runs.**
  (This is an immediate, deterministic showstopper for automated agents).
- **Answer to Q4 (Does git claim need stronger locks like GitHub Issues or PR checks?):**
  **NO, for 3 agents, Git optimistic concurrency ("first push wins") is completely adequate**, PROVIDED that `scripts/claim-task.sh` is patched to immediately execute `git reset --hard HEAD~1` when a push fails, inspect the winner's claim, and return a clean exit code 3 without corrupting the local branch. Stronger locking (e.g. Issue labels or distributed locks) is over-engineering for 3 agents and introduces GitHub API rate limit risks.

---

## 3. Scalability Stress-Testing: 3 Agents -> 7 Agents (§5.c, §8.Q5)

### 3.1 Concurrency Model & Breaking Points
When scaling the swarm from 3 Muse agents to 7 agents (3 Muse + 4 Antigravity sub-agents):

```
                               ┌───► muse-1 (Worker)
                               ├───► muse-2 (Worker)
                               ├───► agy-worker-1 (Worker)
  Task Backlog                 ├───► agy-worker-2 (Worker)       Review Queue           Device Test & Merge
  [tasks/*.json] ─────────────┼───► agy-worker-3 (Worker) ────► [status: review] ─────► [muse-main ONLY]
                               └───► agy-worker-4 (Worker)              │                     │
                                                                        ▼                     ▼
                                                             Merge Bottleneck!        Single Phone SPOF!
```

#### Breaking Point Analysis:
1. **Git Push Contention on `main` (Probability of Collision):**
   - With $N = 3$ agents and task durations $\sim 30$–60 minutes, push collision probability is $< 2\%$.
   - With $N = 7$ agents, claim/heartbeat/review events arrive at a rate $\lambda \approx 14 \text{ events/hr}$. The probability that two agents push within a 5-second window reaches:
     $$P(\text{collision}) = 1 - e^{-\lambda \Delta t} \approx 1 - e^{-(14/3600) \times 5} \approx 1.9\% \text{ per push}$$
     Over 50 task updates, the chance of at least one agent hitting a race condition exceeds **$62\%$**. Without push rollback and retry logic, the entire swarm will stall within a few hours.
2. **Review & Device-Test Saturation (The Primary Bottleneck):**
   - 6 worker agents generating pull requests with an average task turnaround of 45 minutes will produce **8 completed tasks per hour**.
   - `muse-main` requires approximately 3–5 minutes per task to fetch the branch, run `node scripts/cli.js validate`, deploy to the test phone, execute UI tests, and merge.
   - Maximum throughput of `muse-main` = $\frac{60}{5} = 12 \text{ tasks/hr}$ under 100% continuous utilization.
   - At 8 tasks/hr, `muse-main` enters queue saturation (M/M/1 queue with $\rho = \frac{8}{12} \approx 0.67$), causing review queue wait times to balloon to $15–30$ minutes per task.
3. **GitHub API Secondary Rate Limits:**
   - If 7 agents poll GitHub via `git pull` every 60 seconds, that generates $7 \times 60 = 420 \text{ git requests/hr}$. While Git over HTTPS has higher thresholds than REST, concurrent authenticated API calls will trigger GitHub secondary rate limits.

### 3.2 Recommended Concurrency Thresholds & Swarm Topology
To scale stably to 7 agents without architectural breakdown:

1. **Queue Sharding by Domain (`tasks/<domain>/`):**
   - `tasks/vbook/`: vBook extension repair and creation (claimed by workers with vBook skills).
   - `tasks/research/`: Fork scans, site probes, API analysis (claimed by research agents).
   - `tasks/infra/`: CI/CD, scripts, toolchain improvements.
2. **Tiered Verification Gatekeeping:**
   - **Tier 1 (Peer Review):** Any idle worker agent can claim tasks in `status: "review"`, checkout the branch, run offline `validate` and unit tests, and add a `peer_review: PASS` note.
   - **Tier 2 (Device Test & Merge):** `muse-main` only touches tasks that already possess `peer_review: PASS`. This cuts `muse-main`'s verification time from 5 minutes to 90 seconds, quadrupling merge throughput.
3. **Polling Jitter & Exponential Backoff:**
   - Polling intervals must not be fixed. Agents must use random jitter: $t_{\text{poll}} = 120\text{s} + \text{rand}(0, 60\text{s})$.

---

## 4. Concrete Actionable Proposals (P0 / P1 / P2) (§5.d, §8.Q6)

### 4.1 P0 (Critical / Immediate Fixes)

#### P0.1: Fix Race Condition in `scripts/claim-task.sh` (Add Rollback & Retry)
- **File:** `scripts/claim-task.sh`
- **Lines:** 33–66
- **Problem:** When `git push` fails, the local claim commit is retained. Next rebase explodes.
- **Replacement Code:**
```bash
# --- REPLACEMENT FOR scripts/claim-task.sh:33-66 ---
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Đang cập nhật repo (lần thử $((RETRY_COUNT + 1))/$MAX_RETRIES)..."
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git branch --set-upstream-to="origin/$BRANCH" "$BRANCH" 2>/dev/null || true
  if ! git pull --rebase -q; then
    echo "git pull --rebase thất bại. Đang khôi phục trạng thái sạch..."
    git rebase --abort 2>/dev/null || true
    git reset --hard "origin/$BRANCH" 2>/dev/null || true
    sleep $(( 1 + RANDOM % 3 ))
    RETRY_COUNT=$((RETRY_COUNT + 1))
    continue
  fi

  # Chạy Python kiểm tra và sửa JSON
  if ! python3 - "$FILE" "$AGENT" <<'EOF'
import json, sys
from datetime import datetime, timezone, timedelta

path, agent = sys.argv[1:3]
try:
    with open(path, "r", encoding="utf-8") as f:
        task = json.load(f)
except Exception as e:
    sys.exit(4)

if task.get("status") != "open":
    print(f"Task {task['id']} KHÔNG còn open (status={task.get('status')}, assignee={task.get('assignee') or 'trống'}).")
    sys.exit(3)
if task.get("assignee"):
    print(f"Task {task['id']} đã có người nhận ({task['assignee']}).")
    sys.exit(3)

now = datetime.now(timezone(timedelta(hours=7)))
task["status"] = "claimed"
task["assignee"] = agent
task["claimed_at"] = now.strftime("%Y-%m-%dT%H:%M:%S+07:00")
task["claim_expires_at"] = (now + timedelta(hours=2)).strftime("%Y-%m-%dT%H:%M:%S+07:00")

with open(path, "w", encoding="utf-8") as f:
    json.dump(task, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"Claim OK: {task['id']} → {agent}, hết hạn {task['claim_expires_at']}.")
EOF
  then
    PY_EXIT=$?
    if [ $PY_EXIT -eq 3 ]; then
      echo "Task đã có người khác nhận trước. Dừng claim."
      exit 3
    else
      echo "Lỗi xử lý file task (code $PY_EXIT)."
      exit 1
    fi
  fi

  echo "Đang commit và đẩy lên remote..."
  git add "$FILE"
  git commit -m "claim: $ID -> $AGENT" -q

  if git push -q 2>/dev/null; then
    echo "Push thành công! Đã giữ task $ID cho $AGENT."
    echo "Tiếp theo: tạo branch trên repo đích rồi làm (xem PROTOCOL.md §2)."
    exit 0
  else
    echo "CẢNH BÁO: Tranh chấp push! Người khác đã push trước. Đang rollback commit local..."
    git reset --hard HEAD~1 -q
    RETRY_COUNT=$((RETRY_COUNT + 1))
    sleep $(( 1 + RANDOM % 3 ))
  fi
done

echo "Thất bại sau $MAX_RETRIES lần thử. Vui lòng thử lại sau."
exit 1
```
- **Verification Command:**
  Run simulation test in temporary directory: create 2 local clones against a bare remote, trigger concurrent claims. Clone 2 must cleanly rollback with `git reset --hard HEAD~1`, observe Clone 1's claim, print `Task không còn open`, and exit code 3 with a 100% clean `git status`.

---

#### P0.2: Implement Automated Expired Claim Sweeper (`scripts/sweep-expired.sh`)
- **File:** Create new script `scripts/sweep-expired.sh`
- **Purpose:** In GitHub-only mode, claims that exceed 2 hours without heartbeat must automatically return to `status: "open"`.
- **Implementation Code:**
```bash
#!/bin/bash
# scripts/sweep-expired.sh — Quét và thu hồi các task claimed/doing quá hạn 2h
set -euo pipefail
cd "$(dirname "$0")/.."

echo "Đang đồng bộ repo trước khi quét..."
git pull --rebase -q

python3 - <<'EOF'
import glob, json, os, sys
from datetime import datetime, timezone, timedelta

now = datetime.now(timezone(timedelta(hours=7)))
modified = []

for f in sorted(glob.glob("tasks/*.json")):
    if os.path.basename(f) == "_template.json":
        continue
    try:
        with open(f, "r", encoding="utf-8") as fh:
            t = json.load(fh)
    except Exception:
        continue

    status = t.get("status")
    exp_str = t.get("claim_expires_at")
    if status in ["claimed", "doing"] and exp_str:
        try:
            exp_dt = datetime.fromisoformat(exp_str)
            if now > exp_dt:
                old_assignee = t.get("assignee")
                t["status"] = "open"
                t["assignee"] = ""
                t["claimed_at"] = ""
                t["claim_expires_at"] = ""
                note = f"[sweep {now.strftime('%d/%m %H:%M')}: hết hạn 2h từ {old_assignee}, trả về open]"
                t["notes"] = ((t.get("notes") or "") + " " + note).strip()
                with open(f, "w", encoding="utf-8") as fh:
                    json.dump(t, fh, indent=2, ensure_ascii=False)
                    fh.write("\n")
                modified.append(t["id"])
                print(f"Thu hồi task quá hạn: {t['id']} (từ {old_assignee})")
        except Exception as e:
            print(f"Lỗi phân tích hạn task {f}: {e}")

if modified:
    sys.exit(10) # Báo hiệu có task được cập nhật
EOF
PY_STATUS=$?

if [ $PY_STATUS -eq 10 ]; then
  git add tasks/*.json
  git commit -m "chore(tasks): sweep expired claims back to open" -q
  git push -q
  echo "Đã đẩy cập nhật thu hồi task lên GitHub."
else
  echo "Không có task nào hết hạn."
fi
```
- **Verification Command:**
  Set a task's `claim_expires_at` to an hour in the past, run `./scripts/sweep-expired.sh`. Verify the task reverts to `open`, commit is created and pushed cleanly.

---

#### P0.3: Bridge or Deprecate `hub/server.js` File Storage
- **File:** `hub/server.js`
- **Problem:** Writes to `hub/data/tasks.json` instead of `tasks/<id>.json`.
- **Immediate Fix:** If Hub is maintained, replace `loadTasks()` and `saveTasks()` in `hub/server.js:42-52` to read and write directly to `tasks/*.json` in the git tree, or explicitly disable `hub/server.js` with a warning until bidirectional git sync is implemented.
- **Recommended Action:** Place a prominent banner in `hub/server.js` and `docs/SETUP-HUB.md` affirming that Hub is in **EXPERIMENTAL/STAGING** status and must not be used concurrently with `scripts/claim-task.sh`.

---

### 4.2 P1 (Near-Term Operational Improvements)

#### P1.1: Live Status Board (`scripts/status-board.sh`)
- **File:** `scripts/status-board.sh`
- **Purpose:** Immediate terminal overview for Anh and all agents of who is working on what, priority, and remaining claim time.
- **Implementation Code:**
```bash
#!/bin/bash
# scripts/status-board.sh — Hiển thị bảng trạng thái task tức thì
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'EOF'
import glob, json, os
from datetime import datetime, timezone, timedelta

now = datetime.now(timezone(timedelta(hours=7)))
tasks = []
for f in sorted(glob.glob("tasks/*.json")):
    if os.path.basename(f) == "_template.json": continue
    try:
        t = json.load(open(f, encoding="utf-8"))
        tasks.append(t)
    except Exception: pass

print(f"\n=== BẢNG TRẠNG THÁI TASK ({now.strftime('%Y-%m-%d %H:%M:%S +07:00')}) ===")
header = f"{'ID':<25} {'STATUS':<10} {'PRIORITY':<9} {'ASSIGNEE':<12} {'HẠN CÒN LẠI'}"
print(header)
print("-" * len(header))

for t in tasks:
    tid = t.get("id", "")[:24]
    st = t.get("status", "")[:9]
    pr = t.get("priority", "")[:8]
    asg = (t.get("assignee") or "-")[:11]
    exp = t.get("claim_expires_at")
    rem = "-"
    if exp and st in ["claimed", "doing"]:
        try:
            exp_dt = datetime.fromisoformat(exp)
            delta = exp_dt - now
            mins = int(delta.total_seconds() / 60)
            rem = f"{mins}p" if mins > 0 else "HẾT HẠN"
        except Exception: pass
    print(f"{tid:<25} {st:<10} {pr:<9} {asg:<12} {rem}")
print("=" * len(header) + "\n")
EOF
```

#### P1.2: Heartbeat CLI Script (`scripts/heartbeat-task.sh`)
- **File:** `scripts/heartbeat-task.sh`
- **Purpose:** Allows a worker agent in GitHub-only mode to extend its claim by 2 hours with a single command without editing JSON manually:
  `./scripts/heartbeat-task.sh 087-novelnext-retest muse-1 "Đang debug selector"`

---

### 4.3 P2 (Long-Term Scalability & 7-Agent Architecture)

1. **Task Archival & Sharding (`tasks/active/` vs `tasks/completed/`):**
   - Once tasks exceed 100 entries, globbing `tasks/*.json` on every pull slows down. Move `status: done` tasks into `tasks/archive/YYYY/`.
2. **Pre-Review Automation Hook:**
   - Implement a lightweight GitHub Action that triggers whenever a PR is submitted on `Qsang_vbook`: automatically runs `node scripts/cli.js validate` and posts the status directly into the corresponding `tasks/<id>.json` file.

---

## 5. Direct Answers to §8 Core Questions

### Q1: Is the GitHub-first + optional Hub architecture sufficient for 3 Muses to work in parallel? If not, what is missing?
> **Answer:** **Yes, it is completely sufficient.**
> The only missing pieces are operational safeguards:
> 1. Rollback logic in `scripts/claim-task.sh` to prevent local git corruption upon lost races.
> 2. An automated expiration sweeper (`scripts/sweep-expired.sh`) so deadlocks do not require manual intervention.
> 3. Disabling or bridging `hub/server.js` so it does not desynchronize with `tasks/*.json`.

### Q2: What is the single biggest weakness of the current design?
> **Answer:** **The unhandled push failure in `scripts/claim-task.sh:63`.**
> When two agents race to claim a task, the loser's push fails, but the unpushed commit remains on their local branch. On their next `git pull --rebase`, a fatal merge conflict occurs inside `tasks/<id>.json`, permanently freezing the loser's automated agent loop until manual human cleanup (`git rebase --abort && git reset --hard origin/main`).

### Q3: Should Tailscale Hub be turned on now, or is GitHub-only enough for test tasks 087/088? If turned on, which machine should host it and what command verifies it?
> **Answer:** **Do NOT turn on Tailscale Hub now. GitHub-only is 100% sufficient for tasks 087 and 088.**
> - `hub/server.js` currently stores tasks in `hub/data/tasks.json`, creating an unsynchronized split-brain with GitHub.
> - Furthermore, worker machines have closed ports (timeout code 000).
> - If Anh ever decides to host Hub in the future, it should run on **Anh's persistent Windows PC** (`docs/SETUP-HUB.md` Plan C).
> - Verification command from VM via proxy:
>   ```bash
>   tunnel_proxy="${HTTPS_PROXY%:*}:3130"
>   curl -m 5 --proxy "$tunnel_proxy" http://<ANH_PC_TAILSCALE_IP>:8787/health
>   # Expected response: {"ok":true,"hub":"muse-teamwork",...}
>   ```

### Q4: Does the race claim via git need stronger locks (e.g. GitHub Issues, PR checks) or is "first push wins" enough for 3 agents?
> **Answer:** **"First push wins" is completely adequate for 3 agents.**
> Stronger external locks (GitHub Issue labels or external Redis/KV locks) are unnecessary complexity for 3 agents and risk running into GitHub REST API rate limits. All that is required is making `claim-task.sh` resilient: on push rejection, immediately run `git reset --hard HEAD~1`, notify the agent that the task was lost, and exit cleanly with code 3.

### Q5: If expanded to 7 agents (3 Muse + 4 Antigravity), what breaks first, and is queue or repo separation needed?
> **Answer:**
> 1. **What breaks first:** **`muse-main`'s review and device-test pipeline.** With 6 workers submitting tasks, `muse-main` will be overwhelmed by the serial requirement to test on the single physical phone.
> 2. **Push contention on git:** Push collisions will jump to $>60\%$ over typical operational windows.
> 3. **Queue separation needed?** **Yes, directory-based queue sharding within the same repo** (e.g. `tasks/vbook/`, `tasks/research/`, `tasks/infra/`). A single repo remains ideal for traceability, but dividing queues and allowing peer review (workers cross-validating PRs before passing them to `muse-main`) is essential.

### Q6: What decisions are needed from Anh before the two worker Muses begin taking real tasks?
> **Answer:**
> Anh only needs to confirm **three simple operational decisions**:
> 1. **Confirm GitHub-only mode for Phase 1:** Officially instruct `muse-1` and `muse-2` to only use `scripts/claim-task.sh` (do not attempt to start or connect to Tailscale Hub).
> 2. **Apply P0 patch to `claim-task.sh`:** Merge the rollback enhancement into `scripts/claim-task.sh` so neither worker gets bricked by a race condition.
> 3. **Assign initial tasks directly:** To avoid an immediate race on day one, Anh or `muse-main` can pre-assign task `087` to `muse-1` and task `088` to `muse-2` in their respective `tasks/*.json` files.

---

## 6. Verification and Integrity Sign-Off

- [x] **Zero changes to open tasks:** `tasks/087-novelnext-retest.json` and `tasks/088-fork-rescan-13.json` are 100% identical to upstream `main`.
- [x] **Zero secrets exposed:** Automated scans confirm no API keys, tokens, cookies, or passwords exist in the review branch.
- [x] **Branch Isolation:** All review analysis and code proposals exist exclusively on `feature/antigravity-review`. No PR or push to `main` has been performed.
