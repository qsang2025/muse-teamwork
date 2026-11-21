# Kaggle 5-Day AI Agents Intensive Course (Google) — Báo cáo tự học (task 193)

- **Khóa học:** 5-Day AI Agents Intensive Course with Google, Kaggle
- **Trang khóa:** https://www.kaggle.com/competitions/5-day-ai-agents-intens (đã kết thúc live — kiểm chứng 21/11: trang này trả 404; nay học self-paced qua Learn Guide https://www.kaggle.com/learn-guide/5-day-agents)
- **Learn Guide (self-paced):** https://www.kaggle.com/learn-guide/5-day-agents
- **Học viên:** muse-2 (Vịt) — vai research, mạch AI Agents, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** khóa số 3 đợt 12 khóa AI/Dev Anh DUYỆT 21/11 13:59. Nối 191 (MCP Course, Hugging Face — Ú, đang ở `review`), 148 (AI Agents Course, Hugging Face — Ú, `done`), 125 (AI Agents in LangGraph — Ú, `done`), 127/128/130 (mạch memory — Ú, `done`).

## Kiểm chứng mức FREE trước khi học

- **Khóa học: MIỄN PHÍ, tự học theo nhịp của mình.** Chạy live 10–14/11/2025 với **hơn 1,5 triệu người đăng ký** (theo KDnuggets + trang giới thiệu khóa, đọc 21/11/2026), nay là Kaggle Learn Guide self-paced, miễn phí toàn bộ whitepaper + codelab + podcast tóm tắt + livestream đã ghi hình.
- **Không hứa chứng chỉ.** Google/Kaggle không hứa chứng chỉ cho khóa này (đúng notes task); huy hiệu hoàn thành trên Kaggle là tự ghi nhận, không phải chứng chỉ có giám sát (theo review độc lập designcopy.net, đọc 21/11/2026). Ai làm capstone thì có cơ hội nhận chứng chỉ/huy hiệu/quà lưu niệm của cuộc thi capstone — phần thưởng, không phải chứng chỉ khóa học.
- **Tài khoản: không tạo.** Notebook chạy trên Kaggle cần tài khoản Kaggle (xác minh bằng điện thoại) + Gemini API key để chạy — báo cáo **không tạo tài khoản Kaggle thay Anh, không chạy notebook**, chỉ học whitepaper + tài liệu công khai (đúng notes task). Chỗ nào cần chạy code thì ghi Chưa xác định.
- **Yêu cầu đầu vào (theo KDnuggets):** biết Python và đã từng gọi LLM API; không cần biết trước về agent.
- **Bản làm mới tháng 06/2026:** có đợt chạy lại theo chủ đề "vibe coding" (15–19/06/2026), thêm nội dung về bảo mật ở Day 4 (theo trang giới thiệu khóa). Báo cáo này học **bản gốc tháng 11/2025**; chi tiết bản 06/2026 chưa khảo sát — xem Chưa xác định ở cuối.

## Ghi chú trung thực về nguồn học

Báo cáo này học qua **ba lớp nguồn**, ghi rõ để muse-main chấm review biết giới hạn — cùng mẫu với task 163/165/167/169/172/174/175/177/178/182/186/190/192:

- **Lớp 1 — trang khóa chính thức (cấu trúc/phạm vi):** trang competition Kaggle + trang whitepaper Day 1 trên Kaggle (đọc 21/11/2026) — tên 5 whitepaper, tác giả Day 1, lời mở đầu whitepaper. **Trang Learn Guide Kaggle trả lỗi 429 khi đọc ngày 21/11** (trang báo crash, `kErrorDropped`) nên cấu trúc ngày + tên notebook lấy từ lớp 2, không phải từ trang chính thức — ghi rõ để muse-main biết.
- **Lớp 2 — người đã học xong (nội dung chi tiết từng ngày):** bài "What I Learned From Kaggle + Google's Free Agentic AI Course" của Bala Priya trên KDnuggets (người học xong cả 5 ngày, liệt kê đủ 10 notebook + khái niệm từng ngày); bài tổng kết 5 ngày + capstone của Peter Wanga trên DEV (đăng 05/12/2025, chi tiết code ADK từng notebook: class, hàm, file cấu hình); bài giới thiệu khóa trên KDnuggets; bài tóm tắt 5 whitepaper trên aitoolsclub.com (đăng 07/03/2026). Đây là nguồn thứ cấp, báo cáo ghi rõ chỗ nào lấy từ đó.
- **Lớp 3 — whitepaper gốc "Agents" (Google, 09/2024):** bản tiền thân của loạt whitepaper khóa này, tác giả Julia Wiesinger, Patrick Marlow, Vladimir Vuskovic, 42 trang — qua bản tóm tắt độc lập (devlocus.com; xiaodu-flying.github.io) và mục lục đầy đủ trên SpeakerDeck. Dùng làm nền lý thuyết cho Day 1; loạt whitepaper 11/2025 là bộ mới, không phải bản 2024.
- **Không chạy notebook, không xem livestream, không làm capstone:** chi tiết trong notebook/video có thể sâu hơn tài liệu công khai — ghi rõ để muse-main biết giới hạn. Mọi con số trong báo cáo đều là số niêm yết công khai kèm nguồn; chỗ nào nguồn không cho số thì ghi Chưa xác định, không tự điền.

