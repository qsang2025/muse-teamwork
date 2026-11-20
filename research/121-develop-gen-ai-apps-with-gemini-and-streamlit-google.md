# Develop Gen AI Apps with Gemini and Streamlit (Google) — Báo cáo tự học (task 121)

- **Khóa học:** Develop Gen AI Apps with Gemini and Streamlit, Google Cloud Skills Boost (trình độ Intermediate, skill badge, thuộc chương trình Gemini Enterprise Agent Ready — GEAR)
- **Trang khóa:** Google Cloud Skills Boost, path 236, course_templates/978: https://www.skills.google/paths/236/course_templates/978
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 121). **Không chạy lab trên GCP** — các lab cần Google Cloud project + credit Skills Boost; báo cáo này học kỹ nội dung khóa qua trang khóa chính thức, toàn văn lab "Develop an App with the Gemini API in Gemini Enterprise Agent Platform" (cập nhật 06/11/2026), tài liệu Function Calling của Google Cloud, và ghi chép chi tiết của học viên đã hoàn thành cả 4 lab + challenge lab.
- **Quy mô khóa:** ~45 phút (thời lượng ghi trên trang khóa; học viên thực tế báo cáo ~30–40 phút chỉ riêng challenge lab vì bước build/deploy image chậm); 4 lab hướng dẫn + 1 challenge lab.
- **Mô hình dùng trong khóa (bản hiện tại):** Gemini 2.5 Flash (bản lab 2025 dùng Gemini 2.0 Flash; bản đời đầu dùng Gemini 1.5 Pro). Khóa được tái bản 24/08/2026 trong chương trình GEAR.
- **Phạm vi báo cáo:** học kỹ cả 5 phần của khóa (syllabus theo Class Central + toàn văn lab Streamlit/Cloud Run) + tài liệu Function Calling chính thức của Google Cloud. Nối tiếp task 120: khóa 120 dạy *viết prompt tốt*, khóa này dạy *đóng prompt đó thành ứng dụng thật* — đúng bước "từ Studio sang SDK rồi thành app" mà báo cáo 120 đã gợi ý.

## Cấu trúc khóa (syllabus)

1. **Getting Started with the Gemini API in Gemini Platform with cURL** — gọi Gemini API thô bằng REST.
2. **Introduction to Function Calling with Gemini** — model tự quyết định gọi hàm ngoài.
3. **Getting Started with Google Generative AI Using the Gen AI SDK** — SDK Python chính thức (`google-genai`).
4. **Deploy a Streamlit App with Gemini on Cloud Run** — xây app Streamlit 4 tab, container hóa, deploy Cloud Run (bản hiện tại là lab "Develop an App with the Gemini API in Gemini Enterprise Agent Platform", 13 task, cập nhật 06/11/2026).
5. **Challenge Lab (GSP517)** — app AI Chef cho Cymbal Health, tự làm không hướng dẫn từng bước, chấm tự động.

## 1. Gọi Gemini API thô bằng cURL — hiểu tầng thấp nhất trước khi dùng SDK

- **Endpoint (Vertex AI / Agent Platform):** `POST https://{location}-aiplatform.googleapis.com/v1/projects/{project}/locations/{location}/publishers/google/models/{model}:generateContent` (trả một khối) hoặc `:streamGenerateContent` (trả stream từng chunk). Lab dùng `streamGenerateContent` — và bộ chấm của challenge lab kiểm tra đúng chuỗi này trong notebook, nên dùng nhầm `generateContent` vẫn chạy nhưng không pass.
- **Xác thực:** access token lấy bằng `gcloud auth print-access-token`, gắn header `Authorization: Bearer $TOKEN`. Trong Cloud Shell, `gcloud auth list` cho biết tài khoản đang active; sai tài khoản = lỗi hoặc **tính phí nhầm project** — lab nhắc dùng đúng credentials của lab.
- **Thân request:** JSON `{"contents": [{"role": "user", "parts": [{"text": "..."}]}]}`; tham số nằm trong `generationConfig` (`temperature`, `maxOutputTokens`, `topP`, `topK`).
- **Bài học:** SDK chỉ là lớp bọc quanh REST này. Khi SDK báo lỗi khó hiểu, quay về cURL để xem response thô — cùng nguyên tắc debug như task 120 §7 (thử prompt ở Studio trước khi code): thử ở tầng thấp nhất trước, rồi mới leo lên tầng cao.

