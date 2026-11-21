# Building Reliable Agents (LangChain Academy) — Báo cáo tự học (task 194)

- **Khóa học:** Building Reliable Agents — LangChain Academy (tên trên trang khóa: Agent Observability & Evaluation)
- **Trang khóa:** https://academy.langchain.com/courses/building-reliable-agents
- **Học viên:** muse-1 (Ú) — vai build, bản TypeScript, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** khóa số 4 đợt 12 khóa AI/Dev Anh DUYỆT 21/11 13:59 (sau 191 MCP, 192 Semrush, 193 Kaggle). Nối 191 (MCP — đánh giá agent gọi tool qua MCP), 125/127/128/130 (agent memory), 148 (mạch AI Agents), 132 (Evaluating and Improving Agentic Applications — DeepLearning.AI × Arize, cùng chủ đề đo lường nhưng khác nền tảng). Đây là mảnh "đo agent bằng công cụ thật" còn thiếu: 132 dạy tư duy eval, khóa này dạy quy trình eval chạy được trên LangSmith.
- **Hình thức:** chỉ học nội dung FREE công khai, **không tạo tài khoản LangSmith, không tạo API key LLM, không cài/chạy code repo kèm, không ghi danh trả phí/chứng chỉ** (khóa không có chứng chỉ). Học qua trang khóa chính thức + đọc code repo kèm công khai (chỉ đọc text, không thực thi) + tài liệu LangSmith chính thức đối chiếu. Nội dung bài học sau đăng nhập không xem được thì ghi Chưa xác định, không bịa kết quả chạy.

## Quét chống trùng (PROTOCOL §3) — 21/11/2026

- **Repo đích (muse-teamwork, research/):** grep "reliable.agents|langchain.academy" chỉ ra task 194 + STATUS.md + task 195 (nhắc chéo) — chưa có báo cáo riêng về khóa này. Không trùng.
- **Tasks claimed/doing/review:** 194 (claimed, muse-1) + 195 (claimed, muse-2, Develop AI agents on Azure — khóa khác). Không trùng việc.
- **STATUS.md:** 194 ghi open (đã giao 14:34); mạch liên quan 191/193 đã done. Không mở lại site đã đóng nào.

## Kiểm chứng mức FREE trước khi học

- **Khóa học: FREE.** Trang khóa chính thức ghi "Free", "29 lessons", "0 hours of video content" (đọc 21/11/2026). Nguồn thứ cấp độc lập (beri.net, kiểm chứng 01/10/2026) cũng ghi: Intermediate, Free, 29 lessons across 4 modules, self-paced, LangChain không công bố tổng số giờ, Certificate: None. Khóa không có chứng chỉ — không có gì để "lấy" ngoài kiến thức + code.
- **Repo kèm: MIT.** `langchain-ai/lca-reliable-agents`, LICENSE ghi MIT License, Copyright (c) 2026 LangChain, Inc. (đọc 21/11/2026). Code Python + TypeScript song song, dùng lại được sau khóa.
- **Ranh giới FREE quan trọng (giống 191/148):** khóa free ở tầng nội dung, nhưng *chạy bài tập* cần tài khoản + key thật. README bản TypeScript của repo ghi rõ: bắt buộc `OPENAI_API_KEY` (khóa dùng chủ yếu gpt-5-nano, README mô tả là "very inexpensive" — chi phí số cụ thể: **Chưa xác định**, báo cáo không tự điền) và `LANGSMITH_API_KEY` (bắt buộc cho evaluation + tracing, kèm `LANGSMITH_TRACING=true`); `ANTHROPIC_API_KEY` tùy chọn (dùng cho question generator). Cần Node.js >= 18 + npm. Trang LangSmith chính thức ghi có free tier cho development/small-scale production, gói trả phí tính theo lượng trace — hạn mức free tier cụ thể: **Chưa xác định** trong các nguồn đã đọc (không mở trang pricing). Task này không tạo tài khoản/key nào, đúng §9.

## Ghi chú trung thực về nguồn học

Báo cáo này học qua **ba lớp nguồn**, ghi rõ để muse-main chấm review biết giới hạn — cùng mẫu với task 191/192/193:

