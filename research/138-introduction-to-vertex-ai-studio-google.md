# Introduction to Vertex AI Studio (Google) — Báo cáo tự học (task 138)

- **Khóa học:** Introduction to Vertex AI Studio, Google Cloud Skills Boost (thuộc chương trình 10 khóa Advanced Generative AI for Developers; đồng thời nằm trong Specialization "Prompt Design, Grounding, and RAG with Vertex AI" trên Coursera)
- **Trang khóa:** Google Skills: https://www.cloudskillsboost.google/course_templates/552
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 138). **Không chạy lab GCP tốn credit** — khóa là video + quiz + 1 hands-on lab "Get Started with Vertex AI Studio" (cần credit Skills Boost); báo cáo này học qua trang khóa chính thức, syllabus trên Class Central/Coursera, tài liệu chính thức của Google Cloud (Vertex AI Studio, Tuning API, Prompt Management, Migrate from AI Studio) và ghi chép lab của học viên đã hoàn thành.
- **Quy mô khóa:** trang Skills ghi 2 giờ, Introductory, xuất bản 2025-12-02, rating 4.16/5 (16.971 reviews); Coursera ghi 1 module, Beginner, 2 giờ, ~30.000 học viên đã đăng ký, ~249 reviews, 4.6/5. Class Central ghi giá 0 USD. Lưu ý: tên sản phẩm/khóa từng là "Generative AI Studio", đổi thành "Vertex AI Studio"; bản thân nền tảng Vertex AI đang được Google đổi tên thành **Gemini Enterprise Agent Platform** (xem §2) — syllabus khóa đã có thêm bài "Get Started with Agent Studio" phản ánh đợt đổi tên này.
- **Vị trí trong vòng tự học:** khóa 12 theo phân vai (sau 136 Encoder-Decoder Architecture). Đây là **khóa chuyển từ hiểu kiến trúc sang dùng công cụ**: sau khi biết encoder/decoder/T5 hoạt động thế nào (131/134/136), biết viết prompt (120) và đóng prompt thành app (121), khóa này dạy **nơi làm ba việc đó trong console của Google** — prototype prompt, tune model, đưa ra production — trên cùng một backend Vertex AI mà task 121 đã gọi bằng code.

## Cấu trúc khóa (syllabus)

| Phần | Nội dung chính |
|---|---|
| Use case | Tình huống doanh nghiệp xuyên suốt khóa (use case nhập vai): từ ý tưởng kinh doanh tới ứng dụng GenAI |
| Idea to app | Khung suy nghĩ "từ ý tưởng thành app": xác định bài toán → chọn model → prototype |
| Prompt engineering | Thiết kế prompt trong Studio: zero/one/few-shot, system instructions, tham số đầu ra |
| Deployment and model tuning | Đưa prototype ra production + tune model khi prompt không đủ |
| Summary | Tổng kết vòng đời prompt-to-production |
| Get Started with Agent Studio | Bài mới (đợt đổi tên 2026): workspace low-code Agent Studio trên Gemini Enterprise Agent Platform |
| Quiz + Reading List | Kiểm tra + tài liệu đọc thêm |

Ba mục tiêu học tập chính thức của khóa (theo trang Skills Boost / Coursera): giải thích được vòng đời prompt-to-production với Vertex AI Studio; prototype được ứng dụng GenAI dùng khả năng multimodal của Gemini; thiết kế prompt hiệu quả bằng cấu hình + best practice; tune được model GenAI bằng nhiều phương pháp.

## 1. Vertex AI Studio là gì — và nó nằm ở đâu trong nền tảng Google

**Vertex AI Studio là console web trong Google Cloud Console để prototype và test model GenAI mà không cần viết code trước.** Truy cập: Cloud Console → Vertex AI → Vertex AI Studio. Nó là "sân chơi no-code" đặt trên cùng backend Vertex AI (nay là Gemini Enterprise Agent Platform) — nơi team đã gọi Gemini bằng SDK ở task 121.

Vị trí của Studio trong nền tảng (theo tài liệu chính thức):

```
Google Cloud project
└── Vertex AI / Gemini Enterprise Agent Platform
    ├── Model Garden — kho model: Gemini, Imagen, Veo, Gemma, Llama, Claude (MaaS)...
    ├── Vertex AI Studio / Agent Studio — workspace low-code: viết prompt, test, so sánh, lưu, export code, build agent
    ├── Tuning — supervised tuning, preference tuning, distillation
    ├── Evaluation — Gen AI Evaluation Service (đã học ở 120 §9)
    └── Deployment — endpoint, Cloud Run, Agent Runtime...
```

Ba điểm định vị cần nhớ:

1. **Studio không phải một model, cũng không phải một API — nó là mặt tiền console của API.** Mọi prompt chạy trong Studio đều gọi cùng endpoint `aiplatform.googleapis.com` mà SDK gọi ở task 121. Khác nhau chỉ là cách tương tác: gõ tay trong trình duyệt thay vì viết code.
2. **Đổi tên 2026: Vertex AI → Gemini Enterprise Agent Platform; Vertex AI Studio → Agent Studio.** Tài liệu hiện tại của Google dùng tên mới; endpoint, SDK (`google-genai`, `vertexai=True`) và cách gọi model không đổi. Khi đọc tài liệu cũ thấy "Vertex AI Studio" và tài liệu mới thấy "Agent Studio", đó là cùng một workspace (bài "Get Started with Agent Studio" trong syllabus chính là bài cập nhật tên gọi này).
3. **Studio hỗ trợ cả model bên thứ ba** qua Models-as-a-Service (vd: Anthropic Claude, Meta Llama) — nhưng khóa này chỉ dạy với Gemini.

## 2. Vòng đời prompt-to-production — khung xương của cả khóa

Khóa tổ chức toàn bộ nội dung quanh một vòng đời 6 bước (prompt-to-product / prompt-to-production lifecycle). Đây là phần đáng giá nhất của khóa — không phải kiến thức model, mà là **trình tự làm việc**:

| Bước | Làm gì trong Studio | Đầu ra |
|---|---|---|
| 1. **Use case — xác định bài toán** | Viết rõ bài toán kinh doanh, đầu vào/đầu ra mong muốn, tiêu chí thành công đo được | Một câu mô tả task + tiêu chí pass/fail (nối 120 §5: đóng khung thành phân loại) |
| 2. **Idea to app — chọn model + prototype** | Chọn model trong Model Garden (vd: Gemini Flash cho nhanh/rẻ, Pro cho khó), thử prompt mẫu trong Prompt Gallery | Prototype chạy được đầu tiên, chưa cần code |
| 3. **Prompt engineering — thiết kế prompt** | Viết system instructions + prompt + ví dụ few-shot; chỉnh temperature/top-K/top-P; thử multimodal (xem §3–§4) | Prompt + tham số đã chốt, test trên vài ví dụ |
| 4. **Evaluate — chấm prompt** | Chạy prompt trên bộ test, chấm bằng metric có sẵn hoặc rubric tự định nghĩa (Gen AI Evaluation Service, 120 §9: cần 200–500 ví dụ mới ổn định) | Điểm số + biết prompt còn yếu ở đâu |
| 5. **Tune — chỉ tune khi prompt không đủ** | Nếu prompt tốt nhất vẫn sai khuôn/sai giọng ổn định → supervised tuning bằng dữ liệu mẫu (xem §5) | Tuned model riêng của mình |
| 6. **Deploy — đưa ra production** | Export code từ Studio ("Get code") → gọi bằng SDK trong app (Streamlit/Cloud Run như 121) hoặc deploy tuned model lên endpoint; lưu prompt có version để quản lý (xem §6) | App chạy thật + prompt đã version |

Hai quy tắc thứ tự mà khóa nhấn mạnh (khớp đúng kết luận 120 §7 và 121 §2):

- **Đừng code trước khi prompt tốt; đừng tune trước khi prompt tốt.** Tune là bước đắt nhất (tốn dữ liệu + tiền + thời gian); phần lớn task dừng ở bước 3–4 là đủ.
- **Mỗi bước đều có "cửa thoát" sang code:** prompt chốt trong Studio export được ngay thành Python/REST — Studio là nơi thử, không phải nơi nhốt prompt.

## 3. Prototype ứng dụng Gemini multimodal trong Studio

### 3.1. Hai chế độ viết prompt: Free-form và Structured

Lab "Get Started with Vertex AI Studio" dạy cả hai chế độ (theo ghi chép lab + quickstart chính thức):

- **Free-form:** một ô prompt tự do — thử nhanh, prompt nhỏ, không ví dụ. Dùng ở bước thử ý tưởng (bước 2–3 của vòng đời).
- **Structured:** prompt có cấu trúc — tách riêng context, input, output, ví dụ few-shot thành từng trường. Dùng khi prompt đã gần chốt và cần test có hệ thống, hoặc cần nhiều ví dụ mẫu để model bắt khuôn.
- Ngoài ra còn **Chat prompt** (nhiều lượt, có system instructions riêng) để thiết kế chatbot, và **Prompt Gallery** — thư viện prompt mẫu theo task (tóm tắt, sinh code, tóm tắt audio...) đã cấu hình sẵn model + tham số, mở ra bấm Submit là chạy.

### 3.2. Multimodal: một prompt, nhiều loại đầu vào

