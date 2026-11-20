# Safe and Reliable AI via Guardrails (DeepLearning.AI × GuardrailsAI) — Báo cáo tự học (task 135)

- **Khóa học:** Safe and Reliable AI via Guardrails, DeepLearning.AI (hợp tác GuardrailsAI)
- **Trang khóa:** https://staging.deeplearning.ai/courses/safe-and-reliable-ai-via-guardrails
- **Giảng viên:** Shreya Rajpal, đồng sáng lập & CEO GuardrailsAI
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE, **không đăng ký chứng chỉ trả phí, không chạy lab/API tốn phí, không tạo tài khoản trả phí** (theo checklist task 135). **Không chạy code lab** — lab cần API key LLM + model NLI/embeddings; báo cáo học kỹ nội dung qua trang khóa chính thức + tài liệu GuardrailsAI/PyPI + tài liệu phân biệt guardrail/eval/red-teaming (xem mục Nguồn).
- **Quy mô khóa:** Short course, xuất bản 13/11/2024; thời lượng niêm yết 1 giờ 42 phút (theo task 135), trình độ Beginner; 10 lessons, 7 code examples. Ví dụ xuyên suốt: chatbot chăm sóc khách hàng RAG cho một tiệm pizza nhỏ.
- **Công cụ dùng trong khóa:** GuardrailsAI (framework Python mã nguồn mở) + Guardrails Hub (kho validator dựng sẵn) + model Natural Language Inference (NLI) cho kiểm tra ảo giác.
- **Vị trí trong vòng tự học:** khóa do chính báo cáo 132 gợi ý (mục Khóa tiếp theo) và được chị cả giao tiếp. Task 132 dạy **đo** (evals: trace, benchmark, evaluator, regression). Khóa này dạy **chặn** (guardrails: kiểm tra lúc chạy, ngay tại từng request). Hai khóa ghép thành một vòng khép kín: đo để biết hệ thống hỏng ở đâu, chặn để lỗi đó không tới được người dùng/hệ thống đích — và mỗi lần chặn hụt lại thành case đo mới.
- **Phạm vi báo cáo:** toàn bộ khung khóa (failure modes, input/output guards, validators, hallucination guard bằng NLI, giữ đúng chủ đề, PII, competitor check, guardrail server) + kiểm chứng mức FREE + phân biệt guardrail vs evaluator vs red-teaming + ánh xạ lên cổng duyệt merge và watcher của team như checklist yêu cầu.

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Khóa học: Freemium — video FREE, lab/quiz/chứng chỉ cần Pro.** Đây là mẫu chung của DeepLearning.AI từ khi gói Pro ra mắt 29/10/2025: thành viên free xem được toàn bộ video; lab thực hành, quiz chấm điểm và chứng chỉ/accomplishment cần DeepLearning.AI Pro (25 USD/tháng trả theo năm hoặc 30 USD/tháng trả theo tháng, kiểm chứng qua các nguồn tổng hợp độc lập đọc trang membership chính thức tháng 11/2026 — xem mục Nguồn). Trang khóa công khai đủ mô tả, mục tiêu học và outline 10 lessons nên học được khái niệm và phương pháp mà không cần Pro. Hệ quả cho task này: **chỉ học khái niệm, kiến trúc và cách dùng validator qua nội dung công khai, không đăng ký Pro, không chạy lab** — đúng checklist.
- **Phần không FREE nếu chạy thật:** (a) gói Pro cho lab/quiz/chứng chỉ, (b) API key LLM để chạy chatbot mẫu và các validator gọi model, (c) hạ tầng chạy model NLI/embeddings cho hallucination guard. Tất cả nằm ngoài phạm vi FREE của checklist → **không chạy**, chỉ học phương pháp qua tài liệu.
- **GuardrailsAI tự nó là mã nguồn mở** (framework Python, cài bằng `pip install guardrails-ai`, license Apache-2.0 theo nguồn tổng hợp 2026). Tức là phương pháp trong khóa không bị khóa sau sản phẩm trả phí — giống kết luận ở task 128/130/132: chỉ bài thực hành trên nền tảng mới tốn phí. Ghi nhận để chị cả biết, không đề xuất team cài GuardrailsAI (xem mục Đề xuất) — team đã có lớp chặn riêng bằng cổng duyệt merge + script claim/complete (mục Áp dụng).
- **Lưu ý trạng thái 2026 (cần kiểm chứng lại khi dùng thật):** một nguồn review độc lập tháng 9/2026 ghi nhận Guardrails Hub và hosted inference đã đóng cuối tháng 8/2026, validator chuyển sang cài qua PyPI, và công ty được Harvey mua lại tháng 9/2026. Báo cáo này chưa kiểm chứng độc lập các tin đó trên repo chính thức; ghi lại như **rủi ro vòng đời công cụ** cần kiểm chứng trước bất kỳ quyết định áp dụng nào — khái niệm guardrail/validator của khóa (2024) không phụ thuộc vào trạng thái thương mại này.

