# Plan: Antigravity Technical Review & Optimization of `muse-teamwork`
- Date: 2026-11-16
- Repo: `https://github.com/qsang2025/muse-teamwork`, branch `feature/antigravity-review`
- Planner: Master Agent (Gemini 4 Argon Medium Planning Mode 2)
- Coordinator: Antigravity Primary Agent (Gemini 3.8 Flash)
- Executor: Antigravity Subagents (Gemini 3.8 Flash)
- Request file: `.agents/plans/2026-11-16-antigravity-review-REQUEST.md`
- Context bundle: `.agents/plans/antigravity-review-CONTEXT.md`

---

## 1. Goal
Execute an in-depth technical verification, vulnerability audit, scalability assessment (3 to 7 agents), and prioritized optimization blueprint (P0/P1/P2) for `muse-teamwork` strictly adhering to §5, §6, and §8 of `docs/ANTIGRAVITY-REVIEW.md`. Document all findings, empirical verification results, code replacements (file:line), and direct answers to §8 Q1–Q6 in `ANTIGRAVITY-FINDINGS.md` on branch `feature/antigravity-review`.

---

## 2. Context the Executor Needs

### Core Architecture & Key Files
- `README.md`, `PROTOCOL.md`, `agents.yaml`: Architectural specifications, RACI matrix, 3-agent roles, task state machine.
- `tasks/`: Authoritative Single Source of Truth (`tasks/*.json`).
  - `tasks/087-novelnext-retest.json` & `tasks/088-fork-rescan-13.json`: MUST REMAIN UNTOUCHED.
- `scripts/claim-task.sh`: Git-first claim mechanism (`git pull --rebase` -> Python edits JSON -> `git commit` -> `git push`).
- `hub/server.js` & `hub/client.js`: Optional live Tailscale coordination server (Node.js, port 8787).
  - Note: `server.js` currently stores tasks in `hub/data/tasks.json`, entirely disconnected from `tasks/*.json` on git!

### Hard Constraints & Prohibitions (§6)
- **Review Only**: DO NOT merge into `Qsang_vbook`, DO NOT push to `main` of `muse-teamwork`, DO NOT create new tasks on `main`.
- **Preserve Tasks 087 & 088**: Strictly do not edit open sample tasks.
- **Strictly No Secrets**: Never log, store, or output tokens, passwords, keys, or cookies.
- **Preserve Merge Contract**: `muse-main` remains the sole merging agent. Auto-merge criteria (`validate PASS` + `device test code 0` + `install code 200`) remain immutable.
- **Branch Isolation**: All commits and outputs must live strictly on `feature/antigravity-review`. Never open a PR to `main`.

---

## 3. Execution Steps

### Step 0: Sync, Baseline Commit & Verify Assumptions
- **What to do**:
  1. Commit the REQUEST file, CONTEXT bundle, and this PLAN file to branch `feature/antigravity-review`.
  2. Verify working directory is clean: `git status`.
  3. Verify branch is based on upstream main `735a892`.
- **Expected result**: Branch `feature/antigravity-review` has initial plan tracking commit; clean working tree.
- **Verification**: `git log -1 --oneline`, `git status`.
- **Done when**: Commit created and git status is clean.

### Step 1: Deep Architectural Verification (§5.a, §8.Q1, §8.Q3)
- **What to do**:
  1. Analyze network constraints: `muse-main` is on a VM client-only node (`can_host_hub: false`), unable to bind listening ports across tailnet.
  2. Analyze probe data from 2026-11-16 (ports 80/8080/18080/3000 timeout code 000 on `muse-1` and `muse-2`).
  3. Evaluate GitHub-first as the baseline vs alternatives:
     - GitHub IssueOps (issues/labels/PR checks).
     - Lightweight Cloudflare Worker / VPS hub.
     - Pure Git files in `tasks/*.json`.
  4. Answer §8 Q1 & Q3 with technical evidence, command outputs, and file:line citations.
- **Verification**: Cross-reference `agents.yaml:26`, `agents.yaml:45`, `agents.yaml:63`, and `docs/SETUP-HUB.md`.

### Step 2: Vulnerability Audit & Failure Mode Analysis (§5.b, §8.Q2, §8.Q4)
- **What to do**:
  Thoroughly analyze and simulate the 5 critical failure modes:
  1. **Race Condition in `scripts/claim-task.sh:36-63`**:
     - Analyze concurrent pull -> edit -> commit -> push.
     - What happens when Agent B's `git push` is rejected? `set -e` causes exit, leaving a dirty unpushed local commit that will cause rebase merge conflicts upon next `git pull`.
  2. **Hub vs Git State Split-Brain**:
     - In `hub/server.js:37`, `DATA_FILE` is `hub/data/tasks.json`.
     - Git tasks are in `tasks/<id>.json`. The two systems do not sync. A claim in Hub never updates GitHub!
  3. **Claim Expiration Deadlock in GitHub-only Mode**:
     - In `hub/server.js:72-86`, `sweepExpired` runs on HTTP requests.
     - In GitHub-only mode, there is NO background daemon; an expired task remains stuck in `claimed` indefinitely until manual human/main intervention.
  4. **Merge Conflict on Task Files**:
     - If two agents update different fields in `tasks/<id>.json` or simultaneously update `notes`.
  5. **SPOF at `muse-main`**:
     - `muse-main` is the only entity with `device-test` capability and merge rights. If VM goes down or exhausts quota, the entire pipeline freezes at `review`.
