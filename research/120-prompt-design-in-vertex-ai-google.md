# Prompt Design in Vertex AI (Google) — Báo cáo tự học (task 120)

- **Khóa học:** Prompt Design in Vertex AI, Google Cloud Skills Boost (trình độ introductory, skill badge)
- **Trang khóa:** Google Cloud Skills Boost, tìm "Prompt Design in Vertex AI" trong learning path "Generative AI": https://www.cloudskillsboost.google/journeys/118
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 120). **Không chạy lab trên GCP** — các lab cần Google Cloud project + credit Skills Boost; báo cáo này học kỹ nội dung khóa qua tài liệu chính thức của Google (whitepaper Prompt Engineering, tài liệu Vertex AI) + ghi chép chi tiết của học viên đã hoàn thành cả 4 lab.
- **Quy mô khóa:** ~3 giờ 45 phút; 4 lab thực hành (45 phút + 1 giờ + 1 giờ + challenge lab 1,5 giờ); không yêu cầu lập trình cho 2 lab đầu, lab SDK cần Python cơ bản + Jupyter.
- **Mô hình dùng trong khóa:** Gemini (gemini-1.5-pro trong bản lab 2025; bản cập nhật dùng Gemini 2.0 Flash), text-bison/chat-bison ở các lab đời đầu.
- **Phạm vi báo cáo:** học kỹ 4 lab của khóa chính + đọc thêm whitepaper "Prompt Engineering" của Google (Lee Boonstra, 02/2025) — tài liệu gốc mà khóa này dựa vào — vì whitepaper giải thích đầy đủ các kỹ thuật mà lab chỉ cho thực hành nhanh (CoT, ReAct, ToT, step-back, tự đánh giá prompt).

## Tóm tắt khóa chính — Prompt Design in Vertex AI

### 1. Prompt là gì, và giải phẫu một prompt

- **Prompt** là yêu cầu bằng ngôn ngữ tự nhiên gửi cho mô hình để nó sinh văn bản, ảnh, code hoặc đầu ra khác. Một prompt đầy đủ có thể gồm: hướng dẫn (instruction), bối cảnh (context), ví dụ few-shot, hoặc một phần đầu vào để model hoàn thành.
- **Giải phẫu prompt (theo khóa):** 3 thành phần lặp lại trong mọi prompt tốt:
  - **System instructions:** chỉ dẫn hệ thống, định hướng hành vi chung của model (vd: "You are a creative marketing assistant for an outdoor brand").
  - **User prompt:** yêu cầu cụ thể của lượt này.
  - **Examples (few-shot):** ví dụ mẫu để model bắt đúng khuôn cần theo.
- **Quy trình prompt engineering là test-driven, lặp lại:** định nghĩa mục tiêu → viết prompt → test → đánh giá kết quả → tinh chỉnh → lặp lại. Model nhạy với thay đổi nhỏ trong câu chữ — sửa một từ có thể đổi hẳn đầu ra — nên không có "prompt đúng tuyệt đối", chỉ có prompt đã được kiểm chứng trên bộ test của mình. Nối tiếp đúng kết luận của task 119: LLM dự đoán từ tiếp theo, không "hiểu" — vì vậy kiểm chứng bằng test là bắt buộc, không phải tùy chọn.

### 2. Cấu hình đầu ra của LLM — 3 núm vặn quyết định "tính cách" câu trả lời

LLM dự đoán xác suất cho từng token tiếp theo; 3 tham số quyết định cách chọn token từ phân phối xác suất đó:

- **Temperature (độ ngẫu nhiên):** 0 = greedy decoding, luôn chọn token xác suất cao nhất → xác định, lặp lại được, phù hợp task chỉ có một đáp án đúng (phân loại, trích xuất, validate). 0,7 = cân bằng, sáng tạo nhưng vẫn bám đất. 0,9+ = hoang dã, đa dạng, khó đoán. Nhiệt độ cao không làm model "thông minh hơn", chỉ làm nó liều hơn khi chọn token.
- **Top-K:** chỉ xét K token có xác suất cao nhất. Top-K = 1 tương đương greedy decoding. K thấp → an toàn, thực tế; K cao → sáng tạo, đa dạng.
- **Top-P (nucleus sampling):** chỉ xét nhóm token có tổng xác suất tích lũy đạt P (vd 0,95). Cùng họ với top-K nhưng linh hoạt theo hình dạng phân phối.
- **Max tokens (độ dài đầu ra):** giới hạn số token sinh ra — token càng nhiều, chi phí + thời gian + năng lượng càng tăng. Điểm xuất phát an toàn được nhiều người dùng gợi ý: `temperature=0.2, top_p=0.95, top_k=30` cho task cần chính xác.
- **Quy tắc thực hành của khóa:** chỉ chỉnh **một** trong temperature/top-K/top-P mỗi lần, hoặc chỉ đổi temperature và giữ 2 cái còn lại mặc định — chỉnh cả ba cùng lúc thì không biết núm nào gây ra thay đổi.

### 3. Các kỹ thuật prompting — thang "đỡ" tăng dần

- **Zero-shot:** chỉ mô tả task, không ví dụ. Đủ cho task đơn giản, model mạnh đã biết làm (hỏi đáp, tóm tắt ngắn). Bắt đầu từ đây, chỉ leo thang khi zero-shot thất bại.
- **One-shot / few-shot:** cho 1–5 ví dụ mẫu trong prompt để model bắt khuôn (định dạng, giọng, độ dài). Ví dụ trong lab: phân loại cảm xúc (positive/neutral/negative) chỉ cần 1 ví dụ mẫu là model làm đúng khuôn. Lưu ý: quá nhiều ví dụ gây overfit vào ví dụ; với task phân loại, **trộn lẫn thứ tự các lớp** trong ví dụ để tránh model thiên kiến theo lớp xuất hiện cuối.
- **System prompting:** đặt vai trò/bối cảnh ở tầng hệ thống, áp dụng cho mọi lượt trong phiên (vd: trợ lý marketing cho hãng đồ outdoor). Khác role prompting ở chỗ: system instruction là "luật chơi" cố định của cả phiên, còn role là vai trong một prompt cụ thể.
- **Role prompting:** "Bạn là..." — định giọng, từ vựng, góc nhìn (nhà phân tích, giáo viên, người soát hợp đồng).
- **Contextual prompting:** đưa dữ liệu/bối cảnh cần thiết vào prompt (văn bản cần tóm tắt, hồ sơ khách hàng). Model không có dữ kiện thì sẽ bịa — đây là nguyên nhân số 1 của ảo giác trong thực hành.
- **Step-back prompting:** trước khi trả lời câu cụ thể, bảo model lùi một bước suy nghĩ về nguyên tắc/khái niệm chung rồi mới áp dụng xuống — hữu ích cho câu hỏi cần suy luận, không chỉ tra cứu.
- **Chain-of-Thought (CoT):** bảo model trình bày từng bước suy luận trước khi chốt đáp án ("hãy suy nghĩ từng bước"). Tăng độ chính xác rõ rệt ở task toán/logic; đi kèm best practice: cho ví dụ CoT mẫu, và yêu cầu model tự kiểm tra lại các bước.
- **Self-consistency:** chạy cùng một prompt CoT nhiều lần (temperature > 0) rồi lấy đáp án xuất hiện nhiều nhất — đổi "một đường suy luận" thành "bỏ phiếu giữa nhiều đường".
- **Tree-of-Thoughts (ToT):** mở nhiều nhánh suy luận song song, đánh giá từng nhánh rồi chọn nhánh tốt nhất — cho bài toán mở, cần khám phá nhiều hướng.
- **ReAct (Reason + Act):** xen kẽ suy luận với hành động (gọi công cụ, tra cứu) — model vừa nghĩ vừa làm, dùng kết quả tra cứu để sửa hướng suy luận. Đây là nền tảng của agent.
- **Automatic Prompt Engineering (APE):** dùng chính LLM để sinh và chấm nhiều biến thể prompt, chọn biến thể tốt nhất — tự động hóa vòng lặp test-driven ở §1.
- **Thứ tự leo thang (khóa + whitepaper):** zero-shot → thêm ví dụ (few-shot) → thêm vai trò/bối cảnh → CoT → self-consistency/ToT → ReAct. Mỗi bậc tốn thêm token; đừng dùng ReAct cho việc zero-shot đã làm xong.

