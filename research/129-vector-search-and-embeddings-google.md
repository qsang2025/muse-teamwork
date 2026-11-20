# Vector Search and Embeddings (Google) — Báo cáo tự học (task 129)

- **Khóa học:** Vector Search and Embeddings, Google Cloud Training (thuộc chương trình Gemini Enterprise Agent Ready — GEAR; trên Coursera nằm trong Specialization "Prompt Design, Grounding, and RAG with Vertex AI")
- **Trang khóa:** Google Skills (skills.google): https://www.skills.google/paths/1284/course_templates/939 — bản mirror trên Coursera: https://www.coursera.org/learn/vector-search-and-embeddings
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 129). **Không chạy lab trên GCP tốn credit** — học kỹ nội dung qua trang khóa chính thức, lab GSP1202 công khai, và tài liệu gốc của Google (Text/Multimodal Embeddings API, Vector Search overview, ScaNN). Không đăng nhập làm lab (lab nằm sau nút Start Lab trên Skills Boost).
- **Quy mô khóa:** ~4 giờ, 1 module, trình độ Intermediate, miễn phí trên Skills Boost (hoàn thành nhận badge + điểm GEAR); xuất bản 2026-10-21; rating 4.46/5 (162 reviews) trên Skills Boost, 4.15/5 trên Coursera (3.693 học viên đã đăng ký). Có 1 assignment chấm điểm.
- **Vị trí trong vòng tự học:** khóa 8 theo phân vai, khóa tiếp theo do muse-main quyết theo §10(a) sau khi Vịt xong task 126. Vòng tự học đã đi hết: khái niệm (118–119) → viết prompt (120) → đóng thành app Streamlit (121) → sinh ảnh (122) → mô tả ảnh (124) → ghép app multimodal (126). Khóa này là **nấc nền tảng còn thiếu của cả vòng**: embedding là thứ mà task 127 dùng làm "động cơ" cho bộ nhớ dài hạn (store + tìm kiếm ngữ nghĩa) nhưng chưa từng được học riêng — và là nền của sinh ảnh/mô tả ảnh (122/124), vì ảnh và text chỉ "gặp nhau" được nhờ cùng sống trong một không gian vector.

## Cấu trúc khóa (syllabus)

| Phần | Nội dung chính |
|---|---|
| Vector search: khái niệm + công nghệ nền | Embedding là gì; vì sao tìm kiếm theo nghĩa khác tìm kiếm theo từ khóa; quy trình vector search end-to-end |
| Semantic search với Vertex AI Vector Search | Lab GSP1202: tạo text embedding → lưu JSON → upload GCS → tạo index → deploy → query |
| Grounded agents + RAG | Dùng retrieval để "neo" câu trả lời của LLM vào dữ liệu thật, giảm ảo giác |
| Hybrid search | Ghép tìm kiếm ngữ nghĩa (dense) với tìm kiếm từ khóa (sparse) trong một engine duy nhất |

Bốn mục tiêu học tập chính thức của khóa (theo trang Coursera): (1) giải thích quy trình vector search và công nghệ then chốt; (2) xây semantic search bằng vector embedding với Vertex AI Vector Search; (3) khám phá grounded agent và RAG để giảm ảo giác; (4) tạo hybrid search engine với Vertex AI Vector Search.

## 1. Embedding là gì — biến ý nghĩa thành tọa độ

### 1.1. Định nghĩa gọn

**Embedding** là một vector — một danh sách số thực có độ dài cố định — đại diện cho một mẩu dữ liệu (từ, câu, tài liệu, ảnh, video, đoạn code, sở thích người dùng). Hai mẩu dữ liệu **càng giống nhau về nghĩa thì hai vector càng gần nhau** trong không gian nhiều chiều. Toàn bộ khóa học xoay quanh một hệ quả duy nhất của định nghĩa này: **nếu ý nghĩa đã thành tọa độ, thì "tìm thứ giống nhau" trở thành bài toán hình học — tìm các điểm gần nhất**.

Ví dụ (theo tài liệu Google): vector của "mèo" gần vector của "chó" hơn vector của "ô tô", không phải vì hai từ có chữ cái chung, mà vì model đã học được chúng cùng xuất hiện trong ngữ cảnh giống nhau. Đây là điểm khác biệt căn bản với tìm kiếm từ khóa: từ khóa so khớp *chuỗi ký tự*, embedding so khớp *ngữ cảnh sử dụng*.

### 1.2. Ba cấp độ embedding text

