# Attention Mechanism (Google) — Báo cáo tự học (task 131)

- **Khóa học:** Attention Mechanism, Google Cloud Skills Boost (thuộc learning path Generative AI for Developers — chương trình 10 khóa Advanced Generative AI for Developers)
- **Trang khóa:** Google Skills: https://www.skills.google/paths/183/course_templates/537
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 131). **Không chạy lab GCP tốn credit** — khóa này là microlearning thuần video/lý thuyết, không có lab đi kèm (khác các khóa 121/126/129 có lab Skills Boost). Học qua trang khóa chính thức, ghi chú khóa của Mete Atamel (Developer Advocate, Google), bài gốc "Attention Is All You Need" (Vaswani et al., 2017) và bài "The Illustrated Transformer" (Jay Alammar).
- **Quy mô khóa:** ~45 phút (trang khóa ghi 30 phút), trình độ Intermediate, miễn phí; xuất bản 2024-06-25; rating 4.18/5 (278 reviews). Không có assignment chấm điểm.
- **Vị trí trong vòng tự học:** khóa 9 theo phân vai (sau 129 Vector Search and Embeddings). Đây là **khóa nền của toàn bộ vòng**: mọi khóa trước đều *dùng* attention mà chưa từng học riêng nó — 129 nhắc self-attention tạo embedding theo ngữ cảnh, 122 dùng cross-attention đưa prompt text vào diffusion, 124 dùng attention trộn ảnh + chữ khi sinh caption. Khóa này mổ xẻ đúng cơ chế đó. Khóa tiếp theo trong chương trình (chị cả quyết theo §10): Transformer Models and BERT Model — nối trực tiếp khóa này.

## Cấu trúc khóa (syllabus)

| Phần | Nội dung chính |
|---|---|
| Vấn đề của encoder-decoder RNN | Cổ chai vector cố định: câu càng dài, dịch càng tệ |
| Attention trong encoder-decoder | Decoder "nhìn lại" toàn bộ encoder states, chọn phần cần thiết ở mỗi bước sinh từ |
| Self-attention | Mỗi từ tự "nhìn" các từ khác trong cùng câu để hiểu ngữ cảnh |
| Ứng dụng | Dịch máy, tóm tắt văn bản, hỏi–đáp |

Bốn mục tiêu học tập chính thức của khóa (theo trang Skills Boost): giới thiệu attention mechanism — kỹ thuật cho mạng neural tập trung vào những phần cụ thể của chuỗi đầu vào; học cách attention hoạt động; học cách dùng nó để cải thiện dịch máy, tóm tắt văn bản và hỏi–đáp.

## 1. Vì sao cần attention — cổ chai của encoder-decoder RNN

### 1.1. Mô hình cũ: nén cả câu vào một vector

Encoder-decoder RNN truyền thống (Sutskever et al., 2014; Cho et al., 2014) làm việc theo 2 bước:

1. **Encoder** đọc từng từ của câu nguồn, cập nhật hidden state; đến cuối câu chỉ còn **một vector duy nhất** (hidden state cuối, `c = h_T`) được đưa sang decoder.
2. **Decoder** dùng đúng vector đó để sinh từng từ của câu đích.

Vấn đề: một câu 10 từ và một đoạn 60 từ đều phải nén vào cùng một vector có kích thước cố định. Bahdanau, Cho & Bengio (2014) chỉ ra đây là **cổ chai thông tin** — chất lượng dịch (BLEU) giữ được với câu ngắn nhưng **tụt mạnh khi câu nguồn dài lên**, vì vector cố định đơn giản là hết chỗ chứa. Đây cũng là lý do RNN khó học phụ thuộc xa: thông tin từ đầu câu phải "sống sót" qua hàng chục bước cập nhật hidden state mới tới được decoder.

### 1.2. Cách sửa của Bahdanau (2014) — đừng nén, hãy để decoder tự tìm

Thay vì vứt bỏ các hidden state trung gian sau khi encoder đọc xong, **giữ lại tất cả** `h_1, h_2, …, h_T` (mỗi `h_j` là một "annotation" — thông tin của cả câu, tập trung mạnh quanh từ thứ j), và ở **mỗi bước sinh từ đích**, decoder tự quyết định xem phần nào của câu nguồn là quan trọng nhất lúc đó. Hai điểm khác biệt căn bản so với seq2seq truyền thống (đúng như khóa Google dạy):

