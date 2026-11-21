# MCP Course (Hugging Face, xây cùng Anthropic) — Báo cáo tự học (task 191)

- **Khóa học:** Model Context Protocol (MCP) Course, Hugging Face — xây dựng cùng Anthropic
- **Trang khóa:** https://huggingface.co/learn/mcp-course/unit0/introduction
- **Học viên:** muse-1 (Ú) — vai build, mạch AI Agents, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** khóa số 1 đợt 12 khóa AI/Dev Anh DUYỆT 21/11 13:59, giao sau khi danh sách 20 khóa công việc hoàn tất 20/20 (189 + 190 done 14:02). Nối 148 (HF AI Agents Course — vòng lặp Thought/Action/Observation + 3 framework), 125 (AI Agents/LangGraph), 127/128/130 (agent memory), 140 (Agentic AI — đã giới thiệu MCP ở §4 và kết luận "theo dõi MCP như chuẩn nối tool, ưu tiên chuẩn mở thay vì tự chế giao thức riêng"). MCP là mảnh còn thiếu: 148 dạy agent *gọi tool của chính nó*, khóa này dạy *giao thức chuẩn để mọi host gọi tool của mọi server*. Học bản JS/TS theo vai build của Ú (khóa có ví dụ Python hoặc TypeScript).
- **Hình thức:** chỉ học nội dung FREE công khai, **không tạo tài khoản Hugging Face, không chạy notebook/Space/lab, không nộp assignment, không lấy chứng chỉ**. Báo cáo học qua trang khóa chính thức (Unit 0–3 + Unit 1 recap) đối chiếu với đặc tả MCP chính thức (xem Ghi chú trung thực). Phần hands-on (build server Gradio, deploy Spaces, PR Agent với Claude Code) được học qua syllabus + trang hướng dẫn công khai, không bịa kết quả chạy.

## Quét chống trùng (PROTOCOL §3) — 21/11/2026

- **Repo đích (muse-teamwork, research/):** grep "mcp" chỉ ra 125/140/147/151 (nhắc MCP như chủ đề phụ) + fleet-console-demo — chưa có báo cáo riêng về MCP Course. Không trùng.
- **Tasks claimed/doing/review:** chỉ có 191 (claimed, muse-1). Task 193 (Kaggle 5-Day, muse-2) có ngày học tools + MCP nhưng là khóa khác, bổ trợ nhau (STATUS.md ghi 193 nối 191). Không trùng việc.
- **STATUS.md:** 191 ghi open (đã giao 14:10); 147 (Azure) đã học Toolbox/MCP ở mức khái niệm, 140 đề xuất "theo dõi MCP" — task này học sâu MCP chuẩn + build/deploy server thật, không mở lại site đã đóng nào.

## Kiểm chứng mức FREE trước khi học

- **Khóa học: FREE, cả chứng chỉ cũng FREE.** Trang Unit 0 chính thức ghi rõ "This free course, built in partnership with Anthropic" và "The certification process is completely free" (đọc 21/11/2026). Học audit mode thì không cần thông báo gì.
- **Hai chứng chỉ:** (1) *Certificate of Fundamentals* — hoàn thành Unit 1 (cho người muốn cập nhật xu hướng MCP, chưa cần build app đầy đủ); (2) *Certificate of Completion* — hoàn thành các unit use-case 2 và 3 (build app thật + chia sẻ với cộng đồng).
- **Yêu cầu trước:** hiểu cơ bản AI/LLM, quen nguyên lý phát triển phần mềm + khái niệm API, kinh nghiệm ít nhất một ngôn ngữ lập trình (ví dụ Python hoặc TypeScript). Cần máy tính có internet + tài khoản Hugging Face miễn phí nếu muốn làm hands-on/nộp bài. Nhịp khuyến nghị: mỗi chapter 1 tuần, khoảng 3–4 giờ/tuần.
- **Phần không chạy được trong phạm vi FREE của task này:** Unit 3 yêu cầu cài Claude Code để test tích hợp MCP server (trang Unit 3 ghi rõ "Installation Required", xác thực qua console.anthropic.com) — chi phí/điều kiện tài khoản Claude Code: **Chưa xác định** trong các nguồn đã đọc, báo cáo không cài, không đăng nhập. Unit 2 deploy lên Hugging Face Spaces cần tài khoản HF — không tạo. Đây là ranh giới quan trọng giống task 148: khóa "free" ở tầng nội dung + chứng chỉ, không có nghĩa mọi cách chạy lab đều miễn phí/không cần tài khoản.

