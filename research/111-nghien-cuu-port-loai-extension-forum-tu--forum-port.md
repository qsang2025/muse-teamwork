# Nghiên cứu port loại extension forum từ Darkrai9x về Qsang_vbook

- Task: `111-nghien-cuu-port-loai-extension-forum-tu-` (muse-2)
- Ngày: 2026-11-20 (nghiên cứu 00:05–00:30 +07)
- Nguồn đọc: fork nhà `https://github.com/qsang2025/vbook-extensions_Darkrai9x`, master `211fc62`
  (đã sync với Darkrai9x; clone về `/tmp/vbook-extensions_Darkrai9x` để đọc)
- Đối chiếu: Qsang_vbook local `~/workspace/Qsang_vbook` (main, đã `git pull`, up to date)
- Phạm vi: CHỈ NGHIÊN CỨU — không sửa Qsang_vbook, không merge.

## 1. Kết luận trước

**NÊN PORT — nhưng CÓ ĐIỀU KIỆN: chỉ port sau khi kiểm chứng app vBook trên điện thoại
của Anh hỗ trợ loại `forum`.** Hợp đồng API phía extension đã đầy đủ, rõ ràng, và
phần việc phía repo Qsang_vbook là nhỏ (chủ yếu là tài liệu + template + 1 dòng
validate). Rủi ro duy nhất — và là rủi ro chặn — nằm ở phía app: nếu bản vBook
trên điện thoại Anh cũ hơn tính năng này, extension `forum` sẽ không chạy được
dù repo port xong. Vì vậy thứ tự đúng là: **(1) probe trên điện thoại trước,
(2) port repo sau**. Không nên port mù rồi mới phát hiện app không hỗ trợ.

Nếu app hỗ trợ: port xong mở ra được 2–3 extension forum tiếng Việt đọc miễn phí
(tinhte.vn, otofun.net.vn là ứng viên chắc chắn nhất; xem §5).

## 2. Hợp đồng API loại `forum` bên upstream (đã đọc kỹ)

### 2.1. Hai commit nguồn

| Commit | Ngày | Nội dung |
|---|---|---|
| `5df84a4` "Sync extension API: news and forum types, explore tabs, endless last section" | 19/11 16:36 +07 | API + template mới: 18 files, +733/−56 dòng |
| `211fc62` "Show forum page numbers, explore tabs and endless feeds in the templates" | 19/11 16:38 +07 | Bổ sung nhỏ: 7 files, +20/−1 dòng (số trang forum, tab explore, feed vô hạn trong template) |

### 2.2. Mô hình hoạt động

```
home / explore / genre / search  ──►  danh sách thread  ──tap──►  posts.js, từng trang
```

- `"type": "forum"` là nguồn **chỉ đọc (read-only), không có trang detail**:
  bấm vào thread trong danh sách thì mở thẳng reader, không qua `detail.js`.
- App lưu item vào history trước (lấy `name`, `cover` từ list item), nên
  `posts.js` chỉ cần trả về nội dung các post.
- **Script bắt buộc: `posts` + ít nhất 1 list source** (`home`, `explore`,
  `genre` hoặc `search`). **Không có `detail` / `toc` / `chap`.**
- Template đầy đủ gồm 6 file: `plugin.json`, `config.js`, `genre.js`,
  `home.js`, `posts.js`, `search.js` (xem §2.5).
- `search.js` kiêm luôn script liệt kê cho tab home/genre: `query` bắt đầu
  bằng `/` hoặc `http` được hiểu là đường dẫn chuyên mục, không phải từ khóa
  tìm kiếm. Thread ghim (pinned) phải tự xếp lên đầu trong script.
- Board (chuyên mục) là một dạng list item: `link`/`action` của board thường
  mở danh sách thread (`{ type: "list", ... }`).

### 2.3. `posts.js` — `execute(url, page)`

