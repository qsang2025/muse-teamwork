#!/usr/bin/env bash
# muse-teamwork-watchdog.sh — Gate cho watchdog: chi danh thuc agent khi
# co viec watchdog that su can lam, thay cho cron 2 gio/lan.
#
# Cron cu (muse-teamwork-watchdog, 2h/lan) chay agent day du moi luot du
# hau het luot khong co gi moi. Hook nay quet nhe (ls-remote + fetch khi
# SHA doi, nhu watch-tasks.sh) va chi wake khi 1 trong 3 dieu kien xay ra:
#   (b) task claimed/doing het han claim (claim_expires_at da qua) — can
#       sweep tra ve open. Wake ca o lan chay dau (ket that).
#   (d) task moi chuyen sang blocked — can phan loai theo PROTOCOL §10(b).
#   (c) muse-1/muse-2 khong con task mo — can giao 1 task tu hoc §9 (§10a).
# KHONG wake khi task vao review: watch hook (muse-teamwork-watch) da goi
# muse-main cho truong hop do, tranh 2 agent cung merge 1 task.
# Luot quet day du moi ngay 06:46 (cron watchdog) la luoi an toan: bat lech
# STATUS.md, review ton dong, hook chet.
#
# Co che: snapshot task (status, assignee, preferred_assignee, claimed_at,
# claim_expires_at, updated_at) luu o ~/hooks/state/muse-teamwork-watchdog.json.
# Het han: wake 1 lan moi dot het han, wake lai sau 2h neu van het han.
# Blocked moi: so trang thai voi snapshot truoc. Worker ranh: khoa episode
# = task done/cancelled gan nhat cua ban do; wake 1 lan moi episode.
# Lan chay dau (chua co state): ghi baseline, silent (tru het han that).
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

REPO="${1:-$HOME/workspace/muse-teamwork}"
STATE="${2:-$HOME/hooks/state/muse-teamwork-watchdog.json}"
DRY="${HATCH_HOOK_DRY_RUN:-0}"

# Buoc nhe truoc: hoi SHA cua origin/main bang ls-remote (1 request nhe).
# SHA khong doi thi dung snapshot da luu (task het han la viec theo thoi
# gian, khong can commit moi van bat duoc). Chi fetch khi SHA doi.
SHA_NEW="$(timeout 30 git -C "$REPO" ls-remote origin main 2>/dev/null | awk '{print $1}' | head -n 1 || true)"
if [[ -z "$SHA_NEW" ]]; then
    log "git ls-remote origin main loi" '{}'
    silent "khong hoi duoc SHA, cho lan quet sau"
fi
OLD_SHA="$(jq -r '.sha // empty' "$STATE" 2>/dev/null || true)"
if [[ -n "$OLD_SHA" && "$OLD_SHA" == "$SHA_NEW" ]]; then
    MODE="cached"
else
    MODE="full"
    if ! timeout 60 git -C "$REPO" fetch origin main --quiet 2>/dev/null; then
        log "git fetch origin main loi" '{}'
        silent "khong fetch duoc repo, cho lan quet sau"
    fi
fi

# Doc snapshot (tu origin/main neu MODE=full, tu state da luu neu
# MODE=cached) bang python3, danh gia 3 dieu kien, in quyet dinh JSON.
DECISION="$(python3 - "$REPO" "$STATE" "$DRY" "$SHA_NEW" "$MODE" <<'PYEOF'
import json, os, subprocess, sys
from datetime import datetime, timezone, timedelta

repo, state_path, dry = sys.argv[1], sys.argv[2], sys.argv[3] == "1"
sha_new = sys.argv[4] if len(sys.argv) > 4 else ""
mode = sys.argv[5] if len(sys.argv) > 5 else "full"

REWAKE_SECS = 7200
OPEN_STATUSES = ("open", "claimed", "doing", "review")
WORKERS = ("muse-1", "muse-2")

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
        return {}, {}, {}, ""
    return (st.get("tasks", {}) or {},
            st.get("expired_alerted", {}) or {},
            st.get("idle_alerted", {}) or {},
            st.get("sha", "") or "")

old, expired_alerted, idle_alerted, _old_sha = load_state()

if mode == "full":
    files = []
    out = git("ls-tree", "-r", "--name-only", "origin/main", "tasks/")
    for line in out.splitlines():
        line = line.strip()
        if not line.startswith("tasks/") or not line.endswith(".json"):
            continue
        name = os.path.basename(line)
        if name in ("_template.json", "000-template.json"):
            continue
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
            "claim_expires_at": str(t.get("claim_expires_at", "") or ""),
            "updated_at": str(t.get("updated_at", "") or ""),
        }
else:
    snap = old

now = datetime.now(timezone.utc)
wakes = []
new_expired_alerted = dict(expired_alerted)
new_idle_alerted = dict(idle_alerted)