## Cấu trúc khóa (syllabus)

| Lesson | Nội dung chính |
|---|---|
| 1. Introduction | Vì sao cần guardrails; ví dụ chatbot tiệm pizza bị ảo giác |
| 2. Guardrails Basics | Dựng validator đơn giản (từ cấm); lớp Guard bọc quanh lệnh gọi LLM |
| 3. Checking for Hallucinations with NLI | Cài model NLI; tách câu; truy xuất nguồn; kiểm tra entailment |
| 4. Hallucination Guard Integration | Bọc NLI validator vào Guard cho chatbot |
| 5. Output Structure Validation | Ép JSON schema và ràng buộc định dạng đầu ra |
| 6. Input Validation | Kiểm tra đầu vào người dùng trước khi gửi cho LLM |
| 7. Custom Validators | Dựng validator riêng theo miền nghiệp vụ |
| 8. Composing Guardrails | Ghép nhiều validator thành một pipeline |
| 9. Production Considerations | Đánh đổi hiệu năng, độ trễ, độ tin cậy |
| 10. Conclusion | Tổng kết |

Đường đi của khóa: **chặn ở hai đầu, bắt đầu từ validator rẻ nhất** — dựng validator luật đơn giản trước, rồi mới tới validator ngữ nghĩa bằng model (NLI), cuối cùng mới ghép pipeline và bàn chuyện production. Ngược với thói quen "viết prompt thật kỹ rồi tin model tự ngoan" mà khóa lấy làm đối tượng phê phán chính: đầu ra LLM vốn là xác suất, không bảo đảm được cùng một câu trả lời hai lần, nên độ tin cậy phải đến từ lớp kiểm tra bên ngoài model.

## 1. Guardrail là gì: lớp kiểm tra lúc chạy, nằm ngoài model

- **Định nghĩa của khóa:** guardrails là cơ chế an toàn và công cụ kiểm chứng tích hợp vào ứng dụng AI, đóng vai trò khung bảo vệ ngăn ứng dụng tiết lộ thông tin sai, không liên quan hoặc nhạy cảm. Điểm cốt lõi: guardrail là **chương trình bên ngoài model**, kiểm tra đầu vào trước khi tới model và đầu ra trước khi tới người dùng — thêm, sửa hay thay guardrail không cần huấn luyện lại model.
- **Bốn failure mode khóa lấy làm mục tiêu:** (1) *ảo giác* — trả lời trôi chảy mà sai sự thật; (2) *lạc chủ đề* — chatbot tiệm pizza đi bàn chuyện ngoài tiệm; (3) *lộ thông tin nhạy cảm* — PII của người dùng hoặc chủ đề mật nội bộ (khóa dùng ví dụ "dự án mật của tiệm pizza"); (4) *hại uy tín* — nhắc tên đối thủ, ngôn ngữ độc hại. Bốn lỗi này đều là lỗi **hành vi**, không phải lỗi code — code chạy không exception vẫn có thể mắc cả bốn. Đây là cùng đóng khung với task 132: test truyền thống đo code, còn lớp bảo vệ cho agent phải đo và chặn hành vi.
- **Guard và Validator là hai khái niệm trung tâm:** *Validator* là một phép kiểm tra đơn lẻ trả về pass/fail (từ cấm, độ dài, PII, entailment...). *Guard* là lớp bọc quanh lệnh gọi LLM: chạy các validator trên đầu vào/đầu ra, và khi fail thì hành động theo `on_fail` đã cấu hình. Validator ghép được vào Guard như các viên gạch — một Guard chứa nhiều validator, mỗi validator một trách nhiệm.
- **Guardrail không thay thế prompt tốt hay model tốt.** Tài liệu phân biệt hiện hành xếp ba lớp an toàn bổ sung nhau: alignment huấn luyện vào trọng số model (không đổi được ở tầng ứng dụng), guardrail lúc chạy do người làm ứng dụng đặt (đổi được ngay), và evaluation ngoại tuyến để biết hai lớp trên có đang hoạt động không. Một lớp duy nhất là một điểm hỏng duy nhất — bài học "Swiss cheese" của task 132 áp nguyên văn: mỗi lớp có lỗ hổng khác nhau nên phải chồng lớp.

## 2. Input guard và output guard: chặn ở hai đầu, chi phí khác nhau

