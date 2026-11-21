#!/usr/bin/env python3
"""Task 206 — Dựng file TblCa mẫu OEE Intermediate II (.xlsx, không macro).

Số liệu minh họa lấy từ báo cáo 179/204/205 (KHÔNG phải số thật nhà máy):
- Bảng OEE 5 ca: 72,1% – 68,6% – 59,3% – 71,4% – 63,8% (179 mục 4.3, 204 mục 4)
- Ca mẫu đầy đủ: kế hoạch 480, dừng 60, chạy 420, sản lượng 8.400,
  tốc độ chuẩn 25 -> chuẩn 10.500, phế phẩm 168 (179 mục 2.4)
- TblTocDo: M1 25 / M2 20 / M3 30 thùng/phút (205 mục 3)
- Goal Seek OEE 70% -> cần ~8.572 thùng/ca (205 mục 5)
- Data Table: dừng 30/60/90 -> Availability 93,75%/87,50%/81,25% (205 mục 5)

Công thức trong file dùng dạng A1 (INDEX/MATCH + tham chiếu tuyệt đối) để
Excel và LibreOffice đều tính được và kiểm chứng lại bằng máy được.
Dạng structured reference tương đương của 205 được ghi trong README/báo cáo.

Chạy: python3 research/206-build-tblca.py
Kết quả: ~/workspace/your_files/TblCa-mau-OEE-Intermediate-II.xlsx
"""
from datetime import date
from pathlib import Path

from openpyxl import Workbook
from openpyxl.formatting.rule import CellIsRule
from openpyxl.styles import Alignment, Font, PatternFill, Protection
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.datavalidation import DataValidation
from openpyxl.worksheet.table import Table, TableStyleInfo

OUT = Path.home() / "workspace/your_files/TblCa-mau-OEE-Intermediate-II.xlsx"

HDR_FONT = Font(bold=True, color="FFFFFF")
HDR_FILL = PatternFill("solid", fgColor="4472C4")
TITLE_FONT = Font(bold=True, size=13)
SEC_FONT = Font(bold=True, size=11)
INPUT_FILL = PatternFill("solid", fgColor="FFF2CC")   # vàng nhạt: cột nhập liệu
FORMULA_FILL = PatternFill("solid", fgColor="DDEBF7")  # xanh nhạt: cột công thức
UNLOCKED = Protection(locked=False)
LOCKED = Protection(locked=True)

FMT_DATE = "dd/mm/yyyy"
FMT_INT = '#,##0'
FMT_PCT1 = "0.0%"
FMT_PCT2 = "0.00%"


def style_header(ws, row, ncols):
    for c in range(1, ncols + 1):
        cell = ws.cell(row=row, column=c)
        cell.font = HDR_FONT
        cell.fill = HDR_FILL
        cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)


def protect_no_password(ws):
    """Bật Protect Sheet KHÔNG mật khẩu (task 206 việc 4: chưa có quy định
    mật khẩu của nhà máy nên không đặt mật khẩu; khóa chỉ chống sửa nhầm)."""
    ws.protection.sheet = True
    # Không gán password: mặc định openpyxl là không mật khẩu (gán None sẽ lỗi hash).
    ws.protection.formatCells = False
    ws.protection.formatColumns = False
    ws.protection.formatRows = False
    ws.protection.insertRows = False
    ws.protection.insertColumns = True
    ws.protection.deleteRows = False
    ws.protection.deleteColumns = True
    ws.protection.sort = False
    ws.protection.autoFilter = False


wb = Workbook()