- **Lớp 1 — trang khóa chính thức (cấu trúc):** curriculum đầy đủ 29 bài (Module 0 setup Python/TypeScript + vòng đời agent; Module 1 observability/tracing/analyzing; Module 2 datasets/experiments/3 evaluator; Module 3 production/Insights Agent/online evals/automations; Conclusion) — đọc 21/11/2026. Nội dung chi tiết từng bài (video/text sau đăng nhập): **Chưa xác định**, không suy diễn.
- **Lớp 2 — repo kèm chính thức (nội dung lõi, đọc text thuần, không chạy):** README gốc + README TypeScript (setup, mô tả từng lesson), code agent mẫu Emma `agent_v0.ts` và `agent_v5.ts` (đọc trực tiếp để đối chiếu thay đổi v0→v5), evaluator mẫu `eval_schema_check.ts` (code-based) và `eval_conciseness_pairwise.ts` (pairwise), script `run_experiment.ts` lesson 3 + lesson 5, file dataset `officeflow-dataset.csv`, script sinh trace `generate_traces.ts` (module 3 lesson 2) — đọc 21/11/2026. Repo bị gắn cờ rủi ro thực thi ở khâu clone nên báo cáo **chỉ đọc text, tuyệt đối không cài/chạy code, không chạy lệnh git trong repo đó** — mọi khẳng định về code đều từ việc đọc file, không phải từ kết quả chạy.
- **Lớp 3 — tài liệu LangSmith chính thức (đối chiếu độc lập):** trang "How to evaluate agents" (docs.langchain.com, cập nhật 12/11/2026), trang LangSmith Evaluation (langchain.com), trang docs Automations/rules — đọc 21/11/2026. Cộng một nguồn thứ cấp độc lập (beri.net) để đối chiếu quy mô khóa. Đây là lớp để kiểm tra khóa có nói khác docs hiện hành không (mục 7).

## Cấu trúc khóa (curriculum chính thức, đọc 21/11/2026)

| Phần | Nội dung chính | Khái niệm lõi |
|---|---|---|
| Module 0 (8 bài) | Course Introduction; Intro: The Agent Development Lifecycle; Getting Set Up Python (Video + Text); Getting Set Up TypeScript (Video + Text); Language Translation; Glossary and References | Vòng đời observe-evaluate-improve; chọn 1 trong 2 ngôn ngữ (Ú chọn TS) |
| Module 1 — Observation (5 bài) | Introduction; Lesson 1 Observability; Lesson 2 Tracing with LangSmith; Lesson 3 Analyzing your Agent; Feedback | Trace = cây mọi LLM call + tool invocation + quyết định |
| Module 2 — Evaluation (8 bài) | Introduction; Lesson 1 Evaluating Agents; Lesson 2 Creating Datasets; Lesson 3 Running Experiments; Lesson 4 Eval 1 Code-based; Lesson 5 Eval 2 LLM-as-Judge; Lesson 6 Eval 3 Pairwise; Feedback | Experiment = target + dataset + evaluators; 3 họ evaluator |
| Module 3 — Moving Towards Production (6 bài) | Introduction; Lesson 1 Moving Towards Production; Lesson 2 Insights Agent; Lesson 3 Online Evals; Lesson 4 Automations; Feedback | Từ test nội bộ sang người dùng thật: phân tích trace quy mô lớn, chấm online, tự động hoá |
| Conclusion (2 bài) | Conclusion; End of Course Feedback | — |

Đường đi của khóa: **nhìn thấy agent làm gì (trace) → đo agent bằng bộ test chạy lại được (offline eval) → giám sát agent đang chạy thật (online eval + insights + automations)**. Đây chính là vòng đời phát triển agent mà LangChain gọi là Agent Development Lifecycle: observe → evaluate → improve, lặp lại.

Lưu ý lệch nhỏ giữa hai nguồn chính thức: trang khóa có Module 3 Lesson 4 "Automations" nhưng README TypeScript trong repo chỉ liệt kê Module 3 tới Lesson 3 "Online Evals". Trang khóa là nguồn authoritative cho curriculum; README repo có thể chậm cập nhật hơn. Báo cáo ghi cả hai, không tự sửa nguồn nào.

## 1. Module 0 — Setup TypeScript và vòng đời agent

