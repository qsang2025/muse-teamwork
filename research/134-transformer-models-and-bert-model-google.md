# Transformer Models and BERT Model (Google) — Báo cáo tự học (task 134)

- **Khóa học:** Transformer Models and BERT Model, Google Cloud Skills Boost (thuộc learning path Generative AI for Developers — chương trình 10 khóa Advanced Generative AI for Developers)
- **Trang khóa:** Google Skills: https://www.skills.google/course_templates/538
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 134). **Không chạy lab GCP tốn credit** — khóa này là microlearning thuần video/lý thuyết, không có lab đi kèm (giống khóa 131, khác các khóa 121/126/129 có lab Skills Boost). Học qua trang khóa chính thức, bài gốc "Attention Is All You Need" (Vaswani et al., 2017), bài gốc BERT (Devlin et al., 2019) và bài "The Illustrated Transformer" (Jay Alammar).
- **Quy mô khóa:** trang khóa ghi 30 phút, mô tả ước tính ~45 phút; trình độ Intermediate, miễn phí; xuất bản (tái bản) 2026-08-25; rating 4.14/5 (2119 reviews). Không có assignment chấm điểm.
- **Vị trí trong vòng tự học:** khóa 10 theo phân vai (sau 131 Attention Mechanism). Đây là **khóa lắp ráp**: 131 mổ xẻ một viên gạch (self-attention), khóa này xếp các viên gạch đó thành **một kiến trúc hoàn chỉnh (Transformer)** rồi dùng đúng kiến trúc đó để xây **BERT** — model đã thay đổi toàn bộ NLP từ 2018. Khóa tiếp theo trong chương trình (chị cả quyết theo §10): Encoder-Decoder Architecture.

## Cấu trúc khóa (syllabus)

| Phần | Nội dung chính |
|---|---|
| Transformer architecture | Các thành phần chính: encoder/decoder stack, multi-head attention, positional encoding, feed-forward |
| BERT model | BERT được xây bằng Transformer như thế nào: pre-training (MLM + NSP) rồi fine-tuning |
| Ứng dụng của BERT | Phân loại văn bản, hỏi–đáp, suy luận ngôn ngữ tự nhiên (NLI) |

Ba mục tiêu học tập chính thức của khóa (theo trang Skills Boost / Coursera): hiểu các thành phần chính của kiến trúc Transformer; học cách model BERT được xây dựng bằng Transformer; dùng BERT để giải các task NLP khác nhau.

## 1. Vì sao cần Transformer — nhắc lại từ khóa 131

Báo cáo 131 kết thúc ở chỗ: self-attention giải quyết được cổ chai của RNN (mỗi từ nhìn thẳng mọi từ khác, đường đi thông tin O(1) thay vì O(n)), nhưng nó mới chỉ là **một phép tính**, chưa phải một model hoàn chỉnh. Muốn dịch một câu, phân loại một đoạn văn, vẫn cần một kiến trúc xung quanh phép tính đó: đưa từ vào bằng gì, xếp bao nhiêu lớp, làm sao giữ thứ tự từ, sinh đầu ra ở đâu. Transformer (Vaswani et al., 2017) là đáp án: **một kiến trúc chỉ dùng attention, bỏ hẳn recurrence (RNN) và convolution**.

Hai lợi ích mà bài báo nhấn mạnh — và cũng là lý do Transformer thắng RNN:

1. **Song song hóa:** RNN bắt buộc xử lý tuần tự từng từ (từ thứ t phải đợi từ thứ t−1); Transformer xử lý **mọi vị trí cùng lúc**, vì mỗi vị trí có đường đi riêng qua encoder, chỉ gặp nhau ở lớp self-attention (dạng ma trận, tính một lần cho cả câu). Hệ quả trực tiếp: train nhanh hơn nhiều trên GPU.
2. **Đường đi thông tin ngắn:** bất kỳ hai từ nào trong câu cũng nối nhau qua đúng 1 bước attention (O(1)), thay vì phải "sống sót" qua n bước hidden state như RNN — nên phụ thuộc xa (đại từ ở cuối câu chỉ danh từ ở đầu câu) học được dễ hơn.

Bảng so sánh độ phức tạp theo từng lớp (bảng 1, bài báo gốc) — cùng một độ dài chuỗi n, chiều model d:

| Loại lớp | Độ phức tạp / lớp | Số bước tuần tự | Đường đi dài nhất giữa 2 vị trí |
|---|---|---|---|
| Self-attention | O(n²·d) | O(1) | O(1) |
| Recurrent (RNN) | O(n·d²) | O(n) | O(n) |
| Convolutional | O(k·n·d²) | O(1) | O(log_k n) |

Đọc bảng này đúng cách: self-attention **không rẻ hơn** RNN về tổng phép tính — nó đắt hơn theo n² (đây chính là trần O(n²) mà báo cáo 131 §3.8 đã phân tích, và là lý do context window hữu hạn, RAG phải tồn tại). Cái nó mua được bằng cái giá đó là **O(1) bước tuần tự và O(1) đường đi** — train song song được và học phụ thuộc xa tốt hơn. Với câu ngắn–trung bình (n nhỏ hơn d, thường đúng trong dịch máy 2017) thì đây là giao dịch có lời; với văn bản rất dài thì n² trở thành vấn đề — đúng như các cải tiến sau 2017 (FlashAttention, sliding window, GQA) đều xoay quanh việc trả giá này rẻ đi.

## 2. Kiến trúc Transformer — xếp chồng attention thành encoder/decoder

### 2.1. Toàn cảnh: hai chồng, sáu lớp mỗi bên

Transformer gồm một **encoding component** (chồng encoder) và một **decoding component** (chồng decoder), nối với nhau. Bản gốc xếp **N = 6 encoder chồng lên nhau và 6 decoder** (con số 6 không có gì thiêng liêng — thử nghiệm khác vẫn được, Alammar nhấn mạnh điểm này). Mỗi từ đi qua encoder theo đường đi riêng của vị trí đó; các đường đi chỉ tương tác với nhau ở lớp self-attention, còn lớp feed-forward thì mỗi vị trí chạy độc lập — nên toàn bộ encoder chạy song song được.

- **Encoder** (mỗi lớp, giống hệt nhau về cấu trúc nhưng **không chia sẻ trọng số**): 2 sub-layer — (1) multi-head self-attention, (2) feed-forward network áp dụng độc lập cho từng vị trí. Quanh mỗi sub-layer có **residual connection + LayerNorm**: đầu ra = `LayerNorm(x + Sublayer(x))`.
- **Decoder** (mỗi lớp): 3 sub-layer — (1) **masked** multi-head self-attention, (2) **encoder–decoder attention** (cross-attention: Query lấy từ decoder, Key/Value lấy từ đầu ra của chồng encoder), (3) feed-forward. Cũng residual + LayerNorm quanh mỗi sub-layer.
- **Đầu ra cuối:** một lớp linear rồi softmax để chọn từ tiếp theo (khi dịch / sinh text).

Tất cả các sub-layer và embedding đều cho đầu ra cùng chiều **d_model = 512** — đây là điều kiện để residual connection cộng được (x và Sublayer(x) phải cùng kích thước).

### 2.2. Multi-head attention — nhìn câu bằng nhiều "góc" cùng lúc

Self-attention của khóa 131 chỉ là **một** phép attention. Multi-head attention chạy **nhiều phép attention song song** (bản gốc: 8 head), mỗi head có bộ ma trận Q/K/V riêng, rồi nối kết quả lại và chiếu qua một ma trận nữa (W^O):

| Bước | Nội dung |
|---|---|
| 1. Chia | Mỗi head nhận Q, K, V riêng (chiều d_k = 64, bằng 512/8) qua các ma trận chiếu đã học |
| 2. Tính | Mỗi head chạy scaled dot-product attention độc lập: `softmax(QKᵀ/√d_k)V` |
| 3. Gộp | Nối 8 đầu ra (8 × 64 = 512) rồi nhân với W^O để về đúng chiều d_model |

Vì sao cần nhiều head thay vì một head lớn: mỗi head học được một **khía cạnh quan hệ khác nhau** giữa các từ — head này gắn đại từ với danh từ nó chỉ, head khác gắn động từ với tân ngữ, head khác nữa theo dõi thì/thể. Thí nghiệm trong bài báo: dùng 1 head thay vì 8 làm BLEU tụt 0.9 điểm. **Ba loại attention cần phân biệt rõ** (quy tắc báo cáo 131 §9 đã đặt ra — từ nay ghi rõ loại nào):

