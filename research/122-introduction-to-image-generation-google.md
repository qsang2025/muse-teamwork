# Introduction to Image Generation (Google) — Báo cáo tự học (task 122)

- **Khóa học:** Introduction to Image Generation, Google Cloud (microlearning course, thuộc Generative AI learning path — journey 118 trên Google Cloud Skills Boost; cùng khóa có mặt trên Coursera)
- **Trang khóa:** Google Cloud Skills Boost, journey 118: https://www.cloudskillsboost.google/journeys/118 ; Coursera: https://www.coursera.org/learn/introduction-to-image-generation
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 122). **Không chạy lab trên GCP** — khóa này không có lab thực hành tốn credit, chỉ có 1 video + 1 quiz; báo cáo học kỹ nội dung video (bài giảng của Kyle Steckler, Machine Learning Engineer, Google Cloud Advanced Solutions Lab) qua trang khóa chính thức, ghi chép đầy đủ của học viên đã học, và tài liệu gốc của các paper mà khóa dựa vào (DDPM 2020, Latent Diffusion 2022, Imagen 2022). Không đăng nhập làm quiz (quiz nằm sau đăng ký khóa).
- **Quy mô khóa:** ~1 giờ (ghi trên trang khóa); video chính 9 phút + quiz; 1 module duy nhất, trình độ Beginner, không yêu cầu kinh nghiệm trước.
- **Vị trí trong vòng tự học:** khóa 5 theo phân vai. Nối tiếp task 121: khóa 118–119 dạy khái niệm GenAI, khóa 120 dạy *viết prompt cho text*, khóa 121 dạy *đóng prompt thành app* — khóa này mở rộng sang multimodal phía **sinh ảnh** (diffusion models), phần còn thiếu sau khi đã học sinh text, viết prompt và đóng thành app. Đây đúng là khóa Vịt gợi ý trong báo cáo 120 và 121, muse-main quyết theo §10(a).
- **Phạm vi báo cáo:** toàn bộ 4 phần của video (§1–§4 dưới đây) + đào sâu kỹ thuật ở mức vừa đủ để dùng được (công thức forward/reverse, DDPM, latent diffusion, guidance) + cập nhật tình hình 2026 (Imagen đã nghỉ hưu, thay bằng họ Gemini Image) vì khóa gốc quay năm 2023 và nhiều tên model trong khóa nay đã đổi.

## Cấu trúc khóa (syllabus)

1. **Overview — các họ mô hình sinh ảnh:** VAE, GAN, autoregressive, diffusion.
2. **Diffusion models — bối cảnh và use case:** nguồn gốc vật lý, unconditioned vs conditioned.
3. **How diffusion models work:** forward process (thêm nhiễu), reverse process (học khử nhiễu), sinh ảnh từ nhiễu thuần.
4. **Recent advances and applications:** sinh nhanh hơn, điều khiển tốt hơn, kết hợp LLM → text-to-image (Imagen), deploy trên Vertex AI.

## 1. Bốn họ mô hình sinh ảnh — vì sao diffusion thắng

Khóa mở đầu bằng cách đặt diffusion vào bản đồ các họ mô hình sinh ảnh, để thấy nó không phải lựa chọn duy nhất mà là lựa chọn thắng ở thời điểm hiện tại:

| Họ mô hình | Cách sinh ảnh | Điểm yếu khiến diffusion vượt qua |
|---|---|---|
| **Variational Autoencoders (VAE)** | Encode ảnh về không gian nén, decode lại; sinh bằng cách sample từ phân phối đã học | Ảnh sinh thường mờ, thiếu chi tiết sắc nét |
| **Generative Adversarial Networks (GAN)** | Generator sinh ảnh, discriminator phân biệt thật/giả; hai mạng đấu nhau cùng tiến bộ | Huấn luyện không ổn định (mode collapse, khó cân bằng hai mạng); chính GAN là công nghệ đứng sau deepfake |
| **Autoregressive** | Coi ảnh là chuỗi pixel, sinh từng pixel dựa trên pixel trước đó (học theo cách LLM xử lý text) | Sinh tuần tự nên chậm; khó giữ cấu trúc toàn cục của ảnh |
| **Diffusion models** | Thêm nhiễu dần dần rồi học cách khử nhiễu ngược lại (§3) | Huấn luyện ổn định, chất lượng cao, mở rộng tốt theo dữ liệu và compute — và đó là lý do nó thành chuẩn mực từ 2020 |

