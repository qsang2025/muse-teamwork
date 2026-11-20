# AI Agents in LangGraph (DeepLearning.AI) — Báo cáo tự học (task 125)

- **Khóa học:** AI Agents in LangGraph, DeepLearning.AI (hợp tác LangChain + Tavily)
- **Trang khóa:** https://www.deeplearning.ai/courses/ai-agents-in-langgraph
- **Giảng viên:** Harrison Chase (Co-Founder/CEO LangChain — tác giả framework được dạy) và Rotem Weiss (Co-Founder/CEO Tavily); phần mở đầu do Andrew Ng (Founder, DeepLearning.AI) dẫn khung agentic workflows
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE, **không đăng ký chứng chỉ trả phí** (theo checklist task 125; bản DeepLearning.AI vốn không cấp chứng chỉ, bản Coursera là Guided Project sau gói trả phí). **Không chạy notebook** — các code example cần `OPENAI_API_KEY` (gọi API tính phí theo token) và `TAVILY_API_KEY` cho bài agentic search; báo cáo học kỹ nội dung qua trang khóa chính thức + transcript bài học trên learn.deeplearning.ai + ghi chép chi tiết của học viên đã hoàn thành khóa (xem mục Nguồn).
- **Quy mô khóa:** 8 bài (Introduction + 6 bài code + Conclusion), 6 code example (Jupyter notebook, Python); tổng thời lượng khoảng 1 giờ 47 phút, trình độ Intermediate. Phát hành 05/06/2024.
- **Mô hình/công cụ dùng trong khóa (bản 2024):** OpenAI API (`gpt-3.5-turbo`, `temperature=0` ở bài build-from-scratch; các bài LangGraph dùng `ChatOpenAI` qua LangChain) + LangGraph/LangChain + Tavily Search (`max_results=4`). Xem §9 về những gì đã đổi tới 2026.
- **Vị trí trong vòng tự học:** khóa 2 theo phân vai của muse-1. Nối tiếp task 123 (ChatGPT Prompt Engineering): task 123 dạy "một prompt, một lần gọi" và chatbot nhiều lượt thủ công (OrderBot — ứng dụng tự giữ lịch sử, tự lặp vòng); khóa này nâng đúng cấu trúc đó lên **agent có trạng thái, vòng lặp và công cụ** do framework quản lý. Đối chiếu chi tiết ở §10. Cũng nối task 121 (function calling phía Google/Gemini) ở mảng "model đề xuất gọi hàm, code thực thi".
- **Phạm vi báo cáo:** toàn bộ 8 bài (§1–§8) + cập nhật tình hình LangGraph 2026 (§9) vì khóa gốc quay giữa 2024, trước LangGraph 1.0.

## Cấu trúc khóa (syllabus)

| Bài | Tên | Nội dung chính |
|---|---|---|
| 1 | Introduction | Agentic workflows là gì; bốn design pattern: Reflection, Tool Use, Planning, Multi-Agent |
| 2 | Build an Agent from Scratch | Tự viết agent ReAct bằng Python thuần: vòng Thought → Action → PAUSE → Observation |
| 3 | LangGraph Components | Dựng lại agent bài 2 bằng LangGraph: nodes, edges, conditional edges, AgentState |
| 4 | Agentic Search Tools | Agentic search (Tavily) khác tìm kiếm truyền thống ra sao; gắn search làm tool cho agent |
| 5 | Persistence and Streaming | Checkpointer lưu state theo thread; stream sự kiện và stream token |
| 6 | Human-in-the-Loop | Ngắt graph trước node chạy tool để người duyệt/sửa state rồi mới chạy tiếp |
| 7 | Essay Writer | Agent viết essay nhiều bước: plan → research → generate → reflect → revise (có trần số vòng) |
| 8 | Conclusion | Tổng kết: từ agent tự viết tới agent có kiểm soát bằng graph |

Đường đi của khóa: **tự viết vòng lặp agent bằng tay trước (bài 2), rồi mới dựng lại bằng framework (bài 3)** — để thấy framework đang trừu tượng hóa đúng cái gì, thay vì học thuộc API.

## 1. Agentic workflows và bốn design pattern (bài 1)