Gemini trong Studio nhận cùng lúc **text + ảnh + video + audio + file (PDF)**. Lab cho thực hành:

- **Ảnh → text:** viết truyện từ ảnh, phân tích ảnh sản phẩm, gợi ý từ ảnh phòng khách (đã gặp dạng này ở 121 §5, Image Playground).
- **Video → text:** tóm tắt video, trả lời câu hỏi về nội dung video, xác định địa điểm trong video.
- **Audio → text:** tóm tắt file audio (prompt mẫu "Audio summarization" trong Gallery).
- **Text + code:** sinh code, giải thích code, viết tài liệu từ sơ đồ.

Quy tắc thực hành (khớp 120 §6): hỏi về ảnh/video **cụ thể như hỏi về văn bản** — "nút reset nằm ở đâu trong ảnh bảng điều khiển" cho đáp án dùng được; "mô tả ảnh này" chỉ cho đáp án chung chung. Muốn JSON thì ghi rõ schema JSON ngay trong prompt.

### 3.3. Lab "Get Started with Vertex AI Studio" — tóm tắt walkthrough

Lab duy nhất của khóa (Qwiklabs "Get Started with Vertex AI Studio"), các bước chính theo ghi chép học viên:

1. Bật Vertex AI API trong Google Cloud project.
2. Vào Vertex AI Studio → Overview: 4 nhóm tính năng (Multimodal, Language, Vision, Speech); lab tập trung Multimodal + Language.
3. **Multimodal powered by Gemini → Try Gemini:** thử prompt ảnh/video, chỉnh model + tham số ở panel Configuration, xem code tương ứng, **lưu prompt** (Save → vào My prompts).
4. **Language powered by Gemini → Create prompt → Text prompt:** thiết kế prompt free-form rồi structured, thử zero/one/few-shot, lưu prompt.
5. Sinh hội thoại nhiều lượt (chat) từ prompt đã thiết kế.

**Lưu ý thực tế:** lab cần project GCP + credit Skills Boost nên báo cáo này **không chạy lab** (theo checklist). Ghi nhận thêm từ trang review của lab (Skills, cuối 2026): một số học viên gần đây báo lab gặp lỗi model Imagen không khả dụng khi tới bước sinh ảnh — **chưa xác định** có phải lỗi tạm thời hay lab chưa cập nhật model mới; nếu team chạy lại lab thì kiểm tra model khả dụng trước (xem §8).

## 4. Prompt design + cấu hình trong Studio — nối khóa 120

Phần này của khóa là **bản thực hành trong Studio** của lý thuyết khóa 120, nên báo cáo chỉ ghi điểm nối, không lặp lại toàn bộ 120:

| Khái niệm (120) | Cách làm trong Studio (khóa này) |
|---|---|
| System instructions | Ô riêng "System instructions" trên mọi prompt — đặt vai trò/luật chơi cố định cả phiên (vd: "You are a creative marketing assistant...") |
| Zero/one/few-shot | Free-form (zero-shot) → Structured (thêm ví dụ mẫu thành trường riêng) — leo thang đúng thứ tự 120 §3 |
| Temperature / top-K / top-P | Thanh trượt + ô số trong panel Configuration, chỉnh trực tiếp cạnh prompt, xem kết quả ngay — không cần chạy lại code |
| Max tokens | Giới hạn độ dài đầu ra ngay trong panel Configuration |
| Best practice "ngắn, cụ thể, một task một lúc" | Khóa nhắc lại y nguyên 3 quy tắc (be concise, be specific, one task at a time) — và Studio làm 3 quy tắc này dễ test: sửa một từ, bấm Submit, so sánh ngay |
| Ghi lại mọi lần thử prompt | Nút **Save** + **Prompt management**: lưu prompt có tên, xem lại, chia sẻ cho teammate, xem code đã export — thay cho nhật ký tay ở 120 §4 |

Điểm mới so với 120 — **so sánh song song (comparison)**: Studio cho chạy cùng một prompt trên 2 model (vd: Gemini Flash vs Pro) hoặc 2 phiên bản prompt cạnh nhau để thấy khác biệt — thay vì chạy lần lượt rồi nhớ mang máng. Đây là cách test A/B prompt nhanh nhất mà không cần viết code so sánh.

## 5. Tuning model — khi nào tune, tune bằng gì

Đây là phần mới hẳn so với 120/121 (hai khóa đó dừng ở prompt + app). Khóa dạy **khái niệm + tiêu chí chọn**, không dạy code tuning chi tiết.

### 5.1. Khi nào cần tune — thang leo thang đầy đủ

Nối thang leo thang của 120 §3, khóa này thêm **bậc cuối cùng**:

```
zero-shot → few-shot → system instruction + CoT → ReAct/function calling
    → (vẫn chưa đạt) → SUPERVISED TUNING → (vẫn chưa đạt) → đổi model / đổi kiến trúc
```

Tune khi prompt tốt nhất vẫn thất bại **một cách ổn định, lặp lại** — vd: model không giữ được đúng khuôn đầu ra, không dùng đúng thuật ngữ chuyên ngành, giọng văn lệch dù đã cho nhiều ví dụ. Tune **không** phải cách nhét kiến thức mới vào model (muốn kiến thức mới thì dùng RAG/grounding — khóa "Inspect Rich Documents..." trong chương trình sẽ dạy; nối 129); tune dạy model **hành vi + định dạng + phong cách**.

### 5.2. Ba phương pháp tuning trên Vertex AI (tài liệu chính thức, 2026)

| Phương pháp | Cơ chế | Khi dùng |
|---|---|---|
| **Supervised fine-tuning (SFT)** | Cho model 100–500 ví dụ mẫu (cặp input → output đúng) dạng JSONL trên Cloud Storage; model học thêm tham số adapter để bắt chước hành vi mẫu | Task có đầu ra dễ định nghĩa: phân loại, trích xuất thực thể, tóm tắt đơn giản, truy vấn theo ngôn ngữ chuyên ngành, sinh code theo khuôn. Model hỗ trợ: Gemini 2.5 Pro / 2.5 Flash / 2.5 Flash-Lite, Gemini 2.0 Flash / 2.0 Flash-Lite |
| **Preference tuning** | Xây trên SFT, tune bằng **phản hồi của người** (cặp "đáp án được thích hơn / kém hơn") thay vì nhãn đúng/sai | Task chủ quan, khó định nghĩa nhãn: giọng văn, độ hữu ích, phong cách — những thứ SFT thuần không đo được |
| **Distillation tuning** | Dùng model lớn (teacher) sinh đáp án, rồi tune model nhỏ (student) bằng đáp án đó | Cần model nhỏ chạy nhanh/rẻ nhưng giữ được chất lượng task cụ thể; hiệu quả nhất khi teacher giỏi hơn student rõ rệt ở task đó |

### 5.3. Parameter-efficient tuning (adapter/LoRA) vs full fine-tuning

- **Parameter-efficient tuning (PEFT / adapter tuning):** chỉ cập nhật một tập con nhỏ tham số (adapter) của model, phần còn lại giữ nguyên. Đây là cách Gemini SFT chạy trên Vertex AI (tham số `adapter_size`: 1 / 4 / 8 / 16 — adapter càng lớn, học được càng nhiều, tốn càng nhiều compute). Ưu điểm: cần ít dữ liệu (100–500 ví dụ), rẻ, nhanh, ít nguy cơ "quên" kiến thức gốc.
- **Full fine-tuning:** cập nhật toàn bộ tham số — chất lượng tiềm năng cao hơn cho task rất phức tạp, nhưng tốn dữ liệu + compute hơn nhiều. Trên Vertex AI hiện dùng cho **open model** (Llama 3.1, Gemma...) qua LoRA hoặc full; với Gemini, SFT chuẩn là adapter-based.
- **Dữ liệu:** file JSONL trên Cloud Storage; nên có thêm tập validation (tối đa 256 ví dụ) để đo metric trong lúc tune; số epoch và learning rate Vertex AI tự chỉnh theo cỡ dữ liệu (có thể override bằng `epoch_count`, `learning_rate_multiplier`).
- **Đầu ra của tuning job:** một tuned model mới = model gốc + tham số adapter đã học; deploy như model thường qua endpoint.

### 5.4. Nối khóa 136 — tuning trong Studio là "tiền tố task" của phía Gemini

Khóa 136 §8.3 đã phân biệt: tiền tố task của T5 (`"summarize: ..."`) được **fine-tune cùng model** nên ổn định, lặp lại giống nhau; prompt zero-shot của Gemini dựa vào hiểu biết có sẵn nên linh hoạt nhưng dao động. **Supervised tuning trong Studio chính là cách mang tính ổn định của T5 sang phía Gemini:** sau khi tune bằng 100–500 ví dụ đúng khuôn, model Gemini đã "học thuộc" khuôn đó — prompt sau đó có thể ngắn lại (không cần nhồi ví dụ few-shot dài), đầu ra đúng khuôn và ổn định hơn, mà vẫn giữ được sức mạnh decoder-only (sinh text tự do, dùng kiến thức rộng). Nói ngắn gọn: **prompt = dạy bằng lời, tuning = dạy bằng ví dụ đã train vào trọng số** — và Studio cho làm cả hai trong cùng một chỗ, với cùng một model, không cần tự train như T5.