- **Setup (README TS, đọc trực tiếp):** clone repo (shallow), `npm install`, copy `example.env` → `.env` rồi điền key (mục Kiểm chứng FREE ở trên), kiểm tra môi trường bằng script `env_utils.ts` (kiểm Node >= 18, npm/tsx, packages, biến môi trường). Chạy script bằng `npx tsx` (vd `npx tsx officeflow-agent/agent_v5.ts`, `npx tsx module-2/lesson-3/run_experiment.ts`). Repo còn gợi ý cấp cho coding agent quyền đọc LangSmith Docs nếu dùng coding agent trong khóa.
- **Vòng đời observe-evaluate-improve:** điểm khác căn bản với test phần mềm truyền thống (đã học ở 132 §1): agent không có "đáp án đúng duy nhất" nên không test bằng assert output; thay vào đó quan sát hành vi qua trace, đo bằng eval trên dataset, sửa, rồi đo lại trên cùng bộ đo. Khóa tổ chức toàn bộ 4 module theo đúng vòng này.
- **Ánh xạ sang team:** team đang chạy vòng này bằng tay mà chưa gọi tên: quan sát = task file + STATUS + git log (trace thủ công); đo = review chấm /10 + validate/device test/install; sửa = trả về doing; đo lại = vòng review tiếp theo (tối đa 3 vòng, PROTOCOL §4). Khóa cho team một ngôn ngữ chuẩn + một bộ công cụ tự động hoá vòng đó — nhưng team hiện chưa có agent sản phẩm nào chạy traffic thật để cần LangSmith (mục 8).

## 2. Module 1 — Observability và tracing với LangSmith

- **Lesson 1 Observability:** vì sao debug truyền thống (print/log rời rạc) không đủ cho agent — agent ra quyết định nhiều bước, gọi tool, rẽ nhánh; cần nhìn toàn bộ quỹ đạo của một lần chạy. Đây là cùng kết luận Glassbox ở 193 Day 4 (đo cả quỹ đạo tool, không chỉ đáp án cuối) mà team đã đưa vào checklist chấm review PROTOCOL §4 ngày 21/11.
- **Lesson 2 Tracing:** gắn instrument để mọi LLM call, tool invocation, quyết định đều thành một trace. Trong code Emma v5 (đọc trực tiếp): `wrapOpenAI(...)` bọc client OpenAI để tự động trace các lần gọi model; `traceable(...)` bọc từng hàm `query_database`, `search_knowledge_base` (run_type "tool") và hàm `chat` (name "Emma", metadata thread_id dạng uuid7). Repo còn có 2 ví dụ phụ ở module-1/lesson-2: `third_party_agent` (weather agent có tool calling) và `thread_agent` (agent hội thoại theo thread).
- **Lesson 3 Analyzing:** dùng trace chạy qua các kịch bản PRD, phát hiện failure, debug lặp qua nhiều phiên bản agent. Đây là cầu nối sang Module 2: failure tìm bằng mắt trên trace phải biến thành case trong dataset để đo tự động (đúng bài học 132 §2 "biến lỗi thật thành bộ test chạy lại được").
- **Ánh xạ sang team:** "trace" của team là chuỗi commit + notes trong task file — bền và truy vết được, nhưng không có cây gọi tool/token/latency. Khi chấm review, muse-main hiện kiểm quỹ đạo bằng cách đọc log/nguồn worker đã thử (§4 Glassbox) — tức là làm tay việc mà tracing tự động hoá. Bài học rút ra không phải "gắn LangSmith ngay" mà là: **bằng chứng quỹ đạo phải đọc lại được từ hệ thống thật** — đúng nguyên tắc vàng §11.1 team vừa chốt 21/11.

## 3. Agent mẫu Emma (OfficeFlow) v0 → v5: một agent, năm lần cải tiến có đo

Emma là agent chăm sóc khách hàng cho OfficeFlow Supply Co. (công ty văn phòng phẩm hư cấu), có 2 tool: `query_database` (truy vấn SQLite inventory: sản phẩm, tồn kho, giá) và `search_knowledge_base` (tìm trong tài liệu chính sách công ty bằng embedding + cosine similarity). README gốc mô tả 6 phiên bản; báo cáo đọc trực tiếp v0 và v5 để xác minh (v1–v4 theo mô tả README, ghi rõ là theo README chứ không đọc từng file):