# ---------------------------------------------------------------- README
ws = wb.active
ws.title = "README"
ws.sheet_properties.pageSetUpPr.fitToPage = True
ws.page_setup.orientation = "portrait"
ws.page_setup.fitToWidth = 1
ws.page_setup.fitToHeight = 0
ws.column_dimensions["A"].width = 118
readme = [
    ("TblCa mẫu OEE — Intermediate II (task 206)", TITLE_FONT),
    ("File mẫu áp dụng 6 việc mục 8 của báo cáo 205 (Excel Skills for Business: Intermediate II) "
     "lên số liệu MINH HỌA của báo cáo 179/204/205. Đây KHÔNG phải số liệu thật của dây chuyền. "
     "File .xlsx, không chứa macro.", None),
    ("", None),
    ("6 việc nằm ở đâu trong file", SEC_FONT),
    ("Việc 1 — Data Validation (sheet TblCa): Máy chọn List M1/M2/M3; Ca chọn List Ca1/Ca2/Ca3; "
     "Sản lượng số nguyên >= 0; Phế phẩm số nguyên >= 0; Thời gian dừng thập phân 0–480; "
     "Thời gian kế hoạch số nguyên 1–1440 (mặc định 480); Ngày trong tháng minh họa 01/11/2026–30/11/2026. "
     "Mọi luật đều có Input Message + Error Alert mức Stop. Dùng tháng khác thì sửa luật Ngày: "
     "Data > Data Validation > thẻ Settings.", None),
    ("Việc 2 — Nhãn OEE (sheet TblCa, cột O): nested IF — Đỏ <60%, Vàng 60–<70%, Xanh >=70%, "
     "OEE trống/lỗi = \"Chưa xác định\". Cột OEE (N) còn tô màu có điều kiện theo cùng ngưỡng (179 mục 4.3).", None),
    ("Việc 3 — Lookup tốc độ chuẩn (sheet TblTocDo + TblCa cột I): bảng tra TblTocDo (M1 25, M2 20, M3 30 thùng/phút); "
     "cột Tốc độ chuẩn dùng INDEX/MATCH khớp chính xác, bọc IFERROR trả \"Chưa xác định\" khi không tìm thấy máy. "
     "Excel 365 có thể thay bằng XLOOKUP (công thức tương đương ghi ở cuối sheet này).", None),
    ("Việc 4 — Khóa công thức (sheet TblCa/TblTocDo/MoHinh): cột công thức bị khóa, cột nhập liệu (nền vàng nhạt) "
     "mở khóa; sheet đã bật Protect Sheet KHÔNG mật khẩu (chưa có quy định mật khẩu của nhà máy — Chưa xác định). "
     "Muốn sửa cấu trúc: Review > Unprotect Sheet (không cần mật khẩu). Khi một ô OEE ra số lạ: "
     "Formulas > Trace Precedents truy về ô gốc (205 tuần 4).", None),
    ("Việc 5 — Goal Seek + Data Table (sheet MoHinh): mô hình OEE 1 ca sẵn sàng chạy Goal Seek "
     "(Data > What-If Analysis > Goal Seek) và bảng nhạy cảm theo thời gian dừng 30/60/90. "
     "Ô \"Sản lượng cần (làm tròn lên)\" cho đáp án giải tích 8.572 thùng/ca để đối chiếu kết quả Goal Seek.", None),
    ("Việc 6 — Macro Cuối ca (sheet Macro_CuoiCa): CHỈ ghi các bước + cảnh báo an ninh. File này KHÔNG có macro, "
     "KHÔNG lưu .xlsm. Chính sách macro của nhà máy: Chưa xác định — không bật macro trên máy nhà máy khi chưa rõ.", None),
    ("Sheet KiemChung: tính lại toàn bộ bằng công thức sống (đếm nhãn, lookup, Goal Seek, Data Table) để đối chiếu số của 179/204/205.", None),
    ("", None),
    ("Công thức chính (dạng A1 trong file — Excel/LibreOffice đều tính được)", SEC_FONT),
    ("Thời gian chạy (H) = Thời gian kế hoạch − Thời gian dừng.", None),
    ("Tốc độ chuẩn (I) =IFERROR(INDEX(TblTocDo!$B$2:$B$4,MATCH($B2,TblTocDo!$A$2:$A$4,0)),\"Chưa xác định\")", None),
    ("Sản lượng chuẩn (J) =IF($I2=\"Chưa xác định\",\"Chưa xác định\",$I2*$H2)", None),
    ("Availability (K) =IFERROR($H2/$G2,\"Chưa xác định\")  |  Performance (L) =IFERROR($D2/$J2,\"Chưa xác định\")  |  "
     "Quality (M) =IFERROR(($D2-$E2)/$D2,\"Chưa xác định\")", None),
    ("OEE (N) =IFERROR($K2*$L2*$M2,\"Chưa xác định\")", None),
    ("Nhãn OEE (O) =IF(OR($N2=\"\",$N2=\"Chưa xác định\"),\"Chưa xác định\",IF($N2<0.6,\"Đỏ\",IF($N2<0.7,\"Vàng\",\"Xanh\")))", None),
    ("Dạng structured reference tương đương (205 mục 2–3, dùng khi muốn chuyển hẳn sang cú pháp Table): "
     "Nhãn: =IF([@OEE]=\"\",\"Chưa xác định\",IF([@OEE]<60%,\"Đỏ\",IF([@OEE]<70%,\"Vàng\",\"Xanh\"))); "
     "Lookup: =INDEX(TblTocDo[TocDo],MATCH([@May],TblTocDo[May],0)); "
     "XLOOKUP (Excel 365): =XLOOKUP([@May],TblTocDo[May],TblTocDo[TocDo],\"Chưa xác định\"). "
     "File chọn dạng A1 vì LibreOffice không tính structured reference (kiểm chứng 21/11/2026: trả #N/A) — "
     "dạng A1 tính đúng ở cả hai và Excel vẫn tự điền công thức nhất quán khi thêm dòng vào Table.", None),
    ("", None),
    ("Cách dùng + giới hạn trung thực", SEC_FONT),
    ("Nhập ca mới: gõ tiếp vào dòng ngay dưới Table TblCa (Excel tự mở rộng Table + điền công thức cột H–O; "
     "LibreOffice thì kéo công thức xuống tay). Chỉ nhập cột A–G (nền vàng). Đổi tốc độ chuẩn: sửa 1 ô ở sheet TblTocDo.", None),
    ("Validation chỉ chặn khi gõ tay — dán (paste) vẫn lọt được; rà soát định kỳ bằng Data > Circle Invalid Data (205 tuần 1).", None),
    ("Khóa sheet không mật khẩu chỉ chống sửa nhầm, không phải bảo mật. IFERROR chỉ bọc ở ô hiển thị/tổng hợp — "
     "số gốc sai vẫn phải sửa tận gốc (179 mục 2.4, 205 mục 2).", None),
    ("Locale: công thức lưu dạng chuẩn quốc tế (dấu phẩy phân cách đối số, dấu chấm thập phân); Excel tự hiển thị theo "
     "locale máy (máy Việt Nam thường dùng dấu chấm phẩy + dấu phẩy thập phân). Số trong file hiển thị theo locale máy mở file.", None),
    ("Nguồn số minh họa: 179 mục 2.4 + 4.3, 204 mục 4, 205 mục 2/3/5 (file research/ trong repo muse-teamwork). "
     "Báo cáo kiểm chứng của file này: research/206-ap-dung-6-viec-intermediate-ii-vao-file-tblca-mau.md.", None),
]
r = 1
for text, font in readme:
    c = ws.cell(row=r, column=1, value=text)
    if font:
        c.font = font
    c.alignment = Alignment(wrap_text=True, vertical="top")
    ws.row_dimensions[r].height = 30 if len(text) > 160 else (18 if text else 10)
    r += 1
