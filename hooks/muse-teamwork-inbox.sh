#!/usr/bin/env bash
# muse-teamwork-inbox.sh — Gate cho inbox dashboard: chi danh thuc agent
# khi co GitHub issue [dashboard] mo moi chua ap dung.
#
# Thay cho cron muse-teamwork-dashboard-inbox 15 phut/lan (da xoa 21/11):
# cron cu chay agent day du moi 15 phut (96 luot/ngay) du hau het luot
# khong co issue nao. Hook nay quet nhe bang API GitHub public (khong can
# auth, repo public; 5 phut/lan = 12 req/h, duoi han 60 req/h) va chi goi
# agent day khi co issue moi.
#
# Co che: doc issue mo -> loc tieu de bat dau "[dashboard]" (khong phai PR)
# -> so voi state ~/hooks/state/muse-teamwork-inbox.json (last_wake theo
# so issue). Chi wake khi co issue chua tung wake, hoac da wake hon 2h
# truoc (lan xu ly truoc co the loi, issue van mo). Issue da dong thi xoa
# khoi state de mo lai sau nay van wake duoc.
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

REPO="qsang2025/muse-teamwork"
STATE="$HOME/hooks/state/muse-teamwork-inbox.json"
DRY="${HATCH_HOOK_DRY_RUN:-0}"
REWAKE_SECS=7200

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
# Dung gh api (co auth qsang2025, han 5000 req/h) thay cho curl khong auth:
# API public khong auth chi co 60 req/h chung cho ca IP egress cua proxy
# (104.29.194.191) — da bi 403 rate-limit ngay 21/11. gh chay duoc trong
# hook vi token nam o ~/.config/gh/hosts.yml (doc tu file, khong can secret
# truyen qua env). Neu gh loi: log + silent (khong ket luan duoc thi im lang).
if ! gh api "repos/$REPO/issues?state=open&per_page=100" > "$TMP" 2>/dev/null; then
    log "gh api issues loi hoac timeout" '{}'
    silent "khong doc duoc issue, cho lan quet sau"
fi

DECISION="$(python3 - "$TMP" "$STATE" "$DRY" "$REWAKE_SECS" <<'PYEOF'
import json, sys
from datetime import datetime, timezone, timedelta

issues_path, state_path, dry = sys.argv[1], sys.argv[2], sys.argv[3] == "1"
rewake_secs = int(sys.argv[4]) if len(sys.argv) > 4 else 7200

try:
    issues = json.load(open(issues_path, encoding="utf-8"))
except Exception as e:
    print(json.dumps({"decision": "silent",
                      "reason": f"khong doc duoc JSON issue ({e})",
                      "payload": {}}, ensure_ascii=False))
    sys.exit(0)

open_nums = []
for i in issues or []:
    if not isinstance(i, dict):
        continue
    if "pull_request" in i:
        continue
    title = (i.get("title") or "").strip().lower()
    if title.startswith("[dashboard]"):
        try:
            open_nums.append(int(i.get("number")))
        except (TypeError, ValueError):
            continue

try:
    state = json.load(open(state_path, encoding="utf-8"))
except Exception:
    state = {}
last_wake = state.get("last_wake", {}) or {}
now = datetime.now(timezone.utc)

def parse_ts(s):
    try:
        dt = datetime.fromisoformat(str(s).replace("Z", "+00:00"))
    except ValueError:
        return None
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt

new_issues = []
for n in open_nums:
    prev = parse_ts(last_wake.get(str(n), ""))
    if prev is None or (now - prev).total_seconds() > rewake_secs:
        new_issues.append(n)

# Don state: chi giu issue van mo.
kept = {str(n): last_wake[str(n)] for n in open_nums if str(n) in last_wake}

def write_state():
    if dry:
        return
    import os
    os.makedirs(os.path.dirname(state_path) or ".", exist_ok=True)
    with open(state_path, "w", encoding="utf-8") as f:
        json.dump({"last_wake": kept}, f, ensure_ascii=False, indent=1)

if new_issues:
    for n in new_issues:
        kept[str(n)] = now.isoformat().replace("+00:00", "Z")
    write_state()
    print(json.dumps({"decision": "wake",
                      "reason": "co issue [dashboard] moi chua ap dung: " +
                                ", ".join(f"#{n}" for n in new_issues),
                      "payload": {"issues": new_issues}}, ensure_ascii=False))
    sys.exit(0)

write_state()
print(json.dumps({"decision": "silent",
                  "reason": "khong co issue [dashboard] moi",
                  "payload": {"open_dashboard_issues": open_nums}},
                 ensure_ascii=False))
PYEOF
)" || DECISION='{"decision":"silent","reason":"inbox gate loi, cho lan quet sau","payload":{}}'

REASON="$(printf '%s' "$DECISION" | jq -r '.reason // "no reason"')"
PAYLOAD="$(printf '%s' "$DECISION" | jq -c '.payload // {}')"
KIND="$(printf '%s' "$DECISION" | jq -r '.decision // "silent"')"

if [[ "$KIND" == "wake" ]]; then
    log "inbox: $REASON" "$PAYLOAD"
    wake "$REASON" "$PAYLOAD"
else
    silent "$REASON" "$PAYLOAD"
fi
