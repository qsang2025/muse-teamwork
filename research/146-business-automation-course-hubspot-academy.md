# Business Automation Course (HubSpot Academy) — Báo cáo tự học (task 146)

- **Khóa học:** Business Automation Course — tên chính thức trên HubSpot Academy là *Building an Effective Automation Strategy in HubSpot*
- **Trang khóa:** https://academy.hubspot.com/courses/automation-strategy (trang giới thiệu công khai: https://www.hubspot.com/resources/courses/marketing-automation)
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10: Ú rảnh sau khi task 143 merge xong, không còn task mở). Đây là **khóa số 15 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11); bằng chứng danh sách đầy đủ đã có trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main — không kiểm chứng lại từ đầu theo chỉ dẫn task. Khóa nối tiếp mạch tự động hóa sau 143 (AutoGen multi-agent) + 144 (dùng AI hỗ trợ việc văn phòng) + 145 (Power Automate, đang review): từ pattern agent sang **tự động hóa quy trình kinh doanh thực tế bằng workflow theo luật**.
- **Hình thức:** chỉ học nội dung FREE công khai, **không đăng ký tài khoản trả phí, không chạy lab trên HubSpot thật, không lấy chứng chỉ**. Báo cáo học qua trang giới thiệu khóa chính thức + syllabus công khai + tài liệu Knowledge Base chính thức của HubSpot về workflows (xem mục Nguồn). Trang Academy yêu cầu tải bằng trình duyệt/đăng nhập nên nội dung bài giảng chi tiết được đối chiếu qua syllabus công khai và KB — phần nào không đọc trực tiếp được ghi rõ là suy ra từ syllabus, không bịa chi tiết bài giảng.

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Thuộc danh sách đã duyệt: CÓ.** Business Automation Course — HubSpot Academy là khóa số 15 trong danh sách 32 khóa Vinmedia đã đọc đủ bằng browser thật tối 20/11 (bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main). muse-main đã ghi rõ vào task file.
- **Khóa học: FREE.** HubSpot Academy là thư viện khóa miễn phí của HubSpot; trang giới thiệu chính thức xếp khóa này trong "Free Resources Library" và syllabus công khai ghi giá 0 USD. Không có gói PRO cho bài giảng như DeepLearning.AI (khác mẫu task 128/132/135/137/140/143).
- **Phần không FREE nếu chạy thật:** công cụ **Workflows** của HubSpot yêu cầu gói *Professional/Enterprise* (Marketing Hub, Sales Hub, Service Hub hoặc Data Hub) theo Knowledge Base chính thức — tài khoản CRM miễn phí không chạy được workflows đầy đủ. Hệ quả: **chỉ học phương pháp và mô hình tư duy, không tạo tài khoản, không dựng workflow thật trên HubSpot** — đúng checklist. Giá trị của khóa nằm ở khung quyết định (khi nào tự động hóa, dữ liệu nào kích hoạt, nối quy trình vào action ra sao), không nằm ở thao tác trên giao diện HubSpot.
- **Không trùng:** khóa gần nhất là 145 Power Automate (Microsoft Learn — công cụ tự động hóa trong hệ Microsoft 365, thiên về thao tác flow) và 144 Work smarter with AI (dùng Copilot hỗ trợ việc). Khóa 146 khác ở tầng **chiến lược**: quyết định *có nên* tự động hóa hay chưa và *chuẩn bị gì trước khi* tự động hóa, trước khi chạm vào bất kỳ công cụ nào. Ba khóa bổ sung nhau: 144 dạy *dùng AI trong việc*, 145 dạy *dựng flow bằng công cụ*, 146 dạy *quyết định quy trình nào đáng tự động hóa và dữ liệu phải ra sao*.

## Cấu trúc khóa (syllabus)

Khóa gồm **3 bài**, đi theo đúng thứ tự một dự án tự động hóa thật: quyết định → dữ liệu → nối quy trình vào công cụ.

| Bài | Nội dung chính | Khái niệm lõi |
|---|---|---|
| 1. How to Decide if It's Time to Implement Automation | Đánh giá thời điểm triển khai: doanh nghiệp cần có gì trước khi tự động hóa | Quy trình chuẩn hóa trước, tự động hóa sau |
| 2. Using CRM Data to Trigger Automation in HubSpot | Dùng dữ liệu CRM làm điều kiện kích hoạt (enrollment triggers) cho workflow | Trigger theo dữ liệu, chất lượng dữ liệu đầu vào |
| 3. Connect Business Processes to Workflow Actions | Nối từng bước quy trình kinh doanh vào các action của workflow (gửi email, tạo task, cập nhật bản ghi, thông báo nội bộ...) | Ánh xạ quy trình → trigger/action, test trước khi bật |