ws.sheet_properties.pageSetUpPr.fitToPage = True
ws.print_title_rows = "1:1"

# ---------------------------------------------------------------- TblTocDo (tạo trước để TblCa tham chiếu)
wt = wb.create_sheet("TblTocDo")
wt.append(["May", "TocDo"])
for may, toc in [("M1", 25), ("M2", 20), ("M3", 30)]:
    wt.append([may, toc])
style_header(wt, 1, 2)
tab_toc = Table(displayName="TblTocDo", ref="A1:B4")
tab_toc.tableStyleInfo = TableStyleInfo(name="TableStyleMedium9", showRowStripes=True)
wt.add_table(tab_toc)
wt.column_dimensions["A"].width = 12
wt.column_dimensions["B"].width = 14
wt["A1"].comment = None
# Bảng kiểm chứng lookup (205 mục 3): M1 chạy 420 -> 10.500; M2 450 -> 9.000; M3 400 -> 12.000
wt["A6"] = "Kiểm chứng lookup (205 mục 3) — công thức sống, đổi TblTocDo là đổi theo"
wt["A6"].font = SEC_FONT
wt.append([])  # dòng 7 trống (append sau dòng 6? đảm bảo vị trí) — sẽ ghi đè bên dưới cho chắc
headers_kc = ["May", "ThoiGianChay", "TocDoChuan (INDEX/MATCH)", "SanLuongChuan"]
for j, h in enumerate(headers_kc, start=1):
    c = wt.cell(row=7, column=j, value=h)
    c.font = HDR_FONT
    c.fill = HDR_FILL
    c.alignment = Alignment(horizontal="center", wrap_text=True)
kc_rows = [("M1", 420), ("M2", 450), ("M3", 400)]
for i, (may, chay) in enumerate(kc_rows, start=8):
    wt.cell(row=i, column=1, value=may).protection = UNLOCKED
    wt.cell(row=i, column=1).fill = INPUT_FILL
    c2 = wt.cell(row=i, column=2, value=chay)
    c2.protection = UNLOCKED
    c2.fill = INPUT_FILL
    c2.number_format = FMT_INT
    c3 = wt.cell(row=i, column=3, value=f'=IFERROR(INDEX($B$2:$B$4,MATCH($A{i},$A$2:$A$4,0)),"Chưa xác định")')
    c3.protection = LOCKED
    c3.fill = FORMULA_FILL
    c3.number_format = FMT_INT
    c4 = wt.cell(row=i, column=4, value=f'=IF($C{i}="Chưa xác định","Chưa xác định",$C{i}*$B{i})')
    c4.protection = LOCKED
    c4.fill = FORMULA_FILL
    c4.number_format = FMT_INT
wt.column_dimensions["C"].width = 26
wt.column_dimensions["D"].width = 18
for rr in range(2, 5):
    for cc in (1, 2):
        cell = wt.cell(row=rr, column=cc)
        cell.protection = UNLOCKED
        cell.fill = INPUT_FILL
        if cc == 2:
            cell.number_format = FMT_INT
wt.freeze_panes = "A2"
wt.sheet_properties.pageSetUpPr.fitToPage = True
wt.page_setup.orientation = "portrait"
wt.page_setup.fitToWidth = 1
wt.print_area = "A1:D10"
protect_no_password(wt)

# ---------------------------------------------------------------- TblCa
wc = wb.create_sheet("TblCa")
cols = ["Ngay", "May", "Ca", "SanLuong", "PhePham", "ThoiGianDung", "ThoiGianKeHoach",
        "ThoiGianChay", "TocDoChuan", "SanLuongChuan", "Availability", "Performance",
        "Quality", "OEE", "NhanOEE"]
