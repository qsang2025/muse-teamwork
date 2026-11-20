# Get started with AI agent development on Azure (Microsoft Learn) — Báo cáo tự học (task 147)

- **Khóa học:** Get started with AI agent development on Azure, Microsoft Learn — nay mang tên **Develop AI agents on Azure** (mã khóa đào tạo giảng viên AI-3026)
- **Trang khóa:** https://learn.microsoft.com/en-us/training/paths/develop-ai-agents-azure/
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE công khai; **không đăng ký Azure trả phí, không chạy lab/API tốn phí, không đăng nhập tài khoản Microsoft để làm quiz cuối module** (theo quy tắc tự học §9). Không tạo agent thật — chỉ đọc tài liệu, chưa có subscription Azure để thực hành (xem §11.3).

## 0. Kiểm chứng khóa có trong danh sách 32 khóa đã duyệt — ĐẠT

Khóa này là **số 10 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11). Bằng chứng đầy đủ: Ú đã đọc đủ 32 tên bằng browser thật 20/11 21:57, ghi trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main — "10. Get started with AI agent development on Azure — Microsoft Learn". Theo chỉ dẫn task 147, **không kiểm chứng lại từ đầu**; bản này chỉ đối chiếu lại tên khóa với danh sách đó.

**Lưu ý đổi tên (kiểm chứng 20/11/2026):** tên cũ "Get started with AI agent development on Azure" nay đã đổi thành **"Develop AI agents on Azure"** trên Microsoft Learn — URL module cũ (`/training/modules/develop-ai-agent-azure/...`) tự chuyển hướng về learning path mới. Nội dung là một: cùng learning path, cùng 2 trụ **Microsoft Foundry Agent Service + Microsoft Agent Framework**. Đây là hệ quả của đợt đổi tên lớn nhà Microsoft: "Azure AI Agent Service" → "Microsoft Foundry Agent Service", "Azure AI Studio" → "Microsoft Foundry". Khi tra tài liệu cũ (trước 2026) mà thấy tên Azure AI Agent Service thì đó là tên cũ của cùng một dịch vụ.

| Hạng mục | Số liệu đã kiểm chứng (20/11/2026) |
|---|---|
| Đối tượng | AI Engineer, Developer, Data Scientist, Solution Architect (module 1 ghi rõ) |
| Quy mô | **Learning path 9 module** trên trang Learn (xem §1); mỗi module có exercise thực hành + knowledge check/module assessment |
| Trình độ | Intermediate (module 1 ghi "Intermediate"); yêu cầu trước: quen Azure + Azure portal, hiểu GenAI, biết VS Code cơ bản |
| Tổng thời lượng | **Chưa xác định** — trang learning path không công bố tổng thời lượng (khác 144/145 có ghi rõ) |
| FREE? | ✅ Toàn bộ nội dung learning path đọc miễn phí, không cần đăng nhập. **Nhưng để thực hành tạo agent thật thì cần subscription Azure + model deployment** (xem §11.3 — ranh giới quan trọng của khóa này) |
| Chứng chỉ | Learning path thuộc khóa AI-3026 (đào tạo giảng viên, có phí khi học qua trung tâm); **không đăng ký thi/chứng chỉ** theo §9 |
| Ngôn ngữ | Tiếng Anh |

**Không trùng:** khóa gần nhất là 145 Power Automate (flow xác định: cùng trigger thì chạy cùng các bước) và 143 AutoGen (pattern multi-agent qua hội thoại). 147 là bước tiếp theo đúng như 145 §8 gợi ý: từ *"flow xác định"* sang *"agent tự quyết định bước tiếp theo"* — nhưng lần này là **trên nền tảng Azure có sẵn của Microsoft**, không phải framework mã nguồn mở. Chuỗi agents đã đủ mạch: 140 (khung 4 pattern) → 143 (multi-agent bằng AutoGen) → 145 (flow xác định) → 147 (agent trên Azure).

## 1. Cấu trúc learning path — 9 module