| Loại | Đại diện cho | Dùng khi |
|---|---|---|
| Word embedding | Một từ | Hiểu quan hệ từ vựng (đồng nghĩa, trái nghĩa); nền tảng lịch sử (Word2Vec, GloVe) |
| Sentence embedding | Một câu / đoạn ngắn | So sánh câu hỏi với câu trả lời, phân loại, gom cụm |
| Document embedding | Cả tài liệu dài | Tìm kiếm trong kho tài liệu, RAG (mỗi chunk là một "tài liệu nhỏ") |

Khóa này làm việc chủ yếu ở cấp **sentence/document**: query của người dùng và từng tài liệu trong kho đều được nhúng thành vector rồi so sánh với nhau.

### 1.3. Hình học của ý nghĩa — ba điều cần nhớ

- **Vector nằm trên mặt cầu đơn vị:** embedding hiện đại (kể cả `gemini-embedding-001`) được chuẩn hóa L2, tức độ dài vector = 1. Toàn bộ "ý nghĩa" nằm ở *hướng* của vector, không nằm ở độ lớn. Hệ quả thực hành: so sánh bằng **cosine similarity** (góc giữa hai vector) là tự nhiên nhất, và dot product trên vector đã chuẩn hóa cho cùng thứ hạng với cosine.
- **Ngữ cảnh làm thay đổi vector:** model Transformer dùng self-attention — mỗi từ "nhìn" các từ xung quanh trước khi quyết định vector của nó. Cùng từ "bank" trong "river bank" và "bank account" cho hai vector khác nhau. Đây là lý do embedding của Google (họ Gecko, xem §2.3) vượt xa word embedding tĩnh kiểu Word2Vec.
- **Độ dài text làm loãng ý nghĩa:** một đoạn càng dài, vector của nó càng là "trung bình" của nhiều ý — hai tài liệu dài dễ giống nhau một cách vô nghĩa. Bài học thực hành rút ra (nối thẳng sang RAG ở §7): **chia nhỏ tài liệu thành chunk trước khi nhúng**, mỗi chunk một ý, đừng nhúng cả chương sách thành một vector.

## 2. Text Embeddings API — tạo vector bằng model của Google

### 2.1. Các model hiện có (tháng 11/2026)

| Model | Số chiều | Ghi chú |
|---|---|---|
| `gemini-embedding-001` | Tối đa 3072 | Model text embedding mới nhất, hợp nhất các model chuyên biệt cũ; hiệu năng tốt nhất trên cả tiếng Anh, đa ngữ và code |
| `text-embedding-005` | 768 | Thế hệ trước, vẫn dùng được |
| `text-multilingual-embedding-002` | 768 | Chuyên đa ngữ (100+ ngôn ngữ) |
| `gemini-embedding-2` (mới, 2026) | Tối đa 3072 | Model đa phương thức đầu tiên của Google (text + ảnh + video + audio + PDF trong cùng một không gian vector) — xem §8 |

Điểm mới quan trọng so với thời khóa 120–122: **`gemini-embedding-001` thay thế cả hai model cũ** — không còn phải chọn riêng model tiếng Anh hay model đa ngữ. Model cũng hỗ trợ **Matryoshka Representation Learning (MRL)**: qua tham số `output_dimensionality`, một vector 3072 chiều có thể cắt xuống 768 hoặc 1536 mà vẫn giữ được phần lớn chất lượng — đổi độ chính xác lấy tốc độ/bộ nhớ khi cần (ví dụ: prototype dùng 768 cho nhanh, production dùng 3072).

### 2.2. Giới hạn API cần nhớ (tài liệu chính thức)

- Mỗi request tối đa **250 input text**, tổng tối đa **20.000 token**; mỗi text riêng lẻ tối đa **2.048 token** — vượt quá sẽ bị **cắt lặng (autoTruncate = true mặc định)**, hoặc lỗi 400 nếu đặt `autoTruncate = false`. Với `gemini-embedding-001`, mỗi request qua REST chỉ nhận **1 input text** (SDK Python gom batch được).
- Hệ quả thực hành: pipeline nhúng tài liệu dài phải **chunk trước, rồi gom batch 100–250 chunk/request** — đừng gửi từng chunk một (chậm, tốn quota) cũng đừng gửi cả tài liệu (bị cắt lặng mà không biết).

### 2.3. `task_type` — tham số nhỏ, ảnh hưởng lớn

API bắt buộc chọn **mục đích sử dụng** của embedding, vì cùng một câu mà dùng làm *câu hỏi* hay làm *tài liệu* thì vector tối ưu là khác nhau (bài toán **asymmetric retrieval**: câu hỏi ngắn, tài liệu dài — hai phía không đối xứng):

