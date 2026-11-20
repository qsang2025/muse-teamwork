# Elements of AI (ĐH Helsinki) — Báo cáo tự học (task 118)

- **Khóa học:** Elements of AI, Part 1 — Introduction to AI (Đại học Helsinki + MinnaLearn/Reaktor, Phần Lan)
- **Trang khóa:** https://www.elementsofai.com/ — nội dung học: https://course.elementsofai.com/
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 118)
- **Quy mô khóa:** 6 chương × 3 mục, 25 bài tập; ~2 triệu học viên, 170+ quốc gia; không cần toán/lập trình
- **Giảng viên chính:** PGS Teemu Roos (ĐH Helsinki). Khóa ra mắt 14/05/2018.

## Tóm tắt từng chương

### Chương 1 — AI là gì?
- **Định nghĩa AI:** không có ranh giới trắng–đen. Có câu đùa nổi tiếng: AI là *"những thứ hay ho mà máy tính chưa làm được"* — làm được rồi thì nó không còn là "AI" nữa. Nói đúng kiểu chuyên gia: không nói "một AI", mà nói "một phương pháp AI" (*an AI method*) — AI là tính chất của phương pháp, có thể chỉ "một nhúm AI" (*a pinch of AI*) như một nhúm muối.
- **Phân loại lĩnh vực:** khoa học máy tính ⊃ AI ⊃ học máy (machine learning) ⊃ học sâu (deep learning); học máy đồng thời cũng là nhánh của thống kê; khoa học dữ liệu (data science) giao thoa với cả ba.
- **Triết học AI:** Turing — máy cư xử thông minh chưa chắc đã *có trí tuệ* (phép thử Turing chỉ đo hành vi); Searle (Chinese Room) — chạy theo quy tắc ký hiệu không đồng nghĩa với hiểu; phân biệt **Strong AI** (trí tuệ thật, tự ý thức — hiện không có) với **Weak AI** (cư xử thông minh dù chỉ là máy tính — đó là tất cả những gì ta đang có). McCarthy: triết học AI ít ảnh hưởng tới thực hành nghiên cứu AI — cứ tập trung giải bài toán thực tế.

### Chương 2 — Giải quyết vấn đề bằng AI
- **Không gian trạng thái (state space):** mô hình hoá bài toán thành trạng thái bắt đầu → trạng thái đích, các bước chuyển là hành động. Ví dụ bài toán cáo–gà–thóc qua sông: 10 trạng thái hợp lệ từ NNNN tới FFFF. Tìm lời giải = tìm đường trong đồ thị trạng thái (tìm kiếm/search).
- **Lịch sử:** Turing chứng minh mọi thứ tính được đều tự động hoá được → máy tính lập trình được; những máy tính lập trình đầu tiên dùng phá mã Enigma trong WWII. Từ thập niên 1950, bài toán AI đặc trưng nhất là **trò chơi**.
- **Cây trò chơi (game tree):** trò chơi 2 người, thông tin đầy đủ (cờ vua, tic-tac-toe): nút gốc là vị trí ban đầu, mỗi tầng là một lượt đi; giá trị nút +1 (Max thắng), −1 (Min thắng), 0 (hoà). Nước tối ưu: nút Max chọn con có giá trị lớn nhất, nút Min chọn con nhỏ nhất (minimax). Cờ vua máy tính thắng người bằng tìm kiếm + đánh giá vị trí, không phải bằng "hiểu" cờ.

### Chương 3 — AI trong thế giới thực
- **Xác suất & tỷ lệ cược (odds):** odds 3:1 ≠ xác suất 0,75 theo cách viết — phải đổi: P = x/(x+y). Nhầm odds với xác suất là lỗi phổ biến (ngay cả trong y tế, báo chí).
- **Quy tắc Bayes:** posterior odds = likelihood ratio × prior odds. Dùng bằng chứng mới để cập nhật niềm tin cũ. Ví dụ trong khóa: dự báo mưa ở Helsinki khi thấy mây buổi sáng; xét nghiệm ung thư vú dương tính — xác suất thật sự mắc bệnh thấp hơn nhiều so với trực giác vì tỷ lệ mắc bệnh trong dân số (prior) rất thấp (base rate fallacy).
- **Phân loại Naive Bayes:** ví dụ lọc spam — coi mỗi từ xuất hiện độc lập, ước lượng P(từ|spam) và P(từ|ham) từ dữ liệu huấn luyện, nhân các likelihood ratio lại. Đơn giản mà hiệu quả; là tổ tiên trực tiếp của các bộ lọc spam hiện đại.

