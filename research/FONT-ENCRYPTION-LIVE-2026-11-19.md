# Mẫu live font encryption + pattern giải mã cho extension vBook

- Ngày nghiên cứu: 19/11/2026 (muse-1, task 107) — nối tiếp task 098 (`research/JS-RENDERED-ANTI-BOT-2026-11-19.md` mục 4, lúc đó chỉ là lý thuyết, trừ 2 điểm review vì chưa có mẫu live).
- Phạm vi: chỉ đọc nội dung FREE/công khai. Không bypass VIP/login/paywall, không fake login, không lấy token của Anh.
- Bằng chứng: fetch live bằng curl từ máy muse-1 (1 request/trang, có nghỉ giữa các request, không gặp 429) + parse font thật bằng fontTools 4.46.0 + code thật trong repo Qsang_vbook.

## 1. Kết quả kiểm chứng live (19/11/2026 ~22:41 +07:00)

### 1.1 fanqienovel.com (番茄小说) — CÓ font encryption thật, đang sống

| Trang thử | HTTP | Dung lượng tải | `@font-face` | Ký tự PUA (U+E000–U+F8FF) | Đọc free đầy đủ không login? |
|---|---|---|---|---|---|
| Trang chủ `https://fanqienovel.com/` | 200 | 53.943 byte | 6 khối | 0 | Text trang chủ là chữ thường (không mã hoá) |
| Trang đọc `https://fanqienovel.com/reader/7709161943268868632` (URL chương mẫu từ FORK-SCAN-2026-11-18) | 200 | 8.455 byte tải (30.967 byte sau giải nén) | 6 khối | **150 ký tự** | **Không** — khách chỉ thấy bản xem trước đã mã hoá font + lời mời tải APP/mua SVIP |

Chi tiết trang đọc (tiêu đề: "七零戈壁滩：天降福星成硬汉心肝第96章 买糖葫芦了", 本章字数 2.753 字):

- Text trích từ DOM dài 446 ký tự, trộn chữ Hán thường với ký tự vùng dùng riêng (PUA). Ví dụ nguyên văn đoạn đầu: `支块牌，“营副食销售”，价毛钱串。` — chữ hiển thị trong trình duyệt là chữ đúng (font vẽ glyph đúng), nhưng text trong DOM là ký tự PUA, copy ra là rác.
- `window.__INITIAL_STATE__` ghi `"isVip":false, "hasAuthentication":false` — phiên khách.
- Cuối bản xem trước ghi rõ: "扫码下载APP免费读，SVIP网页畅读" (quét mã tải APP đọc miễn phí, SVIP đọc web) và "会员登录后，可在网页畅读全文" (đăng nhập hội viên mới đọc toàn văn trên web). Tức toàn văn chương **không** mở free trên web cho khách — khớp kết luận cũ của FORK-SCAN-2026-11-18/19 (`ch1: locked`, "chapter page demands login/VIP") và báo cáo 098.
- Không có marker Cloudflare challenge (0 lần xuất hiện `cloudflare`/`cf-chl` ở trang chủ).

**Kết luận mục này:** fanqie là mẫu live font encryption thật (kiểu "fanqie" mà task 098 nhắc), nhưng **không** thoả điều kiện "đọc được chương free đầy đủ mà không cần login" của checklist task 107. Cái đọc được không login chỉ là bản xem trước ngắn, và chính bản xem trước đó cũng đã bị mã hoá font. Em không bypass cổng APP/SVIP này.

### 1.2 qimao.com (七猫) — đối chứng: KHÔNG phải font encryption

- Extension đã có trong Qsang_vbook (`extensions/novel/qimao/`, v6) không dùng font/cmap chút nào: grep `font-face|woff` trong `src/` ra rỗng.
- Cơ chế thật của qimao (code thật, đã kiểm chứng 2026-11-09): nội dung chương lấy từ API `api-ks.wtzw.com/api/v1/chapter/content` rồi giải mã **AES-128-CBC** (`qimao-crypto.js`); trường `chapterData` trên trang web chỉ là bản xem trước mã hoá **DES-ECB** (`qimao-des.js`). Đây là mã hoá blob, giải được bằng JS thuần trong extension — khác hẳn font encryption.
- Bài học: đừng gọi mọi cơ chế chống copy là "font encryption". Chỉ khi DOM text là PUA/garbage mà render vẫn đúng + có `@font-face` lạ mới là font encryption.

