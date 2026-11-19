# PROTOCOL.md — Giao thức làm việc 3 Muse

Ngắn gọn, đủ chạy. Mọi agent (muse-main, muse-1, muse-2) đều tuân theo file này.
Nguồn sự thật là **file task trong repo này trên GitHub**, không phải tin nhắn chat.

## 1. Vòng đời task

```
open → claimed → doing → review → done
                 │           │
                 └─ blocked ─┘   (kẹt thì ghi rõ lý do vào task, báo muse-main)
open → cancelled                 (Anh hoặc muse-main hủy)
```

| Status | Nghĩa | Ai đổi |
|---|---|---|
| `open` | Đã tạo, chưa ai nhận | muse-main / Anh |
| `claimed` | Đã có agent nhận, chưa bắt đầu làm | agent nhận task |
| `doing` | Đang làm | agent nhận task |
| `review` | Đã xong, chờ muse-main kiểm tra + merge | agent nhận task |
| `done` | muse-main đã merge / đã xác nhận xong | chỉ muse-main |
| `blocked` | Kẹt (site chặn, thiếu thông tin, cần Anh quyết) | agent nhận task |
| `cancelled` | Hủy | Anh hoặc muse-main |

Mỗi lần đổi status phải `git pull` trước, sửa file, commit, push ngay — để
agent khác thấy liền.

## 2. Quy tắc claim — 1 task chỉ 1 agent

1. Agent muốn nhận task: `git pull`, mở `tasks/<id>.json`, kiểm tra
   `status == "open"` và `assignee` đang trống.
2. Claim bằng script (khuyên dùng):
   `./scripts/claim-task.sh <id> <agent-id>` — ví dụ `./scripts/claim-task.sh 087-novelnext-retest muse-1`
   Script tự: đổi status → `claimed`, ghi `assignee`, ghi `claim_expires_at`
   = giờ hiện tại + 2h, ghi `claimed_at`, commit + push.
3. Đồng thời tạo branch làm việc trên repo đích (vd Qsang_vbook):
   `git checkout -b feature/<tên-task>` — branch là "bằng chứng" thứ hai.
4. Trong vòng 2h phải có heartbeat: đổi status → `doing` (lần commit đầu tiên
   có code) hoặc chạy `node hub/client.js heartbeat <id>` (nếu có hub).
   **Hết hạn claim sau 2h không heartbeat:** qua hub thì task tự sweep trở lại
   `open`; qua GitHub (đường chính) thì không có gì tự chạy — muse-main dọn
   claim hết hạn mỗi lần chia việc, agent khác chỉ được claim sau khi muse-main
   đã dọn. Đừng ngồi chờ task "tự" mở lại khi làm qua GitHub.
5. Không claim 2 task build cùng lúc. Làm xong 1 task mới claim task tiếp theo.

## 3. Quy tắc chống trùng — đọc trước khi build

Trước khi build bất cứ extension nào, agent **phải** làm đủ 3 bước:

1. **Quét repo đích:** `git pull` Qsang_vbook, kiểm tra extension đã có trong
   `registry` / thư mục nguồn chưa. Có rồi → dừng, báo lại task.
2. **Quét tasks:** `git pull` muse-teamwork, đọc hết `tasks/*.json` có status
   `claimed/doing/review` — có task nào trùng site/trùng việc không. Trùng →
   dừng, báo lại task.
3. **Quét tasks + STATUS.md:** đọc `tasks/*.json` (status `open/doing/review/blocked/cancelled`) + `STATUS.md` ở gốc repo này.
   Site đã ĐÓNG (task `cancelled`) thì không mở lại trừ khi Anh nói rõ. `ROADMAP.md` local của muse-main chỉ là bản báo cáo
   suy ra từ task files, không phải nguồn chống trùng — muse-1/muse-2 không đọc được file đó.

Vi phạm (2 agent cùng build 1 site) thì agent claim sau phải dừng và chuyển
sang task khác, không cãi nhau trong code.

## 4. Quy tắc merge — chỉ muse-main merge

- **Chỉ muse-main** được merge lên `Qsang_vbook` main. muse-1/muse-2 tuyệt đối
  không tự merge, không tự push lên main.
- Quy tắc auto-merge (đã có từ trước, giữ nguyên): merge khi tự kiểm chứng đủ
  3 điều — **validate PASS + device test code 0 + install code 200** — không
  hỏi lại Anh, báo Anh ngay sau khi merge xong.
- Agent worker làm xong: push branch lên repo đích, cập nhật task:
  `status: "review"`, điền `result.branch`, `result.test` (validate + device
  test + install), `result.notes`. Rồi dừng, chờ muse-main.
- muse-main kiểm tra: pull branch, chạy lại validate, xem kết quả device test.
  Đạt → merge → task `done`. Không đạt → ghi rõ lý do vào task, trả về
  `doing` cho agent sửa, hoặc `blocked` nếu cần Anh quyết.
