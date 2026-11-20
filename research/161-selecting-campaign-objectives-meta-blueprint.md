# Selecting campaign objectives and conversion settings (Meta Blueprint) — Báo cáo tự học (task 161)

- **Khóa học:** Selecting campaign objectives and conversion settings, Meta Blueprint
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Trạng thái:** đã học xong, nộp review
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10: Ú rảnh sau khi task 158 merge xong, không còn task mở). Đây là **khóa số 23 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11); bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main (dòng 54) — không kiểm chứng lại từ đầu theo chỉ dẫn task. Nối mạch quảng cáo sau 159 (Google Ads Search, muse-2, đã merge 21/11 02:48) → 160 (TikTok Academy, muse-2, đang claimed từ 03:08 cùng ngày, chưa có báo cáo merge): khóa này sang **phía Meta — quảng cáo theo người (audience/feed) thay vì theo truy vấn**, trọng tâm là **chọn mục tiêu chiến dịch + cài đặt chuyển đổi**, đối chiếu với đấu giá/Ad Rank/attribution của 159 và khám phá vs ý định tìm kiếm của 160: chỗ nào Meta bổ sung, chỗ nào khác hẳn, và chi phí/lợi ích ra sao (team không chạy quảng cáo thật, chỉ học khung).
- **Hình thức:** chỉ học nội dung FREE công khai; không đăng nhập Meta Blueprint/Ads Manager, không đăng ký trả phí/chứng chỉ, không chạy chiến dịch quảng cáo thật, không nạp tiền (quy tắc tự học §9).

## Kiểm chứng danh sách 32 khóa (checklist mục 1) — ĐÃ XÁC NHẬN

Khóa **có** trong danh sách 32 khóa AI miễn phí đã duyệt: số **23** trong danh sách 32 tên đầy đủ đã lưu tại `research/140-governing-ai-agents-deeplearning-ai.md` (dòng 54, mục "Bổ sung kiểm chứng bằng browser thật", 20/11/2026): "Selecting campaign objectives and conversion settings — Meta Blueprint". Khóa số 24 ngay sau là "Managing audiences and optimizing reach — Meta Blueprint" (dòng 55) — task này chỉ học khóa 23, không học khóa 24. Không kiểm chứng lại từ đầu, đúng ghi chú task 161.

## Ghi chú trung thực về nguồn học

- **Trang khóa Meta Blueprint chính thức không đọc trực tiếp từng bài giảng trong lần học này:** Blueprint là nền tảng học cần đăng nhập/trình duyệt; báo cáo học qua **mô tả chính thức của Meta Business Help Center được trích dẫn và đối chiếu chéo trong nhiều hướng dẫn độc lập cập nhật 10–11/2026** (Jon Loomer — chuyên gia Meta Ads lâu năm; Power Ads, kiểm chứng 32 nguồn, cập nhật 11/2026; Scope Design, rà soát 08/2026; Enrich Labs 2026; Voluum, kiểm tra tài liệu từng nền tảng 11/2026) + **tài liệu cài đặt Pixel/Conversions API** (Meta Events Manager qua các hướng dẫn kỹ thuật 2026). Các nguồn độc lập **thống nhất** về 6 mục tiêu ODAX, mô hình 3 lựa chọn (objective / conversion location / performance goal) và cửa sổ attribution mặc định — phần nào là lời nguồn thứ cấp được ghi rõ; **không tạo tài khoản, không làm quiz, không lấy chứng chỉ Meta, không mở Ads Manager** — đúng §9 (team chỉ cần khung, không cần chứng chỉ).
- **Hệ quả của giới hạn này:** chi tiết trình bày trong từng bài giảng Blueprint (ví dụ minh họa, bài tập mô phỏng Ads Manager) có thể sâu hơn phần tóm tắt; nhãn giao diện Meta thay đổi thường xuyên (các nguồn 2026 đều cảnh báo "confirm labels in your live Ads Manager UI") nên báo cáo ghi **khái niệm + tên gọi hiện hành 2026**, không ghi thao tác bấm từng nút. Ghi rõ để muse-main chấm review biết giới hạn.

## Cấu trúc khóa — hai nửa của tên khóa

Tên khóa gồm đúng hai quyết định mà Ads Manager buộc nhà quảng cáo phải ra, theo thứ tự:

| Nửa khóa | Quyết định | Cấp cài đặt |
|---|---|---|
| **Selecting campaign objectives** | Chọn 1 trong 6 mục tiêu ODAX + nơi chuyển đổi (conversion location) + mục tiêu hiệu quả (performance goal) | Objective ở cấp **campaign**; location + performance goal ở cấp **ad set** |
| **Conversion settings** | Sự kiện chuyển đổi nào được tính (dataset/Pixel, sự kiện chuẩn, Conversions API), cửa sổ attribution nào áp dụng | **Events Manager** (dataset) + cài đặt attribution ở cấp **ad set** |

Cấu trúc tài khoản Meta 3 cấp (đối chiếu 159): **campaign (objective) → ad set (audience, conversion location, performance goal, budget, schedule, placements) → ad (creative, copy, CTA, URL đích)**. Google Ads của 159 là account → campaign → ad group → keyword/ad; Meta không có tầng từ khóa — khác biệt gốc rễ được phân tích ở §6.

## 1. Sáu mục tiêu ODAX: mục tiêu là lệnh huấn luyện, không phải nhãn

- **Lịch sử rút gọn:** trước 2022 Meta có **11 mục tiêu** (Brand Awareness, Reach, Traffic, Engagement, Video Views, Lead Generation, Messages, App Installs, Conversions, Catalog Sales, Store Traffic) xếp dưới 3 banner phễu Awareness/Consideration/Conversion. Khung **ODAX (Outcome-Driven Ad Experiences)**, công bố 12/2021 và thành đường tạo chiến dịch duy nhất từ 2023, gộp 11 → **6 mục tiêu phẳng**: **Awareness, Traffic, Engagement, Leads, App promotion, Sales**. Ánh xạ đáng nhớ: Brand Awareness + Reach + Store Traffic → Awareness; Lead Generation → Leads; App Installs → App promotion; Conversions + Catalog Sales → Sales; Messages/Video Views phân tán vào Engagement/Leads/Awareness tùy performance goal. Tài liệu cũ nhắc 11 mục tiêu hoặc nhãn "Conversions" (API/công cụ bên thứ ba còn sót) là **đã lỗi thời** — cùng kỷ luật "đọc tài liệu cũ phải đổi nhãn" như Smart Bidding 06/2026 ở 159.
- **Mục tiêu là tín hiệu huấn luyện cho hệ phân phối, không phải nhãn báo cáo:** Meta dùng objective để chọn mô hình tối ưu — hệ đấu giá của Meta quét Facebook/Instagram/Messenger tìm **người có khả năng cao nhất thực hiện hành động gắn với mục tiêu đó**. Chọn Awareness thì hệ tìm người dễ nhớ quảng cáo; chọn Sales thì hệ tìm người dễ mua. Hệ quả thực hành sắc nhất của khóa: **chọn sai mục tiêu thì hệ tối ưu đúng thứ sai một cách rất hiệu quả** — ví dụ kinh điển trong mọi hướng dẫn 2026: cần doanh số mà chọn Traffic vì "click rẻ" thì nhận về người hay bấm chứ không phải người hay mua.
- **Mục tiêu bị khóa khi chiến dịch chạy:** objective là cài đặt **duy nhất không sửa được sau khi tạo campaign** (muốn đổi phải tạo campaign mới) — quyết định ít đảo ngược nhất trong tài khoản, nên khóa đặt nó lên đầu tên khóa. Đây là điểm khác Google Ads của 159, nơi chiến lược đấu thầu (Smart Bidding) đổi được giữa chừng; ở Meta, **mục tiêu là cam kết, đấu thầu mới là cần gạt**.

| Mục tiêu ODAX | Hệ được lệnh tìm | Cần đo chuyển đổi mạnh? | Bẫy thường gặp |
|---|---|---|---|
| **Awareness** | Người dễ xem/nhớ quảng cáo (reach, impressions, ad recall, video exposure) | Không | Cần lead/doanh số mà muốn "số to giá rẻ" |
| **Traffic** | Người dễ bấm tới đích (link clicks, landing page views) | Hỗ trợ chất lượng LPV, không học mua hàng | Nhầm click rẻ với khách hàng |
| **Engagement** | Tương tác trên Meta (post engagement, video views, messages, event responses) | Không cho chỉ số bề mặt; có nếu messages → CRM | Dùng like làm bằng chứng nhu cầu |
| **Leads** | Người để lại liên hệ (Instant Form, website lead, calls, messages) | Có — sự kiện lead website/chất lượng CRM | Tối ưu số form thô không có phản hồi chất lượng |
| **App promotion** | Cài đặt + hành động trong app | Có — SDK/sự kiện app bắt buộc | Mừng số cài đặt mà không đo kích hoạt/giữ chân |
| **Sales** | Mua hàng + giá trị chuyển đổi (conversions, catalog sales, ROAS) | **Có — Pixel + Conversions API khuyến nghị** | Tín hiệu yếu/thưa → hệ học từ nhiễu |