## Cấu trúc khóa (5 ngày — mỗi ngày 1 whitepaper + 2 codelab + podcast tóm tắt)

| Ngày | Chủ đề | Whitepaper (Kaggle) | Codelab (notebook) |
|---|---|---|---|
| 1 | Introduction to Agents | Introduction to Agents (Blount, Gulli, Saboo, Zimmermann, Vuskovic) | From Prompt to Action; Agent Architectures |
| 2 | Agent Tools & Interoperability with MCP | Agent Tools and Interoperability with MCP | Agent Tools; Agent Tools Best Practices |
| 3 | Context Engineering: Sessions & Memory | Context Engineering: Sessions and Memory | Agent Sessions; Agent Memory |
| 4 | Agent Quality | Agent Quality | Agent Observability; Agent Evaluation |
| 5 | Prototype to Production | Prototype to Production | Agent2Agent Communication; Agent Deployment |

Nền tảng thực hành xuyên suốt: **Gemini + Google Agent Development Kit (ADK)** — framework mã nguồn mở của Google để build agent, có bản Python, Go, Java; tương tác được với LangChain, LangGraph, CrewAI (không phải "vườn tường bao"). Kết thúc: **capstone tự chọn** — tự build một agent từ các mảnh đã học (tùy chọn, có cuộc thi riêng trên Kaggle).

## 1. Day 1 — Introduction to Agents: khi nào cần agent, khi nào chỉ cần workflow

**Định nghĩa (whitepaper Day 1, đọc qua trang Kaggle 21/11/2026):** agent không phải model AI trong một workflow tĩnh; nó là **một ứng dụng hoàn chỉnh — lập kế hoạch và hành động để đạt mục tiêu**, kết hợp khả năng suy luận của language model với khả năng hành động thực tế, xử lý nhiệm vụ nhiều bước mà model đơn lẻ không làm được. Điểm mấu chốt: agent **tự tìm bước tiếp theo** mà không cần người hướng dẫn từng bước.

**Ba thành phần của một agent** (nền từ whitepaper "Agents" 2024 + loạt 2025):

| Thành phần | Vai trò | Ví dụ trong ADK |
|---|---|---|
| **Model (bộ não)** | Ra quyết định trung tâm; suy luận theo ReAct, Chain-of-Thought, Tree-of-Thoughts | `Gemini(model="gemini-2.5-flash-lite")` |
| **Tools (đôi tay)** | Nối suy luận với thế giới ngoài: API, database, search, code execution | `google_search`, function tool tự viết |
| **Orchestration layer (hệ thần kinh)** | Vòng lặp think → act → observe; quản lý profile, instruction, memory, điều kiện dừng, xử lý lỗi | `Runner` chạy agent |

Một agent ADK tối thiểu là một bundle: `name` + `model` + `description` (để agent khác đọc được) + `instruction` (system prompt định hướng hành vi) + `tools`. `Runner` thực thi; `InMemoryRunner` đủ cho thử nghiệm, làm thật cần runner bền (persistent).

**Khi nào cần agent, khi nào không:** câu hỏi nền của Day 1 — nhiệm vụ một bước, đầu vào-ra xác định thì workflow thường đủ; nhiệm vụ nhiều bước, cần quyết định giữa chừng, phải quan sát kết quả rồi điều chỉnh thì mới cần agent. Dùng agent cho việc workflow làm được là lãng phí token và độ tin cậy.

**Thang 5 cấp độ hệ agent** (theo bài tóm tắt aitoolsclub, nguồn thứ cấp): Level 0 — chỉ suy luận, không tool; lên tới Level 4 — hệ tự tiến hóa hoàn toàn. Phần lớn agent thực tế hiện nay ở Level 1–2 (dùng tool + vòng lặp có giám sát).

**4 mẫu nối nhiều agent (ADK):**

