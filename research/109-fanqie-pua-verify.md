# Kiểm chứng bảng PUA fanqie trên 1 chương free + phản ứng API với 1 chương VIP

- Ngày kiểm chứng: 19/11/2026 ~23:26 +07:00 (muse-1, task 109) — Anh duyệt 19/11 23:22 (chat Vbook, sau báo cáo task 108). Nối tiếp task 107 + 108.
- Phạm vi Anh duyệt: fetch đúng 1 chương FREE qua `fanqienovel.com/api/reader/full`, đo tỉ lệ PUA trước/sau khi áp cả hai bảng tĩnh (kychi + bqy), gọi API 1 lần với 1 chương VIP để ghi phản ứng. **Vẫn không build, không merge.** Không đăng nhập, không token, không vượt captcha, không dùng proxy/sign server của fork.
- Kết luận ngắn: **API `reader/full` chặn cả chương free lẫn chương VIP bằng ByteDance Turing slide captcha (HTTP 200, body rỗng 0 byte) đối với khách không đăng nhập từ máy này — không lấy được nội dung qua API để đo PUA trực tiếp.** Kiểm chứng bảng bằng mẫu live sẵn có của task 107 (cùng ngày, cùng font subset) cho thấy **bảng bqy giải mã đúng hoàn toàn trên mẫu đã test, bảng kychi giải mã sai** — sửa lại nhận định ở mục 8 của báo cáo 108. Dù bảng bqy đúng, đường API vẫn không dùng được vì captcha, và toàn văn vẫn sau cổng APP/SVIP. **Fanqie vẫn ĐÓNG.**

## 0. Chống trùng (PROTOCOL §3)

- **Repo đích Qsang_vbook:** chưa có extension fanqie trực tiếp (như mục 0 của báo cáo 108). Task này chỉ kiểm chứng, không build nên không trùng.
- **Tasks claimed/doing/review lúc bắt đầu (23:25):** 103 (claimed, muse-2, shushuwuxs), 105 + 106 (review, muse-1, TruyenTV/TruyenDich) — không trùng site/việc. Không có task kiểm chứng PUA fanqie nào khác đang mở.
- **STATUS.md + danh sách ĐÓNG:** fanqie vẫn ĐÓNG cho build. Task 109 chỉ kiểm chứng tối thiểu theo duyệt của Anh, không mở lại build.

## 1. Chọn chương free / VIP bằng thư mục (1 lần gọi, không captcha)

Để chọn đúng chương free và chương VIP mà không đoán, em gọi 1 lần API thư mục công khai (không đăng nhập, không cookie):

- URL: `https://fanqienovel.com/api/reader/directory/detail?bookId=7695606298095651864`
- Sách: `7695606298095651864` — 《七零戈壁滩：天降福星成硬汉心肝》 (sách của mẫu task 107, chương 96).
- Kết quả: HTTP 200, `code: 0`, 100 chương. Cả 100 chương đều `needPay: 0` (app đọc free), nhưng cờ khóa web khác nhau:
  - **Chương 1–10: `isChapterLock: false` (free công khai trên web).** Chương 1: `itemId 7695617846969123352`, tiêu đề 《第1章 戈壁滩捡个小奶娃》.
  - **Chương 11–100: `isChapterLock: true` (khóa web, cổng APP/SVIP).** Chương 96: `itemId 7709161943268868632`, tiêu đề 《第96章 买糖葫芦了》 — đúng chương mẫu của task 107.
- Chọn cho task này: **free = chương 1 (`7695617846969123352`), VIP/locked = chương 96 (`7709161943268868632`)**. Chương 96 được chọn cho lượt VIP vì đã có bằng chứng khóa SVIP ở task 107, không mơ hồ.

## 2. Gọi `reader/full` với chương free — bị Turing captcha chặn, body rỗng

URL đầy đủ: `https://fanqienovel.com/api/reader/full?itemId=7695617846969123352` (đúng dạng bqy dùng trong `chap.js`, chỉ khác là em không dùng cookie cứng của fork — xem ghi chú minh bạch bên dưới).

Phản ứng của API (khách không đăng nhập, User-Agent trình duyệt thông thường):

- HTTP **200**, `Content-Type: application/json`, **`Content-Length: 0` (body rỗng 0 byte)**.
- Header **`bdturing-verify`** (và `x-vc-bdturing-parameters`): `code: "10000"`, `type: "verify"`, `subtype: "slide"`, `region: "cn"`, kèm chuỗi `detail` + `fp` của thử thách trượt (slide captcha) của ByteDance Turing. `login_status: 0`.
- Không có JSON nội dung, không có `chapterData.content`. Tức API **đòi vượt Turing slide captcha trước khi trả nội dung**, kể cả với chương free.

