# Agentic AI (DeepLearning.AI, Andrew Ng) — Báo cáo tự học (task 140)

- **Khóa học:** Agentic AI, DeepLearning.AI
- **Trang khóa:** https://www.deeplearning.ai/courses/agentic-ai
- **Giảng viên:** Andrew Ng (Founder, DeepLearning.AI; Co-founder, Coursera)
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Bối cảnh task:** task 140 ban đầu giao khóa Governing AI Agents; muse-1 kiểm chứng bằng browser thật (21:57) cho thấy khóa đó **không** có trong danh sách 32 khóa AI miễn phí đã duyệt (Vinmedia Global) nên đã dừng ở blocked. muse-main quyết theo ủy quyền 20/11 (22:48): đổi sang **Agentic AI (DeepLearning.AI) — khóa số 13 trong danh sách 32 đã xác nhận**, nối tiếp mạch agents 123→125→127→130→132→135→137. Bằng chứng kiểm chứng danh sách 32: `research/140-governing-ai-agents-deeplearning-ai.md` trên cùng branch.
- **Hình thức:** chỉ học nội dung FREE công khai, **không đăng ký Pro, không chạy lab/API tốn phí, không tạo tài khoản trả phí**. Không chạy code lab của khóa (cần API key LLM + môi trường lab của nền tảng); báo cáo học qua trang khóa chính thức + syllabus công khai trên Coursera/Class Central + bài giới thiệu của Andrew Ng (xem mục Nguồn).
- **Quy mô khóa:** xuất bản 30/09/2025 trên DeepLearning.AI (trang chính thức ghi Published: 2025-09-30); bản Coursera ra mắt 14/09/2026, mức Intermediate, yêu cầu Python trung cấp + hiểu cơ bản LLM/API, 5 module, mỗi module có quiz, 3 graded programming assignments + ungraded labs, ước lượng ~23 giờ theo thẻ module Coursera (nguồn tổng hợp đọc trang Coursera 08/10/2026). Khóa dạy pattern bằng code Python thuần (module tool use dùng thư viện AI Suite) thay vì tour framework — không module nào nêu LangChain/LangGraph.
- **Vị trí trong vòng tự học:** các khóa trước đi sâu từng mảnh (125 AI Agents in LangGraph = framework; 127/128/130 = bộ nhớ; 132 = đo; 135 = chặn; 137 = tấn công thử). Khóa này là **khóa khung tổng hợp của chính Andrew Ng**: bốn design pattern nền (reflection, tool use, planning, multi-agent) + evals/error analysis làm động cơ cải tiến — đúng "bản đồ" để xếp các mảnh đã học vào một hệ thống.

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Thuộc danh sách đã duyệt: CÓ.** Agentic AI là khóa số 13 trong danh sách 32 khóa Vinmedia đã đọc đủ bằng browser thật tối 20/11 (bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md`, commit a646d1c) — khác hẳn Governing AI Agents (không có trong danh sách). muse-main đã ghi quyết định đổi khóa vào task file lúc 22:48.
- **Khóa học: Freemium — audit FREE xem được video, lab/quiz/chứng chỉ cần Pro.** Trang khóa chính thức (FAQ, đọc 20/11/2026) ghi rõ: audit miễn phí thì xem được video + tham gia forum, nhưng không có assessments, certificates, project tools; Pro ($25/tháng trả theo năm hoặc $30/tháng trả theo tháng) mở quizzes, interactive labs, certificate, practice projects. Cùng mẫu với task 128/132/135/137. Hệ quả: **chỉ học khái niệm, pattern và phương pháp qua nội dung công khai, không đăng ký Pro, không chạy lab** — đúng checklist.
- **Phần không FREE nếu chạy thật:** (a) gói Pro cho graded assignments/certificate, (b) API key LLM để chạy các lab Python (reflection/tool use đều gọi model nhiều lần mỗi task), (c) hạ tầng chạy workflow. Tất cả ngoài phạm vi FREE → **không chạy**, chỉ học phương pháp.
- **Pattern không bị khóa sau sản phẩm:** khóa cố ý dạy pattern từ nguyên lý đầu (first principles) bằng code thuần trước khi đụng framework — nên toàn bộ giá trị khái niệm lấy được từ syllabus + tài liệu công khai, giống kết luận ở task 128/130/132/135/137.

## Cấu trúc khóa (syllabus)

| Module | Nội dung chính |
|---|---|
| 1. Introduction to Agentic Workflows | Agentic là gì, mức tự chủ là phổ (spectrum) không phải có/không, lợi ích, ứng dụng, **task decomposition** (phân rã việc), đánh giá agentic AI, bốn design pattern. Ví dụ: xử lý hóa đơn, agent chăm sóc khách hàng, hệ nghiên cứu/viết báo cáo; cuối module có research agent để thử |
| 2. Reflection Design Pattern | Model tự phê bình và sửa đầu ra của mình, hoặc phản ứng với phản hồi ngoài (thông báo lỗi). Ví dụ: sinh biểu đồ (multimodal reflection — phê bình cả ảnh/chart), cải thiện SQL; đo định lượng lợi ích reflection (độ chính xác SQL) |
| 3. Tool use | Function calling: khai báo hàm thành tool, phát hiện model yêu cầu gọi, chạy và trả kết quả về model. Gồm code execution, workflow trợ lý email, giới thiệu **Model Context Protocol (MCP)** — chuẩn mở nối model với tool/dữ liệu |
| 4. Practical Tips for Building Agentic AI | Evals, **error analysis trên trace**, eval toàn hệ (end-to-end) vs eval từng thành phần (component-level), quyết định sửa gì tiếp, tối ưu latency/cost, tóm tắt quy trình phát triển |
| 5. Patterns for Highly Autonomous Agents | Planning: LLM sinh kế hoạch thực thi được (JSON có cấu trúc hoặc code) điều phối tool/dữ liệu; so sánh JSON plan vs code-as-action (linh hoạt/bảo mật/dự đoán được). Multi-agent: agent chuyên biệt phối hợp theo mẫu tuyến tính (linear pipeline), phân cấp quản lý–thợ (hierarchical manager–worker), nhắn tin tất-cả (all-to-all) |

Đường đi của khóa: **phân rã việc → lặp tự sửa → nối thế giới thật bằng tool → đo và phân tích lỗi → tăng tự chủ có kiểm soát**. Andrew Ng xếp reflection + tool use là hai pattern "đáng tin cậy hơn", planning + multi-agent mạnh hơn nhưng khó dự đoán hơn — học vững hai pattern đầu rồi mới "kiếm quyền" dùng hai pattern sau.

## 1. Agentic AI là gì: phổ tự chủ, không phải công tắc

- **Định nghĩa của khóa:** agentic AI là cách xây phần mềm dùng LLM để hoàn thành một phần hoặc toàn bộ các bước của một task phức tạp — thay vì một prompt một câu trả lời, workflow **lập kế hoạch nhiều bước, thực thi lặp, và cải thiện đầu ra bằng reflection + tool use**.
- **Ba mức tự chủ thực hành:** *thấp* — lập trình viên viết cứng chuỗi gọi LLM/tool; *trung bình* — LLM chọn dùng tool/bước nào trong một tập cố định, theo thứ tự nào; *cao* — LLM tự lập kế hoạch, có thể viết code/tool mới, tự thích ứng khi bước thất bại (Module 5). Khóa cố ý "nghỉ hưu" tranh luận "cái gì mới tính là agent": tự chủ là một núm vặn (dial), phần lớn giá trị nằm ở giữa.
- **Bằng chứng headline của Ng:** bọc một model cũ trong vòng lặp soạn–kiểm–sửa nâng độ chính xác lập trình (HumanEval, thư The Batch tháng 3/2024) nhiều hơn hẳn bước nhảy lên model thế hệ sau — "sự cải thiện từ GPT-3.5 lên GPT-4 bị lu mờ bởi workflow agent lặp". Chi phí đổi lại là nhiều lượt gọi LLM hơn mỗi task, nên Module 4 dành hẳn phần cho latency/cost.
- **Ánh xạ sang team:** team muse-teamwork đang chạy đúng phổ này mà chưa gọi tên: script claim/complete + cổng merge của chị cả là mức thấp (chuỗi cứng), worker tự chọn cách build trong task là mức trung bình, và việc worker tự tạo task tự học khi rảnh (PROTOCOL §9) là mầm mức cao. Khóa cho tiêu chí để quyết mức nào cho việc nào thay vì mặc định "càng tự chủ càng tốt".

## 2. Task decomposition: kỹ năng thiết kế đầu tiên

- **Nội dung:** Module 1 dạy phân rã một quy trình thật thành các bước mà model + tool thực thi được — như cách một người sẽ làm: ở đâu người sẽ lặp sửa (reflection), ở đâu người sẽ tra cứu/hành động (tool use), ở đâu thứ tự không biết trước được (planning). Ví dụ chuẩn của Ng: viết bài luận = nghiên cứu → dàn ý → bản nháp → tự phê bình → sửa, thay vì xin cả bài trong một prompt.
- **Nguyên tắc kèm theo:** ngay từ Module 1 đã phải quyết "làm sao biết bước đó chạy tốt" — đánh giá không phải bước cuối mà là một phần của phân rã.
- **Ánh xạ sang team:** task file của team chính là task decomposition ở dạng văn bản: checklist trong mỗi task (quét chống trùng → claim → build → test → review) là các bước đã phân rã sẵn, và tiêu chí merge 3 điều (validate PASS + device test 0 + install 200) là "biết bước chạy tốt" viết thành luật. Bài học từ khóa: task nào checklist mơ hồ thì worker sẽ phải tự phân rã lại — tốn một vòng và dễ lệch; checklist rõ là một nửa của chất lượng.

## 3. Reflection: tự phê bình có đo lường

- **Cơ chế:** model xem lại đầu ra của chính mình (hoặc một critic agent xem hộ) để tìm cách cải thiện, rồi sửa — "như code review nhưng tự động". Reflection mạnh lên rõ rệt khi có **phản hồi ngoài** đưa vào vòng lặp: thông báo lỗi chạy code, kết quả truy vấn thật, hoặc phê bình đa phương thức trên chính biểu đồ vừa sinh.
- **Điểm khóa nhấn mạnh:** phải **đo** reflection có giúp thật không (ví dụ độ chính xác SQL trước/sau reflection), không mặc định "lặp thêm là tốt hơn" — lặp mù tốn latency/cost mà có thể không tăng chất lượng, thậm chí làm hỏng đầu ra vốn đúng.
- **Ánh xạ sang team:** vòng review của chị cả (chấm điểm /10, trả về doing nếu <7, tối đa 3 vòng — PROTOCOL §4) chính là reflection ở quy mô tổ chức: critic độc lập + tiêu chí đo + giới hạn số vòng. Khác biệt: team dùng agent khác làm critic thay vì tự phê bình — khóa cho thấy cả hai dạng đều hợp lệ, và dạng critic tách rời tránh được điểm mù "tự chấm bài mình".

## 4. Tool use và MCP: nối model với thế giới thật

- **Cơ chế:** khai báo hàm thành tool (tên, mô tả, tham số), model quyết định khi nào gọi, hệ thống chạy hàm và **trả kết quả về cho model** để nó tiếp tục suy luận. Khóa đi từ cách đánh dấu cũ (marker-based) tới cú pháp tool-calling gốc hiện đại, gồm code execution và workflow trợ lý email.
- **MCP (Model Context Protocol):** chuẩn mở chuẩn hóa cách model truy cập tool và nguồn dữ liệu ngoài, giúp nối ứng dụng agent với nhiều back-end mà không phải viết adapter riêng cho từng cái.
- **Ánh xạ sang team:** đây là pattern team sống hằng ngày — worker gọi git, script claim/complete, hub, browser; mỗi tool có "mô tả" là PROTOCOL/skill. Bài học từ khóa: chất lượng mô tả tool quyết định model gọi đúng hay sai — tương đương bài học task 119/120/123 (mô tả/checklist là prompt). MCP cũng là hướng chuẩn hóa đáng theo dõi nếu team sau này nối thêm nguồn ngoài (task 133 đã kết luận chưa xây cầu Discord — MCP là lớp chuẩn nên cân nhắc trước khi tự chế cầu nối).

## 5. Evals và error analysis: động cơ cải tiến (Module 4)

- **Nội dung:** eval toàn hệ đo kết quả cuối; **component-level eval** đo từng bước trong workflow để biết lỗi nằm ở khâu nào; **error analysis** là đọc trace của các ca thất bại, gom nhóm lỗi, rồi quyết định sửa gì tiếp theo theo tần suất × mức độ — thay vì sửa theo cảm tính.
- **Tối ưu vận hành:** cân bằng chất lượng với latency và cost (mỗi vòng reflection/tool call đều tốn tiền và thời gian) — quyết định kiến trúc phải tính cả ba.
- **Ánh xạ sang team:** nối thẳng task 132 (evals: benchmark, judge hiệu chuẩn, regression) — khóa này đặt evals vào đúng vị trí trong vòng xây agent: phân rã → xây từng bước → đo từng bước → phân tích lỗi → sửa bước lỗi nhất → đo lại. Team đang làm dạng thủ công: validate (component) + device test (end-to-end) + review đọc trace của chị cả (error analysis). Khóa xác nhận thứ tự ưu tiên: **đọc trace lỗi trước khi thêm tính năng**.

## 6. Planning: JSON plan vs code-as-action (Module 5)

- **Cơ chế:** thay vì viết cứng chuỗi bước, LLM sinh một kế hoạch thực thi được — hoặc **JSON có cấu trúc** (dễ kiểm chứng, dễ chặn bước nguy hiểm, nhưng kém linh hoạt) hoặc **code** (linh hoạt, biểu đạt được vòng lặp/điều kiện, nhưng khó dự đoán và cần sandbox). Khóa so sánh hai dạng qua ví dụ agent bán lẻ và phân tích bảng tính, nhấn mạnh trade-off linh hoạt ↔ bảo mật ↔ tính dự đoán được.
- **Ánh xạ sang team:** PROTOCOL của team là dạng "JSON plan" ở quy mô tổ chức: bước cố định, cổng kiểm chứng cứng, worker chỉ tự do trong từng bước. Khóa giải thích vì sao lựa chọn đó đúng cho việc có hậu quả thật (merge, push): kế hoạch càng tự do càng cần lớp chặn mạnh hơn — đúng ranh giới quyết ở PROTOCOL §10 (việc đơn giản chị cả quyết, việc tốn tiền/permission/hướng sản phẩm phải hỏi Anh).

## 7. Multi-agent: ba mẫu giao tiếp

- **Ba mẫu khóa dạy:** *tuyến tính* (linear pipeline — bàn giao tuần tự), *phân cấp* (hierarchical manager–worker — một agent quản lý giao việc cho agent chuyên biệt), *tất-cả* (all-to-all — mọi agent nhắn tin với nhau). Agent chuyên biệt với vai trò + tool riêng thường thắng một agent tổng hợp làm mọi thứ, giống cách một công ty thuê nhiều nhân viên.
- **Cảnh báo của khóa:** multi-agent thuộc nhóm pattern khó dự đoán hơn (cùng planning) — chỉ dùng khi task thật sự cần phân vai, không dùng vì "nghe hay".
- **Ánh xạ sang team:** team 3 Muse đang chạy mẫu **phân cấp**: chị Bẹp (muse-main) là manager — chia việc, review, merge; Ú (build) và Vịt (research) là worker chuyên biệt; giao tiếp qua hiện vật bền (task file GitHub là nguồn sự thật, hub là kênh phụ) thay vì nhắn tin tất-cả. Khóa cho tên gọi để team tự nhận diện kiến trúc của mình, và củng cố quyết định hiện tại: file/task là kênh chính, chat chỉ là thông báo — vì all-to-all không có hiện vật bền thì không truy vết được.

## 8. Đối chiếu với mạch tự học đã qua (123→137)

| Khóa | Đóng góp một mảnh | Khóa 140 xếp mảnh đó vào đâu |
|---|---|---|
| 123 ChatGPT Prompt Engineering | Viết prompt/checklist rõ | Nền của task decomposition (§2) và mô tả tool (§4) |
| 125 AI Agents in LangGraph | Framework xây agent có trạng thái | Lớp triển khai dưới các pattern — khóa 140 dạy pattern bằng code thuần để hiểu framework đang đóng gói cái gì |
| 127/128/130 Bộ nhớ agent | Lưu/truy xuất ngữ cảnh dài hạn | Thành phần trong workflow nhiều bước; khóa 140 không đi sâu bộ nhớ — giữ vai trò bổ trợ |
| 132 Evaluating Agentic Applications | Đo: benchmark, judge, regression | Module 4 của khóa 140 (evals + error analysis) — cùng kỷ luật, khóa 132 sâu hơn |
| 135 Safe & Reliable AI via Guardrails | Chặn lúc chạy | Lớp an toàn quanh planning/tool use (§6) — kế hoạch tự do cần chặn mạnh |
| 137 Red Teaming LLM Applications | Tấn công thử chủ động | Kiểm chứng đối kháng trước phát hành; khóa 140 không dạy red-teaming — vòng đo–chặn–tấn công vẫn cần 137 |

Kết luận đối chiếu: khóa 140 là **khóa bản đồ** — không thay thế khóa nào trước, nhưng cho khung để biết mỗi kỹ thuật đã học thuộc pattern nào và khi nào nên dùng. Thứ tự học của team (đi sâu từng mảnh trước, học khung tổng hợp sau) cho kết quả tốt: đọc khóa này mà không có 132/135/137 thì phần evals/an toàn sẽ nông.

## 9. Đề xuất áp dụng cho team

1. **Giữ nguyên kiến trúc phân cấp hiện tại** (chị cả quản lý, worker chuyên biệt, task file là nguồn sự thật) — khóa xác nhận đây là mẫu multi-agent đáng tin cậy nhất trong ba mẫu; không chuyển sang nhắn tin tất-cả.
2. **Thêm thói quen "đo reflection" vào review:** khi chị cả trả task về doing, ghi rõ vòng sửa sau có cải thiện điểm không (đã có `result.review.rounds` + score) — nếu 2 vòng không tăng điểm thì đổi cách sửa thay vì lặp tiếp, đúng cảnh báo "lặp mù" của Module 2.
3. **Error analysis trước khi thêm tính năng:** khi một họ task liên tục lỗi (vd nguồn 403, validate fail), gom trace theo nhóm lỗi rồi mới quyết sửa skill hay sửa quy trình — thay vì vá từng ca.
4. **Theo dõi MCP như chuẩn nối tool** cho các cầu nối tương lai (sau kết luận task 133 chưa xây cầu Discord): ưu tiên chuẩn mở thay vì tự chế giao thức riêng.
5. **Không đề xuất** cài framework agent mới hay chạy lab của khóa — team đã có hệ phối hợp chạy thật; giá trị lấy ở khung pattern và kỷ luật evals, không ở sản phẩm.

## Nguồn

- Trang khóa chính thức (mục tiêu, 4 pattern, outline 5 module, FAQ FREE/Pro, Published 2025-09-30): https://www.deeplearning.ai/courses/agentic-ai
- Bài giới thiệu khóa của Andrew Ng (The Batch): https://www.deeplearning.ai/the-batch/check-out-our-course-on-how-to-build-ai-agents
- Syllabus chi tiết theo module (Coursera): https://www.coursera.org/organizations/cofc/learn/dlai-agentic-ai
- Tổng hợp syllabus + mô tả module (Class Central): https://www.classcentral.com/course/coursera-dlai-agentic-ai-568767
- Đánh giá độc lập đọc trang Coursera 08/10/2026 (5 module, ~23 giờ, Intermediate, AI Suite, 3 graded assignments): https://bestaicertifications.com/reviews/deeplearning-ai-agentic-ai/
- Ghi chú học viên công khai theo module (bốn pattern, JSON vs code planning, ba mẫu multi-agent): https://aljazkovac.github.io/posts/agentic-ai/
- Bằng chứng danh sách 32 khóa đã duyệt (Agentic AI là khóa số 13; Governing AI Agents không có trong danh sách): `research/140-governing-ai-agents-deeplearning-ai.md` trên branch `feature/140-tu-hoc-governing-ai-agents-deeplearning-ai` (commit a646d1c)