| Phiên bản | Thay đổi (README gốc) | Bằng chứng đọc trực tiếp (v0/v5) |
|---|---|---|
| v0 Baseline | Agent gốc, không tracing | Client OpenAI trần; RAG cắt chunk 200 ký tự/overlap 20; mô tả tool `query_database` chung chung ("SQL query to execute..."); threadId cố định "default" |
| v1 | + LangSmith tracing | (theo README) |
| v2 | + Enhanced tool instructions | v5 cho thấy kết quả cuối: mô tả tham số query bắt buộc khám phá schema trước (`SELECT name FROM sqlite_master`, `PRAGMA table_info`) rồi mới query dữ liệu |
| v3 | + Stock information policy | v5 có mục STOCK INFORMATION POLICY: không bao giờ lộ số tồn kho cụ thể, quy về 5 dải lời nói (>20 "in stock"; 10–20 "in stock, but running low"; 5–9 "only a few left"; 1–4 "very limited"; 0 "out of stock") |
| v4 | + No-chunking RAG | v5 nạp nguyên văn từng tài liệu (không cắt chunk), có kiểm tra embeddings cũ (`embeddingsAreStale` so mtime file với cache) |
| v5 | + Conciseness improvements | v5 có mục CONCISENESS PRIORITY (ngắn gọn, bỏ filler) + ví dụ hội thoại rút gọn hẳn so với v0 |

Ba bài học thiết kế đáng nhớ từ Emma:

- **Mô tả tool là một nửa của việc gọi đúng** (lặp lại 191 §4 và 148): thay đổi v2 không sửa code tool, chỉ sửa *mô tả* tham số để ép agent khám phá schema trước khi đoán tên cột. Lỗi "đoán schema" sau đó được đo tự động bằng evaluator code-based ở Module 2 (mục 4) — sửa bằng prompt, kiểm bằng code.
- **Chính sách nghiệp vụ nằm trong prompt phải đo được:** stock policy (v3) và conciseness (v5) đều là quy tắc "mềm" trong system prompt; khóa không tin prompt tự đúng mà xây evaluator riêng cho từng quy tắc (pairwise conciseness ở mục 4). Đây là cùng tinh thần §11 team vừa học từ Kerr: quy tắc chỉ nằm trong trí nhớ/prompt thì không giữ được, phải có cơ chế kiểm chứng.
- **RAG không phải lúc nào cũng cắt chunk:** v4 bỏ chunking, nạp nguyên tài liệu vì knowledge base nhỏ (tài liệu chính sách). Bài học: chunking là lựa chọn theo quy mô tài liệu, không phải mặc định — và thay đổi này cũng phải qua eval mới biết tốt hơn hay tệ hơn, không đổi theo cảm tính.

## 4. Module 2 — Evaluation: datasets, experiments, 3 họ evaluator

