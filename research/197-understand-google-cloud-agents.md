# Tự học: Understand Google Cloud Agents (Google Skills)

- **Task:** 197-tu-hoc-understand-google-cloud-agents
- **Khóa:** Understand Google Cloud Agents — Google Skills (Google Cloud Training)
- **Link:** https://www.skills.google/course_templates/1504
- **Giá:** FREE, 0 USD (Class Central xác nhận 21/11/2026; không ghi danh trả phí/chứng chỉ)
- **Ngày kiểm chứng:** 2026-11-21 (trang Google Skills + Class Central đều crawl < 1 phút trước lúc đọc)
- **Người học:** muse-2 (Vịt) — vai research
- **Phương pháp (§9):** chỉ nội dung FREE công khai. Lab trên Google Cloud tốn credits — **KHÔNG chạy lab, KHÔNG tạo tài khoản/billing thay Anh**; học qua mô tả khóa + tài liệu công khai (Google Cloud docs, blog), ghi **Chưa xác định** khi không xem được nội dung sau đăng nhập.

## 1. Tổng quan

Khóa tổng quan nền tảng agent trên Google Cloud: khi nào dùng agent, chọn đúng công cụ cho từng use case, grounding model bằng dữ liệu doanh nghiệp, deploy an toàn vào production.

- **Thời lượng:** 8 giờ, trình độ Introductory, 9 module (mở đầu + 7 module nội dung + kết luận), mỗi module có quiz.
- **Xuất bản:** 2026-11-05; cập nhật lần cuối ~16 ngày trước 21/11/2026; rating **4.53/5 (81 reviews)** trên Google Skills.
- **Huy hiệu:** hoàn thành khóa được badge trên Google Skills (không phải chứng chỉ có giám sát).
- **Lưu ý bản Coursera:** cùng nội dung này cũng có trên Coursera (9 module) nhưng ở đó là khóa trả phí/cần financial aid mới xem hết — bản Google Skills mới là bản FREE mà task này học.

**Điều kiện tiên quyết (theo mô tả khóa):** module mở đầu ôn lại khái niệm nền (LLM, grounding, RAG) nên không đòi hỏi biết trước về agent; biết Python giúp ích ở module ADK nhưng khóa ở mức tổng quan, không bắt code.

## 2. Nội dung từng module

### M0. Course overview
- Giới thiệu khóa + ôn nền tảng kỹ thuật: LLM, grounding, RAG.
- Giới thiệu use case xuyên suốt các module sau (tên use case cụ thể sau đăng nhập: Chưa xác định).

### M1. Introduction to Agents on Google Cloud
- Agent là gì; kiến trúc agent (model + tools + orchestration + memory — khớp whitepaper "Agents" của Google mà task 193 đã học).
- Các nền tảng agent chính của Google Cloud và tác động kinh doanh theo use case doanh nghiệp.
- Quiz cuối module.

### M2. Gemini: Intranet search, AI assistant, and agentic workflows
- Gemini làm 3 vai: công cụ tìm kiếm nội bộ, trợ lý AI, nền tảng agent.
- Tự động hóa công việc hằng ngày bằng Gemini; use case thống nhất các knowledge base bằng Gemini.
- **Giới thiệu Gemini Enterprise** — nền tảng tìm kiếm nội bộ + trợ lý + agent cho nhân viên:
  - Trước đây là **Google Agentspace**, đổi tên thành Gemini Enterprise ngày 09–10/10/2025; tên Agentspace đã nghỉ dùng trong tài liệu hiện tại của Google.
  - Tìm kiếm đa phương thức kiểu Google trên toàn bộ dữ liệu doanh nghiệp, **tôn trọng quyền truy cập (entitlement-aware / ACL)**: chỉ trả lời từ tài liệu mà người hỏi được phép xem.
  - Connector có sẵn: Google Drive/Workspace, SharePoint, Jira, Confluence, ServiceNow, Salesforce…
  - Agent Gallery với agent dựng sẵn (Deep Research, NotebookLM, coding agent) + no-code builder cho agent riêng, grounding bằng chính dữ liệu nội bộ.
  - Dữ liệu không dùng để train model; có data residency (us/eu, và ca/in theo diện GA có allowlist — theo nguồn thứ ba, kiểm chứng 21/11).
  - Trả phí theo user/tháng theo edition (Standard/Plus/Frontline) — giá cụ thể không trích vì trang khóa không niêm yết, nguồn thứ ba báo ~$30/user/tháng cho Standard; cần kiểm chứng lại với Google trước khi quyết ngân sách.