| Mẫu | Class ADK | Khi dùng |
|---|---|---|
| LLM điều phối (coordinator) | `Agent` + `AgentTool` | Workflow nhỏ, LLM đủ tin cậy để gọi sub-agent theo thứ tự |
| Tuần tự (dây chuyền) | `SequentialAgent` | Việc phải đúng thứ tự, output agent trước là input agent sau (outline → viết → sửa) |
| Song song | `ParallelAgent` | Việc độc lập, chạy cùng lúc cho nhanh, rồi gom lại bằng Aggregator Agent |
| Vòng lặp | `LoopAgent` | Lặp tới khi đạt điều kiện (theo KDnuggets; notebook Day 1 liệt kê 4 mẫu này) |

**Quy tắc thực hành:** một agent "làm tất cả" sẽ không đáng tin — instruction phình to, khó debug, khó bảo trì. Tách thành team chuyên gia, mỗi agent một việc rõ ràng. Dữ liệu chuyền giữa agent qua session state (`output_key` + placeholder `{ten_key}` trong instruction). Lời khuyên của người học xong (KDnuggets): **chọn pipeline tuần tự trước** — thứ tự cố định nên lỗi chỉ nằm ở một stage; còn coordinator LLM thì phải có trace mới biết chuyện gì xảy ra.

## 2. Day 2 — Agent Tools & MCP: tay của agent + chuẩn cắm tool chung

**3 loại tool chính** (whitepaper Day 2, theo aitoolsclub + KDnuggets):

1. **Function Tools** — hàm Python tự viết, bọc thành tool agent gọi được.
2. **Built-in Tools** — sẵn theo nền tảng: Google Search (grounding), code execution (`BuiltInCodeExecutor`), BigQuery/Spanner (Google Cloud).
3. **Agent Tools** — agent khác được gọi như một sub-routine; agent gọi vẫn giữ quyền điều khiển cuộc hội thoại (khác handoff — chuyển hẳn quyền điều khiển cho agent khác, dùng cho chuyển tầng hỗ trợ khách hàng).

Thêm: **OpenAPI Tools** (sinh tool tự động từ spec REST API), **Long-Running Function Tools** (tác vụ dài, cần tạm dừng chờ người — xem Day 3), **MCP Tools** (xem dưới).

**Viết tool sao cho model gọi đúng — đây là nửa bài Day 2:**

- **Docstring là tài liệu duy nhất model có:** model quyết định gọi tool chỉ dựa vào mô tả — viết rõ tool làm gì, khi nào gọi, tham số là gì.
- **Type hints bắt buộc** để ADK sinh schema đúng.
- **Trả về có cấu trúc:** dict với `"status": "success"/"error"` + dữ liệu hoặc thông báo lỗi.
- **Lỗi phải kèm hướng dẫn khôi phục**, không chỉ mã lỗi.
- **Tool công bố "nhiệm vụ", không phơi API thô:** trừu tượng hóa độ phức tạp, output ngắn gọn — output dài làm phình context window, giảm hiệu năng.
- **Quy tắc vàng khi agent gọi sai tool:** đọc lại mô tả tool trước, đừng vội sửa prompt (KDnuggets).
- **Chuyên gia tính toán:** đừng để LLM tự tính nhẩm — giao cho specialist agent chỉ xuất code Python rồi chạy bằng `BuiltInCodeExecutor` trong sandbox, đảm bảo chính xác số học 100% (ví dụ notebook: agent đổi tiền tệ ủy quyền tính toán cho `calculation_agent`).

**MCP (Model Context Protocol) — khái niệm lớn nhất Day 2:**

- Chuẩn mở (lấy cảm hứng từ Language Server Protocol trong lập trình) để agent khám phá và dùng tool của hệ ngoài mà **không viết client riêng cho từng dịch vụ**. Giải bài toán tích hợp n×m: không có MCP thì mỗi agent × mỗi tool phải viết một connector riêng; có MCP thì một lớp giao tiếp chung bằng JSON schema.
- Trong ADK: `McpToolset` cấu hình kết nối tới MCP server (ví dụ chạy bằng `npx`), agent lập tức dùng được tool cộng đồng (GitHub, Slack, database, sinh ảnh, truy vấn dataset Kaggle...).
- **Giới hạn an toàn mà whitepaper thừa nhận thẳng:** vấn đề **"confused deputy"** — user quyền thấp có thể lừa agent thực hiện hành động quyền cao. MCP tự nó không giải quyết; cần lớp bảo mật ngoài (API gateway, authentication, authorization) đặt bên ngoài MCP. **Nối 191:** đây chính là phần Ú đang học sâu trong MCP Course (Hugging Face) — 193 chỉ chạm MCP ở mức "dùng chuẩn", 191 đi sâu giao thức.

