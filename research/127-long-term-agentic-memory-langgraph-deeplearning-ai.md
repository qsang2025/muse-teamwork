# Long-Term Agentic Memory with LangGraph (DeepLearning.AI) — Báo cáo tự học (task 127)

- **Khóa học:** Long-Term Agentic Memory with LangGraph, DeepLearning.AI (hợp tác LangChain)
- **Trang khóa:** https://www.deeplearning.ai/courses/long-term-agentic-memory-with-langgraph
- **Giảng viên:** Harrison Chase (Co-Founder/CEO LangChain — tác giả framework được dạy); phần mở đầu do Andrew Ng (Founder, DeepLearning.AI) dẫn khung; đội xây khóa gồm Lance Martin, Will Fu-Hinthorn, Nuno Campos (LangChain) và Geoff Ladwig (DeepLearning.AI)
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE, **không đăng ký chứng chỉ trả phí** (theo checklist task 127). **Không chạy notebook** — các code example cần API key trả phí theo token (model + embedding cho vector store); báo cáo học kỹ nội dung qua trang khóa chính thức + transcript bài Introduction trên learn.deeplearning.ai + tài liệu LangMem/LangGraph chính thức và ghi chép chi tiết của học viên đã dựng lại toàn bộ khóa (xem mục Nguồn).
- **Quy mô khóa:** short course, phát hành 14/03/2025; tổng thời lượng khoảng 1 giờ 24 phút (phần video cốt lõi ~64 phút theo đánh giá 2026), trình độ Intermediate. Dự án xuyên suốt: **personal email agent** — phân loại email (ignore / notify / respond), viết thư, lên lịch, và học dần sở thích của người dùng qua bộ nhớ dài hạn.
- **Công cụ dùng trong khóa:** LangGraph (StateGraph + checkpointer + `BaseStore`) + **LangMem** (thư viện bộ nhớ dài hạn của LangChain, `pip install langmem`) + vector store có tìm kiếm ngữ nghĩa (`InMemoryStore` khi học, Postgres/Redis khi production).
- **Vị trí trong vòng tự học:** khóa 3 theo phân vai của muse-1. Nối tiếp trực tiếp task 125 (AI Agents in LangGraph): task 125 dạy **state bền trong một thread** (checkpointer, bài 5) và để trống mảng "bộ nhớ dài hạn qua nhiều phiên" (§9) — khóa này lấp đúng mảng đó: từ bộ nhớ *của một cuộc hội thoại* lên bộ nhớ *của một người dùng qua nhiều cuộc hội thoại*. Cũng nối task 123 ở hai chỗ: few-shot examples (task 123 §2) quay lại dưới tên episodic memory, và system prompt (task 123) quay lại dưới tên procedural memory — cùng một kỹ thuật, nay có vòng đời lưu trữ và cập nhật.
- **Phạm vi báo cáo:** toàn bộ khung khóa (ba loại memory + hai cơ chế hình thành + email agent mẫu) + cập nhật tình hình LangMem/LangGraph 2026, vì khóa quay đầu 2025, trước LangGraph 1.0 (10/2025).

## Cấu trúc khóa (syllabus)

| Phần | Nội dung chính |
|---|---|
| Introduction | Vì sao trợ lý "quên sạch sau mỗi cuộc trò chuyện" là không dùng được; hai câu hỏi cốt lõi của bộ nhớ: *lưu cái gì* và *lúc cần thì lấy lại cái gì*; giới thiệu ba loại memory + thư viện LangMem |
| Email agent nền | Dựng agent email bằng LangGraph: router phân loại email thành ignore / notify / respond; các tool viết thư, lên lịch, kiểm tra lịch trống; state của agent (`email_input`, `messages`, `triage_result`) |
| Semantic memory | Gắn memory tools để agent học *sự kiện* về người dùng, lưu vào long-term store, tìm kiếm lại ở các phiên sau |
| Episodic memory | Đưa *ví dụ* các lần phân loại email trước (few-shot) vào bước triage để agent học sở thích của người dùng từ tiền lệ |
| Procedural memory | Biến *system prompt* thành bộ nhớ: tối ưu chỉ dẫn của agent bằng phản hồi, để hành vi tự tiến hóa qua các lần dùng |
| Conclusion | Tổng kết khung tư duy: ba loại memory × hai cơ chế (hot path / background) |