### 4. Best practices — danh sách kiểm tra của Google (whitepaper 02/2025)

- **Cho ví dụ (provide examples):** ví dụ tốt hơn mọi lời mô tả dài.
- **Thiết kế đơn giản:** prompt ngắn, rõ ý tốt hơn prompt dài, vòng vo. Ví dụ trong khóa: "Suggest three names for an artisanal, sustainable coffee shop." thắng câu hỏi dài dòng cùng ý.
- **Cụ thể về đầu ra:** ghi rõ định dạng, giọng, số lượng ("List five benefits..., each in one sentence").
- **Dùng instruction thay vì constraint:** nói model **nên làm gì** thay vì liệt kê thứ **không được làm** — model tuân theo hướng dẫn tích cực tốt hơn danh sách cấm.
- **Một task một lúc:** tách các yêu cầu khác nhau thành từng prompt riêng.
- **Kiểm soát max token:** đầu ra quá dài tốn token, quá ngắn mất ý.
- **Dùng biến trong prompt:** viết prompt dạng template có chỗ điền biến (`{tên_sản_phẩm}`, `{đối_tượng}`) để tái dùng và test hàng loạt.
- **Thử nhiều định dạng đầu vào và phong cách viết:** cùng một task, đổi cách trình bày dữ liệu (bảng, JSON, gạch đầu dòng) có thể đổi hẳn chất lượng.
- **Ghi lại mọi lần thử prompt (document attempts):** phiên bản prompt, tham số, đầu ra, đánh giá — không có nhật ký thì không biết bản nào tốt hơn bản nào, và không tái lập được kết quả tốt.
- **Thích ứng khi model cập nhật:** prompt tối ưu cho model cũ có thể lệch trên model mới — kiểm tra lại sau mỗi lần đổi model.

### 5. Biến task sinh (generative) thành phân loại (classification) — mẹo kiểm soát đầu ra

- Task sinh mở (viết đoạn văn, nghĩ slogan) cho đầu ra khó đoán, khó chấm tự động.
- **Cách khóa dạy:** đóng khung lại thành phân loại — bắt model **chọn trong các phương án cho trước** thay vì sinh tự do. Ví dụ: phân loại cảm xúc review thành positive/neutral/negative thay vì "nói cảm nhận của bạn".
- Khi bắt buộc phải sinh mở, khóa đầu ra bằng **định dạng bắt buộc** (JSON có đúng các field, độ dài tối đa, số mục cố định) — máy đọc được thì mới chấm tự động được.
- Nối tiếp điểm 1 của task 119 (bài thử "Y là số/nhãn hay nội dung"): phân loại = đầu ra là nhãn → kiểm chứng được ngay; sinh mở = đầu ra là nội dung → phải có người đọc chấm. Chọn dạng task theo khả năng kiểm chứng của mình.

### 6. Multimodal prompting — một prompt, nhiều loại đầu vào

- Gemini nhận trong cùng một prompt: **văn bản + ảnh + video + file (PDF) + dữ liệu có cấu trúc**.
- **Lab 2 (Vertex AI Studio):** upload ảnh sản phẩm → yêu cầu model viết mô tả như quảng cáo; đổi tham số creativity để so sánh các bản mô tả. Bài tập trong lab: tóm tắt review khách hàng thành pros/cons.
- **Ví dụ qua SDK:** caption ảnh (`[image, "Provide a poetic caption..."]`), tóm tắt video (`Part.from_uri("gs://.../travel.mp4")` + "Summarize the main events..."), liệt kê vật thể trong ảnh từ URL.
- **Quy tắc thực hành:** đặt câu hỏi về ảnh/video **cụ thể như hỏi về văn bản** — model trả lời theo đúng câu hỏi, nên câu hỏi mơ hồ cho mô tả mơ hồ; muốn JSON thì ghi rõ schema JSON ngay trong prompt.
- **Ứng dụng trực tiếp cho vai research:** khi worker cần "đọc" một trang web/screenshot, prompt multimodal tốt = ảnh chụp trang + câu hỏi cụ thể ("nút X nằm ở đâu, chữ trên nút là gì") thay vì "mô tả trang này".

