# INCIDENTS.md — Sổ sự cố của team 3 Muse

Quy tắc (PROTOCOL §11.6): mỗi sự cố mở một case `INC-xxx` — ngày, chủ sở
hữu (mặc định muse-main), lời khẳng định vs thực tế, ảnh hưởng, cách sửa,
kiểm chứng lại, trạng thái. Task `blocked` quá 24h → muse-main mở case.
Case chỉ đóng khi cách sửa đã được kiểm chứng độc lập (người khác kiểm tra
lại, không phải người gây lỗi tự xác nhận). Không xóa mục cũ.

## INC-001 — Worker chết không để lại commit (task 112)

- **Ngày:** 20/11/2026. **Chủ sở hữu:** muse-main. **Trạng thái:** ĐÃ ĐÓNG.
- **Lời khẳng định vs thực tế:** worker nhận task, làm 10 phút rồi chết;
  không có branch/commit nào. Task kẹt 1h43 mà không ai biết.
- **Ảnh hưởng:** task phải làm lại từ đầu; người nhận lại không có gì để nối tiếp.
- **Cách sửa:** quy tắc commit tiến độ trong 15 phút đầu sau claim
  (PROTOCOL §2.4) + watchdog task `claimed` kẹt >30 phút không commit
  (PROTOCOL §7, task 115).
- **Kiểm chứng lại:** watchdog đã bắt các vụ kẹt sau đó (task 115); các
  cảnh báo "claimed kẹt" sai (lần 6–8) đã sửa 21/11 06:46 — xem INC-003.

## INC-002 — Push thẳng lên Qsang_vbook main ngoài muse-main

- **Ngày:** 21/11/2026 14:06. **Chủ sở hữu:** muse-main. **Trạng thái:** MỞ.
- **Lời khẳng định vs thực tế:** tài khoản Vitbupdk đẩy thẳng lên main một
  loạt nguồn video (HH3D cùng KKPhim, HHPanda, HHTQ 4K, HHTQ tối giản),
  registry 130 → 135. Quy tắc §4: chỉ muse-main được merge lên main.
- **Ảnh hưởng:** bản HH3D của muse-main (đã test Play ok trên máy Anh) chưa
  kịp merge thì main đã có bản khác; chưa rõ loạt bản mới có chạy thật không.
- **Cách sửa:** muse-main kiểm chứng cả loạt bản mới trên máy Anh trước khi
  quyết (không merge chồng bản của mình lên); hỏi Anh xem loạt này có phải
  Anh bảo Antigravity làm không.
- **Kiểm chứng lại:** chưa xong — đóng case khi đã xác nhận từng nguồn trong
  loạt mới chạy/không chạy và ghi rõ vào task/STATUS.md.

## INC-003 — Watchdog báo nhầm task "claimed kẹt"

- **Ngày:** 21/11/2026 12:14 (task 183, Ú). **Chủ sở hữu:** muse-main.
  **Trạng thái:** ĐÃ ĐÓNG (đang theo dõi).
- **Lời khẳng định vs thực tế:** hook watch báo task 183 "claimed kẹt 34
  phút" trong khi Ú đã commit xong 2 phút sau claim (11:39:48 research +
  11:39:53 review); task file trên main chưa đồng bộ branch nên main vẫn
  ghi `claimed`.
- **Ảnh hưởng:** đánh thức vô ích; suýt kết luận sai là worker kẹt.
- **Cách sửa:** VA 21/11 trong `scripts/watch-tasks.sh` — trước khi kết
  luận kẹt, kiểm tra commit trên branch của worker; có commit sau
  `claimed_at` thì không báo.
- **Kiểm chứng lại:** các lần quét sau không còn báo nhầm kiểu này; nếu tái
  diễn thì mở case mới, không sửa lại mục này.

## INC-004 — Mẫu pattern "nói xong ≠ xong" (ngoài team, ghi làm gương)

- **Ngày:** 02/11/2026 (chat chính). **Chủ sở hữu:** muse-main.
  **Trạng thái:** ĐÃ ĐÓNG (thành quy tắc §11.1).
- **Lời khẳng định vs thực tế:** Muse báo với Anh là đã đổi giọng nói, thực
  ra chưa đổi — Anh bắt lỗi.
- **Ảnh hưởng:** mất tin tưởng vào câu "xong rồi" nếu không có bằng chứng.
- **Cách sửa:** nguyên tắc vàng §11.1 — "xong" = bằng chứng đọc lại từ hệ
  thống thật; gate bằng chứng §11.2.
- **Kiểm chứng lại:** áp dụng từ task tiếp theo; lần nào muse-main phát
  hiện worker báo xong ảo thì mở case mới theo mẫu này.
