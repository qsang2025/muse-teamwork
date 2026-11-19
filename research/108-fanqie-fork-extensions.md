# Nghiên cứu các extension fanqie trong fork — cách xử lý font encryption + captcha

- Ngày nghiên cứu: 19/11/2026 (muse-1, task 108) — Anh giao 19/11 22:50 (chat Vbook): tìm "fanqie" trong kho extension của app ra 11 kết quả, giao nghiên cứu xem các extension đó làm thế nào.
- Phạm vi: **chỉ nghiên cứu code, không build, không merge.** Không gọi API fanqie live trong đợt này (tránh dồn dập/captcha), không bypass VIP/login, không lấy token của Anh.
- Bằng chứng: clone `--depth 1` 11 repo fork về máy muse-1 và đọc trực tiếp `plugin.json` (catalog + từng extension), `src/chap.js`, `src/config.js`, `src/toc.js`, `src/detail.js`, `src/search.js`; đối chiếu catalog `repository.json` (19 catalog) của Qsang_vbook; đọc hướng dẫn `duongden/vbook_news` mục Cà Chua; kiểm chứng catalog OpenLove live qua trình duyệt. Mọi khẳng định dưới đây đều trỏ về file code cụ thể.

## 0. Chống trùng (PROTOCOL §3)

- **Repo đích Qsang_vbook:** chưa có extension fanqie trực tiếp (registry 119 nguồn, main `399b2d1`). Chỉ có đường gián tiếp qua Sáng Tác Việt APP (host `fanqie` trong `sangtacvietapp/src/chap.js` chỉ sửa ảnh/thẻ của bản convert STV, không fetch fanqienovel.com). Task này là research, không build nên không trùng.
- **Tasks claimed/doing/review:** 103 (claimed, muse-2, shushuwuxs), 105 (review, muse-1, TruyenTV) — không trùng site/việc. Không có task research fanqie nào khác đang mở.
- **STATUS.md + danh sách ĐÓNG:** fanqie vẫn ĐÓNG cho build (chương khóa login/VIP theo FORK-SCAN 18–19/11). Task 108 chỉ nghiên cứu cách fork làm, không mở lại build.

## 1. Liệt kê các extension fanqie tìm thấy

Ảnh chụp của Anh thấy 7 tên; 4 tên dưới nếp gấp chưa thấy. Quét 11 repo + 19 catalog tìm thấy **13 extension liên quan fanqie** (kể cả bản sao trong kho gom `laodai123/vbook-plugins-collection`). Bảng dưới ghi bản gốc; bản sao "+1" trong kho gom không tính riêng.

| # | Tên (theo catalog) | Tác giả / repo gốc | Source khai báo | Trong ảnh Anh? |
|---|---|---|---|---|
| 1 | [Fanqie] Cà Chua C2 v6 | kychi — `kychitoge/vbook-ext` | fanqienovel.com | Có |
| 2 | Cà Chua Sói Xám v3 | kychi — `kychitoge/vbook-ext` | fanqienovel.com | Chưa xác định (ứng viên dưới nếp gấp) |
| 3 | Cà Chua v9 | mizhm — `mizhm/vbook-extensions` | fanqienovel.com | Có |
| 4 | Fanqienovel - LV v4 | Nahona — `SoulGodEve9x9/Vbook-ext` (nhánh Nahona, `Fanqienovel.zip`) | fanqienovel.com | Có |
| 5 | Sói Xám (Fanqie) v24 | Will Sun — `WillSun28/vbook-extensions` (`zip/api.langge.cf.zip`) | api.langge.cf | Có |
| 6 | fanqieweb v1 | TH03 — `TuanHai03/vbook-extensions` (`fqweb/`) | localhost:9999 | Có |
| 7 | FQWeb Universal v3 | Chanhnh — `Chanhnh/vbook-ext` (`fqweb/`) | fanqienovel.com (API mặc định localhost:9999) | Chưa xác định (ứng viên dưới nếp gấp) |
| 8 | [Fanqie] Cachua v38 | bqy — chỉ thấy bản sao trong `laodai123/vbook-plugins-collection` | fanqienovel.com (+ localhost:9999 trong regexp) | Chưa xác định (ứng viên dưới nếp gấp) |
| 9 | Fanqie Novel v12 | Nhocconsr — `Cachkomuoi/vbook` (`fanqienovel/`) | fanqienovel.com | Chưa xác định (ứng viên dưới nếp gấp) |
| 10 | Fanqie v1 | TuanHai03 — `TuanHai03/vbook-extensions` (`fq/`) | fanqienovel.com | Chưa xác định (có thể là 1 trong 4, hoặc không hiện vì khác bộ catalog trên máy Anh) |
| 11 | Fanqie OpenLove v20 | open-love — ngoài GitHub (`vb-source.open-love.app`, kiểm chứng live 19/11) | fanqienovel.com | Có |
| 12 | FQ Video v3 (type video) | Đường đen — `duongden/vbook` (zip host ngoài repo) | fanqienovel.com | Có |
| 13 | 5in1 v70 (fanqie là 1/5 nguồn) + Langgee v7 (fanqie là 1/~30 nguồn) | B — `dat-bi/ext-vbook`; Đường đen — `duongden/vbook` | IP thô / v5.langge.uk | Chưa xác định (tên không chứa "fanqie", có thể không khớp tìm kiếm của app) |

