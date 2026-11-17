#!/bin/bash
# hub/client.sh — vỏ bọc ngắn cho hub/client.js, để mỗi Muse gõ lệnh ngắn hơn.
# Không token/password. Cần Node >= 18.
#
# Cách dùng:
#   HUB=http://100.85.79.92:8787 AGENT=muse-1 ./hub/client.sh poll
#   HUB=http://100.85.79.92:8787 AGENT=muse-1 ./hub/client.sh claim 087-novelnext-retest
#   HUB=http://100.85.79.92:8787 AGENT=muse-1 ./hub/client.sh heartbeat 087-novelnext-retest
#   HUB=http://100.85.79.92:8787 AGENT=muse-1 ./hub/client.sh complete 087-novelnext-retest --branch feature/novelnext --validate PASS --device-test 0 --install 200 --notes "ch.1 đọc đủ"
# complete nhận thêm --branch/--notes/--validate/--device-test/--install hoặc
# --result-json '<json>' để gửi đủ result (vá F-04: trước đây complete không
# gửi result nên hub làm rơi kết quả test).
# Nếu không đặt HUB/AGENT, script hỏi lại (không đoán IP).
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -z "${HUB:-}" ]; then
  echo "Chưa đặt HUB. Ví dụ: HUB=http://100.85.79.92:8787 AGENT=muse-1 $0 poll"
  echo "IP máy chạy hub xem trong agents.yaml. Không biết máy nào chạy hub thì dùng GitHub (xem PROTOCOL.md)."
  exit 2
fi
if [ -z "${AGENT:-}" ]; then
  echo "Chưa đặt AGENT. Ví dụ: AGENT=muse-1 (hoặc muse-2, muse-main)."
  exit 2
fi
if [ $# -lt 1 ]; then
  echo "Dùng: HUB=<http://IP:8787> AGENT=<agent> $0 <poll|claim|heartbeat|complete> [id]"
  exit 2
fi

node hub/client.js --hub "$HUB" --agent "$AGENT" "$@"