- **Input guard kiểm tra trước khi gọi model:** phát hiện prompt injection/jailbreak, PII trong câu hỏi, yêu cầu lạc chủ đề, văn bản vô nghĩa. Lợi thế quyết định: **chặn ở đầu vào thì không tốn token** — request bị từ chối trước khi model chạy. Trong tài liệu thực hành GuardrailsAI, validator GibberishText đặt ở kênh input chặn prompt gõ bừa mà không gọi API lần nào.
- **Output guard kiểm tra sau khi model trả lời:** ảo giác (có bám nguồn không), PII lọt ra, nhắc đối thủ, ngôn ngữ độc hại, sai định dạng/schema. Output guard bắt được lỗi của chính model nhưng **đã tốn token** — nó là hàng phòng thủ cuối, không phải hàng rẻ nhất.
- **Thứ tự rẻ trước, đắt sau (tiered validation):** chạy kiểm tra luật rẻ (regex, từ khóa, độ dài) trước; chỉ khi qua mới chạy kiểm tra ngữ nghĩa đắt (classifier, NLI, LLM judge). Đây là nguyên tắc vận hành quan trọng nhất khi ghép nhiều validator: pipeline không sắp xếp theo chi phí sẽ biến mọi request thành nhiều lần gọi model.
- **Ánh xạ sang team:** input guard của team là khâu **claim task** — script `claim-task.sh` kiểm tra status còn open, assignee trống, `preferred_assignee` khớp trước khi cho nhận việc (chặn trùng việc trước khi tốn công build, đúng nghĩa "chặn trước khi tốn token"). Output guard của team là khâu **review trước merge** — validate/device test/install chạy trên sản phẩm đã build xong (đã tốn công, nhưng là hàng cuối trước khi lên main).

## 3. Validator và hành động khi fail (`on_fail`): chặn không chỉ là từ chối

Mỗi validator trong GuardrailsAI gắn một hành động khi kiểm tra không đạt. Các hành động chính:

| Hành động | Nghĩa | Khi nào hợp |
|---|---|---|
| `exception` | Ném lỗi, dừng luồng | Vi phạm cứng: PII, secret, jailbreak — không có "sửa nhẹ" |
| `reask` | Gửi lại cho model kèm lý do fail, yêu cầu sửa | Sai định dạng/schema, thiếu trường — lỗi sửa được bằng một vòng nữa |
| `fix` | Tự sửa đầu ra theo luật (cắt câu không bám nguồn, che PII) | Lỗi cục bộ sửa được mà không cần gọi lại model |
| `filter` / `refrain` | Lọc bỏ phần vi phạm hoặc từ chối trả lời | Nhắc đối thủ, lạc chủ đề — trả câu từ chối mẫu |
| `noop` | Ghi nhận nhưng cho qua | Giai đoạn đo thử: biết tỉ lệ fail trước khi bật chặn thật |

- **Bài học thiết kế:** cùng một validator nhưng `on_fail` khác nhau cho ra hệ thống khác hẳn. `exception` cho mọi thứ sẽ biến guardrail thành máy từ chối; `reask` không giới hạn số lần sẽ biến lỗi định dạng thành vòng lặp tốn token. Khóa và tài liệu đều nhấn: **giới hạn số lần reask** và luôn có đường lui (fallback) khi sửa không thành.
- **Validator dựng sẵn trên Hub** (khóa dùng trực tiếp): DetectPII (dùng Microsoft Presidio, nhận diện thực thể NLP chứ không chỉ regex), CompetitorCheck (khớp tên chính xác hoặc NER theo ngưỡng), ToxicLanguage (classifier theo ngưỡng), DetectJailbreak (classifier chuyên biệt, không dựa từ khóa), GibberishText, RegexMatch/ValidLength... Bài học: **đừng tự viết lại phép kiểm tra đã có chuẩn** — nhưng cũng đừng tin validator dựng sẵn mà chưa đo tỉ lệ chặn nhầm trên dữ liệu của mình (nối task 132: validator cũng là một "judge" cần hiệu chuẩn precision/recall).
- **Custom validator:** khi luật là của riêng nghiệp vụ (ví dụ tiệm pizza không được bàn dự án mật), tự viết lớp validator với hàm `validate` trả pass/fail. Đây là điểm khóa nhấn mạnh nhất về tính mở rộng: khung thì chung, luật thì riêng — giống cách team dùng chung PROTOCOL nhưng checklist từng task viết riêng.

## 4. Hallucination guard bằng NLI: kiểm tra từng câu có được nguồn "kéo theo" không

Đây là đóng góp kỹ thuật trung tâm của khóa:

- **NLI (Natural Language Inference)** là bài toán phân loại quan hệ giữa hai đoạn văn: tiền đề (premise) có *kéo theo* (entailment), *mâu thuẫn* (contradiction) hay *trung tính* (neutral) với giả thuyết (hypothesis) không. Khóa áp vào RAG như sau: tài liệu truy xuất được là tiền đề, **từng câu** trong câu trả lời của chatbot là giả thuyết; câu nào không được bất kỳ tài liệu nguồn nào entail thì bị đánh dấu ảo giác.
- **Quy trình ba bước:** (1) tách câu trả lời thành từng câu; (2) với mỗi câu, chạy NLI so với các đoạn nguồn đã truy xuất; (3) câu fail bị cắt bỏ (`fix`) hoặc toàn bộ câu trả lời bị reask. Kiểm tra theo câu thay vì cả đoạn vì một câu trả lời thường trộn câu đúng và câu bịa — chấm cả đoạn sẽ hoặc tha câu bịa, hoặc giết câu đúng.
- **Giới hạn phải nhớ:** NLI đo *độ bám nguồn* (groundedness), không đo *độ đúng sự thật* — nguồn sai thì câu bám nguồn vẫn sai. NLI cũng có ngưỡng: đặt ngưỡng entailment cao thì chặn nhầm câu diễn đạt lại đúng ý (false positive), đặt thấp thì lọt câu bịa khéo (false negative). Đây chính là bài toán precision/recall của task 132 Module 3, nay xuất hiện ở tầng chặn: **ngưỡng guardrail phải được chọn bằng số đo trên dữ liệu thật, không chọn bằng cảm tính**.
- **Ánh xạ sang team:** nguyên tắc "từng khẳng định phải bám nguồn" là dạng tự động của kỷ luật team đã chạy bằng tay — báo cáo research phải trích nguồn kiểm chứng được, số liệu không có nguồn thì ghi "Chưa xác định" (quy tắc của Anh). Hallucination guard cho thấy kỷ luật đó có thể cơ giới hóa ở mức câu khi hệ thống có lưu lượng thật; ở quy mô file + review của team, người review đóng vai NLI.

## 5. Giữ đúng chủ đề, PII và đối thủ: ba guardrail nghiệp vụ của khóa

- **Giữ đúng chủ đề (topic guard):** khóa dựng guardrail giới hạn chatbot chỉ trả lời chuyện tiệm pizza, từ chối chủ đề ngoài phạm vi và chủ đề mật nội bộ. Kỹ thuật: phân loại chủ đề ở input guard (chặn sớm, rẻ) cộng kiểm tra ở output guard (bắt trường hợp model tự lái sang chuyện khác). Bài học: **phạm vi được phép nói phải viết thành luật kiểm tra được**, không chỉ viết trong prompt — prompt là lời dặn model, guardrail là cổng kiểm tra độc lập với model.
- **PII guardrail hai chiều:** DetectPII quét cả prompt người dùng (không để PII đi vào model/log) lẫn đầu ra (không để PII lọt ra). Khi fail có thể che (redact) thay vì chặn cứng — lựa chọn `fix` thay vì `exception` khi thông tin còn lại vẫn hữu ích. Nối task 132 mục bảo mật bộ nhớ: PII lọt vào log/trace là một đường rò rỉ; guardrail ở đầu vào là chỗ rẻ nhất để cắt đường đó.
- **Competitor check bằng pipeline hai tầng:** khóa dựng pipeline phát hiện tên đối thủ gồm logic điều kiện rẽ sang khớp chính xác (exact match) hoặc kiểm tra ngưỡng bằng NER (named entity recognition). Bài học thiết kế: **kết hợp luật xác định với model xác suất** — khớp chính xác bắt trường hợp rõ ràng với chi phí gần 0, NER bắt trường hợp viết tắt/biến thể mà regex bỏ sót. Đây là dạng thu nhỏ của nguyên tắc ba lớp evaluator ở task 132.

## 6. Guardrail server (OpenAI-compatible): đưa lớp chặn ra khỏi code ứng dụng

- **Hai cách triển khai:** (a) *thư viện trong code* — import Guard, bọc lệnh gọi LLM ngay trong ứng dụng; (b) *server độc lập* — chạy `guardrails start` với file config định nghĩa các Guard, server phơi endpoint REST trong đó có endpoint **tương thích OpenAI** dạng `/guards/<tên-guard>/openai/v1/chat/completions`. Client chỉ cần trỏ `base_url` của OpenAI SDK sang server này là mọi request tự động qua validator, response trả về đúng định dạng OpenAI cộng thêm metadata `guardrails.validation_passed`.
- **Ý nghĩa kiến trúc:** khi guardrail là server, **chính sách chặn tách khỏi ứng dụng** — nhiều ứng dụng dùng chung một bộ luật, sửa luật một chỗ áp cho tất cả, và ứng dụng không cần biết validator nào đang chạy. Đổi lại: thêm một dịch vụ phải vận hành, thêm độ trễ mạng, và thêm một điểm hỏng (server guardrail chết thì request chết theo hay cho qua? — xem mục 7).
- **Ánh xạ sang team:** hub muse-teamwork (port 8787) đóng vai tương tự ở quy mô nhỏ — một điểm chung phơi trạng thái task cho các agent, nhưng nguồn sự thật vẫn là file task trên GitHub và hub chỉ là tăng tốc. Bài học chung: **lớp trung gian dùng chung chỉ nên tăng tốc hoặc kiểm tra, không nên trở thành nguồn sự thật duy nhất** — guardrail server hỏng phải có đường lui về kiểm tra tại chỗ hoặc từ chối an toàn, giống hub chết thì team vẫn làm việc qua GitHub.

