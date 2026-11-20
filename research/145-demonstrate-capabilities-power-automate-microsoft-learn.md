# Demonstrate the capabilities of Power Automate (Microsoft Learn) — Báo cáo tự học (task 145)

- **Khóa học:** Demonstrate the capabilities of Microsoft Power Automate, Microsoft Learn (learning path thuộc PL-900, Microsoft Power Platform Fundamentals)
- **Trang khóa:** https://learn.microsoft.com/en-us/training/paths/demonstrate-capabilities-microsoft-power-automate/
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE công khai; **không đăng ký trả phí/chứng chỉ, không chạy lab/API tốn phí, không đăng nhập tài khoản Microsoft để làm quiz cuối module** (theo checklist task 145 + quy tắc tự học §9). Không tạo flow thật — chỉ đọc tài liệu, chưa có tài khoản/license Power Automate để thực hành (xem §7.3).

## 0. Kiểm chứng khóa có trong danh sách 32 khóa đã duyệt — ĐẠT

Khóa này là **số 16 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11). Bằng chứng đầy đủ: Ú đã đọc đủ 32 tên bằng browser thật 20/11 21:57, ghi trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main — "16. Demonstrate the capabilities of Power Automate — Microsoft Learn". Theo chỉ dẫn task 145, **không kiểm chứng lại từ đầu**; bản này chỉ đối chiếu lại tên khóa với danh sách đó.

| Hạng mục | Số liệu đã kiểm chứng (20/11/2026) |
|---|---|
| Đối tượng | Business user / maker (người dùng văn phòng, chủ doanh nghiệp, sinh viên), **không cần nền tảng kỹ thuật, không cần biết code** (low-code) |
| Quy mô | **Learning path 2 module, 21 units, 2 giờ 21 phút** — Module 1 "Identify Microsoft Power Automate components" 1 giờ 10 phút (10 units), Module 2 "Build a Microsoft Power Automate flow" 1 giờ 11 phút (11 units) |
| Trình độ | Beginner, không yêu cầu kiến thức trước (Prerequisites: None) |
| FREE? | ✅ Toàn bộ nội dung learning path đọc miễn phí, không cần đăng nhập. **Nhưng để thực hành tạo flow thật thì cần tài khoản + license Power Automate** (xem §4.3 và §7.3 — ranh giới quan trọng của khóa này) |
| Chứng chỉ | Là một phần của PL-900 (Microsoft Power Platform Fundamentals) — **không đăng ký thi/chứng chỉ** theo §9 |
| Ngôn ngữ | Tiếng Anh (Copilot trong Power Automate tối ưu cho tiếng Anh, hỗ trợ hạn chế ngôn ngữ khác) |

**Không trùng:** khóa gần nhất là 144 Work smarter with AI (dùng AI hỗ trợ từng tác vụ trong ngày làm việc). 145 là bước tiếp theo đúng như 144 §9 gợi ý: từ *"dùng AI hỗ trợ việc"* sang *"tự động hóa việc"* — biến tác vụ lặp lại thành flow chạy tự động, không cần bấm tay từng lần. 142 (AI For Everyone) dạy *chọn dự án AI nào*; 144 dạy *dùng AI hàng ngày ra sao*; 145 dạy *để máy tự chạy việc lặp lại như thế nào*. Ba khóa xếp thành một chuỗi, không trùng nhau.

## 1. Power Automate là gì — cloud flow vs desktop flow

- **Power Automate** là dịch vụ workflow online của Microsoft: tự động hóa tác vụ lặp lại trên các app/dịch vụ phổ biến, **không cần viết code** (low-code). Người làm flow (maker) mô tả "khi X xảy ra thì làm Y", hệ thống chạy thay.
- **Cloud flow** — chạy trên cloud, nối các dịch vụ qua connector (Outlook, SharePoint, Teams, Forms...). Có 3 loại, phân biệt bằng cách flow bắt đầu:
  - **Automated cloud flow:** chạy khi một *sự kiện* xảy ra (vd: có email mới từ một người, có item mới trong SharePoint list).
  - **Instant cloud flow:** chạy khi người dùng *bấm nút* hoặc kích hoạt thủ công (vd: gửi nhắc nhở cho team, bắt đầu một phê duyệt từ Teams/SharePoint).
  - **Scheduled cloud flow:** chạy theo *lịch* (vd: mỗi ngày tải dữ liệu lên SharePoint, gửi báo cáo hàng tháng). Dùng trigger Recurrence.
  - Nếu dùng Copilot để tạo flow thì không cần tự chọn loại — Copilot suy ra loại từ mô tả của bạn.