### 7. Từ Studio (no-code) sang SDK (code) — Lab 2 và Lab 3

- **Vertex AI Studio:** sân chơi no-code — tạo/sửa/test prompt trực tiếp, chỉnh temperature/top-K/top-P bằng thanh trượt, lưu prompt, export sang Python notebook. Dùng để **thử nhanh** trước khi code.
- **GenAI SDK (Python):** `vertexai.generative_models.GenerativeModel("gemini-2.0-flash")`, `generate_content(...)`, chat nhiều lượt (`start_chat` / `send_message`), **streaming** (`stream=True`) cho phản hồi thời gian thực, **đếm token** trước khi gửi để kiểm soát chi phí, **function calling** (model gọi hàm ngoài), **embedding** (tìm kiếm tương tự, gom cụm), **batch prediction**.
- **Luồng làm việc chuẩn mà khóa dạy:** thử prompt trong Studio → chốt prompt + tham số → export sang notebook → chạy bằng SDK trong ứng dụng thật. Đừng code trước khi prompt đã tốt — code chỉ đóng gói prompt tốt, không sửa được prompt dở.

### 8. Challenge Lab — trợ lý marketing cho Cymbal Direct (1,5 giờ)

- **Tình huống:** startup nội dung giáo dục hợp tác với hãng đồ outdoor **Cymbal Direct**; cần tạo tài sản marketing bằng GenAI.
- **Yêu cầu (4 việc trong 1 lab):**
  1. Viết prompt phân tích ảnh sản phẩm → tạo caption.
  2. Viết prompt sinh tagline từ bối cảnh (system instruction + few-shot).
  3. Export 2 prompt sang Python notebook, chỉnh bằng SDK.
  4. Test nhiều biến thể đầu ra với tham số khác nhau.
- **Đầu ra bắt buộc:** phân tích ảnh + tagline gợi ý + tóm tắt tính năng, **tất cả ở dạng JSON** — kiểm tra được cả 3 kỹ năng: multimodal, system instruction, định dạng đầu ra có cấu trúc.
- **Bài học của lab:** bài toán thực tế không bao giờ là "một prompt", mà là **chuỗi prompt + tham số + định dạng** làm việc cùng nhau; chấm điểm bằng cách kiểm tra JSON có đúng schema không, tagline có bám bối cảnh ảnh không — tức là chấm theo tiêu chí đo được, không chấm theo cảm giác.

### 9. Đánh giá prompt một cách hệ thống — Gen AI Evaluation Service

- **Vấn đề:** cảm giác "prompt này hay hơn" không đo được; model nhạy với thay đổi nhỏ nên cần đo, không đoán.
- **Công cụ:** Vertex AI Gen AI Evaluation Service — chấm prompt theo metric có sẵn (summarization quality, groundedness, verbosity, instruction following...) hoặc metric tự định nghĩa theo rubric.
- **Quy tắc của Google (tài liệu Prompting Strategies):** bộ đánh giá cần **200–500 ví dụ** mới cho kết quả ổn định; chạy **sensitivity analysis** — chạy cùng prompt nhiều lần để biết độ biến động của chính model; tránh bẫy mẫu nhỏ (vài ví dụ tốt không chứng minh prompt tốt).
- **Dạng chấm:** computation-based (so với đáp án chuẩn) và model-based (dùng model khác chấm theo rubric, pointwise/pairwise).

### 10. Responsible AI trong prompt design

- **Safety filters:** Gemini có bộ lọc theo danh mục (hate, violence, self-harm...) với ngưỡng chặn chỉnh được theo từng request (`HarmBlockThreshold.BLOCK_LOW`...). Người thiết kế prompt chủ động đặt ngưỡng phù hợp thương hiệu/ngữ cảnh, không để mặc định.
- **Thiên kiến trong few-shot:** thứ tự và lựa chọn ví dụ có thể nhét thiên kiến vào model — trộn lớp, đa dạng ví dụ.
- **Groundedness:** dùng công cụ grounding (Google Search, code execution) trong prompt để giảm ảo giác — model tra cứu thay vì bịa. Nối tiếp điểm 4 của task 119: không tin output chưa kiểm chứng live.

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc build extension vBook của team:

1. **Viết checklist task như viết prompt: thêm "thang leo thang" (§3).** Task 119 đã chốt "viết checklist như viết prompt cho model instruction-tuned". Khóa này bổ sung thứ tự leo thang: checklist nên bắt đầu từ yêu cầu đơn giản nhất (zero-shot) và chỉ thêm chi tiết khi worker làm sai ở bước đó — checklist dài ngay từ đầu cũng như few-shot thừa ví dụ: tốn token, gây nhiễu. *Áp dụng ngay:* khi viết task mới, để checklist ở mức tối thiểu đủ pass (validate PASS, device test code 0, install 200); chi tiết kỹ thuật chỉ thêm vào khi review phát hiện worker sai đúng chỗ đó.
2. **"Một task một lúc" → một task một việc (§4).** Checklist gộp nhiều việc trong một mục ("build + test + sửa + báo cáo") cho output lệch như prompt gộp nhiều yêu cầu. *Áp dụng ngay:* giữ nguyên thói quen tách checklist thành từng mục đơn, mỗi mục một động từ + một tiêu chí pass/fail — team đã làm đúng, khóa này chỉ gọi tên lý do.
3. **Dùng instruction thay vì constraint khi viết task (§4).** Viết "làm X theo cách Y" hiệu quả hơn "không được làm Z". *Áp dụng ngay:* trong checklist, ưu tiên câu khẳng định ("push branch feature/... lên repo đích") hơn câu cấm; câu cấm chỉ giữ cho ranh giới cứng (TUYỆT ĐỐI KHÔNG merge lên main).
4. **Biến việc chấm review thành phân loại (§5).** Review hiện chấm điểm 0–10 (sinh mở, khó nhất quán giữa các vòng). Mẹo của khóa: đóng khung thành phân loại trước — vd: checklist 3 điều kiện merge (validate/device/install) là phân loại pass/fail; điểm số chỉ là lớp phủ sau. *Áp dụng ngay (đề xuất cho muse-main):* khi review, chấm pass/fail từng mục checklist trước, rồi mới cho điểm tổng — điểm tổng không thay thế 3 điều kiện merge (đã có trong PROTOCOL §4, khóa này xác nhận cách làm đó là đúng về mặt kỹ thuật prompt).
5. **Ghi lại mọi lần thử prompt — áp dụng cho cả prompt của worker (§4).** Whitepaper yêu cầu nhật ký prompt: phiên bản, tham số, đầu ra, đánh giá. *Áp dụng ngay:* file task JSON đã là nhật ký một phần (notes theo PROTOCOL §8); bổ sung: khi một task phải làm lại (review trả về), ghi rõ **bản checklist nào đã đổi và vì sao** vào notes — để lần sau không lặp lại cùng một lỗi prompt.
6. **Đánh giá prompt cần 200–500 ví dụ — soi lại cách team test (§9).** Một lần device test pass không chứng minh extension bền; Google yêu cầu 200–500 mẫu mới ổn định. Team không có 200 máy test, nhưng có thể tăng độ tin cậy bằng cách test **nhiều trang/case khác nhau** thay vì một trang mẫu duy nhất (đã làm ở task 112/114: device test 7–8 case). *Áp dụng ngay:* giữ quy tắc device test nhiều case (≥ 7 case như các task gần đây), không rút xuống 1–2 case cho "nhanh".
7. **System instruction = PROTOCOL.md; user prompt = file task (§1).** Khóa phân biệt system instruction (luật chơi cố định cả phiên) với user prompt (yêu cầu từng lượt). Đối chiếu team: PROTOCOL.md là system instruction của mọi worker; file task JSON là user prompt của từng lượt làm việc. *Áp dụng ngay:* khi worker làm sai lặp lại cùng một kiểu, sửa PROTOCOL.md (system) thay vì sửa từng file task (user prompt) — đúng tinh thần "sửa kỹ thuật nhỏ trước" và khớp điểm 5 của task 119 (PETM: đổi prompt trước, đổi mô hình sau).
8. **Multimodal: hỏi ảnh/screenshot bằng câu hỏi cụ thể (§6).** Khi cần worker hoặc model đọc screenshot trang web/ảnh lỗi, prompt phải hỏi cụ thể từng thứ cần lấy ("nút X có chữ gì", "lỗi hiện dòng nào") — "mô tả ảnh này" cho kết quả chung chung, không dùng được để debug.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — thêm mục "Thang leo thang khi viết checklist" (từ §1–§3 ở trên):** checklist bắt đầu ở mức tối thiểu đủ pass, chỉ thêm chi tiết khi review phát hiện worker sai đúng chỗ đó; lý do: prompt thừa chi tiết gây nhiễu như few-shot thừa ví dụ.
2. **Skill `vbook-extension-building` — thêm mục "Ghi lại bản checklist đã đổi khi task bị trả về" (từ §4, §10):** khi review trả task về `doing`, ghi vào notes: mục checklist nào đã đổi, đổi từ gì sang gì, vì sao — để không lặp lại cùng một lỗi prompt ở vòng sau.
3. **Skill `vbook-extension-building` — thêm mẹo "đóng khung thành phân loại khi cần kiểm chứng" (từ §5):** khi một yêu cầu khó chấm (vd: "đọc tốt", "hiển thị đẹp"), viết lại thành lựa chọn đo được (pass/fail theo tiêu chí cụ thể) trước khi đưa vào checklist.
4. **Không đề xuất sửa PROTOCOL.md:** phân biệt system instruction (PROTOCOL) / user prompt (task file) đã được quy trình hiện tại phản ánh đúng; khóa học xác nhận cấu trúc đó, không cần đổi.