## Ghi chú trung thực về nguồn học

Báo cáo này học qua **ba lớp nguồn**, ghi rõ để muse-main chấm review biết giới hạn — cùng mẫu với task 148/192:

- **Lớp 1 — trang khóa chính thức (cấu trúc + nội dung lõi):** Unit 0 introduction (syllabus, chứng chỉ, nhịp học, giảng viên Ben Burtenshaw — ML Engineer tại Hugging Face — và Alex Notov — Technical Partner Enablement Lead tại Anthropic, làm Unit 3), Unit 1 recap (kiến trúc, primitive, JSON-RPC, discovery, Gradio), Unit 2 introduction + trang Gradio server + trang clients + Tiny Agents, Unit 3 introduction + solution walkthrough, Unit 4 introduction ("Coming Soon") — tất cả đọc 21/11/2026.
- **Lớp 2 — đặc tả MCP chính thức (đối chiếu độc lập):** trang Transports của modelcontextprotocol.io (bản 2025-06-18, đọc 21/11/2026) — hai transport chuẩn stdio và Streamable HTTP, cảnh báo bảo mật cho Streamable HTTP. Đây là nguồn để phát hiện **lệch pha giữa khóa và spec hiện hành** (mục 7).
- **Lớp 3 — nguồn thứ cấp về bản spec 2026-07-28:** trang Deprecated features của MCP Python SDK chính thức + các bản tóm tắt độc lập (đọc 21/11/2026) về SEP-2577 (deprecate Roots/Sampling/Logging) và thay đổi stateless. Khóa được viết trước bản này nên vẫn dạy Sampling như một primitive bình thường — báo cáo ghi rõ chỗ nào là kiến thức khóa, chỗ nào là spec mới hơn khóa.
- **Không chạy code, không ghi danh:** chi tiết trong notebook/assignment có thể sâu hơn trang công khai — ghi rõ để muse-main biết giới hạn. Chỗ nào nguồn không cho số thì ghi Chưa xác định, không tự điền.

## Cấu trúc khóa (syllabus chính thức, Unit 0)

| Unit | Nội dung chính | Khái niệm lõi |
|---|---|---|
| 0. Onboarding | Syllabus, chứng chỉ, nhịp học, tạo tài khoản, Discord | Cách học + 2 đường chứng chỉ |
| 1. MCP Fundamentals, Architecture and Core Concepts | MCP là gì; kiến trúc Host/Client/Server; Tools/Resources/Prompts/Sampling; JSON-RPC 2.0; transport stdio + HTTP+SSE; discovery qua `tools/list`; SDK; Gradio; use-case đơn giản | Bài toán M×N → M+N, ai kiểm soát primitive nào |
| 2. End-to-end Use case: MCP in Action | Build MCP server sentiment analysis bằng Gradio (`mcp_server=True`, TextBlob), client HuggingFace.js (JS) + smolagents (Python), Tiny Agents, cấu hình `mcp.json`, deploy lên HF Spaces, test/debug | Một hàm Python + docstring + type hints = một MCP tool có schema |
| 3. Deployed Use case: MCP in Action | PR Agent Workflow Server cho Claude Code: Module 1 Tools (phân tích file, gợi ý PR template), Module 2 GitHub Actions qua Cloudflare Tunnel + Prompts, Module 3 Slack notification; thêm Resources cho ngữ cảnh dự án | Cả 3 primitive phối hợp trong một workflow thật |
| 4. Bonus Units | Trang hiện ghi "Coming Soon — collaboration with partners" | **Chưa xác định** nội dung chi tiết (đọc 21/11/2026) |

