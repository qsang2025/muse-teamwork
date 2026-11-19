# tasks/ — Task thật của nhóm 3 Muse

Mỗi task là **1 file JSON**, tên file = `tasks/<id>.json` (id dạng
`087-novelnext-retest`, `088-fork-rescan-13`, ...). Đây là **nguồn sự thật**:
agent nào muốn biết "việc gì đang mở, ai đang làm gì" thì đọc thư mục này
(sau `git pull`).

> Quy ước riêng cho mục đã đóng (Living Spec bước 5, 19/11/2026): task
> `cancelled` của các mục đóng từ trước có id dạng `closed-<số-roadmap>-<slug>`
> (vd `closed-061-chivi`), **không** dùng số đầu như task thường. Lý do:
> `new-task.sh` và `apply-dashboard-issues.py` tính id mới bằng
> max(số đầu tên file)+1 — đặt `108-...`/`111-...` sẽ làm task mới tiếp theo
> nhảy thành 112 thay vì 095. Tiền tố `closed-` tránh điều đó, số roadmap
> vẫn giữ trong id và notes để tra cứu.

## Schema (xem mẫu đầy đủ ở `_template.json`)

| Trường | Nghĩa |
|---|---|
| `id` | Mã task, trùng tên file (không có `.json`) |
| `title` | Tiêu đề ngắn, nói rõ làm gì |
| `type` | `vbook-extension` / `research` / `doc` / `test` / `other` |
| `repo` | Repo đích làm việc (vd `Qsang_vbook`) |
| `branch` | Branch làm việc trên repo đích (điền khi claim) |
| `assignee` | `muse-main` / `muse-1` / `muse-2` / `""` (chưa gán) |
| `preferred_assignee` | Agent được gán cố định (vd `muse-1` cho 087, `muse-2` cho 088) — `claim-task.sh` và hub từ chối agent khác claim (vá F-03); `""` = ai cũng claim được |
| `priority` | `high` / `medium` / `low` |
| `status` | `open` / `claimed` / `doing` / `review` / `done` / `blocked` / `cancelled` |
| `created_by` | Ai tạo task |
| `created_at` | Giờ tạo (ISO 8601, giờ Việt Nam +07:00) |
| `claimed_at` | Giờ claim (điền khi claim) |
| `claim_expires_at` | Hết hạn claim = claimed_at + 2h |
| `result.branch` | Branch đã push (điền khi xong) |
| `result.test` | `validate` / `device_test` / `install` — ghi PASS/FAIL + mã code |
| `result.notes` | Kết quả, lỗi gặp, link log |
| `result.review.score` | Điểm muse-main chấm khi kiểm tra (0–10; 7+ mới đạt) — không thay thế 3 điều kiện merge |
| `result.review.rounds` | Số vòng đã chấm (tối đa 3; sau 3 vòng vẫn < 7 thì muse-main quyết giao lại / tách task / đóng) |
| `result.review.by` / `.at` / `.note` | Ai chấm / giờ chấm / ghi chú ngắn vì sao được điểm đó |
| `checklist` | Các bước cần làm, tick dần |
| `notes` | Bối cảnh: link site, link ROADMAP, quyết định của Anh |

## Cách dùng

- **Tạo task mới:** `./scripts/new-task.sh "Tiêu đề task" vbook-extension`
  (xem `scripts/`), hoặc copy `_template.json` rồi sửa tay.
- **Claim task:** `./scripts/claim-task.sh <id> <agent-id>`
- **Gia hạn / nộp task (kênh GitHub-only):** `./scripts/heartbeat-task.sh <id> <agent-id> [tiến-độ]`,
  `./scripts/complete-task.sh <id> <agent-id> <branch> [ghi-chú] [--validate X] [--device-test X] [--install X]`
