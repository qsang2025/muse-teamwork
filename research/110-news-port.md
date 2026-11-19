# Nghiên cứu port loại extension `news` từ Darkrai9x về Qsang_vbook

- Ngày nghiên cứu: 20/11/2026 ~00:10–00:30 +07:00 (muse-1, task 110) — Anh duyệt 20/11 00:01 (chat Vbook): giao Ú (110, loại `news`) + Vịt (111, loại `forum`) nghiên cứu xem 2 loại extension mới của Darkrai9x có đáng port về Qsang_vbook không. **Chỉ nghiên cứu — không sửa Qsang_vbook, không merge.**
- Nguồn đọc: fork nhà `qsang2025/vbook-extensions_Darkrai9x` (master `211fc62`, clone về máy này để đọc), trọng tâm `.agents/skills/vbook-extensions/templates/news/` + mục "News & Forum Extensions" trong `extension-api.md` + 2 commit `5df84a4` ("Sync extension API: news and forum types, explore tabs, endless last section") và `211fc62` ("Show forum page numbers, explore tabs and endless feeds in the templates"). Đối chiếu phía Qsang_vbook: `extension-api.md` (2 bản copy), `tools/cli/validate.js`, `tools/cli/build.js`, `tools/cli/build-catalog.js`, `scripts/cli.js`, `scripts/vbook.js`, `templates/`, skill `.agents/skills/vbook-extensions/` (SKILL.md, modes, reference).
- Kết luận ngắn: **ĐỂ SAU.** Port được về kỹ thuật và chi phí hạ tầng thấp (validate + đồng bộ doc + 1 template), nhưng hiện **chưa có nhu cầu thật được xác nhận** (Anh dùng vBook đọc truyện, chưa từng xin đọc tin trong vBook), **chưa kiểm chứng app vBook trên điện thoại Anh có hỗ trợ loại `news` không**, và **upstream cũng chưa có extension `news` thật nào** (chỉ có template + hợp đồng API) nên không có mẫu chạy thật để đối chiếu. Chỉ chuyển thành NÊN PORT khi đủ 2 điều kiện: (1) probe trên máy thật xác nhận app hỗ trợ (cách làm ở mục 4, ~15 phút), (2) Anh chốt muốn đọc ít nhất 1 site tin cụ thể trong vBook (gợi ý VnExpress trước, mục 3). Nếu loại `forum` (task 111) cũng được duyệt thì gộp chung 1 task hạ tầng cho cả 2 loại.

## 0. Chống trùng (PROTOCOL §3)

- **Repo đích Qsang_vbook:** registry `plugin.json` có 119 nguồn — `novel` 74, `chinese_novel` 42, `comic` 1, `video` 2; **0 nguồn `news`/`forum`**. Chưa có `templates/news/` (cả ở gốc `templates/` lẫn `.agents/skills/vbook-extensions/templates/`), chưa có thư mục `extensions/news/`. Không trùng.
- **Tasks claimed/doing/review lúc bắt đầu (00:10):** 103 (doing, muse-2, ShuShuWu), 105 + 106 (review, muse-1, TruyenTV/TruyenDich), 111 (claimed, muse-2 — loại `forum`, việc khác, không trùng loại `news` của task này). Không có task nghiên cứu/build `news` nào khác đang mở.
- **Upstream Darkrai9x:** quét toàn bộ `plugin.json` trong fork — chỉ có đúng 2 file mang `"type": "news"` / `"type": "forum"` là 2 template trong `.agents/skills/vbook-extensions/templates/`; **không có extension thật nào thuộc 2 loại này** (không có thư mục registry `news.json`/`forum.json` ở gốc). Nghiên cứu này dựa trên template + hợp đồng API, đúng như task đã lưu ý.

## 1. Hợp đồng loại `news` bên upstream

Đọc từ template `templates/news/` (6 file: `plugin.json`, `config.js`, `home.js`, `genre.js`, `search.js`, `article.js`) và mục "News & Forum Extensions" + các bảng liên quan trong `extension-api.md` upstream (bản sau commit `5df84a4` + `211fc62`):