Đường đi của khóa: **hiểu giao thức → build server nhỏ nhất có thể deploy được → build server workflow nhiều primitive → (bonus)**. Khác 148 (đo bằng benchmark GAIA) ở chỗ khóa này đo bằng *sản phẩm deploy được và chia sẻ được*, không có leaderboard.

## 1. Bài toán M×N và kiến trúc Host / Client / Server

- **Bài toán gốc:** nối M ứng dụng AI với N công cụ/nguồn dữ liệu theo kiểu tự chế cần M×N tích hợp riêng lẻ. MCP biến nó thành M+N: mỗi ứng dụng viết một MCP client, mỗi công cụ viết một MCP server, hai bên gặp nhau ở giao thức chung. Đây là lý do MCP được gọi là "USB-C cho AI" trong nhiều tài liệu — một cổng chuẩn thay vì mỗi thiết bị một dây.
- **Ba vai (Unit 1 recap, đối chiếu khớp spec):**
  - **Host** — ứng dụng AI người dùng nhìn thấy (Claude Desktop, Cursor, VS Code, Claude Code...). Host điều phối, quản lý các client, quyết định khi nào lấy dữ liệu/gọi tool.
  - **Client** — thành phần *bên trong* host, giữ **một kết nối 1:1 với đúng một server**, xử lý chi tiết giao thức (handshake, discovery, gọi tool). Host có bao nhiêu server thì có bấy nhiêu client.
  - **Server** — chương trình/dịch vụ bên ngoài cung cấp tools, dữ liệu, dịch vụ qua MCP; thường là lớp bọc mỏng (lightweight wrapper) quanh chức năng đã có sẵn (API, file, database).
- **Hệ quả kiến trúc:** thêm server mới không cần sửa host (modularity) — host tự khám phá khả năng của server qua các method list (`tools/list`, `resources/list`, `prompts/list`) thay vì hardcode. Đây là điểm khác căn bản với tool-calling kiểu cũ ở 148: ở 148, tool được *ghim vào system prompt lúc khởi tạo agent* và agent chỉ biết tool của chính nó; ở MCP, danh sách tool là **dữ liệu runtime** mà client kéo về khi kết nối.
- **Ánh xạ sang team:** team hiện có đúng hình dạng này mà chưa gọi tên MCP: mỗi worker (Ú/Vịt) là một "host" chạy model, các "server" là git, hub muse-teamwork, browser, script claim/complete — nhưng giao thức nối chúng là tự chế (HTTP endpoint riêng của hub, CLI riêng của script). Bài học từ 140 §4 lặp lại ở đây với bằng chứng cụ thể hơn: nếu sau này team muốn một client chuẩn bên ngoài (vd Claude Code trên máy Anh) gọi được hub, đường đúng là bọc hub thành MCP server thay vì viết thêm một adapter riêng nữa (xem mục 8).

## 2. Ba primitive + Sampling: ai kiểm soát cái gì

Điểm thiết kế quan trọng nhất của MCP không phải là "có tool" mà là **phân quyền kiểm soát** cho từng loại khả năng (Unit 1 recap):

| Primitive | Là gì | Ai kiểm soát | Hệ quả an toàn |
|---|---|---|---|
| **Tools** | Hàm thực thi được, có thể có side-effect (gửi tin nhắn, truy vấn API, sửa file) | **Model** quyết định gọi | Thường cần người dùng phê duyệt trước khi chạy, vì gọi là *làm thật* |
| **Resources** | Nguồn dữ liệu chỉ-đọc để lấy ngữ cảnh, giống GET endpoint của REST | **Ứng dụng/host** quyết định nạp | Không thực thi, ít rủi ro; host chọn nạp gì vào ngữ cảnh |
| **Prompts** | Template/workflow định sẵn hướng dẫn tương tác | **Người dùng** chọn | Người dùng chủ động kích hoạt, không tự chạy |
| **Sampling** | Server *nhờ ngược* client gọi LLM giúp (server-driven agentic behavior) | Client phê duyệt từng lần | **Đã deprecated ở spec 2026-07-28** (mục 7) — khóa vẫn dạy, không nên xây mới trên nó |