- **Desktop flow** — RPA (Robotic Process Automation) chạy trên máy Windows: tự động hóa thao tác với *ứng dụng đã cài đặt, hệ thống legacy, giao diện không có API* — những chỗ cloud flow không chạm tới được.
- **Kết hợp cloud + desktop thành giải pháp end-to-end:** cloud flow xử lý phần online (nhận email, phê duyệt, ghi dữ liệu), desktop flow xử lý phần trên máy (mở phần mềm cũ, nhập liệu) — nối cloud với môi trường on-premises.
- **Quy tắc chọn loại flow (quyết định đầu tiên khi làm automation):** hỏi "flow bắt đầu bằng gì?" — sự kiện → automated; nút bấm → instant; giờ giấc → scheduled; thao tác trên máy tính, app không có API → desktop flow. Chọn sai loại thì flow không chạy được đúng lúc, dù các bước sau có đúng.

## 2. Use cases với Microsoft 365 — approvals, Teams, Outlook, SharePoint, Forms, AI Builder

- **Approvals (phê duyệt) — use case quan trọng nhất của module:** action chính là **Start and wait for an approval** — gửi yêu cầu phê duyệt cho một hoặc nhiều người, flow *dừng lại chờ trả lời* rồi mới chạy tiếp. Trong action này chọn 1 trong **4 loại phê duyệt**:
  - **Approve/Reject – Everyone must approve:** tất cả người phê duyệt phải đồng ý; chỉ một người reject là yêu cầu bị từ chối. Dùng cho duyệt tuân thủ, ký tài liệu pháp lý — nơi cần đồng thuận tuyệt đối.
  - **Approve/Reject – First to respond:** người đầu tiên trả lời quyết định kết quả. Dùng khi cần nhanh và bất kỳ ai trong nhóm cũng đủ thẩm quyền.
  - **Custom Responses – Wait for all responses:** tự định nghĩa nút trả lời (vd: Approve / Needs revision / Escalate), tất cả phải trả lời.
  - **Custom Responses – Wait for one response:** nút tự định nghĩa, một trả lời là đủ.
  - Lưu ý: tài liệu Microsoft hiện còn ghi thêm **Sequential approval** (duyệt lần lượt từng người theo thứ tự — quản lý rồi mới tới tài chính) như một loại thứ 5, ngoài phạm vi 4 loại của module. Khi làm flow thật nên kiểm tra danh sách hiện tại trên portal, đừng học thuộc mỗi 4 loại.
- **Teams:** flow đăng thông báo vào channel, quản lý phê duyệt qua Adaptive Cards, tạo channel tự động.
- **Outlook:** trigger từ email đến, gửi thông báo tự động, trả lời phê duyệt ngay trong email (không cần mở Power Automate).
- **SharePoint:** phê duyệt item mới trong list, quản lý vòng đời tài liệu, thông báo khi list thay đổi, bảo trì theo lịch.
- **Forms:** câu trả lời form tự động chảy sang hệ thống downstream (vd: form báo cáo → ghi vào SharePoint list → gửi email tóm tắt).
- **AI Builder — document automation:** trích dữ liệu có cấu trúc từ PDF và tài liệu khác mà không cần nhập tay (vd: đọc số liệu từ biên bản scan).
- **Flow templates:** điểm khởi đầu cho kịch bản phổ biến — không cần làm từ con số 0, chọn template gần nhất rồi sửa lại.

## 3. Trigger và action — giải phẫu một cloud flow

