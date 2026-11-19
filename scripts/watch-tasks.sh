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
# Lan chay dau (chua co state): ghi baseline, silent, khong danh thuc.
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
# chac chan khong co gi doi — bo qua fetch, im lang luon. Chi fetch khi SHA
# doi (hoac chua co SHA luu). Giam ~90% luong fetch.
SHA_NEW="$(timeout 30 git -C "$REPO" ls-remote origin main 2>/dev/null | awk '{print $1}' | head -n 1 || true)"
if [[ -z "$SHA_NEW" ]]; then
    log "git ls-remote origin main loi" '{}'
    silent "khong hoi duoc SHA, cho lan quet sau"
fi
OLD_SHA="$(jq -r '.sha // empty' "$STATE" 2>/dev/null || true)"
if [[ -n "$OLD_SHA" && "$OLD_SHA" == "$SHA_NEW" ]]; then
    silent "khong co thay doi (sha khong doi, bo qua fetch)" "{\"sha\":\"$SHA_NEW\"}"
fi

if ! timeout 60 git -C "$REPO" fetch origin main --quiet 2>/dev/null; then
    log "git fetch origin main loi" '{}'
    silent "khong fetch duoc repo, cho lan quet sau"
fi

# Doc snapshot tu origin/main bang python3 (1 tien trinh duy nhat), so sanh
# voi state, in ra quyet dinh JSON: {"decision":..., "reason":..., "payload":...}
DECISION="$(python3 - "$REPO" "$STATE" "$AGENT" "$DRY" "$SHA_NEW" <<'PYEOF'
import json, os, subprocess, sys

repo, state_path, agent, dry = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] == "1"
sha_new = sys.argv[5] if len(sys.argv) > 5 else ""

def git(*args):
    r = subprocess.run(["git", "-C", repo] + list(args),
                       capture_output=True, text=True, timeout=30)
    return r.stdout if r.returncode == 0 else ""

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
        "file": path,
    }

old = {}
if os.path.exists(state_path):
    try:
        old = json.load(open(state_path, encoding="utf-8")).get("tasks", {})
    except Exception:
        old = {}

wakes = []

def mine(t):
    return t.get("assignee") == agent or t.get("preferred_assignee") == agent

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

wakes = wakes[:10]

if not old:
    if not dry:
        os.makedirs(os.path.dirname(state_path) or ".", exist_ok=True)
        with open(state_path, "w", encoding="utf-8") as f:
            json.dump({"tasks": snap, "sha": sha_new}, f, ensure_ascii=False, indent=1)
    print(json.dumps({"decision": "silent",
                      "reason": "initialized baseline (first run)" if not dry else "would initialize baseline (dry-run, state not written)",
                      "payload": {"tasks_seen": len(snap)}}, ensure_ascii=False))
    sys.exit(0)

if wakes:
    if not dry:
        os.makedirs(os.path.dirname(state_path) or ".", exist_ok=True)
        with open(state_path, "w", encoding="utf-8") as f:
            json.dump({"tasks": snap, "sha": sha_new}, f, ensure_ascii=False, indent=1)
    print(json.dumps({"decision": "wake",
                      "reason": "task change needs " + agent,
                      "payload": {"changes": wakes}}, ensure_ascii=False))
    sys.exit(0)

if not dry:
    os.makedirs(os.path.dirname(state_path) or ".", exist_ok=True)
    with open(state_path, "w", encoding="utf-8") as f:
        json.dump({"tasks": snap, "sha": sha_new}, f, ensure_ascii=False, indent=1)
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