- **Nguyên tắc chọn primitive:** việc *đọc* thì là Resource, việc *làm* thì là Tool, việc *người dùng chọn quy trình* thì là Prompt. Nhầm lẫn phổ biến nhất của người mới là biến mọi thứ thành Tool — khi đó model có quyền tự gọi cả những việc lẽ ra host/người dùng phải quyết.
- **Ánh xạ sang team:** PROTOCOL của team đã vô tình áp đúng phân quyền này: task file + STATUS.md là "resources" (chỉ đọc để lấy ngữ cảnh, worker không tự ý đổi trạng thái của task người khác); claim/complete/push là "tools" (có side-effect, bị chặn bởi script + gate evidence §11.2); các mẫu báo cáo/quiz là "prompts" (Anh hoặc chị cả chọn khi nào dùng). Khóa cho team một ngôn ngữ chuẩn để gọi tên — và một tiêu chí kiểm tra: nếu một khả năng mới được thêm vào hub mà không trả lời được "ai kiểm soát nó", thiết kế đó chưa xong.
- **Ánh xạ sang nhà máy (gợi ý, không tự làm):** một trợ lý tra cứu SOP/FSSC đúng chuẩn MCP sẽ phơi SOP/checklist dưới dạng **Resources chỉ-đọc** (host quyết nạp), không phơi dưới dạng Tool ghi/sửa — vì sửa tài liệu chất lượng là việc có side-effect cần phê duyệt, không phải việc model tự quyết. Đây là cùng ranh giới "Chưa xác định thay vì đoán" mà team đang giữ.

## 3. JSON-RPC 2.0, discovery và transport

- **Định dạng tin nhắn:** mọi trao đổi client↔server là JSON-RPC 2.0 (request/response/notification, UTF-8). Transport chỉ là "đường ống" chở các tin nhắn này — đổi transport không đổi ngữ nghĩa giao thức.
- **Hai transport theo khóa (Unit 1 recap):** **stdio** cho giao tiếp local (client khởi chạy server như tiến trình con, nói chuyện qua stdin/stdout) và **HTTP+SSE** cho remote.
- **Đối chiếu spec chính thức (đọc 21/11/2026):** spec hiện hành định nghĩa hai transport chuẩn là **stdio** và **Streamable HTTP** (một endpoint duy nhất nhận POST, trả JSON hoặc stream SSE theo từng request). HTTP+SSE kiểu cũ (bản 2024-11-05) đã deprecated. Khóa vẫn dạy HTTP+SSE vì Gradio MCP server dùng endpoint `/gradio_api/mcp/sse` — đây là **lệch pha cần biết khi học**: học khái niệm từ khóa, nhưng khi build thật phải theo spec mới (xem mục 7).
- **Cảnh báo bảo mật của spec cho Streamable HTTP (nguyên văn tinh thần):** server **MUST** validate header `Origin` để chống DNS rebinding; chạy local thì **SHOULD** bind chỉ 127.0.0.1 thay vì 0.0.0.0; **SHOULD** có xác thực cho mọi kết nối. Với stdio, biên bảo mật là biên tiến trình của hệ điều hành: server chạy với quyền của client đã khởi chạy nó, và credentials lấy từ môi trường (env) chứ không đi qua wire.
- **Ánh xạ sang team:** hub muse-teamwork hiện bind 0.0.0.0:8787, không token/password, chỉ dựa vào tailnet riêng (ghi rõ trong `hub/server.js`: "chỉ chạy trong tailnet riêng của Anh, không mở ra internet"). Theo thang bảo mật của spec MCP, đây là mức chấp nhận được *chỉ vì* nó không ra internet — nhưng nếu hub được MCP-hoá và mở cho client bên ngoài tailnet, ba điều trên (Origin, bind localhost, auth) là điều kiện bắt buộc phải thêm trước, không phải việc làm sau. Ghi nhận này là đề xuất có điều kiện ở mục 8, không tự sửa hub trong task này.

## 4. Unit 2 — Gradio biến một hàm Python thành MCP server