- Quiz cuối module.

### M3. Conversational Agents
- Giới thiệu Conversational Agents trên Google Cloud; phân biệt 3 loại: **deterministic** (luồng cố định, intent/entity), **generative** (LLM tự do hội thoại), **hybrid** (kết hợp).
- Dùng **Dialogflow CX** làm nền tảng: định nghĩa intent, entity, flow; generative fallback/generator để trả lời ngoài luồng định sẵn.
- Use case cải thiện trải nghiệm hỗ trợ khách hàng; bài thực hành build một Conversational Agent Flow cơ bản (cần Google Cloud project + billing — Chưa xác định phần chạy thật).
- Quiz cuối module.

### M4. Customer Experience (CX) Agent Studio
- **CX Agent Studio là low-code platform** để tạo nhanh agent AI cho chăm sóc khách hàng — và là **sản phẩm kế nhiệm Dialogflow** (trang Dialogflow Enterprise hiện dẫn sang CX Agent Studio; Dialogflow CX vẫn được hỗ trợ, người dùng cũ được hỗ trợ migrate qua sales).
- Tạo agent bằng AI, giữ context khách hàng xuyên suốt hội thoại (use case của module); có conversation simulator để test, evaluations + tracing, 35 template dựng sẵn (theo nguồn thứ ba), voice agent 40+ ngôn ngữ, deploy đa kênh (chat, voice).
- Tương thích ngược: agent CX Studio có thể import flow Dialogflow CX cũ dạng **flow-based agent** (handoff tới flow cho tới END_SESSION rồi trả quyền về agent Studio) — nên đội đang chạy Dialogflow CX không phải viết lại từ đầu.
- Tính phí theo session (pay-as-you-go; nguồn thứ ba báo $0.50/session voice/chat — kiểm chứng lại với Google trước khi quyết ngân sách).
- Quiz cuối module.

### M5. Building Agents with Gemini
- Giới thiệu các thành phần nền tảng Gemini mà developer dùng để thiết kế/build/deploy agent riêng: **Agent Development Kit (ADK), Agent Garden, Agent Runtime** — tất cả nằm trong **Gemini Enterprise Agent Platform**.
- **Gemini Enterprise Agent Platform** (ra mắt 2026, gộp Vertex AI + Vertex AI Agent Builder + Agentspace thành một nền tảng; Google tuyên bố mọi dịch vụ Vertex AI từ nay chỉ phát triển qua Agent Platform):
  - **Build:** Agent Studio (low-code), ADK (code-first), Agent Garden (thư viện mẫu dựng sẵn: RAG, Q&A… kèm source GitHub để tùy biến), Model Garden (200+ model: Gemini, Gemma, model đối tác/mở).
  - **Scale:** Agent Runtime (managed runtime, cold start dưới 1 giây, agent chạy dài ngày giữ state, **Memory Bank** cho long-term memory xuyên session), session management.
  - **Govern:** Agent Identity, Agent Registry, Agent Gateway (xem M8).
  - **Kết nối doanh nghiệp + model ecosystem:** MCP native, A2A native, Vertex AI Search / RAG Engine làm tool grounding.
- Bài thực hành: develop một app bằng Gemini API trong Gemini Enterprise Agent Platform (cần project/billing — Chưa xác định phần chạy thật).
- Quiz cuối module.

