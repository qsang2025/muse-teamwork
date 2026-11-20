# Build Real World AI Applications with Gemini and Imagen (Google) — Báo cáo tự học (task 126)

- **Khóa học:** Build Real World AI Applications with Gemini and Imagen, Google Cloud Skills Boost (skill badge, thuộc Gen AI Exchange Program; nay nằm trong chương trình Gemini Enterprise Agent Ready — GEAR)
- **Trang khóa:** Google Skills (skills.google): https://www.skills.google/course_templates/1076
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 126). **Không chạy lab trên GCP tốn credit** — học kỹ nội dung 4 lab qua trang khóa chính thức, bài walkthrough của học viên đã hoàn thành (DEV, Medium), và tài liệu gốc của Google (Vertex AI SDK migration guide, Gemini API / Firebase AI Logic migration guide, PyPI `google-genai`). Không đăng nhập làm lab (lab nằm sau đăng ký khóa trên Skills Boost).
- **Quy mô khóa:** ~1 giờ 15 phút, 4 lab (3 lab 15 phút + 1 challenge lab 30 phút), trình độ Introductory, miễn phí, hoàn thành nhận skill badge + 100 điểm leaderboard Gen AI Exchange.
- **Vị trí trong vòng tự học:** khóa 7 theo phân vai, khóa tiếp theo do chính Vịt gợi ý trong báo cáo 124 và muse-main quyết theo §10(a). Vòng tự học đã đi hết: khái niệm (118–119) → viết prompt (120) → đóng thành app Streamlit (121) → sinh ảnh (122) → mô tả ảnh (124). Khóa này là **nấc đóng vòng**: ghép cả text + ảnh vào **một app multimodal thật**, chạy trên Vertex AI / Agent Platform — nối tiếp trực tiếp task 121 (app) + 122 (sinh ảnh) + 124 (mô tả ảnh).

## Cấu trúc khóa (syllabus)

1. **Lab 1 — Build an AI Image Recognition App using Gemini on Vertex AI** (15 phút): upload ảnh, hỏi bằng text, Gemini trả lời — ảnh → text.
2. **Lab 2 — Build an AI Image Generator App using Imagen on Vertex AI** (15 phút): text → ảnh, model Imagen (`imagen-3.0-generate-002`).
3. **Lab 3 — Build an Application to Send Chat Prompts using Gemini** (15 phút): chat text với Gemini, streaming và non-streaming, quản lý session.
4. **Lab 4 — Build a Multi-Modal GenAI Application: Challenge Lab** (30 phút): ghép cả ba kỹ năng vào một app duy nhất — chat + nhận diện ảnh + sinh ảnh, theo kịch bản doanh nghiệp (công ty thiết kế hoa).

## 1. Lab 1 — Image Recognition App (Gemini)

### 1.1. Ý tưởng: một prompt có thể chứa cả ảnh lẫn chữ

Lab 1 dạy kỹ năng nền của cả khóa: **prompt multimodal** — đưa ảnh vào cùng câu hỏi text, model trả lời bằng text. Đây chính là chiều ảnh → text mà khóa 124 đã dạy ở mức lý thuyết (encoder-decoder, attention); ở đây nó thành code chạy được trong vài dòng, không cần train model nào.

- **Model trong lab:** Gemini Flash (`gemini-2.0-flash-001`) — bản nhanh, rẻ, đủ cho nhận diện ảnh.
- **Mẫu code theo khóa (Vertex AI SDK cũ):**
  ```python
  import vertexai
  from vertexai.generative_models import GenerativeModel, Part

  vertexai.init(project="PROJECT_ID", location="us-central1")
  model = GenerativeModel("gemini-2.0-flash-001")
  image_part = Part.from_uri(
      "gs://generativeai-downloads/images/scones.jpg", mime_type="image/jpeg")
  response = model.generate_content([image_part, "What is in this image?"])
  print(response.text)
  ```
