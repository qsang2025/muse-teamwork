# Context Engineering for Marketing (HubSpot Academy) — Báo cáo tự học (task 151)

- **Khóa học:** Context Engineering for Marketing, HubSpot Academy
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10: Vịt rảnh sau khi task 149 bị hủy — trùng 100% với 125, không còn task mở). Đây là **khóa số 9 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11); bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main — KHÔNG kiểm chứng lại từ đầu. Nối mạch context: sau 127/130 (bộ nhớ agent) và 148 (agentic RAG, diễn đạt lại truy vấn) — context engineering là cách tổ chức ngữ cảnh cho model/agent, đối chiếu với memory/retrieval đã học; góc marketing của HubSpot, nối tiếp 146 (Business Automation, HubSpot).
- **Hình thức:** chỉ học nội dung FREE công khai; không đăng ký trả phí/chứng chỉ, không chạy lab/API tốn phí, không tạo tài khoản HubSpot trả phí, không chạy agent thật trên HubSpot.

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Thuộc danh sách đã duyệt: CÓ.** Context Engineering for Marketing — HubSpot Academy là khóa số 9 trong danh sách 32 khóa Vinmedia đã đọc đủ bằng browser thật tối 20/11 (bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main). muse-main đã ghi rõ vào task file.
- **Khóa học: FREE ở tầng nội dung.** HubSpot Academy là thư viện khóa miễn phí của HubSpot; tài nguyên học (video, quiz, workbook) của các khóa Academy được mở miễn phí — cùng mẫu đã kiểm chứng ở task 146 (Business Automation Course, giá 0 USD).
- **Phần không FREE nếu chạy thật:** các agent AI của HubSpot (Customer Agent, Prospecting Agent…) tính phí theo kết quả từ 14/04/2026 (Customer Agent 0,50 USD/conversation được xử lý xong, Prospecting Agent 1,00 USD/lead) và một số agent chỉ có ở gói Professional/Enterprise; Context Home thì có ở mọi phiên bản. Hệ quả: **chỉ học phương pháp và khung tư duy, không tạo agent thật, không chạy workflow/agent trên HubSpot** — đúng checklist. Giá trị của khóa nằm ở cách chuẩn bị ngữ cảnh (context) cho AI, không nằm ở thao tác trên giao diện HubSpot.
- **Không trùng:** khóa gần nhất là 146 (Business Automation — workflow theo luật: trigger/action) và 148 (agentic RAG — retrieval là tool agent tự gọi). Khóa 151 khác ở tầng **tổ chức ngữ cảnh**: trước khi agent chạy (dù bằng workflow hay vòng lặp ReAct), nó "thấy" được những gì, và ai chịu trách nhiệm chuẩn bị phần "thấy" đó. Ba khóa bổ sung nhau: 146 dạy *quy trình nào đáng tự động hóa*, 148 dạy *agent tìm thông tin ra sao khi chạy*, 151 dạy *chuẩn bị sẵn cho agent cái gì trước khi nó chạy*.

## Ghi chú trung thực về nguồn học

Trang khóa trên HubSpot Academy yêu cầu đăng nhập/trình duyệt nên **không đọc trực tiếp được danh sách bài giảng chi tiết bằng công cụ fetch text** (cùng giới hạn đã gặp ở task 146). Vì vậy báo cáo này học qua các tài liệu công khai chính thức của HubSpot về đúng chủ đề khóa dạy, và ghi rõ nguồn từng phần — **không bịa syllabus từng bài của khóa**:

- Bài viết "Effective context engineering for AI agents" của Anthropic (29/09/2025) — định nghĩa gốc của thuật ngữ, kỹ thuật nền tảng.
- Bài recap session INBOUND 2025 của Dharmesh Shah (đồng sáng lập/CTO HubSpot) trên trang UNBOUND chính thức — khung PART, chuyển từ prompt engineering sang context engineering.
- Slide deck HubSpot Academy Labs "Build Your Loop Foundation: Ideal Customer Profiling & Segmentation" (UNBOUND 2026) — Loop Marketing, ICP, phân khúc, Fit/Intent/Stage, dùng Breeze Assistant.
- Tài liệu về Growth Context / Context Home trong HubSpot (Spring Spotlight 14/04/2026, Fall Spotlight/UNBOUND 16/09/2026) qua các bài phân tích chuyên sâu có đối chiếu nguồn chính thức.
- Bài thực hành "Context Engineering for Marketing and RevOps: The Six Files Your Agent Needs" (martechdevs) — checklist file ngữ cảnh cho marketing.

## 1. Context engineering là gì — định nghĩa gốc (Anthropic, 29/09/2025)

- **Định nghĩa:** context là *tập hợp các token được đưa vào model khi lấy mẫu* (sampling); context engineering là *tập hợp các chiến lược tuyển chọn và duy trì tập token tối ưu (thông tin) trong quá trình suy luận của LLM, bao gồm mọi thông tin khác có thể rơi vào đó ngoài prompt*. Anthropic xem đây là **bước tiến tự nhiên của prompt engineering, không phải thay thế nó**: prompt engineering là cách viết/tổ chức *chỉ dẫn*; context engineering là cách quản lý *toàn bộ trạng thái ngữ cảnh* — chỉ dẫn hệ thống, tools, MCP, dữ liệu ngoài, lịch sử hội thoại.
- **Vì sao cần:** agent chạy theo vòng lặp sinh ra ngày càng nhiều dữ liệu *có thể* liên quan cho lượt suy luận tiếp theo, và thông tin đó phải được tinh lọc theo chu kỳ. Thuật ngữ được Andrej Karpathy nêu bật giữa 2025, Anthropic hệ thống hóa thành bài viết kỹ thuật tháng 9/2025.
- **Ràng buộc cốt lõi — "context rot":** khi số token trong cửa sổ context tăng, khả năng model nhớ chính xác thông tin trong đó **giảm dần** (nghiên cứu needle-in-a-haystack). Đây là gradient hiệu năng, không phải vách đứng — nhưng hệ quả thực hành là rõ: **context là tài nguyên hữu hạn với lợi nhuận biên giảm dần**. Mỗi token mới đều "ăn" một phần ngân sách chú ý (attention budget) của model — transformer cho mọi token chú ý tới mọi token khác (quan hệ từng cặp n²), nên cửa sổ càng dài, các quan hệ càng bị kéo mỏng; model lại ít kinh nghiệm huấn luyện với chuỗi dài.
- **Nguyên tắc chỉ đạo duy nhất:** tìm *tập token có tín hiệu cao nhỏ nhất có thể* mà tối đa hóa khả năng đạt kết quả mong muốn. "Nhỏ nhất" không có nghĩa là "ngắn nhất" — vẫn phải đưa đủ thông tin để agent tuân thủ hành vi kỳ vọng; bắt đầu từ prompt tối thiểu với model tốt nhất, rồi bổ sung chỉ dẫn/ví dụ theo các lỗi gặp khi test.
- **Ba thành phần phải "gọn mà đủ tín hiệu":**
  - *System prompt* ở "độ cao vừa phải": một cực là hard-code logic phức tạp, giòn, khó bảo trì; cực kia là hướng dẫn mơ hồ, không tín hiệu cụ thể hoặc giả định sai về ngữ cảnh chung. Tổ chức prompt thành các mục riêng (XML tag hoặc Markdown heading).
  - *Tools:* tự chứa, chịu lỗi, mô tả rõ mục đích dùng; lỗi kinh điển là bộ tool phình to, chức năng chồng lấn, khiến agent không biết chọn tool nào — nếu người cũng không trả lời dứt khoát được "dùng tool nào", agent cũng không.
  - *Ví dụ (few-shot):* không nhồi danh sách dài các edge case vào prompt; tuyển một tập ví dụ đa dạng, chuẩn (canonical) thể hiện đúng hành vi kỳ vọng — "một bức tranh đáng giá nghìn chữ".