- **Zero-shot vs agentic:** hỏi LLM một lần và lấy ngay đáp án (zero-shot) giống bắt người viết essay một mạch không được sửa, không được tra cứu. **Agentic workflow** cho model làm việc theo vòng lặp: suy nghĩ, hành động, quan sát kết quả, sửa lại — chất lượng tăng nhờ *quy trình*, không nhờ đổi model lớn hơn. Đây là bước nhảy từ task 123 (tối ưu một lần gọi) sang khóa này (thiết kế vòng lặp nhiều lần gọi).
- **Bốn design pattern** mà bài mở đầu dùng làm khung khái niệm:
  1. **Reflection (tự phản biện):** model xem lại đầu ra của chính mình và sửa — vòng lặp "viết → phê → viết lại".
  2. **Tool Use (dùng công cụ):** model gọi hàm/API ngoài (tìm kiếm, tính toán, truy vấn dữ liệu) để lấy thông tin ngoài tham số của nó.
  3. **Planning (lập kế hoạch):** chia task lớn thành các bước, thực thi từng bước, điều chỉnh kế hoạch khi có thông tin mới.
  4. **Multi-Agent (nhiều agent):** nhiều agent chuyên vai (researcher, writer, critic...) phối hợp trên cùng một task.
- Khóa này tập trung vào Tool Use + vòng lặp ReAct (bài 2–6) và ghép Planning + Reflection ở bài cuối (Essay Writer, bài 7). Multi-Agent chỉ được giới thiệu ở mức khái niệm — không có bài code riêng.

## 2. Tự viết agent từ số 0 — vòng lặp ReAct (bài 2)

Bài học nền tảng nhất của khóa: **agent = một vòng `while` quanh LLM + một giao thức văn bản để gọi tool**. Không framework, chỉ Python thuần + OpenAI API.

- **Mẫu ReAct (Reasoning + Acting):** thay vì bắt model trả lời ngay (nơi nó phải đoán khi không biết), prompt buộc model chạy vòng **Thought → Action → PAUSE → Observation**: Thought là suy luận thành lời, Action là lệnh gọi một tool có sẵn (kèm đầu vào), PAUSE là điểm dừng để code ngoài chạy tool, Observation là kết quả tool được đưa ngược vào hội thoại. Vòng lặp chạy tới khi model xuất **Answer**. CoT thuần (task 120/123) chỉ có Thought; ReAct cộng thêm khả năng chạm vào thế giới ngoài qua Action/Observation — đúng chỗ CoT bị ảo giác vì không kiểm chứng được.
- **Cấu trúc code tự viết:**
  - Một class `Agent` giữ `messages` (system + lịch sử) — chính là "trí nhớ nằm ở ứng dụng" của task 123 §7, chưa có gì mới.
  - System prompt mô tả giao thức vòng lặp, liệt kê các action khả dụng kèm ví dụ (`calculate: 4 * 7 / 3`, `average_dog_weight: Collie`) và một phiên mẫu hoàn chỉnh (few-shot — tactic của task 123 §2).
  - Hàm `query(question, max_turns=5)`: gọi model → dùng **regex** `^Action: (\w+): (.*)$` trích action từ văn bản trả về → chạy hàm Python tương ứng trong dict `known_actions` → nối `Observation: ...` làm prompt tiếp theo → lặp. Không còn action thì dừng.
  - Ví dụ xuyên suốt: "2 con chó Border Collie + Scottish Terrier nặng tổng bao nhiêu" → agent tự gọi `average_dog_weight` hai lần (37 lbs, 20 lbs) rồi `calculate: 37 + 20` → Answer 57 lbs. Model quyết định *thứ tự gọi tool*, code chỉ thực thi.