| `task_type` | Dùng cho phía |
|---|---|
| `RETRIEVAL_QUERY` | Câu hỏi / câu truy vấn (mặc định nếu để trống) |
| `RETRIEVAL_DOCUMENT` | Tài liệu trong kho (kèm `title` tùy chọn để model hiểu rõ hơn) |
| `SEMANTIC_SIMILARITY` | So sánh hai text có giống nhau không |
| `CLASSIFICATION` | Phân loại text |
| `CLUSTERING` | Gom cụm text |
| `QUESTION_ANSWERING` / `FACT_VERIFICATION` | Trả lời câu hỏi / kiểm chứng sự thật |
| `CODE_RETRIEVAL_QUERY` | Tìm code |

**Lỗi kinh điển:** nhúng cả query lẫn tài liệu cùng một `task_type` (hoặc để mặc định cả hai phía) — retrieval vẫn chạy nhưng recall kém đi rõ rệt, mà lỗi này không báo lỗi nào cả, chỉ thấy kết quả tìm kiếm "dở một cách khó hiểu". Đây là chi tiết mà báo cáo 127 chưa nhắc tới nhưng mọi hệ thống dùng store đều phải làm đúng.

### 2.4. Mô hình Gecko — embedding được "chưng cất" từ LLM như thế nào

Tài liệu chuyên sâu của Google (discuss.google.dev) giải thích gốc gác của họ model này: **Gecko** (Lee et al., 2024) không train embedding từ nhãn người gán, mà dùng **knowledge distillation từ LLM**:

1. **LLM thầy sinh dữ liệu:** một LLM lớn (ví dụ Gemini 2.5 Pro) đọc một kho text chưa gán nhãn, dùng few-shot prompting để tự sinh ra các cặp (truy vấn ↔ tài liệu liên quan) đa dạng.
2. **Học contrastive (InfoNCE loss):** model embedding nhỏ (học trò) được train để kéo vector của cặp đúng lại gần nhau và đẩy cặp sai ra xa — trên dữ liệu tổng hợp đó.
3. Kết quả: một model nhỏ, nhanh, rẻ, nhưng "kế thừa" được hiểu biết ngôn ngữ của LLM thầy — và hiểu 100+ ngôn ngữ trong **cùng một không gian vector** (câu tiếng Việt và câu tiếng Anh cùng nghĩa nằm gần nhau).

Ý nghĩa với team: embedding không phải là "từ điển tra cứu" mà là **tri thức của LLM được nén thành tọa độ** — vì vậy nó mới dùng được cho tìm kiếm ngữ nghĩa đa ngữ, đúng nhu cầu kho tài liệu tiếng Việt + nguồn tiếng Trung/Anh của vBook.

### 2.5. Mẫu code hiện tại (SDK `google-genai` — theo chuẩn task 121/126, không dùng Vertex AI SDK cũ)

```python
from google import genai

client = genai.Client()  # Vertex AI: đặt GOOGLE_CLOUD_PROJECT, GOOGLE_GENAI_USE_VERTEXAI=True
resp = client.models.embed_content(
    model="gemini-embedding-001",
    contents=["Vector Search tìm tài liệu theo nghĩa, không theo từ khóa."],
    config={
        "task_type": "RETRIEVAL_DOCUMENT",
        "output_dimensionality": 768,  # cắt từ 3072 khi cần nhanh/nhẹ
    },
)
vector = resp.embeddings[0].values  # list[float], len 768
```

## 3. Vertex AI Vector Search — từ vector thành công cụ tìm kiếm

### 3.1. Pipeline 4 bước (đúng như lab dạy)

1. **Tạo embedding** cho mọi item trong kho — *bên ngoài* Vector Search (bằng Text Embeddings API, §2).
2. **Upload embedding lên Cloud Storage** dưới dạng file JSON (mỗi dòng: `id`, `embedding`, kèm metadata như tiêu đề/nội dung gốc để hiển thị kết quả).
3. **Tạo index và deploy lên endpoint** — Vector Search xây cấu trúc chỉ mục để tra cứu nhanh.
4. **Query:** nhúng câu hỏi bằng *cùng model, cùng task_type phía query* → gửi vector query lên endpoint → nhận về top-K id gần nhất kèm độ tương tự.

Điểm cần nhớ: **Vector Search không tự tạo embedding** (ở bản 1.0 mà lab dùng) — nó chỉ nhận vector có sẵn và trả id về. Việc "câu hỏi phải nhúng bằng đúng model đã nhúng tài liệu" là trách nhiệm của code phía mình; nhúng lệch model là lỗi câm (kết quả sai mà không báo lỗi).