- **Ba cách đưa ảnh vào prompt:** ảnh trên Cloud Storage (`Part.from_uri` với `gs://...`), ảnh local đọc thành bytes (`Part.from_data` / `Image.load_from_file`), hoặc URL công khai. Với ảnh lớn vài MB trở lên, để trên GCS là sạch nhất — SDK tái dùng file đã upload qua nhiều request, không đẩy bytes qua HTTP mỗi lần.

### 1.2. Vì sao lab này quan trọng

- **Một model, hai chiều dữ liệu:** cùng một Gemini vừa đọc ảnh (lab 1) vừa chat text (lab 3) vừa sinh ảnh (lab 2 qua Imagen). Người học không cần ba model ba SDK khác nhau — một khung prompt duy nhất xử lý mọi loại input.
- **Ứng dụng mà khóa nêu:** gắn tag sản phẩm tự động (ảnh sản phẩm → mô tả), hỗ trợ người khiếm thị (đọc mô tả ảnh), kiểm duyệt nội dung, phân tích ảnh giám sát. Tất cả đều là cùng một pattern: ảnh + câu hỏi → câu trả lời text.
- **Bài học nối sang khóa 124:** câu hỏi trong lab ("What's happening in this image?", "Describe all the objects") chính là **prompt xin caption** — và chất lượng caption trả về phụ thuộc vào câu hỏi, đúng như §1 báo cáo 124: caption không có đáp án duy nhất, hỏi khác thì mô tả khác.

## 2. Lab 2 — Image Generator App (Imagen)

### 2.1. Chiều ngược lại: text → ảnh

Lab 2 lật ngược lab 1: đưa prompt text vào, nhận ảnh ra. Model trong lab là Imagen (`imagen-3.0-generate-002`), model text-to-image chuyên biệt của Google.

- **Mẫu code theo khóa (Vertex AI SDK cũ):**
  ```python
  from vertexai.preview.vision_models import ImageGenerationModel

  model = ImageGenerationModel.from_pretrained("imagen-3.0-generate-002")
  images = model.generate_images(
      prompt="A robot sitting by a campfire in the mountains",
      number_of_images=1,
      aspect_ratio="1:1",
      seed=42,
  )
  images[0].save("robot-campfire.png")
  ```
- **Các tham số lab dạy chỉnh:** `number_of_images` (sinh nhiều ảnh một lúc), `aspect_ratio` (tỉ lệ khung hình), `seed` (tái lập được kết quả — cùng seed + cùng prompt cho cùng ảnh), `add_watermark` (đóng dấu SynthID), `safety_filter_level` và `person_generation` (kiểm soát nội dung nhạy cảm / sinh hình người).
- **Ví dụ trong lab:** "a cricket ground in the heart of Los Angeles" — prompt có chủ thể + bối cảnh rõ ràng, đúng template 4 thành phần của báo cáo 122 (chủ thể + style + ánh sáng + bố cục).

### 2.2. Bài học về tham số: seed là "version control" của ảnh sinh

- **Seed cố định → ảnh tái lập được.** Không có seed, mỗi lần chạy cùng prompt cho ảnh khác nhau — không debug được, không so sánh được hai prompt với nhau. Đặt seed là cách duy nhất để "chạy lại đúng kết quả cũ" khi sinh ảnh, tương tự như khóa 120 dạy đặt `temperature=0` để text tái lập được.
- **Watermark (SynthID) luôn bật mặc định trên Imagen** — ảnh sinh ra mang dấu chìm nhận diện được bằng máy, không nhìn thấy bằng mắt. Đây là khác biệt với Nano Banana (§5): khi migrate, quyền kiểm soát watermark không còn là tham số của mình nữa.

## 3. Lab 3 — Chat App (Gemini)

### 3.1. Chat là generate_content có nhớ