Đường đi của khóa: **dựng một agent thật trước (email agent), rồi cộng từng lớp bộ nhớ vào** — mỗi loại memory giải quyết đúng một kiểu "quên" của agent nền, thay vì dạy lý thuyết bộ nhớ rời rạc.

## 1. Vấn đề: agent quên sạch sau mỗi phiên (Introduction)

- **Ẩn dụ mở đầu:** một trợ lý người mà quên toàn bộ cuộc trò chuyện trước với bạn thì không dùng được; agent cũng vậy. Các use case chính của agent — trợ lý cá nhân, công việc năng suất — đều đòi hỏi nhớ *qua nhiều phiên*, không chỉ trong một phiên.
- **Hai câu hỏi thiết kế** mà khóa dùng làm trục: (1) *lưu cái gì* vào bộ nhớ dài hạn, và (2) khi cần dùng thì *lấy lại cái gì*. Chatbot đời đầu chỉ giữ lịch sử hội thoại trong context của từng lượt — tức là "lưu tất cả, lấy tất cả" — cách này vỡ khi hội thoại dài (tràn context window) và vô ích khi phiên mới bắt đầu (context trống).
- **Giải pháp của khóa:** phân loại thông tin thành ba loại memory (semantic / episodic / procedural) và giao việc quản lý cho **LangMem** — thư viện hỗ trợ một vector database *tìm kiếm được, chia sẻ được, bền vững*, cập nhật được *ngay lập tức bởi agent* hoặc *ở nền bởi một helper agent*. Hai tính từ cuối ("ngay" vs "ở nền") chính là hai cơ chế hình thành bộ nhớ ở §5.
- **Ranh giới với task 125:** checkpointer của task 125 bài 5 là bộ nhớ *ngắn hạn đã làm cho bền* — nó sống trong phạm vi một `thread_id`, đổi thread là trắng. Khóa này bắt đầu đúng tại điểm đó: những gì phải sống sót *qua* thread thì cần một tầng lưu trữ khác (store, §3).

## 2. Email agent nền — dự án xuyên suốt khóa

Trước khi có bộ nhớ, khóa dựng một email agent hoàn chỉnh bằng LangGraph (dùng lại toàn bộ bộ máy task 125: state, nodes, conditional edges, tools):

- **Router/triage:** một node phân loại mỗi email đến thành đúng một trong ba nhãn — `ignore` (bỏ qua), `notify` (báo người dùng), `respond` (tự trả lời). Việc phân loại dùng structured output (một schema `Router` có trường reasoning + classification) — model buộc phải xuất nhãn trong tập đóng thay vì văn bản tự do, đúng nguyên tắc "đóng khung đầu ra thành định dạng kiểm chứng được" của task 120/123.
- **Tools hành động:** viết thư (writing), lên lịch (scheduling), kiểm tra lịch trống (availability) — agent chỉ *đề xuất* gọi tool, code thực thi (ranh giới task 121/125 giữ nguyên).
- **State của agent:** `email_input` (email đang xử lý), `messages` (lịch sử, reducer nối thêm), `triage_result` (nhãn phân loại). Đây là *working memory* — bộ nhớ làm việc trong một lần chạy, phân biệt rõ với ba loại bộ nhớ dài hạn cộng vào sau.
- **Ba kiểu "quên" của agent nền** mà các phần sau lần lượt sửa: (a) không biết sự kiện về người dùng (sinh nhật, múi giờ, người liên hệ quan trọng) → semantic; (b) không nhớ tiền lệ "email kiểu này lần trước bạn bảo notify" → episodic; (c) chỉ dẫn hành vi cố định, không học được từ phản hồi "lần sau viết ngắn hơn" → procedural.

## 3. Tầng lưu trữ: checkpointer (thread) vs store (namespace)

Khái niệm kỹ thuật nền của toàn khóa — **LangGraph có hai tầng bền trạng thái, khác nhau ở phạm vi (scope), không phải ở độ bền**:

| Tầng | Phạm vi | Lưu cái gì | Tương đương |
|---|---|---|---|
| **Checkpointer** (task 125 bài 5) | Một `thread_id` | Snapshot của state sau mỗi node — lịch sử hội thoại + tiến độ graph | Bộ nhớ ngắn hạn / working memory làm cho bền |
| **Store (`BaseStore`)** (khóa này) | Một `namespace` (thường là `user_id`) | Tài liệu JSON tùy ý dưới cặp namespace + key, có thể đánh chỉ mục vector để tìm kiếm ngữ nghĩa | Bộ nhớ dài hạn qua mọi thread |

- **Sai lầm kinh điển** mà tài liệu nhấn mạnh: dùng checkpointer như bộ nhớ người dùng — người dùng quay lại với `thread_id` mới sẽ trắng trơn vì sở thích của họ bị lưu theo thread cũ thay vì theo user. Một user có nhiều thread; store khóa theo *user*, checkpointer khóa theo *thread*.
- **Namespace là đơn vị cách ly:** bộ nhớ ghi dưới namespace `("memories", user_id)` chỉ đọc được trong đúng namespace đó — nền tảng để nhiều người dùng/nhiều agent dùng chung một store mà không lẫn nhau. Trong khóa học dùng `InMemoryStore` (mất khi tắt tiến trình, chỉ để học); production thay bằng `PostgresStore`/`AsyncPostgresStore` mà code không đổi.
- **Store được tiêm vào node:** node khai báo tham số `store: BaseStore` thì runtime tự cấp — graph phải `compile(checkpointer=..., store=...)`; quên truyền `store=` là lỗi runtime khó hiểu kinh điển. Điểm quan trọng: **LLM không bao giờ tự gọi checkpointer hay store** — nó chỉ nhìn thấy những gì code đã lấy ra và đặt trước mặt nó. Bộ nhớ là việc của *hệ thống quanh model*, không phải của model.

## 4. Ba loại bộ nhớ dài hạn

Khóa mượn khung phân loại của bộ nhớ người. Mỗi loại trả lời một câu hỏi khác nhau và có mẫu lưu trữ riêng:

### 4.1 Semantic memory — sự kiện (facts)

- **Là gì:** sự kiện và tri thức về người dùng/thế giới: "người dùng ở múi giờ Pacific", "sinh nhật của X là...", "sếp của người dùng tên là...". Tương đương con người: biết Python là ngôn ngữ lập trình.
- **Mẫu lưu trữ:** *profile* (một tài liệu cấu trúc duy nhất cho mỗi user, cập nhật tại chỗ) hoặc *collection* (nhiều mục rời, tìm kiếm ngữ nghĩa khi cần). Profile hợp với tập sự kiện nhỏ và ổn định; collection hợp khi sự kiện nhiều và chỉ cần lấy vài mục liên quan nhất.
- **Trong email agent:** agent được gắn hai tool — `manage_memory` (tạo/sửa/xóa một mục nhớ) và `search_memory` (tìm kiếm ngữ nghĩa trong store). Khi người dùng nói một sự kiện đáng nhớ, agent tự gọi tool lưu lại; ở phiên sau, agent tìm kiếm trước khi trả lời. Đây là dạng RAG thu nhỏ áp cho chính người dùng: tra cứu bộ nhớ ngoài thay vì trả lời từ tham số model (chống ảo giác, nối task 123 §4 và task 125 §4).

### 4.2 Episodic memory — trải nghiệm (examples)

- **Là gì:** các trải nghiệm cụ thể trong quá khứ, dùng để agent "nhớ cách đã làm": lần trước email kiểu này được phân loại `notify` vì lý do gì. Tương đương con người: nhớ ngày đầu đi làm.
- **Mẫu lưu trữ:** collection các ví dụ (cặp đầu vào → kết quả đúng), lấy ra theo độ liên quan ngữ nghĩa với tình huống hiện tại rồi đưa vào prompt dưới dạng **few-shot examples**.
- **Trong email agent:** bước triage — một bài toán *phân loại* — là nơi episodic memory phát huy nhất: mỗi lần người dùng sửa nhãn phân loại của agent, cặp (email, nhãn đúng) được lưu lại; lần sau, vài ví dụ gần nhất được chèn vào prompt phân loại, agent học sở thích từ tiền lệ thay vì từ luật viết tay. Đây là few-shot của task 123 §2 nhưng *tự sinh từ lịch sử dùng thật* và *tự cập nhật* — không còn là ví dụ cố định do người viết prompt soạn sẵn.