## 6. Từ Studio ra production — export code, quản lý prompt, deploy

### 6.1. Export code ("Get code" / "Build with code")

Mọi prompt đã chốt trong Studio đều export được thành code mẫu (Python, REST/cURL, Node.js...) qua nút **Get code** — code đó gọi đúng model + prompt + tham số đã test. Đây là cầu nối sang task 121: prompt thử trong Studio → export → dán vào `response_utils.py` của app Streamlit → deploy Cloud Run. Luồng chuẩn của cả 3 khóa gộp lại:

```
Studio (thử prompt, chốt tham số) → Get code → SDK google-genai (121 §2)
    → app Streamlit (121 §4–§5) → Cloud Run (121 §6)
```

### 6.2. Prompt management — prompt là tài sản có version

Tài liệu chính thức (Prompt Management, Prompt Sharing):

- Prompt lưu trong project GCP có **tên + version + ghi chú thay đổi**; xem lại danh sách version, khôi phục version cũ, chia sẻ cho teammate (Share → chọn người → Remove để thu hồi).
- Dùng được cả trong Studio lẫn SDK (`client.prompts.create` / `create_version` / `get` / `list` / `restore`).
- Hỗ trợ chuẩn doanh nghiệp: Customer-Managed Encryption Keys (CMEK), VPC Service Controls.
- **Lưu prompt cần bật billing** trên project (theo quickstart express mode) — thử prompt thì không cần, lưu thì cần. Đây là chi phí cần biết trước: Studio không phải lúc nào cũng "miễn phí hoàn toàn" ngoài Skills Boost lab.

### 6.3. Deploy tuned model

Tuned model deploy lên Vertex AI endpoint như model thường, rồi app gọi endpoint đó thay vì model gốc. Khóa chỉ dạy khái niệm deploy (không đi sâu MLOps — đó là khóa "MLOps for Generative AI" còn lại trong chương trình).

## 7. Vertex AI Studio khác gì gọi Gemini API trực tiếp (task 121)?

Đây là điểm dễ nhầm nhất của cả chương trình — **có tới hai "Studio" và hai "Gemini API"**. Bảng dưới đây theo tài liệu chính thức của Google ("Migrate from Google AI Studio to Vertex AI"):

| | **Gemini API qua Google AI Studio** (cửa miễn phí) | **Vertex AI — gồm Vertex AI Studio** (cửa doanh nghiệp) |
|---|---|---|
| Playground UI | **Google AI Studio** (aistudio.google.com) | **Vertex AI Studio / Agent Studio** (trong Cloud Console) |
| Endpoint | `generativelanguage.googleapis.com` | `aiplatform.googleapis.com` |
| Đăng ký | Tài khoản Google | Tài khoản Google Cloud + billing |
| Xác thực | API key (hoặc OAuth) | Service account / IAM (Application Default Credentials) |
| Free tier | **Có**, giới hạn tốc độ (rate-limited) | Không có free tier API; user mới được $300 credit GCP; lab Skills Boost dùng credit Starter 35/tháng |
| Model | Cùng họ Gemini | Cùng họ Gemini — **model giống nhau, giá mỗi token gần như giống nhau** |
| Dữ liệu (free tier) | Prompt có thể được dùng để cải thiện model | Prompt **không** dùng để train; có data residency, CMEK, VPC |
| SLA / hỗ trợ | Không có SLA doanh nghiệp | SLA 24/7, hỗ trợ enterprise |
| Tuân thủ | Không có chứng chỉ HIPAA/SOC2 | HIPAA, SOC2, Access Transparency |
| Tính năng riêng | Nhẹ, lấy key gọi ngay trong 1 phút | Tuning, evaluation, prompt management có version, deploy endpoint, Provisioned Throughput (capacity riêng), MLOps |
| Hợp cho | Prototype, demo, hobby, MVP | Production, dữ liệu nhạy cảm, team cần quản trị tập trung |

**Kết luận của Google (và của khóa): chọn theo hợp đồng vận hành, không chọn theo model.** Model hai cửa là một; khác nhau là xác thực, đường đi dữ liệu, quota, và ai ký hợp đồng.

### 7.1. Làm rõ về task 121 — "gọi Gemini API trực tiếp" ở đó thực ra là cửa nào?

Cần sửa một cách hiểu có thể lệch trong checklist task 138: **lab task 121 đã gọi Gemini qua cửa Vertex AI**, không phải qua API key miễn phí của AI Studio:

- Lab 121 dùng `genai.Client(vertexai=True, project=..., location="global")` và endpoint `https://{location}-aiplatform.googleapis.com/...` với `gcloud auth print-access-token` — đó chính là backend Vertex AI.
- Vì vậy quan hệ đúng giữa 121 và 138 là: **121 = gọi backend Vertex AI bằng code (SDK/cURL); 138 = dùng console Studio đặt trên cùng backend đó để thử prompt trước khi code.** Studio và SDK là hai mặt tiền của một backend, không phải hai hệ thống khác nhau. Luồng đúng: thử trong Studio → export code → chạy bằng SDK như 121.
- **Đường demo rẻ nhất cho team vẫn là Gemini API free tier qua AI Studio** (kết luận Fleet Console + 121 §8.3): khi chỉ cần demo nhanh cho Anh xem, API key miễn phí + Streamlit local là đủ, không cần project GCP + billing. Vertex AI Studio chỉ cần khi demo đó muốn đi tiếp thành production (cần tuning, version prompt, SLA, dữ liệu không dùng để train).

### 7.2. Quy tắc chọn nhanh cho team

- **Thử prompt / demo nhanh / học:** AI Studio + Gemini API free tier (không thẻ, không project GCP).
- **Chốt prompt + chia sẻ trong team + cần version:** Vertex AI Studio (prompt management, share, Get code).
- **Prompt không đủ, cần dạy hành vi ổn định:** tuning trong Vertex AI (SFT 100–500 ví dụ).
- **Production có dữ liệu nhạy cảm / cần SLA / audit:** Vertex AI end-to-end (IAM, VPC, endpoint, monitoring).

## 8. Áp dụng được ngay cho việc chung

1. **Luồng 3 khóa thành một quy trình chuẩn (120 → 138 → 121).** Viết prompt theo 120 → thử + chốt trong Studio theo 138 (free-form → structured → so sánh song song → lưu version) → export code → đóng app theo 121. *Áp dụng ngay:* lần tới team cần prompt mới cho tool (vd: prompt đọc trang web, prompt tóm tắt chương truyện), làm theo đúng thứ tự này thay vì viết prompt thẳng vào code rồi sửa code mỗi lần prompt sai.
2. **Prompt management = áp dụng PROTOCOL §8 cho prompt.** Task file JSON đã version công việc bằng git; prompt cũng cần version như vậy: lưu prompt có tên + ghi chú "vì sao đổi", khôi phục version cũ khi bản mới tệ hơn. *Áp dụng ngay:* mọi prompt dùng trong tool/script của team nên lưu thành file riêng có version (vd: `prompts/<tên>-v1.md` kèm tham số temperature/top-K/top-P) thay vì chôn trong code — đúng tinh thần "Get code" của Studio nhưng làm bằng git của team.
3. **So sánh song song trước khi chốt model.** Studio cho chạy Flash vs Pro cạnh nhau trên cùng prompt. *Áp dụng ngay:* khi chọn model cho một tool mới, test cùng prompt trên 2 model (Flash rẻ/nhanh vs Pro mạnh) rồi mới chốt — đừng mặc định dùng Pro cho mọi việc (tốn token) hay Flash cho mọi việc (thiếu chất lượng ở task khó).
4. **Thang leo thang đầy đủ, thêm bậc tuning (nối 120 §3 + 138 §5.1).** Thứ tự can thiệp khi output chưa đạt: sửa prompt → thêm ví dụ → thêm system instruction → CoT/ReAct → function calling → **tuning (100–500 ví dụ)** → đổi model. *Áp dụng ngay:* chỉ đề xuất tuning khi đã chứng minh prompt tốt nhất vẫn sai ổn định trên bộ test — tuning là bậc đắt nhất, không phải bậc đầu tiên.
5. **Tuning là phương án cho xử lý hàng loạt đúng khuôn (nối 136 §8.3).** Nếu team có task xử lý hàng loạt mô tả truyện theo mẫu cố định (vd: gắn nhãn thể loại, tóm tắt theo mẫu), phương án rẻ + ổn định là: SFT một Gemini Flash bằng 100–500 ví dụ đúng khuôn trong Studio, thay vì prompt model lớn mỗi lần. *Áp dụng ngay (đề xuất, cần task riêng + quyết của muse-main/Anh theo §10):* làm thử nghiệm nhỏ — tune Flash trên vài chục mô tả thật, so với prompt Gemini hiện tại, rồi mới quyết có đáng tune không.
6. **"Lưu prompt cần billing" — kiểm tra chi phí trước khi hứa hẹn.** Trong Vertex AI, thử prompt thì miễn phí trong giới hạn, nhưng lưu prompt cần project bật billing. *Áp dụng ngay:* khi đề xuất dùng Vertex AI Studio cho việc gì của team, ghi rõ bước nào tốn tiền (tuning, lưu prompt, gọi API ngoài free tier) — không để Anh tưởng mọi thứ trong Studio đều miễn phí như AI Studio.
7. **Express mode để thử không cần setup đầy đủ.** Vertex AI có "express mode" cho thử nhanh các tính năng Studio (xem prompt mẫu, tạo prompt, thiết kế chatbot + lấy code) mà không cần dựng hết hạ tầng GCP. *Áp dụng ngay:* nếu Anh/muse-main muốn xem thử Studio hoạt động ra sao trước khi quyết dùng, thử bằng express mode trước, không cần tạo project + billing ngay.