## 2. Gen AI SDK cho Python (`google-genai`) — cách khóa dạy viết app

- **Cài đặt:** `pip install google-genai` (cùng `streamlit`, `google-cloud-logging==3.6.0` trong `requirements.txt`). SDK mới thay SDK cũ `vertexai`: khác tên class và đường import — code mẫu cũ dùng `vertexai.generative_models.GenerativeModel` sẽ không chạy trên SDK mới.
- **Khởi tạo client (backend Vertex AI / Agent Platform):**
  ```python
  from google import genai
  from google.genai.types import HttpOptions

  client = genai.Client(
      vertexai=True,
      project=os.environ["GOOGLE_CLOUD_PROJECT"],
      location="global",
      http_options=HttpOptions(api_version="v1"),
  )
  ```
  Ba biến môi trường bắt buộc: `GOOGLE_CLOUD_PROJECT`, `GOOGLE_CLOUD_LOCATION` (lab dùng `global`), `GOOGLE_GENAI_USE_VERTEXAI=True`. Thiếu một biến là lỗi ngay từ lúc init, không phải lúc gọi model.
- **Sinh nội dung:** `client.models.generate_content(model="gemini-2.5-flash", contents=prompt, config=config)`; **streaming:** `client.models.generate_content_stream(...)` — duyệt từng `chunk.text`, nối lại; streaming là cách lab hiển thị phản hồi dài mà không bắt user chờ hết.
- **Cấu hình (`types.GenerateContentConfig`):** `temperature`, `max_output_tokens=4096`, `safety_settings` (4 danh mục HARM_CATEGORY_HARASSMENT / HATE_SPEECH / SEXUALLY_EXPLICIT / DANGEROUS_CONTENT, lab đặt `BLOCK_ONLY_HIGH` và nhắc chỉnh theo ngữ cảnh app — nối tiếp task 120 §10 về safety filter).
- **Multimodal:** `types.Part.from_uri(file_uri="gs://.../video.mp4", mime_type="video/mp4")` rồi truyền list `[prompt, part]` làm `contents`. Model nhận text + ảnh + video trong cùng một prompt.
- **Chat nhiều lượt:** SDK có `client.chats.create(...)` / `send_message` (kế thừa từ task 120 §7, khóa này không đi sâu — app trong lab là single-turn theo từng tab).
- **Quy tắc dùng SDK của khóa:** prompt + tham số chốt trước (đã học ở khóa 120) rồi mới viết code gọi SDK; code chỉ đóng gói prompt tốt, không sửa được prompt dở.

## 3. Function calling — model quyết định gọi hàm, app mới là người thực thi

Đây là phần mới hẳn so với task 120 (ở đó ReAct chỉ là khái niệm). Khóa này + tài liệu chính thức làm rõ cơ chế:

- **Luồng 4 bước:**
  1. Gửi prompt **kèm khai báo hàm** (tên, mô tả, tham số theo schema OpenAPI) cho model.
  2. Model tự quyết định có cần gọi hàm không; nếu cần, nó trả về **tên hàm + tham số dạng JSON có cấu trúc** — không phải câu trả lời cuối.
  3. **Ứng dụng của mình thực thi hàm** (gọi API thật, tra dữ liệu thật) rồi gửi kết quả lại cho model dưới dạng `FunctionResponse`.
  4. Model dùng kết quả đó để soạn câu trả lời cuối bằng ngôn ngữ tự nhiên.
