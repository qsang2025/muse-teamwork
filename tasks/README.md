# tasks/ — Task thật của nhóm 3 Muse

Mỗi task là **1 file JSON**, tên file = `tasks/<id>.json` (id dạng
`087-novelnext-retest`, `088-fork-rescan-13`, ...). Đây là **nguồn sự thật**:
agent nào muốn biết "việc gì đang mở, ai đang làm gì" thì đọc thư mục này
(sau `git pull`).

## Schema (xem mẫu đầy đủ ở `_template.json`)

| Trường | Nghĩa |
|---|---|
| `id` | Mã task, trùng tên file (không có `.json`) |
| `title` | Tiêu đề ngắn, nói rõ làm gì |
| `type` | `vbook-extension` / `research` / `doc` / `test` / `other` |
| `repo` | Repo đích làm việc (vd `Qsang_vbook`) |
| `branch` | Branch làm việc trên repo đích (điền khi claim) |
| `assignee` | `muse-main` / `muse-1` / `muse-2` / `""` (chưa gán) |
| `priority` | `high` / `medium` / `low` |
| `status` | `open` / `claimed` / `doing` / `review` / `done` / `blocked` / `cancelled` |
| `created_by` | Ai tạo task |
| `created_at` | Giờ tạo (ISO 8601, giờ Việt Nam +07:00) |
| `claimed_at` | Giờ claim (điền khi claim) |
| `claim_expires_at` | Hết hạn claim = claimed_at + 2h |
| `result.branch` | Branch đã push (điền khi xong) |
| `result.test` | `validate` / `device_test` / `install` — ghi PASS/FAIL + mã code |
| `result.notes` | Kết quả, lỗi gặp, link log |
| `checklist` | Các bước cần làm, tick dần |
| `notes` | Bối cảnh: link site, link ROADMAP, quyết định của Anh |

## Cách dùng

- **Tạo task mới:** `./scripts/new-task.sh "Tiêu đề task" vbook-extension`
  (xem `scripts/`), hoặc copy `_template.json` rồi sửa tay.
- **Claim task:** `./scripts/claim-task.sh <id> <agent-id>`
- **Xem task mở:** `grep -l '"status": "open"' tasks/*.json` (trừ `_template.json`).
- **Đổi status:** sửa file, commit, push ngay. Không giữ thay đổi local lâu.

## Task mẫu đang mở

- `087-novelnext-retest.json` — retest 1 chương novelnext.me sau thời gian lặng
  dài (từ ROADMAP #87, MERGE HELD vì HTTP 429). Status: `open`, chưa gán.
- `088-fork-rescan-13.json` — rescan fork lần 13 tìm nguồn mới (rescan #12 đã
  xong 2026-11-16, kho build-ready kiểm chứng được từ VM đã cạn). Status:
  `open`, chưa gán.

## Quy tắc

- Không sửa task của agent khác khi nó đang `claimed/doing` (trừ muse-main
  dọn claim hết hạn 2h).
- `_template.json` không phải task thật — đừng đổi status của nó, đừng claim nó.
- File task phải là JSON hợp lệ: kiểm tra bằng
  `python3 -m json.tool tasks/<id>.json`.