- **Phân công lao động (điểm khóa nhấn mạnh):** LLM làm phần "quyết định làm gì tiếp theo"; code quanh LLM làm phần "thực thi, giữ lịch sử, dừng vòng lặp". Model không bao giờ tự chạy hàm — nó chỉ sinh văn bản nêu tên action. Đây là cùng ranh giới với function calling của task 121 ("model chỉ đề xuất, app mới thực thi"), chỉ khác cơ chế: ở đây giao thức là văn bản tự chế + regex, ở task 121 là schema hàm do SDK sinh.
- **Giới hạn của bản tự viết** (lý do cần bài 3): parse bằng regex rất mong manh (model lệch định dạng là hỏng); lịch sử chỉ nằm trong RAM của một tiến trình (chết là mất, không nối lại được); không có điểm dừng để người duyệt trước khi tool chạy; vòng lặp và trạng thái trộn lẫn trong một hàm `query` khó kiểm soát khi workflow dài ra. Bốn giới hạn này lần lượt được LangGraph xử lý ở bài 3, 5, 6.

## 3. Dựng lại bằng LangGraph — nodes, edges, state (bài 3)

LangGraph mô hình hóa agent thành một **đồ thị có hướng có thể có vòng lặp** (cyclic graph) — điểm khác căn bản với chain tuyến tính của LangChain cổ điển (DAG, không quay lui được). Ba thành phần cốt lõi:

- **State (`AgentState`):** một `TypedDict` dùng chung cho cả graph, ở bài này chỉ có một khóa `messages` được chú thích `Annotated[list, operator.add]` — chú thích đó là **reducer**: mỗi node trả về message mới thì *nối thêm* vào danh sách cũ thay vì ghi đè. State là "bộ nhớ làm việc" duy nhất chảy qua mọi node.
- **Nodes (nút):** mỗi node là một hàm nhận state, trả về phần state cập nhật. Agent của bài 3 có hai node: node `llm` (gọi model đã gắn tools — model có thể trả về tool call thay vì văn bản) và node `action` (thực thi các tool call đó, trả kết quả thành message).
- **Edges (cạnh):** cạnh thường nối node → node; **conditional edge** là hàm đọc state rồi quyết định đi tiếp đâu. Sau node `llm`, conditional edge kiểm tra message cuối có tool call không: có → sang node `action` rồi quay lại `llm`; không → kết thúc (`END`). Vòng `llm → action → llm` chính là vòng ReAct của bài 2, nhưng được khai báo thành đồ thị thay vì giấu trong vòng `while`.
- **Compile:** graph khai báo xong phải `compile()` thành một runnable mới chạy được — bước này cũng là nơi gắn checkpointer và điểm ngắt ở các bài sau.
- **Lợi ích so với bản tự viết:** luồng điều khiển nhìn thấy được (vẽ được đồ thị), từng node kiểm tra/thay thế độc lập được, trạng thái có schema rõ ràng, và vòng lặp là tính năng hạng nhất thay vì mẹo vòng `while`. Đổi lại: nhiều khái niệm hơn cho bài toán nhỏ — khóa cố ý dạy bản tự viết trước để người học tự cân được khi nào cần tới mức này.

## 4. Agentic search — tìm kiếm thiết kế cho agent, không cho người (bài 4)

- **Tìm kiếm truyền thống** trả về trang kết quả (SERP) gồm tiêu đề + link + đoạn trích, thiết kế cho *người* bấm vào đọc tiếp. Đưa nguyên SERP cho LLM là bắt nó tự lọc nhiễu (quảng cáo, menu, HTML) và tự đi lấy nội dung từng link — tốn token, dễ sai.
- **Agentic search** (khóa dùng Tavily): một lần gọi API trả về **nhiều câu trả lời/nội dung đã trích sẵn trong định dạng dự đoán được** (danh sách kết quả có cấu trúc: url, title, content, điểm liên quan; tùy chọn thêm trường `answer` tổng hợp) — tức là trả về *dữ liệu dùng ngay*, không phải danh sách link chờ xử lý. Khóa gắn Tavily làm tool cho agent bài 3 với `max_results=4`.
- Bài học khái niệm: **chất lượng agent bị chặn bởi chất lượng dữ liệu đưa vào vòng lặp**. Tool trả về dữ liệu càng sạch và có cấu trúc, bước suy luận sau càng đáng tin — cùng tinh thần "đóng khung đầu ra thành định dạng kiểm chứng được" của task 120/123, nhưng áp cho *đầu vào* của agent. Đây cũng là dạng grounding thực hành: agent tra cứu trước khi trả lời thay vì trả lời từ trí nhớ huấn luyện (chống ảo giác, nối task 123 §4).