| # | Module | Nội dung chính |
|---|---|---|
| 1 | Develop AI agents with Microsoft Foundry and Visual Studio Code | Agent là gì, Foundry Agent Service, 3 cách phát triển, build agent đầu tiên, test/deploy |
| 2 | Integrate custom tools into your agent | Vì sao cần tool riêng; các lựa chọn custom tool; build agent có custom tool |
| 3 | Integrate MCP Tools with Azure AI Agents | MCP server/client, tool discovery động, wrap MCP tool thành async function |
| 4 | Build knowledge-enhanced AI agents with Foundry IQ | RAG, knowledge layer dùng chung, nguồn dữ liệu, citation |
| 5 | Integrate web-based knowledge into your agent with Web IQ | Web Search/News/Images/Videos/Browse/Auto, Web IQ AppID, nối qua MCP |
| 6 | Integrate your agent with Microsoft 365 | Publish agent lên Teams + Microsoft 365 Copilot, Work IQ, Agents Toolkit |
| 7 | Build agent-driven workflows using Microsoft Foundry | Node, biến, structured output, rẽ nhánh, For-Each, human-in-the-loop, Power Fx |
| 8 | Develop an AI agent with Microsoft Agent Framework | SDK Agent Framework, tạo Foundry agent bằng code, plugin function |
| 9 | Orchestrate a multi-agent solution using the Microsoft Agent Framework | 5 pattern orchestration: sequential, concurrent, handoff, group chat, Magentic |

**Ghi chú về module thứ 10 (A2A):** Class Central và chương trình AI-103 liệt kê thêm module "Discover Microsoft Foundry agents with A2A" (giao thức agent-to-agent), nhưng trang learning path chính thức ngày 20/11/2026 chỉ có 9 module — A2A tồn tại như module riêng/bổ sung, chưa nằm trong path này. Tài liệu Foundry xác nhận A2A v1.0 đã GA (v0.3 còn preview). Không coi A2A là module thứ 10 của path này cho tới khi trang Learn cập nhật.

## 2. Agent theo định nghĩa của Microsoft — model + instructions + tools

- **Định nghĩa:** agent là ứng dụng AI dùng LLM để suy luận về yêu cầu của người dùng và **tự thực hiện hành động** để hoàn thành yêu cầu đó. Khác chatbot ở chỗ: chatbot trả lời, agent **làm việc** (gọi tool, truy xuất dữ liệu, chạy nhiều bước).
- **Ba thành phần lõi** (mọi agent Foundry đều có):
  - **Model (LLM):** suy luận + sinh ngôn ngữ — dùng model trong Foundry model catalog (GPT-4o, Llama, DeepSeek...), đổi model không cần đổi code agent.
  - **Instructions:** mục tiêu, ràng buộc, cách hành xử của agent — viết bằng prompt, định nghĩa workflow, hoặc code của hosted agent.
  - **Tools:** cho agent chạm tới dữ liệu/hành động thật (search, file, API...). Không có tool, agent chỉ là chatbot biết nói hay.
- **Ba thành phần bổ sung** mà tài liệu Foundry nhấn mạnh:
  - **Knowledge:** nguồn dữ liệu để grounding — Foundry IQ hợp nhất SharePoint, OneLake, Blob Storage, web thành knowledge base dùng chung, có phân quyền (permission-aware); Foundry lo chunking, embedding, retrieval, khỏi tự build pipeline RAG.
  - **Memory:** agent nhớ procedural + episodic memory qua nhiều lượt hội thoại, tăng tỉ lệ thành công ở tác vụ nhiều bước.
  - **Observability:** tracing, metrics, evaluation tự động — xem từng quyết định agent đã làm, đo chất lượng, bắt regression.
- **Thread:** hội thoại user–agent diễn ra trên một *thread* — giữ lịch sử tin nhắn + file sinh ra trong hội thoại. Thread là "bộ nhớ ngắn hạn" của agent; memory (§2) là "bộ nhớ dài hạn".

**Quy tắc chọn "agent hay flow hay chatbot" (rút từ 140 + 145 + 147):** việc có thứ tự bước biết trước, ổn định → flow (145, rẻ và đoán được); việc cần suy luận, chọn bước tiếp theo theo tình huống, dùng tool linh hoạt → agent; việc chỉ trả lời câu hỏi, không hành động → chatbot/RAG thuần. Chọn sai thì hoặc tốn tiền agent cho việc flow làm được, hoặc kẹt flow ở việc cần agent quyết.

## 3. Microsoft Foundry Agent Service — 3 loại agent + Responses API

Foundry Agent Service là **managed platform** để build, deploy, scale agent: lo hosting, scaling, identity, observability, enterprise security để người làm chỉ tập trung vào logic agent.