Mục tiêu học tập chính thức của khóa: (1) hiểu vì sao phải có quy trình kinh doanh cố định trước khi tự động hóa; (2) dùng workflow actions để tự động hóa việc hằng ngày, tăng hiệu quả; (3) tự động hóa quy trình xuyên phòng ban (marketing, vận hành...).

## 1. Bài 1 — Quy trình trước, tự động hóa sau

- **Luận điểm trung tâm của khóa:** tự động hóa không sửa được quy trình hỏng — nó chỉ chạy quy trình đó nhanh hơn và đều hơn. Nếu quy trình chưa cố định (mỗi người làm một kiểu, bước chưa rõ, đầu ra chưa định nghĩa), tự động hóa sẽ nhân bản sự hỗn loạn ở quy mô lớn. Vì vậy điều kiện tiên quyết là **quy trình đã được chuẩn hóa và đang chạy ổn định bằng tay**.
- **Tiêu chí "đã đến lúc"** (tổng hợp từ mục tiêu bài 1 + tài liệu HubSpot): việc lặp lại thường xuyên và tốn thời gian thủ công; các bước đã rõ và ít thay đổi; đầu vào/đầu ra xác định được; lỗi chủ yếu do quên/quá tải chứ không do thiếu phán đoán. Ngược lại, việc còn đang thử nghiệm, ít lặp lại, hoặc cần phán đoán tinh tế theo từng trường hợp thì chưa nên tự động hóa.
- **Ánh xạ sang nhà máy:** đây là đúng thứ tự Anh đang áp dụng với FSSC 22000 v7 và chuẩn hóa vận hành đóng gói — chuẩn hóa quy trình (SOP, checklist, Visual Management) trước, rồi mới tính chuyện số hóa/tự động hóa báo cáo OEE hay nhắc việc theo ca. Khóa cho một câu kiểm tra đơn giản trước mọi dự án tự động hóa ở xưởng: *quy trình này đã chạy ổn định bằng tay chưa, hay đang muốn dùng phần mềm để che chỗ chưa chuẩn?*
- **Ánh xạ sang team:** team 3 Muse cũng đi đúng thứ tự này — PROTOCOL.md (quy trình) có trước, watcher 5 phút + hub (tự động hóa) có sau. Bài học rút ra: mỗi lần muốn thêm tự động hóa cho team (vd tự claim, tự merge), phải hỏi quy trình tương ứng đã ổn định chưa — task 115/§7 watchdog là ví dụ ngược: tự động hóa chỉ thêm sau khi quy trình claim đã chạy tay đủ lâu để thấy điểm kẹt thật (task 112).

## 2. Bài 2 — Dữ liệu là trigger: rác vào, rác ra ở quy mô lớn

- **Cơ chế:** trong HubSpot, workflow tự động "ghi danh" (enroll) một bản ghi khi nó thỏa **enrollment triggers** — bộ tiêu chí dựa trên dữ liệu CRM. Knowledge Base chính thức liệt kê 4 loại trigger: theo bộ lọc thuộc tính (filter-based), theo sự kiện (event-based), theo lịch (schedule), và theo webhook từ hệ ngoài. Sau khi ghi danh, workflow chạy chuỗi actions trên bản ghi đó hoặc bản ghi liên quan.
- **Hệ quả dữ liệu:** trigger chỉ tốt bằng dữ liệu nó đọc. Thuộc tính trống, sai định dạng, trùng lặp → workflow ghi danh sai người, gửi sai nội dung, hoặc không chạy mà không ai biết. Đây là lý do khóa đặt bài dữ liệu *trước* bài dựng action: **làm sạch và chuẩn hóa dữ liệu là một phần của dự án tự động hóa, không phải việc phụ**.
- **Re-enrollment — chi tiết dễ bỏ qua:** mặc định một bản ghi chỉ vào workflow **một lần** (lần đầu thỏa trigger). Muốn bản ghi chạy lại khi điều kiện lặp lại (vd khách quay lại một giai đoạn) phải bật re-enrollment triggers riêng, với luật riêng (không dùng AND, không dùng activity...). Quên chi tiết này là lỗi kinh điển: workflow "chạy đúng lần đầu rồi im lặng mãi".
- **Ánh xạ sang nhà máy:** trigger trong nhà máy là dữ liệu sản xuất — số liệu OEE, sản lượng ca, kết quả kiểm tra chất lượng. Nếu số liệu đầu vào nhập tay không chuẩn (mỗi ca ghi một kiểu), mọi dashboard/cảnh báo tự động phía sau đều sai theo. Bài học: trước khi tự động hóa báo cáo, chuẩn hóa *định nghĩa và cách ghi* số liệu — đúng tinh thần "Is / Is Not" và chuẩn hóa đo lường Anh đang triển khai.
- **Ánh xạ sang team:** trigger của team là file task JSON (status, assignee, preferred_assignee). Bài học re-enrollment ánh xạ thẳng: watcher chỉ đánh thức khi *trạng thái đổi* — một task kẹt ở `claimed` không tự "chạy lại" nếu không có cơ chế riêng (watchdog §7 chính là re-enrollment trigger của team, được thêm sau vụ task 112). Khóa củng cố: khi thiết kế bất kỳ vòng tự động nào, phải trả lời rõ "điều kiện lặp lại thì sao" ngay từ đầu.