### 1.3 Site thứ hai có font encryption + chương free đầy đủ: KHÔNG TÌM ĐƯỢC trong đợt này

Trong phạm vi kiểm chứng đợt này (fanqie live + đối chứng qimao bằng code + dữ liệu FORK-SCAN-2026-11-18/19 sẵn có), không có site nào vừa dùng font encryption vừa mở chương free đầy đủ cho khách. Em ghi trung thực là **không tìm được mẫu thứ hai**, không bịa. Nếu sau này rescan fork phát hiện host mới có dấu hiệu PUA + `@font-face` mà chương free mở, cần fetch 1 chương free + parse font như mục 2 rồi mới kết luận.

## 2. Cách font bị mã hoá (bằng chứng từ file font thật)

Font chương của fanqie (tải công khai từ CDN của chính site, HTTP 200):

- `https://lf3-awef.bytetos.com/obj/awesome-font/c/dc027189e0ba4cd.woff2` (47.564 byte, WOFF2/CFF) và bản `.woff` (53.416 byte). Trang chủ dùng biến thể `-500`/`-700` cùng họ (`dc027189e0ba4cd-500.woff2`…) — tức font được subset riêng theo trang/chương, không phải một font cố định dùng mãi.
- `font-family` trong CSS là chuỗi ngẫu nhiên `DNMrHsV173Pd4pgy` (không phải tên font hệ thống).
- Bảng `name` của font ghi: "This is a subset font of SourceHanSansSC-Normal" — font gốc là Source Han Sans SC, đã subset chỉ còn glyph của các ký tự xuất hiện trong chương.
- Parse bằng fontTools: bảng `cmap` có đúng **362 mục, toàn bộ nằm trong vùng PUA** (U+E3E8 trở đi), mỗi mã PUA trỏ tới một glyph tên dạng `gid58344`, `gid58345`… Số glyph trong font là 363 (362 + `.notdef`).
- Điểm mấu chốt: **tên glyph không chứa mã Unicode gốc** (không có glyph dạng `uniXXXX`). Hơn nữa số trong tên glyph bằng đúng giá trị mã PUA (U+E3E8 = 58344 → `gid58344`), nên đọc `cmap` không suy ra được ký tự thật là gì. Muốn giải mã phải đối chiếu hình glyph (outline CFF) hoặc số CID/gid với font SourceHanSansSC đầy đủ bên ngoài, hoặc render glyph ra ảnh rồi OCR.

## 3. Cách giải mã đã thử (kể cả cách thất bại)

| Cách thử | Kết quả |
|---|---|
| Đọc text trực tiếp từ DOM/HTML tĩnh | Thất bại — ra ký tự PUA (150 ký tự trong bản xem trước), không phải chữ thật. Đây là dấu hiệu nhận biết font encryption. |
| Parse `cmap` của font bằng fontTools (offline, trên VM) | Parse được (362 mục PUA → gid), nhưng **không giải ra chữ**: glyph chỉ tên `gidNNNNN`, không mã hoá Unicode gốc. `cmap` một mình không đủ. |
| Suy chữ từ số gid (gid = giá trị PUA) | Thất bại — gid ở đây bằng mã PUA đã xáo trộn, không phải mã Unicode thật. |
| Đối chiếu outline/CID với font SourceHanSansSC đầy đủ, hoặc render + OCR | Chưa làm tới cùng trong đợt này (cần tải font gốc đầy đủ + khớp từng glyph). Về nguyên tắc làm được **offline trên máy tính** (đây là cách các công cụ cộng đồng giải fanqie), nhưng: (a) font subset đổi theo từng chương nên phải tải + khớp lại mỗi chương; (b) toàn văn vẫn bị cổng APP/SVIP chặn nên giải được cũng chỉ có bản xem trước. Không đáng và không hợp lệ để bypass cổng đó. |
| Giải mã ngay trong extension vBook (Rhino ES6) | **Không làm được** — runtime không có API tải/parse font (WOFF/WOFF2/CFF), không có OCR, không đọc được bảng `cmap`/`post`. Khớp kết luận 098, nay đã có mẫu live chứng minh cơ chế. |

