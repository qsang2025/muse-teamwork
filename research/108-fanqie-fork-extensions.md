# Nghiên cứu các extension fanqie trong fork — cách xử lý font encryption + captcha (task 108)

- Ngày nghiên cứu: 19/11/2026 ~23:00 +07:00 (muse-1) — Anh giao 19/11 22:50: tìm "fanqie" trong kho extension của app ra 11 kết quả, nghiên cứu xem các ext đó làm thế nào.
- Phạm vi: CHỈ NGHIÊN CỨU, không build, không merge. Chỉ đọc code công khai; không gọi API bên thứ ba, không đăng nhập, không lấy token của Anh.
- Bằng chứng: quét 19 catalog trong `repository.json` của Qsang_vbook (19/19 tải được bằng curl) + GitHub Search API; tải và đọc code 7 `plugin.zip` + 4 repo GitHub độc lập; đối chiếu bảng decode với mẫu live của task 107 bằng script.

## 1. Danh sách extension fanqie tìm được

Ảnh chụp của Anh (tìm "fanqie" trong Tiện ích mở rộng) có 11 kết quả. Quét 19 catalog công khai + GitHub tìm thấy **11 codebase fanqie khác nhau**; trong đó 2 tên trong ảnh chụp (**Fanqie OpenLove — open-love** và **fanqieweb — TH03, localhost:9999**) **không xuất hiện trong 19 catalog công khai** và không tìm thấy bằng GitHub Search — khả năng là repo Anh tự thêm trong app ngoài `repository.json` (Chưa xác định repo gốc của 2 cái này). Ngược lại, quét công khai thấy thêm 3 cái không nằm trong 7 tên đã thấy ở ảnh chụp (Cà Chua Sói Xám, 5in1, và các repo độc lập) — nhiều khả năng nằm trong 4 kết quả "dưới nếp gấp".

| # | Tên (tác giả) | Repo / catalog | Nguồn dữ liệu chương | Xử lý font encryption |
|---|---|---|---|---|
| 1 | Cà Chua (mizhm) v9 | mizhm/vbook-extensions | API bên thứ ba `http://101.35.133.34:5000/api` (có 3 host dự phòng trong comment) | Không — tin nội dung proxy trả về |
| 2 | [Fanqie] Cà Chua C2 (kychi) v6 | kychitoge/vbook-ext (+ bản sao ở yae-miko-313) | Proxy mirror `https://gofq.52dns.cc/content?item_id=` | Bảng thay thế cố định 372 ký tự (`decodeText`) |
| 3 | Cà Chua Sói Xám (kychi) v3 | kychitoge/vbook-ext | Proxy `https://v2.czyl.cf/content` (POST, cần cookie qttoken nếu đã đăng nhập Sói Xám) | Bảng thay thế cố định (gần giống C2) |
| 4 | Sói Xám (Fanqie) (Will Sun) v24 | WillSun28/vbook-extensions | Server Sói Xám `http://219.154.201.122:5006` (mặc định), regexp còn nhận `*.czyl.cf`/`*.langge.cf` | Không đọc được — `encrypt: true`, code mã hoá |
| 5 | Fanqienovel - LV (Nahona) v4 | SoulGodEve9x9/Vbook-ext (nhánh Nahona) | Metadata qua API app chính thức `api5-normal-lf.fqnovel.com` (aid=1967, iid hardcode); chương qua proxy `https://fqnovel.ceseet.me/content` | Không — trả thẳng nội dung proxy |
| 6 | FQ Video (Đường đen) v3 | duongden/vbook | API video fanqie trực tiếp (type `video`, không phải truyện chữ) | Không liên quan (video); `encrypt: true` |
| 7 | 5in1 (dat-bi) | dat-bi/ext-vbook | `api.langge.cf` / `api.doubi.tk` / `219.154.201.122:5006`, cần cookie thiết bị (`get_device()`), donate để tải | Không (có hàm decrypt1 zero-width đã comment-out) |
| 8 | vbook-ext-fanqie (KyCtG) | GitHub độc lập | Server tự host trong LAN `192.168.x.x:9999` + API key | Server tự host xử lý (không thấy code server trong repo) |
| 9 | fanqie_vbook (devanenWl) | GitHub độc lập | `http://localhost:9999` (server tự host) + dịch OpenAI tuỳ chọn | Server tự host xử lý |
| 10 | vbook-fanqie (DHaiPhong) | GitHub độc lập | Trang chính thức fanqienovel.com cho vài chương đầu; chương sau qua proxy cấu hình được (mặc định `gofq.52dns.cc`) hoặc cookie đăng nhập | 2 bảng thay thế cố định (PAGE + LIST), dựng từ đối chiếu glyph font |
| 11 | vbook-fanqie-ext (TekMonts) | GitHub độc lập | Server tự host (Express trên Vercel) fetch `fanqienovel.com/reader/<id>` rồi giải mã phía server | Bảng charset phía server (372 mục) |

