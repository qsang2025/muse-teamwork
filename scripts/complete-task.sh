#!/bin/bash
# scripts/complete-task.sh — chuyển task sang review để muse-main kiểm định.
# Cần: bash + python3 (có sẵn). Chạy trong repo muse-teamwork.
#
# Cách dùng:
#   ./scripts/complete-task.sh <id> <agent-id> <branch> [ghi-chú] [--validate X] [--device-test X] [--install X] [--evidence TEXT]
#   ./scripts/complete-task.sh 087-novelnext-retest muse-1 feature/novelnext "Đã test ch.1 đọc mượt" --validate PASS --device-test 0 --install 200 --evidence "validate log commit abc1234, device test log 2026-11-21"
# Chỉ đúng assignee của task mới được complete. Task chuyển sang review,
# result.branch + result.notes được ghi; các cờ --validate/--device-test/
# --install (nếu có) được merge vào result.test mà KHÔNG làm rơi các trường
# test đã có (merge nông 1 cấp, giống hub/server.js).
#
# Gate bằng chứng (PROTOCOL §11.2, Kerr/Muse Next — Anh duyệt 21/11):
# --evidence là BẮT BUỘC. Task vbook-extension phải đủ cả 3 trường test +
# evidence; task research thì evidence phải trỏ tới file research/<id>-....md;
# các loại khác cũng phải có evidence (commit SHA / log / file). Thiếu thì
# script từ chối, task ở nguyên trạng thái cũ — "nói xong" không tính là xong.
#
# Vá F-05 (P1, review qsang2027): kênh GitHub-only không có daemon ngầm — worker
# nộp task bằng script này thay vì sửa tay file JSON.
#
# Chống "toxic unpushed commit" (vá P0, theo claim-task.sh): push lỗi thì
# rollback commit local ngay (git reset --hard HEAD~1) để không để lại commit
# rác — file task trở về đúng trạng thái trước khi chạy script.
set -euo pipefail
cd "$(dirname "$0")/.."

ID="${1:-}"
AGENT="${2:-}"
BRANCH="${3:-}"

if [ -z "$ID" ] || [ -z "$AGENT" ] || [ -z "$BRANCH" ]; then
  echo "Dùng: $0 <id-task> <agent-name> <branch-name> [kết-quả-ghi-chú] [--validate X] [--device-test X] [--install X] [--evidence TEXT]"
  echo 'Ví dụ: $0 087-novelnext-retest muse-1 feature/novelnext "Đã test ch.1 đọc mượt" --validate PASS --device-test 0 --install 200 --evidence "validate log commit abc1234"'
  exit 2
fi

# Tham số còn lại: tham số vị trí thứ 4 (nếu có, không bắt đầu bằng --) là
# NOTES; phần còn lại là các cờ --validate/--device-test/--install/--evidence.
shift 3
NOTES=""
VALIDATE=""
DEVICE_TEST=""
INSTALL=""
EVIDENCE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --validate) VALIDATE="${2:-}"; shift 2 ;;
    --device-test) DEVICE_TEST="${2:-}"; shift 2 ;;
    --install) INSTALL="${2:-}"; shift 2 ;;
    --evidence) EVIDENCE="${2:-}"; shift 2 ;;
    --*) echo "Cờ không rõ: $1 (chỉ nhận --validate, --device-test, --install, --evidence)."; exit 2 ;;
    *) if [ -z "$NOTES" ]; then NOTES="$1"; shift; else echo "Tham số thừa: $1."; exit 2; fi ;;
  esac
done

if [ -z "$ID" ] || [ -z "$AGENT" ] || [ -z "$BRANCH" ]; then
  echo "Dùng: $0 <id-task> <agent-name> <branch-name> [kết-quả-ghi-chú] [--validate X] [--device-test X] [--install X] [--evidence TEXT]"
  echo 'Ví dụ: $0 087-novelnext-retest muse-1 feature/novelnext "Đã test ch.1 đọc mượt" --validate PASS --device-test 0 --install 200 --evidence "validate log commit abc1234"'
  exit 2
fi

FILE="tasks/${ID}.json"
if [ ! -f "$FILE" ]; then
  echo "Không tìm thấy: $FILE"
  exit 1
fi

echo "Đang đồng bộ repo trước khi nộp task..."
git pull --rebase --autostash || { echo "git pull lỗi — kiểm tra mạng rồi chạy lại, chưa sửa task nào."; exit 1; }

