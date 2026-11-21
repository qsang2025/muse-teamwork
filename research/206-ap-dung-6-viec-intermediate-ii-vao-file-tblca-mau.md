# Áp dụng 6 việc Intermediate II vào file TblCa mẫu — Báo cáo task 206

- **Task:** 206-ap-dung-6-viec-intermediate-ii-vao-file-tblca-mau (build, repo muse-teamwork, branch `feature/206-ap-dung-6-viec-intermediate-ii-vao-file-tblca-mau`)
- **Người làm:** muse-1 (Ú) — claim 21/11/2026 19:25:22+07:00 (commit claim `00b3828` trên main), WIP quét chống trùng `e8ffb62`, WIP script dựng file `19a7bf8`
- **Nối tiếp:** 205 Excel Skills for Business: Intermediate II (done 21/11 19:18, review 8/10) mục 8 — 6 việc áp dụng; 204 Intermediate I (TblCa, COUNTIFS/AVERAGEIFS); 179 Essentials (bảng OEE 5 ca mục 4.3 + ví dụ OEE 1 ca mục 2.4)
- **Phạm vi (theo notes task):** CHỈ số liệu minh họa của 179/204/205 — KHÔNG dùng dữ liệu thật của nhà máy, KHÔNG ghi danh/không mua gì, KHÔNG bật macro trên máy nhà máy, file `.xlsx` (KHÔNG `.xlsm`)
- **File đích:** `~/workspace/your_files/TblCa-mau-OEE-Intermediate-II.xlsx` (20 KB, 6 sheet, không chứa macro — kiểm chứng bằng danh sách file trong gói .xlsx: không có `vbaProject`, ngày 21/11/2026)
- **Script dựng file (tái lập được):** `research/206-build-tblca.py` — chạy `python3 research/206-build-tblca.py` là ghi lại đúng file đích

## Quét chống trùng (PROTOCOL §3) — 21/11/2026

- **Repo đích (muse-teamwork, research/):** grep `TblCa-mau` / `206-ap-dung` trong research/ không có file nào trước task này (ngoài bản WIP của chính task này, commit `e8ffb62`). Không trùng.
- **Tasks claimed/doing/review/open:** chỉ có 206 (task này, muse-1) + 199 (open, preferred_assignee muse-2 — không đụng, không claim). Không có task muse-1 nào khác đang claimed/doing. Không trùng việc.
- **STATUS.md / ROADMAP:** repo không có `ROADMAP.md` (PROTOCOL §3.3: ROADMAP local của muse-main không phải nguồn chống trùng cho muse-1/muse-2 — dùng STATUS.md thay thế). STATUS.md ghi đúng task 206 và bối cảnh 205 done → giao 206. Không mở lại site/khóa đã đóng nào.
- **File đích:** `~/workspace/your_files/` chưa có file TblCa nào trước task này.
- **Hub:** `/health` trả ok:true ngày 21/11/2026, service systemd đang active — chi tiết hạ tầng không ghi vào notes theo PROTOCOL §8.

## Cấu trúc file mẫu (6 sheet)

| Sheet | Nội dung | Việc tương ứng |
|---|---|---|
| `README` | Hướng dẫn dùng, bản đồ 6 việc → sheet/ô, danh sách công thức (dạng A1 trong file + dạng structured tương đương), giới hạn trung thực, nguồn số minh họa | — |
| `TblCa` | Table `TblCa` 15 cột × 5 ca mẫu, validation, nhãn OEE, lookup, khóa công thức, tô màu OEE, in ngang A4 (Print Area A1:O6, lặp hàng tiêu đề) | 1, 2, 3, 4 |
| `TblTocDo` | Table `TblTocDo` (M1 25 / M2 20 / M3 30 thùng/phút) + bảng kiểm chứng lookup 10.500/9.000/12.000 bằng công thức sống | 3 |
| `MoHinh` | Mô hình OEE 1 ca sẵn sàng Goal Seek + đáp án giải tích + bảng nhạy cảm thời gian dừng 30/60/90 + hướng dẫn chạy Goal Seek/Data Table gốc của Excel | 5 |
| `Macro_CuoiCa` | 5 bước macro Cuối ca dạng tài liệu + cảnh báo Absolute/Relative + an ninh macro. **Không có macro thật** | 6 |
| `KiemChung` | 17 hạng mục tính lại bằng công thức sống, đối chiếu cột kỳ vọng của 179/204/205 | Kiểm chứng |