- muse-main chấm điểm mỗi lần kiểm tra (khi task ở `review`): điền
  `result.review` (`score` 0–10, `rounds` = số vòng đã chấm, `by: "muse-main"`,
  `at`, `note` ngắn gọn vì sao được điểm đó). Thang: 9–10 xuất sắc, 7–8 đạt,
  5–6 chưa đạt, 0–4 kém. Điểm KHÔNG thay thế 3 điều kiện merge (validate PASS
  + device test code 0 + install 200) — chỉ là thước chất lượng kèm theo.
  Chưa đạt (< 7) → trả về `doing`, `rounds` +1, ghi rõ lỗi vào
  `result.review.note`. Tối đa 3 vòng chấm: sau 3 vòng vẫn < 7 thì muse-main
  quyết — giao lại agent khác, tách nhỏ task, hoặc `blocked`/`cancelled` +
  báo Anh.
- Merge xong phải cập nhật ROADMAP.md + registry của Qsang_vbook (như quy
  trình cũ). Merge xong phải cập nhật task → `done` + `STATUS.md` trong cùng một lượt push, rồi mới báo Anh.

## 5. Cách báo cáo

- **Báo cáo vào task file:** mọi tiến độ, kết quả test, lỗi gặp phải đều ghi
  vào `tasks/<id>.json` (mục `result` + `notes`), commit + push. Không báo cáo
  chỉ bằng chat — chat trôi, file còn.
- **Báo Anh:** muse-main tổng hợp **1 tin duy nhất** sau mỗi task xong
  (hoặc cuối ngày nếu nhiều task): task gì, ai làm, kết quả, link branch/commit.
  Không nhắn Anh mỗi bước nhỏ.
- **Task blocked:** agent ghi rõ vào task (lý do + cần gì), để status
  `blocked`, muse-main sẽ hỏi Anh 1 lần (gom nhiều câu hỏi vào 1 tin nếu có).

## 6. Xung đột (2 agent sửa cùng 1 file task)

- Luôn `git pull --rebase` trước khi push. Push bị reject → pull lại, xem ai
  claim trước (theo `claimed_at` trong file + giờ commit).
- Người claim sau nhường, chuyển sang task khác. Không force-push.
- Nếu hub đang chạy, hub là trọng tài phụ (xem `hub/server.js`), nhưng file
  GitHub vẫn là quyết định cuối cùng khi có mâu thuẫn.

## 7. Nhịp làm việc

- Mỗi agent trước khi bắt đầu ca làm: `git pull` muse-teamwork, xem task open.
- **Watcher 5 phút (quyết định của Anh 19/11):** mỗi agent cài hook/script
  `scripts/watch-tasks.sh` quét repo mỗi 5 phút, chỉ mở phiên làm việc khi
  script báo có thay đổi liên quan đến mình (task mới giao cho mình, task
  vào review — chỉ muse-main, task của mình bị làm lại/mở lại/hủy).
  Script chỉ đọc `origin/main`, bỏ qua thay đổi notes/`updated_at`
  (heartbeat, bình luận dashboard) để không đánh thức vô ích.
  Từ 19/11 ~21:45 (đề xuất 2, Anh duyệt): script hỏi SHA bằng `ls-remote`
  trước, SHA không đổi thì bỏ qua fetch luôn (giảm ~90% lượng fetch);
  chỉ fetch khi SHA đổi. Lỗi mạng (ls-remote/fetch) thì im lặng chờ lần sau.
  **CẤM quét mỗi 1 phút** (GitHub có thể chặn tạm thời vì quét quá dày;
  5 phút đã rút lúc nhận việc từ ~30 phút xuống ~2-3 phút). Webhook không
  làm được vì VM không nhận kết nối từ ngoài vào.
- Mỗi 2h làm việc: heartbeat (commit tiến độ hoặc `heartbeat` qua hub).
- Cuối task: cập nhật task file → push → báo muse-main (bằng cách để task ở
  `review`, muse-main tự thấy khi pull).

## 8. Luật Living Spec — cập nhật spec trước, báo cáo sau

- Xong việc phải cập nhật task file + push rồi mới được nhắn báo cáo. Merge xong phải cập nhật task + `STATUS.md` trong cùng một lượt push rồi mới báo Anh.
- Mỗi lần sửa task file phải cập nhật `updated_at` = giờ hiện tại. Task `doing` mà `updated_at` quá 48h thì coi như spec có thể cũ — kiểm chứng lại trước khi tin.
- `notes` là nhật ký thêm vào cuối, không sửa mục cũ. Mỗi mục 1 sự kiện, tối đa 5 dòng, định dạng `[DD/MM HH:MM tên-agent: nội dung]`. Chỉ ghi khi có: kết quả mới, quyết định mới, blocker mới, hoặc gotcha cho người sau.
- **Heartbeat không được ghi vào notes.** Tiến độ lặp lại (hub sống/chết, poll ok) thuộc về log heartbeat / file riêng, không thuộc task.
- Nếu `notes` dài quá ~8.000 ký tự: chuyển các mục cũ sang `tasks/archive/<id>-log.md`, để lại trong notes 1 dòng trỏ tới file đó.
- **Không ghi IP, port, mẫu máy, đường dẫn local vào `notes`** (repo public, dashboard hiển thị công khai — chi tiết hạ tầng để trong file log riêng, notes chỉ ghi kết quả + link). File archive đã ghi rồi thì để nguyên văn, không sửa lại lịch sử.
- `branch` cấp ngoài và `result.branch` phải giống nhau — chỉ ghi một chỗ, chỗ kia copy y hệt, không để một chỗ trống.