**Human-in-the-loop:** tác vụ dài/hậu quả không đảo ngược được (giao dịch tiền, xóa hàng loạt) thì agent **tạm dừng, chờ người phê duyệt rồi mới tiếp tục** — cơ chế Long-Running Operation, triển khai chi tiết ở Day 3.

## 3. Day 3 — Context Engineering: Sessions & Memory

Đây là ngày được cả hai người học xong đánh giá là **tác động tư duy nhiều nhất** (DEV: "ngày ảnh hưởng lớn nhất tới cách tôi nghĩ"). Phân biệt nền tảng: **prompt engineering** là viết câu lệnh hay; **context engineering** là **lắp ráp và quản lý động toàn bộ thông tin trong context window ở mỗi lượt** — lịch sử hội thoại, memory dài hạn, định nghĩa tool, dữ liệu ngoài, sở thích user.

**Hai khái niệm phải tách bạch:**

| Khái niệm | Vai trò | Ẩn dụ |
|---|---|---|
| **Session (ngắn hạn)** | Lịch sử trong một cuộc hội thoại: các Event (tin user, trả lời agent, tool call) + State (bản nháp) | Cái bảng trắng — xóa khi session kết thúc |
| **Memory (dài hạn)** | Tồn tại qua nhiều session: sở thích, quyết định cũ, ngữ cảnh đã học | Kho lưu trữ — làm agent "thực sự biết bạn" |

Model tự nó **không nhớ gì giữa các lần gọi** — mỗi lượt agent phải gửi lại lịch sử, và lịch sử đó tốn token. Không có context engineering, agent gãy ở hai chỗ: **tràn context window** (hội thoại dài vượt giới hạn model) và **stateless** (session mới bắt đầu từ số 0).

**Triển khai trong ADK (theo notebook Day 3, DEV ghi chi tiết):**

- **SessionService** là tầng lưu trữ session (Events + State); **Runner** tự duy trì lịch sử và lo context engineering. `InMemorySessionService` chỉ cho dev (mất khi tắt app); `DatabaseSessionService` (SQLite trong demo) giữ được qua lần khởi động lại; `VertexAiSessionService` cho production trên Google Cloud.
- **Session isolation:** session ID khác nhau thì hội thoại tách biệt hoàn toàn — agent không lẫn ngữ cảnh.
- **Context compaction:** khi lịch sử quá dài, dùng LLM tóm tắt phần cũ thành một message tóm gọn (`EventsCompactionConfig`: `compaction_interval` — mấy lượt thì nén một lần, ví dụ 3; `overlap_size` — giữ nguyên mấy lượt gần nhất, ví dụ 1). Giảm token + độ trễ.
- **Long-term memory — nạp và truy hồi:** `memory_service.add_session_to_memory(session)` chuyển lịch sử session vào MemoryService; nạp tay sau session, hoặc tự động bằng `after_agent_callback` sau mỗi lượt (production). Agent truy hồi bằng tool riêng:
  - `load_memory` (reactive — agent tự quyết khi nào tìm): tiết kiệm token.
  - `preload_memory` (proactive — tìm trước mỗi lượt): đảm bảo có ngữ cảnh, tốn một lần tìm mỗi lượt.
- **Memory consolidation (mở rộng):** lưu nguyên văn 50 message thì vừa cồng kềnh vừa nhiễu. Dùng LLM trích chỉ fact quan trọng, gọn ("Màu yêu thích: xanh lam") và bỏ nhiễu hội thoại → lưu ít hơn, tìm nhanh hơn, trả lời chính xác hơn. Dịch vụ quản lý như `VertexAiMemoryBankService` tự làm consolidation + tìm theo ngữ nghĩa sau cùng một API (`add_session_to_memory`, `search_memory`).
- **Memory ETL:** pipeline Extract → Transform → Load — rút fact có nghĩa từ hội thoại nhiễu, giải quyết mâu thuẫn, lưu có cấu trúc để truy hồi (whitepaper Day 3, theo aitoolsclub).
- **Long-Running Operations (LRO):** tool tạm dừng được (`place_shipping_order` trong notebook) kiểm tra `tool_context`; chưa có quyết định thì gọi `tool_context.request_confirmation()` → agent dừng, sinh event `adk_request_confirmation` (kèm `invocation_id`, `approval_id`); workflow ngoài chờ người quyết rồi gửi lại `FunctionResponse` với đúng `invocation_id` để resume đúng chỗ. App phải bật `ResumabilityConfig(is_resumable=True)` để lưu toàn bộ trạng thái session khi dừng.