- **Cơ chế lõi:** `demo.launch(mcp_server=True)` (hoặc env `GRADIO_MCP_SERVER=True`) khiến Gradio tự động: (1) biến các hàm Python thành MCP Tools, (2) map input component thành schema tham số của tool, (3) suy định dạng response từ output component, (4) dựng JSON-RPC qua HTTP+SSE, (5) tạo đồng thời web UI cho người và endpoint MCP cho máy. Server mẫu của khóa: `sentiment_analysis(text: str) -> str` dùng TextBlob, trả JSON chứa polarity (−1..1), subjectivity (0..1) và assessment; web UI ở `http://localhost:7860`, MCP endpoint ở `http://localhost:7860/gradio_api/mcp/sse`.
- **Bài học thiết kế đáng nhớ nhất:** **docstring + type hints của hàm chính là schema của tool**. Gradio đọc docstring (mô tả Args/Returns) và type hints để sinh mô tả tool cho model. Hàm viết cẩu thả → mô tả tool cẩu thả → model gọi sai. Đây là cùng bài học "mô tả tool là một nửa của việc gọi đúng" ở 148 §1 và 123, nhưng ở đây nó thành cơ chế tự động: không có bước viết mô tả riêng, tài liệu hàm *là* giao diện.
- **Client:** khóa build client bằng HuggingFace.js (JavaScript) và smolagents (Python), cộng Tiny Agents (`@huggingface/tiny-agents`, cấu hình bằng file `agent.json` gồm model/provider/servers, chạy bằng `npx @huggingface/tiny-agents run agent.json`). Cấu hình server cho host dùng file `mcp.json` với cấu trúc `mcpServers` (name → command/args hoặc url). Với client chưa hỗ trợ SSE trực tiếp (vd Claude Desktop ở thời điểm khóa viết), dùng cầu nối `mcp-remote` chạy qua `npx`.
- **Deploy:** đưa server lên Hugging Face Spaces (cần file `app.py`), sau đó cấu hình client (vd Cursor) trỏ tới `https://<username>-mcp-sentiment.hf.space/gradio_api/mcp/sse`. Deploy là nơi transport + auth lộ ra vấn đề thật — nguồn thứ cấp độc lập cũng nhấn mạnh "deploy something" là trọng tâm thực hành của khóa.
- **Ánh xạ sang team:** mẫu "một hàm + docstring = tool" là cách rẻ nhất để team thử MCP mà không cần viết server từ đầu: một script Python nhỏ (vd đọc STATUS.md, liệt kê task open) bọc bằng Gradio là đủ để một client chuẩn gọi thử. Nhưng đây là đề xuất thử nghiệm có điều kiện — team hiện không có nhu cầu client bên ngoài nào đang chờ, nên không tự làm trong task này (đúng kết luận thận trọng của 133 về cầu Discord: chưa có nhu cầu thật thì chưa xây cầu).

## 5. Unit 3 — PR Agent Workflow Server: cả 3 primitive trong một workflow

