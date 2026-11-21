# Tự học: Develop AI agents on Azure (Microsoft Learn, AI-3026)

- **Task:** 195-tu-hoc-develop-ai-agents-azure-ms-learn
- **Khóa:** Develop AI agents on Azure — Microsoft Learn, mã AI-3026
- **Link:** https://learn.microsoft.com/en-us/training/paths/develop-ai-agents-azure/
- **Giá:** FREE, 0 USD (Class Central xác nhận 21/11/2026; không ghi danh trả phí/chứng chỉ)
- **Ngày kiểm chứng:** 2026-11-21 (trang Learn + Class Central đều crawl < 1 phút trước lúc đọc)
- **Người học:** muse-2 (Vịt) — vai research
- **Phương pháp (§9):** chỉ nội dung FREE công khai. Bài tập cần tài khoản Azure / Microsoft Foundry project — **KHÔNG tạo tài khoản/subscription thay Anh**; phần hands-on sau đăng nhập ghi **Chưa xác định**.

## 1. Tổng quan

Learning path dạy hiểu agent AI, khi nào dùng và cách build bằng **Microsoft Foundry Agent Service** (tên mới của Azure AI Agent Service) và **Microsoft Agent Framework** (SDK code-first, kế thừa Semantic Kernel + AutoGen — bản syllabus cũ của TD SYNNEX vẫn ghi module Semantic Kernel, path hiện tại đã thay bằng Agent Framework).

Điều kiện tiên quyết theo Microsoft: quen khái niệm AI cơ bản và dịch vụ AI trên Azure; nên học trước path "Get started with artificial intelligence".

**Số module:** trang Learn hiển thị **9 module**; syllabus đầy đủ trên Class Central liệt kê **10 module** (thêm module A2A cuối). Chưa xác định tổng thời lượng toàn path (Microsoft không ghi tổng giờ trên trang path; từng module thường 30–60 phút).

## 2. Nội dung từng module

### M1. Develop AI agents with Microsoft Foundry and Visual Studio Code
- Agent là gì, Foundry Agent Service có gì (tạo agent, thread, run; quản lý trạng thái hội thoại phía server).
- 2 cách làm: no-code trên Foundry portal và code qua **Foundry Toolkit for VS Code**.
- Mở rộng agent bằng tools; test bằng playground tích hợp; deploy và tích hợp vào ứng dụng.
- Bài tập: build + deploy một agent (cần Foundry project — Chưa xác định phần chạy thật).

### M2. Integrate custom tools into your agent
- Khi nào tool có sẵn không đủ; các lựa chọn custom tool: function calling (hàm tự viết), code interpreter, file search, và tool của bên thứ ba.
- Bài tập: build agent tích hợp custom tool.

### M3. Integrate MCP Tools with Azure AI Agents
- Vai trò MCP server / client trong phát hiện và gọi tool; wrap MCP tool thành async function rồi đăng ký cho Azure AI agent; agent gọi MCP tool động lúc runtime.
- **Nối task 191** (MCP Course, Hugging Face): cùng giao thức MCP, ở đây là phía consumer — agent Azure gọi MCP server ngoài.

### M4. Build knowledge-enhanced AI agents with Foundry IQ
- RAG giải "bài toán tri thức" của agent: **Foundry IQ** là lớp tri thức dùng chung (shared knowledge platform) nhiều agent cùng truy cập, thay vì mỗi agent tự gắn một kho riêng.
- Nguồn dữ liệu: Azure AI Search, Blob Storage, SharePoint, OneLake.
- Cấu hình instruction để kiểm soát hành vi retrieval, trích dẫn nhất quán; test và giám sát chất lượng retrieval khi đưa vào production.

### M5. Integrate web-based knowledge into your agent with Web IQ
- Agent cần grounding bằng thông tin web hiện tại (chống hallucination về sự kiện mới).
- Các phương thức Web IQ: Web Search, News, Images, Videos, Browse, Auto.
- Tạo Web IQ resource, lấy AppID, test trong portal; nối Web IQ vào agent Foundry qua MCP tool.

### M6. Integrate your agent with Microsoft 365
- Publish agent Foundry lên **Microsoft Teams** và **Microsoft 365 Copilot**; dùng **Work IQ** để truy cập dữ liệu workplace (mail, file, lịch…).
- Có mục nâng cao dùng Microsoft 365 Agents Toolkit; test và troubleshoot agent đã tích hợp.
- Bài tập: publish agent lên Teams (cần tenant M365 — Chưa xác định phần chạy thật).

### M7. Build agent-driven workflows using Microsoft Foundry
- Workflow = điều phối agent + các component khác thành ứng dụng thông minh (no-code/low-code trong Foundry).
- Khái niệm: node, biến, output của agent điều khiển luồng; routing bằng structured output + logic điều kiện; vòng lặp For-Each; **human-in-the-loop** và escalation khi độ tin cậy thấp; biểu thức **Power Fx** để thao tác dữ liệu.
- Dùng workflow trong code; bài tập tạo workflow điều khiển bởi agent.

### M8. Develop an AI agent with Microsoft Agent Framework
- Agent Framework SDK (hỗ trợ .NET và Python) nối vào Microsoft Foundry project; tạo agent Foundry Agent Service bằng SDK; gắn plugin function.
- Đây là lớp code-first thay cho cách click portal ở M1.