Lab 3 dạy điểm khác biệt duy nhất giữa "hỏi một câu" và "trò chuyện": **lịch sử hội thoại**. Một chat session giữ toàn bộ các lượt đã trao đổi và gửi kèm vào mỗi request mới, nên model nhớ ngữ cảnh.

- **Mẫu code theo khóa (Vertex AI SDK cũ):**
  ```python
  model = GenerativeModel("gemini-2.0-flash-001")
  chat = model.start_chat()

  # Non-streaming: gọi rồi chờ toàn bộ câu trả lời
  response = chat.send_message("Hello, what can you do?")
  print(response.text)

  # Streaming: nhận từng chunk khi model đang sinh
  for chunk in chat.send_message_stream("Tell me a story in 300 words."):
      print(chunk.text, end="")
  ```
- **Hai chế độ trả lời:**
  - **Non-streaming** (`send_message`): một request, một response đầy đủ. Đơn giản, hợp cho gọi API phía server, xử lý batch, hoặc khi cần toàn bộ câu trả lời trước khi làm bước tiếp theo (ví dụ: lấy caption rồi mới sinh ảnh từ caption đó).
  - **Streaming** (`send_message_stream`): response chảy về từng chunk ngay khi model sinh ra. Người dùng thấy chữ hiện dần thay vì chờ trắng màn hình — bắt buộc cho chatbot, trợ lý ảo, giao diện demo. Giá phải trả: code phức tạp hơn (vòng lặp nhận chunk, ghép text, xử lý ngắt giữa chừng).

### 3.2. Quản lý session — phần dễ sai nhất khi làm app thật

- **Một session = một cuộc trò chuyện.** Mỗi người dùng, mỗi chủ đề cần một `chat` object riêng; dùng chung session cho nhiều người là rò rỉ ngữ cảnh (người A thấy câu trả lời mang ngữ cảnh của người B).
- **Lịch sử dài → token dài → tốn tiền và chậm.** Mỗi lượt mới gửi kèm toàn bộ lịch sử cũ. App thật phải có chính sách cắt ngắn: giữ N lượt gần nhất, hoặc tóm tắt lịch sử cũ thành một đoạn rồi thay thế. Lab không dạy phần này — đây là khoảng trống giữa lab 15 phút và app production, và là lý do lab 4 chỉ dừng ở mức demo.
- **Bài học nối sang khóa 120:** system instruction (vai trò, định dạng đầu ra) đặt một lần lúc `start_chat` sẽ theo suốt session — đúng cấu trúc system instruction / user prompt mà báo cáo 120 đã chốt.

## 4. Lab 4 — Challenge Lab: Multi-Modal GenAI App

### 4.1. Kịch bản: công ty thiết kế hoa

Lab cuối là bài tập tổng hợp, không có hướng dẫn từng bước: một công ty thiết kế bó hoa cần hệ thống AI để khách mô tả kiểu hoa muốn đặt, nhận lại **ảnh bó hoa thực tế** kèm **lời chúc sinh nhật cá nhân hóa**. Học viên phải tự viết:

1. **Hàm 1 — sinh ảnh:** nhận mô tả bó hoa của khách → gọi Imagen → lưu ảnh ra file.
2. **Hàm 2 — phân tích + chúc mừng:** đọc ảnh vừa sinh bằng Gemini → sinh lời chúc sinh nhật khớp với bó hoa trong ảnh.
3. **Streaming output:** lời chúc trả về theo từng chunk, cho cảm giác tương tác thời gian thực.
4. **Kiểm thử toàn pipeline:** chạy end-to-end trong môi trường Vertex AI, xác nhận ảnh sinh ra khớp mô tả và lời chúc khớp ảnh.

### 4.2. Vì sao lab này là "app thật" còn 3 lab trước chỉ là "mẫu code"