- **Trigger = sự kiện bắt đầu flow.** 3 loại cơ bản: automated (sự kiện trong dịch vụ đã nối), scheduled (theo lịch recurrence), instant (kích hoạt thủ công). Có thể đặt **trigger filters** để flow chỉ chạy với những sự kiện thỏa điều kiện (vd: chỉ email từ một người cụ thể) — tránh flow chạy vô ích hàng trăm lần.
- **Action = việc flow làm sau khi trigger chạy.** Các nhóm action trong module:
  - **Connector-specific:** tương tác với dịch vụ ngoài (gửi email Outlook, đăng Teams, ghi SharePoint).
  - **Approval:** các action phê duyệt (§2).
  - **Control:** làm flow "thông minh" — Condition (rẽ nhánh if/else), Switch (rẽ nhiều nhánh), Apply to each (lặp qua từng mục trong danh sách), Do until (lặp tới khi đạt điều kiện), parallel branch (chạy song song nhiều nhánh để giảm tổng thời gian).
  - **Data operations:** thao tác dữ liệu trong flow (ghép, lọc, biến đổi).
  - **AI Builder:** thêm khả năng machine learning (đọc tài liệu, nhận diện).
  - **HTTP:** gọi dịch vụ ngoài thư viện connector có sẵn.
- **Giải phẫu flow trong designer:** trigger → các action nối tiếp → **dynamic content** (nút tia sét ⚡ để chèn dữ liệu từ bước trước, vd: chèn "Tweeted by" và "Tweet text" vào email) → **expressions** (hàm tính toán) → **connections** (tài khoản đã nối tới từng dịch vụ, tick xanh = hợp lệ, dấu chấm than đỏ = cần sửa).
- **Ví dụ xuyên suốt tài liệu Microsoft (đọc đủ, chưa chạy thật):** "khi có tweet mới chứa từ khóa thì gửi email" — trigger *When a new tweet is posted* (X), action *Get user* + *Send an email (V2)* (Outlook). Cách tạo không dùng Copilot: Sign in → My flows → Create from blank → chọn trigger → dấu **+** sau trigger → tìm action → điền tham số → Save. Cách tạo bằng Copilot: xem §4.

## 4. Copilot trong Power Automate — tạo flow bằng ngôn ngữ tự nhiên

- **Cloud flow bằng Copilot:** mô tả việc cần tự động hóa bằng ngôn ngữ tự nhiên ("when a new tweet is posted, send an email to...") → Copilot đề xuất cấu trúc trigger + actions → chưa ưng thì mô tả thêm để Copilot tạo lại → ưng thì **Keep it and continue** → kiểm tra connection (tick xanh = hợp lệ) → **Create flow** → designer mở ra kèm Copilot pane bên phải để hỏi/sửa tiếp ("What does my flow do?", sửa action, nhờ gợi ý mô tả cho flow).
- **Desktop flow bằng Copilot:** Copilot tạo chuỗi action từ mô tả text; **Record with Copilot** (AI Recorder) quay màn hình + nghe thuyết minh bằng giọng nói rồi tự sinh action cho desktop flow. Task trình duyệt/UI thì Copilot chỉ tạo được placeholder — phải hoàn thiện bằng recorder chuẩn hoặc viết action UI bằng tay, rồi test lại.
- **Copilot còn làm được:** mô tả một flow đã có (hỏi "flow này làm gì?" để hiểu flow người khác bàn giao), gợi ý sửa flow, trả lời câu hỏi về sản phẩm.
- **Giới hạn và điều kiện đã kiểm chứng — phần này quan trọng hơn phần tính năng:**
  - Cần **tài khoản cơ quan/trường học**; Copilot **không chạy với tài khoản cá nhân** (vd: outlook.com).
  - Cần **license có Power Automate** (license Power Automate độc lập, gói Microsoft 365 có Power Automate, hoặc license Power Apps/Dynamics 365). **Không cần add-on Copilot riêng.**
  - Chỉ chạy trong **new designer**, không chạy trong classic designer.
  - Tối ưu cho **tiếng Anh**, hỗ trợ hạn chế ngôn ngữ khác; chạy trên Azure OpenAI Service.
  - **License do connector quyết định, không do cách tạo flow quyết định:** flow chỉ dùng connector chuẩn (Outlook, SharePoint, Teams) chạy trên license chuẩn; flow dùng premium connector (HTTP, Dataverse) cần license Premium — dù flow đó do Copilot tạo hay tạo tay cũng vậy.
  - **Copilot là công cụ soạn nháp, không phải người chịu trách nhiệm:** flow nó tạo chạy bằng connection và quyền của chính bạn — phải xem lại như xem flow đồng nghiệp viết rồi mới bật (nối 144 §5: Ask–review–verify–decide–act).

## 5. Quy trình build – test – monitor – share (module 2)

