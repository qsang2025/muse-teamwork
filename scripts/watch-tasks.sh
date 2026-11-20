#!/usr/bin/env bash
# watch-tasks.sh — Canh nhe repo muse-teamwork, chi danh thuc agent khi co viec that.
#
# Luat team (PROTOCOL §7, quyet dinh cua Anh 19/11): moi agent quet repo moi
# 5 phut bang script nhe (khong dung AI), chi mo phien lam viec khi script
# bao CO thay doi lien quan den minh. CAM quet moi 1 phut (GitHub co the
# chan tam thoi vi quet qua day; 5 phut da rut luc nhan viec tu ~30 phut
# xuong ~2-3 phut). Webhook khong lam duoc vi VM khong nhan inbound.
#
# Cach dung (lam hook script hoac chay tay):
#   watch-tasks.sh <agent-id> [repo-dir] [state-file]
#   agent-id: muse-main | muse-1 | muse-2
#   repo-dir mac dinh: ~/workspace/muse-teamwork
#   state-file mac dinh: ~/hooks/state/muse-teamwork-watch-<agent>.json
#
# Co che: hoi SHA cua origin/main bang ls-remote truoc (1 request nhe);
# SHA khong doi thi bo qua fetch luon (de xuat 2, Anh duyet 19/11 — giam
# ~90% luong fetch). SHA doi thi git fetch origin main (khong dong vao
# working tree), doc task tu origin/main, so sanh (id, status, assignee,
# preferred_assignee) voi state lan truoc. Bo qua thay doi notes/updated_at
# (heartbeat, binh luan dashboard) de khong danh thuc vo ich.
#
# Dieu kien danh thuc agent A:
#   - task moi xuat hien, giao cho A (preferred/assignee == A, chua done/cancelled)
#   - task chuyen sang review (chi danh thuc muse-main)
#   - task cua A chuyen sang doing (tu review/blocked — lam lai / go ket),
#     sang open (tu blocked/review/doing — mo lai), sang cancelled (dung viec)
#   - WATCHDOG (task 115, quyet 20/11 — sau vu task 112 ket 1h43 vi worker
#     chet ma khong de lai commit): task o "claimed" ma qua 30 phut ke tu
#     claimed_at van chua co commit/heartbeat moi thi danh thuc agent duoc
#     gan (va muse-main nhu luoi an toan). Chi ap dung status "claimed"
#     (task "doing" da co commit dau tien; build dai khong commit la binh
#     thuong). Moi claim chi bao 1 lan; claim moi (claimed_at doi) hoac
#     task roi "claimed" thi dat lai. Kiem tra ca khi SHA khong doi, tren
#     snapshot da luu — vi task ket thi SHA khong doi la dung truong hop
#     can bat. Thoi gian claim giu 2h (khong giam xuong 1h).
#     VA 21/11 (sua bao nham lan 6-8): worker cap nhat status tren branch
#     (doing/review) truoc khi dong bo len main, nen main van ghi claimed
#     trong luc worker da lam xong. Truoc khi ket luan ket, kiem tra commit
#     tren branch cua worker (branch trong task file, repo dich): neu co
#     commit sau claimed_at thi worker da bat dau — KHONG bao. Chi bao khi
#     khong co commit nao sau claimed_at, hoac khong kiem chung duoc branch
#     (khong co branch, fetch loi, repo la — fail-safe, giu hanh vi cu).
#     Task "doing" ket that van bi thu hoi o luot sweep 2h (sweep-expired.sh).
# Lan chay dau (chua co state): ghi baseline, silent, khong danh thuc
# (tru watchdog: task claimed qua 30 phut van bao, vi do la ket that).
# Fetch loi: log + silent (khong ket luan duoc thi im lang).
# Dry-run (HATCH_HOOK_DRY_RUN=1): KHONG ghi state.
set -euo pipefail

# Nap runtime cua hook (silent/wake/log). Chay tay khong co runtime thi
# dung ban du phong in ket qua ra stdout.
if [[ -n "${HATCH_HOOK_RUNTIME:-}" && -f "$HATCH_HOOK_RUNTIME" ]]; then
    # shellcheck disable=SC1090
    source "$HATCH_HOOK_RUNTIME"