### M9. Orchestrate a multi-agent solution using the Microsoft Agent Framework
- 5 pattern điều phối, mỗi pattern có trường hợp dùng riêng:
  1. **Concurrent** — các agent chạy song song, gom kết quả.
  2. **Sequential** — agent sau nhận output agent trước (pipeline).
  3. **Group chat** — nhiều agent thảo luận, có quản lý lượt nói.
  4. **Handoff** — chuyển phiên cho agent chuyên môn khi cần.
  5. **Magentic** — orchestrator lập kế hoạch + điều phối động, agent tự chọn bước tiếp theo.
- Bài tập: build giải pháp multi-agent.

### M10. Discover Microsoft Foundry agents with A2A
- Giao thức **A2A** (Agent2Agent, Google): agent discovery, giao tiếp trực tiếp, phối hợp task giữa các agent ở xa.
- Định nghĩa A2A agent, implement agent executor, host A2A server, kết nối tới agent A2A.
- Bài tập: kết nối tới Foundry agent từ xa qua A2A.
- **Nối task 193** (Kaggle 5-Day AI Agents Intensive — có phần A2A + prototype→production) và **task 148/125/127/128/130** (mạch AI Agents: LangGraph, memory).

## 3. Điểm đáng chú ý / phân biệt

- **Foundry IQ vs RAG tự build:** IQ là RAG "đóng gói thành dịch vụ" — một knowledge base dùng chung cho nhiều agent, có tối ưu retrieval và trích dẫn; phù hợp doanh nghiệp có dữ liệu SharePoint/OneLake sẵn. RAG tự build (như task 121 demo Streamlit + Gemini free tier) rẻ hơn nhưng mỗi agent tự quản lý kho.
- **Web IQ vs search tool tự gắn:** Web IQ là dịch vụ tìm kiếm web có quản lý của Microsoft, nối qua MCP — cùng mẫu "tool qua MCP" như M3.
- **Workflows (M7) vs orchestration code (M9):** M7 là no-code trong portal (node + Power Fx), M9 là code-first bằng SDK; chọn theo đối tượng (citizen developer vs engineer).
- **Agent Framework vs LangGraph (task 125):** cùng giải bài toán multi-agent, khác hệ sinh thái — Agent Framework gắn chặt Foundry/Azure, LangGraph trung lập framework + state machine rõ ràng hơn. Pattern concurrent/sequential/group chat/handoff/Magentic có đối chiếu trực tiếp với pattern LangGraph (supervisor, swarm…).
- **Đổi tên cần nhớ:** "Azure AI Agent Service" → "Microsoft Foundry Agent Service"; "Semantic Kernel" → "Microsoft Agent Framework" trong path hiện tại. Tài liệu cũ (TD SYNNEX) vẫn dùng tên cũ.

## 4. Áp dụng được cho team / việc chung

1. **Pattern điều phối multi-agent (M9):** 5 pattern là khung tham chiếu trực tiếp cho cách team 3 Muse phối hợp — hiện tại team dùng handoff thủ công qua task GitHub (tương đương Handoff + Sequential); Magentic là gợi ý nếu sau này có orchestrator tự động phân task.
2. **A2A (M10):** nếu sau này các agent chạy trên máy/khác nhau cần gọi nhau trực tiếp thay vì qua file task GitHub, A2A là giao thức chuẩn để tham khảo (kèm task 193).
3. **Foundry IQ (M4):** mẫu "shared knowledge platform" — áp dụng cho kho `research/` của team: thay vì mỗi báo cáo tự học rời rạc, một lớp tri thức dùng chung (như `research/CHEAT-SHEET-ATTENTION.md` đã làm cho Transformer) giúp agent sau tra cứu nhất quán.
4. **Human-in-the-loop (M7):** khớp quy tắc team — việc chạm line thật / merge main luôn cần người quyết (chị Bẹp merge, Anh quyết), agent chỉ đề xuất.
5. **Không áp dụng ngay:** toàn bộ stack Foundry/Azure cần subscription trả phí theo dùng (pay-as-you-go) — team hiện dùng Gemini free tier + Meta Model API rẻ (theo kết luận Fleet Console), nên đây là kiến thức tham chiếu, không phải hướng triển khai.

## 5. Giới hạn của lần học này (Chưa xác định)

- Không chạy bài tập thực hành nào (cần Azure subscription + Foundry project + M365 tenant) — không tạo tài khoản theo §9.
- Tổng thời lượng path, độ khó từng module sau đăng nhập, và nội dung knowledge check chi tiết: Chưa xác định (chỉ đọc được mô tả công khai).
- Không đăng ký chứng chỉ (AI-3026 là mã khóa học instructor-led tương ứng; path Learn này miễn phí, không cấp chứng chỉ).

## 6. Đề xuất cập nhật

- Không cần sửa skill vbook-extension-building (khóa này không liên quan build extension).
- Ghi chú vào `research/CHEAT-SHEET-ATTENTION.md` (nếu chị Bẹp đồng ý): thêm 5 pattern orchestration (M9) + A2A (M10) vào bản đồ họ agent, cạnh LangGraph — để lần sau tra một chỗ.
- Khóa tiếp theo theo mạch: 194 (Building Reliable Agents, LangChain Academy — Ú đang làm) rồi 192 đã xong; mạch Azure coi như đủ ở mức khái niệm.

## Nguồn

- https://learn.microsoft.com/en-us/training/paths/develop-ai-agents-azure/ (truy cập 21/11/2026)
- https://www.classcentral.com/course/microsoft-learn-develop-ai-agents-on-azure-532245 (Free, 0 USD)
- https://academy.tdsynnex.com/tr/training/course/ai-3026/ (syllabus cũ, còn ghi Semantic Kernel — đối chiếu tên cũ/mới)