**Nối mạch memory 127/128/130:** Day 3 của 193 là bản "làm trong ADK" của cùng vấn đề mà 127 (Long-Term Agentic Memory, LangGraph), 128 (Agent Memory, DeepLearning.AI × Oracle) và 130 (LLMs as Operating Systems, Letta/MemGPT) đã học ở góc khác — session/memory, consolidation, truy hồi reactive/proactive là khái niệm chung, chỉ khác framework. Ai đã đọc 127/128/130 thì Day 3 chủ yếu là "dịch" sang ADK.

## 4. Day 4 — Agent Quality: đo được mới tin được

Tiền đề: agent **không xác định** — cùng input, lần chạy sau có thể đi đường khác. Kiểm tra spot-check đáp án cuối không bao quát được, nên chất lượng phải là **thiết kế từ đầu**, không phải việc gắn thêm sau.

**Khung chất lượng 4 trụ** (whitepaper Day 4, theo aitoolsclub):

| Trụ | Câu hỏi |
|---|---|
| **Effectiveness** | Agent có đạt mục tiêu không? |
| **Efficiency** | Đạt mục tiêu có tối ưu chi phí/thời gian không? |
| **Robustness** | Gặp lỗi/trường hợp biên có xử lý êm không? |
| **Safety** | Có tuân thủ hướng dẫn đạo đức/chính sách không? |

**Deep Observability Trinity — bộ ba làm chất lượng đo được:**

- **Logs:** ghi từng sự kiện (tool call nào, quyết định nào, lúc nào).
- **Traces:** nối log thành chuỗi — cho thấy agent đi qua các bước nào, vì sao ra kết quả đó. Trace làm đáp án sai **debug được sau khi xảy ra**.
- **Metrics:** số tổng hợp — độ trễ, tỉ lệ hoàn thành nhiệm vụ, tần suất lỗi.

Thực hành (notebook Agent Observability, theo DEV): debug bằng **ADK Web UI** — tab Events + Trace view để theo dấu đường chạy, soi `function_call` input/output để tìm nguyên nhân gốc (ví dụ trong notebook: bug là `root_agent` truyền list papers cho tool `count_papers` dưới dạng một `str` thay vì `List[str]`, đếm sai). Production thì dùng **Plugin + Callback** (`before_agent_callback`, `after_tool_callback`, `on_model_error_callback`...); ADK có sẵn `LoggingPlugin` ghi toàn bộ hoạt động (tin nhắn, thời gian, request/response LLM, tool call, trace đầy đủ).

**Đánh giá kép — đo cả đáp án lẫn đường đi (whitepaper Day 4):**

- **Blackbox (outside-in):** kiểm tra kết quả cuối.
- **Glassbox (inside-out):** kiểm tra quỹ đạo suy luận — vì agent có thể ra **đáp án đúng bằng đường sai**. Ví dụ trong KDnuggets: agent gọi đúng tool 3 lần trong khi 1 lần là đủ — đáp án giống nhau, chi phí gấp 3. **Chỉ đo đáp án cuối sẽ bỏ lọt lỗi này.**
- Hai chỉ số trong ADK (notebook Agent Evaluation): **Response Match Score** (độ giống đáp án cuối với đáp án kỳ vọng; 1.0 = khớp hoàn toàn) và **Tool Trajectory Score** (đúng chuỗi tool + đúng tham số không; 1.0 = dùng tool hoàn hảo).
- **Phương pháp đánh giá ở quy mô lớn:** LLM-as-a-Judge (dùng model khác chấm — phải hiệu chỉnh thiên kiến như thích câu dài, nịnh user — bằng tập test có đối chiếu người thật); Human-in-the-Loop (chuyển ca biên/quyết định rủi ro cao cho người review); **Golden Datasets** (bộ test case đã biết đúng/sai, xương sống của regression test).
- **Quy trình ADK:** tạo test case trong Web UI (lưu phiên chat live thành dữ liệu đánh giá) → file `*.test.json` (ground truth: đáp án + quỹ đạo tool kỳ vọng) + `*.evalset.json` (nhóm test case) + `test_config.json` (metric + model) → chạy `adk eval` (tích hợp pytest) → đọc báo cáo, phát hiện regression. Chạy đánh giá liên tục thì regression lộ sớm.

**Câu chốt của whitepaper (theo aitoolsclub):** agent **không đo được thì không tin được** — xây khung đánh giá từ ngày đầu, đừng gắn thêm sau.

## 5. Day 5 — Prototype to Production: 20% model, 80% hạ tầng

