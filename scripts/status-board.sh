#!/bin/bash
# scripts/status-board.sh — Hiển thị bảng theo dõi trạng thái công việc thời gian thực.
#
# P2.1 (theo review độc lập Antigravity qsang2027, §4.3): xem toàn bộ tiến
# độ trong một màn hình console, không cần mở từng file JSON.
#
# Cách dùng:
#   ./scripts/status-board.sh            # tất cả task, mọi status
#   ./scripts/status-board.sh --status open
#   ./scripts/status-board.sh --status claimed
# Đọc cả tasks/*.json và tasks/*/*.json (1 tầng con sau sharding P2.2:
# tasks/vbook/, tasks/research/, tasks/infra/, tasks/archive/); bỏ qua
# _template.json và 000-template.json. Chỉ đọc, không sửa gì.
set -euo pipefail
cd "$(dirname "$0")/.."

FILTER="${2:-}"
if [ "${1:-}" = "--status" ] && [ -n "$FILTER" ]; then
  :
elif [ -n "${1:-}" ]; then
  echo "Dùng: $0 [--status <open|claimed|doing|review|done|blocked|cancelled>]"
  exit 2
fi

python3 - "$FILTER" <<'EOF'
import glob, json, os, sys
from datetime import datetime, timezone, timedelta

status_filter = sys.argv[1] if len(sys.argv) > 1 else ""
now = datetime.now(timezone(timedelta(hours=7)))
tasks = []
for f in sorted(glob.glob("tasks/*.json") + glob.glob("tasks/*/*.json")):
    if os.path.basename(f) in ["_template.json", "000-template.json"]:
        continue
    try:
        with open(f, "r", encoding="utf-8") as fh:
            tasks.append(json.load(fh))
    except Exception:
        pass

if status_filter:
    tasks = [t for t in tasks if t.get("status") == status_filter]

print(f"\n==================== BẢNG TRẠNG THÁI MUSE TEAMWORK ({now.strftime('%d/%m/%Y %H:%M:%S')}) ====================")
fmt = "{:<24} {:<10} {:<9} {:<12} {:<12} {:<25}"
print(fmt.format("MÃ TASK", "STATUS", "PRIORITY", "ASSIGNEE", "THỜI HẠN", "TIÊU ĐỀ"))
print("-" * 98)
for t in tasks:
    tid = t.get("id", "")[:23]
    st = t.get("status", "")[:9]
    pr = t.get("priority", "")[:8]
    asg = (t.get("assignee") or "-")[:11]
    title = t.get("title", "")[:24]
    exp = t.get("claim_expires_at")
    rem = "-"
    if exp and st in ["claimed", "doing"]:
        try:
            exp_dt = datetime.fromisoformat(exp)
            delta = exp_dt - now
            mins = int(delta.total_seconds() / 60)
            rem = f"{mins} phút" if mins > 0 else "QUÁ HẠN!"
        except Exception:
            pass
    print(fmt.format(tid, st, pr, asg, rem, title))
print("=" * 98 + "\n")
EOF