## 7. Production considerations: độ trễ, chặn nhầm, và fail open hay fail closed

- **Mỗi validator là một lần tính toán thêm.** Validator luật (regex, độ dài) gần như miễn phí; validator model (NLI, classifier độc hại, LLM judge) cộng độ trễ và chi phí theo từng request. Pipeline nhiều validator model nối tiếp nhau có thể chậm hơn chính lệnh gọi LLM. Giải pháp khóa/tài liệu gợi ý: sắp xếp rẻ trước đắt sau, chạy song song các validator độc lập, và chỉ bật validator đắt cho luồng rủi ro cao.
- **Chặn nhầm (false positive) là chi phí thật:** guardrail chặn câu trả lời đúng làm người dùng khó chịu và đội vận hành mất niềm tin vào lớp chặn, dẫn tới tắt guardrail — thất bại tệ nhất. Vì vậy phải **đo tỉ lệ chặn và tỉ lệ chặn nhầm** như đo chất lượng sản phẩm (nối thẳng task 132: guardrail không có benchmark là guardrail không biết mình đang giúp hay đang hại).
- **Fail open vs fail closed phải quyết trước:** khi chính validator lỗi/timeout, hệ thống cho qua (fail open — ưu tiên khả dụng) hay chặn (fail closed — ưu tiên an toàn)? Không có đáp án chung: luồng chứa PII/secret nên fail closed, luồng nội dung thông thường có thể fail open kèm ghi log. Lỗi nguy hiểm nhất là **không quyết** — để mặc định của thư viện quyết thay.
- **Guardrail cũng bị tấn công:** validator dựa từ khóa bị né bằng cách viết lái; classifier bị né bằng paraphrase. Guardrail giảm rủi ro chứ không xóa rủi ro — vì vậy vẫn cần lớp đo ngoại tuyến (evals) và lớp tấn công thử (red-teaming) ở mục 8.

## 8. Phân biệt guardrail vs evaluator vs red-teaming (checklist mục 3)

Ba khái niệm hay bị trộn lẫn; khóa này và tài liệu hiện hành phân biệt rõ theo **thời điểm chạy** và **câu hỏi trả lời**:

| Khía cạnh | Guardrail | Evaluator (evals) | Red-teaming |
|---|---|---|---|
| Thời điểm | **Lúc chạy** (runtime), trên từng request thật | **Ngoại tuyến** (offline), trên bộ case cố định | **Định kỳ/đợt**, trước phát hành hoặc theo lịch |
| Câu hỏi trả lời | "Request này có được qua không?" | "Hệ thống tốt đến đâu, có hồi quy không?" | "Người tấn công giỏi có phá được hệ thống không?" |
| Hành động khi phát hiện lỗi | Chặn/sửa/reask ngay tại chỗ | Ghi điểm, so phiên bản, tạo case hồi quy | Báo cáo lỗ hổng để vá |
| Tính chất | Kiểm soát (control) | Đo lường (measurement) | Kiểm toán tấn công (audit) |
| Ví dụ trong khóa/team | Input/output guard, NLI check từng câu | Task 132: benchmark Northwind, LLM judge hiệu chuẩn | Đội thử jailbreak/prompt injection có chủ đích |
| Điểm mù | Chỉ bắt lỗi đã biết luật; bị né bằng paraphrase | Chỉ đo trên case đã nghĩ ra; không chặn được request thật | Ảnh chụp tại một thời điểm; đắt, không lặp lại liên tục được |