## 2. Ba lựa chọn tách rời: objective giới hạn thực đơn, performance goal quyết định người xem

- **Mô hình 4 tầng hay bị trộn lẫn** (Scope Design 08/2026, khớp mô tả Meta Business Help): (1) **business outcome** — kết quả kinh doanh thật (doanh số có lãi, cơ hội đủ điều kiện, lịch hẹn đã đặt); (2) **campaign objective** — 1 trong 6 ODAX; (3) **conversion location** — hành động xảy ra ở đâu (website, app, Instant Form, Messenger/Instagram/WhatsApp, cuộc gọi, cửa hàng); (4) **performance goal** — hành vi cụ thể hệ tối ưu trong objective + location đó (reach, landing page views, conversations, leads, purchases...). Công cụ đơn giản của Meta (Business Suite, Ad Center, Instagram) **gói 3 lựa chọn sau thành 1 nút**; Ads Manager tách ra cho chọn từng cái — khóa này dạy bản tách.
- **Câu chốt của khóa:** *objective giới hạn các lựa chọn được chào; performance goal là thứ tối ưu thực sự đi theo* (Jon Loomer, được các hướng dẫn 2026 trích dẫn thống nhất). Ví dụ chính thức của Meta: campaign **Sales** vẫn có thể có ad set tối ưu cho **link clicks** — khi đó quảng cáo đi tới người hay bấm, không phải người hay mua, dù nhãn campaign ghi Sales. Cột "Results" đếm theo performance goal đã chọn, nên **hai ad set khác performance goal không đếm cùng một thứ** — đọc báo cáo mà không biết goal là đọc sai.
- **Quy tắc chọn đúng (đồng thuận 2026):** chọn objective khớp với **hành động đo được gần nhất dự đoán đáng tin cậy kết quả kinh doanh** — không phải hành động rẻ nhất hay số đẹp nhất. Ngân sách ngày tối thiểu Meta gợi ý: khoảng **10 lần chi phí trung bình của performance goal** (theo Power Ads trích Meta) để hệ có đủ tín hiệu học — ghi như **gợi ý của Meta qua nguồn thứ cấp**, không phải công thức đảm bảo; team không chạy thật nên chỉ giữ nguyên lý "tín hiệu thưa thì hệ học nhiễu".
- **Advantage+ không còn là loại campaign riêng (2026):** Sales/Leads/App promotion hiển thị Advantage+ bật khi budget/audience/placements để ở cài đặt Advantage+; luồng tạo mới có thể mặc định đẩy campaign đủ điều kiện về Advantage+. Kỷ luật rút ra từ các hướng dẫn 2026: phân biệt **control** (ràng buộc không thương lượng: khu vực phân phối, điều kiện đủ tư cách, ngân sách được duyệt, quyền nội dung, tồn kho) với **suggestion** (gợi ý linh hoạt của hệ) — đọc từng khuyến nghị đối chiếu brief thay vì bật tự động mù. Đây là bản sao Meta của bài học 159 "Optimization Score là danh sách kiểm tra, không chạy theo 100%".

## 3. Cài đặt chuyển đổi: dataset/Pixel + Conversions API + sự kiện chuẩn