- **Script:** `home`, `genre`, `search`, `article` (+ `config.js` là helper được `load()`). **Không có `detail`/`toc`/`chap`/`page`/`track`** — đây là khác biệt cốt lõi so với các loại truyện.
- **Bắt buộc:** `article` + ít nhất 1 nguồn list (`home`/`explore`/`genre`/`search`). Trong bảng "Required scripts per type", `search` của `news` là tùy chọn (○), nhưng template vẫn dùng `search.js` làm script list dùng chung cho tab của `home.js`/`genre.js` (query bắt đầu bằng `/` hoặc URL tuyệt đối = đường dẫn chuyên mục, còn lại = từ khóa tìm kiếm).
- **Luồng đọc:** chạm 1 item trong list → chạy thẳng `article.js` với `link` của item, **không qua trang detail**. App lưu item vào lịch sử trước (tên + ảnh lấy từ item), nên `article.js` chỉ phải trả phần còn lại.
- **Item list** dùng chung contract list hiện tại (`data` = items, `data2` = token trang sau) cộng thêm 2 trường cho `news`: `author`, `time` (chuỗi hiển thị hoặc epoch giây/mili-giây). `description` là đoạn lead của bài.
- **`article.js`** — `execute(url)` trả: `name`, `author`, `cover`, `time`, `edited_time`, `source_name`, `tags` (mảng chuỗi), `content` (HTML hoặc Markdown), `content_format` (`html` mặc định / `markdown`), `comments` tùy chọn (đúng dạng `comments` của `detail.js`).
- **Section explore mới:** `news_hero` (item đầu là thẻ ảnh rộng, còn lại là hàng bài viết), `news_list` (hàng bài viết, ảnh bên phải). Cơ chế "section cuối cuộn tiếp" (endless last section, commit `5df84a4`/`211fc62`) áp dụng cho cả `news_hero`/`news_list` khi section cuối tự tải và script trả `data2` khác rỗng.
- **Bảng Item `type`** có thêm dòng `news`/`forum` = mở thẳng reader; item của extension `news` luôn được xử lý như vậy bất kể script khai `type` gì.
- **Đọc bằng giọng nói (TTS):** bài `news` được đọc như 1 chương; doc dặn viết `content` thành đoạn văn thật vì đó là phần giọng đọc đọc. Cài đặt chữ + dịch của reader áp dụng như truyện.
- **Giới hạn cần biết:** `regexp` (khớp URL dán/chia sẻ để mở đúng extension) theo doc chỉ áp dụng cho `novel`/`comic`/`audio`/`video` — extension `news` **không mở được từ link dán vào app**. Đây là giới hạn của app, không phải lỗi template.
- **Phân biệt 2 nghĩa của "news":** upstream ghi rõ `news` vừa là **extension type** mới, vừa là giá trị legacy mà `detail` có thể trả về. Doc Qsang hiện tại ghi ngược lại ("`ebook` and `news` are not extension types") — khi đồng bộ doc phải sửa câu này.
- Template upstream dùng `locale: "vi"`, `encrypt: true`, `author: "vBook"` — khác chuẩn Qsang (xem mục 2), nên **không copy nguyên văn được**.

## 2. Đối chiếu Qsang_vbook — chỗ phải đổi/thêm nếu port

