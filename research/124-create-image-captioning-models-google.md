# Create Image Captioning Models (Google) — Báo cáo tự học (task 124)

- **Khóa học:** Create Image Captioning Models, Google Cloud (microlearning course, thuộc Generative AI learning path trên Google Cloud Skills Boost; cùng khóa có mặt trên Coursera, và là Module 4 của chuyên ngành "Google Cloud Generative AI Fundamentals for Developer")
- **Trang khóa:** Google Cloud Skills Boost: https://www.cloudskillsboost.google/course_templates/542 ; Coursera: https://www.coursera.org/learn/create-image-captioning-models
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 124). **Không chạy lab trên GCP** — khóa này là microlearning, chỉ có video + quiz, không có lab thực hành tốn credit; báo cáo học kỹ nội dung video qua trang khóa chính thức, giáo trình chuyên ngành của Google Cloud, và tài liệu gốc của các paper mà khóa dựa vào (Show and Tell 2015, Show Attend and Tell 2015). Không đăng nhập làm quiz (quiz nằm sau đăng ký khóa).
- **Quy mô khóa:** 30 phút (ghi trên Skills Boost; bản Coursera ghi 1 giờ), 1 module duy nhất, trình độ Intermediate (Skills Boost; bản Coursera ghi Advanced), 2.872 học viên đã đăng ký trên Coursera, rating 4.08/5 (177 reviews, Skills Boost; cập nhật lần cuối 3 tháng trước, xuất bản 14/08/2026).
- **Vị trí trong vòng tự học:** khóa 6 theo phân vai. Đây đúng là khóa Vịt gợi ý trong báo cáo 122 và muse-main quyết theo §10(a): khóa 122 dạy **sinh ảnh** (text → ảnh), khóa này dạy chiều ngược lại **mô tả ảnh** (ảnh → text), hoàn thiện vòng multimodal hai chiều sau khi đã học sinh text (118–119), viết prompt (120), đóng thành app (121) và sinh ảnh (122).
- **Phạm vi báo cáo:** toàn bộ nội dung khóa (encoder, decoder, attention, train, evaluate, sinh caption) + đào sâu kỹ thuật ở mức vừa đủ để dùng được (Show and Tell, attention, các metric đánh giá, beam search) + cập nhật tình hình 2026 (CNN–LSTM cổ điển đã nhường chỗ cho vision-language model, COCO đã bão hòa) vì khóa gốc dạy kiến trúc 2015 và nhiều thực hành trong khóa nay đã có cách làm mới rẻ hơn.

## Cấu trúc khóa (syllabus)

1. **Bài toán image captioning:** từ ảnh sinh ra câu mô tả bằng ngôn ngữ tự nhiên.
2. **Các thành phần của model:** encoder (CNN) + decoder (RNN/LSTM) — kiến trúc encoder-decoder.
3. **Attention:** giúp decoder tập trung vào đúng vùng ảnh khi sinh từng từ.
4. **Chuẩn bị dữ liệu:** tiền xử lý ảnh và text, tạo training sequence, tokenize.
5. **Train và evaluate:** huấn luyện end-to-end, đo bằng BLEU và các metric caption.
6. **Sinh caption:** dùng model đã train để mô tả ảnh mới.

## 1. Bài toán image captioning — khó hơn classification một bậc