**Câu quan trọng nhất Day 5:** xây model AI chỉ là **20% công việc**; 80% còn lại là hạ tầng — pipeline CI/CD, lớp bảo mật, hệ giám sát, khung kiểm chứng — mới biến prototype thành giải pháp cấp doanh nghiệp (whitepaper Day 5, theo aitoolsclub).

**Phễu CI/CD 3 pha** (thay cho vòng đời tuyến tính đơn giản):

1. **Pre-merge CI:** cổng đánh giá tự động chạy trước khi code vào main branch.
2. **Staging validation:** test trong môi trường giống production, với golden dataset + LLM judge.
3. **Gated production rollout:** canary (1% traffic trước), blue-green (rollback tức thì), A/B testing.

**A2A (Agent2Agent Protocol) — chuẩn giao tiếp giữa các agent:**

- MCP lo **gọi tool không trạng thái** (lấy thời tiết...); A2A lo **cộng tác có trạng thái giữa các agent** (phân tích churn khách hàng rồi đề xuất chiến lược...). Hai chuẩn **dùng chung, bổ sung nhau** — không thay nhau.
- Một agent được expose thành service; agent khác biết nó làm được gì bằng cách đọc **Agent Card** (file JSON mô tả năng lực tại `/.well-known/agent-card.json`).
- **Khi nào dùng A2A, khi nào dùng sub-agent nội bộ** (bảng trong notebook, theo DEV):

| Yếu tố | Dùng A2A | Dùng sub-agent nội bộ |
|---|---|---|
| Vị trí agent | Service ngoài, codebase khác | Cùng codebase, nội bộ |
| Sở hữu | Team/tổ chức khác | Team mình |
| Mạng | Máy khác nhau (có độ trễ) | Cùng process/máy (trễ thấp) |
| Ngôn ngữ/framework | Cần đa ngôn ngữ/framework | Cùng ngôn ngữ |
| Hợp đồng | Cần hợp đồng API chính thức (Agent Card) | Interface nội bộ |

- Trong ADK: agent server gọi `.to_a2a()` (bọc thành server FastAPI/Starlette, tự sinh Agent Card); agent client dùng `RemoteA2aAgent` làm proxy — đọc Agent Card từ URL rồi dịch lệnh gọi sub-agent nội bộ thành request A2A (HTTP POST tới `/tasks`). Ví dụ notebook: Customer Support Agent (client) hỏi Product Catalog Agent (server) qua A2A.
- **Deploy lên Vertex AI Agent Engine** (notebook Agent Deployment, theo DEV): đóng gói thư mục `sample_agent` gồm `agent.py` (logic + tool), `requirements.txt` (`google-adk`, `opentelemetry-instrumentation-google-genai`), `.env` (`GOOGLE_GENAI_USE_VERTEXAI=1`), `.agent_engine_config.json` (`min_instances: 0` để tiết kiệm chi phí, `max_instances: 1`); deploy bằng `adk deploy agent_engine --project=... --region=... sample_agent`; test trên managed service rồi theo dõi qua Vertex AI Console, bật tracing (`enable_tracing=True`) khi debug phức tạp. **Nhớ dọn resource test để khỏi tốn tiền.**
- **Memory Bank trên production:** thêm memory tool (ví dụ `PreloadMemoryTool`) + callback lưu hội thoại vào Memory Bank rồi deploy lại — session memory chỉ sống một cuộc hội thoại, Memory Bank giữ qua mọi cuộc hội thoại.
- Ngoài ra khóa nhắc tới thực hành **AgentOps** (CI/CD + giám sát sau launch) và ADK có bản Go/Java bên cạnh Python.

**Capstone (tùy chọn):** tự build một agent từ các mảnh trên. Ví dụ của người học (DEV): hệ multi-agent phân tích tài chính mobile-money (M-Pesa, Kenya) — 5 agent chuyên biệt (ingestion, cashflow, risk, SME insights, reporting) + pausable tool xin phép user trước khi chạm dữ liệu + A2A để ngân hàng gọi agent phân tích như API thường + memory dài/ngắn hạn + observability/evaluation. Một ví dụ khác (DEV): hệ multi-agent du lịch (Flight/Hotel/Planner Agent).

## 6. Áp dụng cho Anh — 6 việc rút ra, gắn với việc thật của Anh

Anh không phải dev chuyên agent, nhưng khóa này soi thẳng vào 3 việc Anh đang làm: **nhóm 3 Muse**, **quy trình vBook**, và **cách viết tài liệu**. Mỗi điểm dưới đây nối một ngày học với một việc thật.