- **Bài học của bảng này:** chọn họ mô hình là chọn đánh đổi giữa *chất lượng*, *ổn định huấn luyện* và *tốc độ sinh*. Diffusion thắng ở hai cột đầu, thua ở tốc độ — và toàn bộ các cải tiến sau 2020 (§5) chủ yếu là đi vá cột tốc độ.
- **Nối tiếp task 119:** khóa 119 đã giới thiệu GenAI phân biệt với ML truyền thống; khóa này cho thấy cùng một ý tưởng "học phân phối dữ liệu rồi sample từ đó" nhưng áp dụng cho ảnh, và diffusion là cách thực hiện thành công nhất tính đến nay.

## 2. Diffusion models — bối cảnh

- **Nguồn gốc:** lấy cảm hứng từ vật lý, cụ thể là nhiệt động lực học (thermodynamics) — quá trình khuếch tán: một giọt mực loang dần trong nước cho đến khi mất hết cấu trúc, và quá trình ngược lại (từ hỗn loạn về có cấu trúc) nếu học được sẽ sinh ra dữ liệu mới.
- **Lịch sử:** ý tưởng diffusion probabilistic models do Sohl-Dickstein và cộng sự đề xuất năm 2015, nhưng tiềm năng không được nhận ra ngay. Đến 2020, paper **DDPM — Denoising Diffusion Probabilistic Models (Ho, Jain & Abbeel, NeurIPS 2020)** chứng minh diffusion sinh ảnh chất lượng ngang GAN (FID 3.17 trên CIFAR-10 không điều kiện), và từ đó diffusion trở nên phổ biến cả trong nghiên cứu lẫn công nghiệp.
- **Vị thế hiện tại:** diffusion là nền tảng của hầu hết các hệ sinh ảnh state-of-the-art và các công cụ sinh ảnh trên Google Cloud — câu khẳng định mở đầu của khóa, và vẫn đúng năm 2026: Stable Diffusion, DALL·E 2, Imagen và cả diffusion transformer trong Sora đều cùng một khung DDPM.

## 3. Diffusion hoạt động như thế nào — phần lõi của khóa

Đây là phần khóa dành nhiều thời lượng nhất, và cũng là phần đáng học nhất. Toàn bộ quá trình gồm hai chiều ngược nhau:

### 3.1. Forward diffusion process — phá cấu trúc một cách có hệ thống

- Lấy một ảnh thật, **thêm nhiễu Gaussian từng chút một, qua nhiều bước**, cho đến khi ảnh chỉ còn là nhiễu thuần, không còn cấu trúc nào của ảnh gốc.
- Mỗi bước chỉ phụ thuộc bước ngay trước nó — một **chuỗi Markov**: phân phối Q ở bước t chỉ phụ thuộc bước t−1.
- Trong paper gốc, **T = 1000 bước** để đi từ ảnh thật tới nhiễu thuần. Lịch phương sai (variance schedule) tuyến tính, β tăng từ 10⁻⁴ lên 0.02.
- **Điểm quan trọng mà khóa nhấn mạnh:** forward process **không cần học** — nó là một công thức toán cố định. Nhờ tính chất Gaussian, có thể nhảy thẳng từ ảnh gốc tới bất kỳ mức nhiễu t nào trong một phép tính, không cần mô phỏng từng bước trung gian: x_t = √(ᾱ_t)·x₀ + √(1−ᾱ_t)·ε, với ε là nhiễu Gaussian chuẩn. Chính nhờ đó việc huấn luyện mới rẻ: mỗi lần train chỉ cần lấy một ảnh, chọn ngẫu nhiên một bước t, thêm nhiễu, rồi hỏi mạng "nhiễu vừa thêm là gì".

### 3.2. Reverse diffusion process — học cách khử nhiễu