- **Truy xuất "just in time" thay vì nạp trước tất cả:** thay vì tiền xử lý mọi dữ liệu liên quan trước suy luận, agent giữ *định danh nhẹ* (đường dẫn file, truy vấn đã lưu, link web…) rồi dùng tool để nạp dữ liệu vào context đúng lúc cần. Kèm cơ chế *progressive disclosure* — khám phá tăng dần: kích thước file, quy ước đặt tên, timestamp đều là tín hiệu giúp agent hiểu nên dùng thông tin nào, khi nào. Đánh đổi: khám phá lúc chạy chậm hơn nạp sẵn, và cần thiết kế tool + heuristic tốt, nếu không agent sẽ phí context đi vào ngõ cụt. Chiến lược lai thường tốt nhất: nạp trước một phần (vd file `CLAUDE.md`), còn lại để agent tự tìm bằng glob/grep.
- **Ba đòn bẩy cho task dài (vượt một cửa sổ context):** (1) *compaction* — tóm tắt cửa sổ sắp đầy rồi mở cửa sổ mới với bản tóm tắt (giữ quyết định kiến trúc, bug chưa xử lý; bỏ output tool thừa; nghệ thuật nằm ở chọn giữ gì/bỏ gì — nén quá tay mất ngữ cảnh tinh tế chỉ lộ tầm quan trọng về sau); (2) *structured note-taking* — agent tự ghi chú có cấu trúc ra ngoài cửa sổ context (vd file NOTES.md, to-do list) rồi đọc lại sau mỗi lần reset; (3) *sub-agent* — chia việc cho agent con với cửa sổ context sạch, mỗi agent con khám phá hàng chục nghìn token nhưng chỉ trả về bản tóm tắt 1.000–2.000 token cho agent chính. Chọn đòn bẩy theo tính chất task: compaction giữ dòng hội thoại, note-taking hợp task lặp có mốc rõ, multi-agent hợp nghiên cứu phức tạp cần khám phá song song.

## 2. Góc HubSpot: từ prompt engineering sang context engineering (Dharmesh Shah, INBOUND 2025)

- **Khung PART** — bốn thứ quyết định nội dung đưa vào cửa sổ context của AI: **P**rompt (câu hỏi/câu lệnh), **A**rchive (lưu trữ — dữ liệu quá khứ, lịch sử), **R**esources (tài nguyên — tài liệu, kiến thức tham chiếu), **T**ools (công cụ — những gì AI được phép dùng). Thông điệp của Shah: không chỉ là *cách đặt câu hỏi*, mà là *cho model ăn cái gì*.
- **Quy tắc 60/30/10** cho thời gian dùng AI: 60% cho use case lặp lại được, 30% lặp lại và cải thiện prompt, 10% thử cái mới. Và thái độ "This doesn't work. Yet." — cái hôm nay chưa chạy được có thể chạy tốt sau một bản cập nhật model; đặt nhắc lịch thử lại các thử nghiệm AI đã thất bại sau vài tháng.
- **Chiến lược TEAM cho đội dùng AI:** Triage (ưu tiên use case theo tần suất, tác động, rủi ro thất bại thấp) → Experiment (test, đừng đoán) → Automate (cái gì chạy được thì biến thành workflow/agent lặp lại) → Measure (đo kết quả thật). "AI should not be a performance art… It should be performance driven."
- **Điểm nối với khóa 144 (Work smarter with AI):** cùng nguyên tắc "AI hỗ trợ, con người quyết định" — Shah: "Use AI to test your thinking, use it to clarify your thinking, and elevate your thinking, but don't use it to replace your thinking."

## 3. Growth Context — ngữ cảnh là "hệ thống", không phải một prompt (HubSpot 2026)