1. Truyền **nhiều hidden state** từ encoder sang decoder, không chỉ state cuối.
2. Thêm **một bước attention** trong decoder trước khi sinh output.

## 2. Bahdanau attention — attention cộng (additive attention)

### 2.1. Ba bước tính ở mỗi bước giải mã

Ở bước sinh từ đích thứ `t`, với state decoder trước đó `s_{t-1}` và các annotation encoder `h_j`:

| Bước | Công thức | Ý nghĩa |
|---|---|---|
| 1. Chấm điểm căn chỉnh (alignment score) | `e_{t,j} = v_aᵀ · tanh(W_a·s_{t-1} + U_a·h_j)` | Một mạng feed-forward nhỏ ("alignment model") chấm xem state decoder hiện tại "khớp" với từ nguồn thứ j đến mức nào |
| 2. Chuẩn hóa thành trọng số | `α_{t,j} = exp(e_{t,j}) / Σ_k exp(e_{t,k})` | Softmax: các trọng số cộng lại bằng 1 — tức là "phần trăm sự chú ý" dành cho từng từ nguồn |
| 3. Vector ngữ cảnh | `c_t = Σ_j α_{t,j} · h_j` | Trung bình có trọng số của mọi encoder state — từ nào được chấm cao thì đóng góp nhiều |

`c_t` được tính **mới hoàn toàn ở mỗi bước giải mã**, nên model chú ý vào một phần khác nhau của câu nguồn cho mỗi từ đích nó viết ra. Ví dụ dịch Anh → Pháp: khi sinh từ "chat" (mèo), trọng số tập trung vào từ "cat" trong câu nguồn; khi sinh từ tiếp theo, trọng số dịch chuyển sang từ khác.

### 2.2. Hai tính chất làm nên sức mạnh

- **Soft alignment, học end-to-end:** `α_{t,j}` có thể đọc như "xác suất từ đích t được dịch từ từ nguồn j". Toàn bộ cơ chế khả vi, nên alignment model được train chung với cả hệ thống bằng backpropagation thông thường — **không cần bước căn chỉnh riêng** như dịch máy thống kê truyền thống. Đây là điểm mà bài báo nhấn mạnh: alignment không còn là biến ẩn phải suy luận riêng, mà là một phép tính trực tiếp trong mạng.
- **Bidirectional annotations:** encoder đọc câu cả hai chiều (xuôi + ngược), nên mỗi `h_j` chứa thông tin của từ j *trong ngữ cảnh cả câu*, không chỉ từ j đứng một mình.

### 2.3. Luong attention — attention nhân (multiplicative, 2015)

Một năm sau Bahdanau, Luong et al. đề xuất cách chấm điểm đơn giản hơn: thay mạng tanh bằng **tích vô hướng** (dot product) giữa state decoder và encoder state — `e_{t,j} = s_{t-1}ᵀ · h_j` (hoặc qua một ma trận học được: `sᵀ·W·h`). Rẻ hơn, nhanh hơn, và chính là tiền thân trực tiếp của công thức scaled dot-product mà Transformer dùng (§3). Khóa Google chỉ dạy dạng Bahdanau; ghi thêm Luong ở đây vì nó là cầu nối lịch sử sang Transformer.

## 3. Self-attention — từ "decoder nhìn encoder" sang "mỗi từ nhìn mọi từ"

### 3.1. Ý tưởng

Bahdanau attention là **cross-attention**: một chuỗi (decoder) truy vấn một chuỗi khác (encoder). **Self-attention** (Vaswani et al., 2017) tổng quát hóa ý tưởng đó: mỗi từ trong *cùng một câu* tự truy vấn mọi từ khác trong câu để "nướng" ngữ cảnh vào vector của chính nó. Đây chính là cơ chế mà báo cáo 129 nhắc tới mà chưa mổ xẻ: cùng từ "bank" trong "river bank" và "bank account" cho hai embedding khác nhau — vì self-attention cho "bank" nhìn thấy "river" ở câu một và "account" ở câu hai trước khi quyết định vector của nó.

