#!/bin/bash
# scripts/new-task.sh — tạo task mới (file tasks/<id>.json), không cần cài thêm.
# Cần: bash + python3 (có sẵn). Chạy trong repo muse-teamwork, rồi git push.
#
# Cách dùng:
#   ./scripts/new-task.sh "Tiêu đề task" [type] [priority] [repo]
#   ./scripts/new-task.sh "Build extension truyentranh.net" vbook-extension high Qsang_vbook
# Mặc định: type=vbook-extension, priority=medium, repo=Qsang_vbook.
# ID tự sinh: số tiếp theo sau task lớn nhất hiện có (vd 089, 090...) + slug từ tiêu đề.
set -euo pipefail
cd "$(dirname "$0")/.."

TITLE="${1:-}"
TYPE="${2:-vbook-extension}"
PRIORITY="${3:-medium}"
REPO="${4:-Qsang_vbook}"

if [ -z "$TITLE" ]; then
  echo "Dùng: $0 \"Tiêu đề task\" [type] [priority] [repo]"
  echo "Ví dụ: $0 \"Build extension truyentranh.net\" vbook-extension high Qsang_vbook"
  exit 2
fi

ID=$(python3 - "$TITLE" "$TYPE" "$PRIORITY" "$REPO" <<'EOF'
import json, glob, os, re, sys, unicodedata
from datetime import datetime, timezone, timedelta

title, typ, prio, repo = sys.argv[1:5]
# Số tiếp theo: quét tasks/*.json (bỏ _template), lấy số đầu id lớn nhất.
nums = []
for f in glob.glob("tasks/*.json"):
    base = os.path.basename(f)[:-5]
    if base == "_template":
        continue
    m = re.match(r"(\d+)", base)
    if m:
        nums.append(int(m.group(1)))
n = (max(nums) + 1) if nums else 1
# Slug: bỏ dấu tiếng Việt (đ→d, í→i...) rồi mới thay ký tự lạ bằng "-".
ascii_title = title.replace("đ", "d").replace("Đ", "D")
ascii_title = "".join(c for c in unicodedata.normalize("NFD", ascii_title)
                      if unicodedata.category(c) != "Mn")
slug = re.sub(r"[^a-z0-9]+", "-", ascii_title.lower()).strip("-")[:40] or "task"
task_id = f"{n:03d}-{slug}"

now = datetime.now(timezone(timedelta(hours=7))).strftime("%Y-%m-%dT%H:%M:%S+07:00")
task = {
    "id": task_id,
    "title": title,
    "type": typ,
    "repo": repo,
    "branch": "",
    "assignee": "",
    "priority": prio,
    "status": "open",
    "created_by": "muse-main",
    "created_at": now,
    "claimed_at": "",
    "claim_expires_at": "",
    "result": {"branch": "", "test": {"validate": "", "device_test": "", "install": ""}, "notes": ""},
    "checklist": [
        "Quét repo đích + tasks/open + ROADMAP (chống trùng)",
        "Claim task (script claim-task.sh) + tạo branch",
        "Build / khảo sát xong, test đầy đủ",
        "Push branch, cập nhật task sang review",
        "muse-main kiểm tra + merge, task sang done",
    ],
    "notes": "",
}
with open(f"tasks/{task_id}.json", "w", encoding="utf-8") as fh:
    json.dump(task, fh, indent=2, ensure_ascii=False)
    fh.write("\n")
print(task_id)
EOF
)

python3 -m json.tool "tasks/$ID.json" > /dev/null
echo "Đã tạo tasks/$ID.json (status open, chưa gán)."
echo "Tiếp theo: git add tasks/$ID.json && git commit -m \"task: $TITLE\" && git push"
echo "Rồi báo muse-1/muse-2 pull repo để claim."