- **Quan hệ vòng tròn:** red-teaming tìm lỗ hổng mới → lỗ hổng thành case trong benchmark (evals) → case đo được thì viết thành validator (guardrail) → guardrail chặn hụt ngoài đời lại quay về thành case mới. Thiếu một khâu là vòng hở: có guardrail mà không có evals thì không biết guardrail chặn đúng hay chặn nhầm; có evals mà không có guardrail thì biết lỗi mà không chặn được lúc chạy; có cả hai mà không red-team thì chỉ phòng thủ được lỗi đã biết.
- **Ánh xạ sang team:** PROTOCOL hiện tại đã có đủ ba khâu ở dạng thủ công — *guardrail* là script claim/complete + cổng merge của chị cả (chặn lúc chạy), *evaluator* là vòng review chấm điểm + validate/device test (đo ngoại tuyến trên từng task), *red-teaming* ở dạng nhẹ là các task kiểm chứng đối kháng (ví dụ task 109 kiểm chứng bảng PUA bằng dữ liệu thật thay vì tin báo cáo). Khóa này cho tên gọi và khung lý thuyết để team nhận ra mình đang chạy đủ vòng, chỉ chưa tự động hóa.

## 9. Đối chiếu: đo (132) vs chặn (135) — hai nửa của một vòng

| Khía cạnh | Task 132 — Evals (Arize Phoenix) | Task 135 — Guardrails (GuardrailsAI) |
|---|---|---|
| Câu hỏi trung tâm | Làm sao *biết* agent đang tốt hay đang hại | Làm sao *ngăn* lỗi tới được người dùng/hệ thống đích |
| Thời điểm | Ngoại tuyến, trước/sau khi phát hành | Lúc chạy, trên từng request |
| Đơn vị xử lý | Trace + benchmark có nhãn | Từng input/output đi qua Guard |
| Công cụ chính | Code evaluator, LLM judge đã hiệu chuẩn, nhãn người | Validator luật + validator model (NLI, classifier), `on_fail` |
| Khi phát hiện lỗi | Ghi case hồi quy, sửa rồi đo lại | Chặn/sửa/reask ngay, không cho qua |
| Rủi ro đặc trưng | Tin judge chưa hiệu chuẩn; benchmark cũ cho an toàn giả | Chặn nhầm làm mất niềm tin; fail open/closed không quyết trước |
| Đóng góp cho trục an toàn | Phép đo chất lượng + bảo mật bộ nhớ | Lớp chặn runtime + kỷ luật ngưỡng đo được |

Hai khóa xếp thành một thang hoàn chỉnh nối tiếp trục bộ nhớ (127 framework → 128 hạ tầng → 130 quản lý context → 132 đo lường → 135 chặn): **biết nhớ đúng cách chưa đủ, phải đo được nhớ đúng hay sai (132), và phải chặn được khi đo thấy sai mà vẫn lọt (135)**. Điểm hội tụ: cả hai đều chống "tin model tự ngoan" — 132 bằng bằng chứng đo được, 135 bằng cổng kiểm tra độc lập với model. Điểm phân kỳ: 132 xây hệ thống *kiểm chứng*, 135 xây hệ thống *cưỡng chế* — kiểm chứng mà không cưỡng chế thì lỗi đã biết vẫn tới tay người dùng; cưỡng chế mà không kiểm chứng thì không biết cổng đang chặn đúng hay chặn nhầm.

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai build (muse-1) và cách team muse-teamwork đang vận hành — team hiện chạy một vòng chặn bằng script + cổng review; khóa này cho thêm kỷ luật còn thiếu:

1. **Chặn ở đầu vào rẻ hơn chặn ở đầu ra (§2).** Claim-task kiểm tra trước khi nhận việc là input guard của team: chặn trùng task trước khi tốn công build. *Áp dụng ngay:* giữ nguyên kỷ luật claim bằng script (không sửa tay file task để nhận việc), và khi tạo task mới, kiểm tra trùng site/trùng việc ngay lúc tạo (PROTOCOL §3) thay vì để tới review mới phát hiện.
2. **Mỗi cổng chặn phải có hành động khi fail viết rõ (§3).** "Không đạt thì sao" phải quyết trước: sửa lại (reask), tự sửa cục bộ (fix), từ chối (exception/refrain) hay ghi nhận cho qua (noop). *Áp dụng ngay:* khi viết checklist task, mỗi mục nên rõ hệ quả khi không đạt — trả về doing sửa tiếp, blocked chờ Anh quyết, hay cancelled đóng nguồn — thay vì để người review tự đoán.
3. **Từng khẳng định phải bám nguồn, kiểm tra theo đơn vị nhỏ nhất (§4).** NLI kiểm tra từng câu, không kiểm tra cả đoạn. *Áp dụng ngay:* báo cáo research và result.notes phải để từng số liệu/kết luận truy được về nguồn hoặc bằng chứng cụ thể; khẳng định không bám nguồn thì cắt hoặc ghi "Chưa xác định" — đúng quy tắc của Anh, nay có thêm lý do kỹ thuật: chấm cả báo cáo một lượt sẽ tha khẳng định bịa lẫn trong báo cáo đúng.
4. **Ngưỡng chặn phải chọn bằng số đo, không bằng cảm tính (§4, §7).** Ngưỡng NLI/classifier quyết định đánh đổi chặn nhầm vs lọt lỗi. *Áp dụng ngay:* các ngưỡng team đang dùng (điểm review ≥7 mới merge, claim hết hạn 2h, watchdog 30 phút) cũng là ngưỡng guardrail — khi muốn đổi ngưỡng, phải có số liệu từ các task đã qua (bao nhiêu task bị chặn nhầm, bao nhiêu lỗi lọt) chứ không đổi theo cảm giác.
5. **Fail open hay fail closed phải quyết trước cho từng cổng (§7).** Hub chết thì team làm tiếp qua GitHub (fail open có đường lui); cổng merge thì fail closed tuyệt đối (chưa đủ 3 điều kiện thì không merge, không ngoại lệ). *Áp dụng ngay:* khi thêm bất kỳ kiểm tra tự động nào (watcher, sweep, script), ghi rõ trong task/PROTOCOL là kiểm tra đó hỏng thì hệ thống dừng hay đi tiếp — không để mặc định quyết thay.
6. **Lớp trung gian dùng chung không được thành nguồn sự thật duy nhất (§6).** Guardrail server tách chính sách khỏi ứng dụng nhưng thêm điểm hỏng. *Áp dụng ngay:* hub chỉ tăng tốc, file task trên GitHub là nguồn sự thật (đã có trong PROTOCOL); mọi lớp kiểm tra mới cũng phải giữ tính chất này — hỏng lớp kiểm tra không được làm mất dữ liệu gốc.
7. **Đo tỉ lệ chặn nhầm của chính cổng chặn (§7).** Guardrail chặn nhầm nhiều sẽ bị tắt. *Áp dụng ngay:* khi chị cả trả task về doing nhiều vòng vì cùng một lý do, đó là tín hiệu rubric/checklist đang chặn nhầm (viết chưa rõ) chứ không hẳn worker làm sai — sửa rubric trước, đổi worker sau (nối bài học hiệu chuẩn judge của task 132).
8. **Vòng đo–chặn–tấn công thử phải khép kín (§8).** Lỗi lọt qua cổng merge ngoài đời phải quay lại thành case trong skill/task đóng (đã có), và case đó phải thành luật kiểm tra ở vòng sau. *Áp dụng ngay:* mỗi lần một nguồn đã merge lại hỏng, không chỉ sửa nguồn — ghi thêm mục "đã thử/không thử lại" vào skill để cổng kiểm tra lần sau bắt được, đúng vòng red-team → eval → guardrail ở quy mô file.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ, theo tiền lệ task 118–132):

1. **Skill `vbook-extension-building` — thêm mục "Chặn ở đầu vào trước khi tốn công: kiểm tra trùng và điều kiện tiên quyết" (từ §2):** trước khi build, chạy đủ kiểm tra rẻ (trùng site, task trùng, nguồn đã đóng, điều kiện tiên quyết như dev mode) và ghi kết quả vào task file; phát hiện trùng/thiếu điều kiện ở bước này thì dừng ngay, không build rồi mới báo — input guard rẻ hơn output guard.
2. **Skill `vbook-extension-building` — thêm mục "Mỗi mục checklist phải rõ hành động khi không đạt" (từ §3):** khi tạo task, mỗi mục checklist ghi kèm hệ quả: sửa tiếp (doing), chờ quyết (blocked + cần gì), hay đóng (cancelled + lý do). Mục nào không rõ hệ quả thì người làm và người review sẽ hiểu khác nhau — viết lại mục trước khi giao.
3. **Skill `vbook-extension-building` — thêm mục "Khẳng định phải bám nguồn ở mức từng câu" (từ §4):** trong báo cáo/result, mỗi số liệu và kết luận phải truy được về bằng chứng cụ thể (log, link, commit, ảnh chụp); khẳng định không bám nguồn thì cắt bỏ hoặc ghi "Chưa xác định", không để lẫn trong báo cáo đúng — dạng thủ công của hallucination guard bằng NLI.
4. **Không đề xuất sửa PROTOCOL.md, không đề xuất cài GuardrailsAI:** ánh xạ input guard = claim-task + kiểm tra trùng §3, output guard = cổng merge §4, evaluator = review chấm điểm, red-teaming dạng nhẹ = task kiểm chứng đối kháng cho thấy vòng đo–chặn hiện tại đã đúng khung của khóa ở quy mô file + GitHub. Bài học lấy ở kỷ luật (chặn sớm rẻ hơn, rõ hành động khi fail, ngưỡng chọn bằng số đo, quyết fail open/closed trước), không lấy ở sản phẩm; GuardrailsAI chỉ cần khi team có ứng dụng LLM chạy production với lưu lượng thật cần kiểm tra từng request. Thêm lưu ý vòng đời công cụ ở mục Kiểm chứng FREE: trạng thái Hub/hosted inference năm 2026 cần kiểm chứng lại trước bất kỳ quyết định dùng thật nào.