- **Lesson 2 Creating Datasets:** dataset là tập input + (khi có) reference output để đo lặp lại được. File mẫu `officeflow-dataset.csv` trong repo chỉ có **một cột `question`** (đọc trực tiếp: các câu hỏi kiểu "How many reams of copy paper do you currently have available?", câu hỏi ngoài phạm vi như pet food, câu hỏi nhiều ý, khách bực bội...) — **không có cột đáp án chuẩn**. Hệ quả thiết kế: mọi evaluator của khóa đều là loại *không cần đáp án chuẩn* (reference-free) — chấm hành vi/quỹ đạo/chất lượng tương đối thay vì so khớp đáp án. Đây là điểm khác quan trọng với eval kiểu benchmark có ground truth (vd GAIA ở 148).
- **Lesson 3 Running Experiments:** experiment = nối target (agent cần đo) + dataset + evaluators rồi chạy. Script mẫu lesson 3 dùng một dummy app luôn trả câu có chữ "OfficeFlow" và một evaluator code-based kiểm tra chữ đó — cố ý đơn giản để học cơ chế `evaluate(dummyApp, { data: "officeflow-dataset", evaluators: [...] })` trước khi đo agent thật. Đối chiếu docs chính thức (How to evaluate agents, cập nhật 12/11/2026): `evaluate()` nhận target function + `data` (tên/UUID dataset) + `evaluators`; evaluator định nghĩa được ở 2 nơi — trong code, hoặc trong LangSmith UI (tự kích hoạt với mọi experiment mới); metadata (models/prompts/tools) gắn vào experiment để so sánh theo nhóm. Script lesson 5 của khóa dùng đúng đường UI: chạy `evaluate(chatWrapper, { data: datasetName })` không truyền evaluators vì evaluator đã "bound" vào dataset trong UI và tự chạy.
- **Lesson 4 Eval 1 — Code-based:** evaluator xác định (deterministic), chạy như unit test: kiểm tra tool usage, output shape, keyword matching. Mẫu đọc trực tiếp `eval_schema_check.ts`: chấm 1 nếu agent kiểm tra schema DB (regex `PRAGMA table_info` / `sqlite_master`) *trước* query dữ liệu đầu tiên, 0 nếu query mù; không gọi `query_database` thì chấm 1 (không áp dụng). Đây là evaluator **chấm quỹ đạo** (thứ tự gọi tool), không chấm câu trả lời cuối — đúng Glassbox của 193 và checklist §4 của team.
- **Lesson 5 Eval 2 — LLM-as-Judge:** dùng một LLM chấm tiêu chí chủ quan khó viết bằng code. Trang LangSmith Evaluation chính thức cảnh báo thẳng: LLM-as-judge không phải lúc nào cũng đúng; phải route mẫu sang người chấm để phát hiện bất đồng, hiệu chỉnh (calibrate) judge theo thời gian. Đây là cùng bài học 132 §3 "phải đo chính người chấm" — khóa này cho công cụ (annotation queues + calibrate), 132 cho tư duy.
- **Lesson 6 Eval 3 — Pairwise:** so hai phiên bản agent cạnh nhau trên cùng dataset, judge chọn bản tốt hơn theo một tiêu chí. Mẫu đọc trực tiếp `eval_conciseness_pairwise.ts`: judge (gpt-5-nano) nhận question + Response A + Response B, trả 1/2/0 (A tốt hơn/B tốt hơn/bằng nhau) theo tiêu chí "ngắn gọn hơn mà vẫn đủ thông tin cốt lõi — ngắn hơn không tự động tốt hơn nếu thiếu thông tin"; chạy `evaluate(["agent-v4-experiment", "agent-v5-experiment"], { evaluators: [concisenessEvaluator], randomizeOrder: true })` — có **randomizeOrder** để judge không thiên vị vị trí A/B. Pairwise hợp cho quyết định "bản mới có tốt hơn bản cũ không" khi không có đáp án chuẩn; code-based vẫn giữ vai cổng cứng (schema/contract) vì preference không phát hiện được vỡ contract.
- **Khi nào dùng họ nào (tổng hợp từ khóa + docs):** code-based cho điều kiện đúng/sai kiểm được bằng logic (gọi đúng tool chưa, đúng thứ tự chưa, đúng format chưa, có lộ số cấm không); LLM-as-judge cho chất lượng chủ quan (đúng trọng tâm, đủ ý, đúng giọng) nhưng phải hiệu chỉnh bằng người; pairwise cho so sánh A/B hai phiên bản/prompt/model trên cùng bộ đo. Ba họ bổ sung nhau, không thay thế nhau.

## 5. Module 3 — Production: Insights Agent, online evals, automations

- **Lesson 1 Moving Towards Production:** chuyển từ test nội bộ sang người dùng thật — lúc này không còn reference output, câu hỏi thật không lường trước, dữ liệu thay đổi. Docs/AWS đối chiếu ghi rõ hai chế độ bổ sung nhau: offline eval chạy trên dataset curated trước deploy (benchmark/regression/unit test), online eval chạy trên trace production thật sau deploy (giám sát thời gian thực/phát hiện bất thường).
- **Lesson 2 Insights Agent:** tự động phân tích trace ở quy mô lớn để phát hiện usage patterns + failure modes trên hàng trăm trace (README TS). Repo hỗ trợ lesson này bằng script `generate_traces.ts` (đọc trực tiếp phần đầu): sinh 1000 trace tổng hợp, 200 trace mỗi loại trong 5 loại (inventory, policy, out_of_scope, both, website_troubleshooting), mỗi trace gồm 2 run (root "Emma" + child "ChatOpenAI"), kèm `upload_traces.ts` để đẩy lên LangSmith. Tức là khóa dạy Insights trên dữ liệu giả lập có kiểm soát trước — học viên chưa có traffic thật vẫn học được cách đọc báo cáo insights.
- **Lesson 3 Online Evals:** tự động chấm mọi trace production khi nó đến, cho tín hiệu liên tục về chất lượng (README TS). Docs chính thức bổ sung: online evaluator có thể là LLM-as-judge (có sampling rate để kiểm soát chi phí), code evaluator chạy trong sandbox, hoặc thread-level evaluator chấm cả cuộc hội thoại. Điểm cần nhớ: online eval không có đáp án chuẩn nên chỉ dùng được evaluator reference-free — đúng thiết kế dataset ở mục 4.
- **Lesson 4 Automations:** docs chính thức (trang rules, đọc 21/11/2026): automation rule gồm item type (runs hoặc threads) + filter + sampling rate + action; action gồm thêm trace vào dataset, thêm vào annotation queue, trigger webhook, chạy online evaluator, kéo dài retention, trigger alert. Ví dụ điển hình: trace bị feedback âm → annotation queue cho người xem; lấy mẫu 10% trace → annotation queue spot-check. Đây là mắt xích khép vòng: **lỗi production → dataset → offline eval → sửa → redeploy**. Lưu ý: automations/online evals/insights là tính năng cấu hình trong LangSmith UI — repo không có code chạy cho các lesson này ngoài script sinh/đẩy trace của Lesson 2; nội dung thao tác UI chi tiết trong bài học sau đăng nhập: **Chưa xác định**.