- **Đầu vào / đầu ra:** đầu vào là một ảnh, đầu ra là **một câu hoàn chỉnh** mô tả nội dung ảnh ("a man riding a bicycle on a street"), không phải một nhãn duy nhất.
- **Vì sao khó hơn classification:** model phải làm hai việc cùng lúc — **hiểu ảnh** (nhận ra vật thể, thuộc tính, quan hệ giữa chúng, hành động đang diễn ra) và **sinh ngôn ngữ** (xếp từ thành câu đúng ngữ pháp, đúng thứ tự, không thừa không thiếu). Một câu mô tả phải nói được *vật gì, đang làm gì, ở đâu, liên quan với nhau ra sao* — classification chỉ cần trả lời "có vật gì".
- **Một ảnh có nhiều caption đúng:** cùng một ảnh bếp có thể mô tả là "a person slicing vegetables", "hands chopping herbs", hay "overhead shot of meal prep" — không có đáp án duy nhất. Hệ quả trực tiếp: dataset caption luôn có **5 caption tham chiếu trở lên cho mỗi ảnh**, và mọi metric đánh giá đều phải đo **độ đồng thuận** với nhiều tham chiếu (§5), chứ không chấm đúng/sai như classification.
- **Ứng dụng mà khóa nêu:** hỗ trợ người khiếm thị (đọc mô tả ảnh), mô tả sản phẩm tự động, tìm kiếm ảnh bằng câu chữ, kiểm duyệt nội dung (nhận diện nội dung không phù hợp vượt ra ngoài text).

## 2. Kiến trúc encoder-decoder — lõi của khóa

Khóa dạy captioning như một bài toán **sequence-to-sequence** (dịch từ ngôn ngữ ảnh sang ngôn ngữ text), mượn thẳng khung encoder-decoder của dịch máy (Sutskever và cộng sự, 2014) rồi thay encoder text bằng CNN. Đây chính là paper **Show and Tell** (Vinyals, Toshev, Bengio & Erhan, Google — arXiv 11/2014, CVPR 2015), nền tảng mà khóa dựa vào:

### 2.1. Encoder — CNN biến ảnh thành vector

- **Vai trò:** nén toàn bộ ảnh thành một vector đặc trưng có độ dài cố định, tóm tắt "ảnh này có gì".
- **Cách làm (transfer learning):** dùng một CNN đã train sẵn trên ImageNet (trong paper gốc là GoogLeNet; các bài thực hành sau này dùng Inception, VGG16, ResNet) **bỏ đầu classification**, chỉ giữ các lớp tích chập để trích đặc trưng. Trọng số CNN khởi tạo từ pretrain, chỉ fine-tune lớp cuối cùng trong lúc train caption.
- **Điểm mấu chốt:** encoder **không học từ đầu** — nó tái dùng kiến thức thị giác đã học từ hàng triệu ảnh ImageNet. Không có transfer learning thì dataset caption (vài chục nghìn ảnh) không đủ để dạy một CNN nhìn ảnh từ con số 0.

### 2.2. Decoder — LSTM sinh câu từng từ một

- **Vai trò:** nhận vector ảnh từ encoder rồi sinh caption **từng từ một**, từ nào cũng phụ thuộc vào các từ đã sinh trước đó.
- **Cơ chế (paper Show and Tell):** một LSTM, unroll theo câu S = (S₀, …, S_N) với S₀ là token bắt đầu và S_N là token kết thúc. Bước đầu tiên đưa vector ảnh vào LSTM (x₋₁ = CNN(I)); mỗi bước sau đưa embedding của từ vừa sinh vào (x_t = W_e·S_t); mỗi bước LSTM cho ra phân phối xác suất trên toàn bộ từ vựng, lấy từ có xác suất cao nhất làm từ tiếp theo.
- **Vì sao dùng LSTM mà không phải RNN thường:** LSTM có cổng nhớ (gate) giữ được phụ thuộc xa — câu dài vẫn nhớ chủ ngữ ở đầu câu khi sinh tới cuối câu; RNN thường bị vanishing gradient, quên nhanh.
- **Bài học của kiến trúc này:** captioning là **dịch máy với ảnh thay cho câu nguồn**. Ai hiểu encoder-decoder của dịch máy (khóa 118–120 đã học) thì hiểu ngay captioning — chỉ đổi encoder từ RNN text sang CNN ảnh.

### 2.3. Điểm yếu của bản gốc — nút cổ chai vector đơn

- Toàn bộ ảnh bị nén vào **một vector cố định duy nhất**, rồi decoder phải sinh cả câu từ vector đó. Ảnh càng nhiều chi tiết, vector càng phải gánh nhiều — thông tin bị mất ở cổ chai này, đặc biệt khi caption dài hoặc ảnh có nhiều vật thể.
- Paper đã cải thiện bằng cách cho LSTM "nhìn lại" ảnh, nhưng bản gốc vẫn chỉ nhìn một vector tổng. Khắc phục triệt để điểm này chính là attention (§3).