- `url` là `link` của thread; `page` là token lần gọi trước trả về ở `data2`
  (rỗng ở lần đầu).
- Trả về **1 trang post** ở `data`, token trang tiếp ở `data2` (rỗng khi hết).
- **Hiển thị số trang + nhảy trang (tùy chọn):** trả `data` dạng object
  `{ posts, page, total_pages }` và giữ token là số trang (`"1"`, `"2"`, …;
  lần đầu `page` rỗng nghĩa là 1). App sẽ gọi `posts(url, "7")` để nhảy tới
  trang 7. Không có `total_pages` thì app chỉ tải nối tiếp từng trang.
- Mỗi post có các trường: `id` (hoặc `floor` để dedup qua các trang),
  `floor`, `url` (permalink), `is_op`, `time` (text hiển thị hoặc epoch),
  `user` (`name` bắt buộc; thêm `id`, `avatar`, `link`, `title`, `role`,
  `badges[]`, `joined`, `posts_count` (number), `reputation`, `online`),
  `content` + `content_format` (`"html"` | `"markdown"`), `signature` (+
  `signature_format`), `edited` (`{ time, by, reason }`), `likes`,
  `dislikes`, `reactions` (`[{ type, count }]`, `type` là text, vd emoji),
  `reply_to` (`{ floor, user }`), `attachments` (`[{ type, link, name, size }]`,
  bấm vào mở link).
- App **không** đăng bài, không like, không trả lời: nguồn chỉ đọc.
- Đọc to (TTS): thread được đọc **từng trang một**, mỗi post dạng
  "tác giả: nội dung", dừng ở cuối trang; câu đang đọc được highlight và
  reader cuộn tới post đang đọc. Vì vậy `content` phải viết thành đoạn văn
  thật, không phải HTML rời rạc.

### 2.4. List item thread / board + section types mới

Trường list item (thêm vào `name`, `cover`, `link`, `description`, `tag`
thường lệ; tất cả tùy chọn, string trừ khi ghi khác):

| Trường | Thread | Board | Ý nghĩa |
|---|---|---|---|
| `author`, `time` | ✓ | | Tên tác giả; text hiển thị hoặc epoch giây/ms |
| `avatar` | ✓ | | Avatar tác giả |
| `replies`, `views` | ✓ | | Số lượng dạng text muốn hiển thị (`"1.2K"`) |
| `board` | ✓ | | Tên board |
| `last_post` | ✓ | | `{ user, time }` của post mới nhất |
| `pinned`, `locked`, `hot` | ✓ | | Boolean (hiện ghim/khóa, hoặc số reply màu đỏ) |
| `threads`, `posts` | | ✓ | Số lượng của board, dạng text |

- `description` là lead của bài / mô tả của board.
- Section types explore mới: `news_hero`, `news_list` (tin),
  `board_list`, `thread_list` (forum); các type cũ (`grid`, `list`, `chip`, …)
  vẫn dùng bình thường.
- Item của extension `news`/`forum` luôn mở thẳng reader, bất kể `type` mà
  script khai báo (quy tắc trong bảng item `type` của API).

### 2.5. Template `forum` upstream (nguyên văn cấu trúc)

`plugin.json` — `metadata.type: "forum"`, `regexp` mẫu
`site\.com/threads/[^/]+/?$`, `script` map chỉ có 4 khóa:

```json
{ "home": "home.js", "genre": "genre.js", "search": "search.js", "posts": "posts.js" }
```

- `home.js`: trả 2 tab mẫu (`Mới nhất` → `/tin-moi`, `Nổi bật` → `/noi-bat`,
  đều chạy `search.js`); tab có `type: "explore"` thì mở trang explore thay
  vì list (script được gọi dạng `execute(input)`, trả về sections như
  `explore.js`).
- `genre.js`: GET `BASE_URL + "/the-loai"`, mỗi genre trỏ `script: "search.js"`.
- `search.js`: danh sách thread/board; URL dạng `?page=`; item có đủ các
  trường ở §2.4; `data2` là số trang tiếp.