Chưa xác định: repo gốc của **Fanqie OpenLove (open-love)** và **fanqieweb (TH03)** trong ảnh chụp. Mẫu "localhost:9999" của fanqieweb trùng mẫu server tự host của KyCtG/devanenWl (số 8, 9) — tức extension chỉ là vỏ gọi server chạy trên máy/điện thoại của người dùng, không tự lấy được nội dung.

## 2. Ba rào cản và cách từng ext xử lý

### 2.1 Font encryption — GIẢI ĐƯỢC bằng bảng thay thế cố định (điểm mới so với task 107)

Task 107 kết luận: vBook runtime không parse được font/cmap nên không giải được font encryption. Kết luận đó đúng về *parse font*, nhưng các ext fork cho thấy một đường khác không cần parse font: **ánh xạ PUA → chữ thật là cố định trên toàn site** (một "codebook" 372 mục, dải U+E3E8 = 58344 đến 58715), nên chỉ cần nhúng bảng thay thế vào JS thuần là decode được trong extension.

- kychi C2 và Cà Chua Sói Xám: hàm `decodeText` với `CODE_ST = 58344, CODE_ED = 58715`, bảng 372 ký tự.
- DHaiPhong: ghi rõ cách dựng bảng — đối chiếu glyph của font `awesome-font/c/dc027189e0ba4cd.woff2` (đúng file font task 107 đã parse) với font CJK chuẩn + đối chiếu `charset.json` của dự án cộng đồng ying-ck/fanqienovel-downloader, khớp 344/362 glyph; có 2 bảng riêng: `CHARSET_PAGE` (trang truyện/chương) và `CHARSET_LIST` (API thư viện), 13 vị trí chưa gặp mẫu để dấu □.
- TekMonts: cùng bảng 372 mục nhưng chạy phía server tự host.

**Kiểm chứng của muse-1:** chạy bảng decode của kychi C2 lên mẫu live trong báo cáo task 107 (bản xem trước 446 ký tự, 150 ký tự PUA) → ra câu tiếng Trung có nghĩa ("任把支…块牌天，只写"使营副食销售"，价两…毛钱…串。"), khớp ngữ cảnh chương "买糖葫芦了" (mua kẹo hồ lô, "一毛钱一串"). Còn vài ký tự lệch (một chữ thành "d", chữ "一" thành "觉") — bảng chưa hoàn hảo 100% và 2 bảng của DHaiPhong còn khác nhau theo ngữ cảnh (PAGE vs LIST), nhưng về nguyên tắc **font encryption của fanqie giải được bằng JS thuần trong vBook runtime**, không cần API parse font. Đây là phần cần sửa lại kết luận task 107 (pattern nhận biết PUA vẫn đúng, nhưng "không giải được" thì chưa đủ — giải được nếu chấp nhận bảng cố định và sai số nhỏ).

### 2.2 Captcha ByteDance Turing + chữ ký a_bogus — KHÔNG ext nào giải trong extension

- DHaiPhong ghi thẳng trong `search.js`: "API tìm kiếm của trang cần chữ ký (a_bogus) nên script không gọi được" → thay bằng quét thư viện + lọc từ khoá, hoặc dán link/ID truyện.
- Nahona né web API bằng API app chính thức `api5-normal-lf.fqnovel.com` với `aid=1967`, `iid` và cookie `novel_web_id` hardcode (giả lập client app) — không có cơ chế giải captcha, chỉ đổi đường gọi.
- Các ext còn lại (mizhm, kychi, Will Sun, dat-bi) đẩy hết việc gọi fanqie sang **server proxy bên thứ ba** (gofq.52dns.cc, v2.czyl.cf, api.langge.cf, api.doubi.tk, 101.35.133.34:5000, 219.154.201.122:5006, fqnovel.ceseet.me) — captcha/phiên đăng nhập do server đó gánh, extension không thấy và không kiểm soát được.

### 2.3 Cổng APP/SVIP — vẫn là rào cản thật