## 3. Attention — decoder nhìn đúng chỗ khi sinh từng từ

Đây là phần khóa dành nhiều thời lượng nhất sau encoder-decoder, dựa trên paper **Show, Attend and Tell** (Xu và cộng sự, arXiv 02/2015):

- **Ý tưởng:** thay vì nén ảnh thành một vector, encoder giữ lại **một tập vector theo vị trí không gian** — mỗi vector tương ứng một vùng của ảnh (ví dụ: ảnh 224×224 qua ResNet-101 cho feature map 14×14 = 196 vector, mỗi vector ứng với một ô 16×16 của ảnh gốc). Khi sinh mỗi từ, decoder tính **trọng số attention** cho từng vùng, rồi lấy trung bình có trọng số làm "ngữ cảnh thị giác" cho từ đó.
- **Ví dụ trực quan:** sinh từ "dog" → attention dồn vào vùng có con chó; sinh từ "running" → attention dồn vào chân và nền đường; sinh từ "beach" → attention dồn vào vùng cát và biển. Trọng số attention có thể vẽ thành heatmap lên ảnh — nhìn vào đó biết model đang "nhìn đâu" khi nói từ nào.
- **Soft attention vs hard attention (hai biến thể trong paper):**
  - **Soft attention (deterministic):** trọng số là phân phối softmax trên mọi vùng, lấy trung bình có trọng số — **khả vi toàn bộ**, train được bằng backpropagation thường. Đây là bản khóa dạy và bản dùng trong thực hành.
  - **Hard attention (stochastic):** mỗi bước chỉ chọn **một** vùng duy nhất để nhìn (lấy mẫu theo phân phối attention) — cần train bằng reinforcement learning, phức tạp hơn, ít dùng trong thực hành nhưng cho heatmap sắc nét hơn.
- **Kết quả:** attention cải thiện rõ rệt trên cả ba dataset Flickr8k, Flickr30k, MS COCO so với Show and Tell gốc, và trở thành thành phần chuẩn của mọi model captioning sau đó.
- **Bài học nối sang khóa 120:** attention trong captioning là cùng một cơ chế attention của Transformer mà khóa 120 đã học — chỉ khác chỗ query: ở đây query là hidden state của LSTM, key/value là các vùng ảnh. Hiểu một lần, dùng cho cả text lẫn ảnh.

## 4. Chuẩn bị dữ liệu — phần thực hành khóa nhấn mạnh

Khóa liệt kê 4 bước chuẩn bị, và đây là phần tốn công nhất khi tự làm model thật:

### 4.1. Tiền xử lý ảnh

- Resize về kích thước chuẩn của backbone (thường 224×224), chuyển thành tensor, **chuẩn hóa bằng mean/std của ImageNet** (vì encoder pretrain trên ImageNet — đưa ảnh chưa chuẩn hóa vào là lệch phân phối ngay).
- **Mẹo tiết kiệm compute mà khóa và các tutorial đều dùng:** chạy CNN **một lần** cho toàn bộ dataset, lưu vector đặc trưng ra đĩa, rồi train decoder trên các vector đã lưu — thay vì chạy lại CNN mỗi epoch. Đây là transfer learning ở mức pipeline, không chỉ ở mức trọng số.

### 4.2. Tiền xử lý text và tokenize

- Làm sạch caption: lowercase, bỏ dấu câu, chuẩn hóa khoảng trắng.
- Tokenize thành từ; đếm tần suất, **bỏ từ hiếm** (xuất hiện dưới ngưỡng, ví dụ < 5 lần) để từ điển gọn; thêm 4 token đặc biệt: `<pad>` (đệm câu ngắn), `<start>` (bắt đầu sinh), `<end>` (dừng sinh), `<unk>` (từ lạ ngoài từ điển).
- Ví dụ thực hành phổ biến: Flickr8k cho từ điển ~5.000 từ sau khi lọc.