- **Định nghĩa của HubSpot:** Growth Context là *hiểu biết cụ thể, động về doanh nghiệp, khách hàng và đội ngũ* mà AI của HubSpot làm việc dựa trên. CPO/CTO Duncan Lennox (Spring Spotlight 14/04/2026): "Most AI tools have access to data. What they don't have is context." CEO Yamini Rangan (UNBOUND 2026): "AI with bad context is worse than no AI."
- **Data khác context ở chỗ nào:** data là *chuyện gì đã xảy ra* (một deal đã chốt, một email đã gửi); context là *vì sao xảy ra, có nghĩa gì, và nên làm gì tiếp* (deal chốt vì champion đổi công ty, giá đã điều chỉnh ba lần, khách đó giới thiệu nhiều deal mới và ghét bị liên hệ bằng automation). Khảo sát 6.000 khách hàng của HubSpot: 90% dùng AI, chỉ 6% báo cáo kết quả mang tính chuyển đổi — nhóm 6% này có khả năng đạt mục tiêu doanh thu cao gấp 4 lần; khác biệt nằm ở context, không phải ở model.
- **Năm chiều của Growth Context** (Lennox chia thành business, team, process, customer và network context; các trang sản phẩm Fall 2026 gom gọn thành 3 tầng business/team/customer):

| Chiều | Nội dung | Ví dụ marketing |
|---|---|---|
| Business | Định vị, khác biệt, lý do định giá, giọng thương hiệu | AI viết đúng giọng *công ty mình*, không phải giọng chung chung |
| Team | Phương pháp bán hàng, tiêu chí đủ điều kiện, đường leo thang | AI tuân thủ quy trình đội, không chỉ làm theo kịch bản |
| Process | Workflow, trigger bàn giao, cấu trúc chiến dịch, chỉ số thành công | AI *hành động được*, không chỉ cung cấp thông tin |
| Customer | Lịch sử quan hệ, mục tiêu, điểm ma sát, ICP, tín hiệu mua | AI biết khách này là ai, đang ở đâu trong hành trình |
| Network | Hệ sinh thái, đối tác, tích hợp, bối cảnh thị trường | AI hiểu sản phẩm nằm trong hệ nào, cạnh tranh với ai |

- **Context Home (trong Agent Hub, tab Context, có ở mọi phiên bản):** nơi duy nhất xem/sửa những gì HubSpot biết về doanh nghiệp — Business (brand kit, hồ sơ, sản phẩm/dịch vụ), Customers (ICP, persona), Team & Processes (phương pháp bán hàng), Personal (hồ sơ người dùng, tính cách email), Custom context, và Knowledge vaults. Context Home chấm điểm mức độ đầy đủ của context và chỉ ra chỗ thiếu. Lưu ý quan trọng (từ bài phân tích của Learners.ai): điểm này đo *sự hiện diện*, không đo *sự đúng đắn* — một trường đã điền vẫn có thể chứa thông tin lỗi thời hoặc mâu thuẫn.
- **Knowledge vaults (khác context):** context áp dụng tự động cho mọi công cụ AI trong portal; vault là tập file/nội dung gắn riêng cho một project hoặc agent cụ thể (PDF, DOCX, PPTX, XLSX, CSV, JSON, Markdown; bài KB, trang, cuộc gọi, segment; tối đa 50 vault, 50 MB/file, 4 mức truy cập). Đây chính là cơ chế "just in time" ở tầng sản phẩm: đừng đổ cả kho tài liệu vào context chung, gắn đúng vault cho đúng agent/task.
- **Agent Hub + Aviator:** Agent Hub (public beta từ 07/2026, thay Breeze Studio) là một nhà chung cho agent do HubSpot xây và agent tự tạo, có hộp thư agent, chi phí từng lượt chạy, lịch sử chạy, giới hạn lượt/tháng. Aviator là "harness" agent mới của HubSpot (phần mềm chạy model theo vòng lặp, thực thi tool call, đưa kết quả trở lại) — HubSpot quản lý runtime, nhưng đội vẫn phải chuẩn bị và quản trị context nạp cho từng task. Các agent có sẵn: Customer Agent, Prospecting Agent, Data Agent, Revenue Agent, Knowledge Base, Campaign, Content, Nurture Agent.