- **Chaining (xâu chuỗi model):** đầu ra của model này là đầu vào của model kia — ảnh Imagen sinh ra được đưa lại vào Gemini để phân tích. Đây là pattern của mọi app GenAI production: không model nào làm hết mọi việc, app là đường ống nối các model lại. Lỗi ở khâu nào thì khâu sau lệch theo — ví dụ Imagen sinh sai loại hoa thì lời chúc của Gemini cũng sai theo, dù Gemini làm đúng nhiệm vụ của nó.
- **Hai chiều multimodal trong một app:** lab 4 chứa cả ảnh → text (phân tích bó hoa) và text → ảnh (sinh bó hoa) trong cùng một luồng người dùng. Đây đúng là vòng tròn khép kín mà báo cáo 124 §"Điều học được" mục 3 đã đề xuất cho demo của team: sinh ảnh từ prompt → mô tả ngược ảnh vừa sinh → so sánh caption với prompt gốc để kiểm tra ảnh có "nghe lời" không.
- **Bài học về kiểm thử:** challenge lab bắt test cả pipeline, không test từng hàm riêng. Một hàm đúng + một hàm đúng chưa chắc thành app đúng — điểm nối giữa hai hàm (file ảnh lưu ở đâu, Gemini đọc file nào, format nào) mới là chỗ hay hỏng. Đây là cùng một bài học với device test của team: chỉ tin kết quả chạy end-to-end trên môi trường thật.

## 5. Tình hình 2026 — hai thứ trong khóa đã cũ, khái niệm còn nguyên

Khóa gốc quay năm 2025 (các walkthrough tháng 4–5/2025), trang khóa trên skills.google tái xuất bản 31/08/2026 nhưng **tên khóa và nội dung lab vẫn giữ nguyên**. Đến 20/11/2026, hai thứ trong khóa đã đổi hẳn — và cả hai đều đã được báo cáo 122 ghi lại, nay xác nhận lại bằng tài liệu chính thức của Google:

### 5.1. Imagen đã nghỉ hưu — Lab 2 và nửa Lab 4 không chạy được như cũ

- **Lịch trình chính thức (Firebase AI Logic migration guide, Google):** mọi model Imagen deprecated, **shutdown từ 17/08/2026**, áp dụng trên cả Gemini Developer API lẫn Agent Platform Gemini API (tên cũ: Vertex AI). Trên Vertex AI, deprecation còn sớm hơn: 24/03/2026, hạn migrate trước 30/06/2026.
- **Model thay thế chính thức — họ Gemini Image, tên marketing "Nano Banana"** (bảng của Google, cập nhật 13/08/2026):

  | Model Imagen trong lab | Model thay thế |
  |---|---|
  | `imagen-3.0-generate-002` (lab 2) | `gemini-3.1-flash-image` |
  | `imagen-4.0-fast-generate-001` | `gemini-3.1-flash-image` (thinking `MINIMAL`) |
  | `imagen-4.0-generate-001` | `gemini-3.1-flash-image` (thinking `HIGH`) |
  | `imagen-4.0-ultra-generate-001` | `gemini-3-pro-image` |

- **Khác biệt cốt lõi (báo cáo 122 §6, vẫn đúng):** Nano Banana không phải model sinh ảnh chuyên biệt mà là **một model Gemini bình thường, trả về ảnh** — làm việc trong hội thoại: gửi prompt → nhận ảnh → nói tiếp "đổi màu giày, giữ nguyên mẫu" → nó sửa đúng chỗ đó, giữ nhân vật/phong cách ổn định qua nhiều lượt; ghép được nhiều ảnh đầu vào thành một ảnh. Imagen là one-shot: một prompt, một ảnh, không nhớ lượt trước.
- **Năm tham số Imagen không có tương đương trên Nano Banana:** negative prompt, số lượng ảnh, định dạng ảnh, điều khiển watermark, điều khiển sinh hình người — khi migrate code lab 2 phải rà lại 5 điểm này (đặc biệt `number_of_images` và `seed`: Nano Banana sinh một ảnh một lần gọi; muốn nhiều ảnh thì gọi nhiều lần).
- **Lưu ý thêm:** bản gốc `gemini-2.5-flash-image` (Nano Banana đời đầu) cũng đã có lịch shutdown (theo bảng deprecation của Google: 15/03/2027) — **không migrate lên model 2.5**, đi thẳng lên dòng 3.x (`gemini-3.1-flash-image` / `gemini-nano-banana-2.1` / `gemini-3-pro-image`).
- **Kết luận cho team:** lab 2 và hàm sinh ảnh của lab 4 phải đọc như **bài học về pattern** (prompt → tham số → ảnh → lưu file), không phải code chạy được. Mọi code sinh ảnh mới của team gọi họ Gemini Image, theo đúng quy tắc đã chốt ở báo cáo 122 mục 6.