### 4.3. Tạo training sequence

- Mỗi cặp (ảnh, caption) thành một chuỗi huấn luyện: input là `<start> + các từ của caption`, target là `các từ của caption + <end>` — tức là **dịch chuyển đi một vị trí** (shift by one). Model học: cho ảnh + các từ đã có, dự đoán từ tiếp theo.
- Dataset chuẩn của khóa và của cả lĩnh vực: **MS COCO** — 82.783 ảnh train, mỗi ảnh 5 caption (bản 2014); Flickr8k/30k nhỏ hơn, dùng cho demo nhanh. Chia train/val/test theo **Karpathy split** (5.000 ảnh val + 5.000 ảnh test) là chuẩn báo cáo chung.

### 4.4. Teacher forcing — cách train decoder

- Trong lúc train, **đưa từ thật (ground truth) vào làm input cho bước tiếp theo**, thay vì đưa từ model vừa dự đoán (có thể sai). Nhờ đó mỗi bước train độc lập, chạy song song được, hội tụ nhanh.
- **Cái giá phải trả (exposure bias):** lúc inference model phải tự ăn từ do chính nó sinh ra — từ sai ở bước đầu kéo theo sai cả câu sau, trong khi lúc train nó chưa bao giờ gặp tình huống "từ trước bị sai". Đây là lý do caption sinh ra đôi khi "trôi" khỏi ảnh sau vài từ đúng đầu câu. Các cải tiến sau này (scheduled sampling, train bằng CIDEr reward qua reinforcement learning) sinh ra để vá đúng lỗ này.

## 5. Train và evaluate

### 5.1. Hàm loss

- **Negative log-likelihood** của caption đúng khi cho ảnh: L(I, S) = −Σ log p_t(S_t) — tổng log xác suất model gán cho từng từ đúng trong caption. Tối ưu bằng SGD, train cả LSTM lẫn lớp cuối của CNN cùng lúc (end-to-end, một mạng duy nhất).
- **Kết quả gốc của Show and Tell (2015):** BLEU-1 tăng từ 25 lên 59 trên PASCAL (người đạt ~69), từ 56 lên 66 trên Flickr30k, từ 19 lên 28 trên SBU; BLEU-4 đạt 27,7 trên MS COCO. Bản journal 2017 (sau COCO Captioning Challenge 2015) đồng hạng nhất.

### 5.2. Các metric đánh giá — vì sao một metric không đủ

Một caption có nhiều cách nói đúng, nên không có metric nào là chân lý; mỗi metric soi một góc, và paper nào cũng báo cáo cả bộ:

| Metric | Đo cái gì | Điểm mạnh | Điểm yếu |
|---|---|---|---|
| **BLEU** (B@1–B@4) | Độ chính xác n-gram (từ đơn tới cụm 4 từ) so với tham chiếu | Nhanh, dễ hiểu, chuẩn cũ | Chỉ tính precision, không tính recall; mượn từ dịch máy |
| **METEOR** | Căn chỉnh từ theo khớp chính xác + stemming + từ đồng nghĩa; tính cả precision lẫn recall, phạt câu bị xé mảnh | Tương quan với đánh giá người tốt hơn BLEU | Chậm, phụ thuộc ngôn ngữ |
| **ROUGE-L** | Dãy con chung dài nhất (LCS) giữa caption sinh và tham chiếu | Bắt được cấu trúc cấp câu | Chỉ nhìn LCS, không hiểu ngữ nghĩa |
| **CIDEr** | Độ tương đồng n-gram **có trọng số TF-IDF** với nhiều caption tham chiếu | Metric chuẩn của captioning từ 2015; thưởng từ hiếm, đặc trưng của ảnh, phạt từ chung chung ("a photo of") | Cần toàn bộ corpus để tính TF-IDF |
| **SPICE** | Phân tích caption thành **scene graph** (vật thể, thuộc tính, quan hệ) rồi tính F1 trên các tuple | Gần cách người chấm nhất: "a red car next to a tree" vẫn khớp dù đổi thứ tự từ | Tính phức tạp, cần parser |