| Loại agent | Cách làm | Code phải maintain | Dùng khi nào |
|---|---|---|---|
| **Prompt agent** | Khai báo bằng cấu hình: instructions + model + tools (portal, SDK, REST, `azd`) | Không | Nhanh nhất; agent nội bộ; agent production không cần orchestration logic riêng |
| **Voice-based prompt agent** | Như prompt agent + cấu hình giọng nói; Foundry quản lý voice qua Voice Live (nhận diện, turn-taking, tổng hợp giọng) | Không (phần voice orchestration) | Tổng đài, trải nghiệm thoại realtime, low-latency; hỗ trợ 2 kiến trúc: speech-to-speech native và cascaded (STT → text model → TTS) |
| **Hosted agent** | Mang code của mình (Agent Framework, LangGraph, OpenAI Agents SDK, Anthropic Agent SDK, code tự viết) đóng container/.zip; Foundry chạy với managed endpoint, autoscale, Entra identity riêng | Có — logic agent của mình | Agent cần gọi code riêng; orchestration logic tùy biến; multi-agent; protocol riêng (webhook, voice, AG-UI) |

- **Workflow agent (preview):** loại thứ tư trong tài liệu cũ — agent dạng workflow nhiều bước; tài liệu mới nhất gộp vào prompt agent qua "Microsoft Copilot harness" (preview) cho multi-step tool/skill/file/command workflow.
- **Responses API — ephemeral agent:** gọi trực tiếp từ code của mình, không tạo agent resource trong Foundry: định nghĩa agent (instructions, tools, model) nằm trong code app, mỗi lần gọi là lắp ráp lại rồi chạy. Dùng khi muốn logic agent version cùng code app qua source control, nhưng mất Copilot harness và agent optimizer (hai tính năng này cần agent đã lưu version).
- **Ba đường bắt đầu (portal-first / code-first / Azure Developer CLI):** portal-first tạo nhanh trong Foundry portal, test ở playground rồi gọi từ app; code-first định nghĩa agent bằng SDK/REST trong pipeline (version control, code review, rollout tự động); `azd` giữ định nghĩa agent trong source control rồi deploy + invoke.

## 4. Vòng đời phát triển agent — 7 bước (build → test → deploy → monitor)

Tài liệu Foundry định nghĩa vòng đời chuẩn, khớp với vòng đời task của team ở tầng quy trình:

1. **Create:** định nghĩa prompt agent trong portal/SDK, hoặc viết hosted agent gọi Responses API.
2. **Test:** chat với agent trong agents playground, hoặc chạy local. MCP server (kể cả custom MCP host trên Azure Functions) test trực tiếp trong playground để kiểm tra kết nối tool, quyền, hành vi trước khi publish.
3. **Trace:** xem từng model call, tool invocation, quyết định của agent.
4. **Evaluate:** chạy evaluation đo chất lượng, bắt regression.
5. **Optimize:** agent optimizer (preview) tự cải thiện instructions, skill, mô tả tool, lựa chọn model cho prompt agent và hosted agent.
6. **Publish:** promote agent thành managed resource với endpoint ổn định; version tự snapshot, rollback/compare được bất cứ lúc nào.
7. **Monitor:** theo dõi hiệu năng/độ tin cậy bằng service metrics và dashboard (Application Insights).

**Đối chiếu team:** bước 2–4 chính là "validate + device test" của team ở tầng agent; bước 5 (optimizer tự sửa instructions) là dạng reflection tự động (143 §4) nhưng có đo (132) — khác reflection mù; bước 6 (version snapshot + rollback) là điều team đang làm thủ công bằng git branch + merge qua chị cả. Khóa này cho thấy nền tảng lớn đã chuẩn hóa đúng những kỷ luật team đang giữ bằng tay.

## 5. Tools và Toolbox — agent chạm tới thế giới thật bằng gì

