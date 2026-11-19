# Báo cáo task 112 — Port loại extension forum + build Otofun

- Task: `112-port-loai-extension-forum-build-otofun` (muse-2)
- Ngày: 2026-11-20 (làm lại sau vụ kẹt 00:32–02:30, xem `112-STALL-ROOT-CAUSE-2026-11-20.md`)
- Branch: `feature/112-forum-otofun` (từ main tip `9cc9f0a`, đã push)
- Repo đích: Qsang_vbook, registry 120 → **121 nguồn** sau build-catalog
- Kết quả: **validate PASS (121 nguồn, 0 cảnh báo)**; device test + install
  **CHƯA CHẠY — chờ duyệt kết nối điện thoại** (xem §5).

## 1. Hạ tầng port (chỉ `forum`, KHÔNG `news`)

- `tools/cli/validate.js:51`: `TYPES` += `"forum"` (1 dòng). `news` KHÔNG thêm
  (task 110 kết luận ĐỂ SAU, Anh chưa chốt đọc tin trong vBook).
- `templates/forum/` (mới, 6 file: `plugin.json`, `config.js`, `genre.js`,
  `home.js`, `posts.js`, `search.js`) — port từ upstream Darkrai9x
  (`.agents/skills/vbook-extensions/templates/forum/` trong fork), chỉnh theo
  quy ước nhà: `var`/function, comment tiếng Việt, `config.js` có
  `BASE_URL` + `DOMAIN`/`MIRRORS` + `normalizeUrl` + `toAbs` (theo mẫu
  `templates/novel/config.js`). Copy đồng bộ sang
  `.agents/skills/vbook-extensions/templates/forum/` (mirror, `diff -r` khớp).
- `extension-api.md` (cả 2 bản, md5 giống nhau `a3163cdf22a8d877e557f395326e6656`):
  thêm `forum` vào bảng `type`, `posts` vào bảng `script`, cột `forum` +
  hàng `posts` vào bảng "Required scripts per type", mục `forum` vào danh
  sách mô tả loại + bảng "per-chapter content", 2 section type
  (`board_list`, `thread_list`), 12 trường item forum
  (`author`, `time`, `avatar`, `replies`, `views`, `board`, `last_post`,
  `pinned`, `locked`, `hot`, `threads`, `posts`), ghi chú item forum luôn
  mở thẳng reader, mục mới `### posts.js` (hợp đồng + bảng trường post),
  mục "Endless last section" + "Explore tab" (từ cùng 2 commit upstream).
  Câu về `news` legacy giữ nguyên (news chưa port).
- `.agents/skills/vbook-extensions/reference/type-contracts.md`: thêm mục
  `Forum` (posts + ≥1 list source, không detail/toc/chap, TTS đọc theo trang).
- `.agents/skills/vbook-extensions/reference/runtime.md`: thêm quy tắc
  endless-last-section + tab/genre `type: "explore"`.
- `.agents/skills/vbook-extensions/SKILL.md`: thêm `forum` vào danh sách template.
- `docs/verify-checklist.md` + `docs/EXTENSION_DEVELOPMENT_GUIDE.md`: thêm
  `forum` vào danh sách type chuẩn.

## 2. Extension thật: `extensions/forum/otofun/` (Otofun, tác giả MuseAi)

- Nguồn probe không có trên máy này (probe do muse-main làm trên máy chị,
  `~/workspace/vbook/work/forum-probe-otofun` không tồn tại ở đây, không có
  branch `probe/otofun-forum` trên remote) nên build lại từ template +
  selector kiểm chứng live (không copy code probe). Cấu trúc theo template
  forum + quy ước nhà: `plugin.json`, `src/` (5 file), `icon.png` 200×200
  (từ `apple-touch-icon` 180×180 thật của site, resize — KHÔNG placeholder),
  `test.json` (8 case), `health.json` (5 case), `plugin.zip` 18.856 byte
  (build bằng CLI, đã commit kèm).
- `home.js`: 2 tab tĩnh — "Mới nhất" (`/whats-new/posts/`), "Quán cafe"
  (`/forums/quan-cafe-otofun.77/`). Tab `/find-threads/featured` 404,
  `/trending/` 404, `/find-threads/unanswered` 403 nên không dùng.
- `genre.js`: GET `/forums/`, 61 board (`.node--forum`), mỗi board trỏ về
  `search.js`. (Probe báo 62 — chênh 1 do 1 node trùng/khác cấu trúc, không
  ảnh hưởng.)
- `search.js`: 2 chế độ (xem §3).
- `posts.js`: xem §3 (lỗi 2).
- Không dùng lib-inline (script tự đủ, không load file lib nào).

## 3. Ba lỗi probe đã biết — cách sửa + kiểm chứng