- Huấn luyện một mạng nơ-ron (thường là **U-Net**: co ảnh qua nhiều lớp rồi mở lại, có shortcut giữa các lớp tương ứng để giữ cả hình dáng thô lẫn chi tiết nhỏ; bước t được đưa vào mạng qua embedding để mạng biết input đang nhiễu cỡ nào) để **dự đoán phần nhiễu đã thêm ở mỗi bước**.
- Input: ảnh nhiễu + số bước t. Output: dự đoán nhiễu. Hàm loss: sai số bình phương (MSE) giữa nhiễu dự đoán và nhiễu thật — đơn giản đến mức ngạc nhiên so với độ phức tạp của bài toán.
- Phát hiện then chốt của DDPM: **dự đoán chính phần nhiễu** (thay vì dự đoán ảnh sạch trực tiếp) cho kết quả tốt nhất. Đây là quyết định thiết kế làm nên tên gọi "Denoising Diffusion".
- Mô hình này có tên đầy đủ **DDPM — Denoising Diffusion Probabilistic Models**.

### 3.3. Sinh ảnh — đi ngược từ nhiễu thuần về ảnh mới

- Lấy **nhiễu thuần** (không có ảnh gốc nào cả), đưa qua model đã train.
- Mỗi vòng lặp: model dự đoán nhiễu đang có, **trừ phần nhiễu đó đi**, được ảnh bớt nhiễu hơn một chút; lặp lại ~1000 lần (bản gốc) cho tới ảnh hoàn chỉnh.
- Vì model đã học phân phối dữ liệu thật của ảnh, ảnh sinh ra là ảnh **mới, chưa từng có trong tập train**, nhưng tuân theo cùng phân phối — tức là "giống thật" theo đúng nghĩa thống kê.
- **Hiểu bằng một câu:** diffusion không "vẽ" ảnh; nó học cách **dọn nhiễu**, và sinh ảnh bằng cách dọn nhiễu từ một đống nhiễu thuần cho tới khi hiện ra ảnh.

## 4. Use case — unconditioned và conditioned

Khóa phân biệt hai nhóm ứng dụng, và sự phân biệt này chính là ranh giới giữa "sinh ảnh chơi" và "sinh ảnh làm việc được":

### 4.1. Unconditioned diffusion models — sinh không cần gợi ý

- **Sinh ảnh mới theo một chủ đề:** train trên tập ảnh cùng chủ đề (ví dụ: khuôn mặt người) rồi sinh ra khuôn mặt mới chưa từng tồn tại. Đây là bài toán gốc của DDPM (CIFAR-10, CelebA-HQ).
- **Super-resolution:** học phân phối ảnh chất lượng cao rồi áp lên ảnh chất lượng thấp để nâng cấp — vì model biết "ảnh đẹp trông như thế nào" nên nó điền được chi tiết còn thiếu.

### 4.2. Conditioned generation — sinh theo điều kiện cho trước

Đây mới là phần tạo ra sản phẩm thật, và là phần nối trực tiếp sang công việc của team:

- **Text-to-image:** điều kiện là câu prompt text — model sinh ảnh khớp với mô tả. Đây là use case nổi tiếng nhất (DALL·E, Imagen, Stable Diffusion).
- **Inpainting:** điều kiện là phần ảnh còn nguyên — model điền phần thiếu/hỏng sao cho khớp với phần còn lại.
- **Text-guided image-to-image editing:** điều kiện là cả ảnh gốc + prompt text — giữ ảnh gốc, sửa theo yêu cầu bằng chữ ("đổi màu áo", "thêm nền hoàng hôn"). Đây chính là cơ chế đứng sau mọi công cụ "edit ảnh bằng câu lệnh" mà Anh dùng khi làm avatar.

## 5. Các cải tiến sau DDPM — những gì khóa chỉ nhắc tên, báo cáo đào sâu

Khóa nhắc ngắn gọn "sinh nhanh hơn, điều khiển tốt hơn, kết hợp LLM". Ba cải tiến dưới đây là phần nội dung thực sự làm diffusion dùng được trong sản phẩm — học viên tự đối chiếu với tài liệu gốc để ghi rõ:

### 5.1. Latent diffusion — diffusion không chạy trên pixel nữa (Rombach và cộng sự, 2022)

- **Vấn đề:** DDPM gốc khuếch tán trên từng pixel (ảnh 512×512×3), huấn luyện và sinh đều đắt.
- **Cách giải:** dùng VAE nén ảnh về **không gian latent nhỏ hơn nhiều lần**, chạy diffusion trong không gian đó, rồi decode trở lại thành ảnh. Đây là kiến trúc của **Stable Diffusion** — lý do nó chạy được trên máy cá nhân và bùng nổ hệ sinh thái mở tháng 08/2022.
- **Bài học:** khi một phương pháp đúng nhưng đắt, đừng đổi phương pháp — hãy đổi **không gian làm việc** của nó.