- **Verification**: Detail exact trace, failure sequence, and blast radius for each flaw. Identify the single biggest bottleneck (§8.Q2).

### Step 3: Scalability Stress-Testing: 3 Agents -> 7 Agents (§5.c, §8.Q5)
- **What to do**:
  1. Model operational capacity if expanded from 3 Muse agents to 7 agents (3 Muse + 4 Antigravity).
  2. Map out the breaking points:
     - Git push contention on `main` branch of `muse-teamwork` (Poisson arrival of claims/updates).
     - Single-reviewer bottleneck at `muse-main` (device testing queue serial latency).
     - GitHub API secondary rate limits on polling.
  3. Propose concrete topological solutions:
     - Queue partitioning: `tasks/vbook/`, `tasks/research/`, `tasks/infra/`.
     - Role specialization: worker swarm vs verification gatekeepers.
     - Batching and polling backoff schedules.
- **Verification**: Formal concurrency formulas, estimated queue wait times, and recommended concurrency thresholds.

### Step 4: Concrete Actionable Proposals (P0/P1/P2) (§5.d, §8.Q6)
- **What to do**:
  Draft exact, production-ready code modifications with `file:line` references, replacement code blocks, and verification commands:
  1. **P0 (Critical/Blocking)**:
     - Fix `scripts/claim-task.sh`: Add automatic rollback (`git reset --hard HEAD~1`) on `git push` failure to prevent rebase lockups. Add retry loop with re-check of task status.
     - Fix Hub data persistence: Bridge `hub/server.js` to read/write directly to `tasks/<id>.json` or disable Hub until bridged.
     - Implement GitHub-only expired claim cleaner script (`scripts/sweep-expired.sh`).
  2. **P1 (Near-Term Operational)**:
     - Add `scripts/status-board.sh` for immediate console visibility of task states across agents.
     - Add heartbeat update script (`scripts/heartbeat.sh`) for GitHub-only mode.
     - Auto-stashing and safe rebase wrappers.
  3. **P2 (Long-Term Scalability / 7 Agents)**:
     - Task directory sharding (`tasks/active/`, `tasks/archive/`).
     - Delegated cross-review protocol (offline lint/unit test approval before device test).
  4. Explicitly answer §8.Q6 (Decisions needed from Anh).

### Step 5: Compile `ANTIGRAVITY-FINDINGS.md` & Commit/Push
- **What to do**:
  1. Synthesize all sections into a comprehensive, beautifully structured document: `/home/antigravity/qsang2025/muse-teamwork/ANTIGRAVITY-FINDINGS.md`.
  2. Double-check zero secret leakage, zero modifications to open tasks 087/088, and clean git diff.
  3. Update Section 5 (DoD) and Section 6 (Progress) of this plan file.
  4. Commit all artifacts to `feature/antigravity-review` and push to origin.
  5. Prepare concise executive summary for reporting back.
- **Expected result**: `ANTIGRAVITY-FINDINGS.md` committed and pushed on `feature/antigravity-review`.
- **Verification**: `git log -2 --oneline`, `git status`.

---

## 4. Risks & Fallbacks
- **Risk 1: Accidental conflict with main or parallel tasks**:
  - *Mitigation*: Strictly maintain branch isolation on `feature/antigravity-review`. Do not touch `tasks/087*` or `tasks/088*`.
- **Risk 2: Quota exhaustion mid-execution**:
  - *Mitigation*: Per `quota-workflow`, executor runs on `flash` tier. If interrupted, save state to plan file and commit.
- **Risk 3: Unverifiable theoretical proposals**:
  - *Mitigation*: Every proposal must have exact file:line citations and executable shell/node verification tests.

---

## 5. Definition of Done (Final Checklist)
- [ ] Plan, Request, and Context files tracked in git on `feature/antigravity-review`.
- [ ] Architectural verification completed (§5.a, §8.Q1, §8.Q3) with empirical evidence.
- [ ] Failure mode and vulnerability audit completed (§5.b, §8.Q2, §8.Q4) with race condition analysis.
- [ ] Scalability stress-testing (3 -> 7 agents) completed (§5.c, §8.Q5) with concurrency thresholds.
- [ ] P0, P1, P2 proposals detailed with exact file:line and code replacements (§5.d).
- [ ] Direct answers provided for all 6 questions in §8.
- [ ] Comprehensive report `ANTIGRAVITY-FINDINGS.md` generated and committed.
- [ ] Zero secrets leaked, zero changes to tasks 087/088.
- [ ] Branch `feature/antigravity-review` pushed to origin.

---

## 6. Progress
- [x] Step 0 — Baseline verified. REQUEST & CONTEXT written.
- [ ] Step 1 — Architectural verification (§5.a, §8.Q1, §8.Q3).
- [ ] Step 2 — Vulnerability audit & failure modes (§5.b, §8.Q2, §8.Q4).
- [ ] Step 3 — Scalability stress-test 3 -> 7 agents (§5.c, §8.Q5).
- [ ] Step 4 — Concrete P0/P1/P2 actionable proposals (§5.d, §8.Q6).
- [ ] Step 5 — Compile `ANTIGRAVITY-FINDINGS.md`, commit & push.

---

## 7. Decisions Made During Execution
- 2026-11-16: Confirmed GitHub-only (Plan A) as the sole viable zero-infrastructure path due to client-only VM limitations and unexposed worker ports.
- 2026-11-16: Identified critical flaw in `scripts/claim-task.sh`: lack of `git push` rollback causes local branch pollution on lost races.