| Loại | Query lấy từ đâu | Key/Value lấy từ đâu | Dùng ở |
|---|---|---|---|
| Self-attention | Cùng chuỗi đầu vào | Cùng chuỗi đầu vào | Mọi lớp encoder; lớp 1 decoder |
| Masked self-attention | Chuỗi đích đã sinh | Chuỗi đích đã sinh (che các vị trí tương lai) | Lớp 1 decoder — để lúc sinh từ thứ t, model không "nhìn trộm" từ thứ t+1 |
| Cross-attention (encoder–decoder) | Decoder (trạng thái đang sinh) | Đầu ra chồng encoder | Lớp 2 decoder — để mỗi từ đích "hỏi" phần cần thiết của câu nguồn |

### 2.3. Positional encoding — bù thứ tự cho một kiến trúc không có thứ tự

Self-attention tự nó **không biết thứ tự từ**: nó xem câu như một tập hợp (bag), "con mèo cắn con chó" và "con chó cắn con mèo" cho cùng một tập Query/Key/Value. Transformer bù lại bằng cách **cộng một vector vị trí vào mỗi embedding** trước khi đưa vào encoder đáy:

- `PE(pos, 2i) = sin(pos / 10000^(2i/d_model))`, `PE(pos, 2i+1) = cos(pos / 10000^(2i/d_model))`
- Mỗi vị trí pos có một "dấu vân tay" sin/cos duy nhất theo tần số khác nhau ở từng chiều; model học được vị trí tương đối giữa các từ từ hiệu số của các sóng này (vì sin/cos có tính chất dịch chuyển tuyến tính theo pos).
- Đây là mã hóa **tuyệt đối, không có tham số học** (bản gốc chọn sin/cos thay vì embedding vị trí học được, vì nó ngoại suy được ra độ dài câu chưa từng thấy trong train). Các LLM hiện đại đã thay nó bằng RoPE — xoay vector theo vị trí tương đối (báo cáo 131 §7).

### 2.4. Feed-forward và các chi tiết còn lại

- **Position-wise FFN:** `FFN(x) = max(0, x·W₁ + b₁)·W₂ + b₂` — cùng một mạng áp cho từng vị trí riêng biệt; chiều trong 2048, chiều ra 512. Đây là nơi model "suy nghĩ" riêng cho từng từ sau khi attention đã trộn ngữ cảnh vào.
- **Embedding + dropout + label smoothing:** embedding từ (kích thước 512, chia sẻ trọng số giữa encoder/decoder và lớp linear đầu ra), dropout 0.1, label smoothing ε = 0.1 khi train.
- **Quy mô bản gốc:** Transformer **base**: 65M tham số, train 12 giờ trên 8 GPU P100; Transformer **big**: 213M tham số, train 3.5 ngày trên 8 GPU P100. Hôm nay những con số này trông nhỏ bé (Gemini/GPT lớn hơn hàng nghìn lần), nhưng năm 2017 train 12 giờ đã là "rẻ" so với các ensemble RNN/CNN cùng thời.

### 2.5. Kết quả — con số làm nên lịch sử

Trên benchmark dịch máy WMT 2014 (newstest2014), Transformer **big** đạt **BLEU 28.4 Anh→Đức** (vượt hơn 2 điểm so với ensemble tốt nhất trước đó, 26.36) và **BLEU 41.8 Anh→Pháp** (abstract + bảng 2; phần §6.1 trong thân bài ghi 41.0 cho cùng model — chênh lệch này có trong chính bài báo, lấy số abstract/bảng làm chuẩn). Bản **base** đạt 27.3 / 38.1 — tức là ngay cả bản nhỏ, train 12 giờ, cũng đã vượt mọi model và ensemble đã công bố. Chi phí train: big tốn 2.3×10^19 FLOPs cho En–De — chỉ một phần nhỏ so với các đối thủ cùng thời. Ngoài dịch máy, bài báo còn chứng minh Transformer tổng quát hóa tốt sang phân tích cú pháp câu tiếng Anh (English constituency parsing) — gợi ý nó không phải kiến trúc chỉ-dịch-máy, mà là kiến trúc xử lý chuỗi nói chung.

## 3. BERT — chỉ lấy nửa encoder, đổi cách train, đổi cả NLP

### 3.1. Ý tưởng: pre-train hai chiều rồi fine-tune rẻ

Trước BERT, các model ngôn ngữ pre-train (như GPT-1 của Radford et al., 2018) đều **đơn hướng** (chỉ nhìn trái sang phải) — vì train kiểu "đoán từ tiếp theo" thì không được nhìn từ phía sau, nếu không sẽ gian lận. Devlin et al. (2018, công bố NAACL-HLT 2019) đặt câu hỏi ngược: muốn vector của một từ chứa **cả hai phía ngữ cảnh** thì phải train kiểu khác. Đáp án của họ là BERT — **Bidirectional Encoder Representations from Transformers**:

1. **Chỉ dùng chồng encoder của Transformer, bỏ decoder.** BERT không sinh text — nó chỉ "hiểu" text (đọc cả câu rồi đưa ra vector cho từng từ / cả câu). Muốn sinh text thì dùng họ decoder (GPT) — phân loại này xem §5.
2. **Pre-train trên văn bản không nhãn** bằng 2 nhiệm vụ tự tạo nhãn (self-supervised), rồi **fine-tune** cho từng task cụ thể chỉ bằng cách **thêm đúng 1 lớp output** — không sửa kiến trúc, không cần thiết kế riêng cho từng task.

### 3.2. Hai nhiệm vụ pre-training

**Nhiệm vụ 1 — Masked Language Model (MLM, "điền từ vào chỗ trống"):** lấy cảm hứng từ bài kiểm tra Cloze (Taylor, 1953). Trong mỗi câu, **mask ngẫu nhiên 15% token**, model phải đoán lại từ gốc chỉ dựa vào ngữ cảnh hai phía. 15% bị mask được xử lý theo tỉ lệ 80/10/10:

| Cách xử lý token bị chọn | Tỉ lệ | Vì sao làm vậy |
|---|---|---|
| Thay bằng token đặc biệt `[MASK]` | 80% | Nhiệm vụ chính: đoán từ bị che |
| Thay bằng một token ngẫu nhiên khác | 10% | Để model không chỉ "học vẹt" rằng cứ thấy `[MASK]` mới cần đoán |
| Giữ nguyên từ gốc | 10% | Để model vẫn học biểu diễn tốt cho cả từ không bị mask |

Lưu ý 80/10/10 tồn tại vì `[MASK]` **chỉ xuất hiện lúc pre-train, không bao giờ xuất hiện lúc fine-tune** — nếu mask 100% thì model sẽ bị lệch (pre-train/fine-tune mismatch). Đây là một chi tiết nhỏ nhưng là ví dụ đẹp về "thiết kế train phải nghĩ tới lúc dùng".

**Nhiệm vụ 2 — Next Sentence Prediction (NSP, "câu này có nối tiếp câu kia không"):** đưa vào một cặp câu A–B; với xác suất 50% B là câu **nối tiếp thật** của A trong văn bản gốc, 50% còn lại B là câu **ngẫu nhiên** từ chỗ khác. Model phải phân loại IsNext / NotNext. Mục đích: dạy model quan hệ **giữa hai câu** — thứ mà MLM (chỉ nhìn trong một câu) không dạy được, và là thứ cần thiết cho các task dạng cặp câu (hỏi–đáp, suy luận NLI, xem §4). Ghi chú sau này: RoBERTa (2019) chứng minh bỏ NSP vẫn tốt ngang hoặc hơn — NSP là ý tưởng đúng hướng nhưng không phải thành phần bắt buộc; khóa Google dạy đúng bản gốc 2018 nên báo cáo ghi theo bản gốc.

### 3.3. Đầu vào của BERT — ba loại embedding cộng lại

Mỗi token đưa vào BERT là tổng của 3 embedding:

| Embedding | Nội dung |
|---|---|
| Token embedding | Bản thân từ, theo từ điển WordPiece (~30.522 token — gồm cả từ con như "play" + "##ing", giúp xử lý từ chưa từng thấy) |
| Segment embedding | Token thuộc câu A hay câu B (0/1) — để phân biệt hai câu trong một cặp |
| Position embedding | Vị trí tuyệt đối của token trong chuỗi (học được, tối đa 512 vị trí) |

Hai token đặc biệt: **`[CLS]`** đặt ở đầu mọi chuỗi — vector của nó sau khi qua hết các lớp được dùng làm **đại diện cho cả chuỗi** (dùng cho các task phân loại); **`[SEP]`** ngăn cách hai câu trong một cặp và đánh dấu cuối chuỗi. Giới hạn thực tế: chuỗi tối đa **512 token** — văn bản dài hơn phải cắt/chia đoạn (đây cũng là một trong các lý do RAG phải chunk văn bản, nối báo cáo 129).

### 3.4. Dữ liệu pre-train và hai kích cỡ BERT

