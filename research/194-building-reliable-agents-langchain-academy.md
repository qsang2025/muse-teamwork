# Building Reliable Agents (LangChain Academy) — Báo cáo tự học (task 194) [WIP]

- **Khóa học:** Building Reliable Agents — LangChain Academy (tên trên trang khóa: Agent Observability & Evaluation)
- **Trang khóa:** https://academy.langchain.com/courses/building-reliable-agents
- **Học viên:** muse-1 (Ú) — vai build, bản TypeScript, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** khóa số 4 đợt 12 khóa AI/Dev Anh DUYỆT 21/11 13:59 (sau 191 MCP, 192 Semrush, 193 Kaggle). Nối 191 (MCP — đánh giá agent gọi tool qua MCP), 125/127/128/130 (agent memory), 148 (mạch AI Agents), 132 (Evaluating and Improving Agentic Applications).
- **Hình thức:** chỉ học nội dung FREE công khai, **không tạo tài khoản LangSmith, không tạo API key LLM, không chạy bài tập, không ghi danh trả phí/chứng chỉ** (khóa không có chứng chỉ theo task file — sẽ kiểm chứng lại trên trang khóa). Học qua syllabus công khai + repo kèm MIT langchain-ai/lca-reliable-agents. Nội dung sau đăng nhập không xem được thì ghi Chưa xác định, không bịa.

## Quét chống trùng (PROTOCOL §3) — 21/11/2026

- **Repo đích (muse-teamwork, research/):** grep "reliable.agents|langchain.academy" chỉ ra task 194 + STATUS.md + task 195 (nhắc chéo) — chưa có báo cáo riêng về khóa này. Không trùng.
- **Tasks claimed/doing/review:** 194 (claimed, muse-1) + 195 (claimed, muse-2, Azure — khóa khác). Không trùng việc.
- **STATUS.md:** 194 ghi open (đã giao 14:34); mạch liên quan 191/193 đã done. Không mở lại site đã đóng nào.

## Khung báo cáo (WIP — đang khảo sát)

1. Kiểm chứng FREE + cấu trúc khóa (29 bài, 4 module) trên trang chính thức
2. Module 0 — setup TypeScript + vòng đời observe-evaluate-improve
3. Module 1 — observability/tracing với LangSmith
4. Module 2 — evaluation: datasets, experiments, 3 loại evaluator (code-based, LLM-as-judge, pairwise)
5. Module 3 — production: Insights Agent, online evals, automations
6. Repo kèm lca-reliable-agents: agent mẫu Emma (OfficeFlow) v0–v5, code Python + TS song song
7. Đối chiếu độc lập: tài liệu LangSmith chính thức (tracing/evaluation) — điểm nào khóa nói khác docs?
8. Áp dụng cho team muse-teamwork + nhà máy (đề xuất có điều kiện, không tự làm)
9. Nếu Anh muốn học thật: cần tài khoản LangSmith + API key LLM — ghi rõ điều kiện, không tự tạo

## Nguồn dự kiến kiểm chứng (sẽ ghi ngày đọc + URL khi xong)

- Trang khóa chính thức: https://academy.langchain.com/courses/building-reliable-agents
- Repo kèm: https://github.com/langchain-ai/lca-reliable-agents
- Tài liệu LangSmith chính thức (observability/evaluation)
- Báo cáo team liên quan: `research/191-mcp-course-hugging-face.md`, `research/132-*`, `research/125-*`, `research/148-*`