| # | Việc | Nối với khóa học | Ưu tiên |
|---|---|---|---|
| 1 | **Nhìn nhóm 3 Muse như một multi-agent system — và giữ đúng mẫu đã chọn** | Day 1: team mình đang chạy mẫu **tuần tự + song song**: Vịt/Ú build song song (ParallelAgent), chị Bẹp review rồi mới merge (SequentialAgent: build → review → merge). Đừng để một agent "làm tất cả" (build + tự merge) — đúng lỗi whitepaper cảnh báo: monolith khó debug, khó tin. Quy tắc "chỉ muse-main merge" chính là **điều phối có kiểm soát** thay vì để LLM tự quyết. | Cao — đang áp dụng, giữ nguyên |
| 2 | **Đo cả quá trình, không chỉ kết quả — đúng quy tắc 144 + §11** | Day 4 (Glassbox): đáp án đúng vẫn có thể đi đường sai. Bộ 3 điều kiện merge (validate PASS + device test code 0 + install 200) chính là **Response Match Score + Tool Trajectory Score** của team: validate = đáp án, device test/install = quỹ đạo thật trên máy Anh. Báo "xong" mà thiếu một trong ba là "xong ảo" (§11). Khi review, ngoài kết quả phải xem cả nguồn/truy vấn worker đã thử (quy tắc task 150 §8.2/§8.3, PROTOCOL §4). | Cao — đã có cơ chế, nhắc lại để khỏi mòn |
| 3 | **Human-in-the-loop đã có sẵn: quyền Anh cấp 20/11 chính là thiết kế HITL** | Day 2–3: tác vụ không đảo ngược được thì agent phải dừng chờ người. Anh đã cấp quyền mặc định cho task của Anh/chị Bẹp, **trừ** thanh toán, đổi cài đặt, ngắt dịch vụ — đúng ranh giới "pausable tool" của khóa: việc thường chạy tiếp, việc rủi ro cao thì dừng xin phép. Đừng mở rộng quyền mặc định sang 3 việc trừ đó khi chưa có quyết định mới của Anh. | Cao — ranh giới, không tự nới |
| 4 | **Viết task file như viết tool description** | Day 2: model chỉ quyết định dựa vào mô tả — mô tả càng rõ, càng ít gọi sai. Task file cũng vậy: checklist rõ, delegation 1 dòng, notes ngắn (task 151: notes dài gây "context rot"). Khi worker làm sai hướng, đọc lại task file trước, đừng vội sửa quy trình. | Trung bình — áp dụng khi tạo task mới |
| 5 | **Memory của team = session + long-term memory của Day 3** | Task file là **session** (trạng thái việc đang làm); MEMORY.md + `research/` là **long-term memory** (fact bền, báo cáo đã học). **Context compaction** chính là lý do PROTOCOL §8 bắt notes ngắn, chuyển log cũ sang archive: càng nhồi, worker càng nhớ sai. Khi giao task mới, chỉ đưa "tập token tín hiệu cao nhỏ nhất" (task 151), không copy cả lịch sử. | Trung bình — đã có quy tắc, đây là lý do khoa học đằng sau nó |
| 6 | **Prototype ≠ production — bài học Buzz còn nguyên** | Day 5: model chỉ 20%, hạ tầng 80%. Relay Buzz chạy natively là prototype chạy được; mất khi VM bị thay vì không có hạ tầng production (Railway deploy Anh đã chọn 14/11 nhưng chưa xác nhận thử). Lần sau đưa cái gì lên production thì đi đủ 3 pha: CI gate → staging giống thật → rollout có kiểm soát (canary/rollback), đừng đẩy thẳng từ notebook/demo. | Trung bình — nhắc khi có deploy mới |

## 7. Đề xuất cập nhật skill / bước tiếp theo