### 5.2. Sinh nhanh hơn — DDIM và giảm số bước

- **Vấn đề:** DDPM gốc cần đủ 1000 bước, tức 1000 lượt chạy mạng cho một ảnh.
- **Cách giải (DDIM, Song và cộng sự, 2021):** quá trình reverse không nhất thiết phải đi đúng quỹ đạo Markov của DDPM; xây một quá trình reverse phi-Markov cho phép **bỏ qua bước**, sinh ảnh tốt chỉ trong **20–50 bước** thay vì 1000, mà vẫn dùng đúng model đã train bằng DDPM.
- **Bài học:** huấn luyện và lấy mẫu là hai việc tách rời — train đắt một lần, sample có thể tối ưu riêng sau đó.

### 5.3. Điều khiển tốt hơn — classifier-free guidance (Ho & Salimans, 2022)

- **Vấn đề:** model có điều kiện (text-to-image) cần vừa "khớp prompt" vừa "đa dạng, tự nhiên" — hai mục tiêu giằng nhau.
- **Cách giải:** trong lúc train, thỉnh thoảng bỏ điều kiện text đi để model học cả hai chế độ (có điều kiện / không điều kiện). Lúc sinh, trộn hai dự đoán theo một hệ số **guidance scale**: scale cao → ảnh bám sát prompt hơn nhưng kém đa dạng; scale thấp → đa dạng hơn nhưng có thể lệch prompt.
- **Áp dụng ngay cho Anh:** tham số "guidance/CFG scale" trong mọi công cụ sinh ảnh chính là hệ số này. Khi ảnh sinh ra "không nghe lời" prompt, tăng guidance; khi ảnh bị "đơ, lặp mẫu", giảm guidance — thay vì đổi prompt lung tung.

### 5.4. Kết hợp LLM — Imagen (Saharia và cộng sự, Google Research, 2022)

- **Kiến trúc:** một **text encoder lớn (mô hình ngôn ngữ, họ T5)** hiểu prompt + **một chuỗi (cascade) các diffusion model**: model đầu sinh ảnh nhỏ (64×64), các model sau phóng to dần (256×256 → 1024×1024) bằng super-resolution diffusion.
- **Phát hiện quan trọng của paper Imagen:** tăng kích thước **text encoder** cải thiện độ khớp prompt và chất lượng ảnh nhiều hơn là tăng kích thước bản thân diffusion model. Nói cách khác, "hiểu chữ tốt" quan trọng hơn "vẽ giỏi" — và điều này nối thẳng sang khóa 120: chất lượng prompt (phần text) quyết định chất lượng ảnh.
- **Tên gọi:** ghi chép của học viên viết "Imogen" — đó là lỗi chính tả của "Imagen", model text-to-image của Google Research.

## 6. Train và deploy trên Vertex AI — theo khóa, và tình hình 2026

