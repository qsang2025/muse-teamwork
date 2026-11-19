# Kỹ thuật xử lý site khó cho extension vBook: JS-rendered, Cloudflare/WAF, font encryption, GBK/encoding

- Ngày nghiên cứu: 19/11/2026 (muse-2, task 098)
- Phạm vi: chỉ đọc nội dung FREE. Không bypass VIP/login/paywall, không fake login, không lấy token.
- Bằng chứng: code thật trong repo Qsang_vbook + fetch live bằng curl từ máy này (tối đa 1 chương free mỗi site, không fetch dồn dập, không gặp 429).

## 1. Kết quả kiểm chứng live (19/11/2026)

| Site | Chương free thử | HTTP | Dung lượng | Encoding | Cần JS? | Đọc free được? |
|---|---|---|---|---|---|---|
| jjwxc.net | `onebook.php?novelid=4737103&chapterid=1` | 200 | 116.708 byte | GBK (`charset=gb18030`, `charset="GBK"`) | Không — `div.noveltext` có sẵn trong HTML tĩnh | Có — sau khi giải mã GBK, câu mở đầu khớp fixture test.json: "灰败阴暗的破旧建筑，散发着潮湿发霉气息…" |
| zhenhunxiaoshuo.com | `1.html` | 200 | 28.210 byte | UTF-8 | Không — `article.article-content > p` có sẵn | Có — mở đầu "农历七月十五，天还没亮。" khớp fixture |
| kyhuyen.com | `truyen/.../chuong-1/63796231303434333836` | 200 | 162.949 byte | UTF-8 | Không — `.story-content article` có sẵn | Có — mở đầu "Đêm khuya tĩnh lặng" khớp health.json |
| 8book.com | (không curl lần này — theo code + ghi chú kiểm chứng live 2026-11-16 trong `chap.js`) | — | — | — | **Có** — trang tĩnh rỗng (`#text/#subtitle/#content` đều rỗng), nội dung nạp qua JS + iframe `share.html` | Có qua WebView — probe máy thật: ch.1 2.116 ký tự, ch.2 3.610 ký tự, không login/paywall |

- Cả 3 site fetch live đều **không có marker Cloudflare challenge** trong body (0 lần xuất hiện `cloudflare`, `cf-chl`, `Just a moment`).
- kyhuyen.com có `@font-face` nhưng chỉ là font trang trí (FontAwesome, Roboto) — nội dung chương là text thường, **không phải font encryption**.
- fanqienovel.com: không fetch thêm. Theo `work/ext-review/FORK-SCAN-2026-11-18-results.json`, chương 1 đã khóa login/VIP (439 ký tự, "chapter page demands login/VIP") nên đã đóng theo quy tắc nhà.

## 2. JS-rendered (nội dung chỉ có sau khi chạy JS)

### Cách nhận biết
- Fetch HTML tĩnh về thì vùng chứa nội dung trống: ví dụ 8book `#text`, `#subtitle`, `#content` đều rỗng; nội dung chỉ xuất hiện sau khi JS chạy hoặc nằm trong iframe (`share.html`).
- Dấu hiệu khác: body rất ngắn so với độ dài chương thật, hoặc chỉ có khung + thẻ `<script>` tải dữ liệu; `health.json` pattern không thấy trong body tĩnh.

### Cách xử lý khả thi trong extension vBook
- Dùng Headless WebView của runtime: `Engine.newBrowser()` — API chuẩn trong `extension-api.md` mục "Browser (Headless WebView)": `browser.launch(url, timeout)`, `browser.html(ms)`, `browser.callJs(...)`, `browser.close()`.
- Mẫu thật — `extensions/chinese_novel/8book/src/chap.js` (đã kiểm chứng trên máy thật):
  - `b.launch(url, 15000)`, rồi poll `b.html(6000)` tối đa 14 lần, mỗi lần `sleep(1000)`, dừng khi `#text` đủ ≥ 200 ký tự.
  - Kiểm tra login/paywall trong body đã render (`登入`/`登錄`/`付費`/`購買`) rồi mới trả nội dung — không bypass.
  - Luôn `b.close()` trong `finally`.
