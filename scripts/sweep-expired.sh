#!/bin/bash
# scripts/sweep-expired.sh — quét và thu hồi task claimed/doing quá hạn 2h về open.
# Cần: bash + python3 (có sẵn). Chạy trong repo muse-teamwork.
#
# Cách dùng:
#   ./scripts/sweep-expired.sh
# Không cần tham số. Script tự git pull, quét tasks/*.json và tasks/*/*.json
# (cả thư mục con sau sharding P2.2), thu hồi task nào hết hạn claim, rồi
# commit + push. Không có task hết hạn thì không commit gì.
#
# Vá F-05 (P1, review qsang2027): kênh GitHub-only không có daemon ngầm, worker
# crash sau khi claim sẽ làm task "chết lâm sàng" vô thời hạn — script này là
# cách dọn thủ công thay cho daemon.
#
# Chống "toxic unpushed commit" (vá P0, theo claim-task.sh): push lỗi thì
# rollback commit local ngay (git reset --hard HEAD~1) để không để lại commit
# rác — file task trở về đúng trạng thái trước khi chạy script.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "Đang đồng bộ repo trước khi quét task quá hạn..."
git pull --rebase --autostash || { echo "git pull lỗi — kiểm tra mạng rồi chạy lại, chưa sửa task nào."; exit 1; }

# python trả 10 = có task đã thu hồi; trả 0 = không có task hết hạn.
# set -e sẽ giết script khi python trả khác 0, nên tắt tạm để lấy mã trả về.
set +e
python3 - <<'EOF'
import glob, json, os, sys
from datetime import datetime, timezone, timedelta

now = datetime.now(timezone(timedelta(hours=7)))
modified = []
for f in sorted(glob.glob("tasks/**/*.json", recursive=True)):
    if os.path.basename(f) in ("_template.json", "000-template.json"):
        continue
    try:
        with open(f, "r", encoding="utf-8") as fh:
            t = json.load(fh)
    except Exception:
        continue
    status = t.get("status")
    exp_str = t.get("claim_expires_at")
    if status in ("claimed", "doing") and exp_str:
        try:
            exp_dt = datetime.fromisoformat(exp_str)
            if now > exp_dt:
                old_assignee = t.get("assignee") or "?"
                t["status"] = "open"
                t["assignee"] = ""
                t["claimed_at"] = ""
                t["claim_expires_at"] = ""
                note = f"[sweep {now.strftime('%d/%m %H:%M')}: hết hạn 2h từ {old_assignee}, tự động trả về open]"
                t["notes"] = ((t.get("notes") or "") + " " + note).strip()
                with open(f, "w", encoding="utf-8") as fh:
                    json.dump(t, fh, indent=2, ensure_ascii=False)
                    fh.write("\n")
                modified.append(t["id"])
                print(f"Thu hồi task quá hạn: {t['id']} (từ {old_assignee})")
        except Exception as e:
            print(f"Lỗi đọc hạn task {f}: {e}")
if modified:
    sys.exit(10)
EOF
PY_STATUS=$?
set -e

if [ "$PY_STATUS" -eq 10 ]; then
  git add tasks/
  git commit -m "chore(tasks): sweep expired claims back to open" -q || {
    echo "Commit lỗi — hoàn tác thay đổi rồi dừng."
    git checkout -- tasks/ 2>/dev/null || true
    exit 1
  }
  if git push -q; then
    echo "Đã thu hồi task quá hạn và đẩy cập nhật lên GitHub."
    exit 0
  fi
  # Push lỗi: rollback commit local ngay để không để lại commit rác
  # (chính là lỗi toxic commit F-01). reset --hard trả file task về
  # đúng trạng thái trước khi chạy script.
  echo "Push bị từ chối (có thể agent khác đã push trước, hoặc lỗi mạng). Rollback commit local..."
  git reset --hard HEAD~1 -q || {
    echo "CẢNH BÁO: rollback commit local THẤT BẠI — kiểm tra bằng tay: git log --oneline -3 và git status."
    exit 1
  }
  echo "Đã rollback. Task vẫn ở trạng thái cũ trên GitHub — chạy lại sweep sau khi git pull."
  exit 1
else
  echo "Không có task nào hết hạn."
fi