### (1) Tìm từ khóa `/search?q=` trả 0 kết quả — ĐÃ SỬA: search chạy bằng POST

- Nguyên nhân: XenForo không có tìm kiếm GET. GET `/search/?q=BMW` trả trang
  form (0 kết quả). POST `/search/search` không token trả 400.
- Cách làm: `searchKeyword()` GET `/search/` lấy `_xfToken`, POST
  `/search/search` với `{keywords, _xfToken, search_type: "post",
  order: "date"}` (fetch theo redirect tới `/search/<id>/?q=...`), đọc kết
  quả dạng `.block-row` (KHÁC `.structItem` của danh sách): tiêu đề
  `.contentRow-title a`, tác giả `.contentRow-minor .username`, giờ
  `time[title]`, mô tả `.contentRow-snippet`, board = link
  "Diễn đàn:" (`.contentRow-minor a[href*="/forums/"]`), avatar
  `.contentRow-figure img`. Link kết quả trỏ tới 1 bài (`/post-...`) nên
  cắt về URL thread (`href.replace(/\/post-\d+.*$/, "")`). Phân trang kết
  quả dùng `?page=N` trên URL kết quả.
- Kiểm chứng bằng curl (trước khi otofun 503, xem §4): POST "BMW X1" → 200,
  20 kết quả/trang, tiêu đề "Kết quả tìm kiếm cho từ khóa: BMW X1"; POST
  "Toyota Camry" → 200, 20 kết quả; POST lại "BMW X1" cùng session → 200.
- Lưu ý: có 1 lần POST trả 400 "Có lỗi về vấn đề bảo mật" (CSRF) khi lặp
  lại từ khóa đã cache ở session khác. Đã thêm **thử lại 1 lần với token
  mới khi POST trả 400** (`doSearchPost()` tách riêng). Chưa kiểm chứng lại
  được vòng thử lại này vì otofun 503 sau đó (xem §4) — device test trên
  điện thoại là bước kiểm chứng chính thức.

### (2) Phân trang bài trong thread chưa kiểm chứng — ĐÃ SỬA: dùng `/page-N`