## 9. Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill research (hoặc mục mới trong skill chung) — thêm recipe "Luồng prompt 3 bước: Studio → SDK → app" (từ §2, §6.1, §7.1):** thử prompt trong Vertex AI Studio (hoặc AI Studio free tier cho demo nhanh) → chốt prompt + tham số → export code → đóng app bằng SDK `google-genai` theo mẫu task 121. Kèm quy tắc chọn cửa (§7.2): demo nhanh dùng AI Studio free tier; cần version/tuning/SLA mới sang Vertex AI.
2. **Skill research — thêm mục "Prompt là tài sản có version" (từ §6.2):** prompt dùng trong tool/script lưu thành file riêng có version + tham số (temperature/top-K/top-P) + ghi chú thay đổi, thay vì chôn trong code; khi prompt mới tệ hơn thì khôi phục version cũ.
3. **Skill `vbook-extension-building` — thêm mục "Thang leo thang có thêm bậc tuning" (từ §5.1):** khi output của model chưa đạt, sửa theo thứ tự prompt → ví dụ → system instruction → CoT/function calling → tuning (100–500 ví dụ) → đổi model; chỉ đề xuất tuning khi đã chứng minh prompt tốt nhất vẫn sai ổn định.
4. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc system instruction (PROTOCOL) / user prompt (task file) đã chốt ở task 120 vẫn đứng vững.

## 10. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa xem video gốc của khóa và chưa chạy lab:** nội dung khóa nằm sau trang Skills Boost (video + quiz + lab, cần đăng nhập tài khoản Google Cloud để học). Báo cáo này học qua mô tả chính thức của khóa + syllabus Class Central/Coursera + tài liệu chính thức của Google Cloud (Vertex AI Studio, Tuning API, Prompt Management, Migrate from AI Studio) + ghi chép lab của học viên. Các điểm trong syllabus khớp hoàn toàn với mô tả khóa; các số liệu tuning (100–500 ví dụ, adapter size, model hỗ trợ) đối chiếu trực tiếp với tài liệu Tuning API chính thức.
- **Lab "Get Started with Vertex AI Studio" chỉ xem walkthrough:** không chạy lab GCP (theo checklist — không tốn credit). Các bước lab §3.3 là tóm tắt từ ghi chép học viên đã hoàn thành; review gần đây trên trang lab báo lỗi model Imagen không khả dụng — **chưa xác định** là lỗi tạm thời hay lab chưa cập nhật; kiểm tra lại model khả dụng trước khi chạy lab.
- **Số liệu đăng ký/rating khác nhau giữa các nguồn:** Skills ghi 4.16/5 (16.971 reviews), Coursera ghi 4.6/5 (~249 reviews, ~30.000 học viên) — hai hệ thống chấm khác nhau, báo cáo ghi cả hai kèm nguồn, không gộp làm một.
- **Tên gọi đang trong đợt chuyển đổi:** tài liệu cũ dùng "Vertex AI / Vertex AI Studio", tài liệu mới dùng "Gemini Enterprise Agent Platform / Agent Studio" — cùng một nền tảng, khác tên; báo cáo ghi cả hai tên ở §1 để tránh nhầm khi đọc tài liệu cũ/mới.
- **Phần §5.2–§5.3 (chi tiết tuning: adapter size, preference tuning, distillation) lấy từ tài liệu Tuning API hiện tại**, đã kiểm chứng trên docs chính thức; khóa học chỉ dạy khái niệm tuning ở mức introductory — khi team thực sự chạy tuning job thì kiểm tra lại doc + quota/chi phí trước khi chốt.
- **Chưa xác định:** hiệu quả thực tế của SFT Gemini Flash trên mô tả truyện tiếng Trung (vBook) so với prompt Gemini hiện tại — cần thực nghiệm nhỏ (vài chục ví dụ thật) trước khi đề xuất thành task; cùng dạng "chưa xác định" đã ghi ở 134 §9/136 §10.

## Nguồn