# Lưu bản sao nội dung gốc để khôi phục nếu commit/push lỗi (phòng khi
# reset --hard không đủ — vd working tree có thay đổi khác trước khi chạy
# script). Dùng file tạm thay vì biến shell để giữ nguyên từng byte
# (kể cả ký tự xuống dòng cuối file).
BACKUP="$(mktemp)"
cp "$FILE" "$BACKUP"
trap 'rm -f "$BACKUP"' EXIT

set +e
python3 - "$FILE" "$AGENT" "$BRANCH" "$NOTES" "$VALIDATE" "$DEVICE_TEST" "$INSTALL" "$EVIDENCE" <<'EOF'
import json, sys
from datetime import datetime, timezone, timedelta

path, agent, branch, notes, validate, device_test, install, evidence = sys.argv[1:9]
with open(path, "r", encoding="utf-8") as f:
    task = json.load(f)
if task.get("assignee") != agent:
    print(f"LỖI: Task này thuộc quyền của '{task.get('assignee')}', bạn là '{agent}'.")
    sys.exit(1)
if task.get("status") not in ("claimed", "doing"):
    print(f"LỖI: Task không ở trạng thái claimed/doing (status={task.get('status')}) — không nộp được.")
    sys.exit(1)
now = datetime.now(timezone(timedelta(hours=7)))
# Gate bằng chứng (PROTOCOL §11.2): "nói xong" không tính là xong.
# Evidence có thể truyền qua --evidence, hoặc đã có sẵn trong file task.
result0 = task.get("result") or {}
test0 = dict((result0.get("test") or {}))
ev = evidence or test0.get("evidence", "") or result0.get("evidence", "")
typ = task.get("type", "")
if typ == "vbook-extension":
    test_merged = dict(test0)
    if validate:
        test_merged["validate"] = validate
    if device_test:
        test_merged["device_test"] = device_test
    if install:
        test_merged["install"] = install
    missing = [k for k in ("validate", "device_test", "install") if not test_merged.get(k)]
    if missing:
        print(f"LỖI (PROTOCOL §11.2): task vbook-extension thiếu trường test: {', '.join(missing)} — nộp lại khi đủ cả 3 (validate/device_test/install).")
        sys.exit(1)
    if not ev:
        print("LỖI (PROTOCOL §11.2): thiếu --evidence (commit SHA / log test / file) — nộp lại kèm bằng chứng.")
        sys.exit(1)
elif typ == "research":
    if not ev or "research/" not in ev:
        print("LỖI (PROTOCOL §11.2): task research cần --evidence trỏ tới file research/<id>-....md (vd: --evidence \"research/191-mcp-course-hugging-face.md\").")
        sys.exit(1)
else:
    if not ev:
        print("LỖI (PROTOCOL §11.2): thiếu --evidence (commit SHA / log / file) — nộp lại kèm bằng chứng.")
        sys.exit(1)
task["status"] = "review"
result = task.get("result") or {}
result["branch"] = branch
result["evidence"] = ev
if notes:
    result["notes"] = notes
# Merge nông 1 cấp cho test: chỉ ghi đè trường được truyền, giữ các trường đã có.
test = dict((result.get("test") or {}))
if validate:
    test["validate"] = validate
if device_test:
    test["device_test"] = device_test
if install:
    test["install"] = install
test["evidence"] = ev
result["test"] = test
task["result"] = result
with open(path, "w", encoding="utf-8") as f:
    json.dump(task, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"Hoàn thành task: {task['id']} đã chuyển sang 'review'.")
EOF
PY_RC=$?
set -e

if [ "$PY_RC" -ne 0 ]; then
  echo "Nộp task không thành công (xem thông báo trên). Hoàn tác thay đổi rồi dừng."
  cp "$BACKUP" "$FILE"
  exit 1
fi

git add "$FILE"
git commit -m "review: $ID completed by $AGENT" -q || {
  echo "Commit lỗi — hoàn tác thay đổi rồi dừng."
  cp "$BACKUP" "$FILE"
  exit 1
}

if git push -q; then
  echo "Đã nộp task $ID lên GitHub để muse-main review và merge."
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
echo "Đã rollback. Task vẫn ở trạng thái cũ trên GitHub — chạy lại sau khi git pull."
exit 1