| Hạng mục | Hiện trạng Qsang_vbook | Phải làm khi port |
|---|---|---|
| `tools/cli/validate.js` — `TYPES` | `["novel","comic","chinese_novel","video","audio","translate","tts","ai"]` — **thiếu `news`** | Thêm `"news"` (và `"forum"` nếu gộp 111). **Hôm nay extension `news` sẽ FAIL validate** ở kiểm tra (f). Validate không ép "script bắt buộc theo type" (chỉ kiểm tra script map tồn tại, không file mồ côi, type/locale thuộc tập chuẩn, zip khớp `src/`, linter Rhino ES6) nên không phải thêm rule mới. |
| `validate.js` — `LOCALES` | `["vi_VN","zh_CN","ja_JP","en_US","zh_TW"]` | Không đổi; template port phải dùng `vi_VN` (upstream dùng `vi` → sẽ fail nếu copy nguyên). |
| `extension-api.md` (2 bản copy giống hệt nhau: gốc repo + `.agents/skills/vbook-extensions/reference/`) | Thiếu: dòng `news`/`forum` trong bảng `type` values; `article`/`posts` trong bảng script; cột `news`/`forum` trong bảng required scripts; section `news_hero`/`news_list`/`board_list`/`thread_list`; dòng `news`/`forum` trong bảng Item `type`; toàn bộ mục "News & Forum Extensions"; câu "`ebook` and `news` are not extension types" đang sai so với upstream mới | Đồng bộ cả 2 bản từ upstream (diff hiện tại: 367 dòng khác nhau, phần lớn là mục news/forum + bảng thêm cột + trôi nhẹ khác), rà lại phần Qsang đã tùy biến trước khi ghi đè. |
| Skill `SKILL.md` | Dòng liệt kê template: "`templates/novel`, `chinese_novel`, `comic`, `audio`, `video`, `tts`, `translate`, `ai`" — thiếu `news`/`forum` | Thêm `news` (và `forum` nếu gộp). |
| `reference/type-contracts.md` | Chưa có mục News/forum (upstream có 1 mục "News and forum") | Thêm mục tương ứng. |
| `modes/create.md`, `test.md`, `verify-checklist.md` | Chưa nhắc `news`/`article` (upstream `create.md` đã thêm: "news: article; forum: posts, replacing 1–3") | Bổ sung tối thiểu: thứ tự test cho `news` = list (`home`/`genre`/`search`) → `article`, không có detail/toc/chap. |
| `templates/news/` | Chưa có. Lưu ý cấu trúc: upstream chỉ để template trong `.agents/skills/.../templates/`, còn Qsang có template ở **2 chỗ giống hệt nhau** (gốc `templates/` + `.agents/skills/.../templates/`, đã `diff -rq` xác nhận không lệch) và SKILL.md ghi nguồn chuẩn là gốc `templates/<type>/` | Tạo `templates/news/` ở cả 2 chỗ, **thích ứng theo chuẩn Qsang** chứ không copy nguyên upstream: `locale: "vi_VN"`, `encrypt: false`, `author: "Qsang"`, config `DOMAIN` (+ `MIRRORS` như template `novel` của Qsang nếu muốn), pacing/helper theo luật nhà. Template `novel` của Qsang cũng đã khác upstream (có thêm `book.js`, `helper.js`) nên tiền lệ thích ứng đã có. |
| `extensions/news/` + registry | Chưa có thư mục loại `news` | Tạo thư mục khi có ext đầu tiên. `tools/cli/build-catalog.js` quét `extensions/<loại>/<tên>/` tổng quát, **không hardcode danh sách type** → registry tự sinh, không phải sửa code. `tools/cli/build.js` đóng zip tổng quát → dùng nguyên. |
| `scripts/vbook.js` (test qua dev server) | Giống hệt bản upstream (đã `diff -q` xác nhận). `testall` chọn `search.js` nếu có, không thì `home.js` | Dùng nguyên: ext `news` có `search.js` nên `testall` chạy được; `article.js` test được bằng lệnh `test <ext> article.js <url>` như mọi script khác. |
| `scripts/health-check.js` | Kiểm tra tổng quát theo `metadata.source` | Dùng nguyên. |
| `AGENTS.md` (dòng ~89) | Liệt kê type chuẩn theo `extension-api.md` | Thêm `news` vào danh sách khi doc đã đồng bộ. |
| Đã hỗ trợ sẵn, không phải đổi | `fetch`/`html`/`Response`/`load()`; contract list script (`data2` = trang sau); explore section tự tải (`script`/`input`); `test.json` golden fixture dạng `{"script","input","expect"}` (tổng quát theo tên script nên dùng cho `article.js` được); cơ chế merge 3 điều kiện (validate PASS + device test 0 + install 200) | — |

Tóm lại phần hạ tầng phải sửa là nhỏ và khu trú: **1 dòng trong `validate.js` + đồng bộ doc (2 bản) + 3 file skill/AGENTS + 1 thư mục template ×2 chỗ**. Không phải sửa `build.js`, `build-catalog.js`, `vbook.js`, `health-check.js`.

## 3. Nhu cầu + site gợi ý

**Nhu cầu:** 119 nguồn hiện tại của Qsang_vbook đều là truyện/video; Anh dùng vBook để đọc truyện và chưa từng xin đọc tin trong vBook. Điện thoại đã có trình duyệt + app tin nên "đọc tin trong vBook" mặc định chỉ là "có thì tốt". Giá trị cộng thêm thật của loại `news` trong vBook gồm: (a) **nghe đọc TTS** — Anh có thói quen học bằng giọng nói khi lái xe (không nhìn màn hình), bài tin được TTS đọc như 1 chương thì dùng được đúng lúc đó; (b) đọc trong giao diện reader sạch, không quảng cáo chen; (c) cùng 1 app với kho truyện. Giá trị (a) là lý do duy nhất đủ mạnh để làm, và nó chỉ có ý nghĩa nếu Anh thật sự muốn nghe tin khi lái xe — điểm này cần Anh xác nhận, em không tự suy diễn thành nhu cầu.

**Site free gợi ý** (kiểm chứng live 20/11 ~00:15, trang chủ trả HTTP 200 với UA mobile; mới kiểm chứng trang chủ — selector trang bài, mức JS-render và chống bot phải kiểm chứng lúc build như mọi extension):

1. **VnExpress** (`vnexpress.net`) — tin tổng hợp lớn nhất Việt Nam, HTML render phía server, chuyên mục rõ ràng, có tìm kiếm. Ứng viên build đầu tiên nếu port.
2. **CafeF** (`cafef.vn`) — tài chính, giá vàng, giá xăng dầu — đúng mảng Anh đang theo dõi.
3. **Genk** (`genk.vn`) — công nghệ/AI — đúng hướng học AI của Anh.