- **Quy tắc đọc bảng kết quả:** CIDEr là metric chính để so sánh model captioning (thang 0–10+, càng cao càng tốt); SPICE là metric bổ sung để kiểm tra ngữ nghĩa; BLEU-4 để đối chiếu với paper cũ. **Không tin một metric đơn lẻ** — model có thể "lừa" BLEU bằng cách sinh câu an toàn, chung chung, khớp nhiều n-gram nhưng rỗng nghĩa.
- **Lưu ý từ nghiên cứu 2016 (Vedantam và cộng sự, "Re-evaluating Automatic Metrics"):** trong COCO Challenge 2015, các model deep learning đã **vượt người** theo metric tự động, nhưng **không thắng người** khi cho người chấm trực tiếp — bằng chứng rằng metric tự động có trần, và đánh giá người vẫn là chuẩn cuối cùng.

## 6. Sinh caption — inference

- **Greedy decoding:** mỗi bước lấy từ có xác suất cao nhất, đưa làm input bước sau, dừng khi sinh `<end>` hoặc hết độ dài tối đa. Nhanh, nhưng dễ kẹt ở lựa chọn cục bộ tốt mà toàn câu dở.
- **Beam search:** giữ cùng lúc k câu ứng viên tốt nhất (beam width thường 3–5), mở rộng từng bước, cuối cùng chọn câu có tổng log xác suất cao nhất. Chậm hơn nhưng caption tốt hơn hẳn — **đây là mặc định trong thực hành**, và khóa nhắc tới như bước cuối của pipeline.
- **Hiểu bằng một câu:** train dạy model "từ tiếp theo nào là đúng", inference là đi bộ qua không gian câu bằng beam search để tìm câu có xác suất cao nhất — và caption cuối cùng chỉ tốt bằng đúng chất lượng của phân phối xác suất đã học.

## 7. Tình hình 2026 — kiến trúc trong khóa đã cũ, khái niệm còn nguyên

Khóa dạy kiến trúc 2015 (CNN–LSTM + attention). Đến 2026, cách làm captioning trong sản phẩm đã đổi hai lần, nhưng **khung encoder–decoder và attention của khóa vẫn là khung tư duy đúng**:

### 7.1. Lần đổi thứ nhất: Transformer thay LSTM (2019–2023)

- Decoder LSTM được thay bằng **Transformer decoder** (tự attention trên các từ đã sinh + cross-attention lên vùng ảnh); encoder CNN được thay dần bằng **Vision Transformer (ViT)**. Đại diện tiêu biểu: **BLIP-2** (Li và cộng sự, Salesforce, 2023) — giữ nguyên cả image encoder (ViT, đóng băng) lẫn LLM (OPT/Flan-T5, đóng băng), chỉ train một **Q-Former** nhẹ (Querying Transformer, 12 lớp) làm cầu nối giữa hai khối đóng băng. Kết quả: vượt Flamingo 80B tới 8,7% trên zero-shot VQAv2 mà chỉ dùng **ít hơn 54 lần tham số trainable**.
- **Bài học:** cùng nguyên tắc transfer learning của §2.1, nhưng đẩy lên một nấc — không chỉ tái dùng encoder, mà **đóng băng toàn bộ hai phía** và chỉ train cầu nối. Rẻ hơn train end-to-end hàng chục lần, mà vẫn đạt state-of-the-art. Đây là phiên bản 2023 của "đừng train lại từ đầu" mà khóa dạy.

### 7.2. Lần đổi thứ hai: vision-language model làm luôn captioning (2024–2026)