### 4.3 Procedural memory — cách làm (instructions)

- **Là gì:** tri thức về *cách thực hiện* nhiệm vụ: quy tắc hành vi, phong cách, quy trình. Tương đương con người: biết đi xe đạp — không nhớ từng lần đi, mà nội hóa thành kỹ năng.
- **Mẫu lưu trữ:** trong LangMem, procedural memory được lưu thành **chỉ dẫn đã học trong prompt của agent** — tức system prompt không còn là hằng số viết một lần, mà là một tài liệu sống trong store, được lấy ra lúc chạy và *được viết lại* khi có phản hồi. LangMem cung cấp bộ tối ưu prompt (`create_prompt_optimizer`) để sửa chỉ dẫn dựa trên các lần chạy trước (thêm luật mới, sửa luật cũ, giữ nguyên phần còn đúng).
- **Trong email agent:** phản hồi kiểu "với email từ nhóm này, lần sau cứ notify đừng tự trả lời" không chỉ sửa một lần phân loại (episodic) mà được *tổng quát hóa* thành luật trong system prompt — agent thay đổi hành vi mặc định cho mọi email tương lai cùng loại.
- **Điểm phân biệt cốt lõi:** semantic nhớ *cái gì đúng*, episodic nhớ *chuyện gì đã xảy ra*, procedural nhớ *phải làm thế nào*. Cùng một phản hồi của người dùng có thể sinh cả ba: một sự kiện mới (semantic), một tiền lệ mới (episodic), một luật mới (procedural) — thiết kế tốt phải quyết định rõ phản hồi đi vào loại nào, không đổ chung một chỗ.

## 5. Hai cơ chế hình thành bộ nhớ: hot path và background

Bộ nhớ không chỉ cần *loại*, còn cần *thời điểm hình thành*. Khóa (và LangMem) phân biệt hai cơ chế:

| Cơ chế | Cách chạy | Ưu điểm | Nhược điểm | Hợp với |
|---|---|---|---|---|
| **Hot path** (đường nóng) | Agent tự gọi `manage_memory`/`search_memory` ngay trong lúc hội thoại | Có hiệu lực tức thì; đơn giản; minh bạch (thấy được agent vừa nhớ gì) | Tăng độ trễ mỗi lượt; thêm một loại quyết định cho model (nhớ hay không) có thể làm nhiễu nhiệm vụ chính | Ngữ cảnh quan trọng phải nhớ ngay ("nhớ là tôi dị ứng...") |
| **Background** (nền) | Một memory manager riêng xem lại hội thoại *sau khi* nó diễn ra, trích xuất và hợp nhất bộ nhớ (`create_memory_store_manager` + `ReflectionExecutor`) | Không tăng độ trễ; không làm nhiễu agent chính; trích xuất kỹ hơn vì nhìn được toàn bộ hội thoại | Có hiệu lực chậm; khó quan sát hơn; tốn thêm lượt gọi model ở nền | Phân tích mẫu, tóm tắt, hợp nhất sự kiện trùng lặp |

- **Debounce của background:** `ReflectionExecutor` trì hoãn việc trích xuất `after_seconds=N` — người dùng nhắn tiếp trong khoảng đó thì nhiệm vụ cũ bị hủy, xếp lại với hội thoại mới nhất. Lý do: trích xuất sau *từng* tin nhắn vừa tốn token vừa chỉ thấy nửa ngữ cảnh. Đây là mẫu "gom việc nền theo nhịp, không chạy theo từng sự kiện" rất đáng nhớ.
- **Hợp nhất (consolidation) là việc riêng của background:** memory manager không chỉ *thêm* mục nhớ mà còn sửa mục cũ và xóa mục lỗi thời (mặc định tắt xóa để an toàn — `actions_permitted` giới hạn được agent chỉ được tạo/sửa mà không được xóa). Bộ nhớ chỉ-thêm-mãi sẽ phình và tự mâu thuẫn; hợp nhất là bước biến nhật ký thô thành tri thức dùng được — đúng vai trò của việc "chưng cất" ghi chép thành MEMORY.md ở quy mô người.
- **Nguyên tắc chọn:** thông tin cần dùng *ngay trong phiên này* → hot path; thông tin chỉ có giá trị *từ phiên sau* → background. Trộn lẫn hai loại vào một cơ chế là nguồn gốc của cả độ trễ thừa lẫn bộ nhớ rác.