elif [[ -f "$HOME/hooks/runtime/hatch_hook_runtime.sh" ]]; then
    # shellcheck disable=SC1091
    source "$HOME/hooks/runtime/hatch_hook_runtime.sh"
else
    silent() { echo "SILENT: ${1-}"; exit 0; }
    wake() { echo "WAKE: ${1-} ${2-}"; exit 0; }
    log() { echo "LOG: ${1-}" >&2; }
fi

AGENT="${1:-}"
REPO="${2:-$HOME/workspace/muse-teamwork}"
STATE="${3:-$HOME/hooks/state/muse-teamwork-watch-${AGENT}.json}"
DRY="${HATCH_HOOK_DRY_RUN:-0}"

if [[ "$AGENT" != "muse-main" && "$AGENT" != "muse-1" && "$AGENT" != "muse-2" ]]; then
    log "agent id khong hop le" "{\"agent\":\"$AGENT\"}"
    silent "agent id khong hop le, bo qua lan quet nay"
fi

# Buoc nhe truoc (de xuat 2, Anh duyet 19/11): hoi SHA cua origin/main bang
# ls-remote (1 request nhe, khong tai object). Neu SHA giong lan truoc thi
# chac chan khong co gi doi — bo qua fetch, nhung VAN chay watchdog tren
# snapshot da luu (task claimed bi ket thi SHA khong doi — dung truong hop
# watchdog can bat). Chi fetch khi SHA doi (hoac chua co SHA luu).
# Giam ~90% luong fetch.
SHA_NEW="$(timeout 30 git -C "$REPO" ls-remote origin main 2>/dev/null | awk '{print $1}' | head -n 1 || true)"
if [[ -z "$SHA_NEW" ]]; then
    log "git ls-remote origin main loi" '{}'
    silent "khong hoi duoc SHA, cho lan quet sau"
fi
OLD_SHA="$(jq -r '.sha // empty' "$STATE" 2>/dev/null || true)"
if [[ -n "$OLD_SHA" && "$OLD_SHA" == "$SHA_NEW" ]]; then
    MODE="watchdog"
else
    MODE="full"
    if ! timeout 60 git -C "$REPO" fetch origin main --quiet 2>/dev/null; then
        log "git fetch origin main loi" '{}'
        silent "khong fetch duoc repo, cho lan quet sau"
    fi
fi

# Doc snapshot (tu origin/main neu MODE=full, tu state da luu neu
# MODE=watchdog) bang python3 (1 tien trinh duy nhat), so sanh voi state,
# in ra quyet dinh JSON: {"decision":..., "reason":..., "payload":...}
DECISION="$(python3 - "$REPO" "$STATE" "$AGENT" "$DRY" "$SHA_NEW" "$MODE" <<'PYEOF'
import json, os, subprocess, sys
from datetime import datetime, timezone, timedelta

repo, state_path, agent, dry = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] == "1"
sha_new = sys.argv[5] if len(sys.argv) > 5 else ""
mode = sys.argv[6] if len(sys.argv) > 6 else "full"

WATCHDOG_STALL_MINUTES = 30

def git(*args):
    r = subprocess.run(["git", "-C", repo] + list(args),
                       capture_output=True, text=True, timeout=30)
    return r.stdout if r.returncode == 0 else ""

def parse_ts(s):
    if not s:
        return None
    try:
        dt = datetime.fromisoformat(str(s).replace("Z", "+00:00"))
    except ValueError:
        return None
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone(timedelta(hours=7)))
    return dt

def load_state():
    try:
        st = json.load(open(state_path, encoding="utf-8"))
    except Exception:
        return {}, {}
    return st.get("tasks", {}) or {}, st.get("watchdog_alerted", {}) or {}

old, alerted = load_state()