- **Dọn task quá hạn:** `./scripts/sweep-expired.sh` (thu hồi task claimed/doing quá hạn 2h về open)
- **Xem task mở:** `grep -l '"status": "open"' tasks/*.json` (trừ `_template.json`).
- **Đổi status:** sửa file, commit, push ngay. Không giữ thay đổi local lâu.

## Bố cục thư mục con (sharding P2.2, review qsang2027)

Khi số task vượt ~100, task được xếp vào thư mục con theo loại, vẫn trong
cùng 1 repo (không chia repo):

- `tasks/vbook/` — task build/fix extension truyện tranh/chữ
- `tasks/research/` — task scan fork, phân tích API nguồn truyện
- `tasks/infra/` — task cải tiến toolchain, script CI/CD
- `tasks/archive/YYYY/` — task đã hoàn thành (status `done`)

Các script (`new-task.sh`, `claim-task.sh`, `sweep-expired.sh`,
`heartbeat-task.sh`, `complete-task.sh`, `status-board.sh`) đều quét cả thư
mục con. Task ở thư mục con vẫn dùng cùng schema và vòng đời
open → claimed → doing → review → done.

- **Task hiện có (087, 088) CHƯA di chuyển** — vẫn ở `tasks/` tầng trên, để
  không gãy đường claim của muse-1/muse-2. Sharding áp dụng cho task mới khi
  số lượng tăng (theo review: khi > 100 task).

## Task mẫu đang mở

- `087-novelnext-retest.json` — retest 1 chương novelnext.me sau thời gian lặng
  dài (từ ROADMAP #87, MERGE HELD vì HTTP 429). Status: `open`, đã gán cố định
  cho muse-1 (`preferred_assignee`).
- `088-fork-rescan-13.json` — rescan fork lần 13 tìm nguồn mới (rescan #12 đã
  xong 2026-11-16, kho build-ready kiểm chứng được từ VM đã cạn). Status:
  `open`, đã gán cố định cho muse-2 (`preferred_assignee`).

## Quy tắc

- Không sửa task của agent khác khi nó đang `claimed/doing` (trừ muse-main
  dọn claim hết hạn 2h).
- `_template.json` không phải task thật — đừng đổi status của nó, đừng claim nó.
- File task phải là JSON hợp lệ: kiểm tra bằng
  `python3 -m json.tool tasks/<id>.json`.
- **Xem bảng trạng thái:** `./scripts/status-board.sh` (thêm `--status open`
  để chỉ xem task mở).

## Anh thao tác trực tiếp từ Dashboard (không cần nhắn chat)

- Dashboard là trang tĩnh nên không ghi thẳng vào repo được. Trên mỗi task có
  nút Giao việc / Bình luận / Quyết định — bấm nút sẽ mở sẵn một GitHub issue
  đã điền nội dung theo mẫu (tiêu đề `[dashboard] NNN: ...`, body có các dòng
  `task:`, `action:`, ...); Anh chỉ cần bấm Submit trên GitHub.
- Cron `muse-teamwork-dashboard-inbox` (15 phút/lần, muse-main) chạy
  `scripts/apply-dashboard-issues.py`: đọc các issue `[dashboard]` đang mở,
  áp dụng vào file task (giao việc → `preferred_assignee`; bình luận/quyết
  định → ghi vào `notes`; chặn → `status=blocked`; hủy → `cancelled`; yêu cầu
  sửa lại → `status=doing`, `result.review.rounds` + 1; đổi ưu tiên; giao việc
  mới → tạo `tasks/<id>-<slug>.json` mới), commit + push, rồi đóng issue kèm
  xác nhận. Chỉ issue do Anh (qsang2025) mở mới được áp dụng. Một issue = một
  thao tác.
- Quyết định "DUYỆT" trên task đang review chỉ ghi nhận ý Anh vào notes —
  việc merge vẫn do muse-main/watchdog làm khi đủ 3 điều kiện (validate +
  device test + install).
- Bình luận/quyết định của Anh hiện trên Dashboard khi làm mới trang (đọc từ
  file task trên main).
