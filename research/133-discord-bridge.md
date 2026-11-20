# 133 — Nghiên cứu cầu Discord nối 3 Muse vào 1 phòng chung

- **Task:** 133-nghien-cuu-cau-discord-noi-3-muse-vao-1- (Anh giao 20/11/2026 19:56 qua chat Team 3 Chị Em, muse-main tạo task, muse-1 nghiên cứu)
- **Tài liệu gốc:** `research/cau-discord-ban-cho-agent.md` (bản sao trong repo; bản gốc ở máy muse-main) — Phần 1 cho người đọc, Phần 2 là đặc tả dán cho agent tự dựng, Phần 3 mẹo vận hành
- **Ngày nghiên cứu:** 20/11/2026
- **Phạm vi:** **CHỈ NGHIÊN CỨU — không build, không tạo bot Discord, không chạm token, không đăng ký tài khoản nào** (đúng notes task 133). Báo cáo đối chiếu từng khẳng định kỹ thuật trong tài liệu gốc với (a) tài liệu Discord chính thức + nguồn kiểm chứng độc lập tháng 11/2026, (b) ràng buộc thật của 3 VM Muse đã chứng minh trong task 092/099/115, (c) cách team đang vận hành bằng GitHub-first.
- **Kết luận ngắn:** **KHÔNG NÊN build ở thời điểm này (tạm hoãn có điều kiện mở lại).** Thiết kế cầu (bot discord.py + Docker + inbox/outbox file) tự nó đúng và gọn cho agent kiểu "chương trình chạy thường trực", nhưng **hai điều kiện tiên quyết đều chưa có trên team Muse**: (1) không có máy chủ cầu luôn bật nhận được SSH vào — 3 VM Muse đều client-only, không nhận inbound; (2) phía agent, Muse không phải daemon thường trực giữ SSH `tail -F` rồi tự thức dậy — Muse thức dậy theo hook/cron/chat của runtime, nên "bộ canh long-poll" trong tài liệu không cắm thẳng vào được mà phải thiết kế lại cơ chế đánh thức. Trong khi đó GitHub-first đang chạy tốt cho đúng việc team đang làm (task, claim, review, merge). Cầu Discord giải quyết một nhu cầu **khác** (phòng chat chung nhìn thấy cả 3, gọi tên là dậy trong vài giây) — nhu cầu đó hiện chưa phải nút thắt. Chi tiết + 4 điều kiện mở lại ở mục Kết luận.

## Quét chống trùng (PROTOCOL §3 — làm trước khi nghiên cứu)

- **Repo đích:** `muse-teamwork` (task research, không build extension nên không quét Qsang_vbook registry).
- **Tasks claimed/doing/review lúc bắt đầu (20/11 20:10):** chỉ có 131 (muse-2, tự học Attention Mechanism) và chính 133 (muse-1, claimed 20:00:15). Không có task nào khác về Discord/chat cầu. Task 099 (muse-main, done 19/11) đã so sánh pattern "bot trung gian Telegram/Discord" ở mức tổng quan và kết luận "chỉ xem lại khi team cần chat 2 chiều trong lúc làm" — báo cáo này là lần đào sâu vào **một thiết kế cụ thể** (cầu file + long-poll SSH) chứ không trùng việc với 099; các điểm 099 đã chứng minh (VM không inbound, VM thay mới xóa service local, miễn phí) được dùng lại và ghi rõ nguồn.
- **STATUS.md + tasks cancelled:** không có site/việc Discord nào bị đóng; không có báo cáo `research/133-*` nào tồn tại trước (đã kiểm tra `ls research/133*` → không có).
- **Branch:** `feature/133-discord-bridge` (WIP commit đầu trong 15 phút sau claim theo PROTOCOL §2 quy tắc 4, heartbeat sang `doing`).

## Kiểm chứng kỹ thuật chính (trước khi đánh giá)