- **Dataset là đơn vị đo hiện hành:** Meta nay quản lý Pixel dưới **Datasets** trong Events Manager — tạo dataset là tự sinh Pixel, **Dataset ID chính là Pixel ID** (một dãy số). Quy tắc cứng: **dùng cùng một Pixel ID cho cả sự kiện trình duyệt lẫn sự kiện máy chủ**; tạo Pixel thứ hai hoặc gửi hai nguồn vào hai dataset khác nhau sẽ **chia đôi dữ liệu** và sinh chênh lệch trong Events Manager.
- **Hai đường gửi sự kiện, Meta khuyến nghị dùng cả hai:** **Meta Pixel** chạy trong trình duyệt của khách (dễ mất sự kiện vì ad blocker, trình duyệt trong app, giới hạn cookie); **Conversions API (CAPI)** gửi sự kiện từ máy chủ (website platform, gateway, hoặc code trực tiếp qua Graph API) — sự kiện mua hàng gửi lại từ server nên không mất vì blocker. Meta tuyên bố nhà quảng cáo có CAPI cho web events thấy chi phí/kết quả thấp hơn trung bình **17,8%** (Meta, 04/2026, qua nguồn thứ cấp — **Meta không công bố phương pháp, đọc như số của Meta, không phải lời hứa**).
- **Chống trùng bằng cặp (event_name, event_id):** sự kiện chuẩn dùng chung hai phía — PageView, ViewContent, AddToCart, InitiateCheckout, Lead, **Purchase (kèm value + currency)** — và bản trình duyệt + bản máy chủ của cùng một hành động phải mang **cùng event_id** (dùng mã đơn hàng làm ID ổn định) thì Meta mới gộp thành 1 chuyển đổi; lệch tên hoặc lệch ID là đếm đôi. Kiểm chứng bằng **Test Events** trong Events Manager (gửi test_event_code, đặt đơn thử, xác nhận hiện đúng 1 Purchase) và kiểm tra lại sau mỗi lần đổi website.
- **Bốn đường cài CAPI, chọn đường ít việc nhất đủ dùng:** (1) **partner integration** của nền tảng website (Shopify, WooCommerce, WordPress...) — ít việc nhất; (2) **CAPI một chạm của Meta** (miễn phí); (3) **gateway** (dịch vụ hosted, có chi phí cloud); (4) **direct build** (code máy chủ, nhiều việc nhất — cho sự kiện tùy biến/offline/CRM). Chạy nhiều đường cùng lúc cho cùng sự kiện = đếm đôi — cùng lỗi "hai nguồn cùng đếm một việc" mà team đã gặp ở tầng task (chống trùng §3 PROTOCOL).
- **Điểm nối sang Leads chất lượng (2026):** performance goal "Maximize number of qualified (conversion) leads" — tối ưu tới người dễ chuyển đổi *sau* khi để lại liên hệ — từ **04/2026 không còn tạo mới được nếu thiếu tích hợp Conversions API** (CRM gửi giai đoạn lead về Meta qua CAPI; campaign cũ bị ảnh hưởng từ 08/2026, theo Variafy 10/2026 trích Meta). Đây là minh chứng rõ nhất của khóa: **cài đặt chuyển đổi không phải việc phụ sau khi chọn mục tiêu — nó quyết định mục tiêu nào dùng được**.

## 4. Attribution: cửa sổ đếm cũng là cửa sổ học

- **Mặc định hiện hành (2026): 7-day click + 1-day engage-through + 1-day view**, đặt ở cấp ad set, mô hình **Standard**, đếm **All Conversions**. Ba cửa sổ: click-through (1 hoặc 7 ngày sau **link click**), engage-through (1 ngày sau tương tác không phải link click — like, share, save, xem video), view-through (1 ngày sau impression, hoặc tắt). Hai thay đổi 2026 phải ghi để khỏi đọc sai tài liệu cũ: **03/2026** Meta đổi định nghĩa click-through (chỉ còn link click; non-link click chuyển sang engage-through, thay tên engaged-view cũ) và **12/01/2026** Meta ngừng trả cửa sổ 7-day view/28-day view trong báo cáo.
- **Attribution không chỉ trình bày báo cáo — nó lái phân phối:** hệ tối ưu để lấy chuyển đổi **nằm trong cửa sổ đã chọn**, nên hai ad set khác cài đặt attribution đang học hai bài toán khác nhau và không so sánh trực tiếp được. Công cụ **Compare Attribution Settings** (Columns → Compare) cho xem cùng dữ liệu dưới nhiều cửa sổ (1-day view, 1-day click, 7-day click, 28-day click) **trước khi** đổi cài đặt thật — kỷ luật "xem trước khi commit" giống hệt bài học 159 về đổi mô hình attribution giữa chừng làm đứt báo cáo.
- **Đối chiếu trực tiếp với 159:** Google Ads 2026 còn 2 mô hình — **Data-Driven Attribution (mặc định, chia credit theo đóng góp thật)** vs Last-Click; Meta Standard là **theo cửa sổ thời gian** (credit cho quảng cáo trong cửa sổ, không chia theo đóng góp từng chạm như DDA). Cùng một đơn hàng, Google DDA có thể chia credit cho nhiều chạm, Meta Standard ghi cho quảng cáo trong cửa sổ 7/1/1 — **hai nền tảng sẽ không bao giờ khớp số chuyển đổi**, và đó là điều bình thường phải ghi rõ khi ai đối chiếu báo cáo chéo nền tảng. Điểm chung cốt lõi của cả hai khóa: **mô hình đo đã chọn nối thẳng vào đấu thầu/phân phối** — đo sai thì máy học sai, ở Google là Smart Bidding nhìn cột Conversions, ở Meta là hệ phân phối học trong cửa sổ attribution.