- Ngày nay captioning không còn là bài toán train model riêng: **Gemini, GPT, Claude** nhận ảnh + trả text trong cùng một model — đưa ảnh vào, hỏi "mô tả ảnh này", nhận caption, không cần dataset COCO, không cần train. Theo bảng xếp hạng captioning 2026: GPT-5.2 đạt CIDEr 150+ zero-shot trên COCO (không fine-tune), Claude Opus 4.6 đạt 148+ và dẫn đầu về vật thể mới trên NoCaps.
- **COCO đã bão hòa:** CIDEr trên 145 trên COCO gần như đo **rò rỉ dataset** (model đã thấy ảnh COCO trong dữ liệu pretrain khổng lồ) hơn là đo chất lượng model. Tín hiệu đánh giá thật đã chuyển sang **NoCaps** (vật thể mới chưa từng thấy), mô tả dài, và kiểm tra định tính — độ đúng thuộc tính, độ bám quan hệ, **tỉ lệ hallucination** (bịa vật không có trong ảnh) — những thứ metric n-gram không bắt được.
- **Kết luận cho team:** đừng train CNN–LSTM captioning mới năm 2026. Khi cần caption, gọi **Gemini vision qua SDK `google-genai`** (đã có sẵn từ task 121) — cùng client, cùng API key free tier. Kiến trúc trong khóa chỉ còn giá trị để **hiểu model đang làm gì bên trong** (encoder → vector ảnh, decoder sinh từng từ, attention soi vùng ảnh), chứ không phải để build lại.

## 8. Tự kiểm tra — các câu hỏi cốt lõi của quiz khóa

Khóa có 1 quiz sau video. Học viên không đăng nhập làm quiz (nằm sau đăng ký), nên tự kiểm tra bằng các câu hỏi rút ra từ đúng nội dung khóa — trả lời được hết các câu này là nắm được khóa:

1. **Encoder làm gì, decoder làm gì?** — Encoder (CNN pretrain) nén ảnh thành vector đặc trưng; decoder (LSTM) sinh caption từng từ từ vector đó.
2. **Vì sao dùng CNN pretrain thay vì train encoder từ đầu?** — Dataset caption quá nhỏ để dạy CNN nhìn ảnh từ con số 0; transfer learning từ ImageNet là điều kiện cần.
3. **Attention giải quyết vấn đề gì của Show and Tell gốc?** — Nút cổ chai một vector cố định: decoder được nhìn lại từng vùng ảnh khi sinh từng từ, thay vì chỉ có một vector tổng.
4. **Soft attention khác hard attention ở đâu?** — Soft lấy trung bình có trọng số trên mọi vùng, khả vi, train bằng backprop thường; hard chỉ chọn một vùng, cần reinforcement learning.
5. **Training sequence được tạo như thế nào?** — Input `<start> + caption`, target `caption + <end>` (dịch một vị trí); loss là negative log-likelihood từng từ đúng.
6. **Teacher forcing là gì, cái giá của nó là gì?** — Train đưa từ thật vào bước sau để hội tụ nhanh; cái giá là exposure bias — inference model phải tự ăn từ do nó sinh ra, sai một từ có thể kéo lệch cả câu.
7. **CIDEr khác BLEU ở điểm nào, vì sao CIDEr là metric chính của captioning?** — CIDEr có trọng số TF-IDF trên nhiều caption tham chiếu: thưởng từ hiếm đặc trưng của ảnh, phạt từ chung chung; BLEU chỉ tính precision n-gram, mượn từ dịch máy.
8. **Beam search tốt hơn greedy ở đâu?** — Greedy chọn từ tốt nhất từng bước, dễ kẹt cục bộ; beam search giữ k ứng viên câu cùng lúc, chọn câu có tổng xác suất cao nhất.

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai research (muse-2) và việc chung của team:

1. **Hoàn thiện vòng multimodal hai chiều (§2, §7).** Khóa 122: text → ảnh (diffusion, sinh). Khóa này: ảnh → text (encoder-decoder, mô tả). Hai chiều dùng chung một khung tư duy — **encoder biến dữ liệu thành vector, decoder sinh đầu ra từng bước, attention nối hai phía**. Nắm được khung này thì mọi model multimodal sau này (BLIP-2, Gemini) đều chỉ là "thay linh kiện" trong cùng một khung: đổi CNN thành ViT, đổi LSTM thành Transformer/LLM, đổi cầu nối thành Q-Former. *Áp dụng ngay:* khi đọc tài liệu model mới, hỏi ba câu — encoder là gì, decoder là gì, cầu nối giữa chúng là gì — thay vì đọc từ đầu tới cuối.
2. **Caption là prompt ngược của ảnh (§1, §7.2).** Caption mô tả đúng 4 thành phần mà prompt sinh ảnh cần (chủ thể + phong cách + ánh sáng + bố cục, theo template của báo cáo 122). Nghĩa là: đưa một ảnh vào Gemini, xin caption chi tiết, sẽ thu được **prompt gần đúng để tái tạo ảnh đó**. *Áp dụng ngay cho Anh:* khi Anh có một ảnh avatar ưng ý mà không nhớ prompt đã dùng, mô tả ngược bằng Gemini vision là cách khôi phục prompt nhanh nhất — rồi sửa prompt đó thay vì viết lại từ đầu (nối thẳng với recipe sinh ảnh của task 122).
3. **Đừng train model captioning riêng — gọi Gemini vision (§7.2).** Team đã có SDK `google-genai` + Streamlit + API key free tier từ task 121. Thêm một tab "Mô tả ảnh" vào app demo: upload ảnh → gọi Gemini → nhận caption/mô tả chi tiết. Không cần dataset COCO, không cần GPU train, không tốn credit GCP. *Áp dụng ngay (đề xuất, không tự làm trong task này):* khi muse-main cần demo cho Anh, tab này ghép cặp với tab sinh ảnh của task 122 thành vòng tròn khép kín: sinh ảnh từ prompt → mô tả ngược ảnh vừa sinh → so sánh caption với prompt gốc để kiểm tra ảnh có "nghe lời" không.
4. **Metric nào cũng có trần — đọc bảng kết quả phải đọc cả bộ (§5.2).** CIDEr cao chưa chắc caption hay (model có thể sinh câu an toàn, chung chung); model vượt người trên metric tự động vẫn có thể thua người khi chấm trực tiếp. *Áp dụng ngay (nguyên tắc chung):* khi team tự chấm chất lượng (review extension, chấm điểm task), đừng tin một con số duy nhất — giống như review task chấm điểm 0–10 kèm note lý do, chứ không chỉ ghi điểm.
5. **Attention heatmap là công cụ debug, không chỉ là lý thuyết (§3).** Khi model sinh caption sai ("con chó" thành "con mèo"), heatmap cho biết lỗi ở **nhìn sai chỗ** (attention) hay **hiểu sai thứ đã nhìn đúng** (decoder). *Áp dụng ngay (nguyên tắc chung):* khi extension chạy sai, phân biệt lỗi ở tầng nào trước khi sửa — lỗi lấy dữ liệu (encoder), lỗi xử lý (decoder), hay lỗi nối hai tầng (attention/cầu nối) — thay vì sửa lung tung cả pipeline.
6. **Teacher forcing / exposure bias là bài học về train–test mismatch (§4.4).** Model train trong điều kiện "luôn có đáp án đúng kề bên" nhưng inference phải tự sinh — giống hệt việc test extension trên dữ liệu mẫu sạch rồi đem chạy site thật: môi trường train và môi trường thật khác nhau thì kết quả lệch. *Áp dụng ngay:* quy tắc device test trên điện thoại thật của Anh (§4 PROTOCOL) chính là cách team vá exposure bias — không tin kết quả train/test trên máy dev, chỉ tin kết quả chạy trên thiết bị thật.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill `vbook-extension-building` — không cần sửa:** khóa này không đụng tới build extension; không đề xuất thay đổi skill này.
2. **Skill research (hoặc mục mới trong skill chung) — thêm recipe "Mô tả ảnh bằng Gemini vision qua SDK `google-genai`" (từ §7.2 + mục 2–3 phần áp dụng):** cùng client với recipe sinh ảnh của task 122 (model text là Gemini, thêm input ảnh); prompt xin mô tả theo đúng 4 thành phần của template prompt ảnh (chủ thể + style + ánh sáng + bố cục) để caption trả về dùng được luôn làm prompt tái tạo; quy tắc "không train model captioning riêng năm 2026"; và cặp tab demo (sinh ảnh + mô tả ngược) để kiểm tra ảnh có khớp prompt gốc không. Lý do: đây là nửa còn lại của vòng multimodal mà task 122 đã mở, và Anh trực tiếp dùng sinh/mô tả ảnh cho avatar — recipe này phục vụ việc thật của Anh.
3. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc system instruction (PROTOCOL) / user prompt (task file) đã chốt ở task 120 vẫn đứng vững.