- **Tạo flow (build):** chọn trigger (instant/automated/scheduled) hoặc mô tả cho Copilot; **bài tập của module:** tạo cloud flow bằng Copilot để *lấy dữ liệu thời tiết và gửi thông báo* — tức flow mẫu nối một nguồn dữ liệu bên ngoài với một kênh thông báo, đúng khuôn mẫu của mọi flow thực tế sau này.
- **Test:** hai công cụ module nêu tên — **Flow checker** (quét lỗi tĩnh trong flow trước khi chạy) và **static result configurations** (cấu hình kết quả tĩnh để test mà không cần chạy thật). Ngoài ra cách test cơ bản nhất: sau khi Save, **gây ra trigger thật** (vd: đăng tweet chứa từ khóa đã chọn) rồi chờ ~1 phút xem email thông báo có tới không.
- **Run & monitor:** vào flow → Details → **28-day run history** — xem từng lần chạy, bấm vào một lần chạy để xem input/output từng bước (chỗ này là nơi duy nhất biết flow hỏng ở bước nào). **Analytics + process mining** để tối ưu: process mining phân tích log sự kiện để vẽ ra quy trình *thực tế đang chạy* (khác quy trình trên giấy), tìm nút thắt rồi sửa flow.
- **Quản lý (manage):** tối đa **600 flow/tài khoản**; trong My flows → ⋮ → Turn off (tạm dừng), Turn on (chạy lại), Edit, Delete, xem run history.
- **Share — 3 cách, chọn theo mức tin tưởng:**
  - **Thêm co-owner:** người khác cùng sở hữu, cùng sửa flow.
  - **Run-only permissions:** người khác chỉ được *chạy* flow, không sửa — dùng cho flow bấm nút (instant) chia cho cả team.
  - **Gửi bản copy:** người nhận có một flow riêng, tự chịu trách nhiệm.
  - Lưu ý license khi share: flow chạy kiểu run-only thì chạy trong context của *người kích hoạt*; nếu flow dùng premium connector thì người chạy cũng cần license tương ứng — share flow không miễn license cho người chạy.
- **Describe flow bằng Copilot:** hỏi Copilot tóm tắt flow có sẵn — hữu ích khi nhận bàn giao flow người khác làm, hoặc khi quay lại flow mình làm từ lâu.

## 6. So sánh với các khóa đã học + nối tiếp 144

| Khía cạnh | 142 AI For Everyone (Ng) | 144 Work smarter with AI (Microsoft) | 145 Power Automate (Microsoft) |
|---|---|---|---|
| Đối tượng | Quản lý/doanh nghiệp, phi kỹ thuật | Người dùng văn phòng, phi kỹ thuật | Business user / maker, phi kỹ thuật, low-code |
| Thời lượng | 7 giờ, 4 module | 42 phút, 1 module | 2 giờ 21 phút, 2 module |
| AI dạy | ML cổ điển: A→B, học có giám sát | GenAI + Copilot + agent trong công việc | **Tự động hóa bằng flow; Copilot chỉ là công cụ tạo flow** |
| Trọng tâm | Chọn dự án AI, tổ chức, dữ liệu | Dùng AI hàng ngày: tóm tắt, soạn thảo, grounding, agent, kiểm chứng | Trigger → action → test → monitor → share; phê duyệt, RPA desktop |
| Quy tắc nhớ | Quy tắc 1 giây; giao nhau 3 vòng | Grounding; khung Ask–review–verify–decide–act | **"Flow bắt đầu bằng gì?" (chọn loại trigger); human-in-the-loop qua approval** |
| Hạn chế | Ra đời trước làn sóng LLM; 2 khẳng định đã lỗi thời (xem 142 §kết luận) | Rất cơ bản; ví dụ gắn chặt hệ Microsoft 365/Copilot | Chỉ đọc lý thuyết — **chưa thực hành tạo flow thật** (chưa có tài khoản/license, xem §7.3); ví dụ gắn chặt hệ Microsoft 365 |