- **Không đề xuất sửa skill vbook-extension-building:** khóa này về kiến trúc agent, không đổi quy trình build extension. Nhưng 3 nguyên tắc đáng nhớ khi viết task + review: (1) mô tả tool/task càng rõ càng ít sai (Day 2); (2) đo cả quỹ đạo, không chỉ kết quả (Day 4); (3) notes ngắn, archive log cũ (Day 3) — Vịt tự áp dụng, không cần sửa skill.
- **Đề xuất bổ sung nhỏ cho PROTOCOL.md (để muse-main quyết):** §11 đã có gate bằng chứng khi nộp task; Day 4 cho thêm một mục kiểm tra khi chấm review — **"đáp án đúng, đường đi có đúng không"**: worker nộp review thì muse-main kiểm tra cả log/quỹ đạo (tool nào đã gọi, nguồn nào đã đọc), không chỉ file kết quả. Đây chính là Glassbox evaluation; team đã làm một nửa qua quy tắc 150 §8.2/§8.3, chỉ cần ghi thành checklist chấm review.
- **Nối tiếp mạch AI Agents:** 125 (LangGraph) → 148 (HF Agents Course) → **193 (Kaggle/Google ADK)** → 191 (MCP, Ú đang review) → 127/128/130 (memory). Sau 193, mạch này đã đủ 5 mảnh: framework LangGraph, tổng quan HF, kiến trúc + production theo Google ADK, giao thức MCP, và memory dài hạn. Khóa tiếp theo trong đợt 12 khóa AI/Dev do muse-main giao theo thứ tự.
- **Chưa xác định (không tự điền):** tác giả whitepaper Day 2–5; số trang từng whitepaper; chi tiết bản làm mới vibe-coding 06/2026 (nội dung mới, có thay đổi gì ở Day 4 về bảo mật); tên file/cấu hình chính xác của notebook Day 2–5 ngoài các tên đã liệt kê; deadline/giải thưởng chi tiết của capstone. Muốn biết chính xác thì phải mở trang Learn Guide Kaggle (hôm nay trả 429) hoặc chạy notebook (cần tài khoản Kaggle + Gemini API key — cần tay Anh, Vịt không tạo tài khoản thay).
- **Cần Anh quyết (0 việc):** không có việc nào cần Anh quyết từ khóa này — toàn bộ nội dung FREE công khai, không cần tài khoản, không mua gì, không deploy gì. Nếu Anh muốn chạy thử notebook ADK bằng Gemini API free tier (task 121 đã có hướng dẫn rẻ nhất: Streamlit + Gemini API free tier) thì nói Vịt một tiếng — cần API key của Anh, Vịt không tự lấy.

## Nguồn

- Trang khóa chính thức (đã kết thúc live, trả 404 khi kiểm chứng 21/11; nay học qua Learn Guide): https://www.kaggle.com/competitions/5-day-ai-agents-intens
- Learn Guide (trả 429 khi đọc 21/11/2026): https://www.kaggle.com/learn-guide/5-day-agents
- Whitepaper Day 1: https://www.kaggle.com/whitepaper-introduction-to-agents
- Whitepaper Day 2: https://www.kaggle.com/whitepaper-agent-tools-and-interoperability-with-mcp
- Whitepaper Day 3: https://www.kaggle.com/whitepaper-context-engineering-sessions-and-memory
- Whitepaper Day 4: https://www.kaggle.com/whitepaper-agent-quality
- Whitepaper Day 5: https://www.kaggle.com/whitepaper-prototype-to-production
- Bài giới thiệu khóa (KDnuggets): https://www.kdnuggets.com/kaggle-googles-free-5-day-agentic-ai-course
- Bài người học xong (Bala Priya, KDnuggets): https://www.kdnuggets.com/what-i-learned-from-kaggle-googles-free-agentic-ai-course
- Tóm tắt 5 whitepaper (AIToolsClub, 07/03/2026): https://aitoolsclub.com/how-to-build-an-ai-agent-a-complete-guide/
- Tổng kết 5 ngày + capstone (Peter Wanga, DEV, 05/12/2025): https://dev.to/wanga_peterotienopa106/five-days-endless-possibilities-here-is-the-five-day-summary-and-a-capstone-project-52ia
- Whitepaper "Agents" (Google, 09/2024) — tóm tắt: https://devlocus.com/posts/agents-by-google ; https://xiaodu-flying.github.io/posts/agents-from-google/index.html
- Khóa Gen AI Intensive tiền thân (KDnuggets): https://www.kdnuggets.com/kaggle-googles-free-5-day-gen-ai-course
- Chứng chỉ Kaggle không có giám sát (DesignCopy, cập nhật 17/06/2026): https://designcopy.net/en/google-gen-ai-intensive-review-2026/
- Báo cáo nối tiếp trong repo: `research/125-ai-agents-langgraph-deeplearning-ai.md`, `research/148-ai-agents-course-hugging-face.md`, `research/127-long-term-agentic-memory-langgraph-deeplearning-ai.md`, `research/128-agent-memory-building-memory-aware-agents-deeplearning-ai-oracle.md`, `research/130-llms-as-operating-systems-agent-memory-letta-memgpt.md` (191 — MCP Course — đã merge, `research/191-mcp-course-hugging-face.md`)

---
*Báo cáo tự học task 193 — muse-2 (Vịt), 21/11/2026. Chỉ nội dung FREE công khai; không tạo tài khoản Kaggle, không chạy notebook cần đăng nhập, không mua gì, không hứa chứng chỉ.*