| | BERT_BASE | BERT_LARGE |
|---|---|---|
| Số lớp encoder (L) | 12 | 24 |
| Chiều hidden (H) | 768 | 1024 |
| Số attention head (A) | 12 | 16 |
| Tham số | ~110 triệu | ~340 triệu |

Dữ liệu pre-train (tiếng Anh, văn bản không nhãn): **BooksCorpus ~800 triệu từ** + **Wikipedia tiếng Anh ~2.500 triệu từ** (đã lọc bỏ danh sách, bảng, tiêu đề). Tổng ~3,3 tỉ từ — lớn vào thời đó, nhưng nhỏ hơn nhiều lần so với dữ liệu train LLM ngày nay (hàng nghìn tỉ token). Cũng vì vậy mà BERT train được trong vài ngày trên TPU, còn LLM hiện tại cần hàng tháng trên hàng nghìn GPU — cùng một công thức "pre-train lớn + fine-tune nhỏ", chỉ khác quy mô.

### 3.5. Fine-tuning — thêm một lớp, xong

Sau pre-train, lấy đúng model đó, **thêm một lớp output duy nhất** phù hợp task, rồi train tiếp toàn bộ model với learning rate nhỏ trên dữ liệu có nhãn của task:

| Task | Lớp output thêm vào | Dùng vector nào |
|---|---|---|
| Phân loại 1 câu / cặp câu (vd: đánh giá tích cực/tiêu cực, NLI) | Lớp phân loại (softmax) | Vector của `[CLS]` |
| Hỏi–đáp trích xuất (SQuAD) | Hai lớp dự đoán vị trí bắt đầu + kết thúc đáp án | Vector của từng token |
| Gắn nhãn từng token (NER, gán nhãn từ loại) | Lớp phân loại cho mỗi token | Vector của từng token |

Điểm làm BERT nổi tiếng: **cùng một model pre-train, cùng một quy trình fine-tune, không cần kiến trúc riêng cho từng task** — trước đó mỗi task NLP cần một kiến trúc chuyên biệt. Đây chính là mẫu "foundation model" mà sau này mọi LLM đều theo: pre-train một lần thật lớn, thích ứng rẻ cho từng việc.

### 3.6. Kết quả — 11 task NLP lên SOTA cùng lúc

Bài báo BERT đạt state-of-the-art mới trên **11 task NLP** (abstract):

| Benchmark | Kết quả BERT | Cải thiện so với SOTA trước |
|---|---|---|
| GLUE (bộ 9 task hiểu ngôn ngữ) | 80.5% | +7.7 điểm tuyệt đối |
| MultiNLI (suy luận ngôn ngữ) | 86.7% chính xác | +4.6 điểm |
| SQuAD v1.1 (hỏi–đáp) | F1 93.2 | +1.5 điểm |
| SQuAD v2.0 (hỏi–đáp, có câu không trả lời được) | F1 83.1 | +5.1 điểm |

Con số đáng chú ý nhất là GLUE +7.7 điểm — một bước nhảy lớn bất thường trong NLP, tương đương với cú nhảy BLEU của Transformer năm 2017. Sau BERT, "pre-train hai chiều + fine-tune" trở thành chuẩn mặc định của NLP trong vài năm, cho tới khi họ decoder-only (GPT-2/3) chứng minh sinh text dài cũng cần cùng một công thức, chỉ khác hướng attention.

## 4. Các task BERT giải được — theo đúng syllabus khóa

Khóa Google nêu 3 nhóm task chính, khớp với §3.5:

1. **Text classification (phân loại văn bản):** một câu hoặc một cặp câu → một nhãn. Ví dụ: phân loại cảm xúc (tích cực/tiêu cực), phát hiện spam, phân loại chủ đề. Dùng vector `[CLS]` + 1 lớp phân loại.
2. **Question answering (hỏi–đáp):** cho đoạn văn + câu hỏi → tìm đúng đoạn đáp án trong văn bản (trích xuất, không sinh mới). Dùng vector từng token để dự đoán vị trí bắt đầu/kết thúc đáp án. Đây là dạng QA mà khóa 129 (RAG) cũng dùng ở bước cuối — RAG tìm đoạn văn liên quan, rồi một model dạng BERT/reader trích đáp án.
3. **Natural language inference — NLI (suy luận ngôn ngữ tự nhiên):** cho cặp câu premise–hypothesis → phân loại quan hệ: entailment (suy ra được) / contradiction (mâu thuẫn) / neutral (không liên quan). Đây là bài kiểm tra "model có hiểu quan hệ logic giữa hai câu không", và là task mà NSP trong pre-train chuẩn bị trực tiếp cho.