wc.append(cols)
style_header(wc, 1, len(cols))
# 5 ca mẫu: đầu vào chọn để OEE tính ra đúng bảng 5 ca của 179/204 (1 thập phân).
# Dòng 3 là ca mẫu đầy đủ của 179 mục 2.4 (8.400/10.500/420/480/168 -> 68,6% chính xác).
data = [
    (date(2026, 11, 3), "M1", "Ca1", 8827, 177, 30, 480),
    (date(2026, 11, 3), "M1", "Ca2", 8400, 168, 60, 480),
    (date(2026, 11, 4), "M2", "Ca1", 5808, 116, 90, 480),
    (date(2026, 11, 4), "M3", "Ca2", 10493, 210, 40, 480),
    (date(2026, 11, 5), "M2", "Ca3", 6250, 125, 60, 480),
]
for i, (ngay, may, ca, sl, phe, dung, ke) in enumerate(data, start=2):
    vals = [ngay, may, ca, sl, phe, dung, ke]
    for j, v in enumerate(vals, start=1):
        c = wc.cell(row=i, column=j, value=v)
        c.protection = UNLOCKED
        c.fill = INPUT_FILL
    wc.cell(row=i, column=1).number_format = FMT_DATE
    for j in (4, 5, 6, 7):
        wc.cell(row=i, column=j).number_format = FMT_INT
    formulas = {
        8: f"=$G{i}-$F{i}",
        9: f'=IFERROR(INDEX(TblTocDo!$B$2:$B$4,MATCH($B{i},TblTocDo!$A$2:$A$4,0)),"Chưa xác định")',
        10: f'=IF($I{i}="Chưa xác định","Chưa xác định",$I{i}*$H{i})',
        11: f'=IFERROR($H{i}/$G{i},"Chưa xác định")',
        12: f'=IFERROR($D{i}/$J{i},"Chưa xác định")',
        13: f'=IFERROR(($D{i}-$E{i})/$D{i},"Chưa xác định")',
        14: f'=IFERROR($K{i}*$L{i}*$M{i},"Chưa xác định")',
        15: f'=IF(OR($N{i}="",$N{i}="Chưa xác định"),"Chưa xác định",IF($N{i}<0.6,"Đỏ",IF($N{i}<0.7,"Vàng","Xanh")))',
    }
    for j, f in formulas.items():
        c = wc.cell(row=i, column=j, value=f)
        c.protection = LOCKED
        c.fill = FORMULA_FILL
    for j in (8, 9, 10):
        wc.cell(row=i, column=j).number_format = FMT_INT
    for j in (11, 12, 13, 14):
        wc.cell(row=i, column=j).number_format = FMT_PCT1
tab_ca = Table(displayName="TblCa", ref="A1:O6")
tab_ca.tableStyleInfo = TableStyleInfo(name="TableStyleMedium9", showRowStripes=True)
wc.add_table(tab_ca)
widths = [12, 8, 8, 12, 11, 14, 16, 14, 12, 14, 13, 13, 11, 10, 13]
for j, w in enumerate(widths, start=1):
    wc.column_dimensions[get_column_letter(j)].width = w
wc.freeze_panes = "B2"
wc.auto_filter.ref = "A1:O6"
wc.sheet_properties.pageSetUpPr.fitToPage = True
wc.page_setup.orientation = "landscape"
wc.page_setup.paperSize = wc.PAPERSIZE_A4
wc.page_setup.fitToWidth = 1
wc.page_setup.fitToHeight = 1
wc.print_title_rows = "1:1"
wc.print_area = "A1:O6"
wc.oddFooter.center.text = "TblCa mau OEE — Intermediate II (task 206) — so lieu minh hoa 179/204/205 — Trang &P/&N"
wc.oddFooter.center.size = 9

# --- Việc 1: Data Validation cho vùng nhập A2:G100 (chừa chỗ nhập thêm ca) ---
dv_may = DataValidation(type="list", formula1='"M1,M2,M3"', allow_blank=True,
                        showDropDown=False, showErrorMessage=True, showInputMessage=True,
                        errorTitle="Máy không hợp lệ", error="Chỉ chọn M1, M2 hoặc M3 (bảng tra TblTocDo).",
                        promptTitle="Máy", prompt="Chọn mã máy: M1 / M2 / M3.")
dv_may.errorStyle = "stop"
wc.add_data_validation(dv_may)
dv_may.add("B2:B100")

dv_ca = DataValidation(type="list", formula1='"Ca1,Ca2,Ca3"', allow_blank=True,
                       showDropDown=False, showErrorMessage=True, showInputMessage=True,
                       errorTitle="Ca không hợp lệ", error="Chỉ chọn Ca1, Ca2 hoặc Ca3.",
                       promptTitle="Ca", prompt="Chọn ca: Ca1 / Ca2 / Ca3.")
dv_ca.errorStyle = "stop"
wc.add_data_validation(dv_ca)
dv_ca.add("C2:C100")

dv_sl = DataValidation(type="whole", operator="greaterThanOrEqual", formula1="0", allow_blank=True,
                       showErrorMessage=True, showInputMessage=True,
                       errorTitle="Sản lượng không hợp lệ", error="Sản lượng phải là số nguyên >= 0.",
                       promptTitle="Sản lượng", prompt="Nhập sản lượng (thùng), số nguyên >= 0.")
dv_sl.errorStyle = "stop"
wc.add_data_validation(dv_sl)
dv_sl.add("D2:D100")
dv_sl.add("E2:E100")  # Phế phẩm cùng luật >= 0

dv_dung = DataValidation(type="decimal", operator="between", formula1="0", formula2="480", allow_blank=True,
                         showErrorMessage=True, showInputMessage=True,
                         errorTitle="Thời gian dừng không hợp lệ",
                         error="Thời gian dừng phải từ 0 đến 480 phút (không vượt thời gian kế hoạch 1 ca trong ví dụ).",
                         promptTitle="Thời gian dừng", prompt="Nhập thời gian dừng (phút), từ 0 đến 480.")
dv_dung.errorStyle = "stop"
wc.add_data_validation(dv_dung)
dv_dung.add("F2:F100")