- `posts.js`: như §2.3; có `normalizeUrl()` trong `config.js` để viết lại host
  (mirror/www) về `BASE_URL`; `config` `DOMAIN` cho phép đổi domain trong app.
- `config.js`: mẫu `BASE_URL` + `DOMAIN` giống hệt các template khác của
  upstream.

### 2.6. Tính năng đi kèm trong cùng 2 commit (không riêng forum)

- **Explore tab** (`type: "explore"` trên tab home hoặc mục genre): mở trang
  explore thay vì list. Áp dụng cho mọi loại extension, không riêng forum.
- **Section cuối cuộn vô hạn (endless last section):** section cuối của trang,
  tự tải riêng, layout dọc (`grid`, `list`, `news_hero`, `news_list`,
  `thread_list`, `board_list`), script trả `data2` không rỗng → app gọi tiếp
  `execute(input, data2)` khi cuộn tới cuối, tới khi `data2` rỗng/lặp/không
  thêm item mới. Item trùng `link` bị loại. Các section khác chỉ hiện trang đầu.
- **Comment tag trên ảnh:** `<comment>` ngay sau `<img>` thì vẽ pill
  "N comments" ở góc dưới phải của ảnh (trước đây chỉ tính cho đoạn văn trên).
- Ghi chú trong API: "Apps older than this feature show dynamic sections empty"
  — tức **app cũ không crash, chỉ hiện section động rỗng**. Điều này quan trọng
  cho §6: nếu app Anh quá cũ, probe forum có thể chỉ hiện trang trắng chứ
  không báo lỗi rõ ràng.

### 2.7. Upstream CHƯA CÓ extension mẫu loại forum/news

Đã kiểm chứng: trong fork có **105 file `plugin.json`**, chỉ đúng 2 file mang
`"type": "news"` / `"type": "forum"` — chính là 2 template
(`.agents/skills/vbook-extensions/templates/news/plugin.json` và
`.../templates/forum/plugin.json`). Không có extension thật nào để đối chiếu
hành vi chạy thực tế; mọi kết luận dưới đây dựa trên template + API doc.
Đây cũng là lý do probe trên điện thoại (§6) là bước bắt buộc, không thể thay
bằng đọc code.

## 3. Đối chiếu Qsang_vbook — những chỗ phải đổi/thêm

Qsang_vbook hiện tại (main, đã pull 20/11): **không có gì của loại `forum`**
(grep `forum` trong toàn repo chỉ ra 0 kết quả ở code/docs; `news` chỉ xuất
hiện với nghĩa cũ — xem §3.1). Dưới đây là danh sách CHÍNH XÁC, chia theo
mức độ.

### 3.1. Chỗ đã có sẵn (không cần đổi)