- **Theo khóa (2023):** học lý thuyết xong thì train và deploy diffusion model trên **Vertex AI** — nền tảng managed của Google Cloud để build với foundation model. Khóa không có lab thực hành, chỉ giới thiệu hướng này.
- **Tình hình 2026 — đã đổi nhiều, cần cập nhật khi dùng:** (tổng hợp từ thông báo của Google và các bài tổng hợp độc lập, truy cập 20/11/2026)
  - **Imagen đã nghỉ hưu trên Gemini API:** Google thông báo ngừng (deprecation) ngày 15/06/2026, **shutdown ngày 17/08/2026** cho cả ba endpoint Imagen 4 (`imagen-4.0-generate-001`, `-ultra`, `-fast`) trên Gemini API; trên Vertex AI (nay gọi là Gemini Enterprise Agent Platform) thông báo còn sớm hơn (03/2026, hạn cập nhật trước 30/06/2026).
  - **Model thay thế chính thức: họ Gemini Image, tên marketing "Nano Banana".** Google chỉ định `gemini-3.1-flash-image` thay cho Imagen 4 / 4 Fast / Imagen 3, và `gemini-3-pro-image` thay cho Imagen 4 Ultra. Bản gốc `gemini-2.5-flash-image` (Nano Banana đời đầu) cũng có lịch shutdown tháng 10/2026 — **không migrate lên model 2.5**.
  - **Khác biệt cốt lõi so với Imagen:** Nano Banana không phải model sinh ảnh chuyên biệt mà là **một model Gemini bình thường, trả về ảnh** — nghĩa là nó làm việc trong hội thoại: gửi prompt → nhận ảnh → nói tiếp "đổi màu giày, giữ nguyên mẫu" → nó sửa đúng chỗ đó và giữ nhân vật/phong cách ổn định qua nhiều lượt; ghép được nhiều ảnh đầu vào thành một ảnh. Imagen là one-shot: một prompt, một ảnh, không nhớ lượt trước.
  - **Giá tham khảo (báo cáo bởi các bài tổng hợp độc lập, kiểm tra lại trước khi dùng):** Imagen 4 Fast ~$0.02/ảnh, Imagen 4 ~$0.04, Nano Banana đời đầu ~$0.039/ảnh (1.290 output token × $30/1M token), Nano Banana 2 ~$0.0672, Nano Banana Pro ~$0.134 — chênh ~7× giữa rẻ nhất và đắt nhất, vì trả cho hai việc khác nhau.
  - **Quy tắc chọn nhanh (đúc kết từ các roundup 2026):** *tạo mới hàng loạt* → họ Imagen (lúc còn sống) / nay là Nano Banana 2 với thinking thấp; *sửa ảnh đã có, giữ nhân vật ổn định qua nhiều lượt* → Nano Banana. Năm tham số của Imagen **không có** tương đương trên Nano Banana: negative prompt, số lượng ảnh, định dạng ảnh, điều khiển watermark, điều khiển sinh hình người — khi migrate prompt cũ phải rà lại 5 điểm này.
  - **Kết luận cho team:** lý thuyết diffusion trong khóa vẫn nguyên giá trị (Nano Banana vẫn chạy trên khung diffusion), nhưng **tên model, endpoint và tham số trong khóa đã cũ**. Mọi code/hướng dẫn mới về sinh ảnh của team phải gọi họ Gemini Image (`gemini-3.1-flash-image` / `gemini-3-pro-image`), không gọi Imagen nữa.

## 7. Tự kiểm tra — các câu hỏi cốt lõi của quiz khóa

Khóa có 1 quiz sau video. Học viên không đăng nhập làm quiz (nằm sau đăng ký), nên tự kiểm tra bằng các câu hỏi rút ra từ đúng nội dung video — trả lời được hết các câu này là nắm được khóa:

1. **Forward process làm gì, có cần học không?** — Thêm nhiễu Gaussian từng bước theo chuỗi Markov cho tới nhiễu thuần; không cần học, là công thức cố định.
2. **Reverse process học cái gì?** — Học dự đoán phần nhiễu đã thêm ở mỗi bước; loss là MSE giữa nhiễu dự đoán và nhiễu thật (DDPM).
3. **Sinh ảnh mới bắt đầu từ đâu?** — Từ nhiễu thuần, trừ dần nhiễu dự đoán qua từng bước cho tới ảnh hoàn chỉnh.
4. **Unconditioned khác conditioned ở đâu?** — Unconditioned sinh theo chủ đề đã train (mặt người, super-resolution); conditioned sinh theo điều kiện ngoài (text, phần ảnh còn lại, ảnh + text).
5. **Vì sao kết hợp LLM giúp text-to-image tốt lên?** — Text encoder lớn hiểu prompt sâu hơn; paper Imagen chứng minh tăng text encoder hiệu quả hơn tăng diffusion model.
6. **Diffusion khác GAN ở điểm nào?** — GAN đấu generator/discriminator, huấn luyện không ổn định; diffusion học khử nhiễu, ổn định và mở rộng tốt hơn.

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc chung của team:

1. **Hiểu đúng công cụ avatar của Anh (§3–§4).** Anh làm avatar bằng AI: chọn ảnh gốc → đổi pose/biểu cảm/phong cách. Đó chính là **text-guided image-to-image editing + inpainting** của diffusion: model giữ phần ảnh gốc (điều kiện) và sửa theo prompt. Hiểu cơ chế này giải thích hai kinh nghiệm thực tế của Anh: (a) giữ khuôn mặt ổn định qua nhiều lần sửa khó vì mỗi lần sinh là một chuỗi khử nhiễu mới từ nhiễu khác nhau — muốn giữ nhân vật phải dùng model có **reference-image conditioning** (đúng điểm mạnh của Nano Banana: giữ nhân vật ổn định qua nhiều lượt hội thoại); (b) video generation bị 403 trên tài khoản này (ghi trong MEMORY 15/11) là giới hạn tài khoản, không liên quan tới diffusion — sinh ảnh tĩnh qua Gemini API free tier là đường khác, không bị chặn theo cùng cách.
2. **Prompt cho ảnh khác prompt cho text — cần cấu trúc riêng (§5.4, nối task 120).** Task 120 dạy viết prompt text (rõ ràng, có vai trò, có định dạng đầu ra). Prompt ảnh cần thêm 4 thành phần mà prompt text không có: **chủ thể + phong cách (style) + ánh sáng + bố cục/góc máy**, và dùng **negative prompt** để loại thứ không muốn (khi model còn hỗ trợ — lưu ý Nano Banana đã bỏ negative prompt, §6). *Áp dụng ngay:* khi viết prompt sinh ảnh cho Anh (avatar, thumbnail, ảnh minh họa demo), dùng template 4 thành phần này thay vì viết một câu mô tả tự do.
3. **Guidance scale là núm chỉnh "nghe lời" (§5.3).** Khi ảnh sinh lệch prompt thì tăng guidance, khi ảnh đơ/lặp mẫu thì giảm — đừng đổi prompt lung tung. *Áp dụng ngay:* ghi rõ guidance scale kèm prompt trong mọi báo cáo/demo sinh ảnh, để người khác tái tạo được kết quả (cùng tinh thần "tab Prompt" của task 121).
4. **Seed + số bước là hai tham số tái tạo (§3.3, §5.2).** Cùng prompt + cùng seed → cùng ảnh; tăng số bước khử nhiễu → ảnh chi tiết hơn nhưng chậm hơn (DDIM cho phép 20–50 bước thay vì 1000). *Áp dụng ngay:* demo nào sinh ảnh cũng ghi seed và số bước, giống như task 121 ghi temperature và max_output_tokens.
5. **Mở rộng demo Streamlit của task 121 thêm tab sinh ảnh (§6).** App demo task 121 đã có sẵn khung: SDK `google-genai` + Streamlit + Cloud Run. Thêm một tab gọi model ảnh Gemini (`gemini-3.1-flash-image`) bằng cùng client đó — không cần thêm hạ tầng, không cần Vertex AI project, dùng được Gemini API free tier qua AI Studio (Anh đã có 10 project AI Studio, mỗi project 1 API key). *Áp dụng ngay (đề xuất, không tự làm trong task này):* khi muse-main cần demo sinh/sửa ảnh cho Anh xem trực tiếp, đề xuất thêm tab ảnh vào app task 121 theo đúng mẫu này, thay vì mô tả bằng chữ.
6. **Đừng gọi Imagen trong code mới (§6).** Mọi hướng dẫn/code sinh ảnh viết từ nay phải dùng họ Gemini Image (`gemini-3.1-flash-image`, `gemini-3-pro-image`); tài liệu cũ nhắc Imagen (kể cả khóa này) chỉ còn giá trị lý thuyết. *Áp dụng ngay:* rà lại các ghi chép cũ của team, chỗ nào còn ghi "dùng Imagen" thì cập nhật thành model thay thế + ghi chú 5 tham số không còn tương đương.
7. **Latent diffusion là bài học về "đổi không gian, không đổi phương pháp" (§5.1).** Khi một cách làm đúng nhưng đắt, hãy nén không gian làm việc rồi làm tiếp trong đó. *Áp dụng ngay (nguyên tắc chung):* khi worker gặp site nặng (font encryption, JS-rendered — các task 098/099), thay vì đổi hẳn hướng, thử nén/bỏ bớt phần không cần thiết của bài toán trước (vd: chỉ lấy đúng field cần, bỏ render toàn trang).

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — không cần sửa:** khóa này không đụng tới build extension; không đề xuất thay đổi skill này.
2. **Skill research (hoặc mục mới trong skill chung) — thêm recipe "Sinh/sửa ảnh bằng Gemini Image qua SDK `google-genai`" (từ §5–§6):** model ID hiện hành (`gemini-3.1-flash-image` / `gemini-3-pro-image`, thay Imagen đã nghỉ hưu 17/08/2026); template prompt ảnh 4 thành phần (chủ thể + style + ánh sáng + bố cục); hai tham số phải ghi kèm mọi kết quả (seed, guidance scale); quy tắc chọn nhanh (tạo mới hàng loạt → Flash, sửa/giữ nhân vật → Pro hoặc Flash Image trong hội thoại); và 5 tham số Imagen không còn tương đương khi migrate. Lý do: team đã có recipe demo text (task 121), recipe này là nửa còn lại của multimodal — và Anh trực tiếp dùng sinh ảnh cho avatar, nên recipe này phục vụ việc thật của Anh, không chỉ là kiến thức.
3. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc system instruction (PROTOCOL) / user prompt (task file) đã chốt ở task 120 vẫn đứng vững.

