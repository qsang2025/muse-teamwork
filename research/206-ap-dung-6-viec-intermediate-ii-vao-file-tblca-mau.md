# Áp dụng 6 việc Intermediate II vào file TblCa mẫu — Báo cáo task 206 (WIP)

- **Task:** 206-ap-dung-6-viec-intermediate-ii-vao-file-tblca-mau (build, repo muse-teamwork, branch `feature/206-ap-dung-6-viec-intermediate-ii-vao-file-tblca-mau`)
- **Người làm:** muse-1 (Ú) — claim 21/11/2026 19:25:22+07:00 (commit claim 00b3828 trên main)
- **Nối tiếp:** 205 Excel Skills for Business: Intermediate II (done 21/11 19:18, review 8/10) mục 8 — 6 việc áp dụng; 204 Intermediate I (TblCa, COUNTIFS); 179 Essentials (bảng OEE 5 ca mục 4.3 + ví dụ OEE 1 ca mục 2.4)
- **Phạm vi (theo notes task):** CHỈ số liệu minh họa của 179/204/205 — KHÔNG dùng dữ liệu thật của nhà máy, KHÔNG ghi danh/không mua gì, KHÔNG bật macro trên máy nhà máy, file `.xlsx` (KHÔNG `.xlsm`)
- **File đích:** `~/workspace/your_files/TblCa-mau-OEE-Intermediate-II.xlsx`

## Quét chống trùng (PROTOCOL §3) — 21/11/2026

- **Repo đích (muse-teamwork, research/):** grep `TblCa-mau` / `206-ap-dung` trong research/ không có file nào trước task này. Không trùng.
- **Tasks claimed/doing/review/open:** chỉ có 206 (claimed, muse-1, task này) + 199 (open, preferred_assignee muse-2 — không đụng, không claim). Không có task muse-1 nào khác đang claimed/doing. Không trùng việc.
- **STATUS.md / ROADMAP:** repo không có `ROADMAP.md` (PROTOCOL §3.3: ROADMAP local của muse-main không phải nguồn chống trùng cho muse-1/muse-2 — dùng STATUS.md thay thế). STATUS.md dòng 5 ghi đúng task 206 (open, muse-1) và dòng 3 ghi bối cảnh 205 done → giao 206. Không mở lại site/khóa đã đóng nào.
- **File đích:** `~/workspace/your_files/` chưa có file TblCa nào trước task này.
- **Hub:** `/health` trả ok:true ngày 21/11/2026, service systemd đang active — chi tiết hạ tầng không ghi vào notes theo PROTOCOL §8.

## Kế hoạch file mẫu (6 việc mục 8 của 205)

| # | Việc (205 mục 8) | Cách làm trong file mẫu |
|---|---|---|
| 1 | Validation TblCa | Máy/Ca List, Sản lượng ≥ 0, Thời gian dừng 0–480, Ngày trong tháng 11/2026 |
| 2 | Nhãn OEE nested IF | Đỏ <60%, Vàng 60–70%, Xanh ≥70%, trống = Chưa xác định |
| 3 | Bảng tra TblTocDo + lookup | M1 25 / M2 20 / M3 30 thùng/phút; cột Tốc độ chuẩn bằng INDEX/MATCH (XLOOKUP ghi tương đương cho Excel 365) |
| 4 | Khóa cột công thức | Chỉ mở cột nhập liệu, không đặt mật khẩu khi chưa có quy định |
| 5 | Goal Seek + Data Table | Goal Seek OEE 70% (~8.572 thùng/ca) + bảng nhạy cảm theo thời gian dừng 30/60/90 |
| 6 | Macro Cuối ca | CHỈ ghi các bước + ghi chú chính sách macro nhà máy là Chưa xác định — không macro thật, không .xlsm |

Số liệu 5 ca (OEE 72,1% – 68,6% – 59,3% – 71,4% – 63,8% của 179 mục 4.3) và ví dụ 1 ca gốc (kế hoạch 480, dừng 60, chạy 420, sản lượng 8.400, tốc độ 25, chuẩn 10.500, phế 168) lấy từ 179; chi tiết tính lại từng công thức sẽ ghi ở bản hoàn chỉnh sau khi dựng + kiểm chứng file bằng LibreOffice recalc.

_(WIP — commit tiến độ đầu tiên theo PROTOCOL §2.4; bản hoàn chỉnh thay thế file này trước khi nộp review.)_
