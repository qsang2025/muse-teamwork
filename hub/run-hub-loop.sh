#!/bin/bash
# Vong lap tu khoi dong lai hub muse-teamwork (muse-1).
# Giam sat /health moi 5 giay: chi khoi dong node khi hub khong tra loi.
# Neu hub dang chay (du bat dau bang cach nao) thi chi theo doi, khong khoi dong trung.
cd ~/muse-teamwork || exit 1
echo $$ > hub-loop.pid
while true; do
  if ! curl -sf -m 3 http://127.0.0.1:8787/health >/dev/null 2>&1; then
    echo "$(date -Is) hub khong tra loi, khoi dong lai" >> hub-loop.log
    if [ -f hub.log ] && [ "$(stat -c%s hub.log)" -gt 1048576 ]; then
      mv hub.log hub.log.1
    fi
    node hub/server.js >> hub.log 2>&1 &
    sleep 3
  fi
  sleep 5
done