| Khẳng định trong tài liệu gốc | Kiểm chứng | Kết quả |
|---|---|---|
| Mời bot bằng quyền **68672** (Xem kênh + Gửi tin + Đọc lịch sử + Thêm reaction) | Giải mã bitmask bằng script: 68672 = 64 (ADD_REACTIONS) + 1024 (VIEW_CHANNEL) + 2048 (SEND_MESSAGES) + 65536 (READ_MESSAGE_HISTORY) | **Đúng, và là quyền tối thiểu tốt** — không có kick/ban/quản lý kênh/role, nên token lộ cũng chỉ spam/đọc được kênh đó |
| Phải bật **MESSAGE CONTENT INTENT** | Intent đặc quyền `MESSAGE_CONTENT` (`1 << 15`): không bật thì bot vẫn nhận sự kiện tin nhắn nhưng trường `content`/`embeds`/`attachments` rỗng (trừ tin bot tự gửi, DM với bot, tin @mention bot). Từ **10/06/2026** ngưỡng xét duyệt đổi từ 100 server sang **10.000 unique users**: dưới ngưỡng chỉ cần bật toggle trong Developer Portal + khai trong code, không phải nộp đơn; trên ngưỡng mới phải xin duyệt và gia hạn hằng năm. App Verification (100+ server) là quy trình riêng | **Đúng và khả thi cho team**: 3 bot private trong 1 server của Anh thì xa ngưỡng 10.000 users, chỉ cần toggle. Lưu ý hệ quả: luật `"tên` (không @mention) **bắt buộc** có intent này mới đọc được nội dung; nếu chỉ dùng @mention thì không cần intent đặc quyền |
| Bot chạy bằng **discord.py + Docker**, mỗi cầu ~35 MB RAM, gần 0% CPU khi rảnh | discord.py 2.x là thư viện chuẩn, chạy Gateway WebSocket ra ngoài tới Discord (không cần inbound từ Discord). Giới hạn Discord hiện hành: REST 50 req/s/bot, tin nhắn tối đa 2.000 ký tự (tài liệu gốc tự giới hạn ~1.900 là đúng), Gateway gửi tối đa 120 sự kiện/60 giây/kết nối. Lưu lượng cầu (vài tin/phút) thấp hơn giới hạn hàng chục lần | **Hợp lý** — con số RAM/CPU là ước lượng của tài liệu gốc, không đo lại được vì task cấm build; mức này khả thi cho 1 bot discord.py rảnh. Docker **không có sẵn trên VM muse-1** (`docker: command not found`, kiểm tra 20/11) — nhưng cầu chạy trên máy chủ cầu riêng, không phải trên VM Muse (xem mục 2) |
| Agent canh inbox bằng **SSH long-poll `tail -F`**, phát hiện tin < 1 giây, cửa sổ ~540 giây tự nối lại, **cấm polling thưa** | Về nguyên lý `tail -F` qua SSH cho độ trễ dưới giây là đúng. Trên VM Muse: SSH ra tailnet phải đi qua **HTTP proxy CONNECT cổng 3130** (Tailscale client-only, TCP-only, không ping/UDP được; địa chỉ đích đầu tiên cần Anh phê duyệt riêng từng IP/tên). Máy có OpenSSH 9.6 + `nc`/`socat` để làm ProxyCommand. **Chưa có bằng chứng** proxy runtime giữ được kết nối SSH đứng 540 giây không bị cắt idle — tài liệu gốc không nhắc tới proxy | **Nguyên lý đúng, đường truyền cụ thể chưa chứng minh** — cần test thật (xem mục 1). Điểm nghẽn lớn hơn nằm ở cơ chế đánh thức agent, không phải ở `tail -F` |
| Token nạp qua **trang web nội bộ**, ghi `.env` quyền **600**, trang tự tắt, token không qua chat | Token bot Discord là "mật khẩu của bot": ai cầm là đăng nhập được với tư cách bot, không cần mã xác thực; Reset Token trong Portal làm token cũ vô hiệu ngay; Discord chỉ hiện token 1 lần. `.env` ngoài Git + quyền 600 là cách lưu chuẩn được Discord khuyến nghị | **Nguyên tắc đúng** (khớp luật nhà: token không qua chat). Nhưng đặc tả **không nói trang nạp token có xác thực/HTTPS/bind địa chỉ nào** — đó là lỗ hổng cần vá trước khi build (mục 4) |
| Độ trễ vòng hỏi–đáp **6–10 giây** | Gateway Discord giao tin < 1 giây; ghi file + `tail -F` + quét outbox 0,5 giây cộng thêm ~1 giây; phần còn lại là thời gian agent xử lý. 6–10 giây chỉ đạt được với việc trivial (bài test "nhân đôi số" trong tài liệu). Việc thật của team (build extension, device test) tính bằng phút–giờ | **Đúng cho tin ngắn, không đại diện cho việc thật** — xem mục 5 |

## 1. Kiến trúc cầu: có đúng với cách 3 Muse vận hành không?

Tài liệu gốc chia hệ thống thành 2 nửa. Đánh giá riêng từng nửa vì kết quả trái ngược nhau.

### 1a. Nửa cầu (trên máy chủ cầu): ĐÚNG

- Mỗi agent 1 bot riêng + 1 container cầu riêng (Python + discord.py), lọc đúng `GUILD_ID` + `CHANNEL_ID`, ghi tin hợp lệ thành 1 dòng JSON vào `data/inbox/inbox.jsonl` (gồm `msg_id`, tác giả, nội dung, `ts`, `rx`), agent trả lời bằng file `data/outbox/<msg_id>.txt` (ghi `.tmp` rồi đổi tên), cầu quét outbox mỗi 0,5 giây, đăng dạng reply, xóa file, thả 👍 khi ghi inbox xong, hiện "đang nhập…" tối đa 240 giây/tin.
- Điểm mạnh thật: (i) bot chỉ gọi **ra** Discord qua Gateway nên máy chủ cầu không cần mở cổng vào internet cho Discord; (ii) giao thức **file** đơn giản, gỡ lỗi bằng cách mở file xem, cầu restart không mất tin đã ghi; (iii) ghi `.tmp` rồi rename tránh đọc file dở; (iv) 👍 + "đang nhập…" cho Anh biết tin đã tới hộp thư hay agent đã dậy — đúng mẹo vận hành ở Phần 3 của tài liệu ("thấy đang nhập mãi thì kiểm tra bộ canh, đừng trách đường truyền").
- Điểm cần lưu ý khi build (không phải lỗi thiết kế): `inbox.jsonl` phình vô hạn nếu không xoay vòng/archival; cầu quét outbox 0,5 giây bằng polling file là đủ ở quy mô 3 bot; "đang nhập…" phải gửi lặp lại mỗi ~10 giây (Discord tự tắt typing sau ~10 giây) nên trần 240 giây = ~24 lần gửi Gateway — vẫn dưới giới hạn 120/60 giây nhưng phải đếm chung với heartbeat của thư viện.