Theo đúng giới hạn Anh duyệt ("nếu API đòi sign/captcha thì dừng ở đó và ghi rõ", "không vượt captcha"), em **dừng tại đây, không giải captcha, không dùng sign server/token/proxy**. Vì body rỗng, **không đo được tỉ lệ PUA trên nội dung API** (mẫu số = 0). Đây là kết quả kiểm chứng hợp lệ của bước 1: đường API trực tiếp như bqy viết (fetch thẳng, không xử lý captcha) **không lấy được nội dung hôm nay** từ phiên khách này.

Ghi chú minh bạch về số lần gọi: nội dung phân biệt vẫn đúng **1 chương free** như duyệt. Để chẩn đoán vì sao body rỗng (lỗi nén/proxy hay captcha thật), em đã thử lại **cùng một `itemId` đó** bằng 2 cách truyền tải khác (curl có cookie `novel_web_id` tự sinh mới + Python urllib) và 1 lần HEAD — tổng cộng 4 lượt chạm `reader/full` cho cùng chương 1, mỗi lượt cách nhau vài giây, không gặp 429. Cả 3 lượt GET đều cho cùng kết quả HTTP 200 / 0 byte; lượt Python đọc được header `bdturing-verify` ở trên nên xác định chắc chắn là captcha, không phải lỗi mạng. Cookie `novel_web_id` dùng trong lượt thử là số tự sinh mới trên máy này, **không phải giá trị cứng `7357767624615331362` trong code bqy**, và không phải đăng nhập. Sau khi xác định là captcha, em không gọi thêm lượt free nào nữa.

## 3. Gọi `reader/full` với chương VIP (đúng 1 lần) — bị chặn, hợp lệ

URL đầy đủ: `https://fanqienovel.com/api/reader/full?itemId=7709161943268868632` (chương 96, `isChapterLock: true`). Gọi đúng 1 lần, không đăng nhập.

Phản ứng nguyên văn (rút gọn phần dài của chuỗi captcha):

- HTTP **200**, **`Content-Length: 0` (body rỗng 0 byte)**.
- Header `bdturing-verify`: `code: "10000"`, `type: "verify"`, `subtype: "slide"` — cùng loại thử thách như chương free.
- **Không có nội dung chương VIP nào được trả về.** Tức API **bị chặn** đối với khách không đăng nhập — đây là phản ứng hợp lệ theo tiêu chí của task ("hợp lệ = BỊ CHẶN"). Không phát hiện lỗ hổng trả nội dung VIP free, nên không có tình huống phải dừng khẩn như task cảnh báo.

Lưu ý: vì captcha chặn trước cả bước kiểm tra quyền VIP, lượt gọi này chứng minh "khách không lấy được VIP qua API" nhưng không phân biệt được server sẽ trả gì sau khi qua captcha (đăng nhập/SVIP). Em không qua captcha nên không kiểm chứng tiếp — đúng giới hạn.

## 4. Kiểm chứng hai bảng PUA bằng mẫu live task 107 (vì API không trả nội dung)

Vì bước 2 không có nội dung API để áp bảng, em áp cả hai bảng lên mẫu live đã có sẵn từ task 107 (fetch 19/11 22:41, cùng ngày, không gọi mạng mới): bản xem trước của chính chương 96 trong `__INITIAL_STATE__.reader.chapterData.content` của trang đọc, font subset `dc027189e0ba4cd` (cùng họ font mà header API ở mục 2 cũng trỏ tới). Cách này trả lời được câu hỏi "bảng nào còn đúng với fanqie hôm nay" trên bằng chứng live cùng ngày, nhưng phải ghi rõ: **đây là nội dung trang đọc HTML, không phải nội dung `reader/full` của task 109** (API đã chặn). Không fetch thêm trang HTML mới trong task này.

Số liệu mẫu (đo bằng script, đếm ký tự > khoảng trắng):