## Khóa tiếp theo

- Theo phân vai §9/§10, muse-2 đã xong cả 5 khóa được giao: **Elements of AI (task 118)**, **Introduction to Generative AI (task 119)**, **Prompt Design in Vertex AI (task 120)**, **Develop Gen AI Apps with Gemini and Streamlit (task 121)**, **Introduction to Image Generation (task 122)**. Vòng tự học đã đi hết: khái niệm (118–119) → viết prompt (120) → đóng thành app (121) → sinh ảnh (122).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): trong cùng chương trình 10 khóa GenAI của Google, khóa còn lại khớp nhất với vòng này là **"Create Image Captioning Models"** — chiều ngược lại của khóa 122 (ảnh → text, thay vì text → ảnh), hoàn thiện vòng multimodal hai chiều; hoặc **"Build Real World AI Applications with Gemini and Imagen"** nếu muốn đi tiếp hướng xây app thật với cả text + ảnh (lưu ý: phần Imagen trong tên khóa đã cũ theo §6, cần đối chiếu model thay thế khi học). Quyết định thuộc về muse-main theo PROTOCOL §10.

## Nguồn

- Trang khóa (Google Cloud Skills Boost, journey 118, Generative AI learning path): https://www.cloudskillsboost.google/journeys/118
- Trang khóa (Coursera, 1 module, ~1 giờ, 198 reviews, 4.5/5): https://www.coursera.org/learn/introduction-to-image-generation
- Ghi chép đầy đủ video bài giảng Kyle Steckler (forward/reverse process, DDPM, use case, Imagen): https://bandyopadhyayarchi.wixsite.com/home/post/introduction-to-image-generation-with-diffusion-models
- Tóm tắt bài giảng (AI Nuggetz): https://ainuggetz.beehiiv.com/p/googles-introduction-ai-image-generation
- Tổng hợp 10 khóa GenAI miễn phí của Google (video 9 phút + quiz cho khóa này): https://www.eharvard.org/Google-free-Gen-AI-Courses.pdf
- DDPM — Ho, Jain & Abbeel, NeurIPS 2020 (T=1000, β 10⁻⁴→0.02, U-Net dự đoán nhiễu, FID 3.17 trên CIFAR-10): https://www.scaler.com/topics/diffusion-models/ ; https://computervisiononline.com/explains/ddpm-paper/
- Toán diffusion, latent diffusion, DDIM, classifier-free guidance: https://AI.INFO/deep-dives/diffusion-models-mathematics ; https://ai.zenoagi.com/ml/case-studies/diffusion
- Tình hình 2026 — Imagen nghỉ hưu 17/08/2026, thay bằng họ Gemini Image (Nano Banana), bảng giá và 5 tham số không tương đương: https://prompt-architects.com/blog/149-imagen-is-retired-migrating-your-prompts-to-nano-banana ; https://www.ud.hk/en-US/resources/ai/image-model-after-imagen-2026-08-17 ; https://dev.to/rajdhokai/why-is-googles-best-image-model-called-nano-banana-and-why-are-you-using-the-wrong-one-h08 ; https://drpranayjha.com/vertex-ai-multimodal-veo-imagen-lyria/