Ghi chú trung thực: **4 tên dưới nếp gấp là suy luận từ catalog, chưa xác định chắc chắn** — muốn chắc phải xem lại màn hình kho extension trên máy Anh. Dù vậy, 13 extension trên đã bao phủ mọi cách làm fanqie đang có trong fork.

Kết quả âm tính quan trọng: **`Darkrai9x/vbook-extensions` (repo gốc của hầu hết fork) không có extension fanqie nào** (grep `fanqie` trong toàn repo ra rỗng). Mọi extension fanqie đều là của fork cộng đồng, không phải bản chính thức.

## 2. Từng extension lấy chương thế nào

### Nhóm A — Proxy bên thứ ba (server trung gian lấy + giải mã sẵn)

**1. [Fanqie] Cà Chua C2 (kychi).** Mọi thao tác đều gọi proxy `https://gofq.52dns.cc` (`/detail`, `/catalog`, `/search`, `/content?item_id=` trong `config.js`/`chap.js`). Proxy trả JSON chứa text còn ký tự PUA; extension tự giải mã bằng bảng tĩnh `decodeText` (xem mục 3). Không gọi fanqienovel.com trực tiếp để lấy chương.

**2. Cà Chua Sói Xám (kychi).** Gọi proxy `https://v2.czyl.cf` (POST `/content`, kèm cookie `qttoken` nếu đã đăng nhập Sói Xám qua trình duyệt trong app). Khách ẩn danh bị giới hạn **3 chương/ngày** (code nhận diện thông báo giới hạn và hiện hướng dẫn đăng nhập `v2.czyl.cf/login`). Cũng dùng bảng `decodeText` như C2.

**3. Cà Chua (mizhm).** Trộn hai đường: mục lục/tìm kiếm gọi API chính thức của fanqie (`/api/reader/directory/detail`, `/api/author/search/search_book/v0`), nhưng **nội dung chương gọi API bên thứ ba** `http://101.35.133.34:5000/api/content?item_id=` (config còn liệt kê 3 API dự phòng khác đã comment). `chap.js` không giải mã gì — tin hoàn toàn text proxy trả về.

**4. Fanqienovel - LV (Nahona).** Chi tiết/tìm kiếm gọi API app ByteDance (`api5-normal-lf.fqnovel.com/reading/bookapi/...` với `aid=1967`, `iid` giả lập), mục lục gọi `/api/reader/directory/detail`, nhưng **chương gọi proxy** `https://fqnovel.ceseet.me/content?item_id=`. Kèm cookie cứng `novel_web_id=...` trong code. Không giải mã phía client.

**5. Sói Xám (Fanqie) (Will Sun).** Code bị **mã hoá toàn bộ** (`encrypt: true`, mọi file `src/*.js` là chuỗi mã hoá không đọc được) nên không đọc được logic. Metadata cho thấy source là `api.langge.cf` / IP `219.154.201.122:5006`, regexp nhận cả link fanqienovel.com và sangtacviet, mô tả yêu cầu đăng nhập trang nguồn. Hướng dẫn cộng đồng (`vbook_news`) xếp vào nhóm "Free + Pre", bán VIP/SVIP tại `api.langge.cf`.