**Nối 144 — từ "AI giúp làm" sang "máy tự làm":** 144 dạy nhờ AI hỗ trợ từng tác vụ (tóm tắt biên bản, soạn briefing, grounding tài liệu vào prompt, khung Ask–review–verify–decide–act). 145 dạy biến tác vụ *lặp lại có quy tắc* thành flow chạy tự động, không cần bấm tay từng lần. Ranh giới quyết định vẫn thuộc về người — nhưng chuyển chỗ: ở 144, người kiểm chứng *bản AI soạn*; ở 145, người kiểm chứng *flow Copilot tạo* trước khi bật, và người vẫn giữ khâu quyết định qua **approval action** (human-in-the-loop). Bài học bẫy "On Track" của 144 §6 càng đúng ở đây: AI tự tin quá mức — flow Copilot tạo sai trigger/action thì không chỉ sai một bản báo cáo, mà **chạy sai hàng loạt, âm thầm, không ai xem lại** cho tới khi run history tố cáo. Vì vậy verify ở 145 là test flow bằng trigger thật + đọc run history, không phải đọc lại một bản nháp.

**Khung chọn việc để tự động hóa (rút từ cả hai module):** việc nào thỏa cả 4 điều thì là ứng viên flow tốt — (1) lặp lại thường xuyên, (2) quy tắc rõ ràng (nếu X thì Y), (3) nhiều bước hoặc chạy qua nhiều hệ thống, (4) chỗ cần phán đoán con người đã tách riêng được thành một bước approval. Việc không thỏa (1) thì làm tay nhanh hơn làm flow; việc không thỏa (2) thì flow sẽ sai theo quy tắc sai; việc không có (4) mà vẫn cần người quyết thì đừng tự động hóa đầu cuối.

**Nối 140/143 (agentic):** flow là chuỗi hành động *xác định* (deterministic) — cùng trigger thì chạy cùng các bước; agent là chuỗi hành động *tự quyết định bước tiếp theo*. 145 là nền để hiểu agent flow trong Copilot Studio sau này: agent flow cũng dùng trigger/action, chỉ khác là agent được tự chọn bước. Ai đã đọc 145 sẽ hiểu nhanh 143; ai làm 143 nên đọc 145 để biết flow nền tảng chạy ra sao.

## 7. Áp dụng ngay cho Anh / team (đề xuất, muse-main quyết)

1. **Ứng viên flow đầu tiên (theo khung §6, xếp theo độ dễ):**
   - (a) **Form báo cáo ca → tổng hợp tự động:** Forms (báo cáo ca) → ghi SharePoint list → gửi email tóm tắt cho ca sau. Toàn connector chuẩn, không cần Premium, không cần Copilot.
   - (b) **Theo dõi sự cố / OEE:** email hoặc item SharePoint mới về sự cố → đăng thông báo Teams cho ca trực + ghi log. Trigger automated, có trigger filter theo mức độ nghiêm trọng.
   - (c) **Phê duyệt tài liệu chất lượng (SOP, biểu mẫu):** file mới trong SharePoint → Start and wait for an approval, loại **Everyone must approve** (tài liệu chất lượng cần đồng thuận) → cập nhật trạng thái file theo kết quả. Đây là human-in-the-loop đúng nghĩa: máy chạy việc vặt, người giữ quyết định.
2. **Quy tắc an toàn trước khi bật flow thật (nối khung 144 §5):** test bằng trigger thật → đọc run history 28 ngày → chạy Flow checker → kiểm tra connection nào dùng quyền của ai (flow chạy bằng quyền người tạo — đừng để flow gửi mail nhân danh tài khoản không đúng) → xác định owner/co-owner trước khi share. Flow chạm dữ liệu sản xuất/khách hàng thì **bắt buộc có bước approval của người** trước khi gửi ra ngoài.
3. **Ranh giới license — kiểm tra trước khi hứa hẹn:** nội dung khóa đọc miễn phí, nhưng tạo flow thật cần license Power Automate (xem §4.3). **Chưa xác định** license Microsoft 365 hiện tại của Anh/công ty có gồm Power Automate không — cần kiểm tra trước khi chọn flow đầu tiên. Nguyên tắc tiết kiệm: flow đầu tiên chỉ dùng connector chuẩn (Outlook/SharePoint/Teams/Forms), tránh HTTP/Dataverse (premium) để không phát sinh phí; Copilot trong Power Automate cần tài khoản cơ quan/trường học, không dùng tài khoản cá nhân.
4. **Chưa thực hành tạo flow thật:** báo cáo này chỉ đọc lý thuyết (theo §9: không đăng nhập, không chạy lab tốn phí). Đề xuất: khi Anh quyết làm flow đầu tiên (§7.1), làm một task build riêng có device test thật (tạo flow bằng tài khoản công ty, test bằng trigger thật, đọc run history) thay vì coi 145 là "đã xong thực hành".
5. **Hồ sơ audit FSSC 22000 v7 (đang mở):** flow thu thập tài liệu → nhắc hạn → tổng hợp checklist là ứng viên tốt, nối đề xuất 144 §8.4 — nhưng chỉ làm sau khi flow (a) ở §7.1 đã chạy ổn, để team quen với test/monitor trước khi giao việc audit cho flow.