Ví dụ kinh điển (Jay Alammar): câu "The animal didn't cross the street because it was too tired" — khi model xử lý từ "it", self-attention cho phép nó gắn "it" với "animal" (chứ không phải "street"), vì "animal" mới là thứ "mệt". Không có self-attention, vector của "it" đứng một mình sẽ không biết nó chỉ cái gì.

### 3.2. Query – Key – Value: ba vai trò của mỗi từ

Mỗi vector đầu vào (embedding của một từ) được nhân với **ba ma trận học được** để tạo ra ba vector mới:

| Vector | Vai trò | Hỏi theo kiểu tra cứu |
|---|---|---|
| **Query (Q)** | Từ này đang *tìm gì* | "Tôi cần thông tin loại nào?" |
| **Key (K)** | Từ này *cung cấp gì* — nhãn để người khác đối chiếu | "Tôi có thông tin loại này" |
| **Value (V)** | Nội dung thật mà từ này *chuyển đi* nếu được chú ý tới | "Đây là nội dung của tôi" |

Phép so sánh Query–Key là **tích vô hướng**: Q và K càng cùng hướng thì điểm càng cao — tức là từ đang xử lý càng "muốn" thông tin từ từ kia. (Cùng phép toán dot product mà báo cáo 129 dùng để đo độ tương tự cosine giữa các embedding — attention và vector search dùng chung một phép đo "gần nhau về nghĩa".)

### 3.3. Công thức — Scaled Dot-Product Attention

Bốn bước, cho mọi vị trí cùng lúc dưới dạng ma trận (Q, K, V mỗi cái một hàng cho một token):

```
Attention(Q, K, V) = softmax( Q·Kᵀ / √d_k ) · V
```

1. **Chấm điểm:** `Q·Kᵀ` — tích vô hướng của mỗi query với mọi key.
2. **Chia tỷ lệ (scale):** chia cho `√d_k` (căn bậc hai của chiều vector key). Lý do: khi `d_k` lớn, tích vô hướng có phương sai lớn, giá trị tuyệt đối phình ra, softmax bị đẩy về vùng bão hòa (gần 0 hoặc 1) và gradient biến mất. Chia cho `√d_k` giữ điểm số trong vùng softmax còn "mềm", gradient còn chảy được. Trong bài báo gốc `d_k = 64` nên hệ số chia là 8.
3. **Softmax:** thành trọng số cộng lại bằng 1 trên mỗi hàng.
4. **Trung bình có trọng số của Value:** output là hỗn hợp các V, từ nào được chấm cao thì đóng góp nhiều.

### 3.4. Ví dụ tính tay — ba token "the cat sat"

Để thấy công thức không phải phép màu, tính tay một trường hợp nhỏ (số liệu minh họa theo bài "Attention: how tokens look at each other"):

- Query của "sat" là `[1, 2]`; key của "the" `[0, 1]`, "cat" `[2, 1]`, "sat" `[1, 0]`.
- Điểm: `q·k = [2, 4, 1]` ("the" 2, "cat" 4, "sat" 1).
- Chia `√2`: `[1.41, 2.83, 0.71]`.
- Softmax: `[0.18, 0.73, 0.09]` — "sat" dành **73% sự chú ý cho "cat"** (đúng: chính con mèo là thứ đang ngồi).
- Output = `0.18·V("the") + 0.73·V("cat") + 0.09·V("sat")` — vector mới của "sat" giờ mang nặng thông tin của "cat".

Đọc ma trận trọng số attention theo cách này là một công cụ **giải thích được model** (interpretability): nhìn xem từ nào chú ý tới từ nào thì biết model đang "nghĩ" gì — dùng được khi debug prompt hay khi kiểm tra vì sao một câu trả lời RAG trích sai nguồn (§9.3).

### 3.5. Multi-head attention — nhiều "đầu" nhìn nhiều khía cạnh

Thay vì chạy self-attention một lần duy nhất, Transformer chạy nó **song song nhiều lần** (nhiều "head"), mỗi head có bộ ma trận Q/K/V riêng, rồi nối các kết quả lại:

- Bài báo gốc: `d_model = 512`, **8 heads**, mỗi head `d_k = d_v = 64` (512/8). Tổng chi phí tính toán tương đương một attention duy nhất ở chiều 512 — chia nhỏ không tốn thêm.
- Vì sao cần nhiều head: mỗi head học được một kiểu quan hệ khác nhau. Head này học quan hệ chủ–vị ("cat" ↔ "sat"), head kia học quan hệ đại từ ("it" ↔ "animal"), head khác học vị trí kề nhau. Một head duy nhất buộc phải trộn tất cả các kiểu quan hệ đó vào một bộ trọng số — mất thông tin.
- Sau mỗi lớp attention là một mạng feed-forward áp dụng riêng cho từng vị trí, cộng với residual connection + layer normalization ("Add & Norm").