**13a. 5in1 (B).** Chương fanqie gọi lần lượt 3 host proxy (`api.langge.cf`, `api.doubi.tk`, IP `219.154.201.122:5006`) kèm cookie thiết bị lấy từ `api.langge.cf/user` (`get_device()` trong `config.js`). Code phải **lọc bỏ watermark/quảng cáo proxy chèn vào text** (nhiều regex xoá dòng "本书源属于..." + ký tự zero-width) — bằng chứng proxy trung gian có sửa nội dung.

**13b. Langgee (Đường đen).** Code cũng mã hoá (`encrypt: true`). Là nguồn gộp ~30 site (fanqie chỉ là 1 lựa chọn trong `source_filter`), server `v2`–`v10.langge.uk`, bắt buộc nhập `qttoken` (VIP/SVIP/hội viên) trong Cài đặt.

### Nhóm B — Gọi thẳng API ByteDance (không qua proxy)

**9. Fanqie Novel (Nhocconsr, 2023).** Mục lục gọi `api5-normal-lf.fqnovel.com/reading/bookapi/directory/all_infos/v/` (kèm `iid`/`aid` giả lập app), chương gọi `novel.snssdk.com/api/novel/book/reader/full/v1/`. Trả `data.content` nguyên văn, không giải mã PUA, không xử lý captcha/SVIP.

**10. Fanqie (TuanHai03).** Chương gọi `novel.snssdk.com/api/novel/reader/full/v1/?item_id=`, trả nguyên văn. Regexp còn nhận link qua các API lạ (`api-fanqienovel.sunianyun.live`, `list.fqapi.jilulu.cn`) và link sangtacviet. Mô tả "Hỗ trợ đọc truyện bị gỡ trên fanqie".

**8. [Fanqie] Cachua (bqy).** Chương gọi **API web chính thức** `https://fanqienovel.com/api/reader/full?itemId=` kèm cookie cứng `novel_web_id=...`, rồi tự giải mã PUA bằng bảng tĩnh `r_content` (xem mục 3). Regexp đồng thời nhận link `localhost:9999` (chế độ server local ở Nhóm C).

### Nhóm C — Server local FQWeb (app Fanqie thật trên máy root làm trung gian)

**6. fanqieweb (TH03)** và **7. FQWeb Universal (Chanhnh)** không tự lấy nội dung từ fanqie: chúng gọi `http://localhost:9999/content?item_id=` (Chanhnh cho cấu hình `api_url` trong Cài đặt, mặc định localhost:9999). Cổng 9999 là **FQWeb** — module Xposed hook vào app Fanqie trên điện thoại Android đã root, dùng chính phiên đăng nhập của app để lấy chương rồi serve HTTP local. Hướng dẫn cộng đồng xếp nhóm này là "Free tự host — yêu cầu Android đã root". Extension chỉ là vỏ mỏng; font/captcha/SVIP do app thật xử lý.

### Nhóm D — Token / sign server

**11. Fanqie OpenLove (open-love).** Catalog live ghi "API chính chủ, giải mã tại máy", nhưng bắt buộc lấy **token** từ `vb-app.open-love.app/claim` (Sign Server) điền vào Cài đặt. Code chỉ có dạng `plugin.zip` trên server của họ, không có trong fork GitHub nào đã quét nên **chưa đọc được code** — chi tiết giải mã "tại máy" là **Chưa xác định**.

### Nhóm E — Video (ngoài phạm vi truyện chữ)

**12. FQ Video (Đường đen).** Type `video` (phim ngắn/hoạt hình Fanqie), mô tả "API trực tiếp và phát native; không cần root". Zip host trên `workers.dev` ngoài repo nên **chưa đọc được code**. Không liên quan tới đọc chương truyện chữ.

## 3. Font encryption: 3 extension giải mã bằng bảng tĩnh, còn lại né bằng API/proxy

Đây là phát hiện chính, bổ sung cho task 107:

- **Chỉ 3 extension giải mã PUA ngay trong extension**, đều bằng **bảng ánh xạ tĩnh** `CODE_ST = 58344` (U+E3E8) đến `CODE_ED = 58715`, 372 mục, 10 mục chưa biết: kychi C2, kychi Sói Xám, bqy. Không extension nào parse font/cmap (khớp task 107: runtime không có API font).
- **Hai bảng của kychi thực chất là một** (250/371 vị trí giống hệt; khác biệt là chữ giản thể vs phồn thể, vd 员/員, 给/給). **Bảng của bqy khác hoàn toàn: 0/372 vị trí trùng với kychi.** Tức trong fork đang tồn tại ít nhất hai phép ánh xạ PUA→chữ không tương thích nhau. Hệ quả: ánh xạ không phải hằng số phổ quát — hoặc fanqie đã đổi mapping theo đợt subset font (bảng cũ hết hạn), hoặc mỗi endpoint trả một phép xáo khác nhau. **Bảng nào (nếu có) còn đúng với fanqie hôm nay là Chưa xác định** vì đợt này không test live.
- **Mọi extension còn lại né font encryption** bằng cách không đọc HTML trang web: chúng lấy text từ API app/proxy/server local vốn đã là chữ thường (server phía kia đã giải mã). Font chỉ là rào cản của đường web reader mà task 107 đã kiểm chứng.

Đối chiếu task 107: kết luận "runtime không parse được font/cmap" **vẫn đúng**, nhưng cần nói chính xác hơn — runtime **giải mã được nếu có bảng tĩnh đúng**, vì đó chỉ là tra bảng bằng JS thuần. Cái task 107 chưa xác định (font/mapping có đổi theo chương không) nay có thêm bằng chứng gián tiếp là **có đổi hoặc không thống nhất** (hai bảng xung khắc). Bảng tĩnh là cách làm mong manh: fanqie đổi subset là bảng sai hàng loạt mà extension không tự phát hiện được (trừ khi áp thêm pattern nhận biết tỉ lệ PUA của task 107 để báo lỗi thay vì trả rác).

## 4. Captcha Turing + cổng APP/SVIP

- **Captcha:** grep `captcha|turing|turnstile` trong code của cả 10 extension đọc được đều **rỗng**. Không extension nào giải captcha. Chúng né captcha bằng cách dùng API app/proxy/phiên app thật. Nếu ByteDance bật Turing cho các API đó, code hiện tại chỉ trả lỗi chung ("Kiểm tra lại app Fanqie") — không có đường lui.
- **SVIP/login:** không extension nào chứa code bypass tường minh. Thay vào đó: (a) proxy Sói Xám/Langge tự dựng cổng riêng (3 chương/ngày cho khách, qttoken/VIP trả phí); (b) FQWeb dùng phiên app thật trên máy root; (c) nhóm API trực tiếp (Nhocconsr/TuanHai03/bqy) gửi request không xác thực — **code không cho biết chúng nhận được chương VIP đầy đủ hay chỉ bản xem trước**. Task 107 đã chứng minh đường web khóa toàn văn sau APP/SVIP; nếu các API app này trả toàn văn VIP không cần auth thì dùng chúng là bypass, nếu chỉ trả chương free thì hợp lệ. Phân biệt hai khả năng này bắt buộc phải test live 1 chương free + quan sát chương VIP bị chặn thế nào — đợt này chưa làm theo đúng phạm vi "chỉ nghiên cứu".

## 5. Đánh giá theo luật nhà (free, không bypass, không token, không trả phí, không API bên thứ ba đáng ngờ)

| Cách làm | Extension | Kết luận |
|---|---|---|
| Proxy bên thứ ba (gofq, czyl, langge, ceseet, IP thô) | kychi C2, kychi Sói Xám, mizhm, Nahona, Will Sun, 5in1, Langgee | **Không đạt.** API trung gian không rõ nguồn gốc, có thể chết/chèn nội dung (5in1 phải lọc watermark), nhiều cái kèm đăng nhập/token/bán VIP. |
| Server local FQWeb trên máy root | TH03, Chanhnh, (bqy chế độ local) | **Không đạt.** Cần root + hook app Fanqie, không phải extension vBook thuần; dựa vào phiên app để qua cổng. |
| Token sign server | OpenLove | **Không đạt.** Bắt buộc token bên thứ ba; code không công khai để kiểm chứng. |
| API app ByteDance trực tiếp, giả lập aid/iid | Nhocconsr, TuanHai03 | **Chưa xác định.** Không token/trả phí trong code, nhưng là endpoint app không chính thức + giả lập thiết bị; chưa chứng minh chỉ lấy nội dung free và không dính captcha. |
| API web chính thức + bảng PUA tĩnh | bqy | **Gần nhất với luật nhà nhưng chưa đủ bằng chứng.** Không proxy/token/trả phí trong code (trừ cookie `novel_web_id` cứng), nhưng bảng giải mã xung khắc với bảng kychi và chưa test live; vẫn phải chứng minh không qua cổng SVIP. |
| Video | FQ Video | Ngoài phạm vi (không phải truyện chữ); code chưa đọc được. |