if mode == "full":
    # Liet ke file task top-level tren origin/main (bo template + archive).
    files = []
    out = git("ls-tree", "-r", "--name-only", "origin/main", "tasks/")
    for line in out.splitlines():
        line = line.strip()
        if not line.startswith("tasks/") or line.count("/") != 1:
            continue
        name = line[len("tasks/"):]
        if name in ("_template.json", "000-template.json"):
            continue
        if name.endswith(".json"):
            files.append(line)

    snap = {}
    for path in files:
        raw = git("show", f"origin/main:{path}")
        if not raw:
            continue
        try:
            t = json.loads(raw)
        except Exception:
            continue
        tid = str(t.get("id", "") or "")
        if not tid:
            tid = os.path.basename(path).split("-")[0]
        snap[tid] = {
            "status": str(t.get("status", "")),
            "assignee": str(t.get("assignee", "") or ""),
            "preferred_assignee": str(t.get("preferred_assignee", "") or ""),
            "claimed_at": str(t.get("claimed_at", "") or ""),
            "updated_at": str(t.get("updated_at", "") or ""),
            "file": path,
            "branch": str(t.get("branch", "") or (t.get("result") or {}).get("branch", "") or ""),
            "repo": str(t.get("repo", "") or "muse-teamwork"),
        }
else:
    # SHA khong doi: khong co du lieu moi, dung snapshot da luu de chay
    # watchdog (task ket thi SHA khong doi — dung truong hop can bat).
    snap = old

wakes = []

def mine(t):
    return t.get("assignee") == agent or t.get("preferred_assignee") == agent

# --- Danh thuc theo thay doi trang thai (chi MODE=full, co snapshot cu) ---
if mode == "full" and old:
    for tid, cur in snap.items():
        prev = old.get(tid)
        if prev is None:
            if mine(cur) and cur["status"] not in ("done", "cancelled"):
                wakes.append({"task": tid, "why": "new task assigned", "status": cur["status"]})
            continue
        if cur["status"] == prev.get("status"):
            continue
        old_status, new_status = prev.get("status", ""), cur["status"]
        if new_status == "review" and agent == "muse-main":
            wakes.append({"task": tid, "why": "entered review", "from": old_status, "to": new_status})
        elif new_status == "doing" and mine(cur) and old_status in ("review", "blocked"):
            wakes.append({"task": tid, "why": "rework/unblocked to doing", "from": old_status, "to": new_status})
        elif new_status == "open" and mine(cur) and old_status in ("blocked", "review", "doing"):
            wakes.append({"task": tid, "why": "reopened", "from": old_status, "to": new_status})
        elif new_status == "cancelled" and mine(cur):
            wakes.append({"task": tid, "why": "cancelled", "from": old_status, "to": new_status})

def resolve_branch_repo(cur):
    """(branch, repo) cua task; state cu chua luu branch thi doc lai file
    task tren origin/main (ref local, khong can mang)."""
    branch = cur.get("branch", "") or ""
    repo = cur.get("repo", "") or "muse-teamwork"
    if branch:
        return branch, repo
    raw = git("show", f"origin/main:{cur.get('file', '')}") if cur.get("file") else ""
    try:
        t = json.loads(raw) if raw else {}
    except Exception:
        t = {}
    if isinstance(t, dict):
        branch = str(t.get("branch", "") or (t.get("result") or {}).get("branch", "") or "")
        repo = str(t.get("repo", "") or "muse-teamwork")
    return branch, repo

CLONES = {"muse-teamwork": repo,
          "Qsang_vbook": os.path.expanduser("~/workspace/vbook/Qsang_vbook")}

def branch_has_progress(task_repo, branch, claimed_dt):
    """True: branch co commit sau claimed_at (worker da bat dau lam).
    False: khong co commit nao sau claimed_at.
    None: khong kiem chung duoc (khong co branch, fetch loi, repo la) —
    goi ham tra ve None thi giu hanh vi cu (bao)."""
    if not branch or claimed_dt is None:
        return None
    clone = CLONES.get(task_repo or "muse-teamwork")
    if not clone or not os.path.isdir(os.path.join(clone, ".git")):
        return None
    try:
        r = subprocess.run(["git", "-C", clone, "fetch", "origin",
                            f"+{branch}:refs/remotes/origin/{branch}"],
                           capture_output=True, text=True, timeout=30)
        if r.returncode != 0:
            return None
        epoch = int(claimed_dt.timestamp())
        r = subprocess.run(["git", "-C", clone, "log",
                            f"--since=@{epoch}", "--format=%H",
                            f"origin/{branch}"],
                           capture_output=True, text=True, timeout=30)
        if r.returncode != 0:
            return None
        return bool(r.stdout.strip())
    except Exception:
        return None