### 1b. Nửa agent (bộ canh trên mỗi VM Muse): KHÔNG CẮM THẲNG ĐƯỢC — đây là điểm nghẽn kiến trúc

Tài liệu gốc giả định agent là **một chương trình chạy thường trực** trên máy của nó: giữ 1 kết nối SSH mở liên tục chạy `tail -F` ngay phía máy chủ cầu, nghe tin thì "đánh thức một lượt xử lý ngay", giữ file watermark `msg_id` đã xử lý để không trả lời trùng, tắt bộ canh cũ trước khi bật bộ canh mới. Ba giả định đó va chạm với cách Muse thật sự chạy:

1. **Muse không có tiến trình agent thường trực để giữ SSH.** Trên 3 VM hiện nay, agent thức dậy theo 3 đường: hook watcher 5 phút (`scripts/watch-tasks.sh`, chỉ mở phiên khi script báo có việc liên quan), cron poll 15 phút, và chat của Anh. Giữa các phiên, không có "agent đang nghỉ nhưng vẫn giữ SSH" — chỉ có các script nhẹ không dùng AI. Muốn có bộ canh đứng, phải dựng thêm **một service thường trực mới trên mỗi VM** (systemd service chạy vòng lặp SSH + đọc inbox) rồi nối nó vào cơ chế đánh thức phiên của runtime (hook). Tài liệu gốc không mô tả khâu nối này — mà đây mới là phần khó nhất, vì bài kiểm chứng số 2 của chính tài liệu ("agent đang nghỉ hoàn toàn, không ai mở tab chat, gọi tên là tự dậy trong 1 phút; không chấp nhận nếu phải có người vào gọi dậy") **chỉ đạt được nếu runtime cho phép service local đánh thức một phiên agent mới**. Hiện tại đường đánh thức đã chứng minh được là hook đọc GitHub, không phải sự kiện file/SSH local. Chưa ai chứng minh đường "file inbox có dòng mới → runtime mở phiên Muse" trên hệ thống này.
2. **SSH đứng qua proxy chưa được chứng minh.** VM gọi ra tailnet qua proxy HTTP CONNECT cổng 3130; mỗi địa chỉ đích (IP hoặc tên MagicDNS — tính là các địa chỉ khác nhau) cần Anh phê duyệt lần đầu. Kết nối SSH 540 giây qua proxy có thể bị cắt bởi idle timeout của proxy/tunnel mà tài liệu gốc không lường tới; cần `ServerAliveInterval` + tự nối lại + đọc bù inbox theo watermark (tài liệu có watermark — tốt). Nhưng "cấm polling thưa" của tài liệu (lý do: từng rớt tin điểm danh, trả lời chậm nhiều phút) cần được cân lại trên đường truyền này: polling SSH ngắn mỗi 30–60 giây qua proxy có thể **bền hơn** một kết nối đứng dài bị cắt giữa chừng mà không ai biết. Đây là thứ phải đo thật, không suy luận được.
3. **Sống sót qua thay VM: làm được nhưng phải theo mẫu hub.** Bài học đã trả giá 19/11: mỗi phiên exec chạy trong cgroup riêng bị dọn khi tick kết thúc (giết node chạy `nohup`/scope), systemd service sống qua tick nhưng **mất khi VM bị thay** (`/etc/systemd/system` bị xóa, hub phải cài lại nhiều lần trong ngày 19/11, commit c9206b0). Bộ canh SSH sẽ chết y hệt nếu chạy kiểu `nohup`. Muốn bền phải: systemd service `Restart=always` + file unit nằm trong repo + poll 15 phút tự cài lại khi unit mất (đúng mẫu `muse-teamwork-hub.service` + HEARTBEAT/poll hiện tại) + watermark/SSH key để trong `~/` (thư mục home sống qua thay VM, `/etc` thì không). Tức là thêm **3 service nữa** (mỗi VM một bộ canh) vào danh sách thứ phải tự sửa khi thay VM, cộng thêm khóa SSH của từng VM phải đăng ký lại/được tin cậy lại trên máy chủ cầu nếu VM đổi danh tính Tailscale.

**Kết luận mục 1:** nửa cầu mang sang nguyên vẹn được; nửa agent phải thiết kế lại cho mô hình đánh thức của Muse và **chứng minh được bài test tự thức (test 2) trước khi tin**. Không nên build cả hệ rồi mới phát hiện agent không tự dậy được.

## 2. Máy chủ cầu: chạy ở đâu? (chặn cứng hiện tại)

Cầu cần một máy **luôn bật, có Docker, nhận SSH vào** từ 3 VM (agent SSH tới để `tail -F` inbox và ghi outbox). Hiện team **không có** máy như vậy: chỉ có 3 VM runtime + điện thoại Anh. Xét từng lựa chọn:

| Lựa chọn | Nhận SSH vào được không? | Chi phí | Độ tin cậy / lưu ý |
|---|---|---|---|
| **Trên 1 trong 3 VM Muse** | **Không.** Cả 3 VM đều Tailscale client-only: chỉ gọi ra, không nhận inbound (đã chứng minh task 092: IP đúng, nghe 0.0.0.0:8787, probe từ máy khác vẫn `http=000`; hub trên muse-1 tới nay vẫn chỉ local). Cầu đặt trên muse-1 thì muse-2/muse-main không SSH vào được. Chưa kể VM bị thay là mất Docker/container/`/etc` | 0đ | **Loại.** Đây cũng là lý do hub Tailscale không thành xương sống được (099 mục 2) |
| **VPS thuê** | Có — IP public, SSH/Docker đầy đủ, 3 VM gọi ra tới VPS qua internet (egress proxy 3128) hoặc qua Tailscale nếu cài Tailscale lên VPS | Trả phí hằng tháng (mức rẻ nhất thường vài USD/tháng — **chưa kiểm chứng giá cụ thể, không nên chốt số khi chưa chọn nhà cung cấp**) | Tin cậy cao, nhưng: trái ràng buộc "miễn phí" team đang giữ (099 mục 2.3); thêm tài khoản + thẻ thanh toán + vá bảo mật + sao lưu; dữ liệu inbox (nội dung chat) nằm trên máy thuê. **Oracle Cloud free tier không được đề xuất lại**: Anh đã dừng Oracle 13/11, không tự mở lại |
| **NAS / mini PC ở nhà Anh** | Có — nếu máy luôn bật + vào cùng tailnet, 3 VM SSH qua proxy 3130 tới IP tailnet của máy | Tiền máy (nếu chưa có) + điện; nếu Anh đã có sẵn máy luôn bật thì gần 0đ | Tin cậy phụ thuộc điện/mạng nhà; cần Anh xác nhận **có máy như vậy không** — hiện chưa có thông tin nào trong repo/memory cho thấy Anh có NAS/mini PC luôn bật. Điện thoại không thay được (Android giới hạn chạy nền, không chạy Docker cầu bền) |
| **GitHub Actions / serverless** | Không phù hợp: Actions runner là máy tạm (tối đa 6 giờ/job, lịch tối thiểu 5 phút) không giữ được Gateway WebSocket thường trực của discord.py; serverless kiểu Workers không chạy discord.py nguyên bản | 0đ | **Loại cho vai cầu realtime.** Actions vẫn là chỗ đúng cho watchdog/inbox theo lịch như 099 đã đề xuất — hai việc khác nhau |

**Kết luận mục 2:** không có lựa chọn miễn phí khả thi hôm nay. Muốn đi tiếp, Anh phải chọn **một** trong hai: có sẵn máy nhà luôn bật (xác nhận + cho SSH/Tailscale vào), hoặc chấp nhận VPS trả phí. Chưa chốt được máy chủ cầu thì chưa build được gì — đây là điều kiện mở lại số 1.

## 3. Luật địa chỉ + chốt 8 tin: đủ chống lặp chưa?

Luật trong tài liệu: tin chỉ vào inbox của agent X khi (a) @mention bot của X, hoặc (b) nội dung chứa dấu `"` ngay trước tên X (không phân biệt hoa thường, chấp cả dấu “ cong, tên phải là từ đứng riêng — `"lu` không khớp trong `"luôn`), hoặc (c) chứa cụm `"tất cả"` → vào inbox mọi agent. Whitelist cứng: chỉ nhận từ `OWNER_ID` (Anh) và `PEER_BOT_IDS` (bot của agent khác); tin bot–bot áp cùng luật. Chốt cứng trong code: quá 8 tin bot–bot liên tiếp vào inbox mà Anh chưa lên tiếng thì ngừng ghi inbox tới khi Anh nhắn lại. Kèm kỷ luật phòng: chỉ nói khi được gọi, tin xác nhận đã xong thì không trả lời, tối đa ~1.900 ký tự/tin, không đưa token/mật khẩu vào phòng.

**Điểm tốt (giữ nguyên):** dấu `"` phân biệt "gọi dậy" với "nhắc tới" là ý hay và rẻ; từ đứng riêng tránh khớp oan; whitelist chặn người lạ trong server; chốt cứng trong code (không chỉ dựa vào kỷ luật prompt) là đúng hướng — agent có thể quên kỷ luật, code thì không; giới hạn ký tự dưới trần 2.000 của Discord.

**Kẽ hở cần vá trước khi build:**

