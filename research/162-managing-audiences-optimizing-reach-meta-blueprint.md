# Managing audiences and optimizing reach (Meta Blueprint) — Báo cáo tự học (task 162)

- **Khóa học:** Managing audiences and optimizing reach (Meta Blueprint)
- **Trang khóa:** https://fbp.exceedlms.com/student/activity/253136-ads-targeting-course (tên nội bộ: "How to Create Audiences for FB & IG Ads Course")
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 21/11/2026
- **Trạng thái:** đã học xong, nộp review
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10: Vịt rảnh sau khi task 160 merge xong, không còn task mở). Đây là **khóa số 24 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11); bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md` dòng 55 — KHÔNG cần kiểm chứng lại từ đầu. Nối mạch quảng cáo sau 159 (Google Ads Search) → 160 (TikTok Academy) → 161 (Meta Blueprint: chọn mục tiêu chiến dịch): khóa này sang phía Meta — quản lý audience + tối ưu reach, đối chiếu với nhắm mục tiêu theo người của TikTok 160, đấu giá/attribution của 159 và chọn mục tiêu của 161: chỗ nào Meta bổ sung, chỗ nào khác hẳn, và chi phí/lợi ích ra sao (team không chạy quảng cáo thật, chỉ học khung).
- **Hình thức:** chỉ học nội dung FREE công khai; không đăng ký trả phí/chứng chỉ, không chạy chiến dịch quảng cáo thật, không nạp tiền (quy tắc tự học §9).

## Kiểm chứng danh sách 32 khóa (checklist mục 1) — ĐÃ XÁC NHẬN

Khóa **có** trong danh sách 32 khóa AI miễn phí đã duyệt: số **24** trong danh sách 32 tên đầy đủ đã lưu tại `research/140-governing-ai-agents-deeplearning-ai.md` (dòng 55): "Managing audiences and optimizing reach — Meta Blueprint".

## Ghi chú trung thực về nguồn học

- **Trang khóa chính thức đọc được phần mô tả + cấu trúc 3 bài học** (trang activity trên fbp.exceedlms.com, kiểm chứng 21/11/2026): mô tả khóa, thời lượng từng bài, rating 4.9 (22 đánh giá), trình độ Intermediate. **Nội dung video từng bài nằm sau đăng nhập** — không xem trực tiếp được, giống giới hạn của task 160 (catalog TikTok render bằng JS). Nội dung chuyên môn trong báo cáo này học qua 3 lớp nguồn, ghi rõ lớp nào là gì: (1) **Meta chính thức** — trang khóa Blueprint, trang sản phẩm Advantage+ audience của Meta for Business (số liệu 14,8%/9,7%/7,2%), bài giải thích đấu giá của Meta năm 2020 + trang Help Center "About ad auctions" hiện tại (qua các bài dẫn lại nguyên văn); (2) **hướng dẫn chuyên sâu 2026** (alenich, adplay, conversios, alexneiman, creahive, feedback-studios — đều kiểm tra lại trong tháng 10–11/2026, nhiều bài đối chiếu trực tiếp từng trang Help Center của Meta) cho phần Advantage+ audience, lookalike, overlap và attribution; (3) **bài tổng hợp/diễn đàn** cho các con số vận hành (ngưỡng overlap, ~50 chuyển đổi/tuần để học) — ghi rõ đây là quy tắc thực hành, không phải con số Meta công bố.
- **Báo cáo của task 161 chưa có lúc viết báo cáo này:** 161 (khóa số 23, "Selecting campaign objectives and conversion settings") đang do muse-1 (Ú) làm, status `claimed` — chưa merge nên chưa đọc được báo cáo của Ú. Phần đối chiếu với 161 trong §8 dựa trên **mô tả công khai của khóa 161** (catalog Blueprint: "Explore the campaign objectives in Meta Ads Manager and consider which conversion locations and performance goals are available for each objective", 16 phút, Beginner, rating 4.5) + ghi chú task 161, không phải báo cáo của Ú. Nếu muse-main muốn, đối chiếu 161 ↔ 162 có thể cập nhật khi 161 merge.
- **Không đăng ký Blueprint, không đăng nhập Ads Manager, không làm bài thi, không lấy chứng chỉ** — đúng §9 (team chỉ cần khung, không cần chứng chỉ). Chứng chỉ hoàn thành khóa (Credential for Completion) là thông tin trên trang khóa, không phải trải nghiệm trực tiếp.
- **Số liệu chi phí/lợi ích của Meta (14,8%/9,7%/7,2%) là số Meta tự công bố** về các chiến dịch của họ, không phải dự báo cho tài khoản nào — đọc như tuyên bố của nhà cung cấp, không phải đo lường độc lập. Các con số "giảm 32% CPA" lưu hành trên blog tổng hợp **không có nguồn Meta trace được** — báo cáo này không dùng.

## Cấu trúc khóa — 3 bài học, 27 phút

| Bài học | Thời lượng | Nội dung theo mô tả chính thức |
|---|---|---|
| **Exploring audience creation options** | 15 phút | Các loại audience trong Meta Ads Manager và cách tạo |
| **Finding your audience with Meta Advantage+** | 7 phút | Tìm audience bằng Meta Advantage+ |
| **Managing audience overlap** | 5 phút | Quản lý chồng lấn audience |

Khóa thuộc path **"Your guide to audience strategy"** trên Meta Blueprint (cùng path với "Defining your ad audience" 31 phút, "Create audiences in Meta Ads Manager" 15 phút, "Privacy controls and brand safety" 14 phút...). Mô tả chính thức: *"This course provides guidance on how to create audiences in Meta Ads Manager. It explores how to optimize reach and performance using Meta Advantage+ and how to manage audience overlap."*

## 1. Ba loại audience — ai là ai trong Ads Manager

Meta chia audience thành ba họ, cộng thêm chế độ broad/Advantage+ (§2). Đây là xương sống của bài học 1.

| Loại | Là ai | Tạo từ đâu | Dùng khi nào |
|---|---|---|---|
| **Core audience (Saved audience)** | Người chưa biết mình, chọn theo thuộc tính | Tuổi, vị trí, giới tính, ngôn ngữ + sở thích (detailed targeting: interests, behaviors, demographics) | Mới bắt đầu, chưa có dữ liệu khách hàng |
| **Custom audience** | Người đã tương tác với mình | Website (Meta Pixel + Conversions API: PageView, AddToCart, Purchase...), app, danh sách khách hàng (email/SĐT đã hash), video engagement (xem 50%/75%...), lead form, tương tác Page/Instagram | Retargeting, loại trừ, và làm **nguồn (seed) cho lookalike** |
| **Lookalike audience** | Người mới giống khách hàng hiện tại | Từ một custom audience nguồn; Meta so sánh người trong nguồn với toàn bộ dân số khu vực và tìm người tương tự nhất | Tìm khách mới (prospecting) giống khách tốt nhất |

### 1.1 Lookalike — con số cần nhớ

- **Kích thước 1%–10% dân số** của khu vực đã chọn: 1% giống nguồn nhất, pool nhỏ nhất, khả năng chuyển đổi cao nhất; 2–5% cân bằng reach/similarity; 6–10% rộng nhất, gần như broad targeting có gợi ý dữ liệu. Quy tắc thực hành: bắt đầu 1%, chỉ mở rộng khi tần suất tăng và hiệu quả giảm (dấu hiệu pool đã hết người mới).
- **Nguồn tối thiểu 100 người** từ một quốc gia (Meta không cho tạo dưới ngưỡng này); **khuyến nghị 1.000–5.000 người** để lookalike làm việc tốt. Nguồn càng sạch càng tốt: danh sách khách có giá trị mua (value-based lookalike, cần cột giá trị) > người mua gần đây qua Pixel > toàn bộ khách truy cập web. **Lookalike không bao giờ tốt hơn danh sách nguồn** — câu này quyết định chất lượng.
- **Không tạo lookalike từ lookalike khác;** nguồn phải là custom audience (hoặc Pixel/app/Page). Lookalike được **làm mới mỗi 3 ngày** (theo tài liệu developer của Meta) nên không cần tạo lại hàng tuần. Từ 2026, khi tạo lookalike không còn chọn quốc gia riêng — Meta dùng vị trí của ad set chứa nó.
- **Advantage+ lookalike** (tên cũ: lookalike expansion): Meta tự động bật cho chiến dịch mới/nhân bản/nháp dùng lookalike từ website, app hoặc danh sách khách — cho phép vượt quá % đã chọn khi dự đoán hiệu quả tốt hơn.

### 1.2 Custom audience — dữ liệu của mình là tài sản

Custom audience là cầu nối giữa dữ liệu mình có và hệ thống Meta: Pixel + Conversions API gửi sự kiện web từ trình duyệt/server; danh sách khách hàng upload (email/SĐT đã hash, Meta khớp rồi xóa dạng gốc); video engagement và tương tác trang. Chất lượng của custom audience quyết định trực tiếp hai thứ: **retargeting có trúng người thật không**, và **lookalike có giống khách tốt không**. Meta cho biết nhà quảng cáo có Conversions API cho sự kiện web thấy **chi phí mỗi kết quả thấp hơn trung bình 17,8%** so với nhóm không có (số của Meta, tháng 04/2026 — đọc như tuyên bố của nhà cung cấp).

## 2. Advantage+ audience — từ "chọn người" sang "gợi ý cho máy chọn"

Đây là thay đổi lớn nhất của Meta trong 2 năm qua, và là trọng tâm bài học 2.

### 2.1 Gợi ý (suggestion) vs giới hạn cứng (control)

- **Advantage+ audience là mặc định** cho chiến dịch Sales, Leads, App mới tạo từ 2025: trong phần audience của ad set, tuổi, giới tính, custom audience và lookalike mà bạn nhập vào trở thành **gợi ý**, hệ thống được phép vượt ra ngoài khi dự đoán hiệu quả tốt hơn. Chỉ còn **4 thứ là giới hạn cứng** mà hệ thống không được vi phạm: **vị trí (location), tuổi tối thiểu, ngôn ngữ, và custom audience bị loại trừ**.
- Nếu bạn biến một gợi ý thành giới hạn cứng (ví dụ khóa chặt độ tuổi hoặc giới tính), chiến dịch **không còn là Advantage+ đầy đủ** — Meta nói rõ điều này trong Help Center (qua Jon Loomer).
- **Detailed targeting đã bị hạ cấp:** Meta đã gộp/xóa nhiều nhóm sở thích từ 23/06/2025, đợt xóa có hiệu lực **15/01/2026** (theo Social Media Today); các ad set còn dùng interest đã xóa thì **dừng phân phối**. **Loại trừ theo sở thích/hành vi (detailed targeting exclusions) đã bị xóa hẳn** — giờ chỉ loại trừ được bằng custom audience. Vì vậy detailed targeting còn lại là **tín hiệu khởi đầu**, không phải hàng rào.

### 2.2 Số liệu Meta công bố — và cách đọc cho đúng

| Mục tiêu chiến dịch | Chi phí mỗi kết quả thấp hơn (theo Meta) |
|---|---|
| Awareness | **14,8%** |
| Traffic, Engagement, Leads | **9,7%** |
| Sales, App promotion | **7,2%** |

- Meta dùng từ "could" (có thể) và công bố ở độ tin cậy 99,9% trên các chiến dịch của họ. **Đọc đúng:** càng cho hệ thống nhiều không gian (mục tiêu càng rộng) thì lợi ích càng lớn — 14,8% ở đầu phễu, 7,2% ở cuối phễu. **Đọc sai:** coi đây là cam kết giảm CPA cho tài khoản của mình. Như task 160 đã cảnh báo về TikTok: Advantage+ có thể hạ CPA báo cáo bằng cách tìm người **đã gần chuyển đổi sẵn**, chứ không chứng minh tạo ra nhu cầu mới — muốn biết tăng trưởng thật phải test có nhóm đối chứng (holdout/A-B test). Meta **khuyến nghị A/B test Advantage+ audience cho gần như mọi loại chiến dịch, trừ retargeting**.
- **Không dùng được:** chiến dịch thuộc Special Ad Category (nhà ở, việc làm, tài chính, chính trị/vấn đề xã hội) không có Advantage+ audience.

### 2.3 Vì sao Meta làm vậy — Andromeda

Tháng 12/2024 Meta công bố **Andromeda**, hệ thống retrieval AI mới cho quảng cáo: mô hình có dung lượng gấp **10.000 lần** thế hệ trước, cải thiện **6% recall và 8% chất lượng quảng cáo** trên các phân đoạn thử nghiệm (theo Engineering at Meta). Andromeda đọc creative (hình ảnh, chủ đề, hook, ngôn ngữ) để quyết định quảng cáo phù hợp với ai — nghĩa là **creative giờ là targeting**. Đây là cùng một xu hướng như TikTok 160 §5 (creative là đòn bẩy) và Google 159 (Quality Score): cả ba nền tảng đều chuyển việc "tìm đúng người" từ tay người quảng cáo sang thuật toán + creative.

### 2.4 Khi nào vẫn nhắm tay

Theo các hướng dẫn 2026 (đồng thuận giữa nhiều nguồn độc lập): dùng Advantage+ khi đã có **~30–50 chuyển đổi/tuần/ad set** để thuật toán học và ngân sách trên ~50 USD/ngày; dùng detailed targeting tay khi tài khoản mới (< 50 chuyển đổi/tuần), thị trường rất ngách, chiến dịch siêu địa phương, hoặc ngân sách dưới ~30 USD/ngày (AI không đủ dữ liệu để học). Ngân sách gợi ý thực hành: **75–95% prospecting, 5–20% retargeting, 2–5% khách cũ** — là khuyến nghị của tác giả hướng dẫn, không phải quy định của Meta.

## 3. Đấu giá Meta — cùng một công thức, khác bối cảnh với Google/TikTok

- **Công thức Total Value (Meta giải thích năm 2020):** `Total Value = Bid × Estimated Action Rate + Ad Quality`. Trang Help Center hiện tại ("About ad auctions") chỉ liệt kê 3 yếu tố mà **không công bố công thức**: bid (số tiền sẵn sàng trả cho kết quả mong muốn), estimated action rates (xác suất hiển thị này dẫn tới kết quả mong muốn cho **người cụ thể đó**), ad quality (phản hồi người xem/ẩn quảng cáo + kiểm tra thuộc tính chất lượng thấp như giấu thông tin, ngôn ngữ giật gân, engagement bait). **Người thắng là quảng cáo có total value cao nhất**, nhưng phải vượt price floor (giá sàn) — và giá trả thực tế không bằng giá thầu vì Meta dùng đấu giá kiểu Vickrey–Clarke–Groves (VCG), tương tự giá thứ hai của Google/TikTok: **trả mức tối thiểu đủ để thắng, không trả giá mình đặt**.
- **Khác Google (159) ở chỗ:** Google đấu giá theo **từng lượt tìm kiếm** (có truy vấn); Meta đấu giá theo **từng lần hiển thị** khi người dùng mở app — không có truy vấn, nên estimated action rate dự đoán theo **người**, không theo từ khóa. Giống TikTok 160 §3: cùng một quảng cáo, eCPM/total value khác nhau giữa các người dùng.
- **Learning phase:** ad set cần đủ dữ liệu để ổn định — ngưỡng thực hành ~50 chuyển đổi/tuần (theo hướng dẫn 2026). Meta liệt kê **auction overlap cao** là một trong các lý do ad set rơi vào trạng thái **learning limited** và khuyên **gộp các ad set giống nhau** — nối thẳng sang §5 về overlap.
- **Điểm mấu chốt nối 159/160/162:** cả ba nền tảng đều dùng cùng một nguyên tắc — *người trả cao nhất không tự thắng; chất lượng + xác suất hành động quyết định*. Trên Google chất lượng là Quality Score theo từ khóa; trên TikTok là Ad Quality Score trong eCPM; trên Meta là ad quality trong total value. **Chất lượng creative là tiền ở cả ba nơi.**

## 4. Tối ưu reach — reach, frequency và hai cách mua

"Reach" trong khóa này có hai nghĩa cần tách: **reach = số người khác nhau đã thấy quảng cáo** (khác impressions = tổng số lần hiển thị, một người có thể thấy nhiều lần), và **tối ưu reach = làm sao chạm được nhiều người đúng nhất với ngân sách cho trước**.

### 4.1 Các đòn bẩy reach trong chế độ đấu giá (auction buying, mặc định)

| Đòn bẩy | Tác dụng lên reach |
|---|---|
| **Advantage+ audience (mở rộng pool)** | Pool đủ lớn để thuật toán học và tìm người mới; audience quá hẹp = hết người để hiển thị, CPM tăng |
| **Advantage+ placements** | Cho phép hiển thị trên toàn bộ vị trí (Feed, Stories, Reels, Marketplace...) thay vì khóa một vị trí — nhiều inventory hơn = reach rộng hơn, CPM rẻ hơn |
| **Advantage campaign budget** (tên cũ: CBO) | Ngân sách cấp campaign, Meta tự phân bổ sang ad set đang hiệu quả — tránh ad set tốt bị hết tiền trong khi ad set kém còn dư |
| **Mục tiêu Reach (Awareness)** | Tối ưu trực tiếp cho số người tiếp cận thay vì chuyển đổi — dùng khi mục tiêu là phủ sóng |
| **Creative đa dạng** | Andromeda dùng creative để tìm người (§2.3): nhiều creative khác nhau = nhiều "cửa" vào các nhóm người khác nhau |

### 4.2 Reach and Frequency buying — mua như mua TV

Ngoài đấu giá, Meta có cách mua **Reach and Frequency** (đặt trước, reservation): nhà quảng cáo **dự đoán được reach và kiểm soát được frequency** (số lần trung bình một người thấy quảng cáo trong một khoảng thời gian) trước khi chạy — giống mua quảng cáo TV. Dùng khi cần phủ sóng chắc chắn cho một chiến dịch ra mắt/sự kiện, chấp nhận trả giá cố định thay vì đấu giá theo thời gian thực. Bài học "Reach and Frequency Campaigns" trong catalog Blueprint mô tả đúng điểm này: *"predictably reach a significant number of people in your target audience and control message frequency"*.

### 4.3 Frequency — kẻ thù thầm lặng của reach

- **Frequency = impressions / reach.** Frequency tăng nghĩa là cùng một người thấy quảng cáo lặp lại — reach ngừng tăng dù ngân sách vẫn tiêu. Dấu hiệu audience đã cạn: frequency leo thang + hiệu quả giảm → lúc đó mới mở rộng lookalike (§1.1) hoặc làm mới creative, không phải tăng ngân sách vào cùng một pool.
- **Creative fatigue** (quảng cáo mệt) là cùng một hiện tượng nhìn từ phía creative: TikTok 160 §8.4 đã ghi "hết ngân sách, creative mệt → phải làm mới liên tục" — trên Meta cũng vậy, chỉ khác là frequency đo được trực tiếp trong Ads Manager.

## 5. Quản lý audience overlap — đừng tự đấu giá với chính mình

Trọng tâm bài học 3 (5 phút nhưng là phần thực hành nhất của khóa).

### 5.1 Overlap là gì và vì sao tốn tiền

Overlap = tỉ lệ người **đồng thời đủ điều kiện** cho hai ad set/audience trở lên. Khi hai ad set của mình cùng nhắm một người, cả hai cùng tham gia đấu giá cho cùng một lần hiển thị — **mình tự đẩy giá của mình lên** (self-competition), CPM tăng, và thuật toán khó học vì dữ liệu chuyển đổi bị chia nhỏ giữa các ad set trùng nhau. Các nguồn 2026 ước tính overlap không kiểm soát có thể cộng **15–30% vào CPM tổng** (số của agency audit, không phải số Meta — đọc như ước tính thực hành).

Các cặp hay chồng nhất: (a) lookalike 1% vs lookalike 2–3% cùng một nguồn (1% nằm gọn trong 2–3% nếu tạo dạng dải từ 0%); (b) lookalike người mua vs custom audience khách truy cập web (người giống khách mua thì cũng hay vào web); (c) prospecting broad/Advantage+ vs retargeting khách truy cập web — nếu không loại trừ, prospecting sẽ hiển thị cho cả người ấm mà retargeting đang nhắm.

### 5.2 Công cụ Audience Overlap — cách dùng

1. Mở Ads Manager → **Audiences** (không nằm trong campaign nào).
2. Tick chọn **2–5 audience** (một số nguồn 2026 nói tối đa 10; Jon Loomer ghi tối đa 5 — con số thay đổi theo phiên bản giao diện, kiểm chứng lại trong tài khoản của mình).
3. Menu ba chấm / **Actions → Show Audience Overlap**. Meta vẽ biểu đồ Venn: audience chọn đầu tiên làm baseline, con số hiển thị là % của baseline cũng có trong audience so sánh.
4. **Giới hạn:** chỉ so sánh được saved/custom/lookalike audience; mỗi audience phải đủ lớn mới đo được — Jon Loomer ghi ngưỡng **1.000 người**, nguồn 2026 mới hơn ghi **10.000 tài khoản Accounts Center** (hai con số khác nhau, chưa đối chiếu được — ghi rõ để muse-main biết, không chọn một con số làm chắc chắn). Công cụ **không thấy** phần mở rộng của Advantage+ audience (vì expansion vượt ra ngoài audience đã định nghĩa), và con số là **ước tính từ mô hình reach của Meta, không phải đếm impression thật**.

### 5.3 Cách sửa — theo thứ tự ưu tiên

| Vấn đề | Cách sửa |
|---|---|
| Prospecting chạm cả người ấm | **Loại trừ bằng custom audience** trong mọi ad set prospecting: người mua 180 ngày, bắt đầu checkout 30 ngày, thêm giỏ hàng 30 ngày, khách truy cập web 30 ngày (nếu có retargeting riêng). Đây là loại trừ còn lại sau khi Meta xóa detailed targeting exclusions (§2.1) |
| Hai tầng lookalike chồng nhau | Chỉ chạy một dải (ví dụ 0–3%) hoặc tạo tầng 1–3% loại trừ tầng 1%; đừng chạy 1%, 2%, 3% riêng lẻ cùng lúc |
| Nhiều ad set giống nhau, learning limited | **Gộp ad set** — Meta khuyên trực tiếp (xem §3); ít ad set hơn, mỗi cái đủ dữ liệu học |
| Không đo được overlap | Lưu nhóm interest quan trọng thành saved audience rồi mới so sánh; với Advantage+ audience thì dựa vào loại trừ + cấu trúc campaign thay vì công cụ đo |

- **Ngưỡng hành động (quy tắc thực hành, KHÔNG phải ngưỡng Meta công bố):** < 15–20% giữa prospecting và retargeting thì chấp nhận, theo dõi; 20–40% thì thêm loại trừ ở lần rà soát tới; > 40% thì cấu trúc lại ngay. Giữa hai tầng lookalike prospecting thì 30–50% là bình thường, ưu tiên sửa thấp hơn — vì đó không gây méo attribution như chồng prospecting–retargeting.

## 6. Đo lường — attribution mặc định giống TikTok, khác Google

- **Mặc định của Meta: 7-day click + 1-day view + 1-day engaged view** (Standard attribution). Nghĩa là: chuyển đổi được tính nếu xảy ra trong 7 ngày sau khi bấm link quảng cáo, hoặc 1 ngày sau khi xem (không bấm), hoặc 1 ngày sau tương tác (với video: xem 5 giây trở lên — từ tháng 03/2026 Meta đổi tên thành engage-through và tính cả click không phải link). Tùy chỉnh được từng ad set: click 1 hoặc 7 ngày; view 1 ngày hoặc tắt; engaged-view 1 ngày hoặc tắt. Từ 12/01/2026 Meta **ngừng trả cửa sổ 7-day view và 28-day view** trong Ads Insights API — báo cáo cũ dùng cửa sổ này sẽ không khớp số mới.
- **So sánh ba nền tảng:** Meta và TikTok **cùng mặc định 7-day click / 1-day view** (160 §7) — trùng nhau hoàn toàn; Google Ads mặc định **30 ngày sau click** (theo từng conversion action) và dùng DDA làm mô hình mặc định (159 §5). Hệ quả: cùng một hành trình mua, ba nền tảng báo ba con số khác nhau — **không bên nào nói sai, chúng đo khác nhau**. Đọc báo cáo Meta thì dùng **Compare Attribution Settings** (menu Columns trong Ads Manager) để xem cùng một ad set dưới các cửa sổ khác nhau trước khi kết luận.
- **Attribution setting vừa là báo cáo vừa là tối ưu:** Meta tối ưu phân phối theo đúng cửa sổ bạn chọn — đổi cửa sổ giữa chừng thì thuật toán học trên tín hiệu khác, báo cáo đứt quãng. Cùng cảnh báo như 159 §5 và 160 §7: **đừng đổi định nghĩa đo giữa chừng rồi so sánh trước–sau như thể cùng một thước đo**.

## 7. Đối chiếu với 159 / 160 / 161 — Meta bổ sung gì, khác hẳn chỗ nào

### 7.1 Ba nền tảng, ba cách "tìm người"

|  | Google Ads Search (159) | TikTok Ads (160) | Meta Ads (khóa này) |
|---|---|---|---|
| Người dùng đang làm gì | **Đã biết mình muốn gì**, gõ truy vấn | **Chưa biết mình muốn gì**, đang cuộn feed | **Đang lướt mạng xã hội**, xem bạn bè/nội dung |
| Tín hiệu đấu giá chính | Truy vấn + Quality Score theo từ khóa | Người dùng + Estimated Action Rate + chất lượng creative | Người dùng + Estimated Action Rate + ad quality (total value) |
| Đơn vị đấu giá | Mỗi lượt tìm kiếm | Mỗi lần hiển thị | Mỗi lần hiển thị |
| Nhắm mục tiêu là gì | **Từ khóa** (broad/phrase/exact) | **Con người** (sở thích/hành vi/dữ liệu) + creative | **Con người + dữ liệu của mình** (custom/lookalike) rồi giao cho AI mở rộng |
| Đơn vị thử nghiệm | Tổ hợp tiêu đề RSA | 3 giây đầu của video | Creative + audience suggestion (A/B test Advantage+ vs manual) |
| Attribution mặc định | 30 ngày click, DDA | 7-day click / 1-day view | 7-day click / 1-day view / 1-day engaged view |
| Đích đến sau bấm | Website của nhà quảng cáo | TikTok Shop trong app (đang đóng kín) | Website/app hoặc ở lại trong Meta (lead form, nhắn tin) |

### 7.2 Chỗ nào Meta bổ sung cho search và TikTok

| Bổ sung | Vì sao |
|---|---|
| **Dữ liệu khách hàng của mình làm xương sống** | Google dùng từ khóa, TikTok dùng hành vi trên nền tảng; Meta cho phép **đưa danh sách khách thật vào** (custom audience) rồi nhân bản thành lookalike — đây là cách duy nhất trong ba nền tảng biến "khách đã có" thành "khách mới giống hệt" một cách có hệ thống |
| **Retargeting có cấu trúc rõ nhất** | Custom audience theo sự kiện (xem web, thêm giỏ, mua) + loại trừ lẫn nhau giữa prospecting/retargeting (§5.3) tạo thành phễu có ranh giới rõ ràng; TikTok cũng có custom audience nhưng khóa 160 nhấn mạnh khám phá hơn là phễu |
| **Reach có thể mua chắc chắn** | Reach and Frequency buying (§4.2) cho phép **đặt trước reach + frequency** như mua TV — Google và TikTok không có sản phẩm tương đương ở self-serve |
| **Attribution trùng TikTok, đối chiếu được trực tiếp** | Cùng mặc định 7-day click/1-day view nên số liệu Meta và TikTok so sánh được với nhau (cùng thước đo), trong khi Google dùng thước khác — hữu ích khi team đọc báo cáo đa kênh |

### 7.3 Chỗ nào khác hẳn (không phải bổ sung, mà là khác loại)

- **Nhắm mục tiêu đã đổi chủ:** trên Google, người quảng cáo vẫn **nắm** từ khóa (match types, 159 §2); trên Meta 2026, người quảng cáo chỉ còn **gợi ý** — detailed targeting là hint, chỉ location + tuổi tối thiểu là cứng. Đây là bước xa hơn cả TikTok: TikTok vẫn cho chọn interest/hành vi làm xương sống ad group (160 §2), Meta đã biến chúng thành gợi ý. Người làm quen với "chọn tay từng interest" chuyển sang Meta phải **bỏ thói quen siết audience** và học cách **giao tín hiệu tốt** (seed sạch, conversion data đầy đủ, creative rõ đối tượng).
- **Overlap là vấn đề riêng của Meta:** Google không có "hai ad group cùng nhắm một người" theo nghĩa này (từ khóa khác nhau thì đấu giá khác nhau, có cơ chế ưu tiên nội bộ); TikTok cũng ít gặp vì targeting theo người + creative. Trên Meta, overlap là **lỗi cấu trúc tài khoản** phải quản lý chủ động bằng công cụ + loại trừ + gộp ad set (§5).
- **Reach không còn là "mua hiển thị", mà là "mở pool":** trên Google, reach tăng bằng cách thêm từ khóa/mở match type; trên Meta, reach tăng bằng cách **bớt siết audience** (mở Advantage+, gộp ad set, đa dạng creative) — ngược trực giác của người quen nhắm tay: **càng siết càng ít reach, càng đắt**.
- **Mục tiêu 161 → audience 162 là một cặp không tách được:** 161 (chọn mục tiêu + conversion settings) quyết định **tối ưu cho hành động nào**; 162 quyết định **ai được thấy quảng cáo** và **chạm được bao nhiêu người**. Sai mục tiêu thì audience tốt cũng tối ưu sai hành động; sai audience thì mục tiêu đúng cũng không có người để hiển thị. Hai khóa này là hai nửa của cùng một ad set.

### 7.4 Chi phí / lợi ích — bảng đối chiếu bốn phía

|  | SEO tự nhiên (154/155/156) | Quảng cáo tìm kiếm (159) | Quảng cáo TikTok (160) | Quảng cáo Meta (khóa này) |
|---|---|---|---|---|
| Chi phí trực tiếp | Công sức; ~0/ lượt bấm | Trả mỗi lượt bấm (CPC) | Trả mỗi 1.000 hiển thị / lượt xem / bấm + chi phí sản xuất video | Trả mỗi 1.000 hiển thị / kết quả + chi phí dữ liệu (Pixel/CAPI) |
| Thời gian thấy kết quả | Chậm (tuần–tháng), ổn định | Ngay khi bật | Ngay khi bật, cần learning phase | Ngay khi bật, cần ~50 chuyển đổi/tuần để học |
| Rủi ro chi phí | Chọn sai từ khóa → mất thời gian | Broad match không kiểm soát → mua traffic rác | Creative dở → đấu giá thua dù trả cao | Overlap không quản → tự đấu giá với mình, CPM +15–30%; siết audience quá → hết reach, CPM tăng |
| Đòn bẩy chất lượng | Backlink + topical authority + on-page | Quality Score cao → CPC thấp | Creative tốt → eCPM cao → trả ít hơn | Creative tốt + seed sạch → total value cao + Advantage+ rẻ hơn 7–15% (số Meta) |
| Đo lường | Search Console, thứ hạng | Conversion tracking, ROAS/CPA, DDA vs Last-Click | Pixel + Events API, 7-day click/1-day view | Pixel + CAPI, 7-day click/1-day view/1-day engaged view, Compare Attribution Settings |
| Điểm dừng | Nội dung tốt ở lại | Hết ngân sách, Quality Score quá thấp | Hết ngân sách, creative mệt | Hết ngân sách, audience cạn (frequency tăng), overlap cao |

- **Kết luận chi phí/lợi ích cho team (khung, không chạy thật):** nếu SEO là **tài sản**, Google Ads là **thuê vị trí trên trang kết quả** (159), TikTok Ads là **thuê sự chú ý trong feed** (160), thì Meta Ads là **thuê quyền tiếp cận đúng người trong mạng xã hội — bằng dữ liệu khách hàng của mình**. Giá trị riêng của Meta với team (ngân sách quảng cáo 0) là **hiểu phía dữ liệu của cùng một người dùng**: cùng một người vừa gõ Google tìm truyện (ý định), vừa cuộn TikTok thấy video giới thiệu truyện (khám phá), vừa là "người giống độc giả hiện tại" mà Meta có thể tìm ra từ danh sách — ba cách nhìn một người, và khóa này cho thấy cách thứ ba vận hành.

## 8. Đề xuất áp dụng cho team (có điều kiện, chưa làm ngay — cần chị Bẹp duyệt)

1. **Tư duy "seed" cho mô tả nguồn vBook (đề xuất, cần chị Bẹp duyệt):** nối tiếp đề xuất 160 §9.1 (BookTok vào mô tả nguồn): Meta dạy rằng **chất lượng nguồn quyết định chất lượng mở rộng** — lookalike không tốt hơn seed. Khi viết mô tả nguồn, thay vì liệt kê chung chung, ghi rõ **"độc giả mẫu" của nguồn là ai** (đọc thể loại gì, theo tác giả nào, ở cộng đồng nào) — cùng dữ liệu mô tả, nhưng viết theo logic "người giống người" thay vì chỉ logic từ khóa (159 §7.1). Không tốn tiền, chỉ đổi cách viết.
2. **Quy tắc "đừng siết, hãy gợi ý" cho mọi thử nghiệm của team (đề xuất, cần chị Bẹp duyệt):** bài học lớn nhất của khóa này là càng siết audience càng ít reach và càng đắt — tương tự, khi team thử nghiệm (nguồn mới, cách viết mô tả mới), **đừng siết điều kiện thử quá chặt** (quá ít mẫu, quá nhiều tiêu chí) rồi kết luận "không hiệu quả". Mở rộng mẫu thử, ghi rõ tín hiệu đầu vào (seed là gì), rồi mới đọc kết quả — mượn trực tiếp logic Advantage+ audience (§2).
3. **Checklist "overlap" cho lịch đăng/bài viết của team (đề xuất, cần chị Bẹp duyệt):** Meta quản overlap vì hai ad set cùng nhắm một người thì tự đẩy giá nhau. Team cũng có dạng overlap riêng: **nhiều bài viết/mô tả cùng nhắm một từ khóa/độc giả** thì tự cạnh tranh nhau trong kết quả tìm kiếm (cannibalization — đã gặp ở SEO 154/155/156). Trước khi viết mô tả nguồn mới, kiểm tra xem đã có mô tả nào cùng nhắm độc giả đó chưa; nếu có, gộp hoặc phân biệt rõ — cùng một nguyên tắc "một audience, một chủ sở hữu" của §5.3.
4. **Không đề xuất chạy quảng cáo thật:** team không có ngân sách quảng cáo, không có nhu cầu chứng chỉ, và §9 cấm chạy chiến dịch thật. Nếu Anh một ngày muốn thử quảng cáo cho vBook/extension, đó là quyết định mới mang ra hỏi Anh (tốn tiền — thuộc nhóm muse-main phải hỏi theo PROTOCOL §10).

## 9. Giới hạn của khóa — đọc kỹ trước khi áp dụng

- **Không đăng ký Blueprint, không đăng nhập Ads Manager, không làm bài thi, không lấy chứng chỉ** — đúng §9; nội dung từng video bài giảng (15'/7'/5') không xem trực tiếp được (sau đăng nhập), chi tiết trình bày trong video có thể sâu hơn phần tóm tắt — ghi rõ để muse-main chấm review biết giới hạn.
- **Báo cáo task 161 chưa merge** nên đối chiếu 161 ↔ 162 (§7.3 cuối) dựa trên mô tả công khai của khóa 161, chưa đối chiếu với báo cáo của Ú — có thể cập nhật khi 161 merge.
- **Nền tảng thay đổi nhanh:** đợt xóa/gộp detailed targeting có hiệu lực 15/01/2026; Advantage+ audience thành mặc định từ 2025; Andromeda công bố 12/2024; cửa sổ attribution 7-day/28-day view ngừng trả từ 12/01/2026. Tài liệu trước các mốc này dùng tên/quy tắc cũ (ví dụ "lookalike expansion" nay là "Advantage+ lookalike", "CBO" nay là "Advantage campaign budget") — khi áp dụng phải kiểm chứng bằng Meta Ads Help hiện tại, không tin tài liệu cũ.
- **Hai con số chưa đối chiếu được:** ngưỡng tối thiểu của công cụ Audience Overlap (1.000 người theo Jon Loomer vs 10.000 tài khoản Accounts Center theo nguồn 2026) và số ad set so sánh tối đa (5 vs 10) — ghi rõ trong §5.2, cần kiểm chứng trong tài khoản thật trước khi dùng làm quy trình.
- **Số liệu của Meta (14,8%/9,7%/7,2%; CAPI −17,8%) và ước tính agency (overlap +15–30% CPM; ~50 chuyển đổi/tuần; ngân sách 75–95/5–20/2–5) là số của nhà cung cấp/nguồn thứ cấp**, không phải đo lường độc lập — chỉ dùng để hiểu cơ chế và thứ bậc, không dùng làm dự toán ngân sách hay cam kết hiệu quả.
- **Số liệu khảo sát hành vi và chi phí trong các nguồn thứ cấp là của thị trường Mỹ/châu Âu là chính** — không suy ra trực tiếp cho người dùng Việt Nam hay độc giả truyện của team.

## Nguồn đã kiểm chứng

- Danh sách 32 khóa đã duyệt (bằng chứng khóa #24, research/140 dòng 55): `research/140-governing-ai-agents-deeplearning-ai.md`
- Meta Blueprint — Managing audiences and optimizing reach (trang khóa chính thức, 27 phút, 3 bài học, Intermediate, 4.9/22 đánh giá; mô tả khóa + tên nội bộ "How to Create Audiences for FB & IG Ads Course"): https://fbp.exceedlms.com/student/activity/253136-ads-targeting-course
- Meta Blueprint — Your guide to audience strategy (path chứa khóa này + các khóa liên quan): https://fbp.exceedlms.com/student/catalog/list?category_ids=7506-your-guide-to-audience-strategy
- Meta for Business — Advantage+ audience (số liệu 14,8%/9,7%/7,2% chi phí mỗi kết quả thấp hơn, theo mục tiêu): https://www.facebook.com/business/ads/meta-advantage-plus/audience
- Meta — Andromeda (Engineering at Meta, 12/2024; mô hình dung lượng gấp 10.000 lần, +6% recall, +8% ad quality): https://engineering.fb.com/2024/12/02/production-engineering/meta-andromeda-advantage-automation-next-gen-personalized-ads-retrieval-engine/
- Meta Business Help Center — About ad auctions / About Advantage+ audience / About attribution models and attribution settings (đọc qua các bài dẫn lại nguyên văn, kiểm tra 10–11/2026): xem các nguồn dưới
- Meta Ads targeting 2026 (Advantage+ audience mặc định, chỉ location + tuổi tối thiểu là cứng, xóa detailed targeting 15/01/2026, ~30–50 chuyển đổi/tuần để học): https://www.alenich.com/blog/facebook-ads-targeting
- Broad vs Detailed Targeting on Meta 2026 (detailed targeting là gợi ý, Andromeda, Advantage+ audience vs Advantage+ sales): https://adplay.ai/blog/broad-vs-detailed-targeting
- Meta Advantage+ Audience vs Detailed Targeting 2026 (xóa/gộp interest 23/06/2025 → 15/01/2026, loại trừ detailed targeting đã xóa): https://www.conversios.io/blog/meta-advantage-audience-vs-detailed-targeting-2026-guide/
- Advantage+ Audience 2026 (số liệu Meta 14,8/9,7/7,2 ở độ tin cậy 99,9%; cảnh báo số "giảm 32% CPA" không có nguồn): https://alexneiman.com/meta-advantage-plus-audience-vs-detailed-targeting-2026/
- Meta Advantage+ audience — Help Center giải thích (gợi ý vs giới hạn cứng, A/B test trừ retargeting, Special Ad Category): https://www.creahive.com/guides/meta-advantage-plus-audience/ và https://adwize.ai/blog/meta-advantage-plus-audience
- Meta Advantage+ explained (4 trang Help Center đọc 04/11/2026; CAPI −17,8% chi phí mỗi kết quả): https://feedback-studios.com/guides/meta-advantage-plus/
- Facebook Lookalike Audiences 2026 (nguồn 1%–10%, tối thiểu 100 người, khuyến nghị 1.000–5.000, custom audience làm seed): https://www.alenich.com/blog/facebook-lookalike-audiences và https://www.searchthetrend.com/blog/lookalike-audiences
- Meta Ads Audience Overlap (công cụ Audiences → Actions → Show Audience Overlap; ngưỡng thực hành 15/25/40%; loại trừ bằng custom audience; gộp ad set): https://adplay.ai/blog/facebook-audience-overlap, https://myseoexperts.com/meta-audience-overlap/, https://www.adsx.com/blog/meta-ads-audience-exclusions-overlap-shopify, https://www.jonloomer.com/facebook-audience-overlap/amp/
- Meta Ads Attribution Setting (mặc định 7-day click/1-day view/1-day engaged view; click 1/7 ngày, view 1 ngày hoặc tắt; Compare Attribution Settings): https://www.jonloomer.com/meta-ads-attribution-setting-a-complete-guide/amp/ và https://www.jonloomer.com/meta-ads-attribution/
- Attribution windows 2026 (Meta + TikTok mặc định 7-day click/1-day view; Meta ngừng trả 7-day/28-day view từ 12/01/2026; engage-through từ 03/2026): https://voluum.com/blog/attribution-window/
- Meta ad auction (Total Value = bid × estimated action rate + ad quality theo giải thích Meta 2020; trang Help Center hiện tại liệt kê 3 yếu tố không công bố công thức; VCG): https://terrads.com/blog/meta-ad-auction và https://www.omneky.com/blog/how-do-facebook-ads-work
- Khóa 161 để đối chiếu (catalog Blueprint: Selecting campaign objectives, 16 phút, Beginner, 4.5): https://fbp.exceedlms.com/student/collection/606095-agency-online-learning-catalog
- Đối chiếu SEO + Google Ads + TikTok: `research/154-on-page-seo-ai-search-essentials-semrush.md`, `research/155-google-seo-fundamentals-uc-davis.md`, `research/156-seo-course-for-beginners-ahrefs.md`, `research/159-google-ads-search-certification-google-skillshop.md`, `research/160-tiktok-academy-tiktok-for-business.md`
