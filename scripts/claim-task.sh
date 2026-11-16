#!/bin/bash
# scripts/claim-task.sh — claim 1 task open: đổi status, ghi assignee + hạn 2h.
# Cần: bash + python3 (có sẵn). Chạy trong repo muse-teamwork, rồi git push.
#
# Cách dùng:
#   ./scripts/claim-task.sh <id> <agent-id>
#   ./scripts/claim-task.sh 087-novelnext-retest muse-1
# Trước khi claim, script tự git pull để thấy trạng thái mới nhất.
# Claim xong nhớ tạo branch làm việc trên repo đích (xem PROTOCOL.md §2).
set -euo pipefail
cd "$(dirname "$0")/.."

ID="${1:-}"
AGENT="${2:-}"

if [ -z "$ID" ] || [ -z "$AGENT" ]; then
  echo "Dùng: $0 <id> <agent-id>"
  echo "Ví dụ: $0 087-novelnext-retest muse-1"
  exit 2
fi
case "$AGENT" in
  muse-main|muse-1|muse-2) ;;
  *) echo "agent phải là muse-main, muse-1 hoặc muse-2 (xem agents.yaml)."; exit 2 ;;
esac

FILE="tasks/$ID.json"
if [ ! -f "$FILE" ]; then
  echo "Không có task $ID. Task mở hiện có:"
  grep -l '"status": "open"' tasks/*.json 2>/dev/null | sed 's|tasks/||; s|\.json||' || true
  exit 1
fi

echo "Đang git pull để lấy trạng thái mới nhất..."
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git branch --set-upstream-to="origin/$BRANCH" "$BRANCH" 2>/dev/null || true
git pull --rebase || { echo "git pull lỗi — kiểm tra mạng rồi chạy lại."; exit 1; }

python3 - "$FILE" "$AGENT" <<'EOF'
import json, sys
from datetime import datetime, timezone, timedelta

path, agent = sys.argv[1:3]
task = json.load(open(path, encoding="utf-8"))
if task.get("status") != "open":
    print(f"Task {task['id']} KHÔNG còn open (status={task.get('status')}, assignee={task.get('assignee') or 'trống'}). Chọn task khác, đừng làm trùng.")
    sys.exit(3)
if task.get("assignee"):
    print(f"Task {task['id']} đã có người nhận ({task['assignee']}). Chọn task khác.")
    sys.exit(3)
now = datetime.now(timezone(timedelta(hours=7)))
task["status"] = "claimed"
task["assignee"] = agent
task["claimed_at"] = now.strftime("%Y-%m-%dT%H:%M:%S+07:00")
task["claim_expires_at"] = (now + timedelta(hours=2)).strftime("%Y-%m-%dT%H:%M:%S+07:00")
json.dump(task, open(path, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
open(path, "a", encoding="utf-8").write("\n")
print(f"Claim OK: {task['id']} → {agent}, hết hạn {task['claim_expires_at']} (2h, heartbeat để gia hạn).")
EOF

echo "Đang commit + push..."
git add "$FILE"
git commit -m "claim: $ID -> $AGENT" -q
git push -q
echo "Xong. Tiếp theo: tạo branch trên repo đích rồi làm (xem PROTOCOL.md §2)."
echo "Nhớ heartbeat trong 2h (commit tiến độ hoặc node hub/client.js heartbeat $ID)."