- **Built-in tools:** web search, file search, code interpreter, memory. Thêm custom tool qua functions, OpenAPI specs, MCP servers.
- **Custom tool (module 2):** khi built-in tool không đủ — ví dụ gọi API nội bộ, tra dữ liệu hệ thống riêng. Module dạy: lợi ích của custom tool, các lựa chọn triển khai, rồi build agent tích hợp custom tool (exercise).
- **Toolbox — khái niệm đáng nhớ nhất của khóa:** gom một tập tool thành **một đơn vị tái dùng**; Foundry expose toolbox qua **một managed MCP endpoint duy nhất** mà agent/runtime nào cũng dùng được, bất kể framework. Toolbox tập trung authentication, governance, versioning: tạo version mới → test → promote làm default, khỏi sửa lại từng agent. Đây là đáp án của Microsoft cho bài toán "10 agent cùng gọi 1 API nội bộ thì quản lý ở đâu" — quản lý một chỗ, dùng mọi nơi.
- **Xác thực khi nối MCP server remote:** key-based, Microsoft Entra (managed identity của agent/project), OAuth On-Behalf-Of (OBO) passthrough, hoặc unauthenticated khi phù hợp. MCP server ví dụ: Azure DevOps MCP Server, hoặc custom MCP host trên Azure Functions qua webhook endpoint `/runtime/webhooks/mcp`.

## 6. MCP — tool discovery động (module 3)

- **Vai trò:** MCP server là nơi host tool; MCP client là phía agent phát hiện + gọi tool. Agent không cần biết trước tool tồn tại — phát hiện động lúc chạy.
- **Cách tích hợp:** wrap MCP tool thành async function, đăng ký với agent; agent tự quyết định gọi khi nào trong lúc chạy (khác custom tool khai báo tĩnh ở module 2 — MCP là "cắm thêm tool lúc chạy").
- **Ánh xạ sang team:** worker gọi git/script/browser mỗi ngày chính là tool use; MCP tương đương việc team có thêm "cổng tool chung" mà worker nào cũng cắm được, thay vì mỗi worker tự cài tool riêng. Bài học lặp lại từ 123/140/143: **mô tả tool rõ là một nửa của việc gọi đúng** — tool đăng ký mơ hồ thì agent gọi sai hoặc gọi thừa, tốn token + tiền.

## 7. Foundry IQ và Web IQ — knowledge layer (module 4–5)

### 7.1 Foundry IQ — RAG có quản trị

- **Vấn đề RAG giải quyết:** model không biết dữ liệu nội bộ, dữ liệu thay đổi sau ngày train — nối agent với dữ liệu thật, trả lời có citation.
- **Foundry IQ là shared knowledge platform:** nhiều agent cùng dùng một knowledge base; nguồn dữ liệu: Azure AI Search, Blob Storage, SharePoint, OneLake. Cấu hình instructions để kiểm soát hành vi retrieval (khi nào tra, trích dẫn ra sao, trả lời nhất quán).
- **Điểm khác với RAG tự build (task 121):** không tự làm chunking/embedding/retrieval; đổi lại phải chấp nhận cách Foundry làm + trả phí hạ tầng. Nối bài học 121 (demo rẻ nhất: Streamlit + Gemini API free tier): RAG tự build rẻ để học, Foundry IQ là đường production khi cần permission-aware + nhiều agent dùng chung.

### 7.2 Web IQ — grounding bằng web thời gian thực

- **Vì sao cần:** dữ liệu nội bộ không có tin mới — agent cần web để trả lời câu hỏi về hiện tại.
- **6 phương thức:** Web Search, News, Images, Videos, Browse, Auto. Tạo Web IQ resource → lấy Web IQ AppID → test request trong portal → nối vào Foundry agent qua MCP tool → đánh giá câu trả lời có grounding.
- **Cảnh báo nối 144 §5:** web grounding không miễn kiểm chứng — agent trích web sai thì sai có citation trông rất đáng tin. Quy tắc Ask–review–verify–decide–act vẫn áp dụng cho câu trả lời có citation.

## 8. Tích hợp Microsoft 365 và A2A (module 6 + bổ sung)

