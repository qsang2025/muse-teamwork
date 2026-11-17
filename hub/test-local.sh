#!/bin/bash
# hub/test-local.sh — kiểm chứng hub (vá F-04: đọc/ghi trực tiếp tasks/*.json,
# auto commit+push, sweep ở heartbeat/complete, complete ghi đủ result).
# Chạy HOÀN TOÀN trong /tmp với remote bare local — KHÔNG động vào origin thật,
# KHÔNG động vào repo thật (hub chạy với TASKS_DIR trỏ sang clone test).
# Chỉ test local, KHÔNG chứng minh máy khác kết nối được qua Tailscale.
# Muốn kiểm tra qua Tailscale thì xem docs/SETUP-HUB.md (curl qua proxy 3130).
# Cách dùng: ./hub/test-local.sh   (exit 0 = tất cả PASS)
set -u
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="/tmp/mt-hub-f04-test"
REMOTE="$TEST_DIR/remote.git"
HOST_CLONE="$TEST_DIR/host"     # máy chạy hub (TASKS_DIR trỏ vào đây)
GIT_CLONE="$TEST_DIR/gitclient" # kênh GitHub-only (scripts/claim-task.sh)
PORT="${PORT:-18787}"
PASS=0
FAIL=0

cleanup() {
  kill "$HUB_PID" 2>/dev/null || true
  rm -rf "$TEST_DIR"
}
trap cleanup EXIT

check() { # check <tên> <lệnh...>
  local name="$1"; shift
  if "$@" >/tmp/mt-hub-f04-check.out 2>&1; then
    PASS=$((PASS + 1)); echo "PASS: $name"
  else
    FAIL=$((FAIL + 1)); echo "FAIL: $name (xem /tmp/mt-hub-f04-check.out)"
    sed 's/^/    /' /tmp/mt-hub-f04-check.out | head -n 20
  fi
}

echo "== 0. Chuẩn bị: remote bare + 2 clone, seed task thật 087/088 =="
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
git init -q --bare "$REMOTE"
git clone -q "$REMOTE" "$HOST_CLONE" 2>/dev/null
git clone -q "$REMOTE" "$GIT_CLONE" 2>/dev/null
git -C "$HOST_CLONE" checkout -q -b main
mkdir -p "$HOST_CLONE/tasks" "$HOST_CLONE/scripts"
cp "$REPO_DIR/tasks/087-novelnext-retest.json" "$REPO_DIR/tasks/088-fork-rescan-13.json" "$HOST_CLONE/tasks/"
cp "$REPO_DIR/scripts/claim-task.sh" "$HOST_CLONE/scripts/"
git -C "$HOST_CLONE" -c user.name=test -c user.email=test@test add -A
git -C "$HOST_CLONE" -c user.name=test -c user.email=test@test commit -q -m "seed test"
git -C "$HOST_CLONE" push -q -u origin main
# Clone B checkout SAU khi seed đã push (không copy file vào trước, tránh
# checkout abort vì file untracked trùng tên file trong commit).
git -C "$GIT_CLONE" fetch -q origin
git -C "$GIT_CLONE" checkout -q -b main origin/main

echo "== 1. Khởi động hub (TASKS_DIR=$HOST_CLONE/tasks, sync git BẬT) =="
PORT="$PORT" TASKS_DIR="$HOST_CLONE/tasks" node "$REPO_DIR/hub/server.js" > /tmp/muse-hub-test.log 2>&1 &
HUB_PID=$!
sleep 1

echo "== 2. GET /health + GET /tasks (thấy 087/088 open, nguồn tasks/*.json) =="
check "health ok" bash -c "curl -s -m 5 'http://127.0.0.1:$PORT/health' | grep -q '\"ok\":true'"
check "tasks liệt kê 087+088 open" bash -c "curl -s -m 5 'http://127.0.0.1:$PORT/tasks?status=open' | grep -q 087-novelnext-retest && curl -s -m 5 'http://127.0.0.1:$PORT/tasks?status=open' | grep -q 088-fork-rescan-13"
check "tasks không liệt kê _template" bash -c "! curl -s -m 5 'http://127.0.0.1:$PORT/tasks' | grep -q 000-template"

echo "== 3. (b) Claim 087 qua API → file tasks/087 đổi đúng + đã push lên remote =="
curl -s -m 5 -X POST "http://127.0.0.1:$PORT/claim" -H 'Content-Type: application/json' -d '{"id":"087-novelnext-retest","agent":"muse-1"}' > /tmp/mt-hub-f04-claim.out
check "claim 087 trả ok" grep -q '"ok":true' /tmp/mt-hub-f04-claim.out
check "file 087 status=claimed, assignee=muse-1, giờ +07:00" python3 -c "import json; t=json.load(open('$HOST_CLONE/tasks/087-novelnext-retest.json')); assert t['status']=='claimed' and t['assignee']=='muse-1' and t['claimed_at'].endswith('+07:00') and t['claim_expires_at'].endswith('+07:00'), t"
check "claim 087 đã push lên remote" bash -c "git -C '$GIT_CLONE' pull -q && python3 -c \"import json; t=json.load(open('$GIT_CLONE/tasks/087-novelnext-retest.json')); assert t['status']=='claimed' and t['assignee']=='muse-1', t\""
check "hub không còn dùng hub/data/tasks.json" bash -c "[ ! -f '$HOST_CLONE/hub/data/tasks.json' ] && [ ! -f '$REPO_DIR/hub/data/tasks.json' ]"