## 6. Tổng kết khóa

- Agent có bộ nhớ dài hạn = agent nền (task 125) + một **store theo namespace** + **ba loại nội dung** (facts / examples / instructions) + **hai nhịp ghi** (hot path / background).
- Câu hỏi thiết kế không phải "có nên cho agent bộ nhớ không" mà là bốn quyết định cụ thể: *hành vi nào nên học từ người dùng, hành vi nào cố định sẵn; loại tri thức nào cần theo dõi; điều kiện nào kích hoạt việc nhớ lại; và ghi ở nhịp nào*.
- Email agent chứng minh cả ba loại cùng chạy trên một hệ thống thật: semantic cho sự kiện, episodic cho phân loại, procedural cho luật hành vi — và cả ba đều sống sót qua các phiên vì nằm trong store, không nằm trong context của một thread.

## 7. Cập nhật 2026 — những gì đã đổi kể từ bản quay 2025

- **LangGraph 1.0 (22/10/2025, đã nêu ở task 125 §9):** cách dựng agent chuẩn đổi từ `create_react_agent` sang `langchain.agents.create_agent` (có middleware); nhưng hai tầng bền trạng thái mà khóa này dựa vào — checkpointer theo `thread_id` và `BaseStore` theo namespace — **không đổi** và là API ổn định cam kết tới 2.0. Khóa vẫn đúng ở tầng khái niệm; code mẫu cần đối chiếu import theo bản 1.0.
- **LangMem là thư viện độc lập, nhịp phát hành chậm:** bản mới nhất 0.0.30 (09/2025), code đổi lần cuối 07/2025 theo kiểm chứng 10/2026 — tức là một thư viện nhỏ, ổn định, ít biến động, không phải nền tảng đang chạy đua tính năng. API công khai gọn: hai memory tools (`create_manage_memory_tool`, `create_search_memory_tool`), hai manager (`create_memory_manager`, `create_memory_store_manager`), prompt optimizer và `ReflectionExecutor`. Lưu ý thực hành từ các guide 2026: LangChain không công bố số liệu độ trễ truy xuất của LangMem, mà tìm kiếm bộ nhớ nằm trên đường nóng của mọi lượt — phải tự đo trong môi trường của mình trước khi đưa ra production.
- **Hệ sinh thái bộ nhớ đã đông hơn khóa học:** ngoài LangMem còn có các lớp bộ nhớ độc lập framework (Mem0 — API quản lý hoặc tự host; Zep — bộ nhớ có chiều thời gian). Điểm phân biệt còn lại của LangMem: nó là lựa chọn duy nhất trong nhóm cho agent *tự viết lại system prompt* từ kinh nghiệm tích lũy (procedural memory) — các lớp khác chỉ nhớ sự kiện.
- **Khóa nối tiếp đã xuất hiện:** DeepLearning.AI phát hành thêm *Agent Memory: Building Memory-Aware Agents* (18/03/2026, hợp tác Oracle) — đi sâu vào hạ tầng bộ nhớ (Memory Manager, trích xuất sự kiện có cấu trúc, hợp nhất episodic → semantic, vòng ghi-ngược để agent tự cập nhật bộ nhớ, dùng tool như procedural memory truy xuất bằng tìm kiếm ngữ nghĩa khi agent có hàng trăm tool). Tức là mảng "bộ nhớ agent" đã thành một chủ đề hạ tầng riêng, không còn là tính năng phụ của framework agent.
- **Những gì khóa không có** (để khỏi kỳ vọng sai): đánh giá chất lượng bộ nhớ tự động (memory evaluation — nhớ sai thì đo bằng gì), chính sách quên/hết hạn (TTL, decay), và bảo mật bộ nhớ (một mục nhớ độc hại ghi vào store sẽ đầu độc mọi phiên sau — khóa không bàn). Ba mảng này là việc phải tự thiết kế khi áp dụng thật.