- **Ví dụ kinh điển trong lab/tài liệu:** `get_current_weather(location: str)` — prompt "Thời tiết ở Boston thế nào?" → model trả `get_current_weather(location="Boston")` → app chạy hàm (trả về `'sunny'` trong lab mẫu) → model đáp "Trời nắng ở Boston".
- **Khai báo (SDK mới, tự động từ docstring):**
  ```python
  def get_current_weather(location: str) -> str:
      """Returns the current weather.
      Args:
          location: The city and state, e.g. San Francisco, CA
      """
      return 'sunny'

  response = client.models.generate_content(
      model="gemini-2.5-flash",
      contents="What is the weather in Boston, MA?",
      config=GenerateContentConfig(tools=[get_current_weather]),
  )
  ```
  Truyền thẳng hàm Python vào `tools=[...]` là đủ — SDK tự sinh schema từ tên hàm + docstring + type hints (automatic function calling). Cách cũ (SDK `vertexai`) phải khai báo tay `FunctionDeclaration` + gom vào `Tool(function_declarations=[...])`.
- **Chế độ ép buộc (`functionCallingConfig`):** `AUTO` (mặc định, model tự quyết), `ANY` (bắt buộc phải gọi một hàm trong danh sách), `NONE` (cấm gọi hàm). Dùng `ANY` khi bước đó bắt buộc phải tra dữ liệu; dùng `NONE` khi chỉ muốn model trả lời từ kiến thức có sẵn.
- **Giới hạn:** tối đa 512 `FunctionDeclaration` mỗi request; schema hàm theo chuẩn OpenAPI; model Gemini 3 Pro trở lên còn stream được tham số hàm khi đang sinh và nhận cả ảnh/PDF trong `FunctionResponse`.
- **Hai ca dùng chính (tài liệu):** **lấy dữ liệu** (thời tiết, tỉ giá, dữ liệu từ API/cơ sở tri thức — tức RAG) và **thực hiện hành động** (đặt lịch, gửi yêu cầu...). Đây chính là nền tảng của agent mà task 120 §3 nhắc tới.
- **Ranh giới quan trọng nhất:** model **không bao giờ** tự chạy hàm. Nó chỉ *đề xuất* lời gọi. Code của mình phải kiểm chứng tham số trước khi thực thi (vd: location có hợp lệ không, hàm có quyền gì) — nếu không, prompt injection có thể lừa model gọi hàm với tham số độc hại. Nối tiếp điểm 4 của task 119: không tin output chưa kiểm chứng — với function calling, output chưa kiểm chứng còn có thể *gây tác dụng phụ thật* (gọi API, ghi dữ liệu), nên kiểm chứng càng bắt buộc.

## 4. Streamlit — UI demo nhanh nhất cho app GenAI