## Khóa tiếp theo

- Track của muse-1 sau khóa này chưa được Anh/chị cả chốt cố định — chờ muse-main tạo task theo PROTOCOL §10(a) khi board rảnh; nếu board lại có task build/gấp thì ưu tiên task đó trước (PROTOCOL §9). Task 134 (Transformer Models and BERT) là của muse-2, không đụng.
- Trục an toàn coi như khép ở hai góc (132 đo lường, 135 chặn runtime). Gợi ý cho chị cả cân nhắc (không phải yêu cầu): mảng còn trống tiếp theo là **red-teaming hệ thống** (tấn công thử có phương pháp: prompt injection, jailbreak, memory poisoning) — team đã chạm rải rác qua các task kiểm chứng đối kháng và mục bảo mật bộ nhớ của 132, nhưng chưa có khóa hệ thống. Nếu muốn đi tiếp trục này, một khóa về AI red-teaming/security cho agent sẽ bổ sung đúng khâu thứ ba của vòng đo–chặn–tấn công thử.

## Nguồn

- Trang khóa chính thức — mục tiêu học, 10 lessons + 7 code examples, giảng viên Shreya Rajpal, ngày xuất bản 13/11/2024, ví dụ chatbot tiệm pizza RAG, các guardrail PII/chủ đề/đối thủ/NLI: https://staging.deeplearning.ai/courses/safe-and-reliable-ai-via-guardrails
- Tổng hợp độc lập về giá DeepLearning.AI — video free, lab/quiz/chứng chỉ cần Pro 25/30 USD, kiểm chứng tháng 11/2026: https://freeaicourses.com/platforms/deeplearning-ai
- Tổng hợp độc lập thứ hai về DeepLearning.AI — cùng kết luận freemium, Pro ra mắt 29/10/2025: https://pasqualepillitteri.it/en/news/25098/free-ai-courses-deeplearning-ai-hugging-face-guide
- Trang PyPI guardrails-ai — định nghĩa Input/Output Guards, Guardrails Hub, guardrail server qua `guardrails start` và endpoint tương thích OpenAI: https://pypi.org/project/guardrails-ai/0.5.11/
- Tài liệu endpoint tương thích OpenAI của Guardrails API — đường dẫn `/guards/{guard_name}/openai/v1/chat/completions`, metadata `guardrails.validation_passed`: https://deepwiki.com/guardrails-ai/guardrails-api/4.3-openai-compatible-endpoints
- Tài liệu validators của Guardrails API — phân loại input/output/structural validator, DetectPII, CompetitorCheck, tham số `on_fail`: https://deepwiki.com/guardrails-ai/guardrails-api/3.2-validators
- Bài thực hành GuardrailsAI — GibberishText/DetectPII/DetectJailbreak ở kênh input vs output, input guard tiết kiệm token, DetectPII dùng Microsoft Presidio: https://www.aiappsecacademy.com/blog/guardrails-ai-validators
- Bài của GuardrailsAI về provenance validators — kiểm tra từng câu bám nguồn để giảm ảo giác, ngưỡng và `on_fail="fix"`: https://guardrailsai.com/blog/reduce-ai-hallucinations-provenance-guardrails
- Bài tổng hợp guardrails — bốn lớp bảo vệ, tiered validation rẻ trước đắt sau, NLI cho groundedness: https://orchestrator.dev/blog/2025-12-10-ai-guardrails/
- Chương sách về guardrails và runtime safety — ba lớp an toàn (alignment, guardrails runtime, evaluation offline), guardrail không thay thế eval: https://llmbook.icsgen-ai.org/part-10-llm-security-runtime-safety/module-48-guardrails-runtime-safety/section-48.1.html
- Bài phân biệt red-teaming vs evals vs guardrails — red teaming là kiểm toán, evals đo hiệu năng, guardrails là kiểm soát runtime: https://www.sichgate.com/articles/not-red-teaming-evals-guardrails
- Bài tổng hợp guardrails 2026 — guardrail kiểm tra ở ba điểm (trước prompt, sau response, khi gọi tool), khác system prompt/alignment/evals ở thời điểm chạy: https://alphacorp.ai/blog/what-are-ai-guardrails
- Review độc lập Guardrails AI 2026 — trạng thái Hub/hosted inference đóng tháng 8/2026, validator qua PyPI, các hành động `on_fail` (reask/fix/filter/refrain/noop/exception): https://www.anchorterminal.com/tools/guardrails-ai
