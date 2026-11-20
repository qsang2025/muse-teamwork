# Introduction to Generative AI (Google) — Báo cáo tự học (task 119)

- **Khóa học:** Introduction to Generative AI, Google Cloud Skills Boost (microlearning, trình độ introductory)
- **Trang khóa:** https://www.cloudskillsboost.google/course_templates/536
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 119)
- **Quy mô khóa:** ~45 phút; video 22 phút + tài liệu đọc + quiz; rating 4,3/5 (5.109 đánh giá); không cần lập trình
- **Giảng viên:** Roger Martinez (Developer Relations Engineer, Google Cloud)
- **Phạm vi báo cáo:** học kỹ khóa chính (video + tài liệu + quiz); đọc thêm 2 khóa cùng learning path "Introduction to Generative AI" (journeys/118) — Introduction to Large Language Models và Introduction to Responsible AI — vì 3 khóa gộp lại mới đủ lấy badge Generative AI Fundamentals, và 2 khóa sau giải thích trực tiếp 2 khái niệm khóa chính chỉ nhắc qua (LLM, AI có trách nhiệm).

## Tóm tắt khóa chính — Introduction to Generative AI

### 1. AI, học máy, học sâu — lồng nhau như thế nào
- **AI** là một ngành (như vật lý) trong khoa học máy tính: tạo ra các agent thông minh có khả năng suy luận, học và hành động tự chủ — máy suy nghĩ và hành xử như con người.
- **Học máy (ML)** là nhánh của AI: chương trình huấn luyện mô hình từ dữ liệu đầu vào, rồi mô hình dự đoán trên dữ liệu mới chưa thấy, không cần lập trình tường minh từng quy tắc.
- **Học sâu (deep learning)** là nhánh của ML, dùng mạng nơ-ron nhân tạo để xử lý các mẫu phức tạp mà ML truyền thống không làm được.
- **GenAI là nhánh của học sâu.** Xếp tầng: AI ⊃ ML ⊃ deep learning ⊃ GenAI. So với Elements of AI (task 118): cùng một cái cây, khóa này đi sâu vào đúng ngọn — nhánh sinh nội dung — thay vì toàn bộ cây.

### 2. Hai loại mô hình học máy: có giám sát và không giám sát
- **Có giám sát (supervised):** huấn luyện trên dữ liệu có nhãn (tên, loại, số). Ví dụ trong khóa: chủ nhà hàng dùng dữ liệu cũ (tiền bill, hình thức gọi món, tiền tip) để dự đoán tip cho đơn mới. Quá trình học = đưa dữ liệu test (x) vào mô hình, so dự đoán với đáp án thật, sai lệch gọi là **error**, mô hình tối thiểu hoá error dần — một bài toán tối ưu hoá (khớp đúng chương 4 của Elements of AI: hồi quy + overfitting).
- **Không giám sát (unsupervised):** dữ liệu không nhãn, mục tiêu là khám phá — gom cụm nhân viên theo thâm niên và thu nhập để tìm nhóm tự nhiên trong dữ liệu thô.
- **GenAI dùng cả ba cách:** có giám sát, không giám sát và bán giám sát (semi-supervised) trên cả dữ liệu có nhãn lẫn không nhãn.

### 3. Generative vs. discriminative — điểm phân biệt cốt lõi của khóa
- **Discriminative model (mô hình phân biệt):** học phân phối xác suất có điều kiện P(y|x) — xác suất của đầu ra y khi biết đầu vào x — để gán nhãn cho dữ liệu. Ví dụ: phân loại ảnh là chó hay mèo. Huấn luyện trên dữ liệu có nhãn, học mối quan hệ giữa đặc trưng và nhãn.
- **Generative model (mô hình sinh):** học phân phối xác suất kết hợp P(x, y) — xác suất đồng thời của đầu vào và đầu ra — nên có thể sinh ra mẫu dữ liệu hoàn toàn mới. Ví dụ: tạo ra ảnh một con chó tên Fred, chưa từng tồn tại.
- **Cách thử nhanh (khóa nhấn mạnh):** nhìn đầu ra Y = F(X). Nếu Y là **số hoặc nhãn** (dự đoán doanh số, phân loại spam/không spam) → không phải GenAI. Nếu Y là **ngôn ngữ tự nhiên, hình ảnh, âm thanh** (định nghĩa "doanh số" bằng một câu) → là GenAI. Học máy truyền thống học quan hệ dữ liệu–nhãn để dự đoán; GenAI học mẫu trong nội dung để sinh nội dung mới.