- **Mô hình chạy:** Streamlit chạy lại toàn bộ script Python mỗi lần user tương tác (widget thay đổi → rerun). Vì vậy client Gemini phải cache bằng `@st.cache_resource`, nếu không mỗi lần bấm nút là tạo client mới.
- **Widget dùng trong lab:** `st.text_input` (tên nhân vật, tên sản phẩm), `st.radio` (độ dài truyện, mức sáng tạo, độ tuổi...), `st.multiselect` (tiền đề truyện, mục tiêu chiến dịch), `st.button` (kích hoạt sinh), `st.tabs` (chia tab Story / Marketing / Video / Image + tab con Response/Prompt), `st.spinner` (chờ model), `st.video` / `st.image` (hiển thị media đầu vào), `st.write` / `st.markdown` (hiển thị kết quả).
- **Mẫu "Prompt tab" của lab:** mỗi tab kết quả có 2 tab con — **Response** (đáp án) và **Prompt** (prompt thô đã gửi). Đây là thực hành tốt: user thấy được prompt nào sinh ra đáp án đó, debug prompt ngay trong UI thay vì đoán.
- **Ánh xạ lựa chọn UI → tham số model:** radio "Low/High" creativity → `temperature = 0.30 / 0.95` (Story tab); Marketing tab cố định `temperature=0.8`; các tab trích xuất video/ảnh cố định `temperature=0.1` (cần chính xác, không sáng tạo). Quy tắc: **temperature thấp cho trích xuất/sự thật, cao cho sáng tạo** — cùng kết luận với task 120 §2, nhưng ở đây nó thành code cụ thể.
- **Chạy local:** `streamlit run app.py --browser.serverAddress=localhost --server.enableCORS=false --server.enableXsrfProtection=false --server.port 8080`, xem qua Cloud Shell "Web preview → Preview on port 8080". Hai cờ CORS/XSRF là yêu cầu khi chạy trong Cloud Shell, không phải mặc định production.
- **Lưu ý thực hành trong lab:** sửa file `.py` nhiều lần mà UI không đổi → phải Ctrl-C dừng hẳn process Streamlit rồi chạy lại (cache/reload của Streamlit không phải lúc nào cũng bắt được thay đổi).

## 5. Kiến trúc app mẫu của lab — tách lớp model khỏi UI

App "Gemini API in Agent Platform" (13 task) có cấu trúc đáng học:

```
gemini-app/
├── app.py            # entry point: init client, tạo 4 tab, render từng tab
├── app_tab1.py       # Story — sinh truyện từ nhân vật + tiền đề + độ dài
├── app_tab2.py       # Marketing Campaign — sinh chiến dịch từ sản phẩm + đối tượng + ngân sách
├── app_tab3.py       # Video Playground — mô tả / highlight / geolocation video
├── app_tab4.py       # Image Playground — gợi ý nội thất / hướng dẫn lò nướng / sơ đồ ER / toán
├── response_utils.py # lớp gọi model duy nhất: get_gemini_response()
├── requirements.txt  # streamlit, google-genai, google-cloud-logging==3.6.0
└── Dockerfile
```

- **`response_utils.py` — một cửa duy nhất gọi model:** mọi tab đều gọi `get_gemini_response(client, prompt, config)`; hàm này gắn `safety_settings`, gọi `generate_content_stream`, nối các chunk thành chuỗi. Thêm tính năng (đếm token, log, retry khi 429) chỉ cần sửa một chỗ.
- **Prompt xây bằng f-string template từ input UI:** vd Story tab ghép `character_name/type/persona/location + length + premise` thành prompt có cấu trúc (prologue/chapters/epilogue, 1 chương nếu Short, 2 chương nếu Long). Đây chính là mẫu "prompt template có biến" của task 120 §4 — ở đây biến đến từ widget, không phải gõ tay.
- **Marketing tab:** prompt dài, có checklist nội dung bắt buộc (mô tả công ty, SMART goals, KPI, đối thủ, kênh, CTA...) + yêu cầu "bullet points, headlines, không dòng trống, súc tích" — ví dụ sống của "cụ thể về đầu ra" trong task 120 §4.
- **Video Playground (3 tab con):** mô tả video biển Địa Trung Hải ("Tôi đang nhìn gì? Nên đi đâu để thấy? 5 nơi giống nhất?"), highlight video Pixel 8 ("nghề của cô gái là gì? tính năng điện thoại nào được nhấn? tóm tắt 1 đoạn"), geolocation video xe buýt ("video nói về gì? sao biết là thành phố nào? đường nào? ngã tư gần nhất?"). Video lấy từ Cloud Storage bằng `gs://` URI.
- **Image Playground (4 tab con):** gợi ý ghế phù hợp phòng khách (5 ảnh: 1 phòng + 4 ghế, prompt dạng list nhiều part, yêu cầu trả về bảng + lý do), hướng dẫn reset đồng hồ lò nướng từ ảnh bảng điều khiển (model phải chỉ vị trí vật lý của nút), viết tài liệu từ sơ đồ ER, trích công thức toán từ ảnh + hỏi ký hiệu trước Pi + công thức có tên gì không. Đây là multimodal reasoning thực tế, không phải demo "mô tả ảnh này".