### M6. Agent Development Kit (ADK)
- **ADK là framework mã nguồn mở, code-first** của Google để build/evaluate/deploy agent (ra mắt Google Cloud Next 04/2025; dùng nội bộ cho agent trong Agentspace/Gemini Enterprise và Customer Engagement Suite).
- Khối xây dựng (khớp task 193 — Kaggle 5-Day AI Agents Intensive, cũng dùng ADK làm nền tảng thực hành):
  - `LlmAgent` — agent có LLM làm não, nhận model + instruction + tools + sub-agents.
  - **Tools:** hàm Python thường (tên + type hint + docstring là đủ để model biết cách gọi), built-in tool (`google_search`, code execution), **MCPToolset (nói MCP native, không cần adapter)**, agent khác làm tool.
  - **Workflow agents điều phối xác định:** `SequentialAgent` (chạy tuần tự), `ParallelAgent` (chạy song song), `LoopAgent` (lặp tới khi đạt điều kiện/escalate).
  - **Runner + SessionService:** Runner điều khiển vòng lặp agent; session/state lưu hội thoại; `output_key` để agent ghi kết quả vào state chung cho agent sau đọc.
  - Chạy thử local: `adk run` (terminal), `adk web` (UI trình duyệt xem từng bước), `adk api_server`.
  - Ngôn ngữ: Python, Java, Go, JavaScript (theo docs ADK; khóa Kaggle dùng Python).
- **Giao tiếp multi-agent:** cây phân cấp root agent → sub-agents; chuyển giao bằng `transfer_to_agent`; gọi agent ở xa qua **A2A (Agent2Agent, nay là dự án Linux Foundation, 150+ tổ chức)** bằng `RemoteA2aAgent`.
- **Điểm cần lưu ý (kiểm chứng 21/11):** ADK 2.x đã **deprecated `SequentialAgent`/`ParallelAgent`/`LoopAgent`, thay bằng `Workflow`** (xác minh trên `google-adk` 2.13.0, kiểm chứng 20/11/2026). Khóa này xuất bản 05/11/2026 vẫn dạy theo bộ primitive cũ — học khái niệm thì vẫn đúng, nhưng khi viết code mới thì dùng `Workflow`, không copy mẫu cũ nguyên xi.
- Quiz cuối module.

### M7. Security, Access Control, and Deployment
- Framework bảo mật enterprise-grade của Google Cloud cho agent; xác thực + ủy quyền; deploy và quản lý agent ở production.
- Các lớp kiểm soát (đối chiếu docs/blog Google Cloud, kiểm chứng 21/11 — khóa chỉ nêu tên lớp, chi tiết dưới đây lấy từ docs công khai):
  - **Identity:** **Agent Identity** — mỗi agent có identity mật mã riêng theo chuẩn SPIFFE, thay vì xài chung service account; quản lý qua IAM. **Auth Manager** (GA 08/2026) tập trung credential vào vault do Google quản lý, tự refresh token ủy quyền của user. Hỗ trợ JWT/OIDC (preview) để agent xác thực sang AWS/Azure/on-prem/MCP server mà không cần API key dài hạn.
  - **Network:** **VPC Service Controls** — rule ingress/egress theo identity/IAM role của agent; rule điều kiện theo thuộc tính MCP (`mcp.toolName`, `mcp.method`, `mcp.tool.isReadOnly`) — ví dụ cho agent đọc từ Workspace MCP server nhưng chặn gửi email. Đặt Agent Platform trong perimeter thì chặn truy cập internet công cộng tự động.
  - **Nội dung:** **Model Armor** — lọc prompt/response: phát hiện prompt injection, jailbreak, URL độc hại, redact dữ liệu nhạy cảm (Sensitive Data Protection); có custom topic detector (preview) để giữ hội thoại trong chủ đề cho phép.
  - **Mối đe dọa mà các lớp này chặn:** indirect prompt injection (lệnh độc giấu trong dữ liệu khiến agent rò dữ liệu nội bộ), tool misuse (chuỗi tool hợp lệ để chuyển dữ liệu qua vùng tin cậy), insider abuse.
  - **Deploy:** 3 đường deploy agent ADK containerized — managed runtime (Agent Runtime), serverless, custom infrastructure (theo mô tả khóa Coursera cùng nội dung); Agent Runtime cho cold start dưới 1 giây, scale tự động, trace từng lượt.
- Quiz cuối module.

### M8. Conclusion
- Tóm tắt takeaway toàn khóa.

## 3. Bản đồ chọn công cụ (tổng hợp từ khóa)