## Việc 1 — Data Validation cho TblCa (205 tuần 1)

Áp cho vùng nhập A2:G100 (5 ca mẫu + chỗ nhập thêm), mọi luật đều có Input Message + Error Alert mức **Stop**:

| Cột | Luật | Thông điệp lỗi |
|---|---|---|
| Ngày (A) | Date từ 01/11/2026 đến 30/11/2026 (`DATE(2026,11,1)`–`DATE(2026,11,30)`) | "Ngày phải nằm trong tháng minh họa 11/2026…" |
| Máy (B) | List `M1,M2,M3` | "Chỉ chọn M1, M2 hoặc M3 (bảng tra TblTocDo)." |
| Ca (C) | List `Ca1,Ca2,Ca3` | "Chỉ chọn Ca1, Ca2 hoặc Ca3." |
| Sản lượng (D), Phế phẩm (E) | Whole number ≥ 0 | "Sản lượng phải là số nguyên >= 0." |
| Thời gian dừng (F) | Decimal từ 0 đến 480 | "Thời gian dừng phải từ 0 đến 480 phút…" |
| Thời gian kế hoạch (G) | Whole number từ 1 đến 1440 (mặc định nhập 480) | "Thời gian kế hoạch phải từ 1 đến 1440 phút." |

Ghi rõ hai điểm trung thực: (1) tháng 11/2026 là **tháng minh họa** — 205 chỉ nói "Ngày trong tháng" mà không nêu tháng cụ thể; dùng tháng khác thì sửa luật ở Data > Data Validation (hướng dẫn trong README). (2) Luật Phế phẩm ≥ 0 và Kế hoạch 1–1440 là luật bổ sung cùng tinh thần Việc 1 (task chỉ liệt kê 4 luật Máy/Ca/Sản lượng/Dừng/Ngày) — ghi rõ để muse-main biết phần nào là bổ sung.

## Việc 2 + 3 + 4 — Công thức TblCa, lookup, khóa công thức (205 tuần 2–4)

Cột nhập liệu A–G (nền vàng nhạt, **mở khóa**): Ngày, Máy, Ca, Sản lượng, Phế phẩm, Thời gian dừng, Thời gian kế hoạch.
Cột công thức H–O (nền xanh nhạt, **khóa**; sheet bật Protect Sheet **không mật khẩu** — kiểm chứng: `protection.sheet=True`, không có mật khẩu, ngày 21/11/2026):

| Cột | Công thức trong file (dạng A1, dòng 2 làm mẫu) | Dạng structured tương đương (205 mục 2–3) |
|---|---|---|
| Thời gian chạy (H) | `=$G2-$F2` | `=[@ThoiGianKeHoach]-[@ThoiGianDung]` |
| Tốc độ chuẩn (I) | `=IFERROR(INDEX(TblTocDo!$B$2:$B$4,MATCH($B2,TblTocDo!$A$2:$A$4,0)),"Chưa xác định")` | `=INDEX(TblTocDo[TocDo],MATCH([@May],TblTocDo[May],0))`; Excel 365: `=XLOOKUP([@May],TblTocDo[May],TblTocDo[TocDo],"Chưa xác định")` |
| Sản lượng chuẩn (J) | `=IF($I2="Chưa xác định","Chưa xác định",$I2*$H2)` | `=[@TocDoChuan]*[@ThoiGianChay]` |
| Availability (K) | `=IFERROR($H2/$G2,"Chưa xác định")` | `=[@ThoiGianChay]/[@ThoiGianKeHoach]` |
| Performance (L) | `=IFERROR($D2/$J2,"Chưa xác định")` | `=[@SanLuong]/[@SanLuongChuan]` |
| Quality (M) | `=IFERROR(($D2-$E2)/$D2,"Chưa xác định")` | `=([@SanLuong]-[@PhePham])/@SanLuong` |
| OEE (N) | `=IFERROR($K2*$L2*$M2,"Chưa xác định")` | `=[@Availability]*[@Performance]*[@Quality]` |
| Nhãn OEE (O) | `=IF(OR($N2="",$N2="Chưa xác định"),"Chưa xác định",IF($N2<0.6,"Đỏ",IF($N2<0.7,"Vàng","Xanh")))` | `=IF([@OEE]="","Chưa xác định",IF([@OEE]<60%,"Đỏ",IF([@OEE]<70%,"Vàng","Xanh")))` (205 mục 2) |

