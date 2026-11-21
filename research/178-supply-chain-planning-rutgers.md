# Supply Chain Planning (Rutgers, Coursera) — Báo cáo tự học (task 178)

- **Khóa học:** Supply Chain Planning, Rutgers University (Rutgers Business School), Coursera — khóa số 3 trong chuỗi 5 khóa Supply Chain Management Specialization (Logistics, Operations, Planning, Sourcing, Strategy)
- **Trang khóa:** https://www.coursera.org/learn/planning?specialization=supply-chain-management
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10a: Vịt rảnh sau khi 177 merge xong; Anh duyệt danh sách 20 khóa công việc mới 21/11 08:31 trong voice call; giao tiếp xen kẽ 2 mạch — 176 mạch A do Ú làm, 177 mạch B do Vịt làm xong). Đây là **khóa số 4 mạch B trong danh sách 20 khóa công việc đã duyệt** (research/171-danh-sach-khoa-hoc-cong-viec-da-duyet.md, mục B4); bằng chứng trong file đó trên main — không kiểm chứng lại từ đầu theo chỉ dẫn task. Nội dung: dự báo nhu cầu và S&OP — lập lịch sản xuất và cân đối cung–cầu ở tầng chuỗi cung ứng, tầng trên của khóa 177 (khóa này cân đối cung–cầu trong nhà máy, B4 cân đối ở tầng chuỗi). Nối thẳng khóa 177 (dự báo, tối ưu, mô phỏng, cây quyết định) và khóa 172 (nút thắt, Little's Law). Lưu ý trong task: B4 để sau B5 theo đề xuất trong báo cáo 174 — nay tới lượt B4; sau B4: B7 Excel Skills for Business: Essentials (Macquarie) theo đề xuất trong báo cáo 177.
- **Hình thức:** chỉ học nội dung FREE công khai, **không đăng ký trả phí/chứng chỉ, không làm bài chấm điểm, không ghi danh, không nạp tiền** (quy tắc tự học §9). Học qua chế độ **Audit** của Coursera (xem video + tài liệu miễn phí). Các bài chấm điểm và chứng chỉ trong khóa **không làm, không lấy** — chỉ học phương pháp, không bịa kết quả làm bài.

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Thuộc danh sách đã duyệt: CÓ.** Supply Chain Planning — Rutgers, Coursera là khóa B4 trong danh sách 20 khóa công việc Anh duyệt 21/11 08:31 (bằng chứng trong `research/171-danh-sach-khoa-hoc-cong-viec-da-duyet.md` mục B4 trên main, ghi 1 tuần ~10 giờ). muse-main đã ghi rõ vào task file; kiểm chứng lại trên main cho thấy đúng khóa B4, link Coursera trùng khớp.
- **Khóa học: miễn phí ở tầng nội dung qua chế độ Audit.** Trang Coursera ghi 1 tuần (~10 giờ/tuần), lịch linh hoạt, học theo nhịp riêng; FAQ chính thức trên trang khóa: muốn nộp bài và lấy chứng chỉ phải mua Certificate experience; một số khóa có lựa chọn Full Course, No Certificate; có hỗ trợ tài chính — không dùng. Lần học này **không ghi danh trả phí, không mua gì, không nhận chứng chỉ** — chỉ học qua trang khóa + syllabus công khai + tài liệu phương pháp chuẩn công khai theo đúng §9.
- **Quy mô khóa:** **4 module, 1 tuần, ~10 giờ, 9 bài tập (AI-graded)** (trang Coursera). **106.042 học viên đã ghi danh, đánh giá 4,7/5 (3.092 đánh giá)** trên Coursera (đọc 21/11/2026; 85% học viên thích khóa này, 80,31% chấm 5 sao). Giảng viên: **Rudolf Leuschner, Ph.D.** (Associate Professor, Department of Supply Chain Management, Rutgers Business School; 17 khóa, 481.286 học viên; 570 đánh giá giảng viên). Trình độ Beginner, không yêu cầu kinh nghiệm trước. Học viên trên trang khóa xác nhận công cụ dùng trong khóa là **Excel** ("carefully working on excel", "using excel to give a introduction to forecasting utilizing historical data. The excel tutorals were helpful" — đánh giá công khai trên Coursera).
- **Tài khoản ghi danh: không tạo.** Nội dung video chi tiết bên trong khóa nằm sau ghi danh — báo cáo không chạm vào tầng đó và ghi rõ giới hạn (xem Ghi chú trung thực).
- **Không chạy việc thật:** không can thiệp dây chuyền, không đổi lịch sản xuất, không gắn tracking, không nạp tiền. Mọi ví dụ áp dụng cho dây chuyền đóng gói IFT trong báo cáo đều ở tầng nguyên tắc, số liệu ví dụ ghi rõ là minh họa, và việc nào chạm dây chuyền thật cũng cần Anh quyết trước khi thử.

## Ghi chú trung thực về nguồn học

Báo cáo này học qua **ba lớp nguồn**, ghi rõ để muse-main chấm review biết giới hạn — cùng mẫu với task 163/165/167/169/172/174/175/177:

- **Lớp 1 — trang khóa chính thức (cấu trúc/phạm vi):** trang Supply Chain Planning trên Coursera (đọc ngày 21/11/2026) — 4 module, 1 tuần ~10 giờ, 106.042 học viên, 4,7/5 (3.092 đánh giá), giảng viên Rudolf Leuschner, mô tả chính thức: "master different forecasting techniques, essential for building a Sales and Operations Plan… analyze demand data, construct different forecasting techniques, and choose the most suitable one for projecting future demand", FAQ về Audit/chứng chỉ, 9 bài tập AI-graded.
- **Lớp 2 — syllabus niêm yết công khai (nội dung từng module):** mô tả 4 module trên Class Central (https://www.classcentral.com/course/coursera-planning-6922) và OpenCourser (https://opencourser.com/course/v8odfe/supply-chain-planning), khớp nhau từng ý với mô tả module trên trang Coursera — báo cáo trình bày theo khung 4 module này. Lưu ý nhỏ: mô tả công khai của module 2 và module 3 đều nhắc exponential smoothing (module 2: "moving average and exponential smoothing", module 3: "master one more forecasting method — exponential smoothing") — báo cáo giữ nguyên tên module như niêm yết, không tự sửa syllabus.
- **Lớp 3 — tài liệu phương pháp chuẩn công khai (chi tiết phương pháp):** các định nghĩa, công thức và ngưỡng của dự báo naive/trung bình tích lũy/trung bình trượt/làm mượt hàm mũ, các thước đo sai số, tracking signal, quy trình S&OP 5 bước và ba chiến lược lập kế hoạch tổng hợp (level/chase/hybrid), tồn kho an toàn và hiệu ứng bullwhip là kiến thức chuẩn của quản trị vận hành / quản trị chuỗi cung ứng, được nhiều nguồn công khai độc lập trình bày nhất quán: công thức SES F(t+1) = α·D(t) + (1−α)·F(t) và Holt (Penn State STAT 501, OpsCalculators, Cellwise); các thước đo MAD/MSE/MAPE/CFE/tracking signal và ngưỡng ±4 (Penn State, Cellwise, AgentleFS); khung S&OP và level/chase/hybrid (UEN Pressbooks — giáo trình SCM mở, Trusted Institute CPIM, giáo trình Stevenson chương 13). Đây là nền chính cho các mục 1–4. Các công thức và ví dụ trong báo cáo đều có trong ít nhất một trong các nguồn này; chỗ nào chỉ một nguồn nêu thì báo cáo ghi rõ nguồn đó. **Riêng khung S&OP 5 bước, ba chiến lược tổng hợp, tồn kho an toàn và bullwhip:** module 4 của khóa là bài tập tổng hợp "phân tích dataset thật và đưa khuyến nghị về phương pháp dự báo" để xây S&OP — các khung này là nội dung phương pháp chuẩn của S&OP mà khóa dẫn tới, trình bày ở đây như kiến thức chuẩn công khai (lớp 3), không khẳng định từng khung xuất hiện nguyên văn trong video bài giảng.
- **Không xem video, không làm bài, không ghi danh:** báo cáo không tạo tài khoản Coursera, không xem từng video bài giảng, không làm quiz/bài tập chấm điểm (9 bài tập AI-graded trong khóa không làm), không chạy mô hình trên dữ liệu thật của nhà máy. Chi tiết minh họa trong video có thể sâu hơn tóm tắt module — ghi rõ để muse-main biết giới hạn. Mọi con số trong báo cáo đều là số niêm yết công khai kèm nguồn; chỗ nào nguồn không cho số thì ghi Chưa xác định, không tự điền. Số liệu ví dụ tính dự báo và S&OP ở các mục dưới là **ví dụ minh họa do Vịt tự lập** để diễn giải công thức, không phải số liệu thật của dây chuyền IFT.

## Cấu trúc khóa (4 module, 1 tuần, ~10 giờ)

| Module | Tên module | Nội dung cốt lõi theo syllabus công khai | Kỹ năng đích |
|---|---|---|---|
| 1 | Simple Forecasting Methods, Naive Forecast and Cumulative Mean | Giới thiệu chuyên ngành Supply Chain Management; hai phương pháp dự báo đơn giản: naive và trung bình tích lũy; tự lập dự báo trên dataset và trả lời quiz | Dự báo được nhu cầu kỳ sau bằng phương pháp đơn giản nhất, hiểu vai trò của dự báo làm chuẩn đối chiếu |
| 2 | Forecast Accuracy and Moving Average | Đo độ chính xác dự báo; hai phương pháp tinh vi hơn: trung bình trượt và làm mượt hàm mũ | Biết dự báo của mình sai bao nhiêu và sai theo hướng nào |
| 3 | Exponential Smoothing and Forecast Selection | Nắm vững làm mượt hàm mũ; học cách chọn phương pháp dự báo tốt nhất và làm gì với dự báo sau khi triển khai | Chọn được phương pháp phù hợp với dữ liệu, không chọn theo cảm tính |
| 4 | Supply Chain Planning | Bài tập tổng hợp: phân tích dataset thật, đưa khuyến nghị về các phương pháp dự báo khác nhau | Ghép dự báo vào kế hoạch S&OP: từ số dự báo ra quyết định sản xuất |

## 1. Module 1 — Hai phương pháp đơn giản nhất: naive và trung bình tích lũy

### 1.1. Vì sao bắt đầu bằng phương pháp "ngu ngốc"

Khóa mở đầu bằng một câu hỏi thực tế: làm sao công ty biết phải sản xuất bao nhiêu trước để không làm thừa cũng không làm thiếu? Câu trả lời là dự báo — và khóa dạy dự báo từ đơn giản nhất đi lên, vì hai lý do. Thứ nhất, **phương pháp đơn giản là chuẩn đối chiếu (benchmark)**: một phương pháp phức tạp chỉ đáng dùng khi nó đánh bại được phương pháp đơn giản trên cùng dữ liệu — nếu không, phức tạp chỉ thêm nhiễu. Thứ hai, **mẫu nhu cầu phải đọc trước khi chọn công cụ**: nhu cầu có 4 thành phần — mức (level), xu hướng (trend), mùa vụ (seasonality), nhiễu (noise). Phương pháp đơn giản bộc lộ ngay dữ liệu của mình thuộc loại nào: naive bắt kịp thay đổi nhưng nhảy theo nhiễu; trung bình tích lũy mượt nhưng chậm.

### 1.2. Hai công thức mở đầu

| Phương pháp | Công thức | Nghĩa | Khi nào dùng |
|---|---|---|---|
| **Naive** | F(t+1) = D(t) | Dự báo kỳ sau bằng đúng nhu cầu kỳ vừa qua | Nhu cầu thay đổi ngẫu nhiên quanh một mức, không xu hướng; làm chuẩn đối chiếu cho mọi phương pháp khác |
| **Trung bình tích lũy (cumulative mean)** | F(t+1) = trung bình của D(1)…D(t) | Dự báo bằng trung bình toàn bộ lịch sử tới nay | Nhu cầu ổn định quanh một mức, muốn triệt nhiễu; càng nhiều dữ liệu thì dự báo càng ít nhúc nhích |

**Điểm khóa nhấn mạnh:** trung bình tích lũy càng về sau càng "nặng" — mỗi kỳ mới chỉ chiếm 1/t trọng số, nên khi nhu cầu đổi mức thật (ví dụ: thêm khách hàng mới, mất một kênh bán), phương pháp này phải mất rất lâu mới bắt kịp. Đó là lý do module 2 phải sang trung bình trượt: chỉ lấy k kỳ gần nhất, bỏ hẳn quá khứ xa.

**Ví dụ minh họa (số liệu do Vịt tự lập — nhu cầu thùng carton in theo tháng, đơn vị thùng):** 12 tháng: 1.200, 1.350, 1.280, 1.420, 1.500, 1.380, 1.620, 1.750, 1.680, 1.900, 1.850, 2.100. Dãy này có xu hướng tăng rõ (từ 1.200 lên 2.100) kèm nhiễu. Naive dự báo tháng 13 = **2.100 thùng** (lấy đúng tháng 12). Trung bình tích lũy dự báo tháng 13 = trung bình 12 tháng = **1.586 thùng** — thấp hơn thực tế kỳ vọng tới ~500 thùng, vì nó kéo cả những tháng đầu thấp vào. Ngay ở ví dụ này đã thấy: khi nhu cầu có xu hướng, cả hai phương pháp đơn giản đều sai theo hướng thấp (xem bảng so sánh đầy đủ ở mục 3.2 — tracking signal của cả hai đều vượt ngưỡng ±4, tức mô hình mất kiểm soát).

**Áp dụng cho Anh:** (1) Trước khi mua phần mềm dự báo hay mô hình phức tạp, luôn tính naive trước — đó là vạch xuất phát miễn phí: mô hình nào không thắng được "lấy tháng trước làm dự báo tháng sau" thì không đáng dùng. (2) Đừng dùng trung bình toàn bộ lịch sử để dự báo khi nhu cầu đang tăng/giảm có xu hướng (ví dụ: sản lượng tăng sau khi thêm khách hàng) — trung bình tích lũy sẽ luôn dự báo thấp, gây thiếu hàng mãn tính.

## 2. Module 2 — Đo độ chính xác và trung bình trượt: biết dự báo sai bao nhiêu

### 2.1. Bốn thước đo sai số — mỗi thước đo bắt một loại lỗi khác nhau

Đặt e(t) = thực tế − dự báo ở kỳ t. Khóa dạy đo sai số trước khi dạy thêm phương pháp mới — vì không đo thì không biết phương pháp nào tốt hơn, và đây là phần nối thẳng với tuần 1 của khóa 177 (MAD/MSE/MAPE/bias ở đó là cùng bộ công cụ, áp cho cùng một việc).

| Thước đo | Công thức | Đọc thế nào |
|---|---|---|
| **MAD** (độ lệch tuyệt đối trung bình) | trung bình \|e(t)\| | Sai trung bình bao nhiêu đơn vị — cùng đơn vị với nhu cầu, dễ hiểu nhất, là thước nên báo cáo lên quản lý |
| **MSE** (sai số bình phương trung bình) | trung bình e(t)² | Phạt nặng sai số lớn — dùng khi một lần sai lớn đắt hơn nhiều lần sai nhỏ (ví dụ: thiếu hàng dịp cao điểm) |
| **MAPE** (sai số phần trăm tuyệt đối trung bình) | trung bình \|e(t)/thực tế\| × 100% | Sai bao nhiêu % — so được giữa các sản phẩm khác nhau; méo khi mẫu số nhỏ (nhu cầu tháng thấp) |
| **Bias / CFE** (độ chệch, sai số tích lũy) | tổng e(t), có dấu | Bias dương kéo dài = dự báo luôn thấp (thiếu hàng mãn tính); bias âm = dự báo luôn cao (tồn kho phình) |

### 2.2. Tracking signal — cái còi báo mô hình mất kiểm soát

**Tracking signal TS = CFE / MAD.** TS đo độ chệch so với sai số điển hình: TS càng lớn thì sai số càng dồn về một hướng. **Ngưỡng chuẩn: |TS| > 4 thì mô hình mất kiểm soát** — phải xem lại (đổi phương pháp, đổi tham số, hoặc kiểm tra xem nhu cầu đã đổi mẫu). Đây là thước mà MAD/MSE/MAPE không thay thế được: một mô hình có thể có MAD nhỏ mà vẫn chệch đều một hướng — chính xác trung bình nhưng sai có hệ thống. TS là phiên bản "SPC cho dự báo": cùng tư duy với biểu đồ kiểm soát của khóa 175 — theo dõi một chỉ số theo thời gian, vượt ngưỡng thì can thiệp, không chờ tới khi thiệt hại hiện ra.

### 2.3. Trung bình trượt — và cái giá của việc làm mượt

**Trung bình trượt k kỳ: F(t+1) = trung bình của k kỳ gần nhất.** Càng lấy nhiều kỳ (k lớn) thì càng mượt (triệt nhiễu tốt) nhưng càng chậm bắt thay đổi; k nhỏ thì nhạy nhưng nhảy theo nhiễu. **Trung bình trượt có trọng số** cho kỳ gần nhất trọng số lớn hơn kỳ xa — là bước đệm sang làm mượt hàm mũ ở module 3. Điểm yếu chung của họ trung bình trượt: **trễ xu hướng (lag)** — trên dãy tăng, dự báo luôn thấp hơn thực tế, vì trung bình của quá khứ thì luôn thấp hơn hiện tại khi dãy đang đi lên; k càng lớn thì trễ càng nặng.

**Áp dụng cho Anh:** (1) Mọi dự báo gửi lên quản lý phải kèm MAD/MAPE **và** tracking signal: "dự báo 2.000 thùng, sai trung bình 8%, tracking signal 1,2 (trong ngưỡng)" mới là báo cáo đầy đủ; chỉ đưa con số dự báo không kèm sai số là báo cáo thiếu một nửa — đúng kỷ luật của task 144. (2) Tính tracking signal hàng tháng cho dự báo nhu cầu bao bì/nguyên liệu: TS vượt ±4 hai tháng liên tiếp thì không phải "nhu cầu biến động" mà là mô hình đã sai mẫu — đổi phương pháp, đừng cố vá bằng cách cộng thêm "hệ số an toàn" cảm tính.

## 3. Module 3 — Làm mượt hàm mũ và chọn phương pháp: so trên cùng một thước

### 3.1. Làm mượt hàm mũ đơn (SES) — trung bình trượt không bao giờ quên hẳn

**Công thức: F(t+1) = F(t) + α·(D(t) − F(t))**, hay viết lại: **F(t+1) = α·D(t) + (1−α)·F(t)**, với 0 < α < 1. Mỗi kỳ mới chỉ điều chỉnh dự báo cũ một phần α của sai số vừa thấy. Khai triển ra thì SES là trung bình có trọng số của **toàn bộ** quá khứ, trọng số giảm theo cấp số nhân khi lùi về xa (α, α(1−α), α(1−α)², …) — đó là nguồn gốc tên "hàm mũ". Khác với trung bình trượt (quên hẳn quá khứ ngoài k kỳ), SES không bao giờ quên hẳn — kỳ rất xa vẫn còn trọng số rất nhỏ.

**α là núm chỉnh độ nhạy:** α lớn (0,5) thì dự báo chạy theo kỳ mới nhất — nhạy với thay đổi thật nhưng cũng nhảy theo nhiễu; α nhỏ (0,1) thì ổn định nhưng chậm bắt thay đổi. **Chọn α bằng số liệu, không chọn bằng cảm tính:** thử nhiều α (0,1 / 0,3 / 0,5…), tính MAD của từng α trên cùng dữ liệu, chọn α có MAD nhỏ nhất. Trong Excel chỉ cần một ô nhập α và một cột công thức `=dự báo cũ + α×(thực tế − dự báo cũ)` rồi kéo xuống — đúng phong cách Excel của cả khóa 177 và khóa này.

**Giới hạn phải nhớ:** SES chỉ theo dõi **mức (level)** — dự báo của nó là một đường ngang (mọi kỳ tương lai đều cùng một số). Trên dãy có xu hướng, SES **trễ vĩnh viễn**: nó luôn chạy sau thực tế một khoảng, và khoảng trễ đó không thu hẹp dù α lớn cỡ nào — α lớn chỉ làm nó nhảy mạnh hơn quanh đường trễ. Đây là lý do khóa dạy tiếp "chọn phương pháp" thay vì dừng ở SES: khi dữ liệu có xu hướng, cần phương pháp có số hạng xu hướng.

**Phần mở rộng chuẩn (không nằm trong 4 module niêm yết — ghi rõ để không nhầm với nội dung khóa):** **Holt — làm mượt hàm mũ có xu hướng** — tách riêng mức L(t) và xu hướng T(t): L(t) = α·D(t) + (1−α)·(L(t−1)+T(t−1)); T(t) = β·(L(t)−L(t−1)) + (1−β)·T(t−1); F(t+1) = L(t)+T(t). Holt là bước tiếp nối tự nhiên khi SES trễ xu hướng; công thức chuẩn theo Penn State STAT 501. Nếu sau này team viết skill dự báo thì Holt là phương pháp nên có sẵn, nhưng báo cáo này không khẳng định khóa dạy Holt.

### 3.2. Ví dụ so sánh đầy đủ — chọn phương pháp bằng số, không bằng cảm tính

Cùng dãy nhu cầu 12 tháng ở mục 1.2 (1.200 → 2.100 thùng, có xu hướng tăng). Tính trên **cùng cửa sổ so sánh** (chỉ các kỳ mà mọi phương pháp đều có dự báo; riêng SES tính từ kỳ 2). Kết quả do Vịt tự tính bằng script (kiểm chứng lại được từ dãy số trên):

| Phương pháp | Dự báo tháng 13 | MAD (thùng) | MSE | MAPE | CFE | Tracking signal |
|---|---|---|---|---|---|---|
| Naive | 2.100 | 138,2 | 23.691 | 8,46% | +900 | **+6,51 — mất kiểm soát** |
| Trung bình tích lũy | 1.586 | 247,2 | 87.000 | 14,14% | +2.719 | **+11,00 — mất kiểm soát** |
| Trung bình trượt 3 kỳ | 1.950 | 158,5 | 31.840 | 9,14% | +1.387 | **+8,75 — mất kiểm soát** |
| SES α=0,1 | 1.543 | 311,6 | 124.662 | 18,13% | +3.428 | **+11,00 — mất kiểm soát** |
| SES α=0,3 | 1.839 | 193,8 | 49.015 | 11,39% | +2.131 | **+11,00 — mất kiểm soát** |
| SES α=0,5 | 1.957 | 145,7 | 29.243 | 8,66% | +1.514 | **+10,39 — mất kiểm soát** |
| Holt α=0,3, β=0,1 (mở rộng, T0 = mức tăng trung bình/tháng 81,8) | 2.089 | **79,3** | **9.211** | **5,02%** | −142 | **−1,79 — trong ngưỡng** |

**Đọc bảng này đúng cách — đây là bài học lớn nhất của module 3:**

- **Naive thắng về MAD/MAPE trong nhóm phương pháp chỉ theo mức** (138 thùng, 8,46%) — nhưng tracking signal +6,51 vẫn vượt ngưỡng: nó sai ít nhưng sai **đều về một hướng** (dự báo thấp), vì dãy đang tăng. Chọn naive chỉ vì MAD thấp nhất mà bỏ qua TS là sai lầm mà module 2 cảnh báo: "so mô hình trên nhiều thước đo, không xếp hạng chỉ bằng MAPE".
- **SES α=0,5 tốt hơn α=0,1** trên dãy này (MAD 146 so với 312) — vì nhu cầu đang đổi nhanh, α lớn bắt kịp hơn. Nhưng α=0,5 vẫn trễ xu hướng: TS +10,39. Tăng α không chữa được lỗi sai mẫu — nó chỉ làm dự báo nhảy mạnh hơn.
- **Chỉ Holt mới trong ngưỡng** (TS −1,79, MAPE 5,02%): vì nó là phương pháp duy nhất trong bảng có số hạng xu hướng. **Kết luận chọn phương pháp: với dữ liệu có xu hướng, phương pháp theo mức là sai mẫu từ đầu — dù tinh chỉnh α hay k cũng không cứu được.** Đây chính là điều module 4 yêu cầu làm trên dataset thật: không phải tìm "α tốt nhất" mà là tìm "họ phương pháp đúng" rồi mới tinh chỉnh tham số bên trong họ đó.
- **Cảnh báo về khởi tạo Holt:** kết quả Holt nhạy với giá trị xu hướng ban đầu T0. Với T0 = 150 (chênh lệch hai tháng đầu) thì Holt dự báo quá cao, CFE −1.646, TS −10,86 — cũng mất kiểm soát, chỉ khác hướng. Với T0 = 81,8 (mức tăng trung bình/tháng của cả dãy) thì Holt trong ngưỡng. Bài học: **phương pháp tốt mà khởi tạo cẩu thả thì vẫn cho đáp án tệ** — ghi rõ cách khởi tạo khi bàn giao mô hình, đừng chỉ bàn giao con số dự báo.

### 3.3. Làm gì với dự báo sau khi triển khai

Module 3 không dừng ở việc chọn phương pháp — nó dạy **vận hành dự báo**: sau khi chọn, theo dõi tracking signal hàng kỳ (như biểu đồ kiểm soát); khi TS vượt ±4 thì xem lại — có thể nhu cầu đã đổi mẫu (mở kênh bán mới, mất khách lớn, thay đổi giá), hoặc tham số đã cũ; dự báo là đầu vào cho S&OP (module 4), không phải con số treo tường. Và **đừng bao giờ đánh giá phương pháp trên dữ liệu nó đã "thấy"** (in-sample) rồi tin tuyệt đối — cách làm đúng là giữ lại vài kỳ cuối làm mẫu kiểm chứng (holdout): chọn phương pháp trên phần đầu, kiểm tra trên phần cuối chưa dùng để chọn — nếu không, phương pháp nào "học thuộc" quá khứ tốt nhất sẽ thắng một cách giả tạo.

**Áp dụng cho Anh:** (1) Dự báo nhu cầu bao bì/nguyên liệu tháng sau bằng SES trong Excel với 3 cột α (0,1 / 0,3 / 0,5) — một bảng, so MAD, chọn α thắng; cộng thêm cột Holt khi thấy TS vượt ±4 kéo dài (dấu hiệu có xu hướng). (2) Mỗi tháng ghi lại TS của phương pháp đang dùng vào cùng file dự báo: TS trong ±4 thì giữ nguyên; vượt ngưỡng thì đổi phương pháp trước khi đổi con số dự báo — sửa mô hình, không sửa kết quả bằng tay. (3) Khi trình dự báo, trình cả bảng so sánh như mục 3.2 (phương pháp, MAD, MAPE, TS) thay vì chỉ một con số: người quyết thấy ngay vì sao chọn phương pháp này và nó tin được tới đâu.

## 4. Module 4 — Supply Chain Planning: từ dự báo ra kế hoạch S&OP

### 4.1. S&OP là gì — và nó nằm ở đâu trong tháp lập kế hoạch

**S&OP (Sales and Operations Planning) là quy trình liên phòng ban, theo chu kỳ tháng, để cân đối cung và cầu ở mức tổng hợp (product family, không phải từng SKU) trên tầm nhìn 12–18 tháng**, rồi chốt thành một kế hoạch duy nhất mà bán hàng, sản xuất, tài chính và chuỗi cung ứng cùng cam kết. S&OP nằm ở **tầng chiến thuật** của tháp lập kế hoạch: trên nó là kế hoạch chiến lược dài hạn (xây nhà máy, mua dây chuyền lớn); dưới nó là MPS — Master Production Schedule (chia kế hoạch tổng hợp ra từng sản phẩm cụ thể theo tuần) rồi MRP (nổ nhu cầu nguyên vật liệu) và lịch chạy máy hàng ngày (tầng vận hành — đúng chỗ khóa 177 làm việc bằng Solver và mô phỏng).

**Quy trình S&OP 5 bước chuẩn (khung APICS/CPIM, tài liệu chuẩn công khai):**

1. **Thu thập dữ liệu** — nhu cầu lịch sử, tồn kho hiện tại, backlog, năng lực, chính sách công ty (tồn kho an toàn tối thiểu, % tăng ca tối đa, cấm sa thải…).
2. **Lập kế hoạch nhu cầu (demand planning)** — chính là dự báo của module 1–3, chốt thành dự báo không thiên vị (unconstrained forecast) cho từng product family.
3. **Lập kế hoạch cung ứng (supply planning)** — lập kế hoạch tổng hợp (aggregate plan): sản xuất bao nhiêu mỗi tháng, bằng giờ thường/tăng ca/thuê ngoài, tồn kho bao nhiêu, nhân sự bao nhiêu.
4. **Họp tiền S&OP (pre-S&OP)** — đối chiếu cung–cầu, cân các phương án, tính chi phí từng phương án, đưa ra một phương án đề xuất kèm các đánh đổi (trade-off) rõ ràng.
5. **Họp S&OP điều hành (executive S&OP)** — ban lãnh đạo chốt một kế hoạch duy nhất, làm cơ sở cho MPS và ngân sách.

**Điểm khóa nhấn mạnh qua mô tả module 4:** bài tập tổng hợp dùng **dataset thật** — học viên phải phân tích dữ liệu, thử nhiều phương pháp dự báo, rồi **đưa khuyến nghị có lý do** (không chỉ tính ra con số). Đó là đúng bản chất S&OP: dự báo chỉ là đầu vào; giá trị nằm ở quyết định cân đối — sản xuất bao nhiêu, tồn bao nhiêu, chấp nhận rủi ro nào.

### 4.2. Ba chiến lược lập kế hoạch tổng hợp — level, chase, hybrid

Kế hoạch tổng hợp phải trả lời: mỗi tháng sản xuất bao nhiêu, dùng tồn kho hay đổi nhân sự để hấp thụ chênh lệch cung–cầu? Có ba chiến lược nền:

| Chiến lược | Cách làm | Ưu điểm | Cái giá phải trả |
|---|---|---|---|
| **Level (sản xuất đều)** | Sản xuất với tốc độ không đổi cả kỳ; tồn kho tăng khi nhu cầu thấp, giảm khi nhu cầu cao | Nhân sự ổn định, không tuyển/sa thải, máy chạy đều, chất lượng ổn định | Tốn chi phí giữ tồn kho; rủi ro tồn kho lỗi thời (đúng bao bì in riêng, hạn dùng ngắn) |
| **Chase (đuổi theo nhu cầu)** | Sản xuất đúng bằng nhu cầu từng tháng; đổi nhân sự/tăng ca/thuê ngoài theo nhu cầu | Tồn kho thấp, ít vốn chôn trong kho | Chi phí tuyển/sa thải, tăng ca, đào tạo; nhân sự bấp bênh, chất lượng dao động khi đổi người liên tục |
| **Hybrid (hỗn hợp)** | Giữ tốc độ nền ổn định, dùng tăng ca + tồn kho đệm + thuê ngoài một phần cho đỉnh nhu cầu | Cân bằng hai thái cực; là phương án thực tế thường thắng | Phức tạp hơn khi lập và giải thích; cần tính đúng chi phí từng cấu phần mới biết hybrid nào tốt nhất |

**Nguyên tắc chọn:** không có chiến lược nào luôn thắng — tính **tổng chi phí** của từng phương án trên cùng một dự báo (chi phí sản xuất giờ thường + tăng ca + thuê ngoài + giữ tồn kho + tuyển/sa thải + thiếu hàng), rồi chọn tổng thấp nhất **kèm mức dịch vụ chấp nhận được**. Đây là cùng tư duy "đo bằng tiền" với shadow price ở khóa 177 tuần 2 — chỉ khác tầng: 177 tối ưu trong nhà máy theo ca, S&OP tối ưu ở tầng chuỗi theo tháng.

**Ví dụ minh họa — kế hoạch tổng hợp 6 tháng cho thùng carton in (số liệu do Vịt tự lập, nối từ dự báo module 3):** dự báo nhu cầu 6 tháng tới: 2.150, 2.250, 2.400, 2.350, 2.500, 2.650 thùng (trung bình 2.383/tháng); tồn kho đầu kỳ 300 thùng. Giả định minh họa: chi phí giữ tồn kho 2.000 đ/thùng/tháng; chi phí thay đổi tốc độ sản xuất (tuyển/sa thải/tăng ca) 15.000 đ cho mỗi thùng thay đổi tốc độ.

- **Level — sản xuất đều 2.384 thùng/tháng:** tồn kho cuối kỳ lần lượt 534, 668, 652, 686, 570, 304 thùng; tổng chi phí giữ tồn kho 6 tháng = **6.828.000 đ**; nhân sự ổn định cả kỳ.
- **Chase — sản xuất đúng nhu cầu từng tháng:** tồn kho giữ nguyên 300 thùng; tổng chi phí thay đổi tốc độ = **9.750.000 đ** (tháng 1 giảm từ 2.200 xuống 2.150 đã tốn 750.000 đ; các tháng tăng nhu cầu tốn 1,5–2,25 triệu/tháng).
- **Kết luận ví dụ này: level rẻ hơn chase 2.922.000 đ** — vì nhu cầu chỉ dao động quanh mức tăng nhẹ, tồn kho đệm rẻ hơn việc liên tục đổi nhân sự. **Nhưng kết luận này không khái quát được:** nếu nhu cầu dao động mạnh theo mùa (Tết tăng gấp đôi, tháng thấp giảm một nửa) thì chi phí giữ tồn kho của level phình lên và chase có thể thắng. Phải tính lại với dữ liệu thật mỗi kỳ — chiến lược đúng là kết quả của phép tính, không phải khẩu hiệu.

### 4.3. Tồn kho an toàn và mức dịch vụ — đệm bao nhiêu là đủ

Dự báo nào cũng sai (module 2), nên S&OP phải đặt **tồn kho an toàn (safety stock)** để hấp thụ sai số dự báo trong thời gian chờ hàng (lead time). Công thức chuẩn: **SS = z × σ_LTD**, trong đó σ_LTD là độ lệch chuẩn của nhu cầu trong lead time, z là hệ số mức dịch vụ (z = 1,65 cho mức dịch vụ 95%, z = 2,33 cho 99%). Ví dụ: σ nhu cầu tháng ≈ 150 thùng (độ lệch chuẩn phần dư của dự báo tốt nhất ở mục 3.2 là ~79 thùng cho Holt — lấy 150 cho thận trọng), lead time 1 tháng, muốn phục vụ 95% nhu cầu → **SS ≈ 1,65 × 150 ≈ 248 thùng**; muốn 99% → **≈ 350 thùng**. Tăng mức dịch vụ từ 95% lên 99% tốn thêm ~100 thùng tồn kho — **mức dịch vụ là quyết định kinh tế, không phải mục tiêu càng cao càng tốt**: mỗi điểm % dịch vụ thêm đều có giá bằng tồn kho, và S&OP là nơi chốt con số đó với bán hàng và tài chính cùng bàn, không phải kho tự quyết.

### 4.4. Hiệu ứng bullwhip — vì sao dự báo càng lên cao càng méo

**Bullwhip effect:** biến động nhu cầu càng khuếch đại khi đi ngược lên chuỗi cung ứng — khách lẻ dao động ±10%, nhà phân phối đặt hàng dao động ±20%, nhà máy thấy đơn đặt dao động ±40%. Nguyên nhân: mỗi tầng dự báo dựa trên đơn đặt hàng của tầng dưới (không phải nhu cầu thật), cộng tồn kho an toàn của riêng mình, cộng đặt hàng theo lô — ba lớp đệm chồng lên nhau thành roi quất. Hệ quả cho nhà máy: lịch sản xuất nhảy múa theo đơn đặt của khách hàng (distributor), không theo nhu cầu thật của người tiêu dùng. **Thuốc chữa nằm trong S&OP:** chia sẻ dữ liệu nhu cầu thật xuyên chuỗi (không dự báo trên đơn đặt hàng), rút ngắn lead time, giảm đặt hàng theo lô, và chốt một dự báo duy nhất cho cả chuỗi trong họp S&OP — đúng chỗ khóa này đặt dự báo vào trong S&OP thay vì để mỗi phòng tự dự báo một kiểu.

**Áp dụng cho Anh:** (1) Đề xuất họp S&OP tháng cho IFT: bán hàng đưa dự báo nhu cầu theo product family, sản xuất đưa năng lực + tồn kho, cùng chốt một kế hoạch sản xuất 3–6 tháng — thay vì mỗi bên tự tính rồi đổ lỗi khi thiếu hàng/thừa kho. (2) Lập kế hoạch tổng hợp cho bao bì/đường/sữa bột theo quý: tính level vs chase vs hybrid bằng tổng chi phí (như mục 4.2) rồi trình Linh Lê/Hao kèm bảng so sánh — quyết định có số, không tranh luận bằng cảm tính. (3) Đặt tồn kho an toàn bằng công thức z × σ thay vì "để dư 500 cho chắc": mức dịch vụ 95% hay 99% là quyết định cần chốt với quản lý, vì mỗi mức có giá tồn kho khác nhau. (4) Khi đơn đặt hàng từ khách/distributor nhảy mạnh, đối chiếu với nhu cầu thật trước khi đổi lịch sản xuất — coi chừng bullwhip: đổi lịch theo đơn đặt dao động là tự đưa biến động vào nhà máy mình.

## Nối mạch: 172 → 174 → 175 → 177 → 178

| Khóa | Vai trò trong mạch | Nối vào 178 như thế nào |
|---|---|---|
| 172 Introduction to Operations Management (Wharton) | Khung vận hành: nút thắt, Little's Law, 7 lãng phí, Six Sigma, TPS | Nút thắt ở 172 là ràng buộc năng lực trong bước 3 của S&OP (supply planning): dự báo nhu cầu có cao mấy cũng phải qua năng lực thật của nút thắt; Little's Law (tồn kho = lưu lượng × thời gian) là quan hệ nền cho tồn kho trong kế hoạch tổng hợp |
| 174 TPM and OEE (iCompetent) | Đo thiết bị: 6 tổn thất lớn, OEE, TEEP, MTBF/MTTR | OEE lịch sử là **năng lực thật** đưa vào S&OP: kế hoạch tổng hợp lập trên công suất danh nghĩa mà không trừ tổn thất thì ngay từ đầu đã là kế hoạch không làm được; tồn kho an toàn phải tính cả biến động do hỏng máy, không chỉ biến động nhu cầu |
| 175 Lean Six Sigma Black Belt (Alison) | Chứng minh bằng thống kê: DMAIC, Cp/Cpk, Gage R&R, SPC, DOE | Tracking signal ở module 2 là **SPC cho dự báo** — cùng tư duy biểu đồ kiểm soát ở Control: theo dõi một chỉ số, vượt ngưỡng thì can thiệp; pha Analyze của DMAIC là nơi dùng dự báo + S&OP để chọn giải pháp cải tiến có căn cứ |
| 177 Operations Analytics (Wharton) | Phân tích định lượng trong nhà máy: Newsvendor, dự báo, Solver, mô phỏng, cây quyết định | 177 dạy dự báo **trong nhà máy** (Newsvendor cho lượng đặt một lần, SES cho dự báo tháng, Solver cho lịch chạy máy theo ca, mô phỏng cho rủi ro sản lượng); 178 đưa cùng bộ công cụ đó **lên tầng chuỗi cung ứng** (dự báo theo product family, S&OP theo tháng, kế hoạch tổng hợp). Hai khóa không trùng: 177 sâu về công cụ định lượng, 178 rộng về quy trình cân đối liên phòng ban. MAD/MAPE/bias/SES ở 177 là cùng bộ công cụ với module 2–3 ở đây — học 178 là ôn lại và đặt chúng vào đúng vị trí trong S&OP |
| 169 Customer Analytics (Wharton) | Phân tích khách hàng — khóa #1 cùng chuỗi Business Analytics | Dự báo nhu cầu ở S&OP (bước 2) cần hiểu khách hàng mua gì, mua khi nào — 169 đo phía cầu, 178 biến phía cầu đó thành kế hoạch cung; hai khóa gặp nhau ở bước lập kế hoạch nhu cầu |

**Luồng dữ liệu xuyên suốt 5 khóa — điểm quan trọng nhất của báo cáo:** dữ liệu thu thập ở 174 (nhật ký dừng máy, OEE từng ca) → kiểm chứng độ tin cậy ở 175 (Gage R&R, capability) → phân tích và ra quyết định trong nhà máy ở 177 (dự báo, tối ưu, mô phỏng, cây quyết định) → **nâng lên tầng chuỗi ở 178 (dự báo theo product family, S&OP, kế hoạch tổng hợp, tồn kho an toàn)**. Thiếu một mắt xích thì các mắt sau sai: S&OP lập trên năng lực danh nghĩa (không trừ OEE) thì kế hoạch tháng nào cũng "đạt trên giấy, vỡ dưới xưởng"; dự báo trên dữ liệu nhu cầu bị kiểm duyệt (ngày hết hàng, khóa 177 mục 1.1) thì S&OP cân đối cung–cầu dựa trên nhu cầu thấp hơn thật. Đây cũng là lý do thứ tự học B1 → B2 → B3 → B5 → B4 là đúng (theo đề xuất trong báo cáo 174): học đo đúng trước, học phân tích trong nhà máy sau, học cân đối ở tầng chuỗi cuối cùng.

## Áp dụng: 6 việc làm được ngay ở dây chuyền đóng gói IFT

Xếp theo mức tác động/công sức, chỉ ở tầng nguyên tắc — việc nào chạm dây chuyền thật cũng cần Anh quyết trước:

| # | Việc | Công cụ trong khóa | Tác động kỳ vọng |
|---|---|---|---|
| 1 | Dự báo nhu cầu bao bì/nguyên liệu tháng sau bằng SES trong Excel (3 cột α 0,1/0,3/0,5, so MAD, chọn α thắng), báo cáo kèm MAD/MAPE + tracking signal | Dự báo, module 1–3 | Biết nhu cầu tháng sau sai khoảng bao nhiêu %; biết khi nào mô hình mất kiểm soát (TS vượt ±4) |
| 2 | Tính naive làm chuẩn đối chiếu cho mọi dự báo hiện có: mô hình nào không thắng được "lấy tháng trước làm dự báo" thì bỏ, đừng tinh chỉnh thêm | Benchmark, module 1 | Dừng việc tinh chỉnh mô hình yếu; chỉ đầu tư công sức vào mô hình đã chứng minh thắng chuẩn đơn giản |
| 3 | Đề xuất họp S&OP tháng: bán hàng + sản xuất + kho cùng chốt một kế hoạch sản xuất 3–6 tháng theo product family | S&OP, module 4 | Một kế hoạch duy nhất thay vì mỗi phòng một số; giảm thiếu hàng do dự báo lệch nhau và thừa kho do đệm chồng đệm |
| 4 | Lập kế hoạch tổng hợp theo quý cho bao bì/đường/sữa bột: tính level vs chase vs hybrid bằng tổng chi phí rồi trình quản lý kèm bảng so sánh | Kế hoạch tổng hợp, module 4 | Quyết định sản xuất đều hay đuổi theo nhu cầu có số liệu chi phí, không tranh luận cảm tính |
| 5 | Đặt tồn kho an toàn bằng công thức z × σ (95% → z=1,65; 99% → z=2,33) thay vì "để dư cho chắc"; chốt mức dịch vụ với quản lý | Tồn kho an toàn, module 4 | Biết mỗi điểm % dịch vụ thêm tốn bao nhiêu tồn kho; tồn kho có lý do bằng tiền |
| 6 | Khi đơn đặt hàng distributor nhảy mạnh, đối chiếu nhu cầu thật trước khi đổi lịch sản xuất — coi chừng bullwhip | Bullwhip, module 4 | Không đưa biến động của tầng trên vào lịch chạy máy của mình; lịch ổn định hơn, đổi ca ít hơn |

**Cái không nên làm theo khóa một cách máy móc:** (1) Đừng chọn phương pháp chỉ vì MAD/MAPE thấp nhất mà bỏ qua tracking signal — mô hình sai ít nhưng sai đều một hướng vẫn là mô hình mất kiểm soát (bảng mục 3.2: naive thắng MAD mà TS +6,51). (2) Đừng tăng α hay tăng k để chữa một mô hình sai mẫu — SES không có số hạng xu hướng thì α bao nhiêu cũng trễ; đổi họ phương pháp, không tinh chỉnh tham số của họ sai. (3) Đừng đánh giá phương pháp trên dữ liệu nó đã "thấy" — giữ vài kỳ cuối làm mẫu kiểm chứng, nếu không phương pháp học thuộc quá khứ sẽ thắng giả tạo. (4) Đừng lập S&OP trên công suất danh nghĩa — trừ OEE/tổn thất (khóa 174) ra khỏi năng lực trước khi cân đối, nếu không kế hoạch tháng nào cũng vỡ dưới xưởng. (5) Đừng đặt tồn kho an toàn theo cảm tính "dư cho chắc" — mức dịch vụ là quyết định kinh tế có giá bằng tồn kho, phải chốt với quản lý. (6) Đừng dự báo trên đơn đặt hàng của tầng dưới rồi gọi đó là nhu cầu — đó là nguồn gốc bullwhip; dự báo phải dựa trên nhu cầu thật càng gần người tiêu dùng càng tốt. Đây là cùng cảnh báo với task 142 (AI For Everyone) và task 172/174/177: kiến thức nền phải đọc cùng bối cảnh thật, không áp máy móc.

## Đề xuất tiếp theo cho team

- **Khóa nối tiếp tự nhiên trong danh sách 20:** B7 **Excel Skills for Business: Essentials** (Macquarie, Coursera, ~6 tuần, 3–5 giờ/tuần) — nâng tay nghề Excel (hàm, dashboard) để chạy các mô hình trong báo cáo này và báo cáo 177 nhanh hơn, vì mọi công cụ của cả hai khóa đều chạy trên Excel. Thứ tự này theo đúng đề xuất trong báo cáo 177 và ghi chú trong task 178.
- **Khóa dự phòng trùng nội dung:** B8 **Supply Chain Fundamentals** (MITx, edX, 13 tuần, 8–12 giờ/tuần) trùng một phần với B4 ở tầng chuỗi cung ứng (dự báo, tồn kho, vận tải, thiết kế mạng lưới) nhưng đi sâu và nặng toán hơn — học sau B4 chỉ khi cần đi sâu, không phải khóa tiếp theo mặc định. Khóa này là khóa duy nhất trong danh sách 20 dạy S&OP và lập kế hoạch tổng hợp; không có khóa nào khác trùng vai trò này.
- **Đề xuất cập nhật skill:** không có — khóa này không thêm pattern build extension nào; kiến thức dùng cho báo cáo ca/kíp, lập lịch và quản lý dây chuyền, không phải cho skill vBook. Nếu sau này team viết skill "đọc báo cáo sản xuất bằng AI" thì khung S&OP (dự báo → kế hoạch tổng hợp → tồn kho an toàn) + bảng so sánh phương pháp dự báo (MAD/MAPE/tracking signal) + checklist 5 câu hỏi của task 144 là ba mảnh ghép sẵn.
- **Liên hệ các báo cáo trước:** task 172 (Introduction to Operations Management — nút thắt, Little's Law) là nền; task 174 (TPM/OEE — năng lực thật đưa vào S&OP) và 175 (Black Belt — SPC/tracking signal, pha Analyze) là hai mắt xích trước; task 177 (Operations Analytics — cùng bộ công cụ dự báo, ở tầng nhà máy) là khóa chị em trực tiếp; task 169 (Customer Analytics — đo phía cầu cho bước lập kế hoạch nhu cầu) là khóa bổ sung; task 144 (Work smarter with AI — checklist 5 câu hỏi soát nội dung AI soạn) là kỷ luật đối chiếu khi dùng mô hình để viết báo cáo ca.

## Nguồn

- Trang khóa chính thức (Coursera): https://www.coursera.org/learn/planning?specialization=supply-chain-management (đọc 21/11/2026 — 4 module, 1 tuần ~10 giờ, 106.042 học viên, 4,7/5 với 3.092 đánh giá, giảng viên Rudolf Leuschner, Ph.D., mô tả khóa, FAQ Audit/chứng chỉ, 9 bài tập AI-graded)
- Syllabus công khai (Class Central): https://www.classcentral.com/course/coursera-planning-6922 (mô tả 4 module; tóm tắt: "Learn to forecast demand with naive, cumulative mean, moving average and exponential smoothing methods, judge forecast accuracy, and build a Sales and Operations Plan")
- Syllabus công khai (OpenCourser): https://opencourser.com/course/v8odfe/supply-chain-planning (mô tả 4 module; nghề liên quan: Demand Planner, Supply Chain Analyst, Inventory Manager…)
- Làm mượt hàm mũ đơn và Holt, công thức SES/Holt, thước đo MSE/MAE/MAPE: https://online.stat.psu.edu/stat501/book/export/html/1001 (Penn State STAT 501) ; https://opscalculators.com/forecasting-analytics/exponential-smoothing-calculator/ ; https://cellwise.app/guides/exponential-smoothing-forecast-in-excel/ (chọn α bằng MAD; tracking signal vượt ±4 là mất kiểm soát)
- Thước đo sai số CFE/MAD/MSE/MAPE/tracking signal, so sánh mô hình trên nhiều thước đo: https://agentlefs.com/context/Faaz17/Agents-and-Skills/skills/research-writing/forecasting-methods/SKILL.md
- Khung S&OP, ba tầng lập kế hoạch (chiến lược/chiến thuật/vận hành), level vs chase: https://uen.pressbooks.pub/scmintro/wp-json/pressbooks/v2/chapters/455 (giáo trình SCM mở) ; https://trustedinstitute.com/concept/cpim/sales-operations-planning/aggregate-supply-production-planning/ (CPIM: 3 chiến lược tổng hợp, 5 bước lập kế hoạch tổng hợp, MPS)
- Danh sách khóa đã duyệt: research/171-danh-sach-khoa-hoc-cong-viec-da-duyet.md (mục B4)
- Báo cáo khóa trước: research/172-introduction-to-operations-management-wharton.md (nút thắt, Little's Law); research/174-total-productive-maintenance-oee.md (OEE, năng lực thật); research/175-lean-six-sigma-black-belt-alison.md (SPC, DMAIC, pha Analyze); research/177-operations-analytics-wharton.md (dự báo, SES, Solver, mô phỏng, cây quyết định — tầng nhà máy); research/169-customer-analytics-wharton-upenn.md (phía cầu); research/144-work-smarter-with-ai.md (checklist 5 câu hỏi)