dv_ke = DataValidation(type="whole", operator="between", formula1="1", formula2="1440", allow_blank=True,
                       showErrorMessage=True, showInputMessage=True,
                       errorTitle="Thời gian kế hoạch không hợp lệ", error="Thời gian kế hoạch phải từ 1 đến 1440 phút.",
                       promptTitle="Thời gian kế hoạch", prompt="Nhập thời gian kế hoạch (phút), mặc định 480.")
dv_ke.errorStyle = "stop"
wc.add_data_validation(dv_ke)
dv_ke.add("G2:G100")

dv_ngay = DataValidation(type="date", operator="between", formula1="DATE(2026,11,1)", formula2="DATE(2026,11,30)",
                         allow_blank=True, showErrorMessage=True, showInputMessage=True,
                         errorTitle="Ngày ngoài tháng báo cáo",
                         error="Ngày phải nằm trong tháng minh họa 11/2026 (01/11/2026–30/11/2026). Dùng tháng khác thì sửa luật validation.",
                         promptTitle="Ngày", prompt="Nhập ngày trong tháng 11/2026, dạng dd/mm/yyyy.")
dv_ngay.errorStyle = "stop"
wc.add_data_validation(dv_ngay)
dv_ngay.add("A2:A100")

# --- Tô màu có điều kiện cột OEE theo ngưỡng 179 (Đỏ <60%, Vàng 60–<70%, Xanh >=70%) ---
red_fill = PatternFill("solid", fgColor="FFC7CE")
red_font = Font(color="9C0006")
yel_fill = PatternFill("solid", fgColor="FFEB9C")
yel_font = Font(color="9C6500")
grn_fill = PatternFill("solid", fgColor="C6EFCE")
grn_font = Font(color="006100")
wc.conditional_formatting.add("N2:N100", CellIsRule(operator="lessThan", formula=["0.6"], fill=red_fill, font=red_font))
wc.conditional_formatting.add("N2:N100", CellIsRule(operator="between", formula=["0.6", "0.699999"], fill=yel_fill, font=yel_font))
wc.conditional_formatting.add("N2:N100", CellIsRule(operator="greaterThanOrEqual", formula=["0.7"], fill=grn_fill, font=grn_font))

protect_no_password(wc)

# ---------------------------------------------------------------- MoHinh (Việc 5)
wm = wb.create_sheet("MoHinh")
wm.column_dimensions["A"].width = 34
wm.column_dimensions["B"].width = 20
wm.column_dimensions["C"].width = 62
wm["A1"] = "Mô hình OEE 1 ca — Goal Seek + Data Table (205 mục 5)"
wm["A1"].font = TITLE_FONT
wm["A2"] = ("Điều kiện ví dụ của 179 mục 2.4: kế hoạch 480, dừng 60, chạy 420, M1 tốc độ 25 -> chuẩn 10.500, "
            "sản lượng hiện tại 8.400, phế phẩm 168 -> OEE 68,6%. Ô nền vàng là đầu vào (mở khóa), ô nền xanh là công thức (khóa).")
wm["A2"].alignment = Alignment(wrap_text=True, vertical="top")
wm.row_dimensions[2].height = 36

# (nhãn, giá trị/công thức, ghi chú, định dạng, là đầu vào?)
model = [
    ("Thời gian kế hoạch (phút)", 480, "Đầu vào — ví dụ 179", FMT_INT, True),
    ("Thời gian dừng (phút)", 60, "Đầu vào — ô để Data Table thay đổi", FMT_INT, True),
    ("Thời gian chạy (phút)", "=B4-B5", "Công thức: Kế hoạch − Dừng", FMT_INT, False),
    ("Máy", "M1", "Đầu vào — tra TblTocDo", None, True),
    ("Tốc độ chuẩn (thùng/phút)", '=IFERROR(INDEX(TblTocDo!$B$2:$B$4,MATCH($B7,TblTocDo!$A$2:$A$4,0)),"Chưa xác định")',
     "Công thức INDEX/MATCH (Việc 3)", FMT_INT, False),
    ("Sản lượng chuẩn (thùng)", '=IF($B8="Chưa xác định","Chưa xác định",$B8*$B6)', "Công thức: Tốc độ × Thời gian chạy", FMT_INT, False),
    ("Sản lượng hiện tại (thùng)", 8400, "Đầu vào — ô để Goal Seek thay đổi", FMT_INT, True),
    ("Phế phẩm (thùng)", 168, "Đầu vào — ví dụ 179", FMT_INT, True),
    ("Availability", '=IFERROR($B6/$B4,"Chưa xác định")', "Công thức: Chạy / Kế hoạch", FMT_PCT2, False),
    ("Performance", '=IFERROR($B10/$B9,"Chưa xác định")', "Công thức: Thực / Chuẩn", FMT_PCT2, False),
    ("Quality", '=IFERROR(($B10-$B11)/$B10,"Chưa xác định")', "Công thức: (Thực − Phế) / Thực", FMT_PCT2, False),
    ("OEE", '=IFERROR($B12*$B13*$B14,"Chưa xác định")', "Công thức: A × P × Q — ô đích của Goal Seek", FMT_PCT2, False),
    ("OEE mục tiêu", 0.70, "Đầu vào — đích Goal Seek 70% (205 mục 5)", FMT_PCT2, True),
    ("Performance cần để đạt mục tiêu", '=IFERROR($B16/($B12*$B14),"Chưa xác định")',
     "Giải tích: Mục tiêu / (A × Q) — đối chiếu Goal Seek", FMT_PCT2, False),
    ("Sản lượng cần (thùng)", '=IFERROR($B17*$B9,"Chưa xác định")', "Giải tích: Performance cần × Chuẩn", '#,##0.00', False),
    ("Sản lượng cần, làm tròn lên (thùng)", '=IFERROR(ROUNDUP($B18,0),"Chưa xác định")',
     "ROUNDUP — số nguyên thùng phải đạt (kỳ vọng 8.572)", FMT_INT, False),
    ("Còn thiếu so với hiện tại (thùng)", '=IFERROR($B19-$B10,"Chưa xác định")', "Cần (làm tròn) − Hiện tại (kỳ vọng 172)", FMT_INT, False),
]
r0 = 4
for i, (label, val, note, fmt, is_input) in enumerate(model):
    r = r0 + i
    a = wm.cell(row=r, column=1, value=label)
    a.font = Font(bold=True)
    b = wm.cell(row=r, column=2, value=val)
    b.protection = UNLOCKED if is_input else LOCKED
    b.fill = INPUT_FILL if is_input else FORMULA_FILL
    if fmt:
        b.number_format = fmt
    c = wm.cell(row=r, column=3, value=note)
    c.alignment = Alignment(wrap_text=True, vertical="center")