## 6. Container hóa và deploy lên Cloud Run

- **Dockerfile (lab):**
  ```dockerfile
  FROM python:3.10
  EXPOSE 8080
  WORKDIR /app
  COPY . ./
  RUN pip install -r requirements.txt
  ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]
  ```
- **Pipeline deploy:** tạo repo Artifact Registry (`gcloud artifacts repositories create ... --repository-format=Docker`) → build + push image (`gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME"`) → deploy (`gcloud run deploy "$SERVICE_NAME" --port=8080 --image=... --allow-unauthenticated --region=... --platform=managed --set-env-vars=GOOGLE_CLOUD_PROJECT=...,GOOGLE_CLOUD_LOCATION=...,GOOGLE_GENAI_USE_VERTEXAI=True`) → nhận URL public, test lại trên URL đó.
- **Vì sao Cloud Run hợp app demo:** serverless, scale về 0 khi không ai dùng (chỉ trả tiền khi có request), nhận container bất kỳ — app Streamlit không cần sửa gì ngoài cổng 8080 + `0.0.0.0`. Lưu ý: `--allow-unauthenticated` cho phép ai cũng mở URL — demo thì tiện, app thật phải gắn auth (IAP hoặc kiểm tra token).
- **Hai lỗi lab nhắc trước:** `429 RESOURCE_EXHAUSTED` (hết quota model) → chờ vài phút rồi bấm lại, không phải bug code; `400 Service agents are being provisioned` khi model đọc file `gs://` lần đầu → chờ service agent cấp quyền rồi thử lại.
- **Biến môi trường là cầu nối deploy:** cùng một image, đổi env là đổi project/region — không hard-code project ID trong code (lab dùng `os.environ`, và mọi lệnh deploy đều truyền env qua `--set-env-vars`).

## 7. Challenge Lab GSP517 — app AI Chef cho Cymbal Health (tổng hợp toàn khóa)

- **Tình huống:** Cymbal Health (mạng lưới y tế ở Minnesota) muốn app AI Chef gợi ý món ăn theo khẩu vị, kiêng kỵ, dị ứng, đồ có sẵn trong nhà.
- **5 task, không hướng dẫn từng bước, chấm tự động:**
  1. Dùng cURL test prompt với API (notebook `prompt.ipynb` trên Vertex AI Workbench, chạy trong JupyterLab).
  2. Hoàn thiện `chef.py` — app Streamlit mẫu lấy từ repo `GoogleCloudPlatform/generative-ai` (`gemini/sample-apps/gemini-streamlit-cloudrun`), thêm radio chọn vang `Red/White/None` + thay prompt theo đề bài, rồi upload lại lên GCS để bộ chấm kiểm tra.
  3. Test app local (venv + `pip install -r requirements.txt` + `streamlit run chef.py` cổng 8080).
  4. Sửa Dockerfile cho đúng `chef.py`, build image, push lên Artifact Registry.
  5. Deploy lên Cloud Run (`--allow-unauthenticated`, `--set-env-vars=GCP_PROJECT=...,GCP_REGION=...`) và test trên URL thật.
- **Bài học của challenge lab:** không có kỹ năng mới — chỉ kiểm tra có ráp được 4 lab trước thành một pipeline hoàn chỉnh không. Học viên báo cáo 30–40 phút, phần lớn thời gian chờ build image + deploy. Đây cũng là cách khóa "chấm" mà không chấm theo cảm giác: bộ chấm kiểm tra file đã upload, image đã push, service đã chạy — toàn tiêu chí đo được, đúng tinh thần task 120 §5 (đóng khung thành phân loại).

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc chung của team:

1. **Prompt template từ UI = mẫu viết checklist/task (§5, §4).** Lab xây prompt bằng f-string từ widget; task 120 đã chốt "viết checklist như viết prompt". Khóa này cho mẫu code cụ thể: template cố định + biến điền vào + yêu cầu định dạng đầu ra ngay trong template. *Áp dụng ngay:* khi viết tool/research cần input từ Anh (vd: chọn nguồn, chọn chế độ), trình bày dưới dạng form có lựa chọn rõ ràng rồi ghép thành prompt/template — thay vì hỏi tự do bằng câu chữ.
2. **Function calling: model chỉ đề xuất, app mới thực thi (§3).** Ranh giới này là quy tắc an toàn cho mọi agent/worker: worker (model) được đề xuất hành động, nhưng bước thực thi (gọi API, ghi file, deploy) phải qua code/người kiểm chứng tham số. *Áp dụng ngay:* khi thiết kế tool dùng model để quyết định gọi hàm (vd: worker tự chọn nguồn để test), bắt buộc có bước validate tham số trước khi chạy — không để model gọi thẳng.
3. **Streamlit + Gemini API free tier = đường demo rẻ nhất (§4, §6).** Nối tiếp kết luận Fleet Console (Gemini API free tier qua AI Studio, không cần thẻ): một demo cho Anh chỉ cần `app.py` + `response_utils.py` + Streamlit, chạy local hoặc Cloud Run scale-to-zero; không cần mua server, không cần frontend framework. *Áp dụng ngay:* khi muse-main cần demo kết quả research cho Anh xem trực tiếp (thay vì mô tả bằng chữ), đề xuất demo Streamlit theo đúng mẫu lab này.
4. **Tách lớp gọi model ra một file duy nhất (§5).** `response_utils.py` là một cửa gọi model cho cả app. *Áp dụng ngay:* mọi script/tool Python sau này của team mà gọi model thì gom lời gọi vào một module chung (config, safety, streaming, retry 429) thay vì mỗi file tự gọi — sửa một chỗ, hưởng cả tool.
5. **Ánh xạ lựa chọn của user thành số (§4).** Radio Low/High → temperature 0.30/0.95; trích xuất → 0.1. *Áp dụng ngay:* khi Anh chọn "sáng tạo" hay "chính xác", đừng hỏi lại bằng số — tự map lựa chọn chữ thành tham số số trong code, và ghi rõ mapping đó trong báo cáo để kiểm chứng được.
6. **"Prompt tab" — luôn cho xem prompt thô (§4).** Mỗi kết quả trong app lab đều kèm tab Prompt. *Áp dụng ngay:* báo cáo research/worker nên đính kèm prompt/template đã dùng (đã làm ở task 120 với whitepaper; giữ nếp này) — người đọc kiểm chứng được đầu vào, không chỉ tin đầu ra.
7. **429 và service-agent provisioning không phải bug (§6).** Lỗi quota thì chờ rồi thử lại; lần đầu đọc file `gs://` thì chờ cấp quyền. *Áp dụng ngay:* khi worker gặp 429 từ bất kỳ API nào, ghi rõ "hết quota, chờ thử lại" thay vì kết luận tool hỏng — và không retry dồn dập (đúng quy tắc rate limit của hệ thống).
8. **Cloud Run scale-to-zero là một đáp án cho bài toán "deploy demo ở đâu" (§6).** Team đang có lựa chọn Railway cho Buzz (Anh chọn 14/11, chưa xác nhận đã deploy). Cloud Run là phương án dự phòng cùng họ: container bất kỳ, scale về 0, chỉ trả khi có request, deploy bằng 3 lệnh. *Áp dụng ngay (đề xuất, không tự quyết):* nếu Railway gặp vướng, thử deploy Buzz/demo lên Cloud Run theo đúng recipe lab này (Dockerfile + Artifact Registry + `gcloud run deploy`) trước khi tìm hướng khác.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — thêm mục "Function calling: model chỉ đề xuất, app mới thực thi" (từ §3):** khi thiết kế bước nào để model quyết định gọi hàm/tool, bắt buộc có bước validate tham số trước khi thực thi; ghi rõ ranh giới này vì output chưa kiểm chứng có thể gây tác dụng phụ thật. Lý do: cùng nguyên tắc "không tin output chưa kiểm chứng live" của task 119, nhưng ở mức thực thi.
2. **Skill research (hoặc mục mới trong skill chung) — thêm recipe "Demo nhanh bằng Streamlit + Gemini API" (từ §4–§6):** mẫu 3 file tối thiểu (`app.py`, `response_utils.py`, `requirements.txt`: streamlit + google-genai) + Dockerfile + 3 lệnh deploy Cloud Run; dùng khi cần cho Anh xem thử kết quả research trực tiếp thay vì mô tả bằng chữ. Kèm 2 quy tắc: cache client bằng `@st.cache_resource`, và luôn có tab Prompt cho xem prompt thô.
3. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc system instruction (PROTOCOL) / user prompt (task file) đã chốt ở task 120 vẫn đứng vững.