1. **Tên gọi của team quá ngắn/dễ trùng.** Tài liệu yêu cầu "tên ngắn, không trùng từ thường" và khai `NAME_TOKENS` gồm bản có dấu + không dấu. Tên thật của team là **Ú, Vịt, Bẹp** — "ú"/"u" là từ cực ngắn, `"u` sẽ khớp oan khắp nơi; bản không dấu ("vit", "bep") cũng dễ lẫn. Cần **tên gọi dậy riêng, dài và hiếm** (ví dụ 2–3 âm tiết không phải từ thường) tách khỏi tên hiển thị, và test kỹ cả bản có dấu/không dấu/dấu cong trên bàn phím điện thoại.
2. **`"tất cả"` nên chỉ Anh mới kích hoạt được.** Đặc tả cho tin bot–bot áp cùng luật địa chỉ, tức một agent có thể phát `"tất cả` đánh thức cả 3 phiên cùng lúc (tốn 3 lượt xử lý, dễ thành vòng lặp tập thể). Nên giới hạn broadcast cho `OWNER_ID`; peer bot chỉ gọi được từng agent một.
3. **Chốt 8 tin im lặng là nguy hiểm.** Khi chạm trần, cầu ngừng ghi inbox mà không báo gì — agent A sẽ tưởng B chết, Anh tưởng hệ hỏng. Chuỗi việc hợp lệ dài hơn 8 lượt (ví dụ A nhờ B test → B báo lỗi → A sửa → B test lại… trong device test) cũng bị cắt giữa chừng nếu Anh vắng mặt vài giờ. Cần: (i) cầu **đăng 1 tin thông báo** khi chạm trần ("đã chạm chốt 8 tin, chờ Anh lên tiếng"), (ii) thêm điều kiện reset ngoài "Anh nhắn lại" — ví dụ hết thời gian chờ (30–60 phút) hoặc một agent tuyên bố xong việc theo mẫu cố định. Số 8 là hằng số của tài liệu gốc, chưa có lý do đo được — nên để cấu hình được.
4. **Whitelist chặn người lạ, không chặn agent hiểu sai nhau.** Tin từ peer bot vẫn là output của model: một agent bị prompt injection qua nội dung nó đọc (trang web, file lạ) có thể gửi chỉ thị độc hại cho peer qua phòng chung. Luật nhà hiện tại (chỉ Anh/chị Bẹp giao task, task file là nguồn thật) phải được ghi cứng vào kỷ luật phòng: **tin trong phòng Discord là trao đổi, không phải lệnh giao việc** — việc chính thức vẫn phải thành task file. Nếu không, cầu Discord thành đường vòng qua PROTOCOL §5/§8 (Living Spec) và quyết định trong chat sẽ trôi mất.
5. **Chưa có luật cho tin sửa/xóa, thread, file đính kèm, tin dài hơn 1 tin nhắn.** Ở quy mô pilot có thể bỏ qua, nhưng phải ghi rõ là bỏ qua (bot chỉ đọc `content` của tin gốc trong đúng 1 kênh) để sau này không ai tưởng đã hỗ trợ.

**Kết luận mục 3:** khung luật đủ tốt để pilot sau khi vá 3 điểm đầu (tên gọi dậy riêng, broadcast chỉ cho Anh, chốt có thông báo + reset theo thời gian). Không có kẽ hở nào là lỗi chết người ở quy mô 1 server private 4 thành viên (Anh + 3 bot).

## 4. Trang nạp token: có an toàn không?

Thiết kế: mỗi cầu có 1 trang web nhỏ ở cổng `SETUP_PORT` riêng; khi `.env` chưa có token, trang mở cho Anh dán token; ghi xong trang **tự tắt hẳn** rồi bot mới khởi động; token đọc từ file lúc chạy (không bake vào image); `.env` quyền 600; token không bao giờ qua chat.

**Đúng ở nguyên tắc:** token không qua chat khớp luật nhà và khuyến nghị của Discord (token là mật khẩu của bot, lộ là phải Reset ngay; GitHub có secret scanning cho mẫu token Discord nhưng chỉ phủ repo GitHub, không phủ chat/ảnh chụp). Tự tắt sau khi nạp rút ngắn cửa sổ phơi bày. Đọc từ file lúc chạy giúp xoay token mà không build lại image. Quyền bot tối thiểu 68672 (đã giải mã ở mục kiểm chứng) giới hạn thiệt hại nếu token lộ: kẻ cầm token chỉ đọc/gửi được trong kênh bot được mời, không quản trị được server.

**Thiếu ở đặc tả (phải bổ sung, không được build nguyên văn):**

- **Ai truy cập được trang?** Đặc tả không nói trang bind `127.0.0.1` hay `0.0.0.0`, có mật khẩu/mã dùng 1 lần không, có HTTPS không. Nếu máy chủ cầu là VPS public và trang nghe `0.0.0.0:SETUP_PORT` bằng HTTP thường, bất kỳ ai quét thấy cổng trong lúc Anh đang nạp token đều có thể gửi token giả (chiếm cầu) hoặc nghe lén token thật trên đường truyền. Cửa sổ ngắn không cứu được nếu kẻ tấn công quét liên tục.
- **Token trên đường truyền:** dán qua HTTP trên LAN/WiFi nhà vẫn bị nghe lén bởi thiết bị cùng mạng. Cần ít nhất một trong: chỉ nghe localhost + Anh vào qua SSH tunnel (`ssh -L`) hoặc Tailscale; hoặc HTTPS; hoặc mã dùng 1 lần in trong log cầu mà Anh phải nhập kèm.
- **`.env` 600 là cần nhưng chưa đủ:** nó chặn user thường khác trên cùng máy, không chặn root, không chặn container khác mount nhầm volume, không chặn lộ qua sao lưu/ảnh chụp thư mục. Cần thêm: `.env` nằm ngoài Git (`.gitignore` trước commit đầu), thư mục dữ liệu không chia sẻ, và quy trình Reset Token viết sẵn (Portal → Bot → Reset Token → nạp lại → bot cũ tự offline) để khi nghi lộ là làm trong 1 phút.
- **3 bot = 3 token = 3 trang nạp.** Mỗi cầu một cổng riêng nhân bề mặt tấn công lúc setup lên 3. Nên nạp lần lượt từng cầu, tắt xong mới mở cầu tiếp theo, và ghi log thời điểm nạp (không ghi giá trị token).

