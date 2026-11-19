# Root cause: task 112 bị kẹt 00:32–02:30 (20/11/2026)

- Người báo cáo: muse-2 (Vịt), 20/11 02:36 +07, theo yêu cầu của Anh
- Task liên quan: `112-port-loai-extension-forum-build-otofun` (muse-2, ưu tiên cao)
- Đề xuất gửi chị Bẹp (muse-main) quyết định — xem §5

## 1. Tóm tắt

Task 112 (Port loại extension forum + build Otofun) được tạo 00:32:52, claim
00:37:56, nhưng không có tiến độ gì cho đến 02:30 khi muse-2 (main) phát hiện
và nhận lại theo yêu cầu kiểm tra task của Anh.

Nguyên nhân: worker do watcher đánh thức đã làm thật 10 phút rồi chết đột
ngột lúc 00:47, không để lại branch/commit/dấu vết nào. Hệ thống không có cơ
chế phát hiện task ở trạng thái "claimed" bị kẹt (watcher chỉ phản ứng khi
trạng thái task THAY ĐỔI), nên task nằm im 1 tiếng 43 phút. Đây là lần thứ 2
cùng mẫu lỗi (task 103 hôm qua cũng kẹt tương tự).

## 2. Dòng thời gian (bằng chứng)

| Thời gian (+07) | Sự kiện | Bằng chứng |
|---|---|---|
| 00:32:51 | Task 103 done (merge shushuwuxs lên main) | commit `d591950` |
| 00:32:52 | muse-main tạo task 112 | commit `b8e377a`; `created_at` 00:32:52 |
| 00:32:12 | Hook tick: silent, SHA không đổi — chưa thấy task 112 (task tạo sau tick 40 giây) | hook log `muse-teamwork-watch-muse-2.jsonl` |
| 00:34:41 | VM bị thay mới (boot) | `uptime` / boot time |
| 00:37:12 | Hook WAKE: task 112 "new task assigned" (muse-2) | hook log, outcome `wake` |
| 00:37:14 | Worker `agent-1cf50f12` được hook đánh thức | `sessions.json` `created_at` 17:37:14Z |
| 00:37:56 | Worker claim task 112, hạn 02:37:56 | commit `6918b95` |
| 00:37–00:47 | Worker làm thật: đọc task/skill/báo cáo 111, tải HTML otofun, xác minh lỗi probe #2 (phân trang `/page-N` đúng — trang 2 trả bài khác) và lỗi #1 (search GET trả 0 kết quả) | session jsonl seq 0–55 |
| 00:47:15 | Worker chết: lệnh exec cuối bị "aborted", phiên kết thúc | session jsonl seq 56; `sessions.json` `updated_at` 17:47:15Z |
| 00:47–02:30 | Task nằm "claimed", không tiến độ. Hook im lặng (không có thay đổi trạng thái). Không commit nào mới. | hook log (silent); `git log` |
| 02:30 | muse-2 (main) phát hiện khi Anh yêu cầu kiểm tra task; gia hạn claim đến 04:30, giao worker mới | commit `6b2171b` (heartbeat); worker `c8bb276a` |

## 3. Phân tích nguyên nhân

### 3.1. Worker chết giữa chừng (nguyên nhân trực tiếp)

Worker `agent-1cf50f12` làm việc 00:37–00:47 (~10 phút), xác minh được 2/3
lỗi probe, rồi phiên kết thúc đột ngột lúc 00:47:15 với lệnh exec bị
"aborted". Nó chưa kịp tạo branch hay commit code nào (mới ở bước khảo sát).

### 3.2. Worker không để lại dấu vết (làm mất khả năng nối tiếp)

Trong 10 phút làm việc, worker chưa tạo branch, chưa commit code hay ghi chú
tiến độ nào vào task. Từ ngoài nhìn vào, task trông như "claim rồi bỏ đó" —
không phân biệt được worker đã làm gì. Người nhận lại phải làm lại từ đầu
phần khảo sát.

### 3.3. Không có watchdog cho task "claimed" bị kẹt (lỗ hổng hệ thống)

Watcher 5 phút chỉ đánh thức khi trạng thái task THAY ĐỔI (task mới, task
chuyển sang open/doing, task vào review...). Một task ở "claimed" mà worker
đã chết thì không đổi trạng thái → watcher im lặng. Cơ chế duy nhất để "giải
cứu" task kẹt là hết hạn claim 2 tiếng (02:37:56) — quá lâu, và sau khi hết
hạn task mới trở lại "open" để claim lại.

Đây là lần thứ 2 cùng mẫu lỗi: task 103 hôm qua cũng kẹt kiểu này (worker
claim 21:58 rồi chết, phát hiện 23:26 khi Anh yêu cầu kiểm tra).

## 4. Cái KHÔNG phải nguyên nhân

- **Đổi VM lúc 00:34:41:** xảy ra TRƯỚC khi worker 112 được tạo (00:37),
  nên không giết worker này. (Nhưng đổi VM là nguyên nhân vụ 103 hôm qua.)
- **Watcher:** hoạt động đúng — phát hiện task 112 và đánh thức worker lúc
  00:37:12, chỉ 5 phút sau khi task được tạo.
- **muse-main:** tạo task đúng, đầy đủ checklist + notes.
- **Worker lười/bỏ việc:** worker đã làm thật 10 phút và xác minh được lỗi
  probe; nó chết chứ không phải không làm.

## 5. Đề xuất khắc phục (gửi chị Bẹp quyết)

### Đề xuất 1 — Watchdog cho task "claimed" bị kẹt (quan trọng nhất)

Thêm luật vào watcher: nếu một task ở trạng thái "claimed" mà quá 30 phút
không có commit mới hoặc heartbeat mới (tức `claim_expires_at` không được gia
hạn), thì đánh thức lại agent được gán (hoặc muse-2) để kiểm tra/nối tiếp.

Cách làm: script `watch-tasks.sh` lưu thêm `last_activity` (thời gian
commit/heartbeat gần nhất của task) và so sánh với ngưỡng 30 phút. Cần sửa
script + PROTOCOL.md §7.

### Đề xuất 2 — Bắt buộc worker commit tiến độ sớm

Worker sau khi claim phải tạo branch và commit một ghi chú tiến độ (hoặc
commit WIP) trong 15 phút đầu. Nếu worker chết sau đó, người nhận lại có thể
nối tiếp từ branch/commit đó thay vì làm lại từ đầu.

Thêm vào PROTOCOL.md (mục claim/lifecycle) và vào skill vbook-extension
(mục checklist claim).

### Đề xuất 3 — Giảm thời gian claim từ 2h xuống 1h (tùy chọn)

Claim 2h là quá dài khi worker chết sớm. Giảm xuống 1h để task kẹt được "giải
cứu" sớm hơn. (Nhưng watchdog ở đề xuất 1 quan trọng hơn, vì nó phát hiện
trong 30 phút thay vì chờ hết hạn.)

## 6. Trạng thái hiện tại

- Task 112 đã được nhận lại: claim gia hạn đến 04:30 20/11, worker mới
  (`c8bb276a`) đang làm (port hạ tầng forum + build Otofun).
- Task 114 (VOZ Forum) vẫn chờ 112 merge xong mới làm được.
- Task 112 cũ (worker `agent-1cf50f12`) không để lại branch/commit nào ngoài
  commit claim `6918b95`; công việc khảo sát của nó (xác minh lỗi probe #1,
  #2) chỉ còn trong file session của nó, worker mới phải làm lại phần này.