### 4. Định nghĩa chính thức của GenAI
- **GenAI là loại AI tạo ra nội dung mới dựa trên những gì đã học từ nội dung có sẵn.** Quá trình học từ nội dung có sẵn gọi là **training**, tạo ra một mô hình thống kê. Khi nhận prompt, AI dùng mô hình để dự đoán phản hồi kỳ vọng và sinh nội dung mới — tức là học cấu trúc ẩn của dữ liệu rồi sinh mẫu tương tự dữ liệu huấn luyện.
- **LLM là một loại GenAI:** tạo ra tổ hợp văn bản mới bằng ngôn ngữ tự nhiên — học mẫu ngôn ngữ từ dữ liệu huấn luyện và dự đoán từ tiếp theo dựa trên văn bản đã cho. LLM là "dự đoán từ tiếp theo", không phải "hiểu" — khớp đúng kết luận Weak AI của Elements of AI (chương 1, 5).
- **Foundation model (mô hình nền tảng):** mô hình AI lớn được tiền huấn luyện (pre-trained) trên dữ liệu khổng lồ, có thể điều chỉnh (adapt) cho nhiều tác vụ downstream: y tế, tài chính, chăm sóc khách hàng...

### 5. Các loại ứng dụng GenAI
- **Text-to-text:** dịch thuật, tóm tắt, hỏi–đáp.
- **Text-to-image:** sinh ảnh từ mô tả chữ.
- **Text-to-video / text-to-3D:** tạo nội dung đa phương tiện.
- **Text-to-task:** thực hiện một tác vụ được định nghĩa bằng văn bản.
- Các mô hình nền được nhắc tên: **PaLM** (Pathways Language Model) và **LaMDA** (Language Model for Dialogue Applications) — học từ nguồn dữ liệu internet khổng lồ, người dùng chỉ cần đặt câu hỏi bằng lời nói hoặc chữ viết.

### 6. Công cụ Google để tự build ứng dụng GenAI
- **Vertex AI Model Garden:** vườn mô hình nền — gồm PaLM API (chat, text) và Stable Diffusion (sinh ảnh).
- **Generative AI Studio (nay là Vertex AI Studio):** thử nghiệm và tuỳ chỉnh mô hình sinh, không cần code nhiều.
- **Generative AI App Builder (nay là Vertex AI Agent Builder):** người ít/không biết code vẫn tạo được giải pháp GenAI cho tương tác khách hàng/nhân viên.
- **PaLM API:** thử nghiệm LLM và công cụ GenAI.
- Lưu ý thực tế (từ đánh giá học viên độc lập): phần cuối video mang nặng màu quảng cáo sản phẩm Google; giá trị của khóa là nền tảng khái niệm, không phải hướng dẫn build tay.

## Mở rộng — 2 khóa cùng learning path (đọc tóm tắt nội dung + tài liệu)

### Introduction to Large Language Models (John Ewald, video 15 phút, ~45 phút)
- **LLM là gì:** mô hình ngôn ngữ đa năng, lớn, có thể tiền huấn luyện rồi fine-tune cho mục đích cụ thể: phân loại văn bản, hỏi–đáp, tóm tắt tài liệu, sinh văn bản. Lợi thế: đa năng, chỉ cần ít dữ liệu chuyên ngành để tuỳ chỉnh, hiệu năng tăng theo dữ liệu + tham số.
- **Ví dụ PaLM:** ra mắt 04/2022, **540 tỷ tham số**, transformer decoder-only, huấn luyện trên nhiều cụm TPU v4 nhờ kiến trúc Pathways — xử lý nhiều tác vụ cùng lúc, học tác vụ mới nhanh.
- **Phát triển LLM khác phát triển ML truyền thống:** không cần chuyên môn sâu hay nhiều ví dụ huấn luyện — **prompt design** (tạo prompt rõ ràng, đúng tác vụ) là đủ cho phần lớn việc; **prompt engineering** (tối ưu prompt để tăng độ chính xác) chỉ cần khi hệ thống đòi hỏi độ chính xác cao.
- **3 loại LLM, mỗi loại cần cách prompt khác nhau:**
  - **Generic:** dự đoán từ tiếp theo từ dữ liệu huấn luyện.
  - **Instruction-tuned:** huấn luyện theo hướng dẫn cho tác vụ cụ thể — prompt phải đúng định dạng tác vụ.
  - **Dialogue-tuned:** trường hợp đặc biệt của instruction-tuned, huấn luyện trên dữ liệu hội thoại — prompt nên đặt như câu hỏi tự nhiên trong đoạn hội thoại dài.