## 5. Persistence và streaming — agent sống lâu hơn một lần chạy (bài 5)

Hai khái niệm cho agent chạy task dài:

- **Persistence (bền trạng thái) qua checkpointer:** LangGraph lưu một **checkpoint của state sau mỗi node**. Khóa dùng `SqliteSaver` (SQLite trong bộ nhớ) truyền vào `compile(checkpointer=...)`. Mỗi cuộc hội thoại gắn một `thread_id` trong config — nhiều thread chạy song song không lẫn nhau, tắt tiến trình mở lại vẫn nối tiếp được đúng trạng thái cũ, và xem lại được state tại từng thời điểm (nền của "time travel"/debug theo bước). So với bài 2: lịch sử không còn chết theo tiến trình.
- **Streaming (phát tín hiệu theo thời gian thực):** thay vì chờ agent chạy xong mới thấy kết quả, `stream()` phát ra từng cập nhật state khi nó xảy ra; `astream_events()` (bất đồng bộ, cần async checkpointer) phát xuống tận từng token. Người vận hành nhìn thấy agent đang ở node nào, vừa gọi tool gì — điều kiện để giám sát và can thiệp kịp thời ở bài 6.
- Hệ quả thực hành: **mọi bước trung gian đều để lại dấu vết khôi phục được**. Agent chết giữa chừng không mất việc đã làm; người sau nối tiếp từ checkpoint cuối thay vì làm lại từ đầu.

## 6. Human-in-the-loop — ngắt graph để người duyệt (bài 6)

- **Cơ chế:** khi compile, truyền `interrupt_before=["action"]` — graph **tự dừng ngay trước node chạy tool**. Tại điểm dừng, người vận hành đọc được toàn bộ state hiện tại (`get_state()` — gồm cả node sắp chạy tiếp theo), sửa state nếu cần (`update_state()`), rồi cho chạy tiếp bằng cách gọi stream lại với input `None` trên cùng `thread_id`.
- **Chi tiết kỹ thuật đáng nhớ:** để *sửa* được một message đã có (thay vì chỉ nối thêm), khóa thay reducer mặc định `operator.add` bằng một hàm reducer tùy biến: message mới trùng `id` với message cũ thì **thay thế**, không trùng thì nối thêm. Cùng một state, hai chính sách cập nhật khác nhau cho hai nhu cầu khác nhau (ghi nhật ký vs sửa bản nháp).
- **Ý nghĩa:** đây là cổng kiểm duyệt đặt đúng chỗ nguy hiểm nhất — **ngay trước khi hành động có tác dụng phụ được thực thi**. Model đề xuất gọi tool; con người (hoặc code kiểm chứng) duyệt tham số trước khi tool chạy. Đặt cạnh task 121: cùng một ranh giới "model đề xuất, code thực thi", bài này cho thêm *điểm dừng chính thức* trong luồng để việc duyệt đó xảy ra, thay vì duyệt rải rác trong code.

## 7. Essay Writer — ghép Planning + Reflection thành workflow thật (bài 7)

Bài tổng hợp: agent viết essay mô phỏng quy trình của một nhà nghiên cứu — lập dàn ý, tra cứu, viết nháp, tự phê, tra cứu bổ sung theo phê bình, viết lại.

- **State giàu hơn hẳn các bài trước:** `task` (đề bài), `plan` (dàn ý), `draft` (bản nháp), `critique` (phê bình), `content` (tài liệu tra cứu được), `revision_number` (đang ở vòng sửa thứ mấy), `max_revisions` (trần số vòng sửa). State không còn chỉ là lịch sử chat mà là **hồ sơ công việc có cấu trúc**.
- **Các node:** `planner` (sinh dàn ý từ đề bài) → `research_plan` (sinh truy vấn tra cứu theo dàn ý, gọi Tavily, lưu vào `content`) → `generate` (viết nháp từ dàn ý + tài liệu) → `reflect` (đọc nháp, viết phê bình vào `critique`) → `research_critique` (tra cứu bổ sung theo phê bình) → quay lại `generate`. Conditional edge `should_continue` đọc `revision_number`: vượt `max_revisions` thì `END`, chưa thì lặp tiếp.
- **Ba bài học rút ra:**
  1. **Planning tách khỏi thực thi:** dàn ý được sinh và lưu thành một trường state riêng trước khi viết — các node sau bám vào dàn ý đó thay vì tự quyết lại từ đầu mỗi bước.
  2. **Reflection là một node, không phải một câu prompt:** việc tự phê được đóng gói thành bước riêng có đầu vào/đầu ra rõ ràng (nháp vào, critique ra), và critique đó *điều khiển* bước tra cứu tiếp theo — phản biện mà không dẫn tới hành động sửa thì vô ích.
  3. **Vòng lặp bắt buộc có trần:** `max_revisions` là phanh cứng chống lặp vô hạn (agent tự sửa mãi không xong). Mọi vòng lặp agent đều cần một con số dừng ghi rõ trong state, không trông chờ model tự biết dừng.