## 8. Đối chiếu với task 125 (AI Agents in LangGraph)

| Khía cạnh | Task 125 — AI Agents in LangGraph | Task 127 — Long-Term Agentic Memory |
|---|---|---|
| Câu hỏi trung tâm | Làm sao tổ chức *một lần chạy* thành vòng lặp có kiểm soát? | Làm sao để agent *học qua nhiều lần chạy*? |
| Tầng lưu trữ | Checkpointer: state theo `thread_id` | Store (`BaseStore`): tài liệu theo `namespace`/`user_id` |
| Đơn vị nhớ | Message và trường state của graph | Facts (semantic), examples (episodic), instructions (procedural) |
| Ai ghi bộ nhớ | Code của graph, tự động sau mỗi node | Agent tự ghi qua tool (hot path) hoặc manager ở nền (background) |
| Ai đọc bộ nhớ | Node tiếp theo trong cùng thread | Bất kỳ thread nào cùng namespace, qua tìm kiếm ngữ nghĩa |
| Ví dụ mẫu | Essay Writer: plan → draft → critique trong một task | Email agent: triage học sở thích qua nhiều email |
| Trần an toàn | `max_turns` / `max_revisions` chống lặp vô hạn | `actions_permitted` chống agent tự xóa/sửa bộ nhớ tùy tiện |

Hai khóa xếp thành một thang: **task 125 dạy agent sống sót qua một lần chạy dài (checkpoint) → task 127 dạy agent tiến bộ qua nhiều lần chạy (long-term memory)**. Không có task 125 thì bộ nhớ dài hạn không có chỗ bám (không có graph để gắn store); không có task 127 thì agent của task 125 vẫn "giỏi trong phiên, trắng giữa các phiên".

## Điều học được, áp dụng được ngay cho việc chung

Áp dụng cho vai build (muse-1) và cách team muse-teamwork đang vận hành — điểm đáng chú ý: **team 3 Muse hiện tại đã có đủ ba loại bộ nhớ và cả hai nhịp ghi, chỉ là đang chạy bằng file + người thay vì vector store**:

1. **Ba tầng lưu trữ của team khớp đúng hai tầng của LangGraph + một tầng người (§3).** Lịch sử một phiên làm việc (context của worker) = checkpointer theo thread; task file + STATUS.md trên GitHub = store theo namespace (sống qua mọi phiên, mọi máy); MEMORY.md của Anh = tầng chưng cất cao nhất. *Áp dụng ngay:* khi ghi thông tin, tự hỏi nó thuộc tầng nào — tiến độ trong một task thì ghi vào task file (đừng ghi vào MEMORY.md), sự kiện bền về Anh/công việc thì mới đề xuất lên MEMORY.md. Ghi sai tầng là lý do worker sau "không thấy" thông tin dù đã ghi.
2. **Semantic memory của team = MEMORY.md phần Facts (§4.1).** Sự kiện bền về người dùng (tên, công việc, tài khoản, cam kết) nằm ở một tài liệu cấu trúc duy nhất — đúng mẫu *profile*. *Áp dụng ngay:* giữ kỷ luật profile: sự kiện mới thay thế sự kiện cũ tại chỗ (như mục GitHub 2FA đã đóng thì ghi rõ "đừng nhắc lại"), không để hai phiên bản mâu thuẫn cùng tồn tại trong file.
3. **Episodic memory của team = task file đã done + báo cáo research (§4.2).** Mỗi task xong là một cặp (tình huống → cách xử lý đúng) — tiền lệ để worker sau bắt chước. Bước "quét tasks trước khi build" (PROTOCOL §3) chính là *truy xuất episodic memory theo độ liên quan* trước khi hành động. *Áp dụng ngay:* báo cáo research nên viết theo dạng tiền lệ dùng lại được (tình huống, quyết định, bằng chứng) thay vì nhật ký thuần túy — người sau cần *ví dụ để bắt chước*, không cần *lịch sử để đọc*.
4. **Procedural memory của team = PROTOCOL.md + skill dùng chung (§4.3).** Đây là system prompt sống của cả team: được lấy ra mỗi phiên, được viết lại khi có phản hồi (mỗi task tự học đề xuất sửa skill, chị cả duyệt và ghi vào). *Áp dụng ngay:* giữ đúng vòng procedural hiện tại — worker *đề xuất* sửa skill trong báo cáo, chỉ chị cả *ghi* vào skill chung. Đây chính là `actions_permitted` của LangMem áp ở quy mô người: agent được đề xuất bộ nhớ, không được tự ý viết lại luật của chính mình.
5. **Hot path vs background đã có sẵn trong nhịp team (§5).** Worker ghi notes/result vào task file *ngay trong lúc làm* = hot path (có hiệu lực tức thì, minh bạch, nhưng tốn nhịp). Chị cả tổng hợp cuối task + vòng chưng cất alignment ban đêm = background (không làm chậm worker, nhìn được toàn cảnh, hợp nhất và loại bỏ mâu thuẫn). *Áp dụng ngay:* giữ phân công này — đừng bắt worker dừng giữa chừng để "tổng kết bài học" (việc background), và đừng để chị cả phải đọc chat thô để biết tiến độ (việc hot path đã ghi vào task file).
6. **Debounce của ReflectionExecutor = watcher 5 phút + sweep của team (§5).** Watcher không phản ứng theo từng sự kiện mà gom theo nhịp 5 phút, bỏ qua thay đổi không đáng thức dậy (notes/`updated_at`) — cùng nguyên tắc "đừng trích xuất sau từng tin nhắn". *Áp dụng ngay:* mọi cơ chế nền mới của team (watchdog, sweep, health check) nên có nhịp gom + điều kiện bỏ qua rõ ràng, thay vì chạy theo từng sự kiện.
7. **Namespace cách ly = ranh giới assignee của team (§3).** Bộ nhớ của muse-2 không được muse-1 ghi đè — đúng như namespace theo user. Luật "không claim task của muse-2/muse-main" là namespace enforcement ở tầng người. *Áp dụng ngay:* khi ghi vào file dùng chung (STATUS.md, skill), ghi rõ phần của mình và không sửa phần của agent khác — ghi đè bộ nhớ của namespace khác là lỗi nghiêm trọng nhất trong hệ thống bộ nhớ.
8. **Bộ nhớ sai nguy hiểm hơn không có bộ nhớ (§7).** Khóa không bàn bảo mật bộ nhớ, nhưng team đã gặp dạng của nó: thông tin cũ trong MEMORY.md (ví dụ nhắc GitHub 2FA sau khi đã đóng) khiến worker sau hành động sai một cách *tự tin*. *Áp dụng ngay:* mỗi khi ghi sự kiện bền, ghi kèm ngày và điều kiện hết hiệu lực ("đóng ngày X, đừng nhắc lại"); sự kiện không có ngày hết hạn là sự kiện sẽ thành sai mà không ai biết.

## Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ, theo tiền lệ task 118–125):

1. **Skill `vbook-extension-building` — thêm mục "Ghi đúng tầng bộ nhớ" (từ §3):** tiến độ và bằng chứng của một task ghi vào task file; bài học dùng lại được cho site khác đề xuất vào skill qua báo cáo research; sự kiện bền về Anh/công việc không ghi vào task file hay skill. Ghi sai tầng thì worker sau không tìm thấy dù đã ghi.
2. **Skill `vbook-extension-building` — thêm mục "Báo cáo theo dạng tiền lệ" (từ §4.2):** mỗi báo cáo research/build nên chứa ít nhất một tiền lệ bắt chước được (tình huống → quyết định → bằng chứng kiểm chứng), để worker sau truy xuất và làm theo — thay vì chỉ liệt kê việc đã làm. (Nối tiếp mục "ghi mọi cách đã thử / không thử lại" của task 118: tiền lệ là mặt tích cực của cùng một kỷ luật.)
3. **Skill `vbook-extension-building` — thêm mục "Sự kiện bền phải có ngày hết hiệu lực" (từ §7):** khi ghi một sự kiện/quyết định vào skill hoặc đề xuất lên MEMORY.md, ghi kèm ngày ghi và điều kiện để nó hết đúng (site đóng, domain đổi, luật đã thay). Bộ nhớ không có ngày hết hạn sẽ thành bộ nhớ sai mà vẫn được tin.
4. **Không đề xuất sửa PROTOCOL.md:** ánh xạ checkpointer = phiên worker, store = task file trên GitHub, ba loại memory = Facts/task-done/PROTOCOL+skill, hot path/background = notes của worker/chị cả tổng hợp cho thấy cấu trúc hiện tại đã là một hệ thống bộ nhớ dài hạn hoàn chỉnh chạy bằng file; khóa này cho thêm tên gọi và lý do kỹ thuật, không đòi luật mới.