## Khóa tiếp theo

- Theo phân vai §9/§10, muse-2 đã xong cả 3 khóa được giao: **Elements of AI (task 118)**, **Introduction to Generative AI (task 119)**, **Prompt Design in Vertex AI (task 120)**. Khóa tiếp theo chờ muse-main chọn trong danh sách 32 khóa đã duyệt (PROTOCOL §10: muse-main quyết luôn việc chọn khóa học tiếp theo, không hỏi Anh).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): trong cùng learning path Generative AI trên Cloud Skills Boost, khóa **"Develop GenAI Apps with Gemini and Streamlit"** là bước nối tiếp tự nhiên (đưa prompt thành ứng dụng thật bằng Streamlit — đúng hướng "từ Studio sang SDK rồi thành app" của khóa này); hoặc khóa **"Introduction to Image Generation"** nếu muốn mở rộng sang multimodal phía sinh ảnh.

## Nguồn

- Trang khóa: Google Cloud Skills Boost, learning path "Generative AI": https://www.cloudskillsboost.google/journeys/118 (tìm "Prompt Design in Vertex AI" trong path)
- Whitepaper Prompt Engineering (Lee Boonstra, Google, 02/2025): https://drive.google.com/file/d/1AbaBYbEa_EbPelsT40-vj64L-2IwUJHy/view (bản tóm tắt đầy đủ: https://iseoai.com/prompt-engineering-google/ ; toàn văn: https://archive.org/stream/whitepaper-prompt-engineering-v-4/whitepaper_Prompt%20Engineering_v4_djvu.txt)
- Tài liệu Vertex AI Gemini Prompting Strategies (04/2025): https://sup1v9yilh9vrl3qq3b9rc.vclaapp.top/fh/files/misc/1_vertex_ai_gemini_prompting_strategies.pdf
- Ghi chép học viên hoàn thành khóa (4 lab + challenge lab Cymbal Direct): https://bhavyab1375.medium.com/prompt-design-in-vertex-ai-a-hands-on-guide-using-google-cloud-skills-boost-281f0e2e9b71 ; https://tanmaybhujade.medium.com/from-concepts-to-code-my-deep-dive-into-prompt-design-in-vertex-ai-with-google-cloud-1ba8d86a6a81 ; https://shishupalkr.medium.com/mastering-prompt-design-in-vertex-ai-my-learning-journey-671ff1e56317 ; https://dev.to/benito5771/mastering-prompt-design-in-vertex-ai-my-new-google-cloud-skill-badge-dc
- Cheatsheet từ whitepaper: https://the-signal.blog/2025/04/24/googles-prompt-engineering-cheatsheet/