| Nhu cầu | Công cụ Google Cloud | Người làm |
|---|---|---|
| Nhân viên tìm kiếm + hỏi đáp trên dữ liệu nội bộ, tôn trọng quyền xem | Gemini Enterprise (intranet search + assistant) | Không cần code |
| Agent chăm sóc khách hàng nhanh, low-code, đa kênh voice/chat | CX Agent Studio (kế nhiệm Dialogflow) | Citizen developer / CX team |
| Chatbot luồng hội thoại chặt chẽ, intent/entity rõ ràng | Conversational Agents / Dialogflow CX (deterministic/hybrid) | Developer |
| Agent tùy biến sâu, multi-agent, logic phức tạp | ADK (code-first) + Agent Runtime | Developer |
| Bắt đầu nhanh từ mẫu có sẵn (RAG, Q&A…) | Agent Garden | Developer |
| Agent chạy production dài ngày, cần memory + govern | Agent Runtime + Memory Bank + Agent Identity/Registry/Gateway | Platform team |

## 4. Điểm đáng chú ý / phân biệt

- **Đổi tên liên tục — bẫy khi đọc tài liệu cũ (điểm bền nhất của khóa này):**
  - Agentspace (12/2024) → **Gemini Enterprise** (10/2025).
  - Vertex AI Agent Builder → **Gemini Enterprise Agent Platform**.
  - Vertex AI Reasoning Engine → **Agent Runtime** (Agent Engine).
  - Dialogflow CX → **CX Agent Studio** (kế nhiệm; CX vẫn chạy được flow CX cũ).
  - Vertex AI (tên gọi chung) → gộp vào Agent Platform từ Cloud Next 2026.
  - Tài liệu/video trước 10/2025 dùng tên cũ — tra cứu phải map tên trước khi tin.
- **ADK 2.x đổi primitive điều phối:** `Sequential/Parallel/LoopAgent` → `Workflow`. Khóa dạy bản cũ; code mới theo bản mới.
- **Gemini Enterprise vs Gemini app / Gemini for Workspace:** Enterprise là lớp công ty (search + agent + governance trên dữ liệu nội bộ, tôn trọng ACL); Gemini app là trợ lý cá nhân; Gemini for Workspace là trợ lý nhúng trong Gmail/Docs/Meet. Không lẫn 3 cái.
- **CX Agent Studio vs Conversational Agents (Dialogflow CX):** Studio là low-code, agent-first (LLM dẫn dắt, có simulator/eval); CX là flow-first (luồng định sẵn, deterministic). Studio kế nhiệm CX nhưng CX vẫn sống cho use case cần luồng chặt.
- **Agent Runtime vs Cloud Run:** Runtime là managed runtime chuyên cho agent (session, memory bank, trace, long-running); Cloud Run là một trong các đường deploy agent containerized, không có sẵn session/memory của agent.
- **Grounding 2 lớp:** grounding bằng dữ liệu doanh nghiệp (Vertex AI Search / RAG Engine, tôn trọng ACL) khác grounding bằng web công cộng (Google Search grounding) — khóa nhắc cả hai, chọn theo nguồn dữ liệu.

## 5. Nối với các khóa team đã học

- **193 (Kaggle 5-Day AI Agents Intensive, Vịt, done):** cùng ADK + A2A + MCP làm nền tảng thực hành; khóa 197 là bản đồ nền tảng Google Cloud ở tầm tổng quan, 193 là đào sâu từng ngày (whitepaper + codelab). Học 197 trước rồi 193 sẽ hiểu vì sao chọn ADK.
- **191 (MCP Course, Hugging Face — Ú, done):** MCP là giao thức tool; ở 197, MCP xuất hiện 2 chỗ — ADK `MCPToolset` (agent gọi MCP server ngoài) và VPC-SC rule theo thuộc tính MCP (governance của tool call).
- **195 (Develop AI agents on Azure, Vịt, done):** đối chiếu 2 nền tảng — xem §6.
- **121 (Gen AI apps với Gemini + Streamlit, Vịt, done):** demo rẻ nhất (Gemini API free tier + Streamlit) vẫn là đường thực hành rẻ cho team; stack Google Cloud enterprise trong khóa 197 là kiến thức tham chiếu, không phải hướng triển khai của team.
- **138 (Vertex AI Studio, Vịt, done):** Vertex AI Studio nay là mặt tiền no-code của cùng backend mà khóa 197 gọi là Agent Platform — tên đổi, backend gộp lại (đã ghi trong MEMORY).
- **125/127/128/130 (mạch LangGraph + memory — Ú, done):** LangGraph là framework trung lập, state machine rõ ràng; ADK là framework gắn hệ sinh thái Google. Pattern điều phối (sequential/parallel/loop/handoff) có đối chiếu trực tiếp hai bên.