# Kiểm tra địa chỉ ô: B4..B20 khớp công thức trên (r0=4, 17 mục -> 4..20). OEE ở B15? Đếm lại:
# 4 KeHoach,5 Dung,6 Chay,7 May,8 TocDo,9 Chuan,10 SanLuong,11 Phe,12 A,13 P,14 Q,15 OEE,16 MucTieu,17 Pcan,18 SLcan,19 Tron,20 Thieu
# Công thức đã viết theo đúng địa chỉ này.

wm["A22"] = "Cách chạy Goal Seek (Excel): Data > What-If Analysis > Goal Seek — Set cell: $B$15 (OEE), To value: 70%, By changing cell: $B$10 (Sản lượng hiện tại). Goal Seek ghi đè B10 — chạy trên bản sao hoặc Ctrl+Z để hoàn tác. Đáp án giải tích ở B17–B20 phải khớp (Performance cần 81,63%, sản lượng cần 8.571,43 -> 8.572)."
wm["A22"].alignment = Alignment(wrap_text=True, vertical="top")
wm.merge_cells("A22:C22")
wm.row_dimensions[22].height = 48

wm["A24"] = "Data Table nhạy cảm theo thời gian dừng (205 mục 5) — công thức trực tiếp, kết quả tương đương Data Table"
wm["A24"].font = SEC_FONT
for j, h in enumerate(["Thời gian dừng (phút)", "Availability", "OEE minh họa (P=80%, Q=98% cố định)"], start=1):
    c = wm.cell(row=25, column=j, value=h)
    c.font = HDR_FONT
    c.fill = HDR_FILL
    c.alignment = Alignment(horizontal="center", wrap_text=True)
for i, dung in enumerate([30, 60, 90], start=26):
    a = wm.cell(row=i, column=1, value=dung)
    a.protection = UNLOCKED
    a.fill = INPUT_FILL
    a.number_format = FMT_INT
    b = wm.cell(row=i, column=2, value=f"=($B$4-$A{i})/$B$4")
    b.protection = LOCKED
    b.fill = FORMULA_FILL
    b.number_format = FMT_PCT2
    c = wm.cell(row=i, column=3, value=f"=$B{i}*0.8*0.98")
    c.protection = LOCKED
    c.fill = FORMULA_FILL
    c.number_format = FMT_PCT2
wm["A29"] = ("Cách tạo bằng Data Table gốc của Excel: đặt ô góc trên-trái của vùng bảng = ô Availability cần theo dõi (B12), "
             "chọn cả vùng gồm cột thời gian dừng, Data > What-If Analysis > Data Table, Column input cell: $B$5. "
             "Bảng trong file dùng công thức trực tiếp để LibreOffice cũng tính được; số phải khớp 93,75% / 87,50% / 81,25%. "
             "Cột OEE minh họa giữ Performance 80% + Quality 98% cố định (giả định ghi rõ, không phải số của 205) — "
             "205 chỉ khẳng định cột Availability. Mỗi 30 phút dừng thêm tốn 6,25 điểm Availability.")
wm["A29"].alignment = Alignment(wrap_text=True, vertical="top")
wm.merge_cells("A29:C29")
wm.row_dimensions[29].height = 60
wm.freeze_panes = "A3"
wm.sheet_properties.pageSetUpPr.fitToPage = True
wm.page_setup.orientation = "portrait"
wm.page_setup.fitToWidth = 1
wm.print_area = "A1:C29"
protect_no_password(wm)

# ---------------------------------------------------------------- Macro_CuoiCa (Việc 6 — chỉ ghi bước)
wmac = wb.create_sheet("Macro_CuoiCa")
wmac.column_dimensions["A"].width = 10
wmac.column_dimensions["B"].width = 42
wmac.column_dimensions["C"].width = 72
wmac["A1"] = "Macro \"Cuối ca\" — CHỈ ghi các bước (Việc 6). File này KHÔNG chứa macro."
wmac["A1"].font = TITLE_FONT
wmac.merge_cells("A1:C1")
wmac["A2"] = ("Chính sách macro/file .xlsm của nhà máy: Chưa xác định (205 mục 6). Không bật macro trên máy nhà máy, "
              "không lưu .xlsm khi chưa rõ chính sách và chưa có quyết định của Anh/IT. Sheet này là tài liệu bước, không phải macro chạy được.")