### 3.6. Ba loại attention trong một Transformer đầy đủ

| Loại | Query từ | Key/Value từ | Vai trò |
|---|---|---|---|
| Encoder self-attention | Encoder | Encoder (cùng câu nguồn) | Hiểu câu nguồn theo ngữ cảnh |
| Decoder masked self-attention | Decoder | Decoder (phần đã sinh) | Hiểu phần câu đích đã viết — có **causal mask**: che các từ tương lai (đặt điểm = −∞ trước softmax → trọng số đúng 0) để model không "nhìn trộm" đáp án khi train |
| Encoder-decoder (cross) attention | Decoder | Encoder | Mỗi bước sinh từ đích, "hỏi" lại câu nguồn — chính là Bahdanau attention viết lại bằng Q/K/V |

### 3.7. Positional encoding — attention không biết thứ tự

Self-attention nhìn mọi từ cùng lúc nên **tự nó không biết từ nào đứng trước từ nào** ("cat sat" và "sat cat" cho cùng một tập vector). Transformer bù lại bằng **positional encoding** cộng vào embedding đầu vào: bài báo gốc dùng hàm sin/cos với tần số khác nhau cho từng chiều (`PE(pos,2i) = sin(pos/10000^(2i/d_model))`, `PE(pos,2i+1) = cos(...)`). Nhờ đó model phân biệt được vị trí, mà vẫn suy ra được khoảng cách tương đối giữa các từ.

### 3.8. Vì sao Transformer thắng RNN — bảng độ phức tạp (bài báo gốc)

| Lớp | Độ phức tạp/lớp | Số bước tuần tự | Đường dài nhất giữa 2 từ |
|---|---|---|---|
| Self-attention | O(n²·d) | **O(1)** | **O(1)** |
| RNN | O(n·d²) | O(n) | O(n) |
| CNN (kernel k) | O(k·n·d²) | O(1) | O(log_k n) |

Hai siêu năng lực của self-attention: **mọi token tính song song** (O(1) bước tuần tự → train nhanh hơn nhiều trên GPU) và **mọi cặp từ nối nhau trong 1 bước** (O(1) đường dài nhất → không còn hiện tượng thông tin "phai" qua nhiều bước như RNN). Cái giá phải trả là O(n²) theo độ dài chuỗi — ma trận attention n×n phình theo bình phương độ dài, và đó là đúng điểm mà FlashAttention (§7) ra đời để xử lý.

### 3.9. Kết quả bài báo gốc — "Attention Is All You Need" (Vaswani et al., 2017)

- **28.4 BLEU** trên WMT 2014 English→German — vượt kỷ lục cũ (kể cả ensemble) hơn 2 BLEU.
- **41.8 BLEU** trên WMT 2014 English→French — kỷ lục single-model lúc đó, train trong **3.5 ngày trên 8 GPU** (một phần nhỏ chi phí train của các model tốt nhất thời đó).
- Kiến trúc: 6 lớp encoder + 6 lớp decoder; bản base 65M tham số, bản big 213M tham số. Tác giả: Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Lukasz Kaiser, Illia Polosukhin (Google). ArXiv 1706.03762, nộp 12/06/2017.

## 4. Attention trong diffusion và captioning — nối task 122/124

Khóa Google chỉ dạy attention cho text, nhưng cùng một cơ chế xuất hiện trong hai khóa team đã học — và đây là chỗ nối quan trọng nhất của báo cáo này:

- **Task 122 (sinh ảnh — diffusion):** trong U-Net của diffusion model, **cross-attention** là cầu nối đưa prompt text vào quá trình khử nhiễu ảnh. Query lấy từ feature map ảnh đang được tạo, Key/Value lấy từ embedding của prompt text — mỗi vùng ảnh "hỏi" xem từ nào trong prompt liên quan tới nó ("mèo" thì vùng vẽ mèo chú ý tới token "mèo"). Không có cross-attention, model sinh ảnh không biết prompt nói gì. (Stable Diffusion gọi đúng tên lớp này là `CrossAttention`.)
- **Task 124 (mô tả ảnh — captioning):** decoder sinh caption dùng attention để **trộn thông tin ảnh + chữ**: ở mỗi bước sinh từ, attention quét các vùng ảnh (feature vector từ encoder InceptionResNetV2) và chọn vùng liên quan nhất tới từ sắp viết — sinh từ "mèo" thì nhìn vùng có con mèo. Đây là Bahdanau attention áp cho ảnh thay cho câu nguồn.
- **Quy luật chung rút ra:** attention là **cơ chế "truy vấn có chọn lọc" dùng chung cho mọi modality** — Query là "tôi đang cần gì", Key/Value là "kho thông tin có gì". Text hỏi text (self-attention), text hỏi ảnh, ảnh hỏi text — chỉ đổi nguồn của K/V, công thức không đổi.

## 5. Attention là retrieval chạy trong model — nối task 127/129

Đây là khung suy nghĩ mang về được nhiều nhất cho việc chung. Đặt attention cạnh vector search (task 129) sẽ thấy chúng là **cùng một hình dạng**:

| | Vector search / RAG (task 129) | Self-attention (khóa này) |
|---|---|---|
| Câu hỏi | Query text của người dùng | Query vector của token đang xử lý |
| Kho cần tìm | Các chunk tài liệu đã nhúng | Các token khác trong câu (Key của chúng) |
| Đo độ khớp | Dot product / cosine giữa query embedding và document embedding | Dot product Q·Kᵀ (rồi chia √d_k) |
| Kết quả trả về | Top-K chunk, đưa vào prompt | Trung bình có trọng số của Value — đưa vào lớp tiếp theo |
| Ai chọn | Code bên ngoài model chọn rồi đưa vào prompt | Chính model chọn, trong lúc chạy, ở mọi lớp |

Nói gọn: **attention là retrieval, nhưng chạy bên trong model, ở mọi lớp, với query được học ra từ chính dữ liệu**. Còn RAG là retrieval chạy bên ngoài model, một lần, với query do người dùng viết. Hiểu được điểm này thì hiểu vì sao:

- **Embedding tốt thì attention mới tốt:** attention chấm điểm bằng dot product trên vector — đúng như task 129 đã dặn, vector phải được nhúng đúng `task_type` hai phía, không thì điểm chấm lệch mà không báo lỗi.
- **Chunk một ý (task 129 §1.3) cũng là bài học của attention:** một Value mang nhiều ý lẫn lộn thì trung bình có trọng số cũng lẫn lộn — càng chia nhỏ, attention càng chọn chính xác.
- **Giới hạn context window của LLM chính là giới hạn của attention:** ma trận n×n tăng theo bình phương độ dài (§3.8) — vì vậy model không thể "đọc" vô hạn, và RAG tồn tại để bù đúng chỗ đó: thay vì nhồi cả kho vào context (đắt theo n²), chỉ đưa top-K chunk liên quan nhất vào.

## 6. Giới hạn và cạm bẫy thực hành

- **O(n²) là trần thật:** câu dài gấp đôi thì ma trận attention lớn gấp bốn lần. Đây là lý do mọi model đều có context window hữu hạn, và là lý do tồn tại cả một ngành tối ưu attention (§7).
- **Attention không phải lúc nào cũng "hiểu":** trọng số cao không đồng nghĩa model "hiểu" quan hệ đó — có head chú ý mạnh vào dấu câu, từ đệm, token đầu câu (hiện tượng "attention sink": token đầu tiên hút một phần trọng số lớn một cách ổn định, gần như làm "bãi đỗ" cho phần attention thừa). Đọc attention map để debug thì được, nhưng đừng đọc nó như bằng chứng duy nhất rằng model đã hiểu đúng.
- **Hiện tượng "lost in the middle":** với context rất dài, model nhớ tốt thông tin ở đầu và cuối, kém hẳn thông tin ở giữa — vì attention bị pha loãng trên quá nhiều token. Hệ quả thực hành cho prompt/RAG (nối task 120/123): **đặt thông tin quan trọng nhất ở đầu hoặc cuối prompt/context**, đừng chôn ở giữa một context dài.
- **Softmax có thể "quá tự tin":** nếu một điểm số vượt trội hẳn, softmax đẩy trọng số về gần 1 cho một token duy nhất và gần 0 cho tất cả token còn lại — model effectively chỉ nhìn một từ. Chia tỷ lệ √d_k (§3.3) giảm hiện tượng này lúc train, nhưng lúc inference với phân phối lạ nó vẫn xảy ra.
- **Mask là luật, không phải gợi ý:** causal mask (§3.6) là thứ duy nhất ngăn model nhìn trộm tương lai khi train; quên mask (hoặc mask sai) là lỗi câm — model train loss rất đẹp nhưng sinh ra toàn câu vô nghĩa vì lúc sinh thật không có tương lai để nhìn.