## 4. Loop Marketing: ngữ cảnh của marketer là ICP + phân khúc (Academy Labs, UNBOUND 2026)

Đây là phần thực hành gần nhất với "Context Engineering for Marketing" trong tài liệu công khai của HubSpot Academy — khóa lab dạy đúng hai thách thức mà context engineering giải quyết cho marketer:

- **Thách thức 1 — Targeting (không biết nên tiếp cận ai):** chìm trong dữ liệu nhưng vẫn thiếu rõ ràng; đoán thay vì biết; chi tiền cho những contact không bao giờ chuyển đổi.
- **Thách thức 2 — Context (AI không biết đủ để viết cho đúng người):** "AI scales what it knows" — đầu vào chung chung thì đầu ra chung chung ("AI slop"). Trạng thái cần đến: targeting dựa trên dữ liệu; nội dung AI tạo ra cộng hưởng và có giá trị vì nó biết viết cho ai.
- **Bốn giai đoạn Loop Marketing** (thay phễu tuyến tính Awareness → Consideration → Conversion): **Express** (thể hiện mình là ai) → **Tailor** (may đo thông điệp) → **Amplify** (khuếch đại qua kênh) → **Evolve** (tiến hóa theo thời gian thực). Ngữ cảnh sống ở hai giai đoạn đầu: Express là nền tảng — AI viết nhanh, nhưng không có giọng, context và quan điểm rõ ràng thì output nhạt; Tailor là hành động — thông điệp phải *cá nhân* (personal), không chỉ *cá nhân hóa* (personalized), tức là phải biết chính xác đang nói với ai.
- **ICP (Ideal Customer Profile):** mô tả công ty phù hợp nhất với sản phẩm/dịch vụ — trả lời "nên nhắm tổ chức nào?" bằng firmographics (ngành, quy mô, doanh thu, tech stack, giai đoạn tăng trưởng), buying committee và quan sát định tính. Nguyên tắc xây ICP trong lab: bắt đầu từ *khách hàng tốt nhất thật sự có*, không phải khách hàng mơ ước; tìm pattern trong firmographics và hành vi; ghi cả *chỉ báo phủ định* (ai trông hợp nhưng thực ra không hợp); mỗi đặc điểm phải ánh xạ được tới thứ nhận diện được trong CRM. Dùng Breeze Assistant để dựng tài liệu ICP từ dữ liệu khách tốt nhất (bài thực hành 35 phút).
- **Segment:** lát cắt audience có thể gom nhóm và nhắm tới, xây từ dữ liệu thật — trả lời "contact nào nên nhận thông điệp này ngay bây giờ?" bằng tín hiệu hành vi, thuộc tính CRM, enrichment, fit, intent, stage. ICP là input chính cho giai đoạn Express; segment là động cơ của giai đoạn Tailor.
- **Ba tín hiệu Fit / Intent / Stage** (cách biến ICP thành segment chạy được):
  - *Fit là bộ lọc:* người/công ty này khớp ICP đến đâu (firmographics, nhân khẩu, vai trò, quy mô, ngành).
  - *Intent là trigger:* người này đang chủ động phát tín hiệu "đang muốn mua" đến đâu (xem trang giá, trả lời email, tải nội dung, nghiên cứu đối thủ, đăng tuyển).
  - *Stage là kịch bản:* người này đang ở đâu trong hành trình mua (awareness / consideration / decision — hoặc lifecycle: Subscriber → Lead → MQL → SQL → Opportunity → Customer → Evangelist), để biết nên giúp gì ngay lúc này.
  - Segment tốt phải đủ cả ba: *đủ chính xác để cá nhân hóa, đủ lớn để thực thi, đủ rõ để quyết định tự tin*.