### 5.2. Vertex AI SDK cũ đã bị gỡ — code lab 1, 3, 4 phải dịch sang SDK mới

- **Lịch trình chính thức (Google Cloud migration guide):** module Generative AI của Vertex AI SDK (`vertexai.generative_models`, `vertexai.language_models`, `vertexai.vision_models`, `vertexai.tuning`, `vertexai.caching`) deprecated 24/06/2025, **bị gỡ khỏi các bản SDK sau 24/06/2026**. Google chỉ định chuyển sang **Google Gen AI SDK** (`google-genai`) — cùng một SDK cho cả Gemini Developer API lẫn Vertex AI/Agent Platform.
- **Bảng dịch code lab sang SDK hiện hành** (team đã dùng SDK này từ task 121):

  | Code trong lab (Vertex AI SDK cũ) | Code hiện hành (`google-genai`) |
  |---|---|
  | `from vertexai.generative_models import GenerativeModel, Part` | `from google import genai` + `from google.genai import types` |
  | `vertexai.init(project=..., location=...)` + `GenerativeModel("gemini-2.0-flash-001")` | `client = genai.Client(vertexai=True, project=..., location=...)` (hoặc `api_key=...` cho Gemini API free tier) |
  | `model.generate_content([image_part, prompt])` | `client.models.generate_content(model="gemini-2.5-flash", contents=[prompt, types.Part.from_uri(...)])` |
  | `chat = model.start_chat()` + `chat.send_message(...)` | `chat = client.chats.create(model=...)` + `chat.send_message(...)` |
  | `chat.send_message_stream(...)` | `client.models.generate_content_stream(...)` |
  | `ImageGenerationModel.from_pretrained("imagen-3.0-generate-002")` | **không còn tương đương** — gọi Gemini Image qua `client.models.generate_content(model="gemini-3.1-flash-image", ...)` |

- **Điểm may mắn cho team:** task 121 đã chọn đúng SDK (`google-genai` + Streamlit + API key free tier) từ trước khi SDK cũ bị gỡ — demo app của team không dính nợ kỹ thuật này. Ai học theo code lab gốc mà copy nguyên `vertexai.generative_models` sẽ gặp lỗi import ngay trên SDK mới.

### 5.3. "Vertex AI" trong tên lab nay là "Agent Platform"

- Mô tả khóa trên skills.google hiện ghi: "deploying applications on the **Google Cloud Agent Platform**", và tài liệu migration của Firebase viết rõ "Agent Platform Gemini API (**formerly Vertex AI**)". Tên nền tảng đổi, nhưng pattern trong lab không đổi: cùng một client, cùng cách gọi model, chỉ khác tên gọi và cách cấu hình project/location. Khi đọc tài liệu Google 2026, "Vertex AI", "Agent Platform", "Gemini Enterprise" đều chỉ cùng một mặt sau — đừng tưởng là ba dịch vụ khác nhau.
- **Tên model trong lab cũng đã cũ:** lab dùng `gemini-2.0-flash-001` (đầu 2025). Dòng hiện hành là Gemini 2.5/3.x. Khi làm theo lab, thay model ID bằng bản hiện hành, giữ nguyên cấu trúc code.