- `news` với nghĩa **giá trị của `detail.type`**: `extension-api.md` dòng 139
  ghi "`ebook` and `news` are not extension types — they are values of
  `detail`'s `type` field". Đây là nghĩa legacy, khác với extension type
  `news` của upstream; khi port phải sửa câu này theo upstream
  ("`news` is both: an extension type, and the legacy value a detail can
  still return").
- **Build/catalog/health-check không kẹt type:** `tools/cli/build.js`,
  `tools/cli/build-catalog.js`, `scripts/cli.js` (`listExtDirs`), và
  `scripts/health-check.js` đều quét `extensions/<loại>/<tên>/` và lấy type
  từ thư mục/`metadata.type` — type-agnostic, không có danh sách type cứng.
  Registry (`plugin.json`/`repository.json` ở root) cũng lấy `type` từ
  manifest. Thêm thư mục `extensions/forum/<tên>/` là các script này tự nhận.
- **Test qua dev server không kẹt tên script:** `.agents/skills/vbook-extensions/scripts/vbook.js`
  lệnh `test` truyền tên script bất kỳ xuống `/extension/test` trên điện
  thoại, không có allowlist — `posts.js` test được như `detail.js`, miễn là
  app hiểu nó.
- **Lint/orphan-file:** `validate.js` chỉ yêu cầu script trong map phải tồn
  tại trong `src/`, file `.js` mồ côi phải được `load()` hoặc khai báo, và
  `config.js`/`helper.js` được miễn — `posts.js` + `config.js` của template
  forum khớp luật này ngay, không cần sửa.

### 3.2. BẮT BUỘC — chặn validate (1 dòng, nhưng không có thì mọi extension forum đều FAIL)

- **`tools/cli/validate.js:51`** — danh sách type chuẩn hiện tại:

  ```js
  const TYPES = ["novel", "comic", "chinese_novel", "video", "audio", "translate", "tts", "ai"];
  ```

  Dòng 611–613: type ngoài danh sách → `err(...)` (lỗi cứng, validate FAIL).
  **Phải thêm `"news", "forum"`** (và giữ `"chinese_novel"` — type riêng của
  nhà, upstream không có). Đây là điểm chặn duy nhất ở phía tooling.
- **`docs/verify-checklist.md:17–19`** — checklist ghi type chuẩn
  (`novel`, `chinese_novel`, `comic`, `video`, `audio`, `translate`, `tts`,
  `ai`); thêm `news`, `forum` cho khớp.
- Lưu ý: `validate.js` **không** kiểm tra script bắt buộc theo từng loại
  (không có logic "novel phải có detail/toc/chap"). Vì vậy sau khi thêm type,
  một extension forum thiếu `posts.js` vẫn qua validate tĩnh — nên cân nhắc
  thêm kiểm tra nhẹ: `forum` phải có `posts` + ≥1 list source
  (`home`/`explore`/`genre`/`search`); `news` phải có `article` + ≥1 list
  source. Đây là cải tiến nên làm, không phải chặn.
- Lưu ý 2: dòng 619–621 của validate yêu cầu thư mục phải khớp
  `metadata.type` (layout `extensions/<loại>/<tên>/`) — extension forum đặt
  đúng `extensions/forum/<tên>/` là khớp, không cần sửa luật.

### 3.3. BẮT BUỘC — tài liệu + template (port từ upstream, có chọn lọc)

| File Qsang_vbook | Việc phải làm |
|---|---|
| `extension-api.md` (root) **và** `.agents/skills/vbook-extensions/reference/extension-api.md` (2 bản copy, hiện giống hệt nhau — `diff` không khác) | Thêm `news`/`forum` vào bảng `type`; thêm `article`/`posts` vào bảng `script`; thêm 2 cột vào bảng script-bắt-buộc theo loại; thêm mục mới "News & forum extensions" (toàn bộ §2.2–2.4); thêm 4 section types (`news_hero`, `news_list`, `board_list`, `thread_list`); thêm action type `explore`; thêm quy tắc endless-last-section + tab/genre `type: "explore"`; sửa câu về `news` legacy (§3.1); thêm ghi chú comment-tag trên ảnh |
| `templates/forum/` (mới, cả 2 nơi: `templates/` ở root là canonical theo SKILL.md dòng 34, và `.agents/skills/vbook-extensions/templates/`) | Copy 6 file template upstream (`plugin.json`, `config.js`, `genre.js`, `home.js`, `posts.js`, `search.js`), chỉnh theo quy ước nhà: kiểm tra xem template nhà có dùng helper `lib/` (vd `fetch-helpers.js`, `cleanHtml.js`) không rồi quyết định có giữ nguyên mẫu upstream hay lồng helper vào; giữ `regexp` mẫu, thay `SELECTOR_*` khi build extension thật |
| `.agents/skills/vbook-extensions/reference/type-contracts.md` | Thêm mục "News and forum" như upstream (yêu cầu `posts`/`article`, bỏ `detail`/`toc`/`chap`, section types, TTS đọc theo trang) |
| `.agents/skills/vbook-extensions/reference/runtime.md` | Thêm quy tắc endless-last-section + tab/genre `type: "explore"` |
| `.agents/skills/vbook-extensions/SKILL.md` | Thêm `news`, `forum` vào danh sách template + danh sách type được hỗ trợ |
| `docs/EXTENSION_DEVELOPMENT_GUIDE.md` | Thêm loại forum vào hướng dẫn (nếu file này liệt kê loại) — kiểm tra khi port |

### 3.4. KHÔNG CẦN — nhưng được hưởng ké

- Tính năng explore-tab + endless-last-section là hành vi **phía app**;
  repo chỉ cần ghi tài liệu. Khi port, các template hiện có (`novel`,
  `comic`, `video`, `audio` — upstream commit `211fc62` cũng đã thêm ghi chú
  endless-feed vào 4 `explore.js` mẫu của họ) có thể nhận thêm ghi chú tương
  tự, nhưng không bắt buộc.
- Không cần đổi `scripts/vbook.js`, `tools/cli/build*.js`, `health-check.js`,
  registry, hay `vbook-vscode-tester` (đã grep: không có danh sách type cứng).

### 3.5. Ước lượng độ lớn (nếu port)

- **Port repo (docs + template + validate + checklist): nhỏ.** ~1 task, ước
  nửa ngày: chủ yếu là dịch/chép có chọn lọc từ upstream (API doc upstream
  thêm ~250 dòng cho cả news+forum; phần forum chiếm khoảng một nửa), cộng
  template 6 file (~150 dòng) và 1 dòng `TYPES`. Không có logic mới phía
  tooling trừ kiểm tra script-bắt-buộc tùy chọn (§3.2).
- **Extension forum đầu tiên: 1 task riêng.** Viết selector thật cho 1 site,
  test `search.js` (list thread) + `posts.js` (đọc 1 thread nhiều trang) qua
  dev server, device test + install như mọi extension khác. XenForo
  (otofun, voz) có cấu trúc HTML ổn định, selector dễ viết.
- **Không đụng app:** toàn bộ hành vi reader/TTS/phân trang là code app
  Darkrai9x; repo Qsang_vbook không chứa code app nên không sửa được — chỉ
  kiểm chứng được qua probe (§6).

## 4. Nhu cầu — Anh có cần loại forum không?

Thành thật: **chưa rõ, và đây là câu hỏi chỉ Anh trả lời được.**

- Anh đọc truyện chữ Trung qua vBook; diễn đàn không phải nhu cầu anh từng
  nêu. Trong các site gợi ý ở §5, site gần với thói quen đọc truyện nhất là
  **tangthuvien.vn** (diễn đàn Tàng Thư Viện — truyện, convert, bàn luận),
  nhưng chính site này lại **không kiểm chứng được từ máy này** (§5).
- Hai site kiểm chứng chắc chắn (tinhte.vn — công nghệ; otofun.net.vn —
  ô tô) đều **không liên quan tới truyện**. Chúng chứng minh được kỹ thuật
  port, nhưng giá trị sử dụng với Anh phụ thuộc vào việc Anh có đọc 2 cộng
  đồng đó không — Chưa xác định.
- Vì vậy kết luận "NÊN PORT" ở §1 mang nghĩa **nên chuẩn bị sẵn năng lực
  (port repo) + làm 1 extension mẫu để chứng minh**, chứ không phải "Anh
  đang cần gấp". Nếu Anh xác nhận không đọc diễn đàn nào trong §5 thì port
  repo vẫn đáng làm (rẻ, để dành), nhưng không ưu tiên build extension thật.

## 5. Site gợi ý (đã kiểm chứng live từ máy này, 20/11 ~00:15 +07)

| # | Site | Kiểm chứng live | Kết quả | Ghi chú |
|---|---|---|---|---|
| 1 | **tinhte.vn** (diễn đàn công nghệ VN) | Trang chủ `200`, 1.6 MB HTML; trang thread `200`, 1.25 MB | **Đạt.** List SSR có marker `thread-title`; trang thread có `data-author` (post trong HTML, không cần JS) | Ứng viên số 1: lớn, ổn định, đọc free, không đăng nhập vẫn xem được thread |
| 2 | **otofun.net.vn** (cộng đồng ô tô VN, XenForo) | Trang chủ `200` (redirect từ `otofun.net`); 1 thread mẫu `200`, 183 KB | **Đạt.** 20 post trong HTML (`message-body`, `bbWrapper` ×20), phân trang `pageNav` ×32; link thread có trong HTML trang chủ | Ứng viên số 2: XenForo SSR chuẩn, selector theo mẫu forum cổ điển, rất hợp template `posts.js` |
| 3 | **voz.vn** (diễn đàn tổng hợp VN, XenForo) | Trang chủ + chuyên mục đều `403` | **Chưa kiểm chứng được.** Trả 403 anti-bot từ máy này (IP VM bị chặn) | Ứng viên điều kiện: cấu trúc XenForo giống otofun nên kỹ thuật làm được, nhưng cần test từ điện thoại Anh (IP nhà) mới biết có bị chặn không |
| — | **tangthuvien.vn** (diễn đàn truyện — gần Anh nhất) | `000` (timeout, 0 byte), cả `https://tangthuvien.vn/` và `https://www.tangthuvien.vn/` | **Chưa kiểm chứng được.** DNS phân giải ra dải `198.18.213.x` (dải proxy nội bộ của sandbox), kết nối TLS timeout — đây là giới hạn mạng của máy VM, không phải bằng chứng site chết | Ứng viên cần Anh/phone test nhất; nếu site sống và SSR như các forum XenForo khác thì là extension forum đúng nhu cầu đọc truyện nhất |
| — | reddit.com | `200` | Loại: JS-heavy, cần đăng nhập cho nhiều nội dung, không hợp mô hình fetch-HTML | Không gợi ý |

**Kết luận site:** đủ 2 site đạt chuẩn để làm extension mẫu ngay (tinhte,
otofun). Đề xuất làm **otofun trước** nếu build mẫu: XenForo SSR sạch nhất
trong các site đo được (post + phân trang đều có sẵn trong HTML), ít rủi ro
selector hơn tinhte (tinhte dùng markup riêng, marker post ít rõ ràng hơn).

## 6. Rủi ro lớn nhất: app vBook trên điện thoại Anh có hỗ trợ loại này không?

**Trạng thái: Chưa xác định.** Không có cách nào kết luận từ repo — tính năng
này sống trong code app Darkrai9x, và repo Qsang_vbook không chứa code app,
không ghi phiên bản app Anh đang dùng. Phiên bản app cần thiết là bản có chứa
2 commit API ngày 19/11 (tức bản publish sau `5df84a4`/`211fc62`); bản app
cũ hơn sẽ không có reader forum.

### Cách kiểm chứng (probe tối thiểu qua dev mode — KHÔNG tự cài/test trên máy Anh trong task này)

1. **Chuẩn bị probe (máy worker làm):** copy template `forum` upstream, điền
   selector thật tối thiểu cho 1 site đã đạt ở §5 (vd otofun: list thread
   trang chủ + `posts.js` lấy `.message-body`, `.message-userDetails`,
   phân trang `.pageNav`), đặt tên vd `forum-probe-otofun`, `type: "forum"`.
   Lưu ý: probe này **không qua được `validate` của repo** cho tới khi
   `TYPES` được vá (§3.2) — nhưng cài qua dev server thì không cần validate
   repo: dùng `node .agents/skills/vbook-extensions/scripts/vbook.js install
   <thư-mục-probe>` hoặc build `plugin.zip` rồi cài tay trong app.
2. **Anh làm trên điện thoại (khi Anh sẵn sàng):** mở app vBook, bật dev mode,
   cài probe; mở extension, bấm 1 thread.
3. **Đọc kết quả:**
   - **Hỗ trợ:** reader mở ra, hiện các post phân trang, có số trang/nhảy
     trang (nếu probe trả `total_pages`) → port repo + build extension thật.
   - **Không hỗ trợ:** bấm thread không làm gì / báo lỗi / rơi về màn hình
     detail trống / list hiện nhưng không mở được → app chưa có tính năng.
     Kiểm tra tiếp phiên bản app trong app (About) hoặc Play Store, cập nhật
     app rồi thử lại probe.
   - **Mập mờ:** trang mở ra nhưng trắng (không lỗi) → khớp với ghi chú
     upstream "apps older than this feature show dynamic sections empty":
     coi như **không hỗ trợ**, đừng cố sửa probe.
4. **Không tự test:** task này cấm tự cài/test trên máy Anh; các bước trên
   cần Anh (hoặc muse-main trên máy Anh) thực hiện, worker chỉ chuẩn bị probe.

### Rủi ro phụ

- **voz.vn / tangthuvien.vn chặn IP lạ:** nếu Anh đọc 2 site này thì extension
  vẫn có thể chạy trên điện thoại Anh (IP nhà khác IP VM), nhưng không thể
  kết luận từ máy này — cần device test trên điện thoại Anh như mọi extension
  khác.
- **Không có extension mẫu upstream:** không có gì để đối chiếu hành vi thật
  (vd cách app xử lý `total_pages` thiếu, `reactions`, `attachments`); probe
  phải tự bao quát các trường hợp này.
- **Forum là read-only:** không đăng bài/like/reply được — nếu Anh kỳ vọng
  tương tác thì loại này không đáp ứng; chỉ đọc.

## 7. Các bước cụ thể nếu port (theo thứ tự)

1. **Probe điện thoại (§6)** — chặn/gate. Nếu không hỗ trợ → dừng, kết luận
   ĐỂ SAU, ghi rõ phiên bản app cần thiết, không port repo.
2. **Port repo (1 task):** vá `tools/cli/validate.js` (`TYPES` += `news`,
   `forum`) + `docs/verify-checklist.md`; port 2 bản `extension-api.md`,
   `type-contracts.md`, `runtime.md`, `SKILL.md`; thêm `templates/forum/`
   (cả `templates/` root và `.agents/skills/vbook-extensions/templates/`);
   chạy `validate` toàn repo để chắc không vỡ extension cũ.
3. **Extension mẫu (1 task):** build `extensions/forum/otofun` (hoặc
   `tinhte`) theo đúng quy trình chuẩn: validate PASS + device test code 0 +
   install code 200, rồi mới trình muse-main merge. Chỉ muse-main merge.
4. **Hỏi Anh** (§4): Anh có đọc diễn đàn nào trong §5 không — đặc biệt
   tangthuvien.vn — để chọn site thứ hai; nếu không thì dừng ở 1 extension
   mẫu.

## 8. Checklist task

- [x] Đọc template + API doc loại forum bên upstream (commit `5df84a4` + `211fc62`)
- [x] Đối chiếu Qsang_vbook: skill/templates/API/CLI/validate/build-catalog/registry — liệt kê chỗ phải đổi (§3)
- [x] Gợi ý 2–3 site free phù hợp, kiểm chứng live 200 (§5: tinhte.vn, otofun.net.vn đạt; voz.vn 403, tangthuvien.vn timeout — cần phone test)
- [x] Ghi rõ cách kiểm chứng app điện thoại có hỗ trợ loại này (không tự test) (§6)
- [x] Báo cáo research + kết luận NÊN PORT (có điều kiện) + task sang review
