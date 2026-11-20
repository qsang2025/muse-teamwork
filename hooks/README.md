# Hooks muse-teamwork — gate tiết kiệm token

Đổi 21/11/2026 theo mẹo tiết kiệm token (Anh duyệt "Làm nhé"): cron chạy
agent đầy đủ theo lịch đã thay bằng hook — script rẻ quét trước, chỉ đánh
thức agent khi có việc thật. Cron muse-teamwork-dashboard-inbox 15 phút/lần
(96 lượt/ngày) đã xóa; cron watchdog 2 giờ/lần đã đổi thành quét đầy đủ mỗi
ngày 06:46 (lưới an toàn, tự kiểm tra sức khỏe hook + backup inbox).

Thư mục này là NGUỒN THẬT DUY NHẤT của script gate. Bản live ở
`~/hooks/scripts/` trên máy muse-main chỉ là wrapper mỏng `exec` sang đây
(theo mẫu `scripts/watch-tasks.sh`). Sửa script thì sửa ở đây, rồi chạy
`hooks.dry_run` kiểm tra trước khi coi như xong. Không sửa trực tiếp bản
live (sẽ lệch với repo).

## 1. muse-teamwork-watch (có từ 19/11)
- Script: `scripts/watch-tasks.sh` (dùng chung 3 agent, nhận agent-id).
- Wrapper live: `~/hooks/scripts/muse-teamwork-watch.sh`. Poll: 300s.
- Wake khi: task mới giao cho agent, task vào review (chỉ muse-main),
  task đổi trạng thái, task claimed kẹt >30 phút không commit.

## 2. muse-teamwork-inbox (mới 21/11)
- Script: `hooks/muse-teamwork-inbox.sh`. Poll: 300s.
- Cách quét: API GitHub public
  `repos/qsang2025/muse-teamwork/issues?state=open&per_page=100` (không cần
  auth, repo public), lọc tiêu đề bắt đầu `[dashboard]`, loại PR.
- Wake khi: có issue [dashboard] mở chưa từng wake, hoặc đã wake hơn 2h
  trước (lần xử lý trước có thể lỗi). Issue đã đóng thì xóa khỏi state.
- State (chỉ có trên máy muse-main, không commit):
  `~/hooks/state/muse-teamwork-inbox.json`
  (`{"last_wake": {"<số issue>": "<ISO UTC>"}}`)
- Worker khi dậy: chạy `python3 scripts/apply-dashboard-issues.py` trong
  repo; chỉ báo cáo khi áp dụng được lệnh thật; lỗi thì báo ngắn gọn.

## 3. muse-teamwork-watchdog (mới 21/11)
- Script: `hooks/muse-teamwork-watchdog.sh`. Poll: 300s.
- Cách quét: `git ls-remote origin main` lấy SHA; SHA đổi mới fetch + đọc
  snapshot task từ `origin/main` (đệ quy `tasks/**/*.json`, trừ template);
  SHA không đổi thì dùng snapshot đã lưu (việc hết hạn là theo thời gian).
- Wake khi (1 trong 3):
  - (b) task claimed/doing hết hạn claim (`claim_expires_at` đã qua) — wake
    cả ở lần chạy đầu; wake lại sau 2h nếu vẫn hết hạn.
  - (d) task mới chuyển sang blocked — cần phân loại theo PROTOCOL §10(b).
  - (c) muse-1/muse-2 không còn task mở (open/claimed/doing/review) — cần
    giao 1 task tự học §9; khóa episode = task done/cancelled gần nhất,
    wake 1 lần/episode.
- KHÔNG wake khi task vào review (watch hook đã gọi muse-main, tránh 2
  agent cùng merge).
- State (chỉ có trên máy muse-main, không commit):
  `~/hooks/state/muse-teamwork-watchdog.json`
  (`tasks` snapshot + `sha` + `expired_alerted` + `idle_alerted`).
- Worker khi dậy: xem prompt trong định nghĩa hook
  (`~/hooks/definitions/muse-teamwork-watchdog.json` trên máy muse-main).

## Lưới an toàn
- Cron `muse-teamwork-watchdog` chạy quét đầy đủ mỗi ngày 06:46: kiểm tra 3
  hook còn đăng ký + enabled không (thiếu thì cài lại theo sổ
  `~/hooks/README.md` trên máy muse-main), backup inbox (issue [dashboard]
  tồn quá 24h thì chạy apply-dashboard-issues.py), sửa lệch STATUS.md
  (verify-spec), sweep hết hạn, review/merge, quản lý §10.
- Nếu hook chết im (không wake dù có việc): lượt quét 06:46 sẽ bắt trong vòng 24h.

## QA độc lập
- Task 156 (giao muse-1, 21/11): kiểm chứng độc lập toàn bộ chuyển đổi này
  — đọc script trong thư mục này, chạy lại dry-run, test đường wake bằng dữ
  liệu giả, tìm lỗ hổng (sót điều kiện, wake thừa/thiếu, race, rate-limit,
  lỗi API, state hỏng). muse-main là người viết script nên KHÔNG tự chấm
  phần này.