## 4. Đề xuất pattern cho extension vBook

**Không đề xuất decoder font trong extension** (runtime không làm được, và mẫu live duy nhất còn bị cổng login/SVIP). Đề xuất duy nhất dùng được ngay là **pattern nhận biết + báo lỗi rõ ràng** trong `chap.js`, để extension không trả rác PUA cho người đọc:

```js
// Nhan biet font encryption: DOM text chua nhieu ky tu PUA (U+E000-U+F8FF)
// trong khi trang van render dung nho @font-face subset. Runtime vBook
// khong parse duoc font/cmap nen KHONG co cach giai ma trong extension:
// tra loi ro rang thay vi tra text rac. (Mau live: fanqienovel.com
// 19/11/2026 — ban xem truoc 446 ky tu chua 150 ky tu PUA, font subset
// SourceHanSansSC 362 glyph, cmap PUA->gid khong chua Unicode goc.)
function puaRatio(text) {
var total = 0;
var pua = 0;
for (var i = 0; i < text.length; i++) {
var c = text.charCodeAt(i);
if (c <= 32) continue;
total++;
if (c >= 0xE000 && c <= 0xF8FF) pua++;
}
return total > 0 ? pua / total : 0;
}
// Trong execute(url) cua chap.js, sau khi lay duoc text chuong:
// if (puaRatio(chapterText) > 0.05) return Response.error(
//   "Nguon nay ma hoa chu bang font rieng (font encryption) — " +
//   "extension khong giai ma duoc, hay doc tren trang goc/ung dung cua nguon.");
```

- Ngưỡng 5% là gợi ý khởi điểm (mẫu fanqie: 150/446 ≈ 34% tính cả khoảng trắng; chương thật sẽ cao hơn vì phần lớn chữ bị xáo). Cần hiệu chỉnh nếu sau này có mẫu thứ hai.
- Pattern này đặt ở `chap.js` (nơi duy nhất chạm text chương), không cần lib mới, không cần thêm quyền gì. Nó biến lỗi "trả rác âm thầm" thành lỗi rõ ràng — đúng tinh thần "không đoán bừa" của team.
- Nếu một ngày vBook runtime có API parse font (hiện **Chưa xác định** — `extension-api.md` không có API font nào tính tới 19/11/2026) thì mới xét lại decoder; lúc đó vẫn phải tải font subset từng chương + khớp glyph với font gốc, việc nặng và dễ vỡ khi site đổi font.

## 5. Đề xuất cập nhật skill vbook-extension-building

Đã sửa 1 dòng trong `shared/skills/vbook-extension-building/SKILL.md` (mục "Handle difficult sites"): thay ghi chú cũ "(Checked 19/11/2026: no open site with live font encryption was available…)" bằng bằng chứng live của đợt này (fanqie: PUA 150 ký tự, font subset SourceHanSansSC 362 glyph, cmap không chứa Unicode gốc, toàn văn cần APP/SVIP) + thêm pattern nhận biết PUA ở mục 4. Kết luận "cannot build" giữ nguyên — nay có mẫu thật đỡ lưng, không còn là lý thuyết.

## 6. Chưa xác định (không đoán)

- **Decode offline bằng khớp outline/CID với SourceHanSansSC đầy đủ:** chưa chạy tới cùng trong đợt này nên chưa xác nhận tỉ lệ khớp; và dù khớp được cũng chỉ giải bản xem trước, toàn văn vẫn sau cổng APP/SVIP — không dùng để bypass.
- **Site font-encryption thứ hai mở free đầy đủ:** chưa tìm được (mục 1.3). Không kết luận "không tồn tại", chỉ là đợt này chưa thấy.
- **Font có đổi theo từng chương/ngày không:** đã thấy subset khác nhau giữa trang chủ (`-500`/`-700`) và trang đọc (bản không hậu tố), nhưng chưa fetch chương thứ hai để so — chưa xác định mức độ thay đổi theo chương (và không fetch thêm để tránh dồn dập).