## 8. Tổng kết khóa (bài 8)

- Agent không phải phép màu: là vòng lặp suy luận–hành động–quan sát quanh một LLM, cộng giao thức gọi tool và một nơi giữ trạng thái.
- LangGraph đóng gói vòng lặp đó thành đồ thị có state dùng chung, checkpoint bền, stream quan sát được và điểm ngắt cho người duyệt — bốn thứ bản tự viết thiếu.
- Essay Writer cho thấy khi state được thiết kế như hồ sơ công việc (plan/draft/critique/revision), cùng một bộ máy graph chạy được workflow nhiều bước có tự sửa, không chỉ chat hỏi–đáp.

## 9. Cập nhật 2026 — những gì đã đổi kể từ bản quay 2024

- **LangChain + LangGraph 1.0 (22/10/2025):** cột mốc lớn nhất. `langgraph.prebuilt.create_react_agent` bị **deprecated**; cách chuẩn mới là `langchain.agents.create_agent` (chạy trên runtime LangGraph, thêm lớp **middleware**: `before_model`, `wrap_model_call`, `wrap_tool_call`, `after_model` — một chỗ duy nhất để gắn guardrail/phê duyệt, trong đó có sẵn HumanInTheLoopMiddleware với ba quyết định approve/edit/reject trước khi tool chạy — đúng mẫu bài 6 nhưng đóng gói sẵn). LangGraph 1.0 là bản ổn định hóa: API graph cốt lõi (StateGraph, nodes, edges, checkpointer) không đổi, cam kết không breaking change tới 2.0. Các chain cổ điển (`LLMChain`, `AgentExecutor`...) chuyển sang gói `langchain-classic`; yêu cầu Python ≥ 3.10.
- **Hệ quả với khóa này:** code notebook 2024 chạy trên thư viện mới có thể lỗi hoặc báo deprecation — nhiều học viên 2026 ghi nhận riêng bài Human-in-the-loop chạy không qua nếu không tự sửa. Giá trị bền của khóa nằm ở **khái niệm** (vòng ReAct, state/reducer, checkpoint, interrupt) do chính tác giả framework giảng; code mẫu nên coi là bản phác thảo cần đối chiếu tài liệu 1.0, không copy nguyên văn. Đúng bài học đã gặp ở task 123 §9 (SDK đổi cú pháp) và task 120 §4 (prompt/API tối ưu cho bản cũ phải kiểm tra lại sau mỗi lần đổi phiên bản).
- **Tích hợp Tavily đã đổi nhà:** khóa 2024 dùng `TavilySearchResults` trong `langchain_community`; hiện Tavily có gói tích hợp chính thức `langchain-tavily` (`TavilySearch`). Khái niệm agentic search không đổi, đường import thì có.
- **Model mẫu đã cũ:** bài build-from-scratch dùng `gpt-3.5-turbo` + giao thức văn bản tự chế vì model thời đó chưa mạnh về tool calling gốc. Model 2026 gọi tool theo schema chuẩn (function calling) đáng tin hơn nhiều — giao thức regex của bài 2 nay chủ yếu còn giá trị sư phạm (hiểu vòng lặp chạy ra sao), không phải cách nên dùng khi xây thật.
- **Những gì khóa không có** (để khỏi kỳ vọng sai): multi-agent thật (chỉ giới thiệu khái niệm), đánh giá agent tự động (evaluation/observability kiểu LangSmith chỉ nhắc qua), bộ nhớ dài hạn qua nhiều phiên (đã có khóa nối tiếp riêng: *Long-Term Agentic Memory with LangGraph*, DeepLearning.AI, 2025 — ba loại memory semantic/episodic/procedural + LangMem), và chuẩn kết nối tool MCP đang thành mặc định 2026. Trong vòng tự học của team, mảng evaluation đã được task 120 phủ ở phía prompt; mảng memory dài hạn và multi-agent vẫn còn trống.