## Khóa tiếp theo

- Track của muse-1 sau khóa này chưa được Anh/chị cả chốt cố định — chờ muse-main tạo task theo PROTOCOL §10(a) khi board rảnh; nếu board lại có task build/gấp thì ưu tiên task đó trước (PROTOCOL §9).
- Gợi ý cho chị cả cân nhắc (không phải yêu cầu): **Agent Memory: Building Memory-Aware Agents** (DeepLearning.AI × Oracle, 18/03/2026) là bước nối trực tiếp — từ "agent có bộ nhớ" (khóa này) lên "hạ tầng bộ nhớ" (Memory Manager, hợp nhất episodic → semantic, vòng ghi-ngược, tool như procedural memory). Tuy nhiên khóa đó dùng Oracle AI Database làm nền hạ tầng — cần kiểm tra mức độ FREE của nội dung trước khi giao, và giá trị với team nằm ở khái niệm hạ tầng chứ không phải sản phẩm cụ thể.

## Nguồn

- Trang khóa chính thức: https://www.deeplearning.ai/courses/long-term-agentic-memory-with-langgraph
- Transcript bài Introduction trên nền tảng học: https://learn.deeplearning.ai/courses/long-term-agentic-memory-with-langgraph/lesson/ovv0p/introduction
- Thông báo khóa + mô tả dự án email agent: https://community.deeplearning.ai/t/new-course-enroll-in-long-term-agentic-memory-with-langgraph/786723
- Bài dựng lại toàn bộ khóa (email agent: State `email_input`/`messages`/`triage_result`, Router ignore/notify/respond, few-shot episodic trong triage): https://diamantai.substack.com/p/building-an-ai-agent-with-memory
- Đánh giá 2026 (thời lượng ~64 phút video, Harrison Chase, ba loại memory): https://scrimba.com/articles/best-context-engineering-courses-and-tutorials-2026/
- LangMem SDK — bài ra mắt chính thức (ba loại memory, namespace, memory tools, prompt optimization): https://www.langchain.com/blog/langmem-sdk-launch
- Guide LangGraph + LangMem 2026 (checkpointer theo `thread_id` vs `BaseStore` theo `user_id`, sai lầm dùng checkpointer làm bộ nhớ người dùng, cảnh báo độ trễ): https://atlan.com/know/long-term-memory-langchain-agents/
- Đối chiếu Mem0 vs LangMem (hot path tools `create_manage_memory_tool`/`create_search_memory_tool`, background `create_memory_store_manager` + `ReflectionExecutor`, `actions_permitted`): https://past.dev/blog/mem0-vs-langmem
- Kiểm chứng LangMem 10/2026 (bản 0.0.30, API công khai, `manage_memory` create/update/delete, `search_memory` query/limit/offset/filter): https://www.anchorterminal.com/tools/langmem
- Tài liệu LangGraph về hai tầng bộ nhớ (checkpointer = ngắn hạn theo thread, store = dài hạn qua thread, namespace, tiêm store vào node): https://supermemory.ai/blog/supermemory-with-langgraph/ ; https://langchain-ai.github.io/lca-lessons/deepagents/m3/m3.3-memory.html
- Khóa nối tiếp về hạ tầng bộ nhớ (phát hành 18/03/2026): https://www.deeplearning.ai/courses/agent-memory-building-memory-aware-agents