**Vì sao file dùng dạng A1 thay vì structured reference:** đã kiểm chứng thực nghiệm ngày 21/11/2026 — file thử dùng `INDEX(TblTocDo[TocDo],MATCH([@May],…))` khi cho LibreOffice 24.2 tính lại trả `#N/A` (LibreOffice không tính structured reference của Excel), trong khi dạng A1 tính đúng ở cả Excel và LibreOffice (M1 → 25 → 10.500; M2 → 20 → 9.000). Task chỉ yêu cầu "bằng INDEX/MATCH (XLOOKUP nếu Excel 365)" nên dạng A1 vẫn đúng yêu cầu; dạng structured ghi kèm trong README + bảng trên để chuyển đổi khi cần. Excel vẫn tự điền công thức nhất quán khi thêm dòng vào Table.

Thêm: cột OEE tô màu có điều kiện theo ngưỡng 179 (Đỏ <60%, Vàng 60–<70%, Xanh ≥70%); OEE/A/P/Q hiển thị % 1 thập phân, sản lượng số nguyên phân cách nghìn, ngày `dd/mm/yyyy` (179 module 3). IFERROR chỉ bọc ở ô tính/tổng hợp — số gốc sai vẫn phải sửa tận gốc (179 mục 2.4).

**Số liệu 5 ca — nguồn và cách dựng (ghi rõ để không hiểu nhầm là số gốc):** 179 mục 4.3 / 204 mục 4 chỉ cho OEE đích của 5 ca (72,1% – 68,6% – 59,3% – 71,4% – 63,8%), không cho đầu vào từng ca — trừ ca 68,6% có đủ đầu vào ở 179 mục 2.4 (kế hoạch 480, dừng 60, chạy 420, sản lượng 8.400, tốc độ 25, chuẩn 10.500, phế 168). Đầu vào 4 ca còn lại do Ú **chọn ngược** (giữ kế hoạch 480, Quality ≈98%, đổi Máy/Dừng/Sản lượng) để OEE tính ra khớp đích ở 1 thập phân. Phế phẩm là số nguyên thùng nên Quality lệch tối đa 0,01 điểm % khỏi 98,00% — OEE vẫn khớp đích ở 1 thập phân (xem bảng kiểm chứng).

## Việc 5 — Goal Seek + Data Table (205 tuần 5, sheet MoHinh)

Mô hình 1 ca ở điều kiện 179 (B4 kế hoạch 480, B5 dừng 60, B6 chạy `=B4-B5`, B7 máy M1, B8 tốc độ INDEX/MATCH, B9 chuẩn, B10 sản lượng hiện tại 8.400, B11 phế 168, B12–B15 Availability/Performance/Quality/OEE, B16 mục tiêu 70%):

- **Đáp án giải tích trong file (công thức sống):** Performance cần `=B16/(B12*B14)` = **81,6327%** (hiển thị 81,63%); Sản lượng cần `=B17*B9` = **8.571,43**; làm tròn lên `=ROUNDUP(B18,0)` = **8.572 thùng/ca**; còn thiếu `=B19-B10` = **172 thùng** — khớp 205 mục 5 (81,63%, ~8.572, thiếu ~172).
- **Cách chạy Goal Seek gốc (ghi trong file):** Data > What-If Analysis > Goal Seek — Set cell `$B$15` (OEE), To value 70%, By changing cell `$B$10`. Goal Seek ghi đè B10 nên chạy trên bản sao hoặc Ctrl+Z; đáp án giải tích B17–B20 để đối chiếu mà không đổi đầu vào.
- **Bảng nhạy cảm (công thức trực tiếp):** Availability `=(B4−Dừng)/B4` cho dừng 30/60/90 → **93,75% / 87,50% / 81,25%** — khớp 205 mục 5; mỗi 30 phút dừng thêm tốn 6,25 điểm Availability. Cột OEE minh họa (73,50% / 68,60% / 63,70%) giữ Performance 80% + Quality 98% cố định — **giả định ghi rõ trong file, không phải số của 205** (205 chỉ khẳng định cột Availability). Hướng dẫn tạo bằng Data Table gốc (Column input cell `$B$5`) ghi trong file; bảng trong file dùng công thức trực tiếp để LibreOffice cũng tính được — kết quả tương đương.