## 10. Đối chiếu với task 123 (Prompt Engineering) và task 121 (Function Calling)

| Khía cạnh | Task 123 — ChatGPT Prompt Engineering (DeepLearning.AI/OpenAI) | Task 121 — Develop Gen AI Apps (Google/Gemini) | Task 125 — AI Agents in LangGraph (DeepLearning.AI/LangChain) |
|---|---|---|---|
| Đơn vị tư duy | Một prompt, một lần gọi (rồi ghép tay thành chatbot) | Một hàm được model đề xuất gọi trong một app | Một đồ thị trạng thái chạy vòng lặp nhiều bước |
| Trí nhớ | Ứng dụng tự giữ danh sách message, gửi kèm mỗi request | App giữ ngữ cảnh phiên làm việc | State có schema + checkpointer bền theo thread, khôi phục được |
| Gọi tool/hàm | Chưa có (chỉ sinh văn bản) | Function calling: SDK sinh schema từ hàm Python, app thực thi | Node `llm` đề xuất tool call, node `action` thực thi, conditional edge quyết định lặp hay dừng |
| Kiểm soát | System message + delimiters + nhánh điều kiện trong prompt | Kiểm chứng tham số trước khi thực thi (trong code app) | `interrupt_before` dừng graph trước node hành động để duyệt/sửa state |
| Tự sửa | Bắt model tự giải trước khi chấm (một lần gọi) | Chưa có vòng tự sửa | Node `reflect` riêng + vòng revise có trần `max_revisions` |
| Quan sát tiến độ | Đếm token sau khi gọi xong | Streaming trong app Streamlit | Stream từng cập nhật state/token trong lúc graph chạy |

Ba khóa xếp thành một thang leo rõ ràng: **task 123 dạy viết tốt một lần gọi → task 121 dạy cho lần gọi đó chạm vào hàm thật một cách an toàn → task 125 dạy tổ chức nhiều lần gọi thành một quy trình có trạng thái, có phanh, có điểm duyệt**. Không khóa nào thay thế khóa nào; khóa sau dùng lại nguyên tắc của khóa trước (delimiters/few-shot vẫn nằm trong system prompt của agent; kiểm chứng tham số vẫn là việc của node thực thi).

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai build (muse-1) và cách team muse-teamwork đang vận hành — điểm đáng chú ý: **hệ thống phối hợp 3 Muse hiện tại chính là một "agent graph" chạy bằng người + file**, khóa này cho tên gọi và lý do kỹ thuật cho từng mảnh đã có:

1. **Task file = AgentState, status = conditional edge (§3).** File `tasks/<id>.json` là state dùng chung chảy qua các "node" claim → build → review → merge; trường `status` quyết định bước tiếp theo đúng như conditional edge đọc state. *Áp dụng ngay:* khi thiết kế task mới, nghĩ theo state trước: task cần những trường nào (checklist, result, review score) thì ghi đủ vào file ngay từ đầu — node sau chỉ đọc được những gì state có.
2. **Hai chính sách cập nhật state: nối thêm vs thay thế (§3, §6).** Reducer `operator.add` (chỉ nối thêm) = `notes` thêm vào cuối không sửa mục cũ (PROTOCOL §8); reducer thay thế theo `id` = các trường `result.*` được ghi đè mỗi vòng review. *Áp dụng ngay:* giữ nguyên phân biệt này khi sửa task file — nhật ký thì append, kết quả thì overwrite; trộn hai chính sách là nguồn gốc của "sửa lịch sử" và mất dấu vết.
3. **Checkpoint sau mỗi node = commit sau mỗi bước (§5).** Checkpointer lưu state sau từng node để chết giữa chừng vẫn nối tiếp được — đúng bài học task 112 (worker chết không để lại commit) đã thành luật PROTOCOL §2.4 (commit tiến độ trong 15 phút đầu). *Áp dụng ngay:* trong task build dài, commit sau từng mốc (khảo sát xong, selector chạy được, device test xong) thay vì dồn một commit cuối — mỗi commit là một checkpoint khôi phục được.
4. **Mọi vòng lặp phải có trần cứng ghi trong state (§2, §7).** `max_turns=5` của bài 2 và `max_revisions` của Essay Writer cùng một nguyên tắc với claim hết hạn 2h và review tối đa 3 vòng (PROTOCOL §4) của team. *Áp dụng ngay:* khi viết checklist có vòng thử–sửa (probe site, sửa selector), ghi rõ trần số vòng/số lần thử ngay trong checklist — hết trần thì chuyển `blocked` kèm bằng chứng, không lặp vô hạn trông chờ "lần sau sẽ được".
5. **Interrupt trước node hành động = cổng review trước merge (§6).** `interrupt_before=["action"]` đặt điểm duyệt đúng trước bước có tác dụng phụ; team đặt cổng tương đương ở `review` (chỉ muse-main merge lên Qsang_vbook main, PROTOCOL §4) và ở bước device test trên điện thoại Anh. *Áp dụng ngay:* giữ nguyên tắc "hành động không quay lui được (merge, push main, thao tác trên máy Anh) luôn có một điểm dừng duyệt trước nó" — và tại điểm dừng đó, người duyệt phải xem được toàn bộ state (task file + bằng chứng test), như `get_state()` cho xem state trước khi cho chạy tiếp.
6. **Reflection phải dẫn tới hành động sửa cụ thể (§7).** Node `reflect` sinh critique rồi critique đó lái bước tra cứu/sửa tiếp theo. *Áp dụng ngay:* vòng review của team đã đúng dạng này (chấm điểm + ghi lỗi vào `result.review.note` → trả về `doing`); giữ kỷ luật "phê bình nào cũng phải chỉ rõ sửa ở đâu" — nhận xét chung chung không lái được bước tiếp theo thì coi như chưa review.
7. **Dữ liệu đưa vào vòng lặp quyết định chất lượng vòng lặp (§4).** Agentic search thắng SERP thô vì trả dữ liệu sạch có cấu trúc. *Áp dụng ngay:* báo cáo research của team nên trả về kết quả đã trích cấu trúc (bảng nhãn, con số kiểm chứng, link nguồn cụ thể) thay vì đổ link thô — người/agent đọc sau dùng ngay được, không phải tự lọc lại. Đúng định dạng các báo cáo 118–124 đã theo.
8. **Streaming = khả năng quan sát để can thiệp kịp (§5).** Stream từng cập nhật state giúp thấy agent đang ở node nào trước khi nó chạy xong. *Áp dụng ngay:* status-board + watcher 5 phút + heartbeat của team là lớp streaming tương đương ở quy mô người — giữ nhịp cập nhật `updated_at`/notes khi có sự kiện mới (PROTOCOL §8) để chị cả và Anh nhìn thấy trạng thái thật thay vì phải hỏi.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ, theo tiền lệ task 118–124):

