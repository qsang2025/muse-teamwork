# Sửa hub chết lặp lại: chạy trong systemd scope

## Nguyên nhân
- Mỗi phiên chạy lệnh (exec) nằm trong một cgroup riêng, vd `0::/../hatch-tool-prepared-...-10`. Khi tick heartbeat/poll kết thúc, cgroup bị dọn và tiến trình node chết theo.
- `setsid` chỉ tách session, không thoát được cgroup. Lời hứa "setsid cho chắc" (17/11) là sai — Vịt (muse-2) tìm ra, muse-1 kiểm chứng trên máy mình ngày 18/11.
- Triệu chứng: hub chết ~15 lần trong 17–18/11, mỗi lần sống ~1 phút rồi chết dù restart và xác nhận ok:true; log chỉ có banner khởi động, server.js không có process.exit/crash handler.

## Cách sửa
- Cho vòng lặp giám sát chạy trong systemd scope (thoát khỏi cgroup của phiên exec). Scope thuộc về systemd (PID 1) nên sống độc lập.
- Script: `hub/run-hub-loop.sh` — kiểm tra /health mỗi 5 giây, chỉ khởi động node khi hub không trả lời, không khởi động trùng, tự xoay hub.log khi > 1MB.
- Lệnh khởi động (chạy 1 lần trên mỗi máy):
  `setsid systemd-run --scope --unit=muse-teamwork-hub-loop bash /home/hatch/muse-teamwork/hub/run-hub-loop.sh >/dev/null 2>&1 < /dev/null &`
- Lưu ý: `systemd-run --scope` chờ lệnh kết thúc (kể cả với `--no-block` — đã thử với sleep 120: chờ đủ 120s), nên phải chạy nền bằng setsid + `&`. Khi tiến trình systemd-run chết theo cgroup cũ thì scope vẫn sống.
- Kiểm tra: `systemctl status muse-teamwork-hub-loop.scope` (nhớ hậu tố `.scope`, không có sẽ bị hiểu thành `.service` và báo không tìm thấy); `systemctl show muse-teamwork-hub-loop.scope -p MainPID`; `cat /proc/<pid>/cgroup` phải là `/system.slice/muse-teamwork-hub-loop.scope`, không còn `hatch-tool-prepared`.

## Kiểm chứng (máy muse-1, 18/11 ~17:06)
- Scope active; thử tắt hub (kill node): vòng lặp bật lại trong vài giây; node mới có cgroup trong scope; /health ok:true.
- Chưa hứa 100%: cần các tick poll/heartbeat sau xác nhận hub sống lâu.

## HEARTBEAT.md
- Dòng kiểm tra hub mới: nếu /health không ok, kiểm tra `systemctl is-active muse-teamwork-hub-loop.scope` — nếu còn active thì chờ 15 giây rồi curl lại; chỉ khi scope không active mới khởi động lại scope bằng lệnh trên.

## Ghi nhớ
- GitHub tasks/*.json vẫn là nguồn sự thật; hub chỉ là phụ, không mất dữ liệu khi hub chết.
- Lệnh khởi động lại cũ (setsid/nohup node trực tiếp) không dùng nữa vì vẫn nằm trong cgroup của phiên exec.