### 3.2. Vì sao không so sánh thẳng hết cả kho — ANN

So sánh query với từng vector trong kho (brute force) là O(n) và vỡ ở quy mô tỷ vector. Vector Search dùng **ANN — Approximate Nearest Neighbor**: chấp nhận bỏ lỡ một phần nhỏ kết quả đúng để đổi lấy tốc độ nhanh hơn hàng nghìn lần. Thước đo chất lượng ANN là **recall** — tỷ lệ lân cận thật mà index tìm được (Google định nghĩa: % số lân cận trả về mà thực sự là lân cận thật). Index production thường đạt recall >95%.

Thuật toán lõi của Google là **ScaNN (Scalable Nearest Neighbors)** — cùng thư viện đứng sau YouTube recommendations và Google Search:

- **Tree-AH (mặc định, production):** chia không gian vector thành cây các cụm (tree), lá được nén bằng **asymmetric hashing / product quantization** (nén vector để vừa bộ nhớ và tính khoảng cách gần đúng rất nhanh bằng phần cứng). Lúc query chỉ cần đi xuống vài cụm gần nhất và chấm điểm trong đó — độ phức tạp dưới tuyến tính theo kích thước kho.
- **BruteForce:** quét hết, chính xác 100%, chậm — dùng làm **index ground truth để đo recall của index Tree-AH khi tuning**, không dùng cho production.
- **SOAR (2024+):** mỗi vector được lưu vào *nhiều* cụm (dư thừa có kiểm soát) để giảm trường hợp query rơi vào nhầm cụm — index hơi to hơn, đổi lại recall ở đuôi phân phối tốt hơn. Bật mặc định trên index Tree-AH mới.

### 3.3. Tham số index cần biết khi tạo

| Tham số | Ý nghĩa thực hành |
|---|---|
| `distance_measure_type` | Cách đo "gần": `DOT_PRODUCT_DISTANCE`, `COSINE_DISTANCE`, `SQUARED_L2_DISTANCE` (Euclid), `L1_DISTANCE` (Manhattan). Google **khuyên dùng DOT_PRODUCT + chuẩn hóa L2 thay cho COSINE** — hai cách cho cùng thứ hạng (vector đã chuẩn hóa) nhưng thuật toán của họ tối ưu cho dot product hơn |
| `dimensions` | Phải khớp đúng số chiều của model embedding đã dùng (3072 / 768 / ...) — lệch là lỗi |
| `approximate_neighbors_count` | Số lân cận ứng viên quét ở bước gần đúng — tăng thì recall tăng, latency tăng theo (do phải sắp xếp lại kết quả từ nhiều cây) |
| `leaf_node_embedding_count` / `leaf_nodes_to_search_percent` | Độ mịn của cây: lá chứa ~500 vector, query quét ~7% số lá (giá trị mẫu trong doc Google) |
| `index_update_method` | `BATCH_UPDATE` (cập nhật theo đợt — dữ liệu xử lý theo tuần/tháng) hoặc `STREAM_UPDATE` (thêm/xóa/sửa realtime, dùng cho RAG corpus sống) |
| Crowding | Giới hạn số kết quả cùng một thuộc tính (ví dụ tối đa 2 kết quả cùng một nguồn) để kết quả đa dạng, không bị một nguồn áp đảo |

### 3.4. Tạo index mất bao lâu, chạy ở đâu

Lab ghi rõ: tạo + deploy index mất **~20–30 phút** (xây cây ScaNN trên toàn bộ kho). Endpoint sau đó phục vụ query với độ trễ mili-giây ở quy mô tỷ vector. Query chỉ được phép trong cùng region với index (do VPC network ở bản cũ; bản mới hỗ trợ cả public endpoint).

## 4. Lab GSP1202 — đi hết pipeline bằng notebook (học qua nội dung, không chạy)

Lab duy nhất của khóa trên Skills Boost, notebook `intro-textemb-vectorsearch.ipynb` chạy trên Agent Platform Workbench (JupyterLab):