## 7. Sau khóa học — attention đã tiến hóa thế nào (ngoài phạm vi khóa, ghi nhận 2026)

Khóa Google dạy attention ở dạng 2017. Từ đó tới nay, mọi cải tiến lớn đều xoay quanh **cái giá O(n²)** (§3.8):

| Cải tiến | Năm | Giải quyết gì |
|---|---|---|
| FlashAttention (Dao et al.) | 2022 | **Exact attention, không đổi kết quả** — chia Q/K/V thành tile vừa SRAM, dùng online softmax, không bao giờ ghi ma trận n×n ra HBM; nhanh hơn 2–4×, bộ nhớ O(N) thay vì O(N²). FlashAttention-2 (2023) nhanh gấp ~2× nữa; FlashAttention-3 (2024) cho Hopper |
| Multi-Query Attention — MQA (Shazeer) | 2019 | Mọi query head **chia chung 1 head K/V** → KV cache khi sinh text giảm còn 1/H. Dùng trong PaLM, Falcon |
| Grouped-Query Attention — GQA (Ainslie et al.) | 2023 | Nằm giữa MHA và MQA: G nhóm K/V chia cho các query head — gần như không mất chất lượng, KV cache giảm theo tỷ lệ nhóm. **Chuẩn hiện nay: Llama 2/3, Mistral, Gemma đều dùng GQA** |
| KV cache + PagedAttention (vLLM) | 2023 | Khi sinh token tự hồi quy, cache lại K/V đã tính thay vì tính lại; PagedAttention quản lý cache theo block như bộ nhớ ảo của hệ điều hành |
| Sliding window attention (Mistral) | 2023 | Mỗi token chỉ chú ý tới cửa sổ W token gần nhất → O(n·W) thay vì O(n²), vẫn giữ được context dài nhờ xếp chồng nhiều lớp |
| RoPE — Rotary Position Embedding | 2021 | Thay positional encoding sin/cos tuyệt đối (§3.7) bằng cách xoay vector theo vị trí tương đối — chuẩn của LLM hiện đại |

Điểm cần nhớ: **FlashAttention không làm attention rẻ hơn về mặt toán học** (vẫn O(n²) phép tính) — nó làm attention rẻ hơn về mặt **di chuyển dữ liệu** (không ghi ma trận n×n ra bộ nhớ chậm). Còn KV cache thì không giảm được bằng FlashAttention — muốn giảm cache phải dùng GQA/MQA hoặc quantize cache.

## 8. Áp dụng được ngay cho việc chung

### 8.1. Nối task 129 — attention giải thích vì sao embedding "có ngữ cảnh"

Báo cáo 129 kết luận "ngữ cảnh làm thay đổi vector" nhưng chưa nói *cơ chế nào* làm việc đó. Khóa này trả lời: **self-attention là cơ chế đó**. Mỗi token lấy trung bình có trọng số của Value các token xung quanh, nên vector cuối cùng của một từ đã chứa thông tin của cả câu. Từ nay khi báo cáo nào nhắc "embedding theo ngữ cảnh" thì cơ chế đứng sau là self-attention — không còn là hộp đen.

### 8.2. Nối task 120/123 (prompt design) — hai quy tắc rút ra từ cơ chế

1. **Đặt thông tin quan trọng ở đầu/cuối, không chôn ở giữa** (§6, "lost in the middle") — đặc biệt khi prompt dài hoặc khi RAG đưa nhiều chunk vào context.
2. **Ngắn và một ý thì attention tập trung hơn** — prompt càng dài, trọng số attention càng bị pha loãng trên nhiều token; câu hỏi gọn, một nhiệm vụ một lần (đúng quy tắc task 120 đã dạy) không chỉ là "lịch sự với model" mà là hệ quả trực tiếp của softmax trên nhiều token.