## 6. Tự kiểm tra — các câu hỏi cốt lõi của khóa

Khóa có 1 challenge lab thay cho quiz cuối (đánh giá bằng "chạy được pipeline", không phải trắc nghiệm). Tự kiểm tra bằng các câu hỏi rút ra từ đúng nội dung 4 lab — trả lời được hết là nắm được khóa:

1. **Prompt multimodal gồm những gì?** — Một prompt có thể chứa cả ảnh (dạng `Part`) lẫn chữ; Gemini nhận cả hai và trả lời bằng text. Ảnh đưa vào bằng `Part.from_uri` (GCS), `Part.from_bytes` (file local) hoặc URL.
2. **Lab 1 và lab 2 là hai chiều nào của multimodal?** — Lab 1: ảnh → text (nhận diện/mô tả ảnh). Lab 2: text → ảnh (sinh ảnh). Hai chiều dùng chung một khung prompt, chỉ đổi loại input/output.
3. **`seed` trong sinh ảnh để làm gì?** — Cố định seed thì cùng prompt cho cùng ảnh — tái lập được kết quả, debug được, so sánh được hai prompt với nhau. Không có seed, mỗi lần chạy là một ảnh khác.
4. **Streaming khác non-streaming ở đâu, khi nào dùng cái nào?** — Streaming trả từng chunk ngay khi sinh, hợp cho chatbot/giao diện (người dùng thấy chữ hiện dần); non-streaming chờ toàn bộ response, hợp cho gọi phía server, xử lý batch, hoặc khi bước sau cần toàn bộ câu trả lời trước.
5. **Vì sao chat cần session riêng cho mỗi người dùng?** — Session giữ toàn bộ lịch sử; dùng chung session là rò rỉ ngữ cảnh giữa các người dùng. Lịch sử dài thì token dài, tốn tiền và chậm — app thật phải cắt ngắn hoặc tóm tắt lịch sử.
6. **Lab 4 nối các lab trước như thế nào?** — Hàm sinh ảnh (lab 2) → ảnh lưu file → hàm phân tích ảnh + sinh lời chúc (lab 1 + lab 3) → streaming trả về. Đầu ra model này là đầu vào model kia; lỗi khâu trước kéo lệch khâu sau.
7. **Imagen trong lab 2 nay thay bằng gì, khác gì?** — Imagen shutdown 17/08/2026; thay bằng họ Gemini Image / Nano Banana (`gemini-3.1-flash-image`, `gemini-3-pro-image`). Khác cốt lõi: Nano Banana là model Gemini trả về ảnh, làm việc trong hội thoại, giữ nhân vật ổn định qua nhiều lượt sửa; Imagen là one-shot. 5 tham số Imagen không có tương đương: negative prompt, số lượng ảnh, định dạng ảnh, watermark, sinh hình người.
8. **Code lab dùng SDK nào, nay phải viết lại ra sao?** — Lab dùng Vertex AI SDK cũ (`vertexai.generative_models`), đã bị gỡ sau 24/06/2026. Viết lại bằng Google Gen AI SDK (`google-genai`): `genai.Client(...)` + `client.models.generate_content` / `generate_content_stream` / `client.chats.create`. Team đã dùng SDK này từ task 121 nên không cần đổi gì.

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc chung của team:

1. **App multimodal là đường ống, không phải một model (§4.2).** Lab 4 chứng minh app thật = xâu chuỗi các model: sinh ảnh → phân tích ảnh → sinh text, đầu ra khâu này là đầu vào khâu kia. *Áp dụng ngay:* khi thiết kế demo cho Anh, vẽ đường ống trước, viết code sau — mỗi khâu một hàm, mỗi hàm test riêng, rồi mới test cả pipeline. Đây là cùng một nguyên tắc với build extension: lấy dữ liệu → xử lý → hiển thị, lỗi ở tầng nào sửa tầng đó (báo cáo 124 mục 5).
2. **Chaining hai chiều text↔ảnh đã có sẵn trong tay (§4.2, nối 122 + 124).** Khóa 122 cho recipe sinh ảnh, khóa 124 cho recipe mô tả ảnh, khóa này cho pattern nối hai recipe thành một app. Team đã có đủ ba mảnh: SDK `google-genai` + Streamlit + API key free tier (task 121). *Áp dụng ngay (đề xuất, không tự làm trong task này):* thêm tab "App multimodal" vào demo — nhập mô tả → sinh ảnh → mô tả ngược ảnh vừa sinh → so sánh caption với prompt gốc để kiểm tra ảnh có "nghe lời" không. Đây đúng là challenge lab 4, chỉ đổi kịch bản bó hoa thành avatar của Anh.
3. **Streaming là yêu cầu giao diện, không phải tính năng thêm (§3.1).** Lab 3 tách riêng streaming thành một kỹ năng vì chatbot không streaming thì người dùng chờ trắng màn hình. *Áp dụng ngay:* mọi demo chat/text cho Anh dùng `generate_content_stream` (SDK `google-genai` đã hỗ trợ sẵn), không dùng gọi chờ toàn bộ — đặc biệt khi câu trả lời dài (mô tả ảnh chi tiết, lời chúc, tóm tắt).
4. **Seed + temperature là hai núm "tái lập được" (§2.2, nối 120).** Text có `temperature=0`, ảnh có `seed` — cùng một nguyên tắc: khi cần so sánh, debug, demo lại đúng kết quả cũ thì khóa ngẫu nhiên lại; khi cần sáng tạo, mới mở ngẫu nhiên ra. *Áp dụng ngay:* mọi kết quả demo sinh ảnh/text cho Anh phải ghi kèm seed (ảnh) hoặc temperature (text) để lần sau chạy lại ra đúng kết quả đó — giống quy tắc "hai tham số phải ghi kèm mọi kết quả" của báo cáo 122.
5. **Đừng copy code lab cũ — dịch sang SDK hiện hành trước khi chạy (§5.2).** Code trong khóa dùng SDK đã bị gỡ (24/06/2026) và model đã shutdown (Imagen 17/08/2026). *Áp dụng ngay (nguyên tắc chung):* khi team lấy code mẫu từ bất kỳ khóa/tutorial nào trước 2026, kiểm tra ba thứ trước khi chạy — SDK còn sống không, model ID còn sống không, tham số còn tương đương không. Bảng dịch ở §5.2 là checklist 30 giây cho việc này.
6. **Tên nền tảng đổi không có nghĩa là dịch vụ đổi (§5.3).** "Vertex AI" → "Agent Platform" / "Gemini Enterprise" là đổi tên gọi, không đổi pattern gọi model. *Áp dụng ngay:* khi đọc tài liệu Google 2026, đừng tưởng ba tên là ba dịch vụ; và khi viết tài liệu cho team, ghi cả tên cũ lẫn tên mới một lần rồi dùng một tên thống nhất.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — không cần sửa:** khóa này không đụng tới build extension; không đề xuất thay đổi skill này.
2. **Skill research (hoặc mục mới trong skill chung) — thêm recipe "App multimodal: xâu chuỗi sinh ảnh + mô tả ảnh + chat qua SDK `google-genai`" (từ §4 + §5):** pattern 3 hàm của challenge lab 4 (sinh ảnh bằng Gemini Image → mô tả/phân tích ảnh bằng Gemini → chat/streaming trả về); bảng dịch code Vertex AI SDK cũ → `google-genai` (§5.2); bảng thay thế Imagen → Gemini Image (§5.1) kèm 5 tham số không tương đương; quy tắc ghi kèm seed/temperature với mọi kết quả demo; và quy tắc session riêng cho mỗi người dùng + cắt ngắn lịch sử chat. Lý do: đây là nấc cuối ghép ba recipe đã có (121 app, 122 sinh ảnh, 124 mô tả ảnh) thành một app hoàn chỉnh — và kịch bản challenge lab (mô tả → ảnh → lời chúc) đổi thành kịch bản của Anh (mô tả avatar → ảnh → mô tả ngược kiểm tra) là dùng được ngay.
3. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc system instruction (PROTOCOL) / user prompt (task file) đã chốt ở task 120 vẫn đứng vững.