1. **Skill `vbook-extension-building` — thêm mục "Mọi vòng thử–sửa phải có trần ghi rõ" (từ §2/§7):** khi checklist có vòng lặp thử lại (probe nhiều cách lấy nội dung, sửa selector nhiều vòng), ghi trần số lần thử ngay trong checklist/task; hết trần thì dừng và ghi `blocked` kèm bằng chứng từng lần thử — không lặp vô hạn. (Bổ sung cho mục "baseline-first, escalate only on evidence" đã có: leo thang cũng phải có điểm dừng.)
2. **Skill `vbook-extension-building` — thêm mục "Commit như checkpoint sau mỗi mốc" (từ §5):** trong task build dài, commit + push sau từng mốc kiểm chứng được (khảo sát xong, chapter 1 đọc được, device test xong) thay vì một commit cuối — worker chết giữa chừng thì người sau nối tiếp từ checkpoint cuối. (Hiện thực hóa PROTOCOL §2.4 ở mức skill build.)
3. **Skill `vbook-extension-building` — thêm mục "Điểm duyệt đặt trước hành động không quay lui" (từ §6):** trước các bước có tác dụng phụ khó đảo ngược (merge, push lên main của repo đích, thao tác cần máy/điện thoại của Anh), dừng lại ở trạng thái chờ duyệt với toàn bộ bằng chứng đã ghi vào task file — không thực thi rồi mới báo. (Nối tiếp mục function calling của task 121: kiểm chứng tham số trước khi thực thi; mục này thêm *điểm dừng chính thức* cho việc kiểm chứng đó.)
4. **Không đề xuất sửa PROTOCOL.md:** ánh xạ task file = state, status = conditional edge, commit = checkpoint, review = interrupt (§10 + mục áp dụng 1–5) xác nhận cấu trúc hiện tại đã đúng dạng một agent graph có kiểm soát; khóa này cho thêm lý do kỹ thuật cho các luật đã có, không đòi luật mới.

## Khóa tiếp theo

- Track của muse-1 sau khóa này chưa được Anh/chị cả chốt cố định — chờ muse-main tạo task theo PROTOCOL §10(a) khi board rảnh; nếu board lại có task build/gấp thì ưu tiên task đó trước (PROTOCOL §9).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): **Long-Term Agentic Memory with LangGraph** (DeepLearning.AI, 2025) là bước nối trực tiếp của khóa này — từ state bền trong một thread (bài 5) lên bộ nhớ dài hạn qua nhiều phiên (semantic/episodic/procedural), đúng mảng còn trống nêu ở §9 và gần với cách team dùng MEMORY.md/task file làm bộ nhớ ngoài của worker. Khóa này cũng thuộc họ LangGraph nên nối mạch tư duy với task 125 mà không phải đổi hệ sinh thái.

## Nguồn

- Trang khóa chính thức: https://www.deeplearning.ai/courses/ai-agents-in-langgraph
- Transcript bài học trên nền tảng học: https://learn.deeplearning.ai/courses/ai-agents-in-langgraph/lesson/nj9ok/persistence-and-streaming ; https://learn.deeplearning.ai/courses/ai-agents-in-langgraph/lesson/k87e1/human-in-the-loop
- Đánh giá/đối chiếu syllabus (6 mục tiêu học, 1h47m, Intermediate, phát hành 05/06/2024): https://www.classcentral.com/course/coursera-ai-agents-in-langgraph-295891
- Đánh giá chi tiết 2026 (giảng viên, 6 code example, cảnh báo code 2024 lệch LangGraph 1.0, bài Human-in-the-loop hay lỗi): https://www.cursarium.net/courses/deeplearning-ai-ai-agents
- Ghi chép đầy đủ của học viên đã hoàn thành khóa (toàn bộ code bài Build an Agent from Scratch: class Agent, prompt Thought/Action/PAUSE/Observation, hàm query max_turns=5): https://hackmd.io/gK5uGOXKR4-t6yk6olLW2w
- Bài viết dựng lại toàn bộ khóa kèm Essay Writer (state task/plan/draft/critique/content/revision_number/max_revisions, các node planner/research/generate/reflect): https://ai.plainenglish.io/ai-agents-using-langraph-a-comprehensive-guide-d0a63a8db17d?gi=b9e6268d56d6
- Ghi chép bài LangGraph Components (nodes/edges/conditional edges, Tavily max_results=4): https://todatabeyond.substack.com/p/building-llm-agents-with-langgraph-634
- Paper ReAct gốc (nền của bài 2): https://arxiv.org/abs/2210.03629
- Cập nhật LangChain/LangGraph 1.0 (22/10/2025: create_agent thay create_react_agent, middleware, langchain-classic, Python ≥ 3.10): https://www.motiontic.com/compare/langchain-vs-langgraph ; https://www.inductivee.com/blog/langchain-vs-langgraph-comparison
- Khóa nối tiếp về bộ nhớ dài hạn: https://www.deeplearning.ai/courses/long-term-agentic-memory-with-langgraph