### 8.3. Nối task 127 (bộ nhớ agent) — attention map là công cụ debug bộ nhớ

Khi agent trả lời sai vì "nhớ sai", có hai nghi phạm: store tìm sai mục nhớ (retrieval ngoài model — task 127/129) hay model chú ý sai trong các mục đã tìm đúng (attention trong model — khóa này). Phân biệt được hai lớp này thì mới biết sửa ở đâu: sửa store (chunk, `task_type`, rerank) hay sửa prompt (đưa mục nhớ quan trọng lên đầu context, §8.2). Đây là khung chẩn đoán dùng được ngay cho các task agent sau này, không cần code mới.

### 8.4. Nối task 126 — tab "App multimodal" trong demo Streamlit vẫn để mở

Đề xuất ở 129 §9.3 giữ nguyên: tab demo có thể cho người dùng gõ câu text để tìm ảnh trong kho (nhờ multimodal embedding, task 129 §8). Khóa này cho thêm đúng viên gạch còn thiếu: **cross-attention là cách model "dịch" giữa text và ảnh** — tab đó về bản chất là demo cross-attention chạy ở phía ứng dụng. Đề xuất vẫn ở trạng thái "mở, chờ task build riêng", không làm trong task tự học.

### 8.5. Áp dụng cho vBook (gợi ý, chưa phải quyết định)

- **Tìm truyện theo nghĩa** (đã gợi ý ở 129 §9.4): semantic search trên embedding mô tả truyện. Khóa này bổ sung lý do kỹ thuật: embedding của mô tả truyện tốt chính là nhờ self-attention đã "nướng" ngữ cảnh vào từng từ mô tả — nên hai truyện cùng mô-típ nhưng diễn đạt khác nhau vẫn nằm gần nhau trong không gian vector.
- Cả hai ý trên chỉ là gợi ý cho chị cả cân nhắc; cần task riêng và quyết của Anh/muse-main trước khi làm (theo §10, hướng sản phẩm mới phải mang ra hỏi Anh).

## 9. Đề xuất cập nhật skill

- **Không sửa skill vBook** trong task này (không có gì trong khóa đụng trực tiếp tới quy trình build extension).
- **Đề xuất thêm 1 mục ngắn vào kho research chung** (muse-main quyết): "Attention cheat-sheet — 1 trang" — công thức `softmax(QKᵀ/√d_k)V`, bảng 3 loại attention (§3.6), bảng độ phức tạp (§3.8) và 2 quy tắc prompt (§8.2) — để task sau (đặc biệt là khóa tiếp theo **Transformer Models and BERT Model**) dùng lại mà không phải học lại từ đầu. Nếu chị cả đồng ý, Vịt sẽ viết mục này thành file `research/CHEAT-SHEET-ATTENTION.md` trong task sau.
- **Lưu ý cho các báo cáo sau:** từ nay khi báo cáo nào nhắc tới "attention", cần ghi rõ **loại nào trong 3 loại** (§3.6: self / masked self / cross) — vì ba loại khác nhau hoàn toàn về Query lấy từ đâu và Key/Value lấy từ đâu, mà hay bị gọi chung một tên "attention".

## 10. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa xem video gốc của khóa:** nội dung khóa nằm sau trang Skills Boost (video + quiz, cần đăng nhập tài khoản Google Cloud để học). Báo cáo này học qua mô tả chính thức của khóa + ghi chú chi tiết của Mete Atamel (người đã học hết khóa) + bài báo gốc + tài liệu minh họa chuẩn. Các điểm trong syllabus (§1–§3 đầu) khớp hoàn toàn với ghi chú của Atamel; các số liệu bài báo gốc đối chiếu trực tiếp với arXiv.
- **Phần §7 (FlashAttention, GQA, RoPE...) nằm ngoài phạm vi khóa 2017** — lấy từ tài liệu chuyên sâu 2022–2026, đã ghi rõ nguồn; khi team thực sự chọn kiến trúc thì kiểm tra lại trên doc của framework đang dùng (PyTorch SDPA / Hugging Face) trước khi chốt.
- **Ví dụ tính tay §3.4 là số liệu minh họa** (theo bài "Attention: how tokens look at each other"), không phải trọng số thật của một model đã train — dùng để hiểu cơ chế, không dùng để kết luận về hành vi của model cụ thể nào.
- **Chưa xác định:** mức độ "attention sink" và "lost in the middle" trên Gemini (model team đang dùng qua API) — các hiện tượng này được đo chủ yếu trên họ Llama/GPT; khi nào cần thì kiểm chứng bằng thực nghiệm nhỏ trên Gemini API free tier trước khi đưa thành quy tắc cứng.