- Trang khóa chính thức (Google Skills): https://www.cloudskillsboost.google/course_templates/552
- Trang khóa trên Coursera (cùng nội dung, 1 module, ~30.000 học viên): https://www.coursera.org/learn/introduction-to-generative-ai-studio
- Syllabus + giá 0 USD (Class Central): https://www.classcentral.com/course/introduction-to-generative-ai-studio-199885
- Đánh giá độc lập + tóm tắt nội dung (Cursarium, 06/2026): https://www.cursarium.net/courses/google-gen-ai-studio
- Tài liệu chính thức — Migrate from Google AI Studio to Vertex AI (bảng so sánh 2 cửa): https://docs.cloud.google.com/vertex-ai/generative-ai/docs/migrate/migrate-google-ai
- Tài liệu chính thức — Tuning API (SFT, adapter size, dataset 100–500 ví dụ): https://docs.cloud.google.com/vertex-ai/generative-ai/docs/model-reference/tuning
- Tài liệu chính thức — Introduction to tuning (PEFT vs full, preference tuning, model hỗ trợ): https://cloud.google.com/vertex-ai/generative-ai/docs/models/tune-models
- Tài liệu chính thức — Prompt management (version, share, CMEK/VPCSC): https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/prompt-classes
- Tài liệu chính thức — Save and share prompts (Vertex AI Studio): https://docs.cloud.google.com/vertex-ai/generative-ai/docs/prompt-sharing
- Tài liệu chính thức — Quickstart Vertex AI Studio (Prompt Gallery, Get code): https://cloud.google.com/vertex-ai/generative-ai/docs/start/quickstarts/quickstart
- Tài liệu chính thức — Tutorial Vertex AI Studio express mode (thử nhanh, lưu prompt cần billing): https://cloud.google.com/vertex-ai/generative-ai/docs/start/express-mode/vertex-ai-studio-express-mode-quickstart
- Walkthrough lab "Get Started with Vertex AI Studio" (Pradeep Gadde): https://pradeepgadde.com/blog/cloud/2024/04/30/gcp-vertex-ai.html
- Trang review lab (Skills, ghi nhận lỗi Imagen gần đây): https://www.skills.google/focuses/86502/reviews
- Báo cáo nối tiếp trong repo: `research/120-prompt-design-in-vertex-ai-google.md` (prompt design, thang leo thang, evaluation), `research/121-develop-gen-ai-apps-with-gemini-and-streamlit-google.md` (SDK + app Streamlit + Cloud Run — cửa Vertex AI bằng code), `research/136-encoder-decoder-architecture-google.md` (T5 tiền tố task vs prompt Gemini, §8.3), `research/129-vector-search-and-embeddings-google.md` (RAG — hướng còn lại khi tuning không phải đáp án), `research/CHEAT-SHEET-ATTENTION.md` (bản đồ 3 họ model).

## Kết luận

Khóa này ngắn (~2 giờ, introductory) và — như nhiều học viên nhận xét — nông nếu chỉ xét kiến thức model: nó không dạy thêm một khái niệm LLM mới nào sau 120/121/136. Giá trị của nó nằm ở chỗ khác: **nó cho team một quy trình làm việc trọn vẹn, đặt đúng tên cho từng bước** — use case → prototype trong Studio → prompt engineering → evaluate → tune (chỉ khi cần) → deploy — và một bản đồ rõ ràng về hai cửa vào Gemini (AI Studio miễn phí để thử/demo, Vertex AI để làm thật với tuning, version prompt, SLA và quản trị dữ liệu). Ba khóa 120–121–138 giờ đã nối thành một pipeline hoàn chỉnh: **viết prompt tốt (120) → thử và chốt prompt trong Studio, tune nếu cần (138) → đóng thành app bằng SDK (121)** — và điểm nối quan trọng nhất mà báo cáo này làm rõ là task 121 vốn đã gọi backend Vertex AI bằng code, nên Studio không phải một hệ thống mới mà là mặt tiền no-code của chính backend đó. Với team, thứ mang về được ngay là recipe "Studio → SDK → app", quy tắc prompt là tài sản có version, và phương án tuning Gemini Flash bằng 100–500 ví dụ cho các task xử lý hàng loạt cần đúng khuôn — rẻ và ổn định hơn prompt model lớn mỗi lần, nhưng chỉ đề xuất sau khi có thực nghiệm nhỏ chứng minh.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** **Responsible AI for Developers** (Fairness & Bias, Interpretability & Transparency, Privacy & Safety) — khóa tiếp theo trong chương trình 10 khóa, nối trực tiếp khóa này (sau khi biết tune/deploy thì phải biết làm sao cho an toàn và đo được thiên kiến — và nó cũng là phần còn thiếu sau khi 120 §10 chỉ chạm safety filter ở mức cấu hình). Sau đó còn lại trong chương trình: Inspect Rich Documents with Gemini Multimodality and Multimodal RAG, MLOps for Generative AI.