wmac["A2"].alignment = Alignment(wrap_text=True, vertical="top")
wmac.merge_cells("A2:C2")
wmac.row_dimensions[2].height = 36
for j, h in enumerate(["Bước", "Thao tác tay hiện tại", "Khi ghi macro (Developer > Record Macro) + lưu ý"], start=1):
    c = wmac.cell(row=3, column=j, value=h)
    c.font = HDR_FONT
    c.fill = HDR_FILL
    c.alignment = Alignment(horizontal="center", wrap_text=True)
steps = [
    ("1", "Data > Refresh All (cập nhật PivotTable/dashboard từ TblCa)",
     "Ghi Absolute Reference — macro luôn refresh toàn workbook, không phụ thuộc vị trí con trỏ."),
    ("2", "Về sheet dashboard/TblCa, đặt con trỏ ô A1",
     "Ghi Absolute (Ctrl+Home) để mọi ca kết thúc ở cùng một chỗ."),
    ("3", "Đặt Slicer Máy/Ca/Tháng về kỳ hiện tại (nếu đã dựng PivotTable theo 204)",
     "Slicer chỉ có sau khi dựng PivotTable (204 tuần 6) — file mẫu này chưa dựng PivotTable, ghi bước để nối sau."),
    ("4", "File > Print Preview, kiểm tra Print Area + tiêu đề lặp, rồi in",
     "Chỉ mở Print Preview, không in thẳng — người trực ca vẫn kiểm tra mắt trước khi in."),
    ("5", "Lưu file (Ctrl+S), giữ định dạng .xlsx",
     "Nếu sau này Anh/IT duyệt macro thật: lưu bản có macro thành .xlsm riêng, chỉ bật macro của file tự ghi/tự kiểm tra (205 mục 6)."),
]
for i, (s, thao, ghi) in enumerate(steps, start=4):
    wmac.cell(row=i, column=1, value=s).alignment = Alignment(horizontal="center", vertical="top")
    c2 = wmac.cell(row=i, column=2, value=thao)
    c2.alignment = Alignment(wrap_text=True, vertical="top")
    c3 = wmac.cell(row=i, column=3, value=ghi)
    c3.alignment = Alignment(wrap_text=True, vertical="top")
    wmac.row_dimensions[i].height = 36
wmac["A9"] = ("Cảnh báo (205 mục 6): Absolute vs Relative Reference là chỗ khó nhất — ghi tuyệt đối hợp cho nút Refresh+Dashboard, "
              "ghi tương đối hợp cho thao tác lặp theo dòng; chọn sai là macro đúng lần đầu, sai từ lần thứ hai. "
              "Macro không sửa được dữ liệu nhập sai — thứ tự đúng: validation (Việc 1) -> lookup (Việc 3) -> khóa công thức (Việc 4) -> macro cuối cùng.")
wmac["A9"].alignment = Alignment(wrap_text=True, vertical="top")
wmac.merge_cells("A9:C9")
wmac.row_dimensions[9].height = 52
wmac.sheet_properties.pageSetUpPr.fitToPage = True
wmac.page_setup.orientation = "landscape"
wmac.page_setup.fitToWidth = 1
wmac.print_area = "A1:C9"

# ---------------------------------------------------------------- KiemChung
wk = wb.create_sheet("KiemChung")
wk.column_dimensions["A"].width = 52
wk.column_dimensions["B"].width = 22
wk.column_dimensions["C"].width = 22
wk.column_dimensions["D"].width = 46
wk["A1"] = "Kiểm chứng — tính lại bằng công thức sống, đối chiếu 179/204/205"
wk["A1"].font = TITLE_FONT
wk.merge_cells("A1:D1")
for j, h in enumerate(["Hạng mục kiểm chứng", "File tính ra", "Kỳ vọng (nguồn)", "Ghi chú"], start=1):
    c = wk.cell(row=2, column=j, value=h)
    c.font = HDR_FONT
    c.fill = HDR_FILL
    c.alignment = Alignment(horizontal="center", wrap_text=True)