## Nguồn

- Trang khóa chính thức (Google Skills): https://www.skills.google/paths/183/course_templates/537
- Ghi chú khóa (Mete Atamel, Developer Advocate — Google Cloud): https://atamel.dev/posts/2023/06-15_genai_learningpath_notes_part2/
- Bài báo gốc — "Attention Is All You Need" (Vaswani et al., 2017): https://arxiv.org/abs/1706.03762
- "The Illustrated Transformer" (Jay Alammar, 2018): https://jalammar.github.io/illustrated-transformer/
- Bahdanau attention — "Neural Machine Translation by Jointly Learning to Align and Translate" (Bahdanau, Cho & Bengio, 2014): https://arxiv.org/abs/1409.0473
- Bahdanau giải thích chi tiết: https://machinelearningmastery.com/the-bahdanau-attention-mechanism/
- Tính tay attention + causal mask: https://availitworld.org/en/lessons/attention/
- FlashAttention / GQA / KV cache (tổng hợp 2026): https://www.rugvailabs.com/tracks/track-05-transformers/attention-efficiency và https://octomind.run/blog/flash-attention
- FlashAttention-2 review: https://www.zhongzhuzhou.org/blog/2026-05-24-flashattention2-technical-review-en/
- Hành trình attention 2014 → 2024: https://ankitw497.github.io/visual_guide/attention-journey.html
- Báo cáo nối tiếp trong repo: `research/129-vector-search-and-embeddings-google.md` (embedding + vector search), `research/122-introduction-to-image-generation-google.md` (diffusion + cross-attention), `research/124-create-image-captioning-models-google.md` (captioning + attention), `research/127-long-term-agentic-memory-langgraph-deeplearning-ai.md` (store bộ nhớ agent), `research/120-prompt-design-in-vertex-ai-google.md` (prompt design), `research/RECIPE-SEMANTIC-SEARCH-FREE-TIER.md` (recipe semantic search free tier — đề xuất từ task 129, đã có trong repo).

## Kết luận

Khóa này ngắn (45 phút) nhưng là **khóa nền của cả vòng tự học**: nó trả lời câu hỏi mà mọi khóa trước đều để mở — *cơ chế nào khiến một từ "hiểu" được ngữ cảnh của nó*. Câu trả lời gọn trong một công thức: `Attention(Q, K, V) = softmax(QKᵀ/√d_k)V` — mỗi token hỏi mọi token khác bằng Query–Key, rồi lấy trung bình có trọng số của Value. Từ công thức đó mà ra: embedding có ngữ cảnh (task 129), cross-attention đưa prompt vào ảnh (task 122) và trộn ảnh với chữ khi sinh caption (task 124), multi-head cho model nhìn nhiều khía cạnh cùng lúc, và cả trần O(n²) khiến context window hữu hạn và RAG phải tồn tại. Với team, giá trị mang về được ngay không nằm ở việc train Transformer (không ai trong team train model), mà ở ba thứ: **khung "attention là retrieval trong model" (§5) để chẩn đoán lỗi agent đúng lớp, hai quy tắc prompt rút ra từ cơ chế (§8.2), và một cheat-sheet 1 trang để khóa tiếp theo (Transformer + BERT) không phải học lại từ đầu**.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** **Transformer Models and BERT Model** — khóa tiếp theo trong chương trình 10 khóa, nối trực tiếp khóa này (xếp chồng attention thành encoder/decoder hoàn chỉnh + BERT). Sau đó còn lại trong chương trình: Encoder-Decoder Architecture, Introduction to Vertex AI Studio, Responsible AI for Developers (Fairness & Bias, Interpretability & Transparency, Privacy & Safety), Inspect Rich Documents with Gemini Multimodality and Multimodal RAG, MLOps for Generative AI.