Giới hạn ghi rõ: Goal Seek/Data Table gốc là thao tác chạy tay trong Excel — file `.xlsx` không tự chạy chúng (và không nên giả vờ đã chạy). File giao mô hình + đáp án giải tích + bảng tương đương để Anh/muse-main chạy lại trong 1 phút.

## Việc 6 — Macro Cuối ca (205 tuần 6, sheet Macro_CuoiCa)

Chỉ ghi 5 bước dạng tài liệu: (1) Refresh All, (2) về sheet dashboard/TblCa ô A1, (3) đặt Slicer về kỳ hiện tại (chỉ khi đã dựng PivotTable theo 204 — file mẫu này chưa dựng PivotTable, ghi bước để nối sau), (4) Print Preview kiểm tra Print Area rồi in, (5) lưu `.xlsx`. Kèm cảnh báo Absolute vs Relative Reference + an ninh macro của 205 mục 6. **Chính sách macro của nhà máy: Chưa xác định** — file không chứa macro, không lưu `.xlsm`, không đề xuất bật macro trên máy nhà máy.

## Kiểm chứng — tính lại toàn bộ, 17/17 PASS (21/11/2026)

**Phương pháp (hai đường độc lập):** (1) tính tay bằng Python từ đầu vào trước khi dựng file; (2) cho LibreOffice 24.2.7 headless tính lại file `.xlsx` đã dựng rồi đọc giá trị đã tính (file gốc bật `fullCalcOnLoad` nên Excel cũng tính lại khi mở). Hai đường cho cùng kết quả; bảng dưới là số LibreOffice tính ra từ chính file đích.

**Bảng 5 ca tính lại (TblCa):**

| Ca mẫu | Máy/Dừng | Chạy | Chuẩn | Availability | Performance | Quality | OEE tính ra | OEE hiển thị (1 tp) | Nhãn | Đích 179/204 |
|---|---|---|---|---|---|---|---|---|---|---|
| 03/11 Ca1 (SL 8.827, phế 177) | M1 / 30 | 450 | 11.250 | 93,75% | 78,46% | 97,99% | 72,0833% | **72,1%** | Xanh | 72,1% ✓ |
| 03/11 Ca2 (SL 8.400, phế 168) — ca gốc 179 | M1 / 60 | 420 | 10.500 | 87,50% | 80,00% | 98,00% | 68,6000% | **68,6%** | Vàng | 68,6% ✓ |
| 04/11 Ca1 (SL 5.808, phế 116) | M2 / 90 | 390 | 7.800 | 81,25% | 74,46% | 98,00% | 59,2917% | **59,3%** | Đỏ | 59,3% ✓ |
| 04/11 Ca2 (SL 10.493, phế 210) | M3 / 40 | 440 | 13.200 | 91,67% | 79,49% | 98,00% | 71,4097% | **71,4%** | Xanh | 71,4% ✓ |
| 05/11 Ca3 (SL 6.250, phế 125) | M2 / 60 | 420 | 8.400 | 87,50% | 74,40% | 98,00% | 63,8021% | **63,8%** | Vàng | 63,8% ✓ |

**17 hạng mục ở sheet KiemChung (file tính → kỳ vọng):** Đỏ 1→1 ✓, Vàng 2→2 ✓, Xanh 2→2 ✓, COUNTIFS <60% 1→1 ✓, COUNTIFS 60–<70% 2→2 ✓, AVERAGEIFS ≥70% 71,7465%→71,75% ở 2 thập phân ✓ (204 mục 4 ghi 71,75% từ số đã làm tròn 72,1/71,4; file tính từ OEE chưa làm tròn nên khớp ở 2 thập phân, lệch 0,0035 điểm % ở độ chính xác đầy đủ — ghi rõ, không giấu), lookup M1 10.500 ✓ / M2 9.000 ✓ / M3 12.000 ✓ (205 mục 3), OEE ca gốc 68,60% ✓ (179 mục 2.4), Performance cần 81,6327%→81,63% ✓, sản lượng cần 8.572 ✓, còn thiếu 172 ✓ (205 mục 5), Availability 93,75%/87,50%/81,25% ✓ (205 mục 5), nhãn khi trống "Chưa xác định" ✓ (205 mục 2).