- DHaiPhong: "Khách chỉ đọc đủ vài chương đầu của mỗi truyện; chương sau cần phiên đăng nhập" — hoặc dán cookie đăng nhập của chính người dùng vào cài đặt, hoặc dùng proxy. Không có cách free hợp lệ cho toàn văn.
- Cà Chua Sói Xám: khách ẩn danh bị giới hạn **3 chương/ngày** (ghi trong description + code nhận diện thông báo giới hạn), muốn đọc tiếp phải đăng nhập tài khoản Sói Xám tại v2.czyl.cf.
- dat-bi 5in1: phải vào `api.langge.cf/login` tạo tài khoản; muốn **tải** truyện thì donate tại `api.doubi.tk/coffee`.
- Will Sun: description ghi "Vui lòng vào trang nguồn đăng nhập để sử dụng".

## 3. Đánh giá theo luật nhà

| Cách làm | Ext tiêu biểu | Đạt luật nhà? | Lý do |
|---|---|---|---|
| Bảng thay thế PUA cố định (JS thuần) | kychi C2, Sói Xám, DHaiPhong, TekMonts | **Đạt về kỹ thuật** | Chạy được trong runtime, không cần token/trả phí; nhưng chỉ giải được nội dung *đã lấy được* — không tự mở cổng SVIP |
| Proxy bên thứ ba (gofq.52dns.cc, v2.czyl.cf, api.langge.cf, api.doubi.tk, IP:5000/5006, fqnovel.ceseet.me) | mizhm, kychi, Will Sun, dat-bi, Nahona (chương) | **Không đạt** | API bên thứ ba không rõ chủ, có cái cần tài khoản/donate để tải; phụ thuộc server lạ, dễ chết/đổi; vi phạm nguyên tắc không gọi API bên thứ ba đáng ngờ |
| API app chính thức với iid/cookie hardcode | Nahona | **Không đạt** | Giả lập client app bằng định danh hardcode của người khác; không phải API công khai cho bên thứ ba |
| Server tự host localhost:9999 | KyCtG, devanenWl, fanqieweb (TH03) | **Không đạt cho repo nhà** | Cần người dùng tự chạy server + API key; devanenWl còn chứa API key dịch vụ trả phí hardcode trong repo công khai (không ghi giá trị ở đây) |
| Cookie đăng nhập của chính người dùng | DHaiPhong (tuỳ chọn) | **Không đạt** | Luật nhà: không lấy token/mật khẩu của Anh; chỉ đọc nội dung FREE công khai |
| FQ Video | Đường đen | Ngoài phạm vi | Type video, không phải truyện chữ; code mã hoá (`encrypt: true`) |

## 4. Kết luận

1. **Font encryption không còn là lý do đóng fanqie**: bảng thay thế PUA cố định (372 mục, dải 58344–58715) giải được trong JS thuần của vBook runtime — đã kiểm chứng trên mẫu live task 107. Kết luận task 107 cần được hiểu lại: đúng là runtime không parse được font, nhưng không cần parse font nếu dùng codebook cố định (chấp nhận sai số nhỏ, 2 bảng PAGE/LIST khác nhau).
2. **Rào cản còn lại mới là rào cản quyết định**: toàn văn chương nằm sau cổng APP/SVIP + API tìm kiếm cần chữ ký a_bogus/captcha. Mọi ext fork đọc được toàn văn đều dựa vào một trong ba thứ vi phạm luật nhà: proxy bên thứ ba (có nơi cần tài khoản/donate), định danh app hardcode, hoặc cookie đăng nhập của người dùng. Không ext nào đọc được toàn văn fanqie bằng nội dung FREE công khai thuần tuý.
3. **Khuyến nghị: fanqie vẫn ĐÓNG** như cũ. Nếu sau này Anh muốn xét lại, hướng duy nhất hợp lệ để kiểm chứng tiếp (không tự build) là: extension chỉ đọc **vài chương đầu free công khai** trên trang chính thức + bảng decode PUA — cần Anh duyệt rõ phạm vi đó và kiểm chứng live xem "vài chương đầu" có thật sự mở đầy đủ cho khách không (DHaiPhong khẳng định có, task 107 thấy bản xem trước bị cắt + mời SVIP — hai bằng chứng chưa khớp nhau, Chưa xác định).
4. Đề xuất cập nhật skill `vbook-extension-building` (muse-main quyết khi review): bổ sung ghi chú "font encryption kiểu fanqie giải được bằng bảng thay thế PUA cố định nếu site dùng codebook cố định — kiểm chứng bằng cách decode mẫu live; vẫn phải xét cổng login/SVIP riêng". Không sửa skill trong task này (chỉ nghiên cứu).