## 6. Đối chiếu khóa ↔ docs hiện hành và ↔ mạch học của team

- **Khóa khớp docs:** cơ chế `evaluate()` (target + data + evaluators, evaluator trong code hoặc UI tự kích hoạt), 3 họ evaluator + human annotation queues, offline vs online, automations (item type/filter/sampling/action) — tất cả khớp tài liệu LangSmith chính thức đọc cùng ngày 21/11/2026. Không phát hiện lệch pha kiểu 191 (khóa dạy transport cũ). Điểm trừ duy nhất: README repo chậm hơn trang khóa ở Module 3 Lesson 4 (mục Cấu trúc khóa).
- **Vendor-specific vs portable:** khóa xây quanh LangSmith nên công cụ là của LangChain; nhưng phương pháp (dataset, 3 họ evaluator, online eval, khép vòng lỗi production thành dataset) mang sang nền tảng khác được — nguồn thứ cấp độc lập cũng nhận xét đúng điểm này. Team đã học cùng phương pháp trên nền Arize ở 132; hai khóa bổ sung nhau: 132 mạnh về tư duy đo (error analysis, đo người chấm), 194 mạnh về quy trình + code mẫu chạy theo vòng đời agent.
- **Nối 191 (MCP):** tracing của LangSmith ghi lại mọi tool invocation — nếu agent gọi tool qua MCP (191), trace chính là nơi kiểm chứng agent có gọi đúng server/tool/thứ tự không, và evaluator quỹ đạo kiểu `schema_before_query` áp dụng nguyên vẹn cho MCP tool call. Hai khóa ghép thành một mạch: 191 dạy *nối* tool chuẩn, 194 dạy *đo* việc gọi tool đó.
- **Nối 193 (Glassbox) + PROTOCOL §4/§11:** evaluator quỹ đạo của khóa là hiện thực hoá bằng code của checklist Glassbox team vừa đưa vào §4 (chấm cả đường đi, không chỉ đáp án). Và toàn bộ khóa là minh chứng cho §11.1: "xong" phải là bằng chứng đọc lại được — trace đọc lại được, điểm eval đọc lại được, experiment so sánh được trên cùng dataset.

## 7. Áp dụng cho team muse-teamwork và nhà máy (đề xuất có điều kiện, không tự làm)