## 3. Bài 3 — Nối quy trình vào action: một bước quy trình = một action kiểm chứng được

- **Phương pháp:** viết quy trình ra từng bước, rồi ánh xạ mỗi bước vào một workflow action cụ thể: gửi email, tạo task cho người phụ trách, cập nhật thuộc tính bản ghi, thông báo nội bộ, tạo bản ghi mới, ghi dữ liệu sang Google Sheets, gán người phụ trách theo vòng... Bước nào không ánh xạ được vào action nào thì bước đó hoặc chưa rõ, hoặc cần người — đó là tín hiệu quay lại chuẩn hóa, không phải cố ép vào workflow.
- **Cài đặt vòng đời workflow** (theo KB chính thức): ngoài trigger và action còn có **unenrollment** (tự rút bản ghi khỏi workflow khi thỏa điều kiện loại trừ — đồng thời chặn ghi danh), **thời gian thực thi** (chỉ chạy trong giờ làm việc), và **test trước khi bật**: HubSpot có chế độ test tiêu chí ghi danh và mô phỏng một bản ghi đi qua toàn bộ workflow *trước khi* bật thật, cộng trang chi tiết để xem hiệu năng và gỡ lỗi ghi danh. Thứ tự đúng là: dựng → test bằng bản ghi mẫu → mới bật.
- **AI trong workflow:** HubSpot cho dùng Breeze (AI của hãng) để sinh trigger/action từ prompt dạng "Khi [việc này xảy ra], thì [làm việc kia]" — nhưng AI chỉ sinh bản nháp cấu hình; người vẫn phải test và chịu trách nhiệm khi bật. Cùng nguyên tắc với task 144: AI hỗ trợ, con người quyết định.
- **Ánh xạ sang team:** checklist trong mỗi task file chính là "quy trình đã ánh xạ": quét chống trùng → claim → build → test → review, mỗi bước có đầu ra kiểm chứng được (commit, validate PASS...). Và "test trước khi bật" là đúng cổng merge của team: validate PASS + device test + install 200 (§4) — không có cổng test thì không có tự động hóa nào được tin.
- **Ánh xạ sang nhà máy:** khi số hóa một quy trình xưởng (vd nhắc kiểm tra định kỳ, tổng hợp báo cáo ca), ánh xạ từng bước SOP vào một hành động hệ thống làm được, bước cần phán đoán của trưởng ca giữ nguyên cho người. Tự động hóa phần *nhắc việc + tổng hợp + ghi chép*, không tự động hóa phần *quyết định*.

## 4. Đối chiếu 3 khóa tự động hóa liên tiếp (144 → 145 → 146) và mạch agent (140/143)

| Khóa | Tầng | Câu hỏi trả lời | Công cụ minh họa |
|---|---|---|---|
| 144 Work smarter with AI | Cá nhân | Dùng AI hỗ trợ việc hằng ngày ra sao? | Microsoft 365 Copilot |
| 145 Power Automate | Công cụ | Dựng một flow tự động bằng thao tác thế nào? | Power Automate |
| 146 Business Automation | Chiến lược | Quy trình nào đáng tự động hóa, chuẩn bị dữ liệu/quy trình ra sao trước khi dựng? | HubSpot Workflows |