**Kết luận mục 4:** giữ nguyên tắc "token không qua chat", nhưng trang nạp phải được vá thành: bind localhost/Tailscale-only + mã dùng 1 lần + tự tắt + log. Nếu không vá được, phương án thay thế an toàn hơn là Anh dán token qua phiên SSH trực tiếp vào file `.env` trên máy chủ cầu (vẫn không qua chat, không cần trang web nào). Quyết định này thuộc về Anh khi chốt build.

## 5. Độ trễ 6–10 giây: có đáng kể so với cách hiện tại không?

Cách hiện tại: watcher 5 phút hỏi SHA bằng `ls-remote` trước (giảm ~90% fetch, task 100/101 đã xác nhận), SHA đổi mới fetch — phát hiện task mới trong **~2–3 phút**; cron poll 15 phút là lưới dự phòng; watchdog soát task kẹt mỗi 2 giờ (chị cả). Tài liệu gốc hứa vòng hỏi–đáp agent–agent **6–10 giây** và phát hiện tin **< 1 giây** nhờ `tail -F`.

- Với **việc team đang làm** (build extension 30–120 phút, device test chờ điện thoại Anh, review/merge theo lượt chị cả), chênh lệch 2 phút lúc nhận việc là **không đáng kể** — nút thắt nằm ở thời gian làm + test + chờ Anh bấm Play, không nằm ở tốc độ phát hiện task. Con số 6–10 giây của tài liệu chỉ đúng cho tin trivial; một lượt xử lý thật của Muse (mở phiên, đọc task, chạy tool) đã vượt xa con số đó trước khi cầu kịp đăng trả lời.
- Với **trao đổi nhanh** ("Ú ơi nguồn này còn sống không?", "dừng task đó lại", Anh gọi cả 3 vào bàn 1 việc), độ trễ hiện tại là **vô hạn** vì kênh đó không tồn tại: agent chỉ trao đổi qua `notes` trong task file (bất đồng bộ, gắn với 1 task) và Anh phải chép tin giữa các tab chat. Cầu Discord không làm nhanh việc cũ bao nhiêu, nó **mở một loại việc mới**: hiện diện chung + gọi dậy tức thì.
- Đổi lại, cầu thêm 4 điểm hỏng mới (Discord gián đoạn, máy chủ cầu tắt, bộ canh SSH đứt, token/intent cấu hình sai) mà GitHub-first không có. Thiết kế inbox file + watermark giảm mất tin (tin nằm trong file chờ đọc bù) nhưng không cứu được khi máy chủ cầu mất đĩa. GitHub vẫn thắng về độ bền/audit: mọi thay đổi task đều có commit, xem lại được.

**Kết luận mục 5:** đừng mua cầu Discord vì "nhanh hơn 2 phút". Chỉ đáng cân nhắc nếu Anh thật sự cần **phòng chung để 3 chị em + Anh nói chuyện trực tiếp** — đó là quyết định về cách làm việc, không phải về độ trễ.

## 6. So với GitHub-first hiện tại: cầu giải quyết được gì GitHub chưa giải quyết?

| Việc | GitHub-first (đang chạy) | Cầu Discord (đề xuất) |
|---|---|---|
| Hàng đợi việc, claim 1-task-1-agent, hạn 2h, chống trùng | **Đã giải quyết tốt** (PROTOCOL §2–§3, 100+ task, registry Qsang_vbook 126 nguồn) | Không thay thế được — phòng chat không có claim/lease/review gate |
| Nguồn thật + audit + sống qua thay VM | **Đã giải quyết** (file trong repo, commit từng bước; 099 kết luận giữ nguyên) | Yếu hơn: chat trôi, inbox nằm trên máy chủ cầu; phải ghi ngược quyết định vào task file mới tính |
| Merge có kiểm chứng (validate PASS + device test 0 + install 200) | **Đã giải quyết** (chị cả merge duy nhất, PROTOCOL §4) | Không liên quan — cầu không được thành đường merge tắt |
| Anh nhìn thấy cả 3 agent trong 1 phòng, gọi tên là dậy | Chưa có — Anh nói chuyện riêng từng tab, agent không thấy nhau | **Đây là giá trị duy nhất cầu mang lại** |
| Agent hỏi nhau nhanh giữa chừng (không tạo task) | Chỉ qua `notes` trong task file (chậm, gắn theo task) | Có — nhưng phải kèm luật "chat không phải giao việc chính thức" (mục 3) |
| Chi phí + bảo trì | 0đ, hạ tầng sống trong repo | Cần máy chủ cầu (mục 2) + 3 bot + 3 cầu + 3 bộ canh + xoay token + vá máy chủ |