## 5. Ánh xạ sang team và nhà máy (khung, không chạy thật)

- **"Objective là lệnh huấn luyện" ánh xạ sang cách team giao việc:** task file của team cũng có "objective" ngầm — build extension hay research, validate PASS hay device test — và worker tối ưu theo đúng tiêu chí ghi trong task, kể cả khi tiêu chí đó lệch mục tiêu thật (giống campaign Sales tối ưu link clicks). Bài học rẻ: **ghi performance goal đo được vào task trước khi ghi định dạng đầu ra** — team đã làm điều này với bộ ba validate/device/install của PROTOCOL §4, khóa này cho thêm ngôn ngữ để gọi tên nó.
- **"Chống trùng event_id" ánh xạ sang chống trùng task:** cùng một hành động bị hai nguồn đếm đôi (Pixel + CAPI lệch ID) là bản sao kỹ thuật của lỗi hai agent cùng build một site (§3 PROTOCOL) — thuốc chữa cũng cùng một loại: **một định danh ổn định dùng chung + một nguồn sự thật duy nhất** (ở Meta là dataset/Pixel ID, ở team là tasks/*.json trên GitHub).
- **Ánh xạ nhà máy (gợi ý, không tự làm):** cửa sổ attribution là bản sao của **cửa sổ đo OEE theo ca**: đổi cửa sổ đếm (ca nào tính sản phẩm lỗi) là đổi cả số báo cáo lẫn hành vi tối ưu của dây chuyền — kỷ luật "ghi rõ cửa sổ đo kèm mọi con số" đã áp dụng cho OEE thì cũng áp dụng cho mọi chỉ số có cửa sổ thời gian.

## 6. Đối chiếu với 159 (Google Ads Search) và 160 (TikTok Academy) — bổ sung, khác hẳn, chi phí/lợi ích

Đây là yêu cầu đối chiếu trực tiếp của task 161. Cơ sở: 159 đã merge (báo cáo đầy đủ trên main); **160 đang claimed bởi muse-2 từ 03:08 21/11, mới có commit WIP, chưa có báo cáo merge** — phần đối chiếu TikTok dưới đây ở **mức khung theo ghi chú task 160** (khám phá vs ý định tìm kiếm) + dữ kiện cửa sổ attribution TikTok đã kiểm chứng chéo 11/2026, ghi rõ giới hạn này; khi báo cáo 160 merge, muse-main có thể đối chiếu sâu hơn.

### 6.1 Khác hẳn: ý định tìm kiếm (159) vs khám phá theo người (161) vs khám phá theo nội dung (160)

|  | Google Ads Search (159) | Meta (khóa này) | TikTok (160, mức khung) |
|---|---|---|---|
| Tín hiệu gốc | **Truy vấn** người dùng gõ — ý định có sẵn, đang tìm | **Người** — hồ sơ/hành vi trên Facebook/Instagram/Messenger, quảng cáo chen vào feed | **Nội dung video ngắn** — người xem đang khám phá, chưa có ý định mua |
| Đơn vị chọn | Từ khóa + match type | Objective + audience + performance goal | Video/creative + mục tiêu chiến dịch |
| Cơ chế thắng | Đấu giá từng lượt tìm kiếm, Ad Rank 6 yếu tố, giá thứ hai | Hệ phân phối tìm người dễ thực hiện hành động của objective trong ngân sách | Hệ đề xuất phân phối video theo mức giữ chân/tương tác (khung task 160) |
| Đo chuyển đổi | Conversion tracking + DDA/Last-Click | Dataset/Pixel + CAPI, cửa sổ 7/1/1 Standard | Attribution window (mặc định cũng 7-day click/1-day view theo Voluum 11/2026) |
| Câu hỏi trả lời | "Ai đang tìm thứ này ngay bây giờ?" | "Ai giống người sẽ làm việc này?" | "Nội dung nào giữ được người xem đủ lâu để nảy ý định?" |

### 6.2 Chỗ nào Meta bổ sung cho 159/160

- **Bổ sung phía "chưa có ý định":** Google Search chỉ bắt được người **đã** gõ truy vấn; Meta (và TikTok ở 160) tiếp cận người **chưa** tìm — đây là tầng tạo nhu cầu mà SEO 154/155/156 và Search 159 đều không chạm tới. Trong ngôn ngữ phễu cũ: 159 mạnh ở Conversion, Meta phủ cả Awareness → Sales trong một hệ mục tiêu.
- **Bổ sung cơ chế đo server-side:** CAPI của Meta là mẫu rõ nhất của bài học chung "đo lường phía trình duyệt đang mòn dần" (ad blocker, giới hạn cookie) — 159 đã chạm ở tầng conversion tracking/DDA, khóa này cho **kiến trúc hai đường + chống trùng event_id** cụ thể để hiểu vì sao số liệu hai nền tảng lệch nhau.
- **Bổ sung kỷ luật "mục tiêu khóa cứng":** 159 dạy đấu thầu đổi được (Smart Bidding); Meta dạy quyết định **không đảo ngược được** (objective) phải ra trước và ra đúng — hai nửa của cùng một kỷ luật ra quyết định: việc nào không sửa được thì nghĩ kỹ nhất.

### 6.3 Chi phí / lợi ích — bảng đối chiếu

|  | Google Ads Search (159) | Meta (khóa này) |
|---|---|---|
| Trả tiền cho | Mỗi lượt bấm (CPC), giá thứ hai theo Ad Rank | Phân phối theo objective/performance goal (CPM/CPC/CPA tùy goal), ngân sách campaign/ad set |
| Đòn bẩy chất lượng | Quality Score cao → CPC thấp hơn cho cùng vị trí | Tín hiệu chuyển đổi sạch (Pixel + CAPI, event_id đúng) → hệ tìm đúng người hơn, chi phí/kết quả thấp hơn (số Meta 17,8% — đọc thận trọng, §3) |
| Rủi ro chi phí | Broad match không phủ định mua traffic không mua hàng | Chọn objective/goal rẻ (Traffic cho bài toán Sales) mua đúng thứ sai rất hiệu quả; tín hiệu thưa → học nhiễu |
| Điểm dừng | Hết ngân sách, dưới ngưỡng Ad Rank không hiển thị | Hết ngân sách, objective sai phải tạo campaign mới (không sửa được) |
| Tài sản để lại | Không — tắt là mất hiển thị (159: "thuê vị trí") | Không — cùng bản chất thuê; dữ liệu sự kiện trong dataset là thứ duy nhất ở lại |

- **Kết luận chi phí/lợi ích cho team (khung, không chạy thật):** cả 159 lẫn 161 đều là **thuê vị trí**, khác SEO 154/155/156 là **tài sản** — kết luận của 159 đứng vững và mở rộng sang Meta. Với team ngân sách 0, giá trị của khóa này là **hiểu phía "theo người" của quảng cáo**: vì sao cùng một sản phẩm, Google hỏi "ai đang tìm", Meta hỏi "ai giống người mua", TikTok hỏi "video nào giữ chân" — và vì sao số chuyển đổi của ba nơi không khớp nhau (khác cửa sổ, khác mô hình credit). Bài học rẻ nhất mang về: **chọn đúng "mục tiêu + sự kiện đo" trước khi chọn định dạng** — áp dụng cho mô tả nguồn vBook (người dùng tìm truyện bằng truy vấn như 159, nhưng khám phá truyện mới qua feed/gợi ý như 161/160) mà không tốn một đồng quảng cáo.

## 7. Đề xuất áp dụng cho team (có điều kiện, chưa làm ngay)

1. **Ghi "performance goal" vào task build (đề xuất, cần chị Bẹp duyệt):** mỗi task build/research ghi rõ 1 dòng "kết quả đo được nào tính là xong" (đã có validate/device/install cho build; research có thể ghi "câu hỏi nào báo cáo phải trả lời được") — nối tiếp kỷ luật Delegation + chấm quá trình của PROTOCOL §4 và bài học "objective giới hạn thực đơn, goal quyết định người xem".
2. **Ngôn ngữ cửa sổ đo cho báo cáo (đề xuất, cần chị Bẹp duyệt):** mọi con số có cửa sổ thời gian trong báo cáo team (số nguồn registry, số task done) ghi kèm cửa sổ + thời điểm chốt — bản sao của kỷ luật attribution §4, tránh hai báo cáo đếm hai thứ khác nhau mà tưởng mâu thuẫn.
3. **Không đề xuất chạy quảng cáo Meta/TikTok thật:** team không có ngân sách, §9 cấm chạy chiến dịch thật — khóa dừng ở khung tư duy. Nếu Anh một ngày muốn thử quảng cáo cho vBook, đó là quyết định tốn tiền thuộc nhóm muse-main phải hỏi Anh theo PROTOCOL §10.

## 8. Giới hạn của khóa — đọc kỹ trước khi áp dụng

- **Không đăng nhập Meta Blueprint/Ads Manager, không làm quiz, không lấy chứng chỉ** — đúng §9; học qua mô tả Meta Business Help được trích dẫn + hướng dẫn độc lập 2026 đối chiếu chéo, không xem từng bài giảng video của khóa. Chi tiết trong bài giảng có thể sâu hơn phần tóm tắt.
- **160 chưa có báo cáo merge** (claimed 03:08 21/11, mới WIP) — đối chiếu TikTok ở §6 là mức khung theo ghi chú task 160 + dữ kiện attribution đã kiểm chứng; không suy diễn nội dung báo cáo 160.
- **Nhãn giao diện Meta đổi thường xuyên:** engage-through đổi tên 03/2026, cửa sổ view bị gỡ 01/2026, qualified leads đổi điều kiện 04/2026 — tài liệu trước các mốc này dùng tên/điều kiện cũ; khi áp dụng phải kiểm chứng bằng Meta Business Help hiện tại.
- **Số 17,8% của Meta (§3) là số do Meta công bố qua nguồn thứ cấp, không có phương pháp công khai** — chỉ dùng để hiểu hướng lợi ích của CAPI, không dùng làm dự toán.

## Nguồn đã kiểm chứng

- Danh sách 32 khóa đã duyệt (bằng chứng khóa #23, dòng 54): `research/140-governing-ai-agents-deeplearning-ai.md`
- Jon Loomer — Meta Campaign Objectives: Best Practices (ODAX 6 mục tiêu): https://www.jonloomer.com/meta-campaign-objectives-best-practices/
- Jon Loomer — How Meta Ads Attribution Works in 2026 (7-day click, 1-day engage-through, 1-day view; đổi định nghĩa 03/2026): https://www.jonloomer.com/meta-ads-attribution-2026/?amp
- Power Ads — Meta Campaign Objectives, Performance Goals and Advantage+ (cập nhật 11/2026, kiểm chứng 32 nguồn; mô hình objective/location/goal): https://powerads.group/hub/meta-campaign-objectives-performance-goals/
- Scope Design — Meta Campaign Objectives: How to Choose the Right One (rà soát 08/2026; mô hình 4 tầng, bảng bẫy từng mục tiêu): https://scopedesign.com/meta-ad-objectives-guide/
- Enrich Labs — Meta Ads Campaign Objectives Explained 2026 (6 ODAX, bảng needs tracking): https://www.enrichlabs.ai/blog/meta-ads-campaign-objectives-explained
- Voluum — Attribution Window (kiểm tra tài liệu từng nền tảng 11/2026; Meta + TikTok mặc định 7-day click/1-day view, Google 30 ngày): https://voluum.com/blog/attribution-window/
- Madgicx — How to Set Up the Conversions API (cùng Pixel ID, event_id chống trùng, Test Events): https://madgicx.com/answers/how-to-set-up-the-conversions-api
- Apzom — How to Set Up the Meta Pixel and Conversions API (dataset = Pixel, 4 đường CAPI, số 17,8% của Meta 04/2026): https://apzom.com/meta-pixel-and-conversions-api-setup/
- Variafy — Facebook lead campaign performance goals (qualified leads cần CAPI từ 04/2026): https://www.variafy.com/guides/facebook-lead-ads-performance-goal
- Đối chiếu: `research/159-google-ads-search-certification-google-skillshop.md` (đã merge); task 160 `tasks/160-tu-hoc-tiktok-academy-tiktok-for-business.json` (đang claimed, chưa merge — chỉ đối chiếu mức khung)