- **Publish agent lên Teams + Microsoft 365 Copilot:** đưa agent tới nơi user đã làm việc, thay vì bắt user mở thêm một app. Kèm **Work IQ** để agent truy cập dữ liệu Microsoft 365 (mail, file, lịch...) trong phạm vi quyền của user.
- **Microsoft 365 Agents Toolkit:** công cụ nâng cao để đóng gói/publish agent theo chuẩn M365.
- **Chia sẻ agent:** versioning + publish (endpoint ổn định) + phân phối qua Microsoft Copilot, Teams, **Entra Agent Registry** — "danh bạ agent" của tổ chức.
- **Giao thức agent-to-agent:** Foundry hỗ trợ **A2A protocol** (agent discovery, giao tiếp trực tiếp, phối hợp task qua các agent ở xa — A2A v1.0 GA, v0.3 preview), OpenResponses và Activity Protocols cho publish M365, Invocations protocol cho tích hợp endpoint linh hoạt với app riêng.
- **Ánh xạ:** A2A là "hợp đồng liên lạc" giữa các agent của tổ chức khác nhau — tương đương PROTOCOL của team ở tầng agent: không có chuẩn chung thì mỗi cặp agent phải tự thỏa thuận cách nói chuyện.

## 9. Foundry Workflows — agent-driven workflow (module 7)

- **Workflows** là cách orchestrate agent + component khác thành ứng dụng thông minh, **trong Foundry** (không cần viết code orchestration).
- **Cơ chế:** node (bước), biến, output của agent điều khiển luồng chạy; route request bằng structured output + logic điều kiện; loop qua nhiều input bằng node For-Each; dùng **Power Fx expressions** để biến đổi dữ liệu và điều khiển luồng.
- **Human-in-the-loop và escalation:** workflow có pattern dừng lại hỏi người khi confidence thấp — đúng chỗ "người giữ quyết định" của 145 (approval action), nhưng ở đây là **escalation theo độ tin cậy**, không phải phê duyệt mọi bước.
- **Đối chiếu 145:** workflow Foundry là "flow có agent bên trong" — ngược với 145 (flow xác định thuần). Ranh giới chọn: bước nào quy tắc rõ thì để node/flow quyết (rẻ, đoán được); bước nào cần suy luận thì giao agent node. Đừng giao cả workflow cho một agent tự quyết từ đầu tới cuối khi một nửa số bước đã biết trước.

## 10. Microsoft Agent Framework — SDK viết agent bằng code (module 8)

- **Agent Framework là gì:** SDK mã nguồn mở (Python + .NET) để build agent bằng code, **kế thừa Semantic Kernel và AutoGen** — Microsoft đang hợp nhất AutoGen vào đây (nối 143 §8: AutoGen maintenance mode, không bắt đầu dự án mới bằng AutoGen 0.2).
- **Cách dùng với Foundry:** `FoundryChatClient` nối SDK tới Foundry project → tạo Foundry Agent Service agent bằng code → gắn plugin function (tool viết bằng code) cho agent.
- **Khi nào dùng SDK thay vì portal:** cần logic riêng, test tự động, version control, CI/CD — đúng ba đường ở §3 (code-first). Portal để thử nhanh; SDK để làm thật, giống như team: thử ý tưởng trong chat thì nhanh, nhưng việc thật phải qua task file + branch + review.

## 11. Orchestration — 5 pattern multi-agent (module 9)

Module này là phần nối trực tiếp nhất với 140/143 — cùng 5 pattern, nhưng là **bản SDK có sẵn**, không phải tự cài đặt như AutoGen.

| Pattern | Cơ chế | Dùng khi nào |
|---|---|---|
| **Sequential** | Output agent trước làm input agent sau, thứ tự cố định | Pipeline nhiều bước, tinh chỉnh dần (vd: thu thập → phân tích → viết → sửa) |
| **Concurrent** | Cùng task broadcast cho nhiều agent cùng lúc, gom kết quả độc lập | Phân tích song song, subtask độc lập, ensemble decision |
| **Handoff** | Chuyển quyền điều khiển giữa các agent theo context/rule; một agent làm việc tại một thời điểm | Escalation, fallback, routing tới chuyên gia |
| **Group chat** | Nhiều agent (có thể kèm người) trò chuyện chung; chat manager chọn ai nói tiếp | Brainstorm, giải quyết chung, xây đồng thuận |
| **Magentic** | Manager agent lập kế hoạch, giao việc, theo dõi tiến độ qua progress ledger, sửa kế hoạch khi team chững lại | Việc phức tạp, mở — đường đi tự hình thành trong lúc làm |