- **Sản phẩm:** MCP server biến Claude Code thành trợ lý "team-aware": chọn PR template tự động theo thay đổi code, theo dõi CI/CD, gửi thông báo Slack. Do Alex Notov (Anthropic) phụ trách.
- **Ba module:** (1) **Tools** — server đăng ký `analyze_file_changes` (đọc git diff, trả dữ liệu có cấu trúc), `get_pr_templates`, `suggest_template`; nguyên tắc thiết kế: *tách thu thập dữ liệu khỏi quyết định* — server trả dữ liệu, Claude mới là bên quyết chọn template nào. (2) **Resources** — phơi template files + hướng dẫn của team dưới dạng resource chỉ-đọc để Claude có ngữ cảnh dự án. (3) **Prompts + webhook** — webhook server chạy song song (port riêng) nhận sự kiện GitHub Actions qua Cloudflare Tunnel, MCP Prompts chuẩn hoá cách báo cáo sự cố CI/CD, rồi tích hợp Slack để thông báo cho team. Kiến trúc hai dịch vụ tách biệt: webhook server lo HTTP/sự kiện, MCP server lo phân tích + tích hợp Claude.
- **Điều kiện chạy thật:** cần Claude Code đã cài + xác thực (console.anthropic.com), Cloudflare Tunnel (`cloudflared`), repo GitHub thật, Slack workspace. Tất cả ngoài phạm vi FREE-không-tài-khoản của task này → chỉ học kiến trúc, không chạy. Chi phí Claude Code: **Chưa xác định** trong nguồn đã đọc.
- **Ánh xạ sang team:** PR Agent của khóa là "người anh em" gần nhất với hệ thống team hiện tại: team cũng có phân tích thay đổi (git diff trước khi merge), template chuẩn (mẫu task/báo cáo), theo dõi sự kiện (watcher 5 phút + watchdog), thông báo (báo Anh qua chat). Khác biệt cốt lõi: khóa đóng gói tất cả thành **một MCP server mà bất kỳ host nào cũng gọi được**, còn team đóng gói thành **quy trình + script riêng mà chỉ 3 Muse của team hiểu**. Ưu điểm của cách team: truy vết bền trên GitHub, không phụ thuộc host nào. Ưu điểm của MCP: một client chuẩn mới (vd một IDE khác) dùng lại được ngay mà không cần học quy trình riêng. Bài học rút ra không phải "chuyển sang MCP ngay" mà là: **khi team thiết kế khả năng mới cho hub, hãy thiết kế theo 3 primitive (đọc/làm/chọn quy trình) để sau này bọc MCP không phải đập đi làm lại**.

## 6. Unit 4 — Bonus: chưa có nội dung

Trang Unit 4 chính thức hiện ghi "Coming Soon — this unit will be a collaboration with partners from the AI community" (đọc 21/11/2026). Nội dung chi tiết, đối tác cụ thể, thời điểm mở: **Chưa xác định**. Báo cáo không suy diễn phần này từ các nguồn thứ cấp.

## 7. Lệch pha khóa ↔ spec 2026-07-28: học khóa nhưng build theo spec

Đây là mục quan trọng nhất khi áp dụng — khóa được viết ở giai đoạn MCP còn session-based, spec đã đi tiếp:

- **Sampling, Roots, Logging bị deprecated (SEP-2577, spec 2026-07-28):** theo trang Deprecated features của MCP Python SDK chính thức (đọc 21/11/2026), cả ba vẫn hoạt động trong cửa sổ 12 tháng nhưng implementation mới không nên dùng. Cách thay thế được khuyến nghị rất "đời thường": Roots → truyền đường dẫn qua tham số tool/resource URI/cấu hình server; Sampling → gọi thẳng API của LLM provider; Logging → ghi stderr hoặc OpenTelemetry.
- **Stateless core:** bản 2026-07-28 bỏ protocol-level session và handshake `initialize` kiểu cũ, mỗi request tự mang protocol version + capabilities; server không còn gửi request ngược độc lập được mà dùng mẫu Multi Round-Trip Requests (server trả `InputRequiredResult`, client retry kèm input). Client/server khác "era" không nói chuyện được với nhau nếu không hỗ trợ cả hai.
- **Transport:** HTTP+SSE cũ deprecated, Streamable HTTP là chuẩn remote hiện hành (mục 3).
- **Kết luận thực hành:** học khóa để lấy **kiến trúc + phân quyền primitive + cách build/deploy** (phần bền), nhưng khi viết server thật thì: dùng SDK hiện hành, tránh Sampling/Roots, dùng Streamable HTTP cho remote, và đọc changelog spec trước khi chốt thiết kế. Ai học khóa rồi build y nguyên theo khóa sẽ vô tình xây trên 3 tính năng đang bị khai tử.

## 8. Áp dụng cho team muse-teamwork (đề xuất có điều kiện, không tự làm)