## 6. Kết luận + bước kiểm chứng tiếp theo (không tự build)

**Chưa có cách nào hợp lệ đã được chứng minh chỉ bằng đọc code để đọc fanqie trong vBook.** Phần lớn fork sống nhờ proxy/token/máy root — đều phạm luật nhà. Hai hướng duy nhất không phạm ngay từ code (API ByteDance trực tiếp; API web + bảng PUA) đều thiếu bằng chứng live về 3 điểm: bảng PUA còn đúng không, API có trả chương VIP không, captcha có chặn không.

Nếu Anh muốn đi tiếp, bước kiểm chứng tối thiểu (cần Anh duyệt trước, vẫn không build): fetch **đúng 1 chương free** qua `fanqienovel.com/api/reader/full` như bqy, đo tỉ lệ PUA trước/sau khi áp cả hai bảng (kychi và bqy), và ghi lại phản ứng của API với 1 chương VIP (phải bị chặn mới hợp lệ). Dừng ngay nếu gặp captcha/login. Chỉ khi cả ba điểm đều đạt mới bàn tới build; **fanqie vẫn ĐÓNG cho tới khi Anh duyệt hướng mới.**

## 7. Chưa xác định (không đoán)

- 4 tên dưới nếp gấp trong ảnh của Anh (mục 1).
- Code của OpenLove, FQ Video, Will Sun, Langgee (mã hoá/host ngoài repo — chỉ đánh giá qua metadata + hướng dẫn cộng đồng).
- Bảng PUA nào còn đúng, mapping có đổi theo chương/ngày không, API app có trả VIP/captcha không (cần test live có duyệt).
- Các proxy còn sống không (đợt này không gọi thử để tránh dồn dập; FORK-SCAN 18/11 ghi `api.langge.cf` lỗi kết nối từ VM).

## 8. Bổ sung kiểm chứng (lượt hook 19/11 ~23:00, muse-1)

Một lượt muse-1 thứ hai (hook watcher) chạy song song đã kiểm chứng độc lập điểm "bảng PUA nào còn đúng" ở mục 7 bằng cách áp bảng `decodeText` của kychi C2 (372 mục, 58344–58715) lên mẫu live trong báo cáo task 107 (bản xem trước 446 ký tự, 150 ký tự PUA, fetch 19/11 22:41): kết quả ra câu tiếng Trung có nghĩa khớp ngữ cảnh chương ("…块牌…只写"使营副食销售"，价两…毛钱…串。"), còn vài ký tự lệch (một chữ thành "d", chữ "一" thành "觉"). Tức bảng kychi **vẫn khớp phần lớn** với font subset live ngày 19/11 — bằng chứng gián tiếp cho thấy mapping không đổi theo từng chương trong ngày, nhưng chưa đủ để khẳng định ổn định dài hạn, và vẫn chưa giải thích được vì sao bảng bqy xung khắc hoàn toàn (0/372). Lượt này cũng đọc thêm 4 repo GitHub độc lập ngoài 19 catalog (KyCtG, devanenWl, DHaiPhong, TekMonts): DHaiPhong ghi rõ bảng dựng từ đối chiếu glyph font `dc027189e0ba4cd.woff2` với font CJK chuẩn + `charset.json` của ying-ck/fanqienovel-downloader (khớp 344/362 glyph), có 2 bảng PAGE/LIST; search của DHaiPhong ghi thẳng API tìm kiếm cần chữ ký a_bogus nên không gọi được. Kết luận chung không đổi: fanqie vẫn ĐÓNG.