- **Nền tảng workflow của SDK:** workflow gồm **executors** (agent hoặc custom logic — đơn vị làm việc), **edges** (direct, conditional, switch-case, fan-out, fan-in — định nghĩa luồng message), **events** (WorkflowStarted/Output/Error, ExecutorInvoke/Complete, RequestInfo — để quan sát + debug). Workflow hỗ trợ **checkpointing** (lưu và resume trạng thái).
- **Quy trình chung mọi pattern:** định nghĩa agent → chọn pattern (thêm manager agent nếu cần) → cấu hình callback/transform → start runtime → invoke với task → nhận kết quả bất đồng bộ. Đổi pattern không cần viết lại logic agent.
- **Trạng thái 2026:** orchestration patterns đạt **1.0 ở cả Python và .NET** (blog Microsoft 08/07/2026) — Sequential, Concurrent, Group Chat, Handoff, Magentic đều ổn định. Khuyên dùng: "Try magentic on a task you would not trust to a hand-wired pipeline. Try handoff when the routing rules matter. Try sequential or concurrent when the workflow should stay deterministic."
- **Đối chiếu 143 (AutoGen):** 4 pattern AutoGen (reflection, tool use, planning, multi-agent) nay có bản SDK chính thức; Magentic là pattern thứ 5 mà AutoGen 0.2 không có sẵn. Team 3 Muse là **group chat có điều phối bằng con người + task file** (chị cả là manager, Anh chốt hướng) — tức là Magentic ở tầng tổ chức, nhưng planning do người làm, không phải LLM. Khóa này xác nhận lựa chọn đó: Magentic tự lập kế hoạch chỉ nên dùng khi việc thật sự mở; việc có hậu quả thật (merge/push) thì planning phải do người giữ.

## 12. Bảo mật, quản trị, vận hành — phần không được bỏ qua

- **Identity:** mỗi agent có thể có Entra identity riêng; RBAC qua Microsoft Entra + Azure RBAC (ai được tạo/gọi/quản lý agent); dùng Foundry RBAC thay vì key (key bypass role); managed identity + OAuth OBO khi tool cần quyền thay mặt user.
- **Mạng và dữ liệu:** chạy trong Azure VNet (private networking cho prompt agent; hosted agent dùng BYO VNet, mỗi session chạy trong VM-isolated sandbox); bring-your-own resources (storage, Foundry IQ/AI Search, Cosmos DB cho conversation state) để đáp ứng compliance/data residency.
- **An toàn nội dung:** content filter tích hợp, guardrails chống prompt injection **kể cả cross-prompt injection (XPIA)** — agent guardrails còn preview. Đây là nối trực tiếp 135 (guardrails) + 137 (red teaming): agent có tool thì prompt injection không chỉ làm sai câu trả lời mà còn **gọi sai tool, chạm sai dữ liệu** — chặn lúc chạy là bắt buộc, không phải tùy chọn.
- **Quan sát được:** tracing từng model call/tool call, metrics, Application Insights, evaluation — không có trace thì agent sai mà không biết sai ở bước nào (đúng bài học "On Track" của 144 §6, nhưng ở quy mô chạy tự động hàng loạt).
- **Chi phí — ranh giới FREE:** nội dung khóa đọc miễn phí; chạy agent thật tốn tiền theo: model input/output, speech (voice agent), tool/data service đã nối, Application Insights ingestion/retention, container compute (hosted agent). Không có free tier nào cho "chạy agent production miễn phí" trong tài liệu — chi phí là lý do phải chọn đúng loại agent (§3) và đúng pattern (§11), không phải cứ agent là tốt.
- **Cảnh báo vòng đời sản phẩm:** Azure AI Agent Service bản classic (hub-based) đã deprecated, **retire 31/03/2027** — workload mới phải dùng Foundry Agent Service hiện tại; tài liệu/bài viết cũ dùng tên Azure AI Agent Service thì phải đối chiếu lại, không áp dụng máy móc.

## 13. So sánh với các khóa đã học + nối mạch 140→143→145→147