## 8. Đề xuất cập nhật skill / khóa tiếp theo

- **Skill research — thêm recipe "Chọn việc để tự động hóa: 4 câu hỏi" (từ §6):** việc có lặp lại không? quy tắc có rõ không? có nhiều bước/nhiều hệ thống không? chỗ nào cần người quyết (tách thành approval)? Kèm checklist **"Trước khi bật flow"** (test trigger thật, đọc run history, Flow checker, kiểm tra connection dùng quyền ai, xác định owner/co-owner) và cảnh báo **"Copilot soạn flow vẫn phải xem lại như flow đồng nghiệp viết — flow sai chạy sai hàng loạt, âm thầm"**.
- **Khóa tiếp theo gợi ý (chị cả quyết theo §10):** trong danh sách 32, ứng viên nối trực tiếp 144→145 là **#10 "Get started with AI agent development on Azure" (Microsoft Learn)** — từ flow xác định sang agent tự quyết định bước, nhưng thuộc lane build của Ú nhiều hơn lane research. Ứng viên cùng chủ đề tự động hóa cho lane research: **#15 "Business Automation Course" (HubSpot Academy)** — góc marketing/sales, đối chiếu được với góc Microsoft 365 của 145. Đề xuất chính: **#10** nếu chị cả muốn nối chuỗi agent; **#15** nếu muốn ở lại lane research thuần.

## Nguồn đã kiểm chứng

- Learning path "Demonstrate the capabilities of Microsoft Power Automate" (2 module, 21 units, 2h21m): https://learn.microsoft.com/en-us/training/paths/demonstrate-capabilities-microsoft-power-automate/
- Module 1 "Identify Microsoft Power Automate components" — đọc đủ mục tiêu học + trang Summary (10 units): https://learn.microsoft.com/en-us/training/modules/identify-microsoft-power-automate-components/
- Module 2 "Build a Microsoft Power Automate flow" — đọc đủ mục tiêu học + trang Summary and resources (11 units): https://learn.microsoft.com/en-us/training/modules/build-microsoft-power-automate-flow/
- Tài liệu Microsoft "Create a cloud flow in Power Automate" (tạo flow bằng Copilot/tay, designer, test, quản lý, 600 flow, run history 28 ngày): https://learn.microsoft.com/en-us/power-automate/get-started-logic-flow
- Tài liệu Microsoft "Create your first cloud flow using Copilot" (Copilot tạo/sửa flow, Azure OpenAI, tối ưu tiếng Anh): https://learn.microsoft.com/en-us/power-automate/create-cloud-flow-using-copilot
- Tài liệu Microsoft "Get started with Power Automate approvals" + unit "Describe Power Automate use cases" (4 loại phê duyệt, action Start and wait for an approval): https://learn.microsoft.com/en-us/power-automate/get-started-approvals
- Điều kiện dùng Copilot (tài khoản cơ quan/trường học, license có Power Automate, không add-on riêng; premium connector cần Premium): đối chiếu nguồn thứ cấp EnjoySharePoint/PopAutomation với tài liệu Microsoft, 20/11/2026
- Danh sách 32 khóa đã duyệt (bằng chứng Ú đọc bằng browser thật 20/11 21:57): `research/140-governing-ai-agents-deeplearning-ai.md` trên main
- Báo cáo 144 (chuỗi 142→144, khung Ask–review–verify–decide–act, bẫy "On Track"): `research/144-work-smarter-with-ai-microsoft-learn.md`

*Module assessment / Knowledge check cuối mỗi module: chưa làm — cần đăng nhập tài khoản Microsoft để ghi điểm; theo §9 không đăng nhập/đổi cài đặt tài khoản trong lúc học nên bỏ qua, không ảnh hưởng nội dung báo cáo (nội dung 21 units đã đọc đủ qua mục tiêu học + Summary hai module + tài liệu Microsoft đi kèm).*