- **Khác biệt với agent (140/143):** workflow theo luật (khóa này + 145) chạy **xác định**: cùng trigger → cùng action, kiểm chứng được từng bước. Agent (AutoGen, LangGraph) chạy **suy luận**: tự chọn bước tiếp theo, mạnh khi việc mơ hồ nhưng khó kiểm chứng. Quy tắc chọn rút ra từ cả mạch: việc đã rõ bước và lặp lại → workflow theo luật (rẻ, an toàn, audit được); việc cần phán đoán/tổng hợp mở → agent, nhưng đặt agent *bên trong* một workflow có cổng kiểm chứng của người. Team 3 Muse hiện là mô hình lai đúng hướng này: khung workflow xác định (PROTOCOL, task file, cổng merge) + agent suy luận bên trong từng task.
- **Điểm chung cả 4 khóa:** không khóa nào dạy "cài công cụ rồi để nó tự chạy". Tất cả đều đặt **quy trình rõ + dữ liệu sạch + cổng kiểm chứng của người** trước tự động hóa. Đây là kết luận nhất quán nhất của mạch tự học tháng 11.

## 5. Đề xuất áp dụng (có điều kiện, chưa làm ngay)

1. **Cho team:** thêm vào mẫu task tự động hóa tương lai một mục "kiểm tra sẵn sàng tự động hóa" theo bài 1: quy trình đã ổn định chưa, trigger là dữ liệu nào, điều kiện lặp lại (re-enrollment) xử lý ra sao, test bằng gì trước khi bật. Rẻ, chỉ là checklist — áp dụng được ngay ở task hạ tầng tiếp theo nếu chị Bẹp duyệt.
2. **Cho nhà máy (gợi ý cho Anh, không tự làm):** trước khi số hóa bất kỳ báo cáo/checklist nào ở xưởng, chạy 3 câu hỏi của khóa: (a) quy trình tay hiện tại đã chuẩn và ổn định chưa; (b) dữ liệu đầu vào ghi có chuẩn một kiểu không; (c) bước nào giữ cho người quyết. Ba câu này khớp sẵn với PDCA/Lean Anh đang dùng — khóa chỉ cho thêm ngôn ngữ "trigger/action/test trước khi bật" để mô tả.
3. **Không đề xuất** tạo tài khoản HubSpot hay dựng workflow thật: công cụ cần gói trả phí Professional/Enterprise, ngoài phạm vi FREE và ngoài nhu cầu hiện tại của team (team đã có GitHub task file + hub tự dựng làm đúng vai workflow engine ở quy mô nhỏ).

## Nguồn

- Trang giới thiệu khóa chính thức (HubSpot Free Resources Library): https://www.hubspot.com/resources/courses/marketing-automation — tên khóa "Business Automation Course: HubSpot Marketing Automation Course", mô tả "Implement an automation strategy for your business using HubSpot... streamline business and marketing workflows", nút Start course trỏ tới https://academy.hubspot.com/courses/automation-strategy
- Syllabus + mục tiêu học tập công khai của khóa *Building an Effective Automation Strategy in HubSpot* (HubSpot, giá 0 USD): https://www.classcentral.com/course/automation-strategy-66247
- HubSpot Knowledge Base — Automate your processes (tổng quan công cụ tự động hóa, điều kiện gói Professional/Enterprise cho Workflows): https://knowledge.hubspot.com/get-started/automate-your-processes?hubs_content=knowledge.hubspot.com%25252Fget-started&hubs_content-cta=workflows
- HubSpot Knowledge Base — Create workflows (4 loại enrollment trigger: filter/event/schedule/webhook; tạo bằng AI Breeze theo mẫu "When [this happens], then [do this]"): https://knowledge.hubspot.com/workflows/create-workflows?hubs_content=knowledge.hubspot.com%2Ftasks%2Fuse-task-queues&hubs_content-cta=create+your+workflow
- HubSpot Knowledge Base — Add re-enrollment triggers to a workflow (mặc định chỉ ghi danh một lần, luật re-enrollment): https://knowledge.hubspot.com/workflows/add-re-enrollment-triggers-to-a-workflow?_ga=2.96279388.1330480669.1659450447-654991896.1659450447
- HubSpot Knowledge Base — Test your workflow (test tiêu chí + mô phỏng bản ghi trước khi bật): https://knowledge.hubspot.com/articles/kcs_article/contacts/how-can-i-test-a-workflow
- Danh sách 32 khóa đã duyệt (khóa số 15): `research/140-governing-ai-agents-deeplearning-ai.md` trên main (Ú đọc bằng browser thật 20/11 21:57)

*Ghi chú trung thực: trang Academy không đọc trực tiếp được bằng công cụ fetch text (trang yêu cầu trình duyệt/đăng nhập), nên nội dung từng bài được học qua syllabus + mục tiêu chính thức của khóa và tài liệu Knowledge Base chính thức của HubSpot về đúng các cơ chế khóa dạy (trigger, action, re-enrollment, test). Không đăng ký tài khoản, không chạy workflow thật — đúng quy tắc tự học §9.*