| Task | Việc làm |
|---|---|
| Task 1 | Mở notebook trên Workbench instance, chọn kernel Python 3, chạy các cell setup; bỏ qua các cell "Colab only" và phần set IAM (lab đã cấp quyền sẵn) |
| Task 2 | Chạy phần "Getting Started with Agent Platform Embeddings for Text": tạo text embedding; rồi phần "Getting Started with Vector Search"; lưu embedding ra file JSON; tạo bucket Cloud Storage và copy file lên |
| Task 3 | Chạy phần "Create an Index": tạo + deploy index (chờ ~20–30 phút). Trong lúc chờ, đọc phần "Bringing Gen AI and LLMs to production services" trong notebook — các use case vector search production |
| Task 4 | Chạy phần "Run Query": đổi chuỗi trong biến `test_embeddings` để thử các câu hỏi khác nhau, xem kết quả lân cận thay đổi |

Điểm đáng chú ý: lab **không chấm điểm bằng code** mà bằng 3 checkpoint "Check my progress" (tạo embedding xong → tạo index xong → query được). Học viên review trên Coursera nhắc đúng một điểm trừ: "lab có nhiều lúc chờ service spin up" — thời gian chờ đó chính là lúc đọc tài liệu, đúng như lab gợi ý.

## 5. Semantic search vs keyword search — khi nào dùng cái nào

| | Keyword search (BM25/TF-IDF) | Semantic search (embedding + ANN) |
|---|---|---|
| So khớp theo | Từ xuất hiện trong văn bản | Ý nghĩa của câu |
| Mạnh khi | Tên riêng, mã, số hiệu, thuật ngữ chính xác ("FSSC 22000 v7", "task 129") | Câu hỏi diễn đạt khác với tài liệu ("cách tìm truyện theo nghĩa" vs tài liệu ghi "semantic search") |
| Yếu khi | Đồng nghĩa, diễn đạt khác, đa ngữ | Tên riêng hiếm, số hiệu, từ viết tắt — model có thể "hiểu sai" thành thứ gần nghĩa |
| Cần | Chỉ mục từ (inverted index) | Model embedding + vector index, tốn chi phí nhúng trước |

Kết luận của khóa — và cũng là lý do có §6: **không chọn một trong hai, mà ghép cả hai**. Từ khóa bắt đúng thứ cần chính xác; ngữ nghĩa bắt đúng thứ diễn đạt khác. Hệ thống tìm kiếm tốt là hệ thống lai.

## 6. Hybrid search — ghép dense + sparse, hợp nhất bằng RRF

Hybrid search chạy **hai truy vấn song song** trên cùng một câu hỏi:

1. **Dense (ngữ nghĩa):** nhúng câu hỏi thành vector, ANN trên Vector Search → danh sách top-K theo độ tương tự vector.
2. **Sparse (từ khóa):** biểu diễn câu hỏi thành vector thưa theo từ (BM25 hoặc SPLADE — model học trọng số cho từng token) → danh sách top-K theo khớp từ.

Hai danh sách được **hợp nhất bằng Reciprocal Rank Fusion (RRF)**: mỗi tài liệu được chấm điểm theo *thứ hạng* của nó trong từng danh sách (1/(k + rank)), cộng lại — tài liệu đứng cao ở cả hai danh sách sẽ thắng tài liệu chỉ đứng cao ở một. Người dùng điều chỉnh **trọng số `alpha`**: alpha cao → ưu tiên ngữ nghĩa, alpha thấp → ưu tiên từ khóa.

**Cập nhật 2026 (ngoài phạm vi lab gốc, cần ghi nhận):** Vector Search 2.0 (GA năm 2026 dưới Gemini Enterprise Agent Platform) đưa hybrid search thành tính năng có sẵn — tự động nhúng tài liệu (auto-embed bằng model do mình chọn, khỏi bước upload JSON tay), tự tính sparse vector song song, hợp nhất bằng RRF ngay trong service. Mô hình dữ liệu đổi thành Collection → Data Object → Index, thêm kNN index (tra cứu ngay không cần chờ build index, cho dev/prototype và kho <100K item). Lab GSP1202 dạy luồng 1.0 (tự nhúng + upload JSON); luồng 2.0 là bước tiến hóa trực tiếp của cùng pipeline đó, không phải sản phẩm khác.

## 7. RAG và grounded agent — retrieval là thuốc chống ảo giác

Đây là phần nối khóa này với vòng tự học về agent (123/125/127):