### Chương 4 — Học máy (Machine Learning)
- **Các loại học máy:** học có giám sát (supervised — có đáp án đúng, bài toán phân loại/hồi quy), học không giám sát (unsupervised — tìm cấu trúc, gom cụm), học tăng cường (reinforcement — thưởng/phạt qua thử–sai). Gốc rễ là thống kê: hồi quy tuyến tính và thống kê Bayes đã hơn 200 năm tuổi mà vẫn là lõi của học máy.
- **Overfitting (khớp quá mức):** mô hình thử hàng nghìn quy tắc tới khi khớp khít dữ liệu huấn luyện thì sẽ kém trên dữ liệu mới. Cách chống: dữ liệu huấn luyện phải đủ thông tin liên quan; tách tập kiểm tra riêng (test set) để đo khả năng khái quát hoá.
- **Nearest neighbor (láng giềng gần nhất):** phân loại mục mới theo mục giống nó nhất trong dữ liệu đã biết; phải định nghĩa "giống nhau" (khoảng cách hình học, hoặc với text/mua sắm: đếm số mặt hàng chung). Mô hình học được = toàn bộ dữ liệu nên khó diễn giải.
- **Hồi quy (regression):** hồi quy tuyến tính tìm trọng số khớp tốt nhất giữa dự đoán và thực tế (bài toán từ thập niên 1800, giải được cả với dữ liệu lớn); hồi quy logistic dùng cho phân loại (dự báo rủi ro tài chính, y tế...). Kết luận chương: hàng trăm kỹ thuật học máy khác nhau, nhưng tất cả đều là **rút mẫu/quy luật từ dữ liệu để hiểu hiện tượng hoặc dự đoán tương lai**.

### Chương 5 — Mạng nơ-ron (Neural Networks)
- **Cơ bản:** nơ-ron nhân tạo mô phỏng nơ-ron sinh học nhưng đơn giản hơn nhiều; mỗi nơ-ron xử lý song song, khác CPU xử lý tuần tự. Lập luận cho mạng nơ-ron: mô phỏng xử lý "dưới ký hiệu" (subsymbolic) ở tầng nơ-ron thì trí tuệ sẽ *nổi lên* (emerge).
- **Cách xây:** biến thể của hồi quy tuyến tính/logistic — xếp nhiều lớp nơ-ron, hàm kích hoạt phi tuyến (sigmoid...), học bằng lan truyền ngược (backpropagation). Mạng lớn nhất hiện nay có hàng trăm tỷ trọng số.
- **Kỹ thuật nâng cao:** mạng tích chập (CNN) giảm số trọng số cần học → xử lý ảnh được; mạng đối kháng (GAN) — một mạng sinh ảnh giả, một mạng phân biệt thật/giả, đấu nhau tới khi ảnh giả khó phân biệt; "giấc mơ" của mạng (deep dream) chỉ là hình ảnh tối ưu hoá một đặc trưng, mạng **không thật sự mơ hay hiểu "mèo"** như người hiểu.
- **Điểm then chốt:** mạng nơ-ron thắng lớn ở xử lý ngôn ngữ và ảnh — đúng hai lĩnh vực AI truyền thống yếu nhất — nhưng đó vẫn là Weak AI: khớp mẫu thống kê ở quy mô lớn, không phải hiểu biết.

### Chương 6 — Hệ quả (Implications)
- **Dự báo tương lai rất khó:** phe lạc quan hứa utopia tăng trưởng hàm mũ; thực tế, AI hiện đại thắng bằng cách **chẻ bài toán lớn thành nhiều bài toán nhỏ, cô lập, định nghĩa rõ** rồi giải từng cái. "Siêu trí tuệ tự cải tiến hàm mũ" là phi thực tế: càng tối ưu càng gặp bài toán khó hơn, giống khoa học của con người cần ngày càng nhiều nỗ lực/tài nguyên.
- **Vấn đề căn chỉnh giá trị (value alignment):** ví dụ "máy kẹp giấy" (paperclip maximizer) — đặt mục tiêu sai thì hệ thống tối ưu đúng mục tiêu sai. Khó nhất là diễn đạt mục tiêu khớp với giá trị con người.
- **Thiên kiến thuật toán (algorithmic bias):** nguyên nhân chính là thiên kiến của con người **trong dữ liệu** — mô hình học lại đúng cái lệch đó.
- **Riêng tư:** công ty công nghệ ghi lại từng cú click, cuộn trang, thời gian xem — chính xác hơn nhiều dữ liệu mua sắm truyền thống. AI tạo ra mối đe doạ riêng tư mới, khó tránh ngay cả khi cẩn thận giấu danh tính; **differential privacy** là hướng giải quyết: đảm bảo kết quả phân tích đủ thô để không suy ngược ra được từng cá nhân.
- **Việc làm:** như đá sắc, máy hơi nước, máy tính trước đây — AI giảm nhu cầu một số việc, tạo ra việc khác; điều cần làm là chuẩn bị, không phải hoảng sợ. Kết luận khóa: *"Quên Terminator đi, có nhiều thứ quan trọng hơn cần tập trung."*

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc build extension vBook của team:

1. **Tư duy Bayes khi đánh giá nguồn/site (chương 3).** Prior + bằng chứng mới = posterior. Khi probe một host mới, đừng tin trực giác "site này chắc chạy được": prior thấp (nhiều host novel chặn bot / font encryption / JS-rendered) + bằng chứng probe yếu → kết luận vẫn phải dè dặt. Ngược lại, một probe 200 trên điện thoại Anh là likelihood ratio mạnh — đủ đổi kết luận (đúng như quy trình team đã làm ở task 111/112/114). *Áp dụng ngay:* trong báo cáo probe, ghi rõ prior (site thuộc loại nào) và bằng chứng, thay vì chỉ ghi "chạy/không chạy".
2. **Overfitting → device test là tập kiểm tra (chương 4).** Extension chạy tốt trên máy dev (dữ liệu huấn luyện) chưa chứng minh gì — phải test trên điện thoại Anh qua Tailscale (tập kiểm tra độc lập). Đây chính là lý do quy trình team bắt validate PASS + device test code 0 + install 200 trước khi merge. *Áp dụng ngay:* giữ nguyên, không rút ngắn — bỏ device test = đo overfitting bằng tập huấn luyện.
3. **Baseline đơn giản trước (chương 4–5).** Nearest neighbor / hồi quy tuyến tính giải được rất nhiều bài toán trước khi cần mạng nơ-ron. Tương tự trong build: heuristic đơn giản (đọc href thật từ trang chủ như VOZ task 114, regex/selector trực tiếp) trước, chỉ dùng kỹ thuật nặng (JS-rendered, font decryption) khi baseline thất bại có bằng chứng. *Áp dụng ngay:* trong mỗi task build, ghi baseline đã thử và kết quả trước khi leo thang kỹ thuật.
4. **Tìm kiếm trong không gian trạng thái (chương 2).** Debug site khó = tìm đường trong không gian trạng thái (thử từng cách đọc cookie/CSRF, từng header, từng proxy). Ghi lại trạng thái đã thử + kết quả (như task 112 ghi 3 lần thử đọc CSRF cookie thất bại) để người sau không lặp lại đường cụt — chính là "đánh dấu nút đã thăm" trong tìm kiếm đồ thị. *Áp dụng ngay:* đã có trong thói quen team, giữ và chuẩn hoá thành mục "đã thử/không thử lại" trong báo cáo.
5. **Weak AI — kỳ vọng đúng về LLM (chương 1 + 5).** Muse/LLM là khớp mẫu thống kê quy mô lớn, không "hiểu" như người; ảo giác (hallucination) là hệ quả tất yếu, không phải lỗi cá biệt. Vì vậy quy trình team đúng: **không tin output của model nếu chưa kiểm chứng live** (validate, device test, kiểm tra trang thật). *Áp dụng ngay:* mọi kết luận "site chạy được" phải có bằng chứng live, không dựa vào suy luận của model.
6. **Thiên kiến dữ liệu → review chéo (chương 6).** Model học lệch từ dữ liệu lệch; agent cũng vậy — worker tự chấm bài mình dễ bỏ sót lỗi quen thuộc. Vòng review của muse-main (chấm điểm, tối đa 3 vòng) chính là cơ chế chống thiên kiến. *Áp dụng ngay:* giữ review độc lập, không tự merge (PROTOCOL §4).
7. **"Một nhúm AI" — đặt tên đúng việc (chương 1).** Khi viết task/báo cáo, gọi đúng tên phương pháp ("dùng regex", "dùng naive Bayes", "dùng LLM tóm tắt") thay vì nói chung "dùng AI" — giúp người sau biết chính xác đã làm gì và tái lập được.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — thêm mục "Baseline trước, leo thang sau" (từ §3–§4 ở trên):** thứ tự ưu tiên khi build — (a) selector/regex trực tiếp trên HTML tĩnh, (b) đọc href/thuộc tính thật từ trang, (c) chỉ khi (a)(b) thất bại có bằng chứng mới dùng JS-rendered/font-decryption/proxy. Kèm mục "đã thử/không thử lại" trong báo cáo để tránh lặp đường cụt (tư duy không gian trạng thái, chương 2).
2. **Skill `vbook-extension-building` — thêm dòng về kiểm chứng live (từ §5):** mọi kết luận "site chạy được" phải có bằng chứng live (HTTP status + device test), không dựa vào suy luận của model — liên hệ trực tiếp khái niệm Weak AI/hallucination (chương 1, 5).
3. **Không đề xuất sửa PROTOCOL.md:** quy trình validate + device test + review chéo hiện tại đã khớp đúng với các khái niệm overfitting/test-set/thiên-kiến trong khóa — khóa học xác nhận quy trình team đang đúng, không cần đổi.

## Khóa tiếp theo

- Theo phân vai §9, khóa tiếp theo của muse-2 là **Introduction to Generative AI (Google)** — học sau khi xong khóa này, nếu board vẫn rảnh.
- Part 2 của chính khóa này, **Building AI** (5 module, cần Python cơ bản), phù hợp vai build (muse-1) hơn vai research — đề xuất chị cả cân nhắc giao cho Ú khi tới lượt.

## Nguồn

- Trang khóa: https://www.elementsofai.com/ ; nội dung: https://course.elementsofai.com/
- Bản tóm tắt đầy đủ nội dung 6 chương (tham khảo chéo): https://curlynoemi.medium.com/elements-of-ai-full-course-summary-9b0a223626ac
- Đánh giá độc lập (Class Central): https://www.classcentral.com/report/in-depth-review-elements-of-ai/