# --- Watchdog: task "claimed" qua 30 phut khong commit/heartbeat moi ---
# Chi ap dung status "claimed": worker chua co commit dau tien (quy tac
# PROTOCOL §2: phai commit tien do trong 15 phut dau sau claim). Task
# "doing" da co commit dau tien nen khong xet — build dai khong commit
# la binh thuong. Moi claim chi bao 1 lan (danh dau theo claimed_at).
now = datetime.now(timezone.utc)
new_alerted = {}
for tid, cur in snap.items():
    if cur.get("status") != "claimed":
        continue
    claimed_at = cur.get("claimed_at", "")
    claimed = parse_ts(claimed_at)
    if claimed is None:
        continue
    stalled = int((now - claimed).total_seconds() // 60)
    if stalled < WATCHDOG_STALL_MINUTES:
        continue
    # Giu lai danh dau cho claim van con ket (de khong bao lap); claim
    # moi (claimed_at doi) hoac task roi "claimed" thi tu dat lai.
    if alerted.get(tid) == claimed_at:
        new_alerted[tid] = claimed_at
        continue
    # VA 21/11: kiem tra commit tren branch truoc khi ket luan ket —
    # worker cap nhat status tren branch truoc khi dong bo len main.
    # Co commit sau claimed_at => worker da bat dau, khong bao.
    # None (khong kiem chung duoc) => giu hanh vi cu: bao.
    branch, task_repo = resolve_branch_repo(cur)
    if branch_has_progress(task_repo, branch, claimed):
        continue
    if agent != "muse-main" and cur.get("assignee") != agent:
        continue
    wakes.append({"task": tid, "why": "claimed stalled without progress commit",
                  "status": "claimed", "claimed_at": claimed_at,
                  "stalled_minutes": stalled,
                  "assignee": cur.get("assignee", "")})
    new_alerted[tid] = claimed_at

wakes = wakes[:10]

def write_state(tasks, sha):
    if dry:
        return
    os.makedirs(os.path.dirname(state_path) or ".", exist_ok=True)
    with open(state_path, "w", encoding="utf-8") as f:
        json.dump({"tasks": tasks, "sha": sha,
                   "watchdog_alerted": new_alerted}, f,
                  ensure_ascii=False, indent=1)

if mode == "full" and not old:
    write_state(snap, sha_new)
    if wakes:
        # Baseline nhung watchdog van bao task ket that (khong phai wake
        # theo thay doi trang thai — task claimed qua 30 phut la ket that).
        print(json.dumps({"decision": "wake",
                          "reason": "task change needs " + agent,
                          "payload": {"changes": wakes}}, ensure_ascii=False))
    else:
        print(json.dumps({"decision": "silent",
                          "reason": "initialized baseline (first run)" if not dry else "would initialize baseline (dry-run, state not written)",
                          "payload": {"tasks_seen": len(snap)}}, ensure_ascii=False))
    sys.exit(0)

if wakes:
    write_state(snap, sha_new)
    print(json.dumps({"decision": "wake",
                      "reason": "task change needs " + agent,
                      "payload": {"changes": wakes}}, ensure_ascii=False))
    sys.exit(0)

write_state(snap, sha_new)
print(json.dumps({"decision": "silent",
                  "reason": "no relevant task change",
                  "payload": {"tasks_seen": len(snap)}}, ensure_ascii=False))
PYEOF
)" || DECISION='{"decision":"silent","reason":"watch script error, wait for next poll","payload":{}}'

REASON="$(printf '%s' "$DECISION" | jq -r '.reason // "no reason"')"
PAYLOAD="$(printf '%s' "$DECISION" | jq -c '.payload // {}')"
KIND="$(printf '%s' "$DECISION" | jq -r '.decision // "silent"')"

if [[ "$KIND" == "wake" ]]; then
    log "watch: $REASON" "$PAYLOAD"
    wake "$REASON" "$PAYLOAD"
else
    silent "$REASON" "$PAYLOAD"
fi