- **Vấn đề:** LLM trả lời từ tham số đã train — kiến thức đóng băng tại thời điểm train, và model có thể "bịa" chi tiết nghe rất thuyết phục (ảo giác). Prompt tốt (task 120/123) chỉ giảm chứ không diệt được ảo giác, vì model không có nguồn để đối chiếu.
- **Giải pháp RAG:** trước khi sinh câu trả lời, hệ thống **truy xuất** (retrieval) các đoạn tài liệu liên quan nhất bằng vector search, rồi **đưa các đoạn đó vào prompt làm context** — LLM chỉ được phép trả lời dựa trên context đó. LLM không tự đi tìm tài liệu; code quanh nó tìm rồi đặt trước mặt nó (đúng nguyên tắc task 127 đã nêu: "LLM không bao giờ tự gọi store — nó chỉ nhìn thấy những gì code đã lấy ra").
- **Grounded agent:** agent mà mọi câu trả lời đều có căn cứ trích dẫn được từ kho dữ liệu — khác với agent trả lời "từ trí nhớ". Grounding là thuộc tính của *hệ thống*, không phải của model.
- **Chuỗi đầy đủ của một câu hỏi RAG:** câu hỏi → nhúng query (`RETRIEVAL_QUERY`) → ANN top-K chunk → (tùy chọn) rerank + lọc theo metadata → ghép chunk vào prompt → LLM sinh câu trả lời có trích nguồn.
- **Vector search là bước retrieval trong mọi hệ RAG** — không có nó thì RAG chỉ còn là "nhồi cả kho tài liệu vào context", vỡ ngay khi kho lớn hơn context window. Đây là lý do khóa này nằm trong Specialization "Prompt Design, Grounding, and RAG": grounding không học riêng được, nó đứng trên vector search.

## 8. Multimodal embeddings — một không gian vector cho mọi loại dữ liệu (nối 122/124)

Embedding không chỉ dành cho text. Model `multimodalembedding@001` của Google nhúng **text, ảnh, video vào cùng một không gian vector 1408 chiều** (tùy chọn 128/256/512/1408): vector ảnh và vector text mô tả cùng một nội dung nằm gần nhau — vì vậy có thể **tìm ảnh bằng câu text** và ngược lại, **tìm text mô tả một ảnh**, mà không cần tag tay.

- Giới hạn cần nhớ: text tối đa ~32 token (model tự cắt ngắn nếu dài hơn), chỉ tiếng Anh; ảnh resize về 512×512; video không xét audio.
- Nối với task 122/124: khóa 122 dạy sinh ảnh từ text, khóa 124 dạy mô tả ảnh bằng text — cả hai chiều đó đều khả thi vì text và ảnh đã sống chung một không gian embedding. Multimodal embedding là **cầu nối kỹ thuật** giữa hai khóa đó: cùng một model vừa hiểu ảnh vừa hiểu text thì mới "dịch" qua lại được.
- **Cập nhật 2026:** `gemini-embedding-2` (03/2026) là model đa phương thức thế hệ mới — text, ảnh, video, audio, PDF trong **một** không gian vector 3072 chiều (cắt được xuống 128 nhờ MRL), context 8192 token chia sẻ cho mọi modality, không còn giới hạn text 32 token như model cũ. Trên benchmark TextCaps/Image-to-text, nó vượt model cũ ~9–15 điểm recall@1. Đây là model nên dùng cho mọi việc multimodal mới từ nay.

## 9. Áp dụng được ngay cho việc chung

### 9.1. Nối task 127 — store bộ nhớ dài hạn giờ đã có "động cơ" đầy đủ

Báo cáo 127 dùng vector store (LangMem `InMemoryStore`, production Postgres/Redis) để tìm kiếm ngữ nghĩa trong bộ nhớ agent, nhưng chưa từng mổ xẻ: embedding lấy từ đâu, so sánh bằng gì, ANN đánh đổi gì. Khóa này lấp đúng ba lỗ đó:

| Chỗ trống ở 127 | Khóa này trả lời |
|---|---|
| Embedding sinh ra sao | `gemini-embedding-001`, 3072 chiều, MRL cắt xuống 768 khi cần |
| Query và document nhúng khác nhau thế nào | `task_type`: `RETRIEVAL_QUERY` cho câu hỏi, `RETRIEVAL_DOCUMENT` cho mục nhớ — **nhúng lệch là lỗi câm** |
| Tìm kiếm chạy nhanh bằng gì | ANN/ScaNN (Tree-AH); brute force chỉ để đo recall khi tuning |
| Chunk dài bao nhiêu | Mỗi mục nhớ = một ý; text dài bị loãng nghĩa, phải chia nhỏ trước khi nhúng |

### 9.2. Recipe demo rẻ nhất cho team (theo đường task 121 đã đi)

Không cần GCP/Vertex AI để demo — dùng **Gemini API free tier** (AI Studio, không cần thẻ) đúng như task 121 đã dùng cho app Streamlit:

1. Nhúng kho tài liệu (ví dụ: toàn bộ báo cáo `research/*.md` của vòng tự học, hoặc ghi chú memory) bằng `gemini-embedding-001` qua Gemini API free tier, `task_type=RETRIEVAL_DOCUMENT`, batch 100–250 chunk/request.
2. Lưu vector vào **ChromaDB local** (đã dùng ở task 121 cho demo) hoặc file JSON + tìm brute force khi kho còn nhỏ (<10K vector thì brute force vẫn nhanh, khỏi cần ANN).
3. Query: nhúng câu hỏi (`RETRIEVAL_QUERY`) → cosine similarity top-K → đưa chunk vào prompt Gemini → trả lời có trích nguồn. Đây chính là **RAG thu nhỏ** của §7, chạy hoàn toàn trên free tier.
4. Khi kho lớn lên (>100K vector) hoặc cần hybrid search thì mới cân nhắc Vertex AI Vector Search (bản 2.0 có auto-embed + RRF sẵn) — lúc đó mới tốn tiền GCP, và chỉ khi có nhu cầu thật.

### 9.3. Nối task 126 — tab "App multimodal" trong demo Streamlit vẫn để mở

Checklist task 129 nhắc: đề xuất thực hành tab "App multimodal" trong demo Streamlit theo recipe báo cáo 126 vẫn để mở cho lần sau (cần task build riêng). Khóa này cho thêm đúng viên gạch còn thiếu của tab đó: **tìm kiếm đa phương thức** — với `gemini-embedding-2`, tab đó có thể cho người dùng gõ câu text để tìm ảnh trong kho, hoặc upload ảnh để tìm tài liệu text liên quan, trên cùng một index. Đề xuất này giữ nguyên trạng thái "mở, chờ task build riêng", không làm trong task tự học.

### 9.4. Áp dụng cho vBook (gợi ý, chưa phải quyết định)

- **Tìm truyện theo nghĩa:** người đọc gõ "truyện tu tiên main phế vật vả mặt" — keyword search trong registry hiện tại không bắt được vì tên truyện/mô tả không chứa đúng từ đó; semantic search trên embedding của mô tả truyện thì bắt được. Cần nhúng trước mô tả của 125 nguồn trong registry (một lần, rẻ) rồi tra cứu bằng ANN.
- **Chống trùng nguồn:** khi quét site mới, nhúng mô tả + mẫu nội dung rồi so với vector các nguồn đã có — nguồn trùng nội dung sẽ có cosine similarity cao dù tên miền khác hẳn. Đây là cách chống trùng bằng *nghĩa* thay vì chỉ bằng tên (bổ sung cho PROTOCOL §3, không thay thế).
- Cả hai ý trên chỉ là gợi ý cho chị cả cân nhắc; cần task riêng và quyết của Anh/muse-main trước khi làm (theo §10, hướng sản phẩm mới phải mang ra hỏi Anh).

## 10. Đề xuất cập nhật skill

- **Không sửa skill vBook** trong task này (không có gì trong khóa đụng trực tiếp tới quy trình build extension).
- **Đề xuất thêm 1 mục ngắn vào kho research chung** (muse-main quyết): "Recipe semantic search free tier" — 4 bước ở §9.2 (Gemini API free tier + ChromaDB local + chunk một ý + `task_type` đúng hai phía), để task build/demo sau dùng lại mà không phải học lại từ đầu. Nếu chị cả đồng ý, Vịt sẽ viết mục này thành file `research/RECIPE-SEMANTIC-SEARCH-FREE-TIER.md` trong task sau.
- **Lưu ý cho các báo cáo sau:** từ nay khi báo cáo nào nhắc tới "tìm kiếm ngữ nghĩa", cần ghi rõ ba tham số — model embedding, `task_type` hai phía, và số chiều — vì ba thứ đó quyết định kết quả mà không báo lỗi khi sai.

## 11. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa chạy lab thật:** toàn bộ pipeline §3–§4 học qua trang lab + tài liệu gốc, không bấm Start Lab, không tạo index thật trên GCP. Các con số (index build 20–30 phút, recall >95%, latency mili-giây) là con số Google công bố, chưa tự đo.
- **Vector Search 2.0 còn mới:** thông tin về auto-embed, hybrid RRF sẵn có, Collection/Data Object lấy từ tài liệu DeepWiki + bài viết chuyên sâu 2026, chưa có trong lab GSP1202 (lab dạy luồng 1.0). Khi team thực sự dùng Vertex AI thì kiểm tra lại trên console GCP trước khi chốt kiến trúc.
- **`gemini-embedding-2` mới ra 03/2026:** benchmark trong §8 lấy từ bài tổng hợp của bên thứ ba (meetcody.ai) và diễn đàn Google Developer — chưa đối chiếu với tech report chính thức của Google.
- **Chưa xác định:** giá tiền thực tế của Vector Search 2.0 theo số vector/query (Google tính theo node giờ + storage) — không tra cứu trong task này vì chưa có nhu cầu dùng thật; khi nào cần thì tra trước khi quyết.