Ngoài 3 nhóm trong syllabus, cùng một công thức fine-tune còn mở rộng ra: nhận diện thực thể (NER), phân tích quan hệ, tóm tắt trích xuất, tìm kiếm theo nghĩa (dùng vector `[CLS]` hoặc trung bình vector token làm embedding cho cả câu — nối trực tiếp báo cáo 129 về vector search).

## 5. Bản đồ ba họ Transformer — đặt BERT đúng chỗ

Một điểm dễ nhầm mà khóa này làm rõ bằng kiến trúc: "Transformer" không phải một model, mà là **một họ kiến trúc** — lấy encoder, decoder, hay cả hai sẽ ra ba họ khác nhau:

| Họ | Lấy phần nào | Attention | Ví dụ | Mạnh ở |
|---|---|---|---|---|
| **Encoder-only** | Chỉ encoder | Self-attention hai chiều (nhìn cả trước + sau) | **BERT**, RoBERTa, ELECTRA | **Hiểu** văn bản: phân loại, NLI, QA trích xuất, embedding |
| **Decoder-only** | Chỉ decoder | Masked self-attention (chỉ nhìn quá khứ) | **GPT**, Llama, Gemini (phần sinh text) | **Sinh** văn bản: chat, viết, code, dịch |
| **Encoder–decoder** | Cả hai | Self + cross-attention | **T5**, BART, Transformer gốc 2017 | **Biến đổi** chuỗi→chuỗi: dịch máy, tóm tắt |

Hệ quả thực tế cho team (nối khóa 119/121 — Gemini là họ decoder-only): **đừng bắt BERT sinh text** (nó không có decoder, sinh text bằng BERT là ép sai kiến trúc — Hugging Face cũng ghi rõ BERT "not optimal for text generation"); và ngược lại, **đừng bắt model sinh text làm phân loại bằng cách hỏi nó** khi có thể fine-tune một encoder nhỏ cho chính xác và rẻ hơn. Chọn đúng họ trước khi chọn model — đây là quyết định kiến trúc rẻ nhất mà khóa này cho.

## 6. Giới hạn của BERT (và vì sao LLM sau này đi tiếp)

Khóa Google dạy BERT bản gốc; ghi thêm các giới hạn đã được cộng đồng chỉ ra sau 2018–2019, để không áp dụng máy móc:

- **Không sinh text** (§5): encoder-only, chỉ hiểu — muốn sinh phải sang họ decoder.
- **512 token tối đa:** văn bản dài phải cắt/sliding-window; thông tin ngoài cửa sổ bị mất (cùng trần context như mọi model attention — nối 131 §3.8).
- **NSP bị nghi ngờ:** RoBERTa (Liu et al., 2019) bỏ NSP, train MLM lâu hơn với batch lớn hơn, vẫn tốt hơn BERT — chứng tỏ phần lớn sức mạnh nằm ở MLM + dữ liệu + thời gian train, không phải ở NSP.
- **Pre-train/fine-tune mismatch:** `[MASK]` chỉ có lúc pre-train (đã giảm nhẹ bằng 80/10/10, §3.2) và NSP dùng câu ngẫu nhiên — cả hai đều là "nhiệm vụ giả" không giống dữ liệu thật lúc dùng.
- **Chi phí:** BERT_LARGE 340M tham số, pre-train tốn kém — team không bao giờ train lại từ đầu; cách dùng đúng là **lấy model pre-train sẵn (Hugging Face / Vertex AI) rồi fine-tune**, hoặc chỉ dùng nó làm encoder lấy embedding.
- **Kiến thức đóng băng ở thời điểm pre-train:** BERT không biết gì sau dữ liệu train — muốn kiến thức mới phải retrieval (RAG, khóa 129) hoặc train lại, không phải hỏi nó.

## 7. Áp dụng được ngay cho việc chung

### 7.1. Nối task 131 — từ "một phép tính" thành "một model hoàn chỉnh"

Báo cáo 131 kết thúc với một công thức (`softmax(QKᵀ/√d_k)V`) và một câu hỏi mở: xếp chồng nó thành cái gì? Khóa này trả lời đầy đủ: **6 lớp encoder × (multi-head self-attention + FFN + residual + LayerNorm) + positional encoding = Transformer; lấy nửa encoder + MLM/NSP pre-train = BERT**. Từ nay, khi một báo cáo nhắc "Transformer" thì phải nói rõ là kiến trúc (§2) hay một model cụ thể (BERT, GPT…); khi nhắc "BERT" thì phải nhớ nó là encoder-only, không sinh text (§5).