| Khía cạnh | 140 Agentic AI (khung) | 143 AutoGen (pattern) | 145 Power Automate (flow) | 147 Foundry Agent Service (nền tảng) |
|---|---|---|---|---|
| Câu hỏi trả lời | Agent là gì, pattern nào | Triển khai multi-agent ra sao | Việc lặp lại tự chạy thế nào | Build agent production ở đâu |
| Công cụ | Khái niệm, không gắn vendor | Framework OSS (AutoGen) | Low-code, Microsoft 365 | Managed service Azure + SDK |
| Mức tự chủ | 4 pattern (reflection, tool, planning, multi-agent) | Hội thoại là runtime | Xác định (deterministic) | Từ prompt agent (khai báo) tới hosted agent (tự code) |
| Human-in-the-loop | Chưa nhấn mạnh | UserProxy hỏi trước khi chạy code | Approval action | Escalation theo confidence + approval + RBAC |
| Đo/chặn | Evals + error analysis | Sandbox + tách vai viết/chạy | Flow checker + run history 28 ngày | Tracing + evaluation + optimizer + guardrails (XPIA) |
| Tuổi thọ | Khái niệm bền | AutoGen maintenance mode → Agent Framework | Sản phẩm ổn định | **Đang là hướng chính của Microsoft** |

**Kết luận nối mạch:** 140 cho bản đồ, 143 cho cách đóng gói pattern vào framework, 145 cho nền flow xác định, 147 cho **nơi chạy thật** — managed service lo hosting/scale/security, SDK lo orchestration. Ai đã đọc 140+143 sẽ thấy 5 pattern của 147 không phải pattern mới mà là **bản product hóa** của pattern đã biết; ai chỉ đọc 147 mà chưa đọc 140 sẽ tưởng "agent = mua dịch vụ Azure là xong" và bỏ qua evals/guardrails — sai lầm tốn kém nhất của khóa này.

## 14. Áp dụng ngay cho Anh / team (đề xuất, muse-main quyết)

1. **Chưa làm agent thật trên Azure:** báo cáo này chỉ đọc lý thuyết (theo §9: không đăng ký, không chạy lab tốn phí). **Chưa xác định** Anh/công ty có subscription Azure + license Microsoft 365 gồm Foundry hay không — cần kiểm tra trước khi hứa hẹn bất kỳ agent thật nào (nối 145 §7.3). Không đề xuất đăng ký Azure trial trả phí trong task này.
2. **Ứng viên agent đầu tiên nếu đã có Azure (xếp theo độ dễ, khi chị cả quyết):**
   - (a) **Prompt agent tra cứu nội bộ (Foundry IQ):** agent trả lời câu hỏi về SOP/biểu mẫu từ SharePoint — toàn cấu hình, không code, có citation; đúng mẫu "knowledge agent" của module 4.
   - (b) **Agent tổng hợp báo cáo ca (workflow):** workflow Foundry nhận báo cáo ca → agent tóm tắt → human-in-the-loop duyệt trước khi gửi ca sau — nối đề xuất 145 §7.1(a) nhưng thêm bước agent suy luận thay vì chỉ ghép flow.
   - (c) **Multi-agent review tài liệu chất lượng (Magentic, chỉ khi (a)(b) đã chạy ổn):** manager agent + specialist agents (soát chính tả, soát số liệu, soát tuân thủ) — nhưng planning và quyết định cuối vẫn do người giữ, không giao cho manager agent tự quyết.
3. **Quy tắc an toàn trước khi bật agent thật (nối khung 144 §5 + 135 + 137):** test trong playground → đọc trace từng tool call → chạy evaluation đo chất lượng → bật guardrails/XPIA → giới hạn data source + tool theo least privilege (agent chỉ chạm dữ liệu nó cần) → xác định owner trước khi publish. Agent chạm dữ liệu sản xuất/khách hàng thì **bắt buộc có bước human-in-the-loop** trước khi gửi ra ngoài.
4. **Giữ nguyên kiến trúc team:** khóa này không thay đổi cách team phối hợp — team đã là multi-agent system có quản trị (task file là nguồn sự thật, chị cả là manager, worker không tự merge). Foundry/Agent Framework là công cụ để **build agent cho việc khác**, không phải để thay cách team làm việc. Đề xuất 143 §10.2 (nested reflection có trace cho worker) vẫn giữ nguyên trạng thái "có điều kiện, chưa làm ngay".
5. **Cập nhật tên gọi trong tài liệu team:** từ nay dùng "Microsoft Foundry Agent Service" (không dùng "Azure AI Agent Service" nữa); AutoGen ghi rõ "maintenance mode — dự án mới dùng Microsoft Agent Framework"; tài liệu cũ nhắc Azure AI Agent Service classic thì ghi chú "retire 31/03/2027".

## 15. Đề xuất cập nhật skill / khóa tiếp theo

