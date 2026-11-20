# Encoder-Decoder Architecture (Google) — Báo cáo tự học (task 136)

- **Khóa học:** Encoder-Decoder Architecture, Google Cloud Skills Boost (thuộc learning path Generative AI for Developers — chương trình 10 khóa Advanced Generative AI for Developers)
- **Trang khóa:** Google Skills: https://www.skills.google/course_templates/543
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 136). **Không chạy lab GCP tốn credit** — khóa là microlearning video + lab walkthrough (xem video hướng dẫn code TensorFlow/Keras, không phải lab GCP tính credit). Học qua trang khóa chính thức, bài gốc seq2seq (Sutskever et al., 2014), bài gốc Bahdanau attention (Bahdanau et al., 2015), bài gốc T5 (Raffel et al., 2019) và bài gốc Transformer (Vaswani et al., 2017).
- **Quy mô khóa:** trang khóa ghi 30 phút, Intermediate, miễn phí; xuất bản (tái bản) 2026-08-25; rating 4.12/5 (2299 reviews). Coursera ghi 1 giờ, Advanced, 51 reviews, 3 mục tiêu học tập chính thức.
- **Vị trí trong vòng tự học:** khóa 11 theo phân vai (sau 134 Transformer Models and BERT Model). Đây là **khóa đi sâu họ thứ ba** còn lại trong bản đồ 3 họ Transformer (134 §5): sau khi biết encoder-only (BERT — hiểu) và decoder-only (GPT/Gemini — sinh), khóa này mổ xẻ **encoder–decoder** — họ biến đổi chuỗi→chuỗi: dịch máy, tóm tắt, hỏi–đáp. Khóa tiếp theo trong chương trình (chị cả quyết theo §10): Introduction to Vertex AI Studio.

## Cấu trúc khóa (syllabus)

| Phần | Nội dung chính |
|---|---|
| Encoder-decoder architecture | Các thành phần chính của kiến trúc encoder–decoder; vì sao nó là kiến trúc chuẩn cho task sequence-to-sequence |
| Train and serve | Cách train một model encoder–decoder và cách serve (đưa vào sử dụng) nó |
| Lab walkthrough | Code trong TensorFlow/Keras một encoder–decoder đơn giản để sinh thơ (poetry generation) — từ đầu |

Ba mục tiêu học tập chính thức của khóa (theo trang Skills Boost / Coursera): hiểu các thành phần chính của kiến trúc encoder–decoder; học cách train và sinh text từ một model dùng kiến trúc này; học cách tự viết một model encoder–decoder bằng Keras.

## 1. Encoder–decoder là gì — ý tưởng seq2seq

Bài toán chung: **đầu vào là một chuỗi, đầu ra là một chuỗi khác, độ dài hai chuỗi không cần bằng nhau**. Dịch máy (câu Anh → câu Pháp), tóm tắt (bài dài → vài câu), hỏi–đáp (câu hỏi + đoạn văn → câu trả lời), sinh thơ (chủ đề → bài thơ). Trước 2014, mỗi bài toán cần một pipeline riêng (căn chỉnh từ, phrase table, language model…); seq2seq thay tất cả bằng **một model duy nhất, train end-to-end**.

Kiến trúc gốc — Sutskever, Vinyals & Le, "Sequence to Sequence Learning with Neural Networks", NIPS 2014 (arXiv:1409.3215):

```
Chuỗi nguồn x1..xn ──► [ENCODER: LSTM nhiều lớp] ──► vector c (cố định)
                                                            │
Chuỗi đích y1..ym ◄── [DECODER: LSTM nhiều lớp] ◄──────────┘
```