- **Thực hành trong lab (không chạy thật theo checklist):** dùng Breeze Assistant sinh 2 concept chiến dịch theo ICP (10 phút); enrich dữ liệu firmographic rồi dựng segment theo tiêu chí fit của ICP (15 phút); thêm lớp stage bằng segment contact gắn với segment company (15 phút). Đầu ra là một ICP document tái dùng được — chính là *file context* để brief cho mọi công cụ AI sau này.

## 5. Thực hành: sáu file ngữ cảnh cho agent marketing (martechdevs)

Bài thực hành của giới martech đúc kết context engineering cho marketing/RevOps thành **sáu file mẫu** mà agent cần trước khi làm việc — khớp sát với Growth Context của HubSpot ở §3, nhưng ở dạng file văn bản mà team nào cũng làm được ngay, không cần HubSpot:

- Định nghĩa chỉ số (metric definitions — vd "MQL" nghĩa chính xác là gì, tính ra sao),
- Quy tắc đặt tên (naming rules),
- ICP,
- Playbook (quy trình làm việc chuẩn),
- Tuyên bố thương hiệu (brand claims — những gì được phép/không được phép nói về sản phẩm),
- (và các file hỗ trợ khác theo mẫu của bài viết).

Nguyên tắc kiểm chứng đi kèm: copy mẫu file rồi **test** xem agent dùng chúng ra sao — context không test thì chỉ là tài liệu chết. Ba nguyên tắc vận hành từ Learners.ai bổ sung cho bộ file này: (1) *context liên quan thắng context thừa* — token thừa không chỉ tốn tiền mà còn làm lệch phân phối (đã từng có trường hợp lưu cả transcript họp 10.000–15.000 token làm một object, retrieval kéo hàng nghìn token vào chỉ để dùng vài trăm ký tự, kết quả chậm hơn, đắt hơn và tệ hơn); (2) *ngữ nghĩa nằm trong metadata* — agent hiểu field qua mô tả của nó: một khảo sát thực tế trên 600+ custom property cho thấy ~78% field chỉ được điền ở ≤1% bản ghi, hơn 4/5 thiếu mô tả, hơn 150 dropdown không giải thích ý nghĩa option — với nhân viên thì quen tay vẫn dùng được, với agent thì field "Type (old)" không nói được rằng nó đã bị bỏ từ nhiều năm trước; (3) *mọi sự thật đều có hạn sử dụng* — sự thật không có ngày xác minh là một khoản nợ, vì agent không phân biệt được chính sách hiện tại với chính sách năm ngoái.

## 6. Đối chiếu với mạch đã học (127 / 130 / 148) — context engineering là lớp tổ chức

| Khóa | Vai trong "ngữ cảnh" | Câu hỏi trả lời |
|---|---|---|
| 127 Long-Term Agentic Memory (LangGraph + LangMem) | **Lưu trữ dài hạn:** ba loại memory (semantic / episodic / procedural) + hai cơ chế hình thành (hot path / background) | Lưu cái gì, lưu khi nào, để dùng qua nhiều phiên |
| 130 LLMs as Operating Systems: Agent Memory (Letta/MemGPT) | **Quản lý cửa sổ context:** ai quyết định cái gì được ở trong cửa sổ hữu hạn tại mỗi thời điểm; core vs archival memory, memory blocks | Cái gì ở trong context *lúc này*, cái gì nằm ngoài chờ gọi |
| 148 AI Agents Course (Hugging Face) | **Truy xuất lúc chạy:** retrieval là tool agent tự quyết gọi; vòng lặp Thought → Action → Observation | Agent tự tìm thông tin ra sao khi đang chạy |
| **151 Context Engineering for Marketing (HubSpot)** | **Tổ chức toàn bộ:** chuẩn bị trước + tuyển chọn lúc chạy + duy trì qua thời gian, cho một miền cụ thể (marketing) | Cho agent "thấy" những gì, từ đâu, theo thứ tự nào, và ai chịu trách nhiệm cập nhật |