## Khóa tiếp theo

- Theo phân vai §9/§10, muse-2 đã xong 7 khóa: **Elements of AI (task 118)**, **Introduction to Generative AI (task 119)**, **Prompt Design in Vertex AI (task 120)**, **Develop Gen AI Apps with Gemini and Streamlit (task 121)**, **Introduction to Image Generation (task 122)**, **Create Image Captioning Models (task 124)**, **Build Real World AI Applications with Gemini and Imagen (task 126)**. Vòng tự học đã đi hết: khái niệm (118–119) → viết prompt (120) → đóng thành app (121) → sinh ảnh (122) → mô tả ảnh (124) → ghép thành app multimodal thật (126).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): vòng GenAI 10 khóa của Google đã gần hết các khóa khớp vai research; hướng đi tiếp có thể là (a) khóa còn lại trong chương trình 10 khóa GenAI chưa học, (b) quay lại **thực hành**: triển khai tab "App multimodal" trong demo Streamlit theo recipe §"Điều học được" mục 2 (cần task build riêng, không phải task tự học), hoặc (c) chuyển sang khóa AI Agents / LangGraph như muse-1 đang học (task 125, 127) nếu muốn nối tiếp hướng agent. Quyết định thuộc về muse-main theo PROTOCOL §10.

## Nguồn

- Trang khóa (Google Skills, course_templates/1076, tái xuất bản 31/08/2026): https://www.skills.google/course_templates/1076
- Class Central (syllabus + mô tả): https://www.classcentral.com/course/google-skills-build-real-world-ai-applications-with-gemini-and-imagen-296540
- Walkthrough 4 lab (DEV, 30/04/2025): http://dev.to/sk_rahemurrahaman_2a9058/build-real-world-ai-applications-with-gemini-and-imagen-on-vertex-ai-google-cloud-tutorial-2cc8
- Walkthrough 4 lab, model ID chi tiết (Medium, Manish Gupta, 30/04/2025): https://manish-gupta.medium.com/%EF%B8%8F-building-real-world-ai-applications-with-gemini-and-imagen-4ac3117009ac
- Walkthrough (Medium, Krish Patel, 13/05/2025): https://krishpatelai.medium.com/building-real-world-ai-applications-with-gemini-and-imagen-my-journey-with-google-cloud-and-8c7e71f6804d
- Imagen nghỉ hưu, bảng thay thế Nano Banana (Firebase AI Logic migration guide, Google): https://firebase.google.com/docs/ai-logic/imagen-models-migration
- Tình hình Imagen 2026, 5 tham số không tương đương, giá: https://www.ud.hk/en-US/resources/ai/image-model-after-imagen-2026-08-17 ; https://invideo.io/blog/imagen-ai-image-generator/
- Vertex AI SDK migration guide — module Generative AI bị gỡ 24/06/2026, chuyển sang Google Gen AI SDK: https://cloud.google.com/vertex-ai/generative-ai/docs/deprecations/genai-vertexai-sdk
- Google Gen AI SDK (`google-genai`, PyPI) — `Client`, `generate_content`, `generate_content_stream`, `Part.from_uri/from_bytes`: https://pypi.org/project/google-genai/
- Vertex AI Gemini Python hiện hành với `google-genai` (streaming, vision, chat): https://computingforgeeks.com/vertex-ai-gemini-python-streaming-tool-use/