**Kiểm tra cấu trúc file (openpyxl, 21/11/2026):** 6 sheet đúng thứ tự README/TblCa/TblTocDo/MoHinh/Macro_CuoiCa/KiemChung; 2 Table (`TblCa` A1:O6, `TblTocDo` A1:B4); 6 luật validation đúng vùng; cột nhập mở khóa/cột công thức khóa đúng (mẫu kiểm tra A2 mở, H2 khóa); Protect Sheet bật ở TblCa/TblTocDo/MoHinh, không mật khẩu; không có `vbaProject` (không macro); `fullCalcOnLoad=True`.

**Chưa kiểm chứng được bằng máy ở lượt này (ghi rõ):** thao tác tay trong Excel (bấm Goal Seek, tạo Data Table gốc, thử gõ sai để xem validation chặn, thử sửa ô khóa) — cần Anh/muse-main mở bằng Excel kiểm tra trực tiếp; logic công thức đã được LibreOffice tính lại toàn bộ nên rủi ro còn lại là khác biệt hành vi giao diện Excel, không phải sai số học.

## Giới hạn trung thực

- File vẫn là Excel do người nhập: validation chặn gõ tay nhưng **paste vẫn lọt** (rà bằng Circle Invalid Data), khóa không mật khẩu chỉ chống sửa nhầm, IFERROR không sửa được số gốc sai (205 mục 7, Đề xuất).
- Đầu vào 4/5 ca là số **dựng ngược** để khớp OEE đích của 179/204 (179/204 không công bố đầu vào từng ca) — dùng để kiểm chứng công thức, không được trích dẫn như số gốc của 179.
- Goal Seek/Data Table gốc chưa chạy trong Excel ở lượt này (mô hình + đáp án giải tích + bảng tương đương đã sẵn sàng); PivotTable/Slicer/Dashboard của 204 chưa dựng trong file này (ngoài phạm vi 6 việc của 205 mục 8) nên bước 3 của macro Cuối ca mới là bước chờ nối.
- Tháng validation 11/2026 là tháng minh họa; chính sách mật khẩu file + chính sách macro của nhà máy đều **Chưa xác định**.

## Đề xuất tiếp theo cho team

- Sau 206 mới quyết bước Excel tiếp theo — **Advanced (khóa 4/4)** hay **Power Tools (Power Query/Power Pivot)** — theo đúng notes task; quyết định cần muse-main/Anh, báo cáo không tự tạo task (giữ nguyên đề xuất (c) rồi (b) của 205: áp dụng vào file thật trước, Power Tools khi việc gộp file thành nút thắt).
- Nếu Anh muốn dùng file mẫu cho tháng thật: đổi luật validation Ngày sang tháng dùng, thay 5 ca mẫu bằng ca thật (giữ nguyên cột công thức), và quyết chính sách mật khẩu/macro trước khi bật bất kỳ macro nào.

## Nguồn tham khảo

- Báo cáo 205 (Excel Intermediate II): `research/205-tu-hoc-excel-skills-for-business-intermediate-ii.md` — mục 1 (validation TblCa), mục 2 (nhãn nested IF, bảng 5 ca), mục 3 (TblTocDo M1 25/M2 20/M3 30, lookup 10.500/9.000/12.000), mục 4 (khóa công thức, không mật khẩu khi chưa có quy định), mục 5 (Goal Seek 81,63%/8.572/thiếu 172, Data Table 93,75%/87,50%/81,25%), mục 6 (macro Cuối ca, chính sách Chưa xác định), mục 8 (6 việc)
- Báo cáo 204 (Excel Intermediate I): `research/204-tu-hoc-excel-skills-for-business-intermediate-i.md` — mục 4 (COUNTIFS 1/2, AVERAGEIFS 71,75%), mục 5 (TblCa Table + structured reference)
- Báo cáo 179 (Excel Essentials): `research/179-excel-skills-for-business-essentials.md` — mục 2.4 (ví dụ OEE 1 ca: 480/60/420/8.400/25/10.500/168 → 68,6%), mục 4.3 (bảng OEE 5 ca 72,1/68,6/59,3/71,4/63,8 + ngưỡng Đỏ/Vàng/Xanh)
- Script + file kết quả: `research/206-build-tblca.py`, `~/workspace/your_files/TblCa-mau-OEE-Intermediate-II.xlsx` — kiểm chứng LibreOffice 24.2.7 headless recalc + openpyxl structure check, 21/11/2026 (17/17 PASS, chi tiết ở mục Kiểm chứng)