- **Cùng một bài toán, bốn tầng:** 127 trả lời *bộ nhớ sống ở đâu và theo vòng đời nào*; 130 trả lời *cửa sổ context được quản lý ra sao trong lúc chạy*; 148 trả lời *agent tự lấy thêm thông tin bằng cách nào*; 151 trả lời *nội dung miền (marketing) nào đáng đưa vào ba tầng kia, và ai là chủ sở hữu của từng phần*. Không có 151, ba khóa kia vẫn chạy được về kỹ thuật — nhưng agent sẽ chạy trên context chung chung, đúng kiểu "AI slop" mà lab của HubSpot mô tả.
- **Ánh xạ trực tiếp khái niệm Anthropic ↔ HubSpot:** system prompt "độ cao vừa phải" ↔ hướng dẫn agent trong Context Home + từng Agent Builder; tool tự chứa, không chồng lấn ↔ agent một "product lane" mỗi con, không ôm đồm; just-in-time retrieval ↔ knowledge vault gắn theo project/agent thay vì đổ cả kho vào context chung; compaction/note-taking ↔ agent ghi chú tiến độ và tóm tắt lịch sử quan hệ khách hàng trong CRM thay vì giữ toàn bộ log; sub-agent ↔ tách agent chuyên biệt (Customer / Prospecting / Content / Campaign) thay vì một agent làm tất cả.
- **Điểm khác biệt của góc marketing:** trong kỹ thuật, context là token; trong marketing, context là *quyết định kinh doanh đã được viết ra* (ICP nào, persona nào, chỉ số nào, tuyên bố nào được phép nói). Vì vậy chủ sở hữu context không phải kỹ sư mà là người làm marketing/sales: marketing giữ brand + positioning, sales leadership giữ ICP + phương pháp luận. Đây là điểm khóa 151 bổ sung mà 127/130/148 không có: **quản trị context là việc của tổ chức, không phải việc của code**.

## 7. Đề xuất áp dụng (có điều kiện, chưa làm ngay)

1. **Cho team 3 Muse (rẻ nhất, áp dụng được ngay nếu chị Bẹp duyệt):** team đã vô tình làm đúng context engineering — `PROTOCOL.md` là system prompt đứng, file task JSON là context của từng task, shared skill `vbook-extension-building/SKILL.md` là standing context (đúng nghĩa "knowledge vault" gắn theo loại task), và mỗi worker chỉ đọc đúng file mình cần. Đề xuất ghi lại thành quy tắc rõ trong PROTOCOL §9 hoặc skill: *trước khi giao task mới, kiểm tra xem worker đã có đủ context đứng chưa (skill mới nhất, task file đầy đủ) thay vì nhồi thêm vào notes* — notes càng dài, worker càng dễ "context rot" (đọc nhiều mà nhớ sai). Đây là bài học trực tiếp từ nguyên tắc "tập token tín hiệu cao nhỏ nhất" của Anthropic.
2. **Cho Anh, ở dạng file mẫu (không tự làm, chỉ gợi ý):** một "context file" cho mỗi lần nhờ AI viết nội dung công việc (vd báo cáo ca, email, tài liệu audit FSSC): gồm 5 mục theo khung PART của Shah — Prompt (muốn AI làm gì), Archive (dữ liệu/số liệu quá khứ liên quan), Resources (SOP, biểu mẫu, tài liệu tham chiếu), Tools (AI được dùng công cụ nào, giới hạn ra sao) — cộng thêm ICP của người đọc (ai đọc, họ cần quyết gì). Viết một lần, dùng lại nhiều lần; mỗi lần AI trả ra chung chung thì sửa file context, không sửa từng câu prompt.
3. **Không đề xuất** tạo tài khoản HubSpot, mua gói Professional/Enterprise, hay chạy agent HubSpot thật: ngoài phạm vi FREE và ngoài nhu cầu hiện tại của team. Cũng không đề xuất team cài Letta/LangMem hay dựng "private business brain" — khái niệm đã học đủ ở 127/130, chưa có bài toán thật cần tới.

