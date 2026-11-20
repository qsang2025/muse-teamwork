# Cheat-sheet: Attention → Transformer → BERT (1 trang)

Dùng lại cho mọi khóa sau trong vòng tự học — viết trong task 134 theo đề xuất của báo cáo 131 §9. Nguồn chi tiết: `research/131-attention-mechanism-google.md` (§3, §7, §8.2) và `research/134-transformer-models-and-bert-model-google.md` (§2, §3, §5).

## 1. Công thức gốc — self-attention

```
Attention(Q, K, V) = softmax(QKᵀ / √d_k) · V
```

Mỗi token tạo 3 vector qua 3 ma trận đã học: **Query** (đang tìm gì) — **Key** (cung cấp gì) — **Value** (nội dung chuyển đi). Chia cho √d_k để softmax khỏi bão hòa khi d_k lớn. Ví dụ: "it" trong "The animal didn't cross the street because it was too tired" gắn với "animal" nhờ attention.

## 2. Ba loại attention — ghi rõ loại nào khi nhắc tới

| Loại | Query từ | Key/Value từ | Dùng ở |
|---|---|---|---|
| Self-attention | Cùng chuỗi | Cùng chuỗi | Mọi lớp encoder |
| Masked self-attention | Chuỗi đích đã sinh | Chuỗi đích đã sinh (che tương lai) | Lớp 1 decoder |
| Cross-attention | Decoder | Đầu ra encoder | Lớp 2 decoder |

## 3. Độ phức tạp — vì sao context window hữu hạn

| Loại lớp | / lớp | Bước tuần tự | Đường đi dài nhất |
|---|---|---|---|
| Self-attention | O(n²·d) | O(1) | O(1) |
| RNN | O(n·d²) | O(n) | O(n) |
| Convolution | O(k·n·d²) | O(1) | O(log_k n) |

Self-attention đắt theo n² nhưng song song được và đường đi O(1). Hậu duệ trả giá n² rẻ đi: FlashAttention (2022, không ghi ma trận n×n ra HBM), GQA/MQA (giảm KV cache), sliding window (Mistral), RoPE (thay sin/cos).

## 4. Transformer (Vaswani et al., 2017) — xếp chồng attention

- **Encoder:** 6 lớp × (multi-head self-attention + FFN), residual + LayerNorm quanh mỗi sub-layer.
- **Decoder:** 6 lớp × (masked self-attention + cross-attention + FFN), residual + LayerNorm.
- **Multi-head:** 8 head × d_k=64 (d_model=512); mỗi head một góc quan hệ; 1 head thay 8 làm BLEU tụt 0.9.
- **Positional encoding:** `PE(pos,2i)=sin(pos/10000^(2i/d_model))`, `PE(pos,2i+1)=cos(...)` — bù thứ tự cho kiến trúc không có thứ tự.
- **Kết quả:** BLEU 28.4 En–De / 41.8 En–Fr (WMT 2014); base 65M tham số train 12h, big 213M train 3.5 ngày (8× P100).

## 5. BERT (Devlin et al., 2019) — chỉ lấy encoder, pre-train hai chiều

- **Pre-train:** **MLM** — mask 15% token (80% `[MASK]` / 10% ngẫu nhiên / 10% giữ nguyên), đoán lại từ gốc; **NSP** — cặp câu A–B, 50% nối tiếp thật / 50% ngẫu nhiên.
- **Đầu vào:** token + segment + position embedding; `[CLS]` = đại diện cả chuỗi, `[SEP]` = ngăn câu; tối đa 512 token; WordPiece ~30.522 token.
- **Dữ liệu:** BooksCorpus 800M từ + Wikipedia EN 2.500M từ. **BASE:** L=12, H=768, A=12, 110M tham số. **LARGE:** L=24, H=1024, A=16, 340M tham số.
- **Fine-tune:** thêm đúng 1 lớp output (phân loại dùng vector `[CLS]`; QA/NER dùng vector từng token).
- **Kết quả:** GLUE 80.5% (+7.7), MultiNLI 86.7% (+4.6), SQuAD v1.1 F1 93.2, SQuAD v2.0 F1 83.1 — SOTA 11 task cùng lúc.
- **Giới hạn:** encoder-only → không sinh text; 512 token; NSP bị RoBERTa bỏ sau này; kiến thức đóng băng ở thời điểm pre-train.

## 6. Ba họ Transformer — chọn đúng họ trước khi chọn model

| Họ | Lấy phần nào | Ví dụ | Mạnh ở |
|---|---|---|---|
| Encoder-only | Chỉ encoder, attention hai chiều | BERT, RoBERTa | **Hiểu:** phân loại, NLI, QA trích xuất, embedding |
| Decoder-only | Chỉ decoder, masked attention | GPT, Llama, Gemini | **Sinh:** chat, viết, code |
| Encoder–decoder | Cả hai, self + cross | T5, BART, Transformer 2017 | **Biến đổi:** dịch máy, tóm tắt |

## 7. Hai quy tắc prompt rút ra từ cơ chế attention

1. **Đặt thông tin quan trọng ở đầu/cuối, không chôn ở giữa** ("lost in the middle") — đặc biệt khi prompt dài hoặc RAG đưa nhiều chunk vào context.
2. **Ngắn và một ý thì attention tập trung hơn** — prompt càng dài, trọng số softmax càng bị pha loãng trên nhiều token; một nhiệm vụ một lần.