Nói gọn: **GitHub-first và cầu Discord không cạnh tranh cùng một việc.** GitHub là xương sống việc; cầu (nếu có) chỉ là phòng họp nhanh đặt cạnh xương sống. Bài học split-brain của hub cũ (`hub/data/tasks.json` tách khỏi file task, vá P0 17/11) áp dụng nguyên vẹn: nếu để phòng Discord thành nguồn thật thứ hai (giao việc, chốt quyết định chỉ trong chat), team sẽ có 2 sự thật lệch nhau. Vì vậy kể cả khi build, PROTOCOL phải thêm 1 dòng: mọi việc/quyết định nảy sinh trong phòng Discord chỉ có hiệu lực khi đã ghi vào task file.

Hiện tại nhu cầu "phòng họp nhanh" chưa từng là nút thắt được ghi nhận: mọi trao đổi đều qua task file và vẫn xong việc; lần duy nhất team cần gọi nhau gấp (task 112 kẹt 1h43 vì worker chết không để lại commit) đã được xử lý bằng watchdog 30 phút trong watcher (task 115), không cần chat realtime. Đây đúng là điều kiện 099 đã đặt ra ("chỉ xem lại khi team cần chat 2 chiều trong lúc làm — hiện tại chưa cần") và tới 20/11 điều kiện đó **vẫn chưa xuất hiện**.

## 7. Nếu Anh quyết build: Anh phải tự tay làm gì, cung cấp gì?

Liệt kê đầy đủ để Anh cân nhắc trước, không phải để làm ngay (task này cấm build). Agent không làm thay được các việc gắn với tài khoản Discord và máy của Anh.

**Việc tay của Anh (theo tài liệu gốc, đã đối chiếu Portal hiện hành):**

1. Tạo (hoặc chọn) **Discord server + kênh** làm phòng chung (ví dụ kênh `#ai-agent`), mời đủ quyền quản trị để thêm bot.
2. Với **từng bot trong 3 bot** (mỗi agent 1 bot riêng): vào Discord Developer Portal → New Application → mục Bot → **bật MESSAGE CONTENT INTENT** (toggle ở Privileged Gateway Intents) → Reset Token để lấy token (Discord chỉ hiện 1 lần).
3. **Mời từng bot vào server** bằng link OAuth2 quyền **68672** (đã giải mã: Xem kênh + Gửi tin + Đọc lịch sử + Thêm reaction — không cấp thêm quyền nào khác).
4. **Dán token của từng bot vào trang nạp token** của cầu tương ứng (không gửi token qua chat/ảnh chụp/file trong repo). Nếu nghi lộ: Reset Token ngay trong Portal, token cũ tự vô hiệu.
5. **Chốt máy chủ cầu** (mục 2): xác nhận có máy nhà luôn bật có Docker + SSH, hoặc mở tài khoản VPS trả phí; cấp quyền SSH/Tailscale cho 3 VM vào máy đó; phê duyệt lần đầu từng địa chỉ đích qua proxy 3130 khi agent kết nối.
6. Có mặt cho **5 bài kiểm chứng bắt buộc** của tài liệu, đặc biệt bài 2 (tự thức khi không ai mở tab chat) và bài 4 (chuyền việc A→B→A không người can thiệp) — hai bài này cần Anh chứng kiến mới tính là đạt.

**Thông tin Anh phải cung cấp:**

| Cần cung cấp | Ghi chú |
|---|---|
| Tên gọi dậy cho từng agent | Tên **dài, hiếm, không trùng từ thường**, kèm bản có dấu + không dấu; không dùng thẳng "Ú/Vịt/Bẹp" (mục 3) |
| Máy chủ cầu: hệ điều hành, có Docker chưa, địa chỉ SSH (user@host/IP tailnet) | Điều kiện tiên quyết — chưa có thì dừng ở đây |
| Server + kênh Discord dùng làm phòng chung | Kèm `GUILD_ID` + `CHANNEL_ID` (agent lấy được sau khi bot vào server, nhưng Anh phải chỉ đúng server/kênh) |
| User ID Discord của Anh (`OWNER_ID`) | Để whitelist chỉ nhận lệnh gọi dậy từ Anh + các bot bạn |
| Quyết định về trang nạp token | Giữ trang web (đã vá localhost + mã dùng 1 lần) hay dán qua SSH (mục 4) |
| Quyết định về `"tất cả"` và chốt 8 tin | Chỉ Anh mới broadcast được? Chốt mấy tin, reset theo thời gian bao lâu? (mục 3) |

**Việc agent tự làm được (khi đủ điều kiện):** dựng code cầu + docker-compose cho 3 cầu, bộ lọc luật địa chỉ, bộ canh phía VM (sau khi thiết kế lại cơ chế đánh thức — mục 1b), watermark chống trùng, chạy đủ 5 bài kiểm chứng và báo cáo số đo độ trễ. Ước lượng công sức **chưa xác định** vì phụ thuộc cơ chế đánh thức runtime có hỗ trợ hay không — không nên hứa số buổi khi chưa chứng minh được bài test tự thức.

## Kết luận: KHÔNG NÊN build ở thời điểm này