Đã thử thêm `tuoitre.vn`, `thanhnien.vn`, `dantri.com.vn`, `zingnews.vn`, `tinhte.vn` — tất cả đều trả 200. `tinhte.vn` thiên về diễn đàn nên thuộc loại `forum` (task 111) hơn là `news`. Lưu ý luật nhà: bài trả phí (một số bài VnExpress có paywall) phải báo lỗi rõ ràng, không vượt; không đăng nhập, không token.

## 4. Rủi ro app điện thoại + cách kiểm chứng (không tự test trong task này)

**Rủi ro chính:** app vBook trên điện thoại Anh có hỗ trợ `type: "news"` không. Theo `extension-api.md`, type thiếu/lạ được app coi là `novel` — tức app cũ sẽ đòi `detail`/`toc`/`chap` của một extension `news` và hỏng. Upstream cũng chưa có extension `news` thật nào nên không có bằng chứng chạy thật để đối chiếu; đây là ẩn số lớn nhất của việc port.

**Cách kiểm chứng bằng probe tối thiểu qua dev mode (~15 phút, Anh hoặc muse-main làm trên máy thật — task này không tự cài/test):**

1. Bật dev server trên điện thoại: chạm 7 lần vào tên phiên bản trong app vBook → bật "Chế độ nhà phát triển", ghi lại IP:port hiển thị (theo README upstream; điện thoại và máy chạy CLI cùng mạng LAN/Tailscale).
2. Dựng probe `news` tối thiểu: `plugin.json` với `"type": "news"`, `home.js` trả 2–3 item cứng, `article.js` trả nội dung cứng (không fetch mạng) — cố ý tối thiểu để tách lỗi "app không hỗ trợ type" khỏi lỗi "site/selector".
3. Cài probe lên điện thoại qua `node scripts/vbook.js install <thư-mục-probe>` (hoặc nút Cài của vBook Tester), mở extension trong app và kiểm tra 3 điểm: (a) thấy tab/list; (b) chạm item mở **thẳng reader** với nội dung của `article.js` (không qua trang detail, không báo thiếu `detail`/`toc`); (c) nút nghe TTS đọc được `content`. Nếu probe có `explore.js` thì kiểm tra thêm section `news_list`/`news_hero` hiển thị đúng.
4. Đạt cả (a)–(c) → app hỗ trợ, mới tính port. Không đạt → dừng tại đây, không port (chờ app cập nhật rồi probe lại).

**Rủi ro phụ:** layout site tin đổi thường xuyên và HTML bài chứa nhiều quảng cáo/bài liên quan/nhúng → chi phí bảo trì cao hơn site truyện; site tin lớn thường có chống bot/rate-limit nên vẫn cần pacing 1 luồng như các ext truyện hiện tại.

## 5. Kết luận: ĐỂ SAU

- **Không phải KHÔNG NÊN:** về kỹ thuật port được, hợp đồng đơn giản hơn loại truyện (ít script hơn: không detail/toc/chap/page), chi phí hạ tầng thấp và khu trú (mục 2), tooling build/test/registry dùng nguyên.
- **Chưa phải NÊN PORT ngay:** chưa có nhu cầu thật được Anh xác nhận, chưa kiểm chứng app trên máy Anh hỗ trợ, upstream chưa có ext mẫu chạy thật. Làm ngay là xây trên 2 giả định chưa kiểm chứng.
- **Điều kiện chuyển thành NÊN PORT:** (1) probe mục 4 đạt trên máy thật; (2) Anh chốt muốn đọc ít nhất 1 site tin cụ thể trong vBook (gợi ý VnExpress trước). Thiếu 1 trong 2 thì giữ ĐỂ SAU.
- **Nếu port, các bước cụ thể:**
  1. **Task hạ tầng** (1 task, gộp chung `forum` nếu task 111 cũng được duyệt): thêm `"news"` (+`"forum"`) vào `TYPES` của `validate.js`; đồng bộ `extension-api.md` cả 2 bản; bổ sung `type-contracts.md`, `SKILL.md`, `modes/create.md` + `test.md`, `AGENTS.md`; tạo `templates/news/` ở cả 2 chỗ theo chuẩn Qsang. Ước lượng: 1 task agent, chỉ cần `validate` ở cuối, không cần máy thật.
  2. **Task build VnExpress (`news`)** (1 task/site): `home`/`genre`/`search`/`article` + `test.json`, kiểm chứng selector trang bài live, device test + install như thường lệ — chỉ merge khi validate PASS + device test 0 + install 200, muse-main là người merge.
  3. CafeF/Genk chỉ làm khi Anh dùng thật VnExpress trong vBook và muốn thêm.
- **Phối hợp với task 111 (`forum`):** phần hạ tầng doc/validate dùng chung cho cả 2 loại. Nếu chỉ 1 loại được duyệt, vẫn nên đồng bộ doc đủ cả 2 mục của upstream để khỏi lệch doc lần nữa, nhưng chỉ thêm vào `TYPES` của validate loại được duyệt.
