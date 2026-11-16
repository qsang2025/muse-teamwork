#!/bin/bash
# hub/test-local.sh — kiểm tra hub chạy đúng trên loopback (127.0.0.1).
# Chỉ test local, KHÔNG chứng minh máy khác kết nối được qua Tailscale.
# Muốn kiểm tra qua Tailscale thì xem docs/SETUP-HUB.md (curl qua proxy 3130).
# Cách dùng: ./hub/test-local.sh
set -u
cd "$(dirname "$0")/.."

PORT="${PORT:-8787}"
echo "== 1. Khởi động hub local (port $PORT, chạy nền) =="
PORT="$PORT" node hub/server.js > /tmp/muse-hub-test.log 2>&1 &
HUB_PID=$!
trap 'kill $HUB_PID 2>/dev/null || true' EXIT
sleep 1

echo "== 2. GET /health =="
curl -s -m 5 "http://127.0.0.1:$PORT/health"; echo

echo "== 3. GET /tasks (ban đầu rỗng) =="
curl -s -m 5 "http://127.0.0.1:$PORT/tasks"; echo

echo "== 4. Seed 1 task mẫu rồi claim/heartbeat/complete =="
python3 - "$PORT" <<'EOF'
import json, sys
p = "hub/data/tasks.json"
tasks = {"999-test": {"id": "999-test", "title": "Task test local", "status": "open", "assignee": "", "priority": "low"}}
json.dump(tasks, open(p, "w"), indent=2, ensure_ascii=False)
print("seed ok")
EOF
curl -s -m 5 -X POST "http://127.0.0.1:$PORT/claim" -H 'Content-Type: application/json' -d '{"id":"999-test","agent":"muse-1"}'; echo
curl -s -m 5 -X POST "http://127.0.0.1:$PORT/heartbeat" -H 'Content-Type: application/json' -d '{"id":"999-test","agent":"muse-1"}'; echo
curl -s -m 5 -X POST "http://127.0.0.1:$PORT/complete" -H 'Content-Type: application/json' -d '{"id":"999-test","agent":"muse-1","result":{"notes":"test local ok"}}'; echo
echo "== 5. GET /tasks?status=review =="
curl -s -m 5 "http://127.0.0.1:$PORT/tasks?status=review"; echo

echo "== 6. Dọn task test =="
python3 -c "import json; json.dump({}, open('hub/data/tasks.json','w'))"
echo "Xong. Nếu các bước trên đều trả JSON ok thì hub chạy đúng local."
echo "Log hub: /tmp/muse-hub-test.log"