checks = [
    ("Số ca Đỏ (NhanOEE)", '=COUNTIF(TblCa!$O$2:$O$6,"Đỏ")', 1, "179 mục 4.3 / 205 mục 2: 1 ca đỏ (59,3%)", FMT_INT),
    ("Số ca Vàng (NhanOEE)", '=COUNTIF(TblCa!$O$2:$O$6,"Vàng")', 2, "179/205: 2 ca vàng (68,6% + 63,8%)", FMT_INT),
    ("Số ca Xanh (NhanOEE)", '=COUNTIF(TblCa!$O$2:$O$6,"Xanh")', 2, "179/205: 2 ca xanh (72,1% + 71,4%)", FMT_INT),
    ("Đếm chéo: COUNTIFS OEE <60%", '=COUNTIFS(TblCa!$N$2:$N$6,"<0.6")', 1, "204 mục 4: =COUNTIFS(OEE,\"<60%\") -> 1", FMT_INT),
    ("Đếm chéo: COUNTIFS OEE 60–<70%", '=COUNTIFS(TblCa!$N$2:$N$6,">=0.6",TblCa!$N$2:$N$6,"<0.7")', 2, "204 mục 4: -> 2", FMT_INT),
    ("AVERAGEIFS OEE >=70%", '=AVERAGEIFS(TblCa!$N$2:$N$6,TblCa!$N$2:$N$6,">=0.7")', 0.7175,
     "204 mục 4: 71,75% (2 thập phân; file tính từ OEE chưa làm tròn nên khớp ở 2 thập phân)", FMT_PCT2),
    ("Lookup M1: sản lượng chuẩn (chạy 420)", "=TblTocDo!$D$8", 10500, "205 mục 3: 25×420 = 10.500", FMT_INT),
    ("Lookup M2: sản lượng chuẩn (chạy 450)", "=TblTocDo!$D$9", 9000, "205 mục 3: 20×450 = 9.000", FMT_INT),
    ("Lookup M3: sản lượng chuẩn (chạy 400)", "=TblTocDo!$D$10", 12000, "205 mục 3: 30×400 = 12.000", FMT_INT),
    ("Ca mẫu 179: OEE (8.400/10.500/420/480/168)", "=TblCa!$N$3", 0.686, "179 mục 2.4: 87,5%×80,0%×98,0% = 68,6%", FMT_PCT2),
    ("Goal Seek: Performance cần (OEE 70%)", "=MoHinh!$B$17", 0.8163, "205 mục 5: 81,63% (hiển thị 2 thập phân)", FMT_PCT2),
    ("Goal Seek: sản lượng cần làm tròn lên", "=MoHinh!$B$19", 8572, "205 mục 5: 8.571,43 -> 8.572 thùng/ca", FMT_INT),
    ("Goal Seek: còn thiếu so với 8.400", "=MoHinh!$B$20", 172, "205 mục 5: thiếu ~172 thùng/ca", FMT_INT),
    ("Data Table: Availability dừng 30", "=MoHinh!$B$26", 0.9375, "205 mục 5: 93,75%", FMT_PCT2),
    ("Data Table: Availability dừng 60", "=MoHinh!$B$27", 0.875, "205 mục 5: 87,50%", FMT_PCT2),
    ("Data Table: Availability dừng 90", "=MoHinh!$B$28", 0.8125, "205 mục 5: 81,25%", FMT_PCT2),
    ("Nhãn khi OEE trống", '=IF($B$20="","Chưa xác định","(có số)")', "Chưa xác định",
     "205 mục 2: trống = Chưa xác định (ô B20 để trống có chủ ý)", None),
]
r = 3
for label, formula, expected, note, fmt in checks:
    wk.cell(row=r, column=1, value=label).alignment = Alignment(wrap_text=True, vertical="center")
    b = wk.cell(row=r, column=2, value=formula)
    b.fill = FORMULA_FILL
    if fmt:
        b.number_format = fmt
    c = wk.cell(row=r, column=3, value=expected)
    if fmt:
        c.number_format = fmt
    d = wk.cell(row=r, column=4, value=note)
    d.alignment = Alignment(wrap_text=True, vertical="center")
    wk.row_dimensions[r].height = 30
    r += 1
wk["A20"] = "Ô trống để kiểm tra quy tắc \"trống = Chưa xác định\" (hàng mục cuối trỏ vào B20):"
wk["A20"].alignment = Alignment(wrap_text=True, vertical="center")
# B20 cố ý để trống
wk["A21"] = ("Cách đọc: cột \"File tính ra\" là công thức sống — sửa đầu vào ở TblCa/TblTocDo/MoHinh là cột này đổi theo. "
             "Nếu mở file mà thấy 0 hoặc chưa tính: Excel bấm Formulas > Calculate Now (F9); LibreOffice bấm Ctrl+Shift+F9. "
             "Chi tiết tính lại từng công thức: research/206-ap-dung-6-viec-intermediate-ii-vao-file-tblca-mau.md.")
wk["A21"].alignment = Alignment(wrap_text=True, vertical="top")
wk.merge_cells("A21:D21")
wk.row_dimensions[21].height = 48
wk.freeze_panes = "A3"
wk.sheet_properties.pageSetUpPr.fitToPage = True
wk.page_setup.orientation = "landscape"
wk.page_setup.fitToWidth = 1
wk.print_area = "A1:D21"

# Thứ tự sheet: README, TblCa, TblTocDo, MoHinh, Macro_CuoiCa, KiemChung
wb._sheets = [wb["README"], wb["TblCa"], wb["TblTocDo"], wb["MoHinh"], wb["Macro_CuoiCa"], wb["KiemChung"]]
wb.active = wb["README"]
wb.calculation.fullCalcOnLoad = True  # Excel tính lại toàn bộ khi mở file (openpyxl không lưu giá trị đệm)
wb.properties.creator = "muse-1 (Ú)"
wb.properties.title = "TblCa mẫu OEE — Intermediate II (task 206)"
wb.properties.description = "File mẫu áp dụng 6 việc Intermediate II (205 mục 8) lên số liệu minh họa 179/204/205. Không macro, không số liệu thật nhà máy."

OUT.parent.mkdir(parents=True, exist_ok=True)
wb.save(OUT)
print(f"Đã ghi: {OUT}")