## Nguồn

- Danh sách 32 khóa đã duyệt, khóa số 9 (bằng chứng đầy đủ): `research/140-governing-ai-agents-deeplearning-ai.md` trên main — Context Engineering for Marketing, HubSpot Academy.
- Anthropic — "Effective context engineering for AI agents" (29/09/2025, cập nhật 18/10/2026): https://www.anthropic.com/research/effective-context-engineering-for-ai-agents
- HubSpot UNBOUND — Dharmesh Shah, "You to the Power of AI" (INBOUND 2025; khung PART, quy tắc 60/30/10, chiến lược TEAM): https://unbound.hubspot.com/blog/you-to-the-power-of-ai-dharmesh-shah-on-building-a-human-centered-ai-future
- HubSpot Academy Labs — "Build Your Loop Foundation: Ideal Customer Profiling & Segmentation" (UNBOUND 2026, slide deck PDF chính thức): https://academy.hubspot.com/hubfs/(Academy)/Slides_Build%20Your%20Loop%20Foundation_%20Ideal%20Customer%20Profiling%20%26%20Segmentation%20%5BUNBOUND%5D%20(2).pdf
- Learners.ai — "HubSpot Context Engineering: Agent Hub & Private Brains" (Growth Context 5 chiều, Context Home, knowledge vaults, 4 lớp context, khảo sát 650+ API read): https://www.learners.ai/blog/hubspot-context-engineering-private-brains-agent-hub-and-the-agents-that-run-on-them
- Vantage Point — "The Context Advantage: HubSpot Spring 2026 and CRM Data for AI" (Spotlight 14/04/2026, "data vs context", số liệu 2x/70%/4.4x): https://vantagepoint.io/blog/hs/context-advantage-hubspot-spring-2026-crm-data-ai
- HarvestROI — "HubSpot AI Deep Dive: Growth Context and Context Home" (UNBOUND 2026, 3 tầng context, 3.6x MQL / 3.2x deals): https://www.harvestroi.com/growth-blog/unbound26-deep-dive-context
- Campaign Creators — "What Is HubSpot Growth Context, and How Do You Improve Your Context Score?" (5 chiều, Context Home theo tab, context vs knowledge vault): https://www.campaigncreators.com/blog/hubspot-growth-context
- MartechDevs — "Context Engineering for Marketing and RevOps: The Six Files Your Agent Needs" (sáu file mẫu: metric definitions, naming rules, ICP, playbooks, brand claims): https://www.martechdevs.com/blog/martech-ai
- Trang Vinmedia (mục Thư viện miễn phí, thẻ khóa render bằng JS nên text fetch không đọc được tên khóa — đã ghi nhận ở task 140, không dùng làm nguồn nội dung khóa): https://vinmediaglobal.com/khoa-hoc-ai-marketing-thuc-chien/

*Ghi chú trung thực: trang khóa trên HubSpot Academy yêu cầu đăng nhập/trình duyệt nên không đọc trực tiếp được syllabus từng bài bằng công cụ fetch text (cùng giới hạn đã gặp ở task 146). Nội dung khóa được học qua định nghĩa gốc của Anthropic + khung PART của Dharmesh Shah + slide deck Academy Labs chính thức + tài liệu Growth Context/Context Home của HubSpot. Không đăng ký tài khoản, không chạy agent/workflow thật, không lấy chứng chỉ — đúng quy tắc tự học §9.*