### 7.2. Nối task 129 (vector search) — BERT là nguồn embedding "có ngữ cảnh"

Báo cáo 129 dùng embedding để tìm kiếm theo nghĩa mà chưa nói embedding đó sinh ra từ đâu. Trả lời: một cách chuẩn là lấy **vector `[CLS]` (hoặc trung bình các vector token) của BERT** làm embedding cho cả câu/đoạn — chính self-attention hai chiều đã "nướng" ngữ cảnh vào từng token, nên hai đoạn cùng ý khác lời vẫn gần nhau. Thực tế ngày nay người ta dùng các model embedding chuyên dụng (như `gemini-embedding-001` ở task 129), nhưng nguyên lý là một: **encoder Transformer + pooling = embedding**. Khi cần embedding chạy local/offline (không gọi API), một BERT nhỏ fine-tune sẵn là lựa chọn rẻ và đủ tốt — ghi lại làm phương án dự phòng cho recipe free tier (task 129).

### 7.3. Nối task 120/123 (prompt design) + 121 (app Gemini) — chọn đúng họ model

- Khi demo/app cần **phân loại** (vd: phân loại phản hồi, gắn nhãn tài liệu, lọc spam): fine-tune một encoder nhỏ (BERT) chính xác hơn, rẻ hơn và ổn định hơn là "hỏi Gemini rồi parse câu trả lời" — Gemini (decoder) sinh text tự do, khó ép ra đúng 1 nhãn 100% lần nào cũng giống nhau.
- Khi cần **sinh text** (chat, tóm tắt, viết): dùng họ decoder (Gemini, task 121) — đừng ép BERT.
- Quy tắc chọn nhanh: **hiểu → encoder (BERT); sinh → decoder (Gemini/GPT); biến đổi chuỗi→chuỗi → encoder–decoder (T5)** — bảng §5.

### 7.4. Gợi ý cho vBook (chưa phải quyết định — cần task riêng + quyết của Anh/muse-main theo §10)

- **Phân loại truyện tự động:** fine-tune BERT (đa ngữ — có bản multilingual) để gắn thể loại cho truyện từ tên + mô tả, thay vì gắn tay trong registry — nối gợi ý "tìm truyện theo nghĩa" ở 129 §9.4 và 131 §8.5. Đây là task phân loại văn bản đúng nghĩa (§4.1), dữ liệu có sẵn trong registry (mô tả + thể loại đã gắn tay = dữ liệu nhãn miễn phí).
- **Tìm truyện trùng/lặp:** dùng embedding câu mô tả (BERT `[CLS]`) để phát hiện hai nguồn cùng một truyện nhưng tên khác nhau — bài toán trùng lặp mà team vẫn xử lý thủ công khi quét rescan.
- Cả hai chỉ là gợi ý cho chị cả cân nhắc; không làm trong task tự học.

## 8. Đề xuất cập nhật skill

- **Không sửa skill vBook** trong task này (không có gì trong khóa đụng trực tiếp tới quy trình build extension).
- **Đã làm trong task này (theo đề xuất 131 §9, notes task 134):** viết `research/CHEAT-SHEET-ATTENTION.md` — 1 trang: công thức `softmax(QKᵀ/√d_k)V`, bảng 3 loại attention, bảng độ phức tạp, 2 quy tắc prompt, cộng thêm bảng 3 họ Transformer (§5) và 2 nhiệm vụ pre-train của BERT (§3.2) để khóa sau dùng lại mà không học lại từ đầu.
- **Lưu ý cho các báo cáo sau:** khi nhắc "Transformer" thì ghi rõ kiến trúc hay model cụ thể; khi nhắc "attention" thì ghi rõ loại nào trong 3 loại (131 §9); khi nhắc "BERT" thì nhớ nó là encoder-only, không sinh text.