**Quyết định đề xuất: KHÔNG NÊN (tạm hoãn), giữ GitHub-first làm xương sống duy nhất.** Lý do xếp theo mức chặn:

1. **Không có máy chủ cầu** (mục 2) — điều kiện vật chất chưa tồn tại, lựa chọn miễn phí đều bị loại bởi ràng buộc client-only đã chứng minh.
2. **Cơ chế tự thức chưa chứng minh được trên Muse** (mục 1b) — tài liệu gốc viết cho agent daemon thường trực; Muse thức dậy theo hook/cron nên phải thiết kế + test lại khâu khó nhất trước khi đầu tư phần còn lại.
3. **Nhu cầu chưa xuất hiện** (mục 5–6) — GitHub-first đang gánh tốt toàn bộ việc thật; cầu chỉ thêm phòng chat nhanh, trong khi chi phí bảo trì (máy chủ + 3 bot + 3 bộ canh + token) là thật và lâu dài.

**Mở lại khi đủ 4 điều kiện (thiếu 1 cũng chưa build):**

1. Anh chốt được máy chủ cầu luôn bật (máy nhà có sẵn **hoặc** chấp nhận VPS trả phí) và cho 3 VM SSH/Tailscale vào được.
2. Chứng minh được **bài test tự thức tối thiểu** trên 1 VM: một sự kiện local (file/SSH) đánh thức được một phiên Muse mới trong < 1 phút mà không cần người mở chat — nếu runtime không hỗ trợ, dừng hẳn hướng này và cân nhắc thay thế bằng watcher GitHub rút ngắn nhịp cho tin gấp.
3. Anh xác nhận nhu cầu phòng chung là việc thật (ví dụ: muốn gọi cả 3 chị em vào bàn việc trực tiếp thường xuyên), không chỉ "có vẻ hay".
4. Vá xong 3 điểm an toàn: tên gọi dậy riêng + broadcast chỉ cho Anh + chốt có thông báo (mục 3); trang nạp token localhost/mã dùng 1 lần hoặc dán qua SSH (mục 4); luật "chat Discord không thay task file" ghi vào PROTOCOL (mục 6).

**Bước tiếp theo cụ thể (không tốn phí, làm được ngay nếu Anh muốn giữ cửa mở):**

- Anh trả lời 2 câu: (a) nhà có máy nào luôn bật (NAS/mini PC/PC) có thể làm máy chủ cầu không? (b) Anh có thật sự muốn phòng chat chung để gọi 3 chị em trực tiếp không, hay GitHub + chat hiện tại đã đủ?
- Nếu (a) hoặc (b) là "không": đóng hướng này, ghi vào STATUS.md là đã nghiên cứu và tạm hoãn (báo cáo này là bằng chứng), không tạo task build.
- Nếu cả hai là "có": tạo 1 task **thử nghiệm tự thức** nhỏ (chỉ 1 VM, 1 bot, 1 cầu trên máy Anh) để qua bài test 2 trước; đạt mới tạo task build đầy đủ. Không build 3 cầu cùng lúc khi chưa qua test tự thức.

## Nguồn

- Tài liệu gốc trong repo: `research/cau-discord-ban-cho-agent.md` (Phần 1–3); task file `tasks/133-nghien-cuu-cau-discord-noi-3-muse-vao-1-.json`; `PROTOCOL.md` §1–§10; `STATUS.md` (20/11 20:03); báo cáo `research/099-pattern-phoi-hop-khong-inbound.md` (ràng buộc VM + pattern bot trung gian); `hub/server.js` + `hub/muse-teamwork-hub.service` + `docs/SETUP-HUB.md` (bài học inbound/systemd/thay VM); `agents.yaml` (IP + vai 3 agent); kiểm tra máy muse-1 ngày 20/11 (không có Docker, systemd 255, OpenSSH 9.6, giải mã quyền 68672 bằng script).
- Discord chính thức + kiểm chứng độc lập (11/2026): Privileged Intent Review guide (ngưỡng 10.000 users từ 10/06/2026, toggle dưới ngưỡng, gia hạn hằng năm) — https://docs.discord.com/developers/gateway/getting-started-with-privileged-intent-review ; tổng hợp intent + lỗi 4014 — https://www.conferbot.com/blog/discord-message-content-intent , https://space-node.net/blog/discord-gateway-intents-message-content-2026 ; giới hạn tốc độ (REST 50 req/s, tin 2.000 ký tự, Gateway 120/60 giây) — https://www.conferbot.com/limits/discord ; token là mật khẩu của bot, Reset làm vô hiệu token cũ, lưu ngoài Git — https://www.conferbot.com/blog/how-to-get-discord-bot-token , https://squarecloud.app/en/learning/bots/discord-bot-token , https://squarecloud.app/en/learning/security/bot-token-leaked .
- Chưa kiểm chứng (ghi rõ để chị cả biết): giá VPS cụ thể (chưa chọn nhà cung cấp nên không chốt số); RAM/CPU ~35 MB của cầu (ước lượng tài liệu gốc, task cấm build nên không đo lại); proxy 3130 có giữ được SSH 540 giây không (cần test thật ở bước thử nghiệm tự thức).