- **Skill research — thêm recipe "Chọn agent hay flow hay chatbot" (từ §2):** việc có thứ tự bước biết trước → flow; việc cần suy luận + chọn bước theo tình huống → agent; việc chỉ trả lời, không hành động → chatbot/RAG. Kèm checklist **"Trước khi bật agent thật"** (§14.3: playground → trace → evaluation → guardrails/XPIA → least privilege → owner) và cảnh báo **"Agent có tool thì prompt injection không chỉ sai câu trả lời mà còn gọi sai tool — chặn lúc chạy là bắt buộc"**.
- **Khóa tiếp theo gợi ý (chị cả quyết theo §10):** trong danh sách 32, ứng viên nối trực tiếp 147 là **#11 "AI Agents in LangGraph" (DeepLearning.AI)** — cùng chủ đề multi-agent nhưng ở cực đối diện của phổ kiểm soát (LangGraph = đồ thị trạng thái viết cứng; Agent Framework = SDK orchestration có sẵn; AutoGen = hội thoại là runtime) — học xong sẽ có đủ 3 cực để chọn kiến trúc. Không gợi ý #15 Business Automation (HubSpot) vì Ú đã claim task 146 ngày 20/11.

## Nguồn đã kiểm chứng

- Learning path "Develop AI agents on Azure" (9 module, tên cũ "Get started with AI agent development on Azure"): https://learn.microsoft.com/en-us/training/paths/develop-ai-agents-azure/
- Module 1 "Develop AI agents with Microsoft Foundry and Visual Studio Code" (Intermediate, 1200 XP, mục tiêu học + 10 units): https://learn.microsoft.com/en-us/training/modules/develop-ai-agents-azure-vs-code/
- Module 9 unit "Understand agent orchestration" (5 pattern, executors/edges/events, checkpointing): https://learn.microsoft.com/en-us/training/modules/orchestrate-semantic-kernel-multi-agent-solution/3-understand-agent-orchestration
- Tài liệu "What is Microsoft Foundry Agent Service?" (3 loại agent, Responses API, Toolbox, vòng đời 7 bước, enterprise capabilities, A2A v1.0 GA): https://learn.microsoft.com/en-us/azure/foundry/agents/overview
- Tài liệu "Understand Microsoft Foundry Agent Service" (classic deprecated, retire 31/03/2027; RBAC, managed identity, OBO, guardrails preview): https://learn.microsoft.com/en-us/training/modules/intro-ai-agent-service-security-controls/1-understand-azure-ai-agent-service
- Syllabus + mô tả từng module (10 mục incl. A2A, giá 0 USD): https://www.classcentral.com/course/microsoft-learn-develop-ai-agents-on-azure-532245
- "Agent Framework's Orchestration Patterns Reach 1.0" (DevBlogs Microsoft, 08/07/2026 — 5 pattern ổn định Python + .NET): https://devblogs.microsoft.com/agent-framework/agent-frameworks-orchestration-patterns-reach-1-0/
- "Workflow orchestrations in Agent Framework" (bảng 5 pattern): https://learn.microsoft.com/uk-ua/agent-framework/workflows/orchestrations/
- Danh sách 32 khóa đã duyệt (khóa này là số 10; bằng chứng Ú đọc bằng browser thật 20/11 21:57): `research/140-governing-ai-agents-deeplearning-ai.md` trên main
- Báo cáo 143 (AutoGen, maintenance mode, 4 pattern), 145 (flow xác định, human-in-the-loop qua approval), 144 (khung Ask–review–verify–decide–act): `research/143-ai-agentic-design-patterns-autogen-deeplearning-ai.md`, `research/145-demonstrate-capabilities-power-automate-microsoft-learn.md`, `research/144-work-smarter-with-ai-microsoft-learn.md`

*Module assessment / Knowledge check cuối mỗi module: chưa làm — cần đăng nhập tài khoản Microsoft để ghi điểm; theo §9 không đăng nhập/đổi cài đặt tài khoản trong lúc học nên bỏ qua, không ảnh hưởng nội dung báo cáo (nội dung 9 module đã đọc đủ qua mục tiêu học + syllabus + tài liệu Foundry/Agent Framework đi kèm). Exercise các module chưa chạy thật — cần subscription Azure + model deployment, ngoài phạm vi FREE của task này.*
