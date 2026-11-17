#!/bin/bash
# scripts/heartbeat-task.sh — gia hạn thêm 2h cho task đang thực hiện trên GitHub.
# Cần: bash + python3 (có sẵn). Chạy trong repo muse-teamwork.
#
# Cách dùng:
#   ./scripts/heartbeat-task.sh <id> <agent-id> [tiến-độ-ngắn]
#   ./scripts/heartbeat-task.sh 087-novelnext-retest muse-1 "Đang debug selector chương 1"
# Chỉ đúng assignee của task mới được heartbeat. Task chuyển sang doing,
# claim_expires_at gia hạn thêm 2h, ghi chú tiến độ (nếu có) kèm giờ vào notes.
#
# Vá F-05 (P1, review qsang2027): kênh GitHub-only không có daemon ngầm — worker
# tự gia hạn bằng script này thay vì sửa tay file JSON.
#
# Chống "toxic unpushed commit" (vá P0, theo claim-task.sh): push lỗi thì
# rollback commit local ngay (git reset --hard HEAD~1) để không để lại commit
# rác — file task trở về đúng trạng thái trước khi chạy script.
set -euo pipefail
cd "$(dirname "$0")/.."

ID="${1:-}"
AGENT="${2:-}"
NOTE="${3:-}"

if [ -z "$ID" ] || [ -z "$AGENT" ]; then
  echo "Dùng: $0 <id-task> <agent-name> [tiến-độ-ngắn]"
  echo 'Ví dụ: $0 087-novelnext-retest muse-1 "Đang debug selector chương 1"'
  exit 2
fi

FILE="tasks/${ID}.json"
if [ ! -f "$FILE" ]; then
  echo "Không tìm thấy: $FILE"
  exit 1
fi

echo "Đang đồng bộ repo trước khi heartbeat..."
git pull --rebase --autostash || { echo "git pull lỗi — kiểm tra mạng rồi chạy lại, chưa sửa task nào."; exit 1; }

# Lưu bản sao nội dung gốc để khôi phục nếu commit/push lỗi (phòng khi
# reset --hard không đủ — vd working tree có thay đổi khác trước khi chạy
# script). Dùng file tạm thay vì biến shell để giữ nguyên từng byte
# (kể cả ký tự xuống dòng cuối file).
BACKUP="$(mktemp)"
cp "$FILE" "$BACKUP"
trap 'rm -f "$BACKUP"' EXIT

set +e
python3 - "$FILE" "$AGENT" "$NOTE" <<'EOF'
import json, sys
from datetime import datetime, timezone, timedelta

path, agent, note = sys.argv[1:4]
with open(path, "r", encoding="utf-8") as f:
    task = json.load(f)
if task.get("assignee") != agent:
    print(f"LỖI: Task này thuộc quyền của '{task.get('assignee')}', bạn là '{agent}'.")
    sys.exit(1)
if task.get("status") not in ("claimed", "doing"):
    print(f"LỖI: Task không ở trạng thái claimed/doing (status={task.get('status')}) — không heartbeat được.")
    sys.exit(1)
now = datetime.now(timezone(timedelta(hours=7)))
task["status"] = "doing"
task["claim_expires_at"] = (now + timedelta(hours=2)).strftime("%Y-%m-%dT%H:%M:%S+07:00")
if note:
    stamp = now.strftime("%H:%M")
    task["notes"] = ((task.get("notes") or "") + f" [{stamp} {agent}: {note}]").strip()
with open(path, "w", encoding="utf-8") as f:
    json.dump(task, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"Heartbeat OK: {task['id']} gia hạn đến {task['claim_expires_at']}.")
EOF
PY_RC=$?
set -e

if [ "$PY_RC" -ne 0 ]; then
  echo "Heartbeat không thành công (xem thông báo trên). Hoàn tác thay đổi rồi dừng."
  cp "$BACKUP" "$FILE"
  exit 1
fi

git add "$FILE"
git commit -m "heartbeat: $ID by $AGENT" -q || {
  echo "Commit lỗi — hoàn tác thay đổi rồi dừng."
  cp "$BACKUP" "$FILE"
  exit 1
}

if git push -q; then
  echo "Đã cập nhật heartbeat lên GitHub thành công."
  exit 0
fi

# Push lỗi: rollback commit local ngay để không để lại commit rác (F-01),
# rồi khôi phục nội dung file task về trước khi chạy script.
echo "Push bị từ chối (có thể agent khác đã push trước, hoặc lỗi mạng). Rollback commit local..."
git reset --hard HEAD~1 -q || {
  echo "CẢNH BÁO: rollback commit local THẤT BẠI — kiểm tra bằng tay: git log --oneline -3 và git status."
  exit 1
}
cp "$BACKUP" "$FILE"
echo "Đã rollback. Heartbeat chưa ghi lên GitHub — chạy lại sau khi git pull."
exit 1