1. **Chưa gắn LangSmith cho team.** Lý do: team chưa có agent sản phẩm chạy traffic thật; "agent" của team là chính 3 Muse làm việc qua GitHub, và hệ thống đo hiện tại (review /10 + evidence gate §11.2 + Glassbox §4) đang làm đúng vai offline eval + human annotation bằng quy trình. Gắn thêm một nền tảng tracing lúc này là thêm hạ tầng không có bài toán — đúng cảnh báo "khi nào không cần framework" của 148.
2. **Mượn 3 ý áp dụng ngay bằng quy trình hiện có:** (a) dataset hồi quy cho extension vBook — mỗi lỗi production (site đổi domain, selector vỡ) biến thành case trong bộ test chạy lại được thay vì sửa xong rồi quên (đúng vòng lỗi→dataset của khóa); (b) pairwise khi so hai bản sửa cùng một extension — chạy cùng bộ case, so từng case thay vì so cảm tính; (c) code-based gate cho điều kiện cứng (validate PASS, device test 0, install 200 — team đã có, giữ nguyên vai cổng cứng, không để điểm review /10 thay thế, đúng §4).
3. **Ánh xạ nhà máy (gợi ý, không tự làm):** nếu sau này có trợ lý tra cứu SOP/FSSC, cách đo đúng theo khóa là: dataset câu hỏi mẫu từ tình huống thật (không cần đáp án chuẩn từng chữ), evaluator code-based kiểm tra quỹ đạo (có tra đúng tài liệu trước khi trả lời không — tương đương `schema_before_query`), LLM-as-judge chấm độ đủ ý có hiệu chỉnh bằng người (Anh/chị cả), online eval lấy mẫu trên câu hỏi thật. Nguyên tắc "Chưa xác định thay vì đoán" của team tương ứng evaluator kiểm tra agent có từ chối trả lời khi không có nguồn không.
4. **Không xây trên judge chưa hiệu chỉnh:** nếu team dùng LLM-as-judge ở đâu (vd chấm báo cáo tự học), phải có vòng người chấm đối chiếu bất đồng như docs cảnh báo — hiện tại muse-main chấm /10 bằng người (agent chị cả đọc bằng chứng độc lập) đang là cơ chế hiệu chỉnh đó, giữ nguyên.

## 8. Nếu Anh muốn học thật

- **Chỉ đọc:** trang khóa + repo MIT công khai là đủ để nắm vòng đời + 3 họ evaluator + mẫu Emma; không cần tài khoản, không tốn phí.
- **Chạy bài tập thật:** cần (1) tài khoản LangSmith + API key (có free tier theo trang chính thức, hạn mức cụ thể Chưa xác định — Anh tự kiểm tra trang pricing trước khi quyết), (2) OpenAI API key (khóa dùng gpt-5-nano, README nói rất rẻ — số tiền cụ thể Chưa xác định), (3) Node.js >= 18 nếu chọn bản TS. Anthropic key tùy chọn. Không có chứng chỉ để lấy.
- **Phần nên học kỹ nhất theo vai build:** evaluator quỹ đạo code-based (mục 4) và pairwise có randomizeOrder; phần nên đọc kèm docs: automations (mục 5) vì đó là mắt xích khép vòng production → dataset.

## Nguồn

- Trang khóa chính thức: https://academy.langchain.com/courses/building-reliable-agents (đọc 21/11/2026 — Free, 29 lessons, curriculum đầy đủ)
- Repo kèm chính thức: https://github.com/langchain-ai/lca-reliable-agents (đọc text 21/11/2026 — LICENSE MIT; README gốc + `ts/README.md`; `ts/officeflow-agent/agent_v0.ts`, `agent_v5.ts`; `ts/module-2/lesson-3/run_experiment.ts`, `lesson-4/eval_schema_check.ts`, `lesson-5/run_experiment.ts`, `lesson-6/eval_conciseness_pairwise.ts`, `ts/module-2/officeflow-dataset.csv`; `ts/module-3/lesson-2/generate_traces.ts`)
- Tài liệu LangSmith chính thức — How to evaluate agents: https://docs.langchain.com/langsmith/evaluate-llm-application (đọc 21/11/2026, trang cập nhật 12/11/2026)
- LangSmith Evaluation (trang chính thức): https://www.langchain.com/langsmith/evaluation (đọc 21/11/2026 — evaluator types, offline vs online, free tier)
- Tài liệu LangSmith chính thức — Automations/rules: https://docs.langchain.com/langsmith/rules (đọc 21/11/2026)
- Nguồn thứ cấp độc lập đối chiếu quy mô khóa: https://www.beri.net/learning/langchain-academy-building-reliable-agents (đọc 21/11/2026, kiểm chứng gốc 01/10/2026)
- Báo cáo team liên quan trên main: `research/191-mcp-course-hugging-face.md`, `research/193-kaggle-5-day-ai-agents-intensive.md` (Glassbox Day 4), `research/132-evaluating-and-improving-agentic-applications-deeplearning-ai.md`, `research/148-ai-agents-course-hugging-face.md`, `PROTOCOL.md` §4/§11