- **Encoder:** một LSTM nhiều lớp đọc chuỗi nguồn, từng từ một; trạng thái ẩn cuối cùng (hidden state sau từ cuối) là **vector ngữ cảnh `c`** — bản tóm tắt toàn bộ câu nguồn, nén vào một vector có chiều cố định.
- **Decoder:** một LSTM khác, khởi tạo bằng `c`, hoạt động như một language model có điều kiện — mỗi bước sinh ra phân phối xác suất trên từ vựng đích, chọn từ tiếp theo, cho tới khi sinh token kết thúc câu (EOS) thì dừng. Nhờ vậy độ dài đầu ra tự do, không cần bằng đầu vào.
- Xác suất toàn bộ câu đích được phân rã thành tích các xác suất có điều kiện: `P(y|x) = Π P(y_t | y_<t, c)` — mỗi từ đích phụ thuộc vào các từ đích đã sinh + vector ngữ cảnh.

### Kết quả — lần đầu neural thắng thống kê

Trên WMT'14 dịch Anh→Pháp, ensemble 5 LSTM (mỗi model 380M tham số, 4 lớp × 1000 cell, từ vựng 80k từ, beam search size 12):

| Model | BLEU (WMT'14 En–Fr) |
|---|---|
| Phrase-based SMT (baseline thống kê) | 33.3 |
| **Seq2seq LSTM (1 model, đảo ngược nguồn)** | 30.6 |
| **Seq2seq LSTM (ensemble 5 model)** | **34.8** |
| Seq2seq dùng để re-rank 1000 giả thuyết của SMT | 36.5 (SOTA thời đó: 37.0) |

Hai chi tiết kỹ thuật đáng nhớ trong bài báo:

1. **Đảo ngược câu nguồn:** đưa câu nguồn vào encoder theo thứ tự ngược (c, b, a thay vì a, b, c) làm perplexity test giảm từ 5.8 → 4.7 và BLEU tăng từ 25.9 → 30.6. Lý do: đảo ngược tạo nhiều phụ thuộc ngắn hạn giữa đầu câu nguồn và đầu câu đích, bài toán tối ưu dễ hơn. (Mẹo này về sau không còn cần khi có attention.)
2. **Không sợ câu dài như tưởng:** trái với lo ngại, LSTM không gặp khó khăn đặc biệt với câu dài — nhưng xem §2: đó là vì câu test WMT'14 chưa đủ dài để lộ cổ chai; Cho et al. (2014) đo kỹ hơn và thấy chất lượng sụt mạnh khi câu dài dần.

## 2. Cổ chai vector cố định — và attention của Bahdanau

Điểm yếu chí mạng của seq2seq gốc: **mọi thông tin của câu nguồn — dù 5 từ hay 50 từ — đều phải nhét vào một vector `c` có chiều cố định**. Câu càng dài, thông tin càng bị nén mất. Cho et al. (2014) đo được chất lượng dịch sụt nhanh khi độ dài câu tăng; Bahdanau, Cho & Bengio đặt tên cho vấn đề này trong bài "Neural Machine Translation by Jointly Learning to Align and Translate" (arXiv:1409.0473, ICLR 2015):

> "A potential issue with this encoder–decoder approach is that a neural network needs to be able to compress all the necessary information of a source sentence into a fixed-length vector."

Giải pháp — **RNNsearch**: đừng nén cả câu vào một vector; giữ lại **một vector riêng cho mỗi từ nguồn** (annotation), rồi để decoder **nhìn lại** câu nguồn mỗi khi sinh một từ đích:

| Bước | Công thức | Ý nghĩa |
|---|---|---|
| 1. Annotation | `h_j` = nối hidden state xuôi + ngược của từ nguồn j (encoder hai chiều) | Mỗi từ nguồn có một bản tóm tắt riêng, nhấn mạnh ngữ cảnh quanh nó |
| 2. Chấm điểm (alignment model) | `e_ij = a(s_{i-1}, h_j)` — một mạng feed-forward nhỏ | Từ đích thứ i "hỏi": từ nguồn nào liên quan tới mình lúc này? |
| 3. Chuẩn hóa | `α_ij = softmax(e_ij)` | Trọng số attention, tổng bằng 1 — đọc được như xác suất căn chỉnh |
| 4. Trộn | `c_i = Σ_j α_ij · h_j` | **Mỗi từ đích có một context vector riêng**, xây lại từ đầu mỗi bước |

Kết quả trên WMT'14 En–Fr (so sánh trực tiếp, cùng cấu hình): RNNsearch-30 đạt **34.16 BLEU**, trong khi encoder–decoder cố định RNNencdec-30 chỉ **13.93 BLEU** — và RNNsearch **không sụt chất lượng trên câu ≥ 50 từ**, nơi model cố định trôi nghĩa sau khoảng 30 từ. Mô hình dài hơn (train lâu hơn) đạt 36.15 BLEU, ngang/vượt Moses SMT (35.63).

Đây là **lần đầu attention xuất hiện trong NLP** — và là mắt xích nối thẳng tới khóa 131/134:

- Bahdanau attention là **additive attention** (điểm số tính bằng mạng feed-forward nhỏ); Transformer (2017) đổi sang **scaled dot-product attention** (`softmax(QKᵀ/√d_k)V`) — nhanh hơn, song song được.
- Trong Transformer, bước 2–4 ở trên chính là **cross-attention** ở lớp thứ 2 của decoder (cheat-sheet §2): Query từ decoder, Key/Value từ đầu ra encoder. Nói cách khác, **Transformer không phát minh attention — nó lấy attention của Bahdanau làm toàn bộ kiến trúc** (bỏ hẳn RNN).
- Trọng số `α_ij` còn cho một lợi ích phụ quý giá: **giải thích được** — vẽ ma trận attention là thấy model đang căn chỉnh từ nào với từ nào, một trong những công cụ interpretability đầu tiên của NLP neural.

Sau Bahdanau còn có Luong attention (Luong et al., 2015): thay alignment model bằng dot-product (nhân trực tiếp), rẻ hơn; và hai biến thể global/local attention. Nguyên lý chung không đổi: **context động theo từng bước sinh, thay vì một vector tĩnh**.

## 3. Train và sinh — teacher forcing, beam search, exposure bias

Khóa dạy cả hai nửa: train như thế nào và sinh (decode) như thế nào — hai nửa này **không giống nhau**, và sự khác biệt đó là nguồn gốc của một lỗi kinh điển.

### 3.1. Train: teacher forcing

Lúc train, decoder được cho **từ đích thật** ở mỗi bước làm đầu vào bước sau (dù nó vừa dự đoán sai ở bước trước) — gọi là **teacher forcing**. Lợi ích: train song song được, hội tụ nhanh, loss ổn định. Đây là cách mọi model seq2seq/Transformer vẫn train tới nay (kể cả Gemini, GPT — loss next-token prediction chính là teacher forcing ở quy mô lớn).

### 3.2. Sinh (inference): tự hồi tiếp

Lúc dùng thật, không có từ đích thật — decoder phải ăn **chính từ nó vừa sinh ra**. Hai chiến lược chọn từ:

| Chiến lược | Cách làm | Ưu / nhược |
|---|---|---|
| **Greedy decoding** | Mỗi bước lấy từ có xác suất cao nhất | Nhanh, đơn giản; dễ kẹt ở lựa chọn cục bộ tốt nhưng toàn cục dở |
| **Beam search** | Giữ B giả thuyết tốt nhất song song (B = beam size, bài seq2seq dùng 12), mở rộng từng bước, cuối cùng lấy chuỗi có tổng xác suất cao nhất | Tốt hơn hẳn greedy; tốn B lần tính toán; B quá lớn đôi khi lại cho câu ngắn, chung chung (vì xác suất tích lũy phạt câu dài — thường bù bằng length penalty) |

### 3.3. Exposure bias — cái giá của teacher forcing

Train thì decoder luôn thấy từ thật; dùng thật thì nó chỉ thấy từ do chính nó sinh — **một lỗi nhỏ ở đầu câu làm các bước sau lệch khỏi phân phối đã train, lỗi tích lũy**. Đây gọi là **exposure bias**. Cách giảm (nằm ngoài phạm vi khóa, ghi để biết):

- **Scheduled sampling** (Bengio et al., 2015): lúc train, trộn dần từ thật với từ model tự sinh theo lịch — càng về sau càng dùng nhiều từ tự sinh.
- **Beam search lúc train / reinforcement learning:** tối ưu trực tiếp metric cuối (BLEU/ROUGE) thay vì chỉ cross-entropy từng từ.
- Thực tế hiện nay: các LLM vẫn train bằng teacher forcing thuần và chấp nhận exposure bias — vì ở quy mô lớn, dữ liệu nhiều + decoding tốt (sampling, beam) đã đủ bù.

## 4. Transformer là một encoder–decoder — khóa này khác gì khóa 134?

Điểm dễ nhầm mà khóa này làm rõ: **Transformer (2017) không phải kiến trúc đối lập với encoder–decoder — nó LÀ một encoder–decoder**, chỉ khác ở "ruột" bên trong:

| | Seq2seq RNN (2014) | Transformer (2017) |
|---|---|---|
| Encoder | LSTM đọc tuần tự | 6 lớp self-attention, song song |
| Decoder | LSTM, context vector `c` cố định | 6 lớp masked self-attention + cross-attention |
| Nối encoder–decoder | Một vector `c` duy nhất | Cross-attention: mỗi bước decoder nhìn lại toàn bộ encoder |
| Kết quả WMT'14 En–De | — (seq2seq đo En–Fr: 34.8) | **BLEU 28.4** En–De / 41.8 En–Fr, train 12h (base) |

Vậy khóa 136 khác khóa 134 ở chỗ: **134 dạy một thành viên cụ thể của họ (Transformer + BERT), 136 dạy cả họ** — định nghĩa chung (encoder nén → decoder sinh), cổ chai vector cố định, attention như lời giải, cách train/serve. Hiểu họ này rồi thì Transformer, T5, BART đều chỉ là các cách "điền ruột" khác nhau vào cùng một khung.

## 5. T5 — encoder–decoder lên tới 11 tỉ tham số

Đại diện hiện đại nhất của họ encoder–decoder trong khóa là **T5 (Text-to-Text Transfer Transformer)** — Raffel et al., "Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer" (arXiv:1910.10683, JMLR 2020):

- **Ý tưởng thống nhất:** mọi task NLP đều viết lại thành **text vào → text ra**, kèm một tiền tố task bằng text: dịch = `"translate English to German: ..."`, tóm tắt = `"summarize: ..."`, phân loại = `"sentiment: ..."` → đầu ra là text nhãn. Nhờ vậy **cùng một model, cùng một loss, cùng một cách decode cho mọi task** — không cần đầu phân loại riêng như BERT.
- **Pre-train — span corruption:** mask một đoạn liên tiếp (trung bình dài 3 token) trong câu, thay bằng một sentinel token, bắt model khôi phục lại đoạn đó. Khác MLM của BERT (mask từng token rời rạc, 134 §3.2) ở chỗ mask theo **đoạn** — model phải học cấu trúc dài hơn.
- **Dữ liệu — C4 (Colossal Clean Crawled Corpus):** ~750 GB text tiếng Anh đã làm sạch từ Common Crawl (lọc trùng lặp, bỏ câu dở, bỏ nội dung xấu/noisy). Bài báo chứng minh **chất lượng lọc quan trọng hơn kích thước thô**: bỏ bước lọc, GLUE tụt từ 83.28 → 81.46 và SuperGLUE từ 71.36 → 68.04.
- **Quy mô:** 5 cỡ — Small 60M, Base 220M, Large 770M, 3B (~2.8B), 11B tham số; bản 11B pre-train ~1 triệu bước, batch 2¹¹ chuỗi dài 512 (~1 nghìn tỉ token) trên TPU.

| Benchmark | T5-Base (220M) | T5-11B | Ghi chú |
|---|---|---|---|
| GLUE (trung bình) | 83.28 | **90.3** | SOTA thời đó |
| SuperGLUE (trung bình) | 71.36 | **88.9** | Gần điểm con người 89.8 |
| SQuAD (exact match, val) | 80.88 | **91.26** | |
| CNN/Daily Mail tóm tắt (ROUGE-2) | 19.24 | **21.55** | ROUGE-1 43.52 / ROUGE-L 40.69 |
| Dịch En–De / En–Fr / En–Ro (BLEU) | 26.98 / 39.82 / 27.65 | Không vượt SOTA dịch | Dịch là task duy nhất trong 24 task mà T5-11B không dẫn đầu |

Bài học phương pháp của T5 (quan trọng hơn cả con số): bài báo là một **khảo sát hệ thống** — đổi một yếu tố tại một thời điểm (kiến trúc, objective, dữ liệu, cách fine-tune, cách trộn multi-task, quy mô) và đo trên cùng bộ benchmark. Kết luận lớn nhất: **pre-train rồi fine-tune thắng multi-task thuần** (trộn đều các task lúc train làm GLUE tụt từ 83.28 → 76.13), và **lặp lại dữ liệu nhỏ nhiều lần làm hại model** (lặp 4096 lần: GLUE 76.34, SuperGLUE 59.29) — dữ liệu đa dạng quan trọng hơn số lần lặp.

Người anh em cùng họ đáng nhớ: **BART** (Lewis et al., 2019) — encoder–decoder Transformer pre-train bằng cách **làm nhiễu văn bản rồi khôi phục** (xáo trộn câu, xóa token…), mạnh ở tóm tắt/sinh; và **mT5 / NLLB** — cùng khung encoder–decoder cho dịch đa ngữ (NLLB của Meta dịch 200 ngôn ngữ, vẫn là encoder–decoder Transformer).

## 6. Lab walkthrough — sinh thơ bằng TensorFlow/Keras

Phần thực hành của khóa (chỉ xem walkthrough, không chạy lab GCP tốn credit theo checklist):

1. **Chuẩn bị dữ liệu:** tập thơ (cặp câu thơ), tokenize, thêm token bắt đầu/kết thúc câu, padding về cùng độ dài.
2. **Encoder:** lớp Embedding → LSTM/GRU, nén mỗi câu thơ thành hidden state cuối (chính vector `c` của §1).
3. **Decoder:** Embedding → LSTM/GRU khởi tạo bằng `c` → Dense + softmax sinh từng từ, train bằng teacher forcing (loss sparse categorical cross-entropy).
4. **Sinh thơ:** cho một câu mồi, decoder tự hồi tiếp sinh tiếp từng từ tới EOS (greedy hoặc sampling với temperature để thơ đa dạng hơn).

Giá trị của lab này không nằm ở bài thơ (model nhỏ, dữ liệu ít, thơ chỉ ở mức minh họa) mà ở chỗ nó **cho thấy toàn bộ khung encoder–decoder chạy được bằng vài chục dòng Keras** — cùng một khung đó, thay LSTM bằng Transformer và thay dữ liệu thơ bằng C4, sẽ ra T5. Đây cũng là khung của khóa 124 (image captioning: encoder CNN đọc ảnh → decoder sinh câu mô tả) — chứng tỏ encoder không nhất thiết phải đọc text: **bất cứ thứ gì nén được thành vector đều làm encoder được**.

## 7. Encoder–decoder khác gì BERT và GPT — bảng chốt

Nối bảng 3 họ ở 134 §5, thêm cột "điểm khác cốt lõi" mà khóa này làm rõ:

| Họ | Kiến trúc | Attention | Ví dụ | Mạnh ở | Khác cốt lõi (khóa 136) |
|---|---|---|---|---|---|
| **Encoder-only** | Chỉ encoder | Self-attention hai chiều | **BERT**, RoBERTa | **Hiểu:** phân loại, NLI, QA trích xuất, embedding | Không có decoder → không sinh chuỗi dài; đầu ra là vector/nhãn cho từng token |
| **Decoder-only** | Chỉ decoder | Masked self-attention | **GPT**, Llama, Gemini | **Sinh:** chat, viết, code | Không có encoder riêng → "điều kiện" chỉ là prompt nối vào đầu chuỗi; mọi thứ là tiếp nối text |
| **Encoder–decoder** | Cả hai, nối bằng cross-attention | Self + **cross** | **T5**, BART, Transformer 2017 | **Biến đổi:** dịch máy, tóm tắt, QA sinh đáp án | **Tách bạch** điều kiện (encoder đọc input) và sinh (decoder viết output); input/output độ dài độc lập, định dạng độc lập (ảnh→text cũng được) |

Hệ quả thực tế cho team (nối 134 §7.3, 119/121):

- **Tóm tắt / dịch / biến đổi có cấu trúc** (vd: tóm tắt chương truyện, dịch mô tả truyện Trung→Việt): họ encoder–decoder là lựa chọn đúng kiến trúc — decoder-only cũng làm được bằng prompt nhưng tốn context và khó kiểm soát định dạng đầu ra; encoder–decoder fine-tune nhỏ (T5-small 60M chạy local được) cho đầu ra đúng khuôn.
- **Phân loại bằng T5:** viết task thành text (`"classify genre: <mô tả>"` → `"tiên hiệp"`) — cùng một model vừa phân loại vừa tóm tắt được, đỡ phải maintain 2 model như cách BERT + tách riêng.
- **Đừng dùng encoder–decoder cho chat tự do:** decoder-only (Gemini) đã thắng ở đó vì train lượng text khổng lồ theo kiểu tiếp nối; T5-11B thua cả 3 task dịch trong chính bài báo của nó — scale + dữ liệu quan trọng hơn họ kiến trúc khi task mở.

## 8. Áp dụng được ngay cho việc chung

### 8.1. Nối khóa 124 (image captioning) — encoder không chỉ đọc text

Khóa 124 dạy captioning: encoder CNN đọc ảnh, decoder sinh câu. Khóa này cho khung tổng quát: **encoder = "đọc đầu vào thành vector", decoder = "viết đầu ra từ vector"** — đầu vào có thể là text, ảnh, âm thanh, bảng số liệu. Khi team gặp task "đầu vào dạng A, đầu ra dạng B khác hẳn", hỏi đầu tiên không phải "dùng model nào" mà là "encoder đọc A bằng gì, decoder viết B bằng gì" — đó là thiết kế kiến trúc, không phải chọn model có sẵn.

### 8.2. Nối khóa 129 (vector search) + 134 (BERT) — embedding từ encoder

T5 và BERT đều có encoder; vector `[CLS]` của BERT (§7.2 báo cáo 134) hay trung bình hidden state của encoder T5 đều làm embedding được. Khác biệt: embedding từ encoder của T5 đã được train để **phục vụ decoder sinh text**, nên nó giữ thông tin "viết lại được" tốt hơn — hữu ích khi cần embedding cho tóm tắt/tìm đoạn văn rồi sinh đáp án (RAG + generative QA, nối 129).

### 8.3. Nối khóa 120/123 (prompt design) — vì sao prompt của Gemini khác "tiền tố task" của T5

T5 dùng tiền tố task bằng text (`"summarize: ..."`) — trông giống prompt, nhưng bản chất khác: tiền tố T5 được **fine-tune cùng model** nên model học thuộc ý nghĩa của nó; prompt của Gemini (decoder-only, zero-shot) dựa vào hiểu biết có sẵn, không train lại. Hệ quả: tiền tố T5 ổn định, rẻ, lặp lại giống nhau 100%; prompt Gemini linh hoạt nhưng dao động. Khi cần **đầu ra đúng khuôn, lặp lại ổn định** (gắn nhãn hàng loạt, tóm tắt theo mẫu cố định): fine-tune T5-small theo kiểu tiền tố task rẻ hơn và ổn định hơn prompt Gemini — ghi làm phương án cho các task xử lý hàng loạt trong vBook (chỉ là gợi ý, cần task riêng + quyết của Anh/muse-main theo §10).

### 8.4. Quy tắc chọn nhanh — bổ sung cheat-sheet

- **Hiểu → encoder (BERT); sinh → decoder (Gemini/GPT); biến đổi chuỗi→chuỗi → encoder–decoder (T5)** — 134 §7.3, nay đã đủ cả 3 họ với bằng chứng số liệu.
- **Input/output khác dạng nhau** (ảnh→text, text dài→text ngắn, ngôn ngữ A→B): nghĩ encoder–decoder trước.
- **Cần đầu ra đúng khuôn, lặp lại hàng loạt:** fine-tune encoder–decoder nhỏ (T5-small/base) thay vì prompt model lớn.

## 9. Đề xuất cập nhật skill

- **Không sửa skill vBook** trong task này (không có gì trong khóa đụng trực tiếp tới quy trình build extension).
- **Đã làm trong task này (theo đề xuất 134 §8):** bổ sung `research/CHEAT-SHEET-ATTENTION.md` §8 — encoder–decoder 1 trang: khung seq2seq, cổ chai + Bahdanau, teacher forcing/beam search/exposure bias, T5 (C4, span corruption, 5 cỡ, SuperGLUE 88.9), bảng 3 họ đầy đủ — để khóa sau dùng lại mà không học lại từ đầu.
- **Lưu ý cho các báo cáo sau:** khi nhắc "encoder–decoder" thì ghi rõ là họ kiến trúc (khung chung) hay một model cụ thể (T5, BART, Transformer 2017); khi nhắc "attention" trong họ này thì ghi rõ self / masked / cross (cheat-sheet §2); khi nhắc "context vector" thì ghi rõ là vector cố định (seq2seq 2014) hay context động theo từng bước (Bahdanau trở đi).

## 10. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa xem video gốc của khóa:** nội dung khóa nằm sau trang Skills Boost (video + quiz + lab walkthrough, cần đăng nhập tài khoản Google Cloud để học). Báo cáo này học qua mô tả chính thức của khóa + bài báo gốc (Sutskever et al., 2014; Bahdanau et al., 2015; Raffel et al., 2019; Vaswani et al., 2017). Các điểm trong syllabus khớp hoàn toàn với mô tả khóa; các số liệu bài báo gốc đối chiếu trực tiếp với arXiv/NeurIPS.
- **Lab thơ chỉ xem walkthrough:** không chạy code TensorFlow/Keras và không chạy lab GCP (theo checklist — không tốn credit). Các bước lab §6 là tóm tắt từ mô tả walkthrough chính thức của khóa; nếu team thực sự chạy lại thì kiểm tra phiên bản TensorFlow/Keras trước khi chốt.
- **Phần §3.3 (exposure bias, scheduled sampling) và §5 (BART, NLLB) nằm ngoài phạm vi hẹp của video khóa** — lấy từ tài liệu chuẩn sau này, đã ghi rõ nguồn; khi team thực sự fine-tune T5 thì kiểm tra lại trên doc Hugging Face trước khi chốt.
- **Chênh lệch nhỏ giữa hai nguồn về BLEU Bahdanau:** bài báo gốc và các review trích 34.16 (RNNsearch-30) và 36.15 (model train lâu hơn, câu không có từ lạ); báo cáo lấy cả hai con số kèm điều kiện đo, không gộp làm một.
- **Chưa xác định:** hiệu quả thực tế của T5-small/base fine-tune trên mô tả truyện tiếng Trung (vBook) so với prompt Gemini — cần thực nghiệm nhỏ (so sánh trên vài chục mô tả thật) trước khi đề xuất thành task build; cùng dạng "chưa xác định" đã ghi ở 134 §9 cho BERT multilingual.

## Nguồn

- Trang khóa chính thức (Google Skills): https://www.skills.google/course_templates/543
- Trang khóa trên Coursera (cùng nội dung, ghi rõ 3 mục tiêu học tập): https://www.coursera.org/programs/la-triada-pyiv5/learn/encoder-decoder-architecture
- Bài báo gốc — "Sequence to Sequence Learning with Neural Networks" (Sutskever, Vinyals & Le, NIPS 2014): https://arxiv.org/abs/1409.3215
- Bài báo gốc — "Neural Machine Translation by Jointly Learning to Align and Translate" (Bahdanau, Cho & Bengio, ICLR 2015): https://arxiv.org/abs/1409.0473
- Bài báo gốc — "Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer" (Raffel et al., JMLR 2020): https://arxiv.org/abs/1910.10683
- Bài báo gốc — "Attention Is All You Need" (Vaswani et al., 2017): https://arxiv.org/abs/1706.03762
- Blog Google Research về T5 (C4, kết quả, Colab): https://research.google/blog/exploring-transfer-learning-with-t5-the-text-to-text-transfer-transformer/
- Báo cáo nối tiếp trong repo: `research/134-transformer-models-and-bert-model-google.md` (Transformer + BERT, bảng 3 họ), `research/131-attention-mechanism-google.md` (self-attention, công thức, 3 loại attention, O(n²)), `research/129-vector-search-and-embeddings-google.md` (embedding + vector search), `research/124-create-image-captioning-models-google.md` (captioning = encoder CNN + decoder), `research/120-prompt-design-in-vertex-ai-google.md` (prompt design), `research/CHEAT-SHEET-ATTENTION.md` (cheat-sheet 1 trang — bổ sung §8 trong task này).

## Kết luận

Khóa này ngắn (30 phút) nhưng là **khóa khóa sổ bản đồ 3 họ Transformer**: nó cho thấy mọi model ngôn ngữ hiện đại đều là một cách điền ruột vào cùng một khung — encoder đọc đầu vào thành biểu diễn, decoder viết đầu ra từ biểu diễn đó. Seq2seq 2014 chứng minh khung này thắng được cả hệ thống thống kê (BLEU 34.8 vs 33.3, chỉ bằng 2 LSTM và một vector cố định); Bahdanau 2015 chỉ ra cổ chai của vector cố định và sửa bằng attention — phát minh quan trọng nhất mà Transformer sau đó lấy làm toàn bộ kiến trúc; T5 2019 chứng minh cùng khung đó, scale lên 11B tham số trên 750 GB C4, đạt SuperGLUE 88.9, gần chạm điểm con người 89.8. Với team, giá trị mang về được ngay không nằm ở việc train encoder–decoder (không ai trong team train model), mà ở ba thứ: **khung tư duy "encoder đọc gì → decoder viết gì" để thiết kế task biến đổi (§8.1)**, **quy tắc chọn đúng họ model đã đủ cả 3 họ với số liệu (§7)**, và **phương án fine-tune T5 nhỏ cho xử lý hàng loạt đúng khuôn, rẻ và ổn định hơn prompt model lớn (§8.3)** — cộng một cheat-sheet đã đủ cả 3 họ để khóa sau không phải học lại từ đầu.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** **Introduction to Vertex AI Studio** — khóa tiếp theo trong chương trình 10 khóa, nối trực tiếp khóa này (từ hiểu kiến trúc sang dùng công cụ: Vertex AI Studio là nơi team đã dùng Gemini API ở task 121). Sau đó còn lại trong chương trình: Responsible AI for Developers (Fairness & Bias, Interpretability & Transparency, Privacy & Safety), Inspect Rich Documents with Gemini Multimodality and Multimodal RAG, MLOps for Generative AI.