# --- (b) Task claimed/doing het han claim ---
for tid, cur in snap.items():
    if cur.get("status") not in ("claimed", "doing"):
        continue
    exp = parse_ts(cur.get("claim_expires_at", ""))
    if exp is None or now <= exp:
        continue
    prev = expired_alerted.get(tid, {})
    prev_at = parse_ts(prev.get("at", "")) if isinstance(prev, dict) else None
    if prev.get("expires_at") == cur.get("claim_expires_at") and prev_at is not None \
            and (now - prev_at).total_seconds() <= REWAKE_SECS:
        new_expired_alerted[tid] = prev
        continue
    wakes.append({"task": tid, "why": "claim expired, needs sweep to open",
                  "status": cur["status"],
                  "claim_expires_at": cur.get("claim_expires_at", ""),
                  "assignee": cur.get("assignee", "")})
    new_expired_alerted[tid] = {"expires_at": cur.get("claim_expires_at", ""),
                                "at": now.isoformat().replace("+00:00", "Z")}
# Don muc het han: chi giu task van het han.
new_expired_alerted = {tid: rec for tid, rec in new_expired_alerted.items()
                       if tid in snap and snap[tid].get("status") in ("claimed", "doing")
                       and parse_ts(snap[tid].get("claim_expires_at", "")) is not None
                       and now > parse_ts(snap[tid].get("claim_expires_at", ""))}

# --- (d) Task moi chuyen sang blocked (chi khi co snapshot cu) ---
if mode == "full" and old:
    for tid, cur in snap.items():
        if cur["status"] != "blocked":
            continue
        prev = old.get(tid)
        if prev is None or prev.get("status") != "blocked":
            wakes.append({"task": tid, "why": "newly blocked, needs classification",
                          "status": "blocked",
                          "from": (prev or {}).get("status", "")})

# --- (c) Worker khong con task mo -> can giao task tu hoc §9 ---
# Sua F-3 (QA 157): "ranh" phai tinh ca viec claimable + task blocked.
# - Task open chua gan ai (khong assignee/preferred_assignee) la viec ma
#   worker claim duoc theo luat poll -> khong coi la ranh.
# - Agent dang co task blocked trong cung luot -> bo qua idle-wake (task
#   blocked can phan loai §10(b) truoc, tranh giao task hoc chong len).
for agent in WORKERS:
    busy = any(cur["status"] in OPEN_STATUSES and
               (cur.get("assignee") == agent or cur.get("preferred_assignee") == agent)
               for cur in snap.values())
    claimable = any(cur["status"] == "open" and
                    not cur.get("assignee") and not cur.get("preferred_assignee")
                    for cur in snap.values())
    has_blocked = any(cur["status"] == "blocked" and
                      (cur.get("assignee") == agent or cur.get("preferred_assignee") == agent)
                      for cur in snap.values())
    if busy or claimable or has_blocked:
        continue
    # Episode key: task done/cancelled gan nhat cua ban do (theo updated_at).
    done = [(parse_ts(c.get("updated_at", "")) or datetime.min.replace(tzinfo=timezone.utc), tid)
            for tid, c in snap.items()
            if c["status"] in ("done", "cancelled") and
            (c.get("assignee") == agent or c.get("preferred_assignee") == agent)]
    done.sort(key=lambda x: x[0])
    episode = done[-1][1] if done else "none"
    if idle_alerted.get(agent) == episode:
        new_idle_alerted[agent] = episode
        continue
    wakes.append({"agent": agent, "why": "idle, no open task — needs self-learning task",
                  "last_done_task": episode})
    new_idle_alerted[agent] = episode

wakes = wakes[:10]

def write_state():
    if dry:
        return
    os.makedirs(os.path.dirname(state_path) or ".", exist_ok=True)
    with open(state_path, "w", encoding="utf-8") as f:
        json.dump({"tasks": snap, "sha": sha_new,
                   "expired_alerted": new_expired_alerted,
                   "idle_alerted": new_idle_alerted}, f,
                  ensure_ascii=False, indent=1)

if mode == "full" and not old:
    write_state()
    expired_now = [w for w in wakes if w.get("why", "").startswith("claim expired")]
    if expired_now:
        print(json.dumps({"decision": "wake",
                          "reason": "task het han claim can sweep ngay",
                          "payload": {"changes": expired_now}}, ensure_ascii=False))
    else:
        print(json.dumps({"decision": "silent",
                          "reason": "initialized baseline (first run)" if not dry else "would initialize baseline (dry-run, state not written)",
                          "payload": {"tasks_seen": len(snap)}}, ensure_ascii=False))
    sys.exit(0)

if wakes:
    write_state()
    print(json.dumps({"decision": "wake",
                      "reason": "watchdog work needed: " +
                                "; ".join(w.get("why", "") + " " +
                                          (w.get("task") or w.get("agent", ""))
                                          for w in wakes),
                      "payload": {"changes": wakes}}, ensure_ascii=False))
    sys.exit(0)

write_state()
print(json.dumps({"decision": "silent",
                  "reason": "no watchdog work (no expired claim, no new blocked, no idle worker)",
                  "payload": {"tasks_seen": len(snap)}}, ensure_ascii=False))
PYEOF
)" || DECISION='{"decision":"silent","reason":"watchdog gate loi, cho lan quet sau","payload":{}}'

REASON="$(printf '%s' "$DECISION" | jq -r '.reason // "no reason"')"
PAYLOAD="$(printf '%s' "$DECISION" | jq -c '.payload // {}')"
KIND="$(printf '%s' "$DECISION" | jq -r '.decision // "silent"')"

if [[ "$KIND" == "wake" ]]; then
    log "watchdog: $REASON" "$PAYLOAD"
    wake "$REASON" "$PAYLOAD"
else
    silent "$REASON" "$PAYLOAD"
fi