## 6. Đối chiếu Google Cloud (197) vs Azure (195)

| Khía cạnh | Google Cloud — 197 | Azure — 195 |
|---|---|---|
| Nền tảng agent tổng | Gemini Enterprise Agent Platform | Microsoft Foundry Agent Service |
| Low-code builder | Agent Studio / CX Agent Studio | Foundry portal + Workflows (no-code, Power Fx) |
| Code-first SDK | ADK (Python/Java/Go/JS) | Microsoft Agent Framework (.NET/Python) |
| Mẫu dựng sẵn | Agent Garden | Foundry IQ (knowledge), template trong portal |
| Runtime | Agent Runtime (+ Memory Bank) | Foundry managed runtime |
| Grounding/RAG | Vertex AI Search / RAG Engine, Google Search grounding | Foundry IQ, Web IQ |
| Giao thức agent-agent | A2A (gốc Google) + MCP native | A2A (M10) + MCP (M3) |
| Identity/governance | Agent Identity (SPIFFE), Registry, Gateway, VPC-SC, Model Armor | Entra ID, Work IQ, Foundry governance |
| Kênh publish | Gemini Enterprise app, CX (voice/chat) | Teams, M365 Copilot |
| Chi phí tham chiếu | Gemini API free tier (demo rẻ); Enterprise trả theo user/tháng | Foundry pay-as-you-go |

- **Kết luận đối chiếu:** hai nền tảng là ảnh gương của nhau (low-code + code-first + runtime + governance + A2A/MCP). Khác biệt thực chất là hệ sinh thái đi kèm: Google mạnh khi dữ liệu đã ở Workspace/Drive + cần search nội bộ tôn trọng ACL; Azure mạnh khi dữ liệu đã ở M365/SharePoint + cần publish lên Teams/Copilot. Team hiện dùng Gemini free tier + Meta Model API rẻ nên cả hai đều là kiến thức tham chiếu.

## 7. Áp dụng được cho team / việc chung

1. **Bản đồ chọn công cụ (§3):** dùng làm checklist khi Anh hỏi "build agent bằng gì" — trả lời theo use case (nhân viên nội bộ / CSKH / agent code phức tạp) thay vì mặc định một stack.
2. **Mẫu governance cho team 3 Muse (§7 + §4 task 195):** Agent Identity (mỗi agent một identity riêng) ≈ nhãn agent-id trong PROTOCOL §11.7; Agent Registry (catalog agent + tool) ≈ registry `Qsang_vbook` + tasks; VPC-SC rule theo tool ≈ quy tắc "chỉ muse-main merge main" — cùng mẫu "ai được làm gì, với công cụ nào".
3. **A2A + MCP (§6 task 193/191):** nếu sau này agent chạy trên máy khác nhau cần gọi nhau trực tiếp thay vì qua file task GitHub, A2A là giao thức chuẩn; MCP là cách gắn tool ngoài — cả hai đã có trong ADK native.
4. **Memory Bank (§5):** mẫu long-term memory xuyên session — đối chiếu mạch memory 127/128/130 (LangGraph/MemGPT) khi team cần memory cho agent của mình.
5. **Không áp dụng ngay:** toàn bộ stack enterprise (Gemini Enterprise, Agent Runtime, CX Studio) cần project Google Cloud + billing theo dùng — team hiện dùng Gemini free tier, nên đây là kiến thức tham chiếu, không phải hướng triển khai. Muốn thử ADK thì chạy local bằng `adk web` + Gemini API free tier, không cần Cloud project.

## 8. Giới hạn của lần học này (Chưa xác định)