- Trước giải mã: 155 ký tự, **62 ký tự PUA (40,0%)**, cả 62 đều nằm trong khoảng bảng `58344–58715` (U+E3E8–U+E54F), gồm **39 mã bias phân biệt**.
- **Bảng bqy** (`r_content`/`charset` trong `[Fanqie] Cachua` của bqy, 372 mục): ánh xạ được **62/62**, còn **0 ký tự PUA (0%)**. Câu đầu sau giải mã đọc thành câu tiếng Trung hoàn chỉnh, đúng ngữ pháp và ngữ cảnh tiệm bán hàng thời bao cấp: “上面支了一块牌子，写着‘国营副食销售’，价格是一毛钱一串。” Toàn bộ 7 đoạn xem trước đều thành văn xuôi mạch lạc (hội thoại cha con mua kẹo hồ lô), không còn chữ Latin lạc hay ký tự rác.
- **Bảng kychi** (`decodeText`/`charset` của Cà Chua C2, 372 mục; biến thể Sói Xám 371 mục cho kết quả tương tự): ánh xạ được 60/62 (2 mã rơi vào ô trống), còn 2 ký tự PUA (1,3%) — nhưng quan trọng hơn, **chữ đã ánh xạ phần lớn là sai**. Cùng câu đầu, bảng kychi cho ra dạng “任把支d觉块牌天，只写‘使营副食销售’，价两变觉毛钱觉串” — có chữ Latin `d`, động từ và lượng từ sai (“使营” thay vì “国营”, “价两变觉” thay vì “价格是一”). Các đoạn sau cũng rời rạc tương tự. Tức bảng kychi **không đúng** với font subset live này; nó chỉ tình cờ cho ra các chữ Hán trông giống văn bản.
- Đối chiếu hai bảng: **0/372 vị trí trùng nhau** (khớp báo cáo 108). Hai bảng kychi (C2 và Sói Xám) trùng nhau 250 vị trí, khác chủ yếu giản/phồn thể — cả hai đều sai trên mẫu này theo cùng một cách.

**Sửa lại mục 8 của báo cáo 108:** mục 8 ghi bảng kychi "vẫn khớp phần lớn" dựa trên đoạn trích “使营副食销售 / 价两…毛钱…串”. Kiểm chứng đầy đủ ở task này cho thấy đó là khớp giả — chữ đúng phải là “国营 / 价格是一”. Bảng đúng trên mẫu 19/11 là **bqy**, không phải kychi. Báo cáo 108 ở các mục còn lại (proxy/token/root đều phạm luật nhà, fanqie vẫn ĐÓNG) không đổi.

Phạm vi của kết luận bảng: mới kiểm chứng **39/372 mã bias** xuất hiện trong bản xem trước 62 ký tự PUA của 1 chương, 1 font subset, 1 ngày. Chưa kiểm chứng 333 mã còn lại, chưa kiểm chứng chương khác/ngày khác (mapping có thể đổi theo đợt subset như báo cáo 108 đã cảnh báo). Không suy rộng thành "bảng bqy đúng vĩnh viễn".

## 5. Kết luận theo 3 điểm kiểm chứng của task 108

| Điểm cần chứng minh | Kết quả task 109 |
|---|---|
| Bảng PUA còn đúng không | **Bảng bqy đúng trên mẫu đã test (62/62, 39 mã phân biệt); bảng kychi sai.** Chưa đủ để khẳng định ổn định dài hạn/toàn bảng. |
| API có trả chương VIP không | **Không.** Lượt VIP duy nhất bị Turing captcha chặn, body rỗng, không lộ nội dung. Hợp lệ. |
| Captcha có chặn không | **Có — chặn cả free lẫn VIP.** `reader/full` đòi ByteDance Turing slide captcha đối với khách không đăng nhập từ máy này. Đây là rào cản quyết định. |

Hệ quả: dù bảng bqy giải mã được text PUA, **không có đường hợp lệ để lấy text đó qua `reader/full` trong vBook runtime** (runtime không giải Turing captcha, và giải captcha/sign bằng dịch vụ ngoài đều phạm luật nhà). Đường trang đọc HTML (task 107) chỉ cho bản xem trước ngắn, toàn văn vẫn sau cổng APP/SVIP. **Fanqie vẫn ĐÓNG. Không build, chờ Anh quyết nếu muốn hướng khác.**

## 6. Chưa xác định (không đoán)

- Sau khi qua Turing captcha (bằng trình duyệt thật/đăng nhập), `reader/full` trả gì cho free/VIP — không kiểm chứng vì vượt captcha nằm ngoài phạm vi duyệt.
- 333 mã bias còn lại của bảng bqy, và tính ổn định của mapping qua chương/ngày khác.
- API có chặn theo IP/thiết bị (máy ảo này) hay chặn mọi khách — chỉ khẳng định được với phiên khách từ máy muse-1 ngày 19/11.
- Số liệu 446 ký tự / 150 PUA trong báo cáo 107 là đếm trên text DOM hiển thị; mẫu `__INITIAL_STATE__` dùng ở mục 4 là 155 ký tự / 62 PUA (chỉ phần `content` xem trước). Hai con số đo hai phạm vi khác nhau, không mâu thuẫn; tỉ lệ PUA đều ~34–40%.