- Mẫu thật thứ hai — `extensions/chinese_novel/jjwxc/src/search.js`: tìm kiếm GBK không gửi query trực tiếp được (kw UTF-8 trả mojibake), nên mở trang danh sách bằng WebView rồi dùng `callJs` điền form `form8` (`input[name=kw]`) và `submit()` — form tự encode theo charset của document (GBK). Sau đó poll `b.html()` tới khi title chứa "搜索".
- Chỉ dùng WebView cho đúng script cần (thường là `chap.js` hoặc `search.js`). **Không fetch ở `home.js`** (quy tắc 9 AGENTS.md: tab đầu tiên phải là tab tĩnh, fetch lỗi sẽ chặn cả trang chủ).

### Giới hạn — cái KHÔNG làm được
- WebView chậm (launch 15 giây + poll từng giây) và chỉ chạy trên máy thật có app vBook — CI không có điện thoại nên không test được đường này bằng `testall`.
- Không có API `.get()` nào trả Document trực tiếp (lỗi này từng làm hỏng `search.js` của sjks88, #94) — chỉ dùng `launch` / `callJs` / `html` / `close`.
- Nếu nội dung nằm sau API cần token/session mà site không cho khách vãng lai thì dừng — không lấy token, không fake login.
- Nếu sau tối đa ~14 lần poll mà nội dung vẫn < 200 ký tự thì trả `Response.error` tiếng Việt rõ ràng, không retry liên tục.

## 3. Cloudflare / WAF chặn fetch

### Cách nhận biết
- HTTP 403 / 503, hoặc **HTTP 200 nhưng body là trang challenge** — không được tin `res.ok` (đã gặp thật ở novels.com.tw ngày 2026-11-06, ghi trong `lib/fetch-helpers.js`).
- Dấu hiệu trang challenge: title "Just a moment..." hoặc bản địa hoá "Chờ một chút..." (Cloudflare localize theo Accept-Language/IP), "Attention Required!", marker `challenges.cloudflare.com`, `__cf_chl`, `cf-challenge`, `cf-turnstile`, `Please verify you are a human`, header `cf-mitigated: challenge`.
- Dấu hiệu rate-limit theo IP (khác challenge): HTTP 429 / 405 / 503 lặp lại — ví dụ qimao.com ngày 2026-11-09: ~6–10 request nhanh (có 2 song song) khiến WAF chặn IP bằng HTTP 405 hơn 2 giờ (ghi trong `lib/rate-limit.js` và AGENTS.md mục 6.11).

### Cách xử lý khả thi trong extension vBook
- Phát hiện challenge trước khi parse: `isChallengeDoc(doc)` / `isChallengeText(text)` trong `lib/fetch-helpers.js` — quét cả title lẫn body (không chỉ khi title rỗng, vì trang challenge HTTP 200 có thể mang title khác), kiểm tra cả header `cf-mitigated`.
- Fallback WebView khi fetch thường thất bại: `fetchViaBrowser(url)` — `Engine.newBrowser()`, `launch(url, 15000)`, poll `html(3000)` tối đa 4 lần trong khi còn là trang challenge; WebView chia sẻ kho cookie với trình duyệt trong app nên nếu người dùng đã xác minh/có `cf_clearance` thì dùng lại được (ghi trong `lib/challenge-handler.js`).
- **Không xoay User-Agent** (quy tắc 10 AGENTS.md): Cloudflare gắn cookie `cf_clearance` với UA của trình duyệt đã qua xác minh; fetch bằng UA khác sẽ không khớp cookie và lại bị 403 — bài học novels.com.tw 2026-11-06 (xoay UA bị 403 ngay cả khi đã qua xác minh; extension của mizhm dùng UA mặc định thì chạy được).
- Rate-limit: 1 request/lần/host, `rateLimitDelay()` trước mỗi request (mặc định 500–1500 ms, host nhạy cảm 2000–3000 ms), không request song song cùng host; gặp 429/405/503 thì backoff hàm mũ + jitter tối đa 3 lần, tôn trọng header `Retry-After` (trần 30 giây), ghi cooldown bằng `setCooldown()` — xem `lib/rate-limit.js` (`pacedFetch()` trả cả mã HTTP để phân biệt 405 với lỗi mạng).
- Gặp 429/405 thì **không dùng browser fallback** (cùng IP nên vô ích) và lỗi trả về phải nói rõ "đang tạm chặn, thử lại sau X phút" (`rateLimitErrorMessage`).
- Khi browser cũng không qua được challenge: trả `Response.error` tiếng Việt kèm hướng dẫn từng bước mở trình duyệt trong app vBook để tự xác minh/đăng nhập rồi quay lại — mẫu `formatChallengeError()` / `formatLoginError()` trong `lib/challenge-handler.js` (kiểu Legado, trong giới hạn vBook).

### Giới hạn — cái KHÔNG làm được
- **Turnstile / captcha tương tác không tự vượt được.** Extension không có cách giải captcha thay người dùng; chỉ có thể nhờ người dùng xác minh trong trình duyệt của app rồi dùng lại cookie.
- HTTP 403 từ dải IP datacenter (CI health-check từng gặp: cùng request từ máy này trả 200, từ runner GitHub trả 403) **không kết luận được site chết** — trạng thái `BLOCKED`, phải kiểm tra tay bằng trình duyệt/máy thật (AGENTS.md mục 12).
- Không retest 429 liên tục: retest 1 lần sau thời gian yên lặng dài rồi quyết định; đừng đóng nguồn chỉ vì 1 vòng 429.

## 4. Font encryption (chữ hiển thị đúng nhưng mã nguồn là ký tự khác)

### Cơ chế (lý thuyết — chưa có site mở nào để kiểm chứng live)
- Site nhúng font `.woff` tùy chỉnh qua `@font-face`, bảng `cmap` của font ánh xạ mỗi mã ký tự trong HTML sang một glyph khác. Người đọc thấy chữ đúng trong trình duyệt, nhưng text trích từ DOM là ký tự rác (hoặc ký tự khác hẳn). Copy-paste từ trình duyệt ra cũng ra ký tự sai.
- Cách nhận biết: `@font-face` trỏ tới font lạ (không phải font hệ thống/trang trí như FontAwesome/Roboto); text trong DOM là chuỗi ký tự vô nghĩa nhưng render đúng; tắt font tùy chỉnh (hoặc xem bằng curl) thì nội dung biến thành ký tự lạ.

### Cách xử lý trong extension vBook: KHÔNG LÀM ĐƯỢC
- Runtime vBook (Rhino ES6) **không có API nào để tải font, đọc bảng `cmap` hay giải mã glyph** — `extension-api.md` không có API font nào; code JS trong extension chỉ xử lý được text/HTML đã có.
- `lib/cleanHtml.js` chỉ lọc được trò ẩn text bằng CSS (`font-size: 0px`), không giải được font encryption thật.
- Giải mã đúng cách đòi hỏi tải file font, parse định dạng woff/cmap và dựng lại bảng ánh xạ — việc này nằm ngoài khả năng của extension vBook, và font có thể đổi theo từng chương/từng ngày nên bảng ánh xạ hardcode cũng không bền.
- **Kết luận: site dùng font encryption cho nội dung chương thì ghi rõ "không build được", đóng task, không cố bypass bằng cách đoán bảng mã.**

### Bằng chứng liên quan đã kiểm chứng
- fanqienovel.com (site được nhắc trong task 098): chương 1 đã khóa login/VIP theo rescan 2026-11-18 (`work/ext-review/FORK-SCAN-2026-11-18-results.json`: `ch1: locked`, 439 ký tự) — đã đóng theo quy tắc nhà, không phải vì font encryption mà vì cổng login. Không có mẫu font-encryption nào còn mở để kiểm chứng trực tiếp trong đợt này.

## 5. GBK / encoding lạ

### Cách nhận biết
- Meta `charset=GBK` / `charset=gb18030` hoặc header `Content-Type: text/html; charset=gbk`; đọc bằng UTF-8 thì ra mojibake (ký tự rác); từ khoá tìm kiếm gửi dạng UTF-8 thì backend không khớp.
- jjwxc.net kiểm chứng live lần này: `file` báo "ISO-8859 text", grep UTF-8 không thấy câu mở đầu, sau `iconv -f GBK` mới thấy đúng câu trong fixture.

### Cách xử lý khả thi trong extension vBook
- Dùng `response.html('gbk')` / `response.text('gbk')` thay cho `.html()` mặc định — mẫu `lib/gbk.js`: `htmlGbk(response)`, `textGbk(response)`, `fetchDocGbk(url)` (kèm UA desktop + `Accept-Language: zh-CN`).
- Quy tắc build: `gbk.js` là lib mẫu ở repo root — bước build phải copy/inline vào `src/` của từng extension (runtime `load()` chỉ load file top-level trong `src/`, không đệ quy); `validate` kiểm tra md5 file lib đã inline khớp bản gốc.
- Tìm kiếm: đừng tự percent-encode từ khoá UTF-8 — dùng WebView submit form của chính site để form tự encode theo charset document (mẫu `jjwxc/src/search.js`, đã kiểm chứng live 2026-11-19: `search.php?kw=<GBK>&t=1` trả đúng 25 kết quả, kw UTF-8 trả mojibake).
- Chỉ dùng cho nguồn Trung mã GBK/GB2312. Site Việt/Nhật/Anh dùng UTF-8 mặc định, không cần file này.

### Giới hạn
- GB2312: hầu hết site GBK đọc được cả hai, đổi `GBK_CHARSET` sang `"gb2312"` chỉ khi site cũ chỉ dùng GB2312 (hiếm).
- Big5 (zh_TW): chưa có lib tương tự, chưa kiểm chứng — khi gặp site Big5 thì thử `response.html('big5')` rồi mới kết luận (xem mục "Chưa xác định").

## 6. Đề xuất cập nhật skill vbook-extension-building

Đã áp dụng trực tiếp vào `shared/skills/vbook-extension-building/SKILL.md` (mục mới "Handle difficult sites", chỉ thêm mới, không xóa nội dung cũ):

| # | Nội dung thêm vào skill | Nguồn bằng chứng |
|---|---|---|
| 1 | Nhận biết + xử lý JS-rendered bằng `Engine.newBrowser()` (launch → poll `html()` tới khi đủ text → `close()` trong `finally`); không dùng API `.get()` không tồn tại | `8book/src/chap.js`, `jjwxc/src/search.js`, `extension-api.md` mục Browser |
| 2 | Nhận biết trang challenge Cloudflare kể cả khi trả HTTP 200 (title "Just a moment"/"Chờ một chút", marker `__cf_chl`/`cf-turnstile`, header `cf-mitigated`); fallback WebView; không xoay UA | `lib/fetch-helpers.js` (`isChallengeDoc`/`fetchViaBrowser`), `lib/challenge-handler.js`, novels.com.tw 2026-11-06 |
| 3 | Rate-limit theo IP: pacing 1 req/lần + jitter, backoff tối đa 3 lần, tôn trọng `Retry-After`, cooldown, không browser fallback khi 429/405; không đóng nguồn vì 1 vòng 429 | `lib/rate-limit.js`, qimao.com 2026-11-09, AGENTS.md mục 6.11 |
| 4 | Font encryption: ghi rõ "không build được" — runtime không có API parse font/cmap; đóng task thay vì đoán bảng mã | Chưa có site mở kiểm chứng live (fanqie đã khóa login/VIP — FORK-SCAN-2026-11-18) |
| 5 | GBK: dùng `response.html('gbk')` qua `lib/gbk.js`; tìm kiếm qua WebView submit form để tự encode GBK | `jjwxc/src/gbk.js`, `jjwxc/src/search.js`, kiểm chứng live 19/11/2026 |

## 7. Chưa xác định (không đoán)

- **Font encryption:** chưa có site nào vừa mở (chương free) vừa dùng font encryption để kiểm chứng trực tiếp trong đợt này. Cơ chế ở mục 4 là mô tả kỹ thuật chung, chưa được xác nhận bằng mẫu thật. Nếu sau này gặp site như vậy mà chương free: cần fetch 1 chương free + kiểm tra `@font-face` và đối chiếu text DOM với text hiển thị rồi mới kết luận.
- **Big5:** chưa kiểm chứng `response.html('big5')` có chạy trên runtime vBook thật không.
- **Hiệu năng WebView trên máy thật:** thời gian launch + poll cho chương dài chưa được đo (8book chỉ ghi nhận ch.1 2.116 ký tự, ch.2 3.610 ký tự).
- **Cloudflare trên 3 site mẫu:** lần fetch này không gặp challenge — kết luận "không bị chặn" chỉ đúng cho thời điểm 19/11/2026 và IP hiện tại; Cloudflare có thể bật challenge theo IP/thời điểm khác nhau.