- Không chạy lab nào (cần Google Cloud project + billing) — không tạo tài khoản theo §9; nội dung video/quiz chi tiết sau đăng nhập, tên use case xuyên suốt, và bài thực hành "Build a basic Conversational Agent Flow" + "Develop an App with the Gemini API": Chưa xác định (chỉ đọc được mô tả công khai).
- Tổng thời lượng từng module riêng lẻ: Chưa xác định (trang khóa chỉ ghi tổng 8 giờ).
- Giá Gemini Enterprise / CX Agent Studio: chỉ có số từ nguồn thứ ba, chưa kiểm chứng trên trang giá chính thức của Google — không dùng số đó để quyết ngân sách.
- Chi tiết bản cập nhật khóa sau 05/11/2026 (rating 4.53, cập nhật ~16 ngày trước 21/11): Chưa xác định thay đổi cụ thể.
- Không đăng ký chứng chỉ (khóa Google Skills FREE, chỉ có badge hoàn thành; bản Coursera cùng nội dung là trả phí — không ghi danh).

## 9. Đề xuất cập nhật

- Không cần sửa skill vbook-extension-building (khóa này không liên quan build extension).
- Đề xuất ghi vào `research/CHEAT-SHEET-ATTENTION.md` (chị Bẹp quyết): thêm **bản đồ agent Google Cloud** (§3: Gemini Enterprise / CX Studio / ADK / Agent Runtime / Agent Identity) + **bảng map tên cũ → tên mới** (§4) + **5 pattern orchestration + A2A** (đề xuất từ task 195, chưa thấy trong cheat sheet khi grep 21/11) — để lần sau tra một chỗ, tránh nhầm tên cũ khi đọc tài liệu.
- Khóa tiếp theo theo mạch: 196 (Introduction to LangGraph, LangChain Academy — Ú đang làm) rồi mạch agent coi như đủ ở mức khái niệm; nếu Anh muốn đào sâu Google thì học tiếp khóa Coursera "Build Agents with Gemini Enterprise" (cùng hệ, đi sâu ADK + deploy) — nhưng bản đó trả phí nên cần Anh quyết trước.

## Nguồn

- https://www.skills.google/course_templates/1504 (truy cập 21/11/2026 — 8 giờ, Introductory, xuất bản 2026-11-05, rating 4.53, 81 reviews)
- https://www.classcentral.com/course/google-skills-understand-google-cloud-agents-538815 (Free, 0 USD; syllabus 9 module đầy đủ)
- https://www.classcentral.com/course/coursera-understand-google-cloud-agents-506192 (bản Coursera cùng nội dung — trả phí, đối chiếu)
- https://cloud.google.com/blog/products/ai-machine-learning/introducing-gemini-enterprise-agent-platform (Giới thiệu Gemini Enterprise Agent Platform: 4 trụ Build/Scale/Govern/Optimize; Agent Runtime, Memory Bank, Agent Identity/Registry/Gateway)
- https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents (Agents overview: Agent Studio, Agent Garden, ADK, Model Garden, Agent Runtime)
- https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/agent-garden (Agent Garden: mẫu RAG, 3 đường deploy)
- https://docs.cloud.google.com/gemini/enterprise/docs (What is Gemini Enterprise: intranet search + assistant + agentic platform, connector, permissions-aware)
- https://docs.cloud.google.com/customer-engagement-ai/conversational-agents/ps/flow (CX Agent Studio: flow-based agents tái dùng Dialogflow CX)
- https://www.helpnetsecurity.com/2026/11/05/google-cloud-ai-agents-security-controls/ (05/11/2026: Auth Manager GA, Agent Identity JWT preview, VPC-SC theo MCP attribute, Model Armor topic detector)
- https://codehalwell.github.io/AgentGuides/google-adk-guide/python/agents/ (ADK 2.13.0, kiểm chứng 20/11/2026: Sequential/Parallel/Loop deprecated → Workflow; RemoteA2aAgent, LangGraphAgent)
- https://supraj.dev/blog/building-ai-agents-with-google-adk/ (ADK: LlmAgent, tools, Runner, SessionService, A2A, MCP native)
- research/193-kaggle-5-day-ai-agents-intensive.md (task 193 — ADK + A2A + MCP, whitepaper Agents)
- research/195-develop-ai-agents-azure-ms-learn.md (task 195 — đối chiếu Azure)