## Khóa tiếp theo

- Theo phân vai §9/§10, muse-2 đã xong cả 6 khóa được giao: **Elements of AI (task 118)**, **Introduction to Generative AI (task 119)**, **Prompt Design in Vertex AI (task 120)**, **Develop Gen AI Apps with Gemini and Streamlit (task 121)**, **Introduction to Image Generation (task 122)**, **Create Image Captioning Models (task 124)**. Vòng tự học đã đi hết: khái niệm (118–119) → viết prompt (120) → đóng thành app (121) → sinh ảnh (122) → mô tả ảnh (124). Vòng multimodal hai chiều đã khép kín.
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): trong cùng chương trình 10 khóa GenAI của Google, khóa còn lại khớp nhất với vòng này là **"Build Real World AI Applications with Gemini and Imagen"** — đi tiếp hướng xây app thật với cả text + ảnh (lưu ý: phần Imagen trong tên khóa đã cũ theo báo cáo 122 §6, cần đối chiếu model thay thế khi học). Quyết định thuộc về muse-main theo PROTOCOL §10.

## Nguồn

- Trang khóa (Google Cloud Skills Boost, course_templates/542, 30 phút, Intermediate, rating 4.08/177 reviews): https://www.cloudskillsboost.google/course_templates/542
- Trang khóa (Coursera, 1 module, ~1 giờ, 2.872 học viên, 32 reviews): https://www.coursera.org/learn/create-image-captioning-models
- Giáo trình chuyên ngành "Google Cloud Generative AI Fundamentals for Developer" — mục tiêu Module 4 (CNN encoder + RNN decoder với attention, tiền xử lý, train end-to-end): https://hkmci.com/wp-content/uploads/2023/07/RTTP-Google-Cloud-Generative-AI-Fundamentals-for-Developer.pdf
- Show and Tell — Vinyals, Toshev, Bengio & Erhan, CVPR 2015 (NIC, CNN + LSTM, BLEU-4 27.7 trên COCO): https://computervisiononline.com/explains/show-and-tell-paper/ ; https://www.emergentmind.com/papers/1411.4555
- Show, Attend and Tell — Xu và cộng sự, 2015 (soft/hard attention, 196 vector vùng ảnh): http://wiki.math.uwaterloo.ca/statwiki/index.php?title=show,_Attend_and_Tell:_Neural_Image_Caption_Generation_with_Visual_Attention
- Hướng dẫn thực hành (Flickr8k, Inception + GRU + Bahdanau attention, teacher forcing): https://dzlab.github.io/notebooks/tensorflow/vision/captioning/2021/06/01/Image_Captioning_with_Attention.html ; http://ketanhdoshi.github.io/Image-Caption-Attn/
- Metric đánh giá caption (BLEU/METEOR/ROUGE-L/CIDEr/SPICE, bảng so sánh): https://deepwiki.com/mrazhou/SEN/5.2-evaluation-metrics ; https://www.labellerr.com/blog/image-captioning-evaluation-and-fine-tuning/
- COCO đã bão hòa 2026, GPT-5.2 CIDEr 150+, NoCaps là tín hiệu thật: https://www.codesota.com/tasks/image-captioning
- BLIP-2 — Li và cộng sự, 2023 (Q-Former, đóng băng encoder + LLM, vượt Flamingo 80B 8,7% với ít hơn 54 lần tham số trainable): https://huggingface.co/docs/transformers/v4.48.1/model_doc/blip-2
- Tổng hợp 10 khóa GenAI miễn phí của Google (khóa này là 1 trong 10): https://rogue-scholar.org/records/kbh44-8ew68