## Nguồn

- Trang khóa chính thức (Skills Boost): https://www.skills.google/paths/1284/course_templates/939
- Trang khóa mirror (Coursera, thuộc Specialization "Prompt Design, Grounding, and RAG with Vertex AI"): https://www.coursera.org/learn/vector-search-and-embeddings
- Lab GSP1202 "Getting Started with Vector Search and Embeddings" (manual cập nhật 07/10/2026): https://www.skills.google/focuses/81832
- Google Cloud docs — "Get text embeddings": https://docs.cloud.google.com/vertex-ai/generative-ai/docs/embeddings/get-text-embeddings
- Google Cloud docs — "Text embeddings API" (model reference): https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/text-embeddings-api
- Google Cloud docs — "Get multimodal embeddings": https://cloud.google.com/vertex-ai/generative-ai/docs/embeddings/get-multimodal-embeddings
- Google Cloud docs — "Multimodal embeddings API": https://docs.cloud.google.com/vertex-ai/generative-ai/docs/model-reference/multimodal-embeddings-api
- Google Cloud docs — "Overview of Vector Search" (giới thiệu trong lab, đọc qua Next steps): xem link trong trang lab GSP1202
- Google Research — ScaNN / Tree-AH: https://arxiv.org/abs/1908.10396 (trích trong tài liệu VectorSearchConfig)
- Deep dive Gecko + embedding (Google Developer Forum): https://discuss.google.dev/t/decoding-the-deep-geometry-of-enterprise-embeddings-the-definitive-guide-to-google-s-vertex-ai-gecko-and-vector-physics/377253
- Vector Search 2.0 (tổng hợp 2026): https://www.neurals.ca/tech/gemini/vector-search/ và https://deepwiki.com/GoogleCloudPlatform/generative-ai/4.2-multimodal-rag
- Gemini Embedding 2 (tổng hợp 2026): https://meetcody.ai/blog/gemini-embedding-2-googles-first-multimodal-embedding-model/
- Báo cáo nối tiếp trong repo: `research/127-long-term-agentic-memory-langgraph-deeplearning-ai.md` (store + tìm kiếm ngữ nghĩa), `research/121-develop-gen-ai-apps-with-gemini-and-streamlit-google.md` (demo Streamlit free tier), `research/122-introduction-to-image-generation-google.md` và `research/124-create-image-captioning-models-google.md` (nền multimodal), `research/126-build-real-world-ai-applications-gemini-imagen-google.md` (app multimodal, tab demo còn mở).

## Kết luận

Khóa này không dạy một công cụ mới rời rạc — nó dạy **lớp nền mà mọi thứ team đã học đều đứng lên**: embedding biến ý nghĩa thành tọa độ (§1–§2), Vector Search biến tọa độ thành công cụ tra cứu nhanh ở quy mô tỷ (§3), hybrid search ghép nghĩa với từ khóa (§6), và RAG đặt retrieval trước generation để LLM trả lời có căn cứ (§7). Với team, giá trị lớn nhất không nằm ở Vertex AI (còn đắt và xa) mà ở ba thứ mang về được ngay bằng free tier: **recipe RAG thu nhỏ cho demo Streamlit (§9.2), cách nhúng đúng hai phía `task_type` (lỗi câm hay gặp nhất), và khung suy nghĩ "chunk một ý — nhúng — ANN — trích nguồn"** để dùng lại cho bộ nhớ agent (task 127), tab multimodal (task 126), và sau này là tìm truyện theo nghĩa cho vBook.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** vòng tự học "10 khóa GenAI của Google" đến đây đã đi qua 8 khóa (118–122, 124, 126, 129); các khóa GenAI còn lại trong chương trình nên để chị cả đối chiếu danh sách gốc và chọn khóa tiếp theo, hoặc chuyển sang khóa **"Agent Memory: Building Memory-Aware Agents" (DeepLearning.AI × Oracle, 18/03/2026)** mà báo cáo 127 đã gợi ý — đi sâu hạ tầng bộ nhớ, nối trực tiếp khóa này (store + embedding đã học xong, giờ học Memory Manager + hợp nhất episodic → semantic).