- **Tuỳ chỉnh sâu hơn:** task-specific tuning (fine-tune cho tác vụ) và **parameter-efficient tuning (PETM)** — tuỳ chỉnh LLM trên dữ liệu riêng mà không sửa mô hình gốc, rẻ và nhanh hơn fine-tune toàn bộ.

### Introduction to Responsible AI (video 9 phút, ~30 phút)
- **Responsible AI là gì:** AI phải được phát triển và dùng một cách có trách nhiệm trong toàn bộ vòng đời sản phẩm — từ thu thập dữ liệu tới giám sát sau triển khai. Các chiều phải xét: **công bằng (fairness), an toàn (safety), trách nhiệm giải trình (accountability), riêng tư (privacy), minh bạch (transparency)**.
- **7 nguyên tắc AI của Google (công bố 2018):**
  1. Mang lại lợi ích xã hội.
  2. Tránh tạo ra hoặc củng cố thiên kiến bất công.
  3. Được xây dựng và kiểm tra để an toàn.
  4. Chịu trách nhiệm trước con người (có phản hồi, giải thích, khiếu nại; con người giữ quyền chỉ đạo/kiểm soát).
  5. Tích hợp nguyên tắc thiết kế riêng tư.
  6. Duy trì tiêu chuẩn cao về xuất sắc khoa học.
  7. Chỉ dùng cho các mục đích phù hợp với các nguyên tắc này.
- Google đồng thời liệt kê các lĩnh vực ứng dụng sẽ không theo đuổi — nguyên tắc không chỉ là khẩu hiệu mà là danh sách loại trừ cụ thể.

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc build extension vBook của team:

1. **Bài thử "Y là số/nhãn hay là nội dung" (§3) → phân loại đúng khi đánh giá site/công cụ (§3 khóa chính).** Nhiều site truyện quảng cáo "AI" nhưng thực chất chỉ là phân loại/tìm kiếm (discriminative: gợi ý truyện, lọc thể loại) — không phải sinh nội dung. *Áp dụng ngay:* khi probe/trả lời về một site "có AI", ghi rõ đầu ra của nó là nhãn/số hay nội dung sinh ra — tránh gọi nhầm mọi thứ là "AI", nối tiếp điểm 7 của task 118 ("một nhúm AI — đặt tên đúng việc").
2. **Prompt design là đủ, prompt engineering chỉ khi cần độ chính xác cao (§ LLM).** Team đã làm đúng theo hướng này mà không gọi tên: file task JSON + checklist chính là **prompt** cho worker (một model instruction-tuned); worker không cần "fine-tune", chỉ cần prompt đủ rõ. *Áp dụng ngay:* viết checklist như viết prompt cho model instruction-tuned — cụ thể, có tiêu chí pass/fail rõ ràng (validate PASS, device test code 0, install 200), không viết chung chung kiểu "test cho kỹ". Checklist mơ hồ = prompt kém = output lệch.
3. **3 loại LLM → chọn đúng "giọng" làm việc (§ LLM).** Generic dự đoán từ tiếp theo; instruction-tuned làm theo hướng dẫn; dialogue-tuned trò chuyện. Worker của team cần hành xử như instruction-tuned: làm đúng checklist, không trò chuyện lan man, không tự suy diễn thêm bước ngoài task. *Áp dụng ngay:* giữ kỷ luật "chỉ làm đúng checklist trong task" — đó chính là cách dùng đúng loại model; mọi việc ngoài checklist phải hỏi lại hoặc ghi vào notes, không tự thêm.
4. **LLM dự đoán từ tiếp theo, không "hiểu" (§4 khóa chính + § LLM).** Ảo giác là hệ quả tất yếu của cơ chế dự đoán thống kê — nối tiếp điểm 5 của task 118. *Áp dụng ngay:* giữ nguyên quy tắc "không tin output của model nếu chưa kiểm chứng live" (validate + device test + kiểm tra trang thật); đặc biệt khi model tự "đọc" một site và kết luận "chạy được".
5. **Parameter-efficient tuning → đừng fine-tune khi prompt đủ dùng (§ LLM).** Tuỳ chỉnh rẻ nhất là đổi prompt/cấu hình, không phải huấn luyện lại. *Áp dụng ngay:* khi worker làm sai lặp lại, sửa task template/checklist (prompt) trước, đừng đổi quy trình lớn hay đổi công cụ — đúng tinh thần "sửa kỹ thuật nhỏ trước" mà muse-main vẫn làm trong review.
6. **7 nguyên tắc Responsible AI → quy trình team đã khớp sẵn, chỉ cần gọi tên (§ Responsible AI).** Đối chiếu: riêng tư — PROTOCOL §8 cấm ghi IP/port/thông tin hạ tầng vào notes repo public; trách nhiệm giải trình — review chấm điểm + chỉ muse-main merge (§4); an toàn — ranh giới "free content only, không VIP bypass, không fake login/purchase" (MEMORY); công bằng/thiên kiến — review chéo chống thiên kiến của worker tự chấm bài mình (điểm 6, task 118). *Áp dụng ngay:* không cần thêm quy tắc mới — nhưng khi viết báo cáo/review, có thể đối chiếu nhanh 7 nguyên tắc để bắt lỗi đạo đức/bảo mật trước khi merge.
7. **Foundation model + Model Garden → giữ "vườn" kỹ thuật của team (§5–§6 khóa chính).** Google không huấn luyện lại model cho mỗi ứng dụng mà chọn model nền có sẵn trong vườn rồi adapt. *Áp dụng ngay:* team đã có "vườn" tương tự — skill vbook-extension-building + các báo cáo research/ (font encryption, JS-rendered/anti-bot, port forum) — khi gặp site khó, tra "vườn" trước thay vì mò lại từ đầu; báo cáo research mới phải ghi rõ nó nối tiếp/bổ sung mục nào trong vườn.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — thêm mục "Viết checklist như viết prompt cho model instruction-tuned" (từ §2–§3 ở trên):** mỗi mục checklist phải có tiêu chí pass/fail đo được (vd: validate PASS, device test code 0, install 200), không viết chung chung; lý do: worker là model instruction-tuned — prompt mơ hồ cho output lệch, và sửa checklist rẻ hơn sửa quy trình (tư duy PETM: đổi prompt trước, đổi mô hình sau).
2. **Skill `vbook-extension-building` — thêm bài thử phân loại "generative vs. discriminative" khi đánh giá site/công cụ (từ §1):** ghi rõ đầu ra của tính năng "AI" trên site là nhãn/số hay nội dung sinh ra, để không gọi nhầm công cụ phân loại/tìm kiếm là "AI sinh nội dung" — nối tiếp điểm "đặt tên đúng việc" của task 118.
3. **Không đề xuất sửa PROTOCOL.md:** 7 nguyên tắc Responsible AI đã được phản ánh trong quy trình hiện tại (riêng tư §8, trách nhiệm giải trình §4, an toàn trong ranh giới team) — khóa học xác nhận quy trình team đang đúng, không cần đổi.

## Khóa tiếp theo

- Theo phân vai §9, muse-2 đã xong cả 2 khóa được giao: **Elements of AI (task 118)** và **Introduction to Generative AI (task 119)**. Khóa tiếp theo chờ muse-main chọn trong danh sách 32 khóa đã duyệt (PROTOCOL §10: muse-main quyết luôn việc chọn khóa học tiếp theo, không hỏi Anh).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): khóa **Prompt Design in Vertex AI** là bước nối tiếp tự nhiên của khóa này (prompt design/engineering + multimodal), phù hợp vai research; hoặc khóa **Generative AI Fundamentals** (badge gộp 3 khóa — đã học xong nội dung, chỉ còn làm quiz/lab nếu muốn lấy badge, nhưng badge cần credit/đăng ký nên chỉ làm khi chị cả quyết là đáng).

## Nguồn

- Trang khóa: https://www.cloudskillsboost.google/course_templates/536 ; learning path: https://www.cloudskillsboost.google/journeys/118
- Ghi chép đầy đủ nội dung video khóa chính (tham khảo chéo): https://kundan-reads.readthedocs.io/en/latest/aiml/generative_ai/Genenerative_AI/
- Tóm tắt video khóa LLM: https://www.tubopedia.com/posts/Introduction-to-Large-Language-Models ; https://finechat.ai/blog-Introduction-to-large-language-models-13628
- 7 nguyên tắc AI của Google (bản gốc 2018 + báo cáo tiến độ 2023): https://storage.googleapis.com/gweb-uniblog-publish-prod/documents/2023_Google_AI_Principles_Progress_Update.pdf
- Tổng quan learning path + badge: https://hackernoon.com/learn-generative-ai-with-google-cloud-new-courses-from-introductory-to-advanced-level