- Kiểm chứng: thread mẫu 391 trả lời (1950346, 20 trang × 20 bài):
  `/page-2` trả 20 bài khác (tầng đầu #21), còn `?page=2` trả lại bài cũ
  (tầng đầu #1). Xác nhận worker trước (00:37–00:47) cũng kết luận vậy.
- Cách làm: `posts.js` ghép `page-N` vào đường dẫn (tự nối lại dấu `/`
  cuối vì app cắt nó đi khi truyền URL), trang 1 dùng URL gốc.
  Trả `data` dạng `{ posts, page, total_pages }` (tổng trang = số lớn nhất
  trong các link `/page-N` của `.pageNav`) + `data2` = số trang tiếp để
  app hiện số trang + nhảy trang.
- Kiểm chứng bằng mô phỏng (§4): p1 20 bài (tầng #1, OP tuyendibo,
  content ~6.083 ký tự), p2 20 bài (tầng #21, ruby thiet), p20 (cuối)
  12 bài, `total_pages` = 20, `next` rỗng ở trang cuối.

### (3) Giờ trong danh sách hiện dạng ISO thô — ĐÃ SỬA: dùng text hiển thị

- Nguyên nhân: probe lấy `datetime` attr (`2010-09-18T14:11:12+0700`).
- Cách làm: lấy `title` attr của `<time>` (dạng "18/9/10 lúc 14:11",
  "17/11/26 lúc 15:06"), fallback sang `.text()` nếu không có title.
  Áp dụng cho cả danh sách thread (`.structItem-startDate time`) và kết
  quả tìm kiếm (`.contentRow-minor time`) lẫn bài viết
  (`.message-attribution-main a` text, vd "11:04 19/11/2025").
- Kiểm chứng bằng mô phỏng (§4): không còn mục nào có giờ dạng ISO thô
  (`timeISO=false`).

### Các selector đã kiểm chứng live (trước khi 503)

- Danh sách thread: `.structItem.structItem--thread`; tiêu đề
  `.structItem-title a[href*="/threads/"]`; tác giả
  `.structItem-parts a.username` (fallback `data-author`); trả lời/xem
  `.structItem-cell--meta dl.pairs dd` (đầu/cuối); ghim
  `.structItem-status--sticky`, khóa `.structItem-status--locked`; tên
  board `.p-title-value` (chỉ khi URL chứa `/forums/`).
- Thread ghim lặp lại mỗi trang → từ trang 2 bỏ qua (mô phỏng: p2 30 mục,
  0 ghim).
- Bài viết: `.message.message--post`; permalink
  `.message-attribution-main a`; tầng `.message-attribution-opposite a`;
  OP = có `.message-name .icon-starter` (p1 có 1, p2 có 0);
  user name/link `.message-name a.username`, title `.message-userTitle`;
  nội dung `.message-body .bbWrapper` (fallback `.message-body`).
  Avatar tác giả là chữ cái (không có ảnh thật) nên bỏ qua.

## 4. Kiểm chứng

- **Validate: PASS** — `node scripts/cli.js validate`: "Đã kiểm tra 121
  nguồn, 121 mục trong registry: PASS (0 cảnh báo)." (Lần đầu FAIL 2 lỗi
  do thiếu `plugin.zip` + catalog chưa sinh — đã build zip + build-catalog
  rồi chạy lại PASS.)
- **Mô phỏng runtime tại chỗ** (Node + cheerio, giả lập Rhino/jsoup;
  `~/workspace/goals/muse-teamwork-coordination/hidden_files/sim112/sim.js`):
  **8/10 PASS** trước khi otofun 503 — home 2 tab, genre 61 board,
  board BMW p1 31 thread (ghim/khóa, tác giả, lượt trả lời/xem, giờ hiển
  thị), board p2 30 thread (0 ghim), whats-new 30 thread, posts p1/p2/p20
  như §3. 2 case search từ khóa FAIL do 400 CSRF (đã sửa bằng thử lại,
  xem §3(1)) — **chưa chạy lại được vì otofun 503** (xem dưới).
- **Otofun 503 từ máy này (từ ~03:00 sau khi VM thay mới):** `curl` trả
  503 "No server is available to handle this request" (cả mobile lẫn
  desktop UA, homepage lẫn board). `example.com`/`github.com` vẫn 200 nên
  egress bình thường — lỗi chỉ riêng otofun (nhiều khả năng WAF chặn dải
  IP egress mới sau khi VM thay, hoặc route tới otofun hỏng). Site không
  chết (Anh vẫn đọc bình thường trên điện thoại; probe 00:31 chạy tốt).
  Vì vậy **không chạy lại được mô phỏng search** trên máy này lúc này.
  Device test trên điện thoại (mạng khác) là kiểm chứng quyết định.

## 5. Device test + install — CHƯA CHẠY (chờ duyệt)

- Điện thoại Anh (HONOR PTP-AN10, Tailscale 100.90.26.91:8080) **có trả
  lời** qua tunnel proxy (`/connect` → `{"code":200,"data":"HONOR PTP-AN10"}`).
- Đã dựng forwarder cục bộ `~/workspace/vbook-forwarder.js`
  (127.0.0.1:18080 → 100.90.26.91:8080 qua tunnel proxy, chạy trong
  systemd scope `vbook-forwarder.scope`, đang nghe) để `vbook.js` dùng
  được (`VBOOK_SERVER=http://127.0.0.1:18080`).
- **Nhưng:** yêu cầu duyệt kết nối tới điện thoại đã **hết thời gian chờ
  mà chưa được trả lời**, nên `/connect` qua forwarder trả rỗng và KHÔNG
  được thử lại khi chưa có yêu cầu của Anh (theo chỉ đạo). Vì vậy device
  test 8 case trong `test.json` (home, genre, search board p1/p2,
  whats-new, search từ khóa, posts p1/p2) + install 200 **chưa chạy**.
- **Cần muse-main (chị Bẹp) chạy device test + install khi có quyền truy
  cập điện thoại**, rồi mới merge. Anh sẽ tự xóa probe "Otofun Probe"
  trong app sau (không có API gỡ).

## 6. Checklist task 112

- [x] Quét repo đích + tasks/open + ROADMAP (chống trùng): repo chưa có
  `extensions/forum/`, không task nào trùng Otofun (114 VOZ Forum là
  task khác, phụ thuộc 112 merge xong); ROADMAP.md không tồn tại trong
  Qsang_vbook nên không đối chiếu được.
- [x] Claim task + tạo branch từ main tip (`feature/112-forum-otofun`,
  đã push; 7 commit).
- [x] Hạ tầng: thêm `'forum'` vào TYPES trong `tools/cli/validate.js:51`.
- [x] Copy `templates/forum/` từ upstream Darkrai9x (6 file) vào Qsang_vbook,
  chỉnh theo quy ước nhà (cả 2 nơi).
- [x] Đồng bộ `extension-api.md` (cả 2 bản, md5 giống nhau) + SKILL.md +
  `type-contracts.md` với mục forum.
- [x] Build extension thật `extensions/forum/otofun/` từ probe (build lại
  từ template + selector live vì probe không có trên máy này), sửa 3 lỗi
  probe đã biết.
- [~] validate PASS + device test code 0 + install 200: **validate PASS;
  device test + install CHƯA CHẠY (chờ duyệt, §5)**.
- [x] Push branch, cập nhật task sang review.
- [ ] muse-main kiểm tra + merge, task sang done (chờ chị Bẹp).
