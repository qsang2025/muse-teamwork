# Operations Analytics (Wharton, Coursera) — Báo cáo tự học (task 177)

- **Khóa học:** Operations Analytics, University of Pennsylvania (Wharton), Coursera — khóa số 2 trong chuỗi 5 khóa Business Analytics Specialization
- **Trang khóa:** https://www.coursera.org/learn/wharton-operations-analytics?specialization=business-analytics
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10a: Vịt rảnh sau khi 175 merge xong; Anh duyệt danh sách 20 khóa công việc mới 21/11 08:31 trong voice call; giao tiếp xen kẽ 2 mạch — 176 mạch A do Ú làm, 175 mạch B do Vịt làm xong). Đây là **khóa số 5 mạch B trong danh sách 20 khóa công việc đã duyệt** (research/171-danh-sach-khoa-hoc-cong-viec-da-duyet.md, mục B5); bằng chứng trong file đó trên main — không kiểm chứng lại từ đầu theo chỉ dẫn task. Nội dung: dùng dữ liệu Excel (dự báo, cây quyết định, tối ưu, mô phỏng) để cân đối cung–cầu — phân tích số liệu OEE, tồn kho, lịch chạy máy; nối thẳng DMAIC/SPC của khóa 175 (phân tích dữ liệu phục vụ pha Analyze) và OEE của khóa 174. Khác với Customer Analytics (khóa #31 đã học, task 169) — khóa đó phân tích khách hàng, khóa này phân tích vận hành.
- **Hình thức:** chỉ học nội dung FREE công khai, **không đăng ký trả phí/chứng chỉ, không làm quiz/bài tập lấy điểm, không ghi danh, không nạp tiền** (quy tắc tự học §9). Học qua chế độ **Audit** của Coursera (xem video + tài liệu miễn phí). Các bài chấm điểm và chứng chỉ trong khóa **không làm, không lấy** — chỉ học phương pháp, không bịa kết quả làm bài.

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Thuộc danh sách đã duyệt: CÓ.** Operations Analytics — Wharton, Coursera là khóa B5 trong danh sách 20 khóa công việc Anh duyệt 21/11 08:31 (bằng chứng trong `research/171-danh-sach-khoa-hoc-cong-viec-da-duyet.md` mục B5 trên main, ghi 1 tuần ~10 giờ). muse-main đã ghi rõ vào task file; kiểm chứng lại trên main cho thấy đúng khóa B5, link Coursera trùng khớp.
- **Khóa học: miễn phí ở tầng nội dung qua chế độ Audit.** Trang Coursera ghi 1 tuần (~10 giờ/tuần), lịch linh hoạt, học theo nhịp riêng; chế độ Audit cho xem video + tài liệu miễn phí, không làm bài chấm điểm, không lấy chứng chỉ (theo FAQ chính thức trên trang khóa: muốn nộp bài và lấy chứng chỉ phải mua Certificate experience; có hỗ trợ tài chính — không dùng). Lần học này **không ghi danh trả phí, không mua gì, không nhận chứng chỉ** — chỉ học qua trang khóa + syllabus công khai + tài liệu phương pháp chuẩn công khai theo đúng §9.
- **Quy mô khóa:** **4 module, 1 tuần, ~10 giờ** (trang Coursera). 131.706 học viên đã ghi danh, đánh giá **4,7/5 (5.151 đánh giá)** trên Coursera; Class Central ghi 4,3/5 (6 đánh giá) — mẫu nhỏ, lấy số Coursera làm chính. Giảng viên: **Senthil Veeraraghavan, Sergei Savin, Noah Gans** (Wharton). Khóa phù hợp người mới, không yêu cầu kinh nghiệm phân tích trước (Class Central).
- **Tài khoản ghi danh: không tạo.** Nội dung video chi tiết bên trong khóa nằm sau ghi danh — báo cáo không chạm vào tầng đó và ghi rõ giới hạn (xem Ghi chú trung thực).
- **Không chạy việc thật:** không can thiệp dây chuyền, không đổi lịch sản xuất, không gắn tracking, không nạp tiền. Mọi ví dụ áp dụng cho dây chuyền đóng gói IFT trong báo cáo đều ở tầng nguyên tắc, số liệu ví dụ ghi rõ là minh họa, và việc nào chạm dây chuyền thật cũng cần Anh quyết trước khi thử.

## Ghi chú trung thực về nguồn học

Báo cáo này học qua **ba lớp nguồn**, ghi rõ để muse-main chấm review biết giới hạn — cùng mẫu với task 163/165/167/169/172/174/175:

- **Lớp 1 — trang khóa chính thức (cấu trúc/phạm vi):** trang Operations Analytics trên Coursera (đọc ngày 21/11/2026) — 4 module, 1 tuần ~10 giờ, 131.706 học viên, 4,7/5 (5.151 đánh giá), 3 giảng viên, mô tả chính thức: "dùng dữ liệu để cân đối cung–cầu một cách có lợi nhuận; mô hình hóa bất định của nhu cầu tương lai, dự báo kết quả của các lựa chọn chính sách cạnh tranh, và chọn hướng hành động tốt nhất khi đối mặt rủi ro". FAQ chính thức về chế độ Audit/chứng chỉ.
- **Lớp 2 — syllabus niêm yết công khai (nội dung từng module):** mô tả 4 module trên Class Central (https://www.classcentral.com/course/coursera-wharton-operations-analytics-4204) và MOOC-list (https://www1.mooc-list.com/course/operations-analytics-coursera), khớp nhau từng chữ với mô tả module trên trang Coursera — báo cáo trình bày theo khung 4 module này. Đánh giá học viên công khai trên hai trang này xác nhận công cụ dùng trong khóa: **Excel — Data Analysis ToolPak và Solver** (học viên PK, 11/10/2019: "in depth analysis of the concepts introduced (optimization, decision trees, forecasting, simulations) and of the tools used"; học viên khác: "I enjoyed learning ToolPak and solver the most").
- **Lớp 3 — tài liệu phương pháp chuẩn công khai (chi tiết phương pháp):** các định nghĩa, công thức và ngưỡng của bài toán Newsvendor, dự báo, tối ưu tuyến tính, mô phỏng Monte Carlo, cây quyết định là kiến thức chuẩn của operations research / quản trị vận hành, được nhiều nguồn công khai độc lập trình bày nhất quán: công thức critical fractile CF = Cu/(Cu+Co) và Q\* = F⁻¹(CF) (nrtechstudio, MetricGate, Cornell Optimization Wiki, davidmashiah — đã kiểm chứng bằng tìm kiếm độc lập ngày 21/11/2026); các phương pháp dự báo và thước đo sai số, Solver trong Excel, mô phỏng Monte Carlo bằng Data Table là kiến thức chuẩn trong giáo trình quản trị vận hành (Stevenson, Jacobs/Chase) và tài liệu Microsoft về Solver/Data Table. Đây là nền chính cho các mục 1–4. Các công thức và ví dụ trong báo cáo đều có trong ít nhất một trong các nguồn này; chỗ nào chỉ một nguồn nêu thì báo cáo ghi rõ nguồn đó.
- **Không xem video, không làm bài, không ghi danh:** báo cáo không tạo tài khoản Coursera, không xem từng video bài giảng, không làm quiz/bài tập chấm điểm, không chạy mô hình trên dữ liệu thật của nhà máy. Chi tiết minh họa trong video có thể sâu hơn tóm tắt module — ghi rõ để muse-main biết giới hạn. Mọi con số trong báo cáo đều là số niêm yết công khai kèm nguồn; chỗ nào nguồn không cho số thì ghi Chưa xác định, không tự điền. Số liệu ví dụ tính Newsvendor, dự báo, tối ưu, mô phỏng, cây quyết định ở các mục dưới là **ví dụ minh họa do Vịt tự lập** để diễn giải công thức, không phải số liệu thật của dây chuyền IFT.

## Cấu trúc khóa (4 module, 1 tuần, ~10 giờ)

| Tuần | Tên module | Nội dung cốt lõi theo syllabus công khai | Kỹ năng đích |
|---|---|---|---|
| 1 | Introduction, Descriptive and Predictive Analytics | Bài toán Newsvendor; biến ngẫu nhiên, thống kê mô tả; các công cụ dự báo từ dữ liệu nhu cầu lịch sử; thước đo chất lượng dự báo | Dự báo nhu cầu và biết dự báo của mình sai bao nhiêu |
| 2 | Prescriptive Analytics, Low Uncertainty | Xây mô hình tối ưu khi bất định thấp; công thức đại số → mô hình bảng tính; dùng Solver để tìm phương án tốt nhất | Tìm quyết định tối ưu bằng Excel, không đoán mò |
| 3 | Predictive Analytics, Risk | Xây và đọc mô hình mô phỏng khi kết quả quyết định là bất định; các thước đo rủi ro và lợi nhuận; diễn giải và trực quan hóa kết quả mô phỏng | Đánh giá rủi ro của một quyết định trước khi làm thật |
| 4 | Prescriptive Analytics, High Uncertainty | Cây quyết định; kết hợp tối ưu + mô phỏng + cây quyết định cho bài toán phức tạp; giải lại bài toán Newsvendor bằng khung mô phỏng–tối ưu | Ra quyết định khi bất định cao, có nhiều chặng |

## 1. Tuần 1 — Dự báo và bài toán Newsvendor: cân đối cung–cầu khi nhu cầu bất định

### 1.1. Bài toán Newsvendor — mô hình gốc của quản lý tồn kho trong bất định

**Định nghĩa:** bài toán Newsvendor (người bán báo) là bài toán một kỳ, một lần đặt hàng, nhu cầu không chắc chắn: đặt quá ít thì mất doanh số, đặt quá nhiều thì thừa hàng phải thanh lý rẻ hoặc bỏ đi. Đây là **mô hình nền tảng của lý thuyết tồn kho ngẫu nhiên** (có từ Edgeworth 1888, hình thức hóa bởi Arrow–Harris–Marschak 1951). Mọi quyết định tồn kho "một lần" ở nhà máy đều là một biến thể của nó: đặt bao bì in theo chiến dịch, sản xuất lô quà Tết, đặt nguyên liệu có hạn dùng ngắn.

**Hai chi phí đối nhau — gốc của mọi quyết định:**

| Chi phí | Công thức | Nghĩa |
|---|---|---|
| **Underage Cu** (thiếu hàng) | Cu = giá bán p − chi phí c | Lợi nhuận mất đi trên mỗi đơn vị nhu cầu không phục vụ được |
| **Overage Co** (thừa hàng) | Co = chi phí c − giá trị thu hồi v | Lỗ trên mỗi đơn vị đặt về mà không bán được |

**Công thức quyết định — critical fractile (tỷ lệ tới hạn):**

- **CF = Cu / (Cu + Co)** — xác suất phục vụ mục tiêu, tức P(nhu cầu ≤ lượng đặt).
- **Q\* = F⁻¹(CF)** — lượng đặt tối ưu là phân vị của phân phối nhu cầu tại CF. Với nhu cầu chuẩn N(μ, σ): **Q\* = μ + z\*·σ**, trong đó z\* = Φ⁻¹(CF) (hàm NORM.INV trong Excel).
- **Luận lý biên:** thêm một đơn vị nữa thì lãi Cu với xác suất bán được (1 − F(Q)), lỗ Co với xác suất ế (F(Q)) — dừng thêm khi hai vế bằng nhau. Đây là lý do công thức đúng, không phải công thức học vẹt.

**Điểm khóa nhấn mạnh:**

- **Q\* nằm trên hay dưới nhu cầu trung bình tùy Cu so với Co.** Cu > Co (lãi biên lớn, thừa rẻ) → CF > 0,5 → đặt nhiều hơn trung bình, cố tình thừa. Cu < Co (biên mỏng, thừa đắt — đúng hàng dễ hỏng, bao bì in riêng) → CF < 0,5 → đặt ít hơn trung bình, cố tình thiếu. Đây là quyết định có chủ đích, không phải "đặt sai".
- **Giá trị thu hồi v càng cao thì Co càng nhỏ, CF càng cao** — bán thanh lý được, cho tặng được, dùng được cho lô sau thì cứ đặt nhiều hơn. Ngược lại, v = 0 (bao bì in riêng không dùng lại được) là trường hợp thừa đắt nhất.
- **Nhu cầu phải ước lượng từ lịch sử, và phải cẩn thận với nhu cầu bị kiểm duyệt (censored demand):** ngày nào bán hết hàng thì số bán ra không phải nhu cầu thật — nhu cầu thật cao hơn. Ước lượng phân phối từ số bán ra trong những ngày hết hàng sẽ đánh giá thấp nhu cầu, kéo Q\* xuống thấp — sai lầm này tự nhân rộng: đặt ít → lại hết hàng → lại thấy "nhu cầu thấp".

**Ví dụ minh họa (số liệu do Vịt tự lập, không phải số thật của IFT):** lô bao bì quà Tết in riêng, sản xuất một lần: giá bán p = 120.000 đ/hộp, chi phí c = 60.000 đ/hộp, giá trị thu hồi v = 20.000 đ/hộp (bán thanh lý sau Tết). Cu = 120.000 − 60.000 = 60.000; Co = 60.000 − 20.000 = 40.000; CF = 60/(60+40) = **0,60**. Nhu cầu ước lượng từ các năm trước: trung bình μ = 1.000 hộp, độ lệch chuẩn σ = 200 hộp. z\* = Φ⁻¹(0,60) ≈ 0,253 → **Q\* = 1.000 + 0,253 × 200 ≈ 1.051 hộp** (Excel: `=NORM.INV(0,6;1000;200)`). Nghĩa là đặt 1.051 hộp, chấp nhận xác suất 60% đáp ứng đủ nhu cầu — và 40% khả năng vẫn thiếu, đó là giá của việc thừa mỗi hộp lỗ 40.000 đ. Nếu bao bì không thanh lý được (v = 0) thì Co = 60.000, CF = 0,5, Q\* = 1.000 hộp — đúng bằng trung bình.

**Áp dụng cho Anh:** (1) Mọi lần đặt vật tư "một lần, không dùng lại được" (bao bì in theo chiến dịch, quà tặng, vật tư sự kiện) đều nên tính qua CF thay vì đặt theo cảm tính "lấy tròn 1.000 cho dễ nhớ". (2) Trước khi tính, ghi rõ p, c, v — ba con số này là toàn bộ quyết định; tranh cãi về số lượng đặt thực chất là tranh cãi về ba con số này, nên đưa chúng ra bàn trước. (3) Nhu cầu ước lượng phải tách riêng ngày hết hàng — ngày hết hàng thì số bán ra không phải nhu cầu.

### 1.2. Dự báo từ dữ liệu lịch sử — và cách biết dự báo sai bao nhiêu

**Thống kê mô tả là nền:** trước khi dự báo, mô tả nhu cầu lịch sử bằng trung bình, độ lệch chuẩn, phân phối (chuẩn hay lệch), xu hướng và mùa vụ. Khóa dạy biến ngẫu nhiên và thống kê mô tả trước khi dạy dự báo — vì dự báo mà không biết dữ liệu của mình biến động cỡ nào thì không biết dự báo có tin được không. Đây là điểm nối với khóa 175: phân phối và độ lệch chuẩn ở đây là cùng khái niệm với capability và SPC ở pha Measure/Control của DMAIC — chỉ khác đối tượng (nhu cầu thay vì đặc tính sản phẩm).

**Ba họ công cụ dự báo trong khóa:**

| Công cụ | Cách làm | Khi nào dùng |
|---|---|---|
| **Trung bình trượt (moving average)** | Dự báo kỳ sau = trung bình k kỳ gần nhất | Nhu cầu ổn định, không xu hướng, không mùa vụ; k lớn thì mượt nhưng chậm bắt thay đổi |
| **Làm mượt hàm mũ (exponential smoothing)** | F(t+1) = α·D(t) + (1−α)·F(t); α càng lớn càng nhạy với kỳ mới nhất | Nhu cầu ổn định; α nhỏ (0,1–0,3) khi dữ liệu nhiễu, α lớn khi nhu cầu đổi nhanh |
| **Xu hướng + mùa vụ** | Tách nhu cầu thành trend × seasonal index; dự báo = trend × chỉ số mùa | Nhu cầu có chu kỳ rõ (Tết, mùa hè, tháng cao điểm) — đúng hàng tiêu dùng nhanh |

**Thước đo chất lượng dự báo — phần quan trọng nhất của tuần 1:**

| Thước đo | Công thức | Đọc thế nào |
|---|---|---|
| **MAD** (độ lệch tuyệt đối trung bình) | trung bình \|thực tế − dự báo\| | Sai trung bình bao nhiêu đơn vị — cùng đơn vị với nhu cầu, dễ hiểu nhất |
| **MSE** (sai số bình phương trung bình) | trung bình (thực tế − dự báo)² | Phạt nặng sai số lớn — dùng khi sai lớn đắt hơn sai nhỏ nhiều lần |
| **MAPE** (sai số phần trăm tuyệt đối trung bình) | trung bình \|sai số / thực tế\| × 100% | Sai bao nhiêu % — so được giữa các sản phẩm khác nhau |
| **Bias** (độ chệch) | trung bình (thực tế − dự báo), có dấu | Bias dương kéo dài = dự báo luôn thấp (thiếu hàng mãn tính); bias âm = dự báo luôn cao (tồn kho phình) |

**Nguyên tắc vàng của khóa:** **không có dự báo nào đúng — chỉ có dự báo kèm độ sai.** Chọn phương pháp dự báo bằng cách so MAD/MAPE trên dữ liệu quá khứ (backtest), không chọn theo cảm tính; và luôn báo cáo dự báo kèm khoảng sai số (ví dụ: "dự báo 1.000 hộp ± 200") thay vì một con số tròn. Khoảng sai số này chính là σ đưa vào bài toán Newsvendor ở mục 1.1 — hai phần của tuần 1 nối với nhau ở đây.

**Ví dụ minh họa — làm mượt hàm mũ cho nhu cầu bao bì tháng (số liệu do Vịt tự lập):** nhu cầu 6 tháng: 900, 1.050, 980, 1.120, 1.080, 1.150 hộp. Lấy α = 0,3, dự báo khởi đầu F1 = 900. F2 = 0,3×900 + 0,7×900 = 900; F3 = 0,3×1.050 + 0,7×900 = 945; F4 = 0,3×980 + 0,7×945 = 956; F5 = 0,3×1.120 + 0,7×956 = 1.005; F6 = 0,3×1.080 + 0,7×1.005 = 1.028; F7 = 0,3×1.150 + 0,7×1.028 = 1.065. Sai số các kỳ: 0, 150, 35, 164, 75, 122 → MAD ≈ 91 hộp, MAPE ≈ 8,8%. Dự báo tháng 7: **~1.065 hộp, sai số kỳ vọng ± 91 hộp**. Nếu dùng trung bình trượt 3 kỳ thì F7 = (1.120+1.080+1.150)/3 = 1.117 — cao hơn; chọn phương pháp nào thì so MAD/MAPE trên cùng dữ liệu, không chọn theo con số "trông hợp lý".

**Áp dụng cho Anh:** (1) Dự báo nhu cầu bao bì/nguyên liệu cho tháng sau bằng làm mượt hàm mũ trong Excel — một cột dữ liệu, một công thức, không cần phần mềm mới. (2) Luôn ghi kèm MAD/MAPE khi gửi dự báo lên quản lý: "dự báo 1.065 hộp, sai số trung bình 8,8%" là báo cáo trung thực; "dự báo 1.065 hộp" không kèm sai số là báo cáo gây hiểu lầm — đúng tinh thần checklist 5 câu hỏi của task 144 (không tin kết luận tổng thể do AI/mô hình soạn, luôn đối chiếu số gốc). (3) Theo dõi bias: nếu dự báo thấp hơn thực tế 3 tháng liên tiếp thì không phải "nhu cầu tăng đột biến" mà là mô hình đang chệch — điều chỉnh α hoặc đổi phương pháp.

## 2. Tuần 2 — Tối ưu khi bất định thấp: biến quyết định thành mô hình Solver

**Định nghĩa:** khi nhu cầu/công suất gần như đã biết (bất định thấp), quyết định tốt nhất tìm được bằng **mô hình tối ưu**: biến quyết định (quyết định cái gì), hàm mục tiêu (tối đa hóa cái gì / tối thiểu hóa cái gì), ràng buộc (giới hạn nào không được vượt). Khóa dạy ba bước: viết công thức đại số → chuyển sang mô hình bảng tính → dùng **Solver** của Excel để tìm đáp án.

**Ba thành phần của mọi mô hình tối ưu — viết ra trước khi mở Excel:**

| Thành phần | Ví dụ: phân bổ giờ máy giữa 2 sản phẩm |
|---|---|
| **Biến quyết định** | x1 = số hộp sản phẩm A, x2 = số hộp sản phẩm B |
| **Hàm mục tiêu** | Tối đa hóa lợi nhuận = 5.000·x1 + 8.000·x2 (đồng/hộp) |
| **Ràng buộc** | Giờ máy: 2·x1 + 3·x2 ≤ 480 phút/ca; nguyên liệu đường: x1 + 2·x2 ≤ 300 kg; x1, x2 ≥ 0 |

**Solver trong Excel — ba engine, chọn đúng loại:**

| Engine | Dùng khi nào |
|---|---|
| **Simplex LP** | Mọi quan hệ đều tuyến tính (mục tiêu và ràng buộc đều là tổ hợp tuyến tính) — nhanh, cho đáp án tối ưu toàn cục, kèm báo cáo sensitivity |
| **GRG Nonlinear** | Có quan hệ phi tuyến (ví dụ: chi phí giảm theo sản lượng, hiệu suất đổi theo tốc độ) — có thể dừng ở tối ưu cục bộ, cần thử nhiều điểm khởi đầu |
| **Evolutionary** | Mô hình không trơn/không liên tục (hàm IF, làm tròn, rời rạc) — chậm, không bảo đảm tối ưu, chỉ dùng khi hai engine kia không chạy được |

**Báo cáo Sensitivity — phần có giá trị nhất sau khi Solver chạy xong:**

- **Shadow price (giá bóng) của một ràng buộc** = lợi nhuận tăng thêm nếu nới ràng buộc đó thêm 1 đơn vị. Ràng buộc có shadow price cao nhất chính là **nút thắt** của hệ thống — đúng khái niệm nút thắt của khóa 172, nhưng ở đây đo bằng tiền, không phải bằng cảm tính. Tăng giờ máy ở nút thắt thì lợi nhuận tăng đúng bằng shadow price × số giờ thêm; tăng giờ ở công đoạn không phải nút thắt (shadow price = 0) thì lợi nhuận không tăng — tiền đổ vào chỗ không sinh lời.
- **Reduced cost** = lợi nhuận mất đi nếu ép sản xuất 1 đơn vị của sản phẩm hiện không được chọn — cho biết sản phẩm đó phải lãi thêm bao nhiêu mới đáng đưa vào lịch.
- **Allowable increase/decrease** = khoảng mà hệ số mục tiêu/ràng buộc được dao động mà đáp án tối ưu không đổi — cho biết đáp án nhạy cảm tới đâu với số liệu đầu vào.

**Ví dụ minh họa — phân bổ giờ máy (số liệu do Vịt tự lập):** một ca 480 phút máy, 2 sản phẩm. A lãi 5.000 đ/hộp, tốn 2 phút máy + 1 kg đường; B lãi 8.000 đ/hộp, tốn 3 phút máy + 2 kg đường; đường có 300 kg/ca. Mô hình: max 5.000x1 + 8.000x2; s.t. 2x1 + 3x2 ≤ 480; x1 + 2x2 ≤ 300; x1, x2 ≥ 0. Giải: ràng buộc giờ máy là nút thắt — tại x2 = 150, x1 = 15 (dùng hết 480 phút: 2×15 + 3×150 = 480; đường: 15 + 300 = 315 > 300 — vi phạm!). Tính lại: giao hai ràng buộc: 2x1 + 3x2 = 480 và x1 + 2x2 = 300 → nhân phương trình 2 với 2: 2x1 + 4x2 = 600, trừ phương trình 1: x2 = 120; x1 = 300 − 240 = 60. Lợi nhuận = 5.000×60 + 8.000×120 = 300.000 + 960.000 = **1.260.000 đ/ca**. Kiểm tra: giờ máy 2×60 + 3×120 = 480 ✓; đường 60 + 240 = 300 ✓. Nếu chỉ chạy toàn B: x2 = 150 (hết đường 300 kg) nhưng giờ máy 450 phút, lợi nhuận 1.200.000 — thấp hơn; chỉ chạy toàn A: x1 = 240, lợi nhuận 1.200.000 — bằng nhau ở ví dụ này, nhưng phối hợp cả hai cho 1.260.000, cao hơn 60.000 đ/ca. Solver tìm đáp án này trong 1 giây; làm tay thì mất cả buổi và dễ bỏ sót phương án phối hợp.

**Áp dụng cho Anh:** (1) Lập lịch chạy máy theo tuần bằng mô hình tối ưu: biến quyết định là số lượng từng SKU, ràng buộc là giờ máy + nguyên liệu + đơn hàng tối thiểu, mục tiêu là lợi nhuận hoặc sản lượng. (2) Đọc shadow price để biết nút thắt thật sự nằm ở đâu — nếu shadow price của giờ máy đóng gói cao nhất thì tăng ca ở khâu đóng gói mới sinh lời, tăng ca ở khâu khác thì không. (3) Trước khi mua thêm máy, chạy Solver với ràng buộc giờ máy nới thêm: lợi nhuận tăng thêm mỗi giờ máy chính là giá trị tối đa đáng trả cho giờ máy đó — so với chi phí mua/thuê máy thì biết ngay có nên mua không.

## 3. Tuần 3 — Mô phỏng khi kết quả bất định: đo rủi ro trước khi làm thật

**Định nghĩa:** khi kết quả của một quyết định là bất định (nhu cầu dao động, máy hỏng ngẫu nhiên, thời gian setup thay đổi), không thể tính đáp án bằng một công thức đóng — phải **mô phỏng Monte Carlo**: cho máy tính "chạy thử" quyết định đó hàng nghìn lần, mỗi lần bốc một bộ số ngẫu nhiên theo phân phối đã biết, rồi xem phân phối kết quả. Khóa dạy xây mô hình mô phỏng trong Excel bằng hàm ngẫu nhiên (RAND, NORM.INV) và bảng Data Table, rồi diễn giải và trực quan hóa kết quả.

**Ba thước đo rủi ro–lợi nhuận mà khóa dạy:**

| Thước đo | Nghĩa | Ví dụ |
|---|---|---|
| **Giá trị kỳ vọng (expected value)** | Kết quả trung bình qua hàng nghìn lần chạy | Sản lượng trung bình/tuần |
| **Độ lệch chuẩn / khoảng biến động** | Kết quả dao động cỡ nào quanh trung bình | Sản lượng tuần dao động ± 15% |
| **Xác suất không đạt mục tiêu** | P(kết quả < ngưỡng) — phần đuôi xấu của phân phối | Xác suất không đạt kế hoạch tuần = 22% |

**Điểm khóa nhấn mạnh:**

- **Mô phỏng không cho đáp án đúng — nó cho phân phối đáp án.** Một quyết định có lợi nhuận kỳ vọng cao nhưng xác suất lỗ 30% khác hẳn một quyết định lợi nhuận kỳ vọng thấp hơn một chút nhưng xác suất lỗ chỉ 5%. Quản lý chỉ nhìn giá trị kỳ vọng thì sẽ chọn phương án rủi ro cao mà không biết.
- **Trực quan hóa là bắt buộc:** biểu đồ histogram của kết quả mô phỏng cho thấy ngay hình dạng rủi ro — phân phối lệch trái (đuôi xấu dài) nghĩa là thỉnh thoảng thua rất đậm; phân phối hẹp nghĩa là kết quả ổn định. Một histogram nói nhiều hơn một bảng số trung bình.
- **Phân tích độ nhạy (sensitivity):** thay từng đầu vào một và xem kết quả đổi bao nhiêu — biến nào làm kết quả đổi nhiều nhất thì đó là biến cần đo chính xác nhất. Đây là cùng tư duy với Gage R&R của khóa 175: đo cái nào quan trọng trước, đừng đo đều tất cả.

**Ví dụ minh họa — mô phỏng sản lượng tuần từ OEE biến động (số liệu do Vịt tự lập, nối từ khóa 174):** dây chuyền chạy 5 ca/tuần, mỗi ca planned production time 480 phút, ideal cycle time 0,5 phút/hộp, tốc độ lý thuyết 960 hộp/ca. Availability dao động theo phân phối chuẩn N(88%, 5%) (hỏng hóc ngẫu nhiên), performance N(93%, 4%), quality N(97%, 1,5%). Mỗi lần mô phỏng: bốc 3 số ngẫu nhiên, tính OEE = A×P×Q, sản lượng ca = 960×OEE. Chạy 1.000 lần bằng Data Table: sản lượng tuần trung bình ≈ 5 × 960 × 0,88 × 0,93 × 0,97 ≈ **3.812 hộp**; độ lệch chuẩn ≈ 260 hộp; **P(sản lượng tuần < 3.500 hộp) ≈ 11%**; P(< 3.200) ≈ 1,5%. Kết luận: kế hoạch tuần đặt 3.800 hộp thì có ~50% khả năng không đạt; đặt 3.500 thì khả năng đạt ~89%. Con số 11% này là thứ mà "tính trung bình rồi nhân lên" không bao giờ cho thấy — trung bình thì tuần nào cũng 3.812 trên giấy, thực tế thì cứ ~9 tuần lại có 1 tuần dưới 3.500.

**Áp dụng cho Anh:** (1) Trước khi cam kết sản lượng tuần với quản lý, mô phỏng từ OEE lịch sử: báo cáo "sản lượng kỳ vọng 3.800 hộp, xác suất đạt kế hoạch 89% nếu đặt 3.500" trung thực hơn "cam kết 3.800". (2) Mô phỏng tồn kho an toàn cho đường/sữa bột: nhu cầu và lead time đều dao động — mô phỏng cho ra xác suất hết hàng với từng mức tồn kho an toàn, thay vì đặt safety stock theo cảm tính. (3) Dùng mô phỏng để thử chính sách trước khi áp dụng: đổi lịch bảo trì, tăng ca, giảm tồn kho đệm — chạy mô phỏng 1.000 lần trước, xem phân phối kết quả, rồi mới quyết. Đây là cách thử rẻ nhất: thử trên bảng tính, không thử trên dây chuyền thật.

## 4. Tuần 4 — Cây quyết định khi bất định cao: nối tối ưu + mô phỏng + cây

**Định nghĩa:** khi quyết định có nhiều chặng và mỗi chặng lại mở ra nhiều khả năng (làm hay không làm → nhu cầu cao hay thấp → mở rộng hay dừng), **cây quyết định** là công cụ sắp xếp: nút vuông = quyết định (mình chọn), nút tròn = cơ hội (trời chọn, có xác suất), lá = kết quả (tiền). Tính ngược từ lá về gốc bằng **EMV (Expected Monetary Value)** — giá trị kỳ vọng tại mỗi nút cơ hội, chọn nhánh có EMV cao nhất tại mỗi nút quyết định. Đây gọi là **rollback**.

**EVPI — giá của thông tin hoàn hảo:** EVPI (Expected Value of Perfect Information) = EMV khi biết trước tương lai − EMV khi không biết. Đây là **giá trần đáng trả cho thông tin** (khảo sát thị trường, thử nghiệm, dữ liệu tốt hơn): nếu EVPI là 50 triệu thì bỏ 60 triệu mua khảo sát là lỗ — thông tin đó không đáng giá đó. Khóa dạy EVPI vì trong thực tế, người ta hay mua thông tin đắt hơn giá trị của nó, hoặc ngược lại, tiếc tiền khảo sát trong khi EVPI cao gấp nhiều lần.

**Kết hợp ba công cụ — điểm tổng kết của khóa:** tuần 4 dùng một ví dụ xuyên suốt để cho thấy ba công cụ không thay thế nhau mà **nối tiếp nhau**: tối ưu (tuần 2) tìm phương án tốt nhất khi số liệu đã biết; mô phỏng (tuần 3) đo phân phối kết quả khi số liệu dao động; cây quyết định (tuần 4) sắp xếp các lựa chọn nhiều chặng và cho biết nên mua thêm thông tin nào. Và bài toán Newsvendor tuần 1 được giải lại bằng khung mô phỏng–tối ưu: thay vì dùng công thức CF, chạy mô phỏng với nhiều mức Q khác nhau, tối ưu hóa lợi nhuận kỳ vọng theo Q — hai cách cho cùng đáp án, nhưng khung mô phỏng–tối ưu áp dụng được cho cả những bài toán không có công thức đóng.

**Ví dụ minh họa — cây quyết định mua máy mới (số liệu do Vịt tự lập):** nhu cầu năm sau: cao (xác suất 0,4) hoặc thấp (0,6). Ba lựa chọn: (a) mua máy mới 2 tỷ, lãi 3 tỷ nếu nhu cầu cao, 0,5 tỷ nếu thấp → EMV = 0,4×3 + 0,6×0,5 − 2 = 1,2 + 0,3 − 2 = **−0,5 tỷ**; (b) tăng ca hiện tại, lãi 1,2 tỷ nếu cao, 0,8 tỷ nếu thấp, chi phí 0,3 tỷ → EMV = 0,4×1,2 + 0,6×0,8 − 0,3 = 0,48 + 0,48 − 0,3 = **+0,66 tỷ**; (c) thuê ngoài, lãi 0,9 tỷ nếu cao, 0,6 tỷ nếu thấp, chi phí 0,2 tỷ → EMV = 0,36 + 0,36 − 0,2 = **+0,52 tỷ**. Chọn (b) tăng ca — EMV cao nhất. EVPI: nếu biết trước nhu cầu cao thì chọn (a): lãi ròng 3 − 2 = 1 tỷ; biết trước thấp thì chọn (b): 0,8 − 0,3 = 0,5 tỷ → EMV với thông tin hoàn hảo = 0,4×1 + 0,6×0,5 = 0,7 tỷ. EVPI = 0,7 − 0,66 = **0,04 tỷ = 40 triệu** — chỉ đáng bỏ tối đa 40 triệu để biết trước nhu cầu năm sau; khảo sát nào đắt hơn 40 triệu thì không mua. Lưu ý: EMV là trung bình — nếu công ty không chịu nổi kịch bản xấu nhất của (a) (lỗ 1,5 tỷ khi nhu cầu thấp) thì vẫn không chọn (a) dù EMV của nó cao; cây quyết định cho EMV, còn khẩu vị rủi ro thì người quyết phải tự cộng thêm — đúng chỗ mô phỏng tuần 3 bổ sung cho cây quyết định.

**Áp dụng cho Anh:** (1) Mọi quyết định đầu tư (mua máy, tăng ca, thuê ngoài, đổi bao bì đường 25 kg → 50 kg) đều nên vẽ thành cây: liệt kê lựa chọn, gán xác suất cho từng kịch bản nhu cầu, tính EMV — thay vì tranh luận bằng cảm tính "mua máy thì chắc ăn hơn". (2) Tính EVPI trước khi đặt khảo sát/thử nghiệm: thử nghiệm đổi bao bì đường tốn bao nhiêu, và nó giảm bất định được bao nhiêu tiền — nếu chi phí thử nghiệm vượt EVPI thì đừng thử, quyết luôn. (3) Cây quyết định là tài liệu trình bày trước quản lý (Linh Lê, Hao): một cây vẽ rõ ràng cho thấy mình đã tính cả kịch bản xấu, không phải chỉ trình bày kịch bản đẹp.

## Nối mạch: 172 → 174 → 175 → 177

| Khóa | Vai trò trong mạch | Nối vào 177 như thế nào |
|---|---|---|
| 172 Introduction to Operations Management (Wharton) | Khung vận hành: nút thắt, Little's Law, 7 lãng phí, Six Sigma, TPS | Nút thắt ở 172 được đo bằng tiền ở tuần 2 (shadow price); Little's Law (tồn kho = lưu lượng × thời gian) là ràng buộc trong mô hình tối ưu lịch chạy máy |
| 174 TPM and OEE (iCompetent) | Đo thiết bị: 6 tổn thất lớn, OEE, TEEP, MTBF/MTTR | OEE lịch sử là **đầu vào** cho mô phỏng tuần 3: phân phối của A/P/Q là thứ mô phỏng bốc số; cây tổn thất là danh sách các biến cần đưa vào mô hình |
| 175 Lean Six Sigma Black Belt (Alison) | Chứng minh bằng thống kê: DMAIC, Cp/Cpk, Gage R&R, SPC, DOE | Pha **Analyze** của DMAIC chính là nơi dùng 4 công cụ của khóa này: dự báo để biết nhu cầu, tối ưu để chọn giải pháp, mô phỏng để đo rủi ro, cây quyết định để chọn giữa các giải pháp; SPC ở Control là đồng hồ theo dõi xem quyết định đã chọn có giữ được không |
| 169 Customer Analytics (Wharton) | Phân tích khách hàng — khóa #1 cùng chuỗi Business Analytics | Cùng chuỗi 5 khóa, cùng giảng viên Wharton, cùng phong cách Excel; khác đối tượng: 169 đo khách hàng, 177 đo vận hành — hai họ đo lường bổ sung nhau, không trùng |

**Luồng dữ liệu xuyên suốt 4 khóa — đây là điểm quan trọng nhất của báo cáo:** dữ liệu thu thập ở 174 (nhật ký dừng máy theo 6 mã tổn thất, OEE từng ca) → kiểm chứng độ tin cậy ở 175 (Gage R&R: số đo có tin được không; capability: quy trình đang ở đâu) → phân tích và ra quyết định ở 177 (dự báo nhu cầu từ dữ liệu đã tin được, tối ưu lịch chạy máy, mô phỏng rủi ro, cây quyết định cho đầu tư). **Thiếu một mắt xích thì các mắt sau sai:** dự báo từ dữ liệu OEE bị "làm đẹp" (khóa 174, mục 4) thì dự báo đẹp mà sai; tối ưu trên số liệu đo sai thì Solver cho đáp án tối ưu của một nhà máy không tồn tại. Đây cũng là lý do thứ tự học B2 → B5 là đúng (theo đề xuất trong báo cáo 174): học đo đúng trước, học phân tích sau.

## Áp dụng: 6 việc làm được ngay ở dây chuyền đóng gói IFT

Xếp theo mức tác động/công sức, chỉ ở tầng nguyên tắc — việc nào chạm dây chuyền thật cũng cần Anh quyết trước:

| # | Việc | Công cụ trong khóa | Tác động kỳ vọng |
|---|---|---|---|
| 1 | Dự báo nhu cầu bao bì/nguyên liệu tháng sau bằng làm mượt hàm mũ trong Excel, báo cáo kèm MAD/MAPE | Dự báo, tuần 1 | Biết nhu cầu tháng sau sai khoảng bao nhiêu %, đặt hàng không còn theo cảm tính |
| 2 | Tính lượng đặt tối ưu cho vật tư một lần (bao bì in theo chiến dịch) bằng critical fractile: ghi rõ p, c, v rồi tính Q\* | Newsvendor, tuần 1 | Đặt đúng số lượng có lý do bằng tiền, thay vì "lấy tròn cho dễ nhớ" |
| 3 | Lập mô hình tối ưu lịch chạy máy bằng Solver: biến là số lượng từng SKU, ràng buộc là giờ máy + nguyên liệu, mục tiêu là lợi nhuận | Tối ưu, tuần 2 | Lịch chạy máy tối ưu theo tiền, và biết nút thắt thật sự qua shadow price |
| 4 | Mô phỏng Monte Carlo sản lượng tuần từ OEE lịch sử (phân phối A/P/Q), báo cáo xác suất đạt kế hoạch thay vì một con số cam kết | Mô phỏng, tuần 3 | Cam kết sản lượng trung thực: "đạt 89%" thay vì "chắc chắn đạt" |
| 5 | Vẽ cây quyết định + tính EMV/EVPI cho quyết định đầu tư (mua máy, tăng ca, thuê ngoài, đổi bao bì đường) trước khi trình quản lý | Cây quyết định, tuần 4 | Quyết định có tính cả kịch bản xấu; biết khảo sát/thử nghiệm đáng giá bao nhiêu thì mua |
| 6 | Dùng dữ liệu OEE (174) đã kiểm chứng độ tin cậy (175) làm đầu vào duy nhất cho mọi mô hình trên — không chạy mô hình trên số liệu chưa kiểm chứng | Nối mạch 174→175→177 | Mô hình đúng trên dữ liệu đúng; tránh "tối ưu của một nhà máy không tồn tại" |

**Cái không nên làm theo khóa một cách máy móc:** (1) Đừng tối ưu trên số trung bình rồi tin đáp án là chắc chắn — "flaw of averages": nhu cầu trung bình 1.000 không có nghĩa là đặt 1.000 là tối ưu; phải qua Newsvendor hoặc mô phỏng mới thấy rủi ro hai phía. (2) Đừng tin dự báo không kèm sai số — dự báo nào cũng sai, chỉ khác sai bao nhiêu; báo cáo dự báo không kèm MAD/MAPE là báo cáo thiếu một nửa. (3) Đừng dùng Solver rồi tin đáp án mà không kiểm tra giả định: mô hình tuyến tính mà thực tế phi tuyến (hiệu suất đổi theo tốc độ) thì đáp án "tối ưu" là đáp án của mô hình sai. (4) Đừng ước lượng nhu cầu từ số bán ra trong ngày hết hàng — nhu cầu bị kiểm duyệt làm mọi con số sau đó thấp đi (mục 1.1). (5) Đừng mua thông tin đắt hơn EVPI — khảo sát/thử nghiệm chỉ đáng tiền khi giá của nó nhỏ hơn giá trị của bất định mà nó gỡ được. (6) Đừng dùng EMV một mình khi kịch bản xấu nhất vượt quá khả năng chịu đựng — EMV là trung bình, không phải bảo hiểm; phải đọc kèm phân phối rủi ro từ mô phỏng tuần 3. Đây là cùng cảnh báo với task 142 (AI For Everyone) và task 172/174: kiến thức nền phải đọc cùng bối cảnh thật, không áp máy móc.

## Đề xuất tiếp theo cho team

- **Khóa nối tiếp tự nhiên trong danh sách 20:** B4 **Supply Chain Planning** (Rutgers, Coursera, ~10 giờ) — dự báo nhu cầu và S&OP, lập lịch sản xuất và cân đối cung–cầu ở tầng chuỗi cung ứng, là tầng trên của chính khóa này (khóa này cân đối cung–cầu trong nhà máy, B4 cân đối ở tầng chuỗi). Thứ tự này theo đúng đề xuất trong báo cáo 174 (B4 để sau B5) và ghi chú trong task 177. Sau B4: B7 **Excel Skills for Business: Essentials** (Macquarie, Coursera) — nâng tay nghề Excel (hàm, dashboard) để chạy các mô hình trong báo cáo này nhanh hơn, vì mọi công cụ của khóa 177 đều chạy trên Excel.
- **Khóa dự phòng trùng nội dung:** không có — khóa này là khóa duy nhất trong danh sách 20 dạy phân tích định lượng vận hành bằng Excel; B8 Supply Chain Fundamentals (MITx) trùng một phần với B4 ở tầng chuỗi cung ứng, học sau B4 chỉ khi cần đi sâu.
- **Đề xuất cập nhật skill:** không có — khóa này không thêm pattern build extension nào; kiến thức dùng cho báo cáo ca/kíp, lập lịch và quản lý dây chuyền, không phải cho skill vBook. Nếu sau này team viết skill "đọc báo cáo sản xuất bằng AI" thì khung 4 công cụ (dự báo – tối ưu – mô phỏng – cây quyết định) + checklist 5 câu hỏi của task 144 là hai mảnh ghép sẵn.
- **Liên hệ các báo cáo trước:** task 172 (Introduction to Operations Management — khung OEE, nút thắt, Little's Law) là nền; task 174 (TPM/OEE — dữ liệu đầu vào) và 175 (Black Belt — kiểm chứng dữ liệu + pha Analyze) là hai mắt xích trước; task 169 (Customer Analytics — cùng chuỗi Wharton, đo khách hàng) là khóa chị em; task 144 (Work smarter with AI — checklist 5 câu hỏi soát nội dung AI soạn) là kỷ luật đối chiếu khi dùng mô hình để viết báo cáo ca; task 142 là lời nhắc không áp kiến thức cũ máy móc.

## Nguồn

- Trang khóa chính thức (Coursera): https://www.coursera.org/learn/wharton-operations-analytics?specialization=business-analytics (đọc 21/11/2026 — 4 module, 1 tuần ~10 giờ, 131.706 học viên, 4,7/5 với 5.151 đánh giá, giảng viên Senthil Veeraraghavan / Sergei Savin / Noah Gans, mô tả khóa, FAQ Audit/chứng chỉ)
- Syllabus công khai (Class Central): https://www.classcentral.com/course/coursera-wharton-operations-analytics-4204 (mô tả 4 module; đánh giá học viên về ToolPak và Solver)
- Syllabus công khai (MOOC-list): https://www1.mooc-list.com/course/operations-analytics-coursera (mô tả 4 module theo tuần; khóa 2/5 trong Business Analytics Specialization)
- Bài toán Newsvendor, critical fractile CF = Cu/(Cu+Co), Q\* = F⁻¹(CF): https://www.nrtechstudio.com/tools/newsvendor/ ; https://metricgate.com/docs/newsvendor-critical-fractile/ ; https://optimization.cbe.cornell.edu/index.php?title=Newsvendor_problem (Cornell Optimization Wiki) ; https://davidmashiah.com/notes/newsvendor-model (kiểm chứng độc lập 21/11/2026)
- Danh sách khóa đã duyệt: research/171-danh-sach-khoa-hoc-cong-viec-da-duyet.md (mục B5)
- Báo cáo khóa trước: research/172-introduction-to-operations-management-wharton.md (nút thắt, Little's Law); research/174-total-productive-maintenance-oee.md (OEE, 6 tổn thất lớn, dữ liệu đầu vào); research/175-lean-six-sigma-black-belt-alison.md (DMAIC, Gage R&R, SPC, pha Analyze); research/169-customer-analytics-wharton-upenn.md (khóa chị em cùng chuỗi Wharton); research/144-work-smarter-with-ai.md (checklist 5 câu hỏi)
