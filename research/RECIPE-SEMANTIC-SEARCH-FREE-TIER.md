# Recipe: Semantic search free tier (RAG thu nhỏ)

Nguồn: task 129, Vector Search and Embeddings (Google) §9.2 — chi tiết đầy đủ trong
`research/129-vector-search-and-embeddings-google.md`. Dùng khi cần demo tìm kiếm
theo nghĩa / RAG mà không tốn tiền GCP.

## 4 bước

1. **Nhúng kho tài liệu** bằng `gemini-embedding-001` qua Gemini API free tier
   (AI Studio, không cần thẻ), `task_type=RETRIEVAL_DOCUMENT`, batch 100–250
   chunk/request. Mỗi chunk = một ý; tài liệu dài phải chia nhỏ trước khi nhúng
   (text dài bị loãng nghĩa). Mỗi text riêng lẻ tối đa 2.048 token — vượt quá sẽ
   bị cắt lặng (mặc định `autoTruncate = true`).
2. **Lưu vector** vào ChromaDB local (đã dùng ở task 121 cho demo) hoặc file JSON
   + tìm brute force khi kho còn nhỏ (<10K vector thì brute force vẫn nhanh,
   khỏi cần ANN).
3. **Query:** nhúng câu hỏi với `task_type=RETRIEVAL_QUERY` (khác phía với tài
   liệu — nhúng lệch là lỗi câm, recall kém mà không báo lỗi) → cosine similarity
   top-K → đưa chunk vào prompt Gemini → trả lời có trích nguồn.
4. **Khi kho lớn lên** (>100K vector) hoặc cần hybrid search thì mới cân nhắc
   Vertex AI Vector Search 2.0 (auto-embed + RRF sẵn) — lúc đó mới tốn tiền GCP,
   và chỉ khi có nhu cầu thật.

## Ba tham số phải ghi rõ khi nhắc tới "tìm kiếm ngữ nghĩa"

Model embedding, `task_type` hai phía, và số chiều — ba thứ đó quyết định kết
quả mà không báo lỗi khi sai. Mẫu: `gemini-embedding-001`, 3072 chiều (cắt xuống
768 qua `output_dimensionality` nhờ MRL khi cần nhanh/nhẹ), `RETRIEVAL_QUERY` /
`RETRIEVAL_DOCUMENT`.

## Áp dụng đã gợi ý (chưa phải quyết định — cần task riêng + quyết của Anh/muse-main)

- Tìm truyện theo nghĩa cho vBook: nhúng mô tả của các nguồn trong registry rồi
  tra cứu bằng ANN (người đọc gõ "truyện tu tiên main phế vật vả mặt" mà tên
  truyện/mô tả không chứa đúng từ đó).
- Chống trùng nguồn bằng nghĩa: nhúng mô tả + mẫu nội dung site mới, so cosine
  similarity với các nguồn đã có — nguồn trùng nội dung có similarity cao dù tên
  miền khác hẳn (bổ sung cho PROTOCOL §3, không thay thế).