1. **Chưa MCP-hoá hub ngay.** Lý do: hub hiện là kênh phụ tùy chọn, GitHub mới là nguồn sự thật (PROTOCOL §1); chưa có client chuẩn bên ngoài nào cần gọi hub. MCP-hoá lúc này là thêm abstraction không có bài toán — đúng cảnh báo "khi nào không cần framework" của 148 §2.
2. **Nếu sau này cần** (vd Anh muốn dùng Claude Code/Cursor trên máy cá nhân để xem/claim task), thiết kế sẵn theo primitive: `tasks/*.json` + STATUS.md → **Resources** chỉ-đọc; claim/heartbeat/complete → **Tools** có gate phê duyệt + evidence như §11.2; mẫu tạo task tự học → **Prompts** do người chọn. Đồng thời bắt buộc thêm: validate `Origin`, bind localhost hoặc auth thật, không mở 0.0.0.0 không token ra ngoài tailnet.
3. **Thử nghiệm rẻ nhất khi có nhu cầu:** bọc một script đọc-only bằng Gradio `mcp_server=True` theo mẫu Unit 2 để kiểm chứng một client chuẩn gọi được, trước khi đầu tư viết server bằng SDK.
4. **Không xây trên Sampling/Roots** cho bất kỳ thiết kế mới nào (mục 7) — team không có nhu cầu server "mượn" model của client; mỗi worker đã có model riêng.

## 9. Nếu Anh muốn học thật / lấy chứng chỉ

- **Audit mode:** học toàn bộ nội dung FREE, không cần thông báo, không cần chứng chỉ — đủ để nắm kiến trúc + primitive.
- **Certificate of Fundamentals:** hoàn thành Unit 1 (quiz/assignment theo trang khóa).
- **Certificate of Completion:** hoàn thành Unit 2 + 3 — cần tài khoản Hugging Face miễn phí để deploy Spaces, và Claude Code cho Unit 3 (chi phí/điều kiện: **Chưa xác định**, cần Anh tự kiểm tra trước khi quyết).
- Nhịp học gợi ý của khóa: 1 unit/tuần, 3–4 giờ/tuần. Nội dung nên học kỹ nhất theo vai build: phân quyền primitive (mục 2) và mẫu Gradio (mục 4); phần nên đọc kèm spec mới: transport + deprecation (mục 3 + 7).

## Nguồn

- Trang khóa chính thức (Unit 0): https://huggingface.co/learn/mcp-course/unit0/introduction (đọc 21/11/2026)
- Unit 1 recap chính thức: https://huggingface.co/learn/mcp-course/unit1/unit1-recap (đọc 21/11/2026)
- Unit 2 introduction: https://huggingface.co/learn/mcp-course/unit2/introduction (đọc 21/11/2026)
- Unit 2 Gradio server: https://huggingface.co/learn/mcp-course/unit2/gradio-server (đọc 21/11/2026)
- Unit 2 clients: https://huggingface.co/learn/mcp-course/unit2/clients (đọc 21/11/2026)
- Unit 2 Tiny Agents: https://huggingface.co/learn/mcp-course/en/unit2/tiny-agents (đọc 21/11/2026)
- Unit 3 introduction: https://huggingface.co/learn/mcp-course/unit3/introduction (đọc 21/11/2026)
- Unit 3 solution walkthrough: https://huggingface.co/learn/mcp-course/unit3/build-mcp-server-solution-walkthrough (đọc 21/11/2026)
- Unit 4 introduction: https://huggingface.co/learn/mcp-course/unit4/introduction (đọc 21/11/2026)
- Đặc tả MCP chính thức — Transports (2025-06-18): https://modelcontextprotocol.io/specification/2025-06-18/basic/transports (đọc 21/11/2026)
- MCP Python SDK chính thức — Deprecated features (spec 2026-07-28, SEP-2577): https://py.sdk.modelcontextprotocol.io/deprecated/ (đọc 21/11/2026)
- Nguồn thứ cấp đối chiếu quy mô/nhịp học: https://www.aiwisdom.dev/ai-certifications/hugging-face-mcp-course (đọc 21/11/2026)
- Báo cáo team liên quan trên main: `research/140-agentic-ai-deeplearning-ai.md` (§4 MCP), `research/148-ai-agents-course-hugging-face.md`, `hub/server.js` (kiến trúc hub hiện tại)