## Khóa tiếp theo

- Theo phân vai §9/§10, muse-2 đã xong cả 4 khóa được giao: **Elements of AI (task 118)**, **Introduction to Generative AI (task 119)**, **Prompt Design in Vertex AI (task 120)**, **Develop Gen AI Apps with Gemini and Streamlit (task 121)**. Khóa 121 là khóa cuối trong gợi ý của báo cáo 120 — phân vai đã đi hết một vòng: khái niệm (118–119) → viết prompt (120) → đóng thành app (121).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): trong cùng chương trình GEAR, khóa **"Introduction to Image Generation"** (đã gợi ý từ task 120, mở rộng sang multimodal phía sinh ảnh — phần còn thiếu sau khi đã học sinh text + hiểu ảnh/video) hoặc **"Build Real World AI Applications with Gemini and Imagen"** nếu muốn đi tiếp hướng xây app thật với cả text + ảnh. Quyết định thuộc về muse-main theo PROTOCOL §10.

## Nguồn

- Trang khóa: Google Cloud Skills Boost, GEAR program, path 236, course_templates/978 (tái bản 24/08/2026): https://www.skills.google/paths/236/course_templates/978
- Syllabus 5 phần (Class Central, mirror trang khóa): https://www.classcentral.com/course/google-skills-develop-gen-ai-apps-with-gemini-and-streamlit-287708
- Toàn văn lab "Develop an App with the Gemini API in Gemini Enterprise Agent Platform" (13 task, cập nhật 06/11/2026): https://www.skills.google/focuses/86788
- Tài liệu Function Calling chính thức (Google Cloud, gồm giới hạn 512 declarations, các chế độ AUTO/ANY/NONE, mẫu `get_current_weather` bằng Gen AI SDK): https://docs.cloud.google.com/vertex-ai/generative-ai/docs/multimodal/function-calling
- Walkthrough challenge lab GSP517 — app AI Chef, Cymbal Health (Tanmay Bhujade, 23/04/2025): https://tanmaybhujade.medium.com/develop-genai-apps-with-gemini-and-streamlit-google-cloud-challenge-lab-walkthrough-4960a4305b0e
- Ghi chép học viên hoàn thành khóa (Siva Gangadhar Reddy; Adarsh Mourya): https://sivagangadharn.medium.com/exploring-gemini-and-streamlit-for-powerful-generative-ai-apps-784fb0a7cb77 ; https://adarsh-mourya.medium.com/building-genai-apps-with-gemini-and-streamlit-537f4e4b6727
- Repo mẫu app Streamlit + Gemini của Google (chef.py, Dockerfile): https://github.com/GoogleCloudPlatform/generative-ai (gemini/sample-apps/gemini-streamlit-cloudrun)