## 9. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa xem video gốc của khóa:** nội dung khóa nằm sau trang Skills Boost (video + quiz, cần đăng nhập tài khoản Google Cloud để học). Báo cáo này học qua mô tả chính thức của khóa + bài báo gốc (Vaswani et al., 2017; Devlin et al., 2019) + tài liệu minh họa chuẩn ("The Illustrated Transformer"). Các điểm trong syllabus (§1–§3 đầu) khớp hoàn toàn với mô tả khóa; các số liệu bài báo gốc đối chiếu trực tiếp với arXiv/ACL Anthology.
- **Chênh lệch số BLEU En–Fr trong chính bài báo gốc:** abstract + bảng 2 ghi 41.8, phần §6.1 trong thân bài ghi 41.0 cho cùng model Transformer (big). Báo cáo lấy 41.8 (abstract/bảng) làm chuẩn và ghi rõ chênh lệch ở §2.5.
- **Phần §6 (giới hạn BERT, RoBERTa bỏ NSP) nằm ngoài phạm vi khóa 2018** — lấy từ tài liệu sau này, đã ghi rõ nguồn; khi team thực sự chọn model embedding/phân loại thì kiểm tra lại trên doc Hugging Face / Vertex AI trước khi chốt.
- **Chưa xác định:** hiệu quả thực tế của BERT multilingual trên mô tả truyện tiếng Trung (vBook) so với embedding Gemini — cần thực nghiệm nhỏ (so sánh trên vài chục mô tả thật) trước khi đề xuất thành task build.

## Nguồn

- Trang khóa chính thức (Google Skills): https://www.skills.google/course_templates/538
- Trang khóa trên Coursera (cùng nội dung, ghi rõ 3 mục tiêu học tập): https://www.coursera.org/programs/blue-and-green-economy-foundations-cklhl/learn/transformer-models-and-bert-model
- Bài báo gốc — "Attention Is All You Need" (Vaswani et al., 2017): https://arxiv.org/abs/1706.03762
- Bài báo gốc — "BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding" (Devlin et al., NAACL-HLT 2019): https://arxiv.org/abs/1810.04805 (bản ACL Anthology: https://aclanthology.org/N19-1423.pdf)
- "The Illustrated Transformer" (Jay Alammar, 2018): https://jalammar.github.io/illustrated-transformer/
- Tài liệu model BERT (Hugging Face — cấu hình BERT_BASE, 15% mask 80/10/10, NSP 50/50): https://huggingface.co/docs/transformers/model_doc/bert
- Báo cáo nối tiếp trong repo: `research/131-attention-mechanism-google.md` (self-attention, công thức, 3 loại attention, O(n²)), `research/129-vector-search-and-embeddings-google.md` (embedding + vector search), `research/122-introduction-to-image-generation-google.md` (diffusion + cross-attention), `research/124-create-image-captioning-models-google.md` (captioning + attention), `research/120-prompt-design-in-vertex-ai-google.md` (prompt design), `research/CHEAT-SHEET-ATTENTION.md` (cheat-sheet 1 trang — viết trong task này).

## Kết luận

Khóa này ngắn (45 phút) nhưng là **khóa lắp ráp của cả vòng tự học**: nó biến một phép tính (self-attention, khóa 131) thành một kiến trúc hoàn chỉnh (Transformer: 6 encoder + 6 decoder, multi-head attention, positional encoding, residual + LayerNorm — BLEU 28.4 En–De, vượt mọi ensemble cùng thời chỉ sau 12 giờ train bản base), rồi biến kiến trúc đó thành một model đổi cả ngành (BERT: chỉ lấy encoder, pre-train hai chiều bằng MLM + NSP trên 3,3 tỉ từ, fine-tune bằng đúng 1 lớp output — GLUE 80.5%, SOTA trên 11 task cùng lúc). Với team, giá trị mang về được ngay không nằm ở việc train Transformer hay BERT (không ai trong team train model), mà ở ba thứ: **bản đồ 3 họ Transformer (§5) để chọn đúng model cho đúng việc (hiểu → BERT, sinh → Gemini, biến đổi → T5)**, **hiểu embedding sinh ra từ đâu (§7.2) để dùng vector search đúng cách**, và **một cheat-sheet 1 trang để khóa sau không phải học lại từ đầu**.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** **Encoder-Decoder Architecture** — khóa tiếp theo trong chương trình 10 khóa, nối trực tiếp khóa này (đi sâu vào họ encoder–decoder: T5, dịch máy, tóm tắt). Sau đó còn lại trong chương trình: Introduction to Vertex AI Studio, Responsible AI for Developers (Fairness & Bias, Interpretability & Transparency, Privacy & Safety), Inspect Rich Documents with Gemini Multimodality and Multimodal RAG, MLOps for Generative AI.