echo "== 4. Heartbeat gia hạn + complete ghi đủ result (qua client.js) =="
sleep 1
node "$REPO_DIR/hub/client.js" --hub "http://127.0.0.1:$PORT" --agent muse-1 heartbeat 087-novelnext-retest > /tmp/mt-hub-f04-hb.out 2>&1
check "heartbeat đổi sang doing + gia hạn" python3 -c "import json; t=json.load(open('$HOST_CLONE/tasks/087-novelnext-retest.json')); assert t['status']=='doing', t"
node "$REPO_DIR/hub/client.js" --hub "http://127.0.0.1:$PORT" --agent muse-1 complete 087-novelnext-retest --branch feature/novelnext --notes "ch.1 đọc đủ, HTTP 200" --validate PASS --device-test 0 --install 200 > /tmp/mt-hub-f04-done.out 2>&1
COMPLETE_RC=$?
if [ "$COMPLETE_RC" -eq 0 ] && grep -q '"ok"' /tmp/mt-hub-f04-done.out; then PASS=$((PASS + 1)); echo "PASS: complete trả ok";
else FAIL=$((FAIL + 1)); echo "FAIL: complete trả ok (exit $COMPLETE_RC)"; sed 's/^/    /' /tmp/mt-hub-f04-done.out | head -n 10; fi
check "(c) file 087 review + đủ result" python3 -c "
import json
t = json.load(open('$HOST_CLONE/tasks/087-novelnext-retest.json'))
r = t['result']
assert t['status'] == 'review', t
assert r['branch'] == 'feature/novelnext', r
assert r['notes'] == 'ch.1 đọc đủ, HTTP 200', r
assert r['test'] == {'validate': 'PASS', 'device_test': '0', 'install': '200'}, r
"
check "complete đã push lên remote" bash -c "git -C '$GIT_CLONE' pull -q && python3 -c \"import json; t=json.load(open('$GIT_CLONE/tasks/087-novelnext-retest.json')); assert t['status']=='review' and t['result']['test']['validate']=='PASS', t\""

echo "== 5. (d) Task quá hạn bị thu hồi khi gọi /heartbeat =="
python3 - "$HOST_CLONE/tasks/088-fork-rescan-13.json" <<'EOF'
import json, sys
from datetime import datetime, timedelta, timezone
p = sys.argv[1]
t = json.load(open(p))
now = datetime.now(timezone(timedelta(hours=7)))
t["status"] = "claimed"; t["assignee"] = "muse-2"
t["claimed_at"] = (now - timedelta(hours=3)).strftime("%Y-%m-%dT%H:%M:%S+07:00")
t["claim_expires_at"] = (now - timedelta(hours=1)).strftime("%Y-%m-%dT%H:%M:%S+07:00")
json.dump(t, open(p, "w"), indent=2, ensure_ascii=False)
open(p, "a").write("\n")
EOF
git -C "$HOST_CLONE" -c user.name=test -c user.email=test@test commit -q -am "seed expired 088" && git -C "$HOST_CLONE" push -q
curl -s -m 5 -X POST "http://127.0.0.1:$PORT/heartbeat" -H 'Content-Type: application/json' -d '{"id":"088-fork-rescan-13","agent":"muse-2"}' > /tmp/mt-hub-f04-sweep.out
check "heartbeat task quá hạn trả 409" grep -q '409\|hết hạn' /tmp/mt-hub-f04-sweep.out
check "(d) file 088 về open sau sweep" python3 -c "import json; t=json.load(open('$HOST_CLONE/tasks/088-fork-rescan-13.json')); assert t['status']=='open' and t['assignee']=='', t"

echo "== 6. (e) Claim qua hub rồi claim lại qua GitHub-only thì bị từ chối =="
curl -s -m 5 -X POST "http://127.0.0.1:$PORT/claim" -H 'Content-Type: application/json' -d '{"id":"088-fork-rescan-13","agent":"muse-1"}' > /tmp/mt-hub-f04-claim88.out
check "claim 088 qua hub ok" grep -q '"ok":true' /tmp/mt-hub-f04-claim88.out
git -C "$GIT_CLONE" pull -q
"$GIT_CLONE/scripts/claim-task.sh" 088-fork-rescan-13 muse-2 > /tmp/mt-hub-f04-claim88b.out 2>&1
RC=$?
if [ "$RC" -eq 3 ]; then PASS=$((PASS + 1)); echo "PASS: (e) claim-task.sh từ chối đúng, exit 3";
else FAIL=$((FAIL + 1)); echo "FAIL: (e) claim-task.sh phải exit 3, thực tế exit $RC"; sed 's/^/    /' /tmp/mt-hub-f04-claim88b.out | head -n 10; fi
check "sau (e) clone B không còn commit rác" bash -c "[ -z \"\$(git -C '$GIT_CLONE' status --porcelain | grep -v '^??')\" ]"

echo
echo "== Kết quả: PASS=$PASS FAIL=$FAIL =="
echo "Log hub: /tmp/muse-hub-test.log"
[ "$FAIL" -eq 0 ]
