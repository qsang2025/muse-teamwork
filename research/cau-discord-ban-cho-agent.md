# Nối nhiều AI agent vào một phòng Discord chung — bản đưa cho agent làm theo

*Tài liệu này có 2 phần. Phần 1 dành cho người đọc. Phần 2 viết sẵn dạng lệnh: bạn chỉ cần điền mấy chỗ trống rồi dán nguyên khối vào chat của AI agent nhà bạn, nó sẽ tự dựng hệ thống giống hệt.*

---

## PHẦN 1 — Dành cho người đọc (3 phút)

**Bài toán:** bạn có nhiều AI agent (ví dụ nhiều tài khoản Muse) chạy ở nhiều máy. Bạn muốn chúng nói chuyện trực tiếp với nhau trong một phòng chat bạn nhìn thấy hết, thay vì bạn phải chép tin qua lại giữa các tab. Và khi bạn gọi tên đứa nào trong phòng, nó phải tự thức dậy trả lời — kể cả lúc nó đang "nghỉ".

**Cách giải quyết trong tài liệu này:**

- Mỗi agent được cấp **một con bot Discord riêng** (dùng Bot API chính thức của Discord, không giả lập trình duyệt, không đụng vào tài khoản AI của bạn).
- Trên một máy chủ luôn bật trong nhà (NAS, mini PC, VPS… đều được), mỗi bot có một chương trình nhỏ gọi là **"cầu"** chạy bằng Docker. Cầu nghe tin trong phòng, lọc ra tin nào gọi đúng agent của nó thì ghi vào một file "hộp thư đến" (inbox).
- Agent tự canh hộp thư bằng một kết nối chờ sẵn (long-poll): tin tới là nó biết trong dưới 1 giây và thức dậy xử lý. Trả lời bằng cách ghi một file vào "hộp thư đi" (outbox), cầu tự đăng lên phòng.
- Muốn gọi agent nào thì gõ **dấu ngoặc kép trước tên** nó, ví dụ: `nhờ "gà kiểm tra việc này`. Tên không có dấu `"` phía trước chỉ là *nhắc tới*, không đánh thức — tránh trường hợp đang nói về một agent mà nó bị gọi dậy oan.
- Phòng có **luật chống nói vòng lặp**: agent chỉ lên tiếng khi được gọi và chỉ nói đúng việc; xong là im. Trong code cầu còn có chốt cứng: tối đa 8 tin bot–bot liên tiếp, quá là cầu tự ngắt.

**Bạn sẽ phải tự tay làm đúng 4 việc** (agent không làm thay được): tạo bot trên trang Discord Developer Portal, bật một công tắc quyền trong đó, bấm link mời bot vào server của bạn, và dán token của bot vào một trang web nội bộ (token không đi qua chat). Mọi việc còn lại agent của bạn tự làm được nếu bạn đưa nó Phần 2.

**Chi phí vận hành:** mỗi cầu tốn ~35 MB RAM, gần như 0% CPU khi rảnh. Độ trễ một vòng hỏi–đáp giữa hai agent: khoảng 6–10 giây.

---

## PHẦN 2 — Dành cho AI agent (dán nguyên khối này cho agent của bạn)

> Trước khi dán: điền các chỗ trong bảng này.
>
> | Cần điền | Ví dụ |
> |---|---|
> | Tên các agent (mỗi agent một tên ngắn, không trùng từ thường) | `Gà`, `Lu` |
> | Máy chủ chạy cầu (hệ điều hành, có Docker, địa chỉ SSH) | Debian, `debian@192.168.1.50` |
> | Server + kênh Discord dùng làm phòng chung | server riêng, kênh `#ai-agent` |
> | User ID Discord của chủ nhà | dãy số trong Discord |
>
> Việc tay của chủ nhà (làm khi agent yêu cầu): tạo Discord application cho từng bot, bật **MESSAGE CONTENT INTENT**, mời từng bot vào server bằng link quyền **68672** (Xem kênh + Gửi tin + Đọc lịch sử + Thêm reaction), dán token của từng bot vào trang nạp token của cầu tương ứng.

```
Bạn được giao xây dựng hệ thống "cầu Discord" nối các AI agent của chủ nhà vào một phòng chat chung, theo đúng đặc tả dưới đây. Làm lần lượt từng bước, kiểm chứng từng bước bằng bằng chứng thật (log, file, tin đăng thành công) rồi mới đi tiếp. Không tự ý thay đổi kiến trúc.

## Mục tiêu
Mỗi agent có một bot Discord riêng và một "cầu" riêng chạy Docker trên máy chủ. Cầu lọc tin trong phòng, ghi tin gọi đúng agent vào hộp thư đến (inbox) dạng file; agent canh inbox bằng long-poll đứng và trả lời qua hộp thư đi (outbox) dạng file. Chủ nhà không chuyển tin hộ giữa các agent.

## Thành phần phải dựng cho MỖI agent
1. Một thư mục riêng trên máy chủ: app/ (code cầu), data/inbox/, data/outbox/, file .env (quyền 600), docker-compose.yml. Mỗi cầu là một container độc lập.
2. Code cầu (Python + discord.py) gồm:
   a. Bot: đăng nhập bằng token trong file .env (đọc từ FILE lúc chạy, không phụ thuộc biến môi trường đã bake vào container). Chỉ xử lý tin trong đúng GUILD_ID + CHANNEL_ID đã khai.
   b. Trang nạp token: nếu .env chưa có token, mở một trang web nhỏ ở cổng SETUP_PORT (mỗi cầu một cổng riêng) cho chủ nhà dán token; ghi token vào .env xong thì trang TỰ TẮT hẳn và bot mới khởi động. Token không bao giờ được yêu cầu qua chat.
3. Giao thức file:
   - Tin hợp lệ → append 1 dòng JSON vào data/inbox/inbox.jsonl, gồm: msg_id, author_id, author_name, content, ts (ISO +07:00 hoặc múi giờ chủ nhà), rx (epoch giây lúc cầu nhận).
   - Trả lời: agent ghi data/outbox/<msg_id>.txt (ghi .tmp rồi đổi tên). Cầu quét outbox mỗi 0,5 giây, đăng dạng reply vào phòng, xóa file, và phản ứng 👍 lên tin gốc khi ghi inbox thành công.
   - Chỉ thị đang soạn: khi có tin vào inbox chưa được trả lời, bot hiện "đang nhập…" trong phòng; trần cứng 240 giây/tin.

## Luật địa chỉ (bắt buộc, cài vào bộ lọc của cầu)
Một tin chỉ vào inbox của agent X khi thuộc một trong các trường hợp:
- Tin @mention bot của X (user-mention hoặc role-mention Discord tự tạo cho app);
- Nội dung chứa dấu " ngay trước tên của X (ví dụ "gà), không phân biệt hoa thường, chấp cả dấu “ cong của bàn phím điện thoại, và tên phải là một từ đứng riêng (chữ "lu không được khớp trong "luôn);
- Nội dung chứa cụm "tất cả" → vào inbox của mọi agent.
Whitelist cứng: chỉ nhận tin từ OWNER_ID (chủ nhà) và từ các bot trong PEER_BOT_IDS (bot của các agent khác). Mọi nguồn khác bỏ qua. Tin bot–bot áp cùng luật địa chỉ.
Chốt chống lặp trong code: đếm tin bot–bot liên tiếp vào inbox; quá 8 tin mà chủ nhà chưa lên tiếng thì ngừng ghi inbox cho tới khi chủ nhà nhắn lại.

## File .env mẫu
DISCORD_BOT_TOKEN=        (để trống lúc đầu)
GUILD_ID= / CHANNEL_ID= / OWNER_ID=   (chủ nhà cung cấp)
NAME_TOKENS=<tên agent, gồm bản có dấu và không dấu, cách nhau dấu phẩy>
PEER_BOT_IDS=<id các bot bạn, cách nhau dấu ;>
SETUP_PORT=<cổng riêng của cầu này>
DATA_DIR=/data

## Phần agent phải tự dựng cho chính mình (bộ canh)
1. Long-poll ĐỨNG: giữ MỘT kết nối SSH mở liên tục tới máy chủ, chạy lệnh nghe đuôi file inbox của mình NGAY PHÍA MÁY CHỦ (tail -F). Tin mới phải được phát hiện trong dưới 1 giây. Cửa sổ chờ ~540 giây, hết tự nối lại. CẤM thăm dò theo đợt (polling cách nhau hàng chục giây trở lên) — đã có trường hợp thật bị rớt tin điểm danh và trả lời chậm nhiều phút vì kiểu đó.
2. Nghe được tin phải đánh thức một lượt xử lý ngay, đưa kèm nội dung tin.
3. Watermark bền chống trùng: giữ file trên máy của agent ghi msg_id đã xử lý. Xử lý xong tin nào ghi ngay msg_id đó; khởi động/nối lại thì đọc bù inbox nhưng bỏ qua mọi msg_id đã có trong file. Một tin chỉ trả lời đúng một lần, kể cả khi bộ canh khởi động lại giữa chừng. Trước khi bật bộ canh mới phải tắt hẳn bộ canh cũ (hai bộ canh song song giành tin cũng gây trùng).

## Kỷ luật phòng (ghi vào hướng dẫn vận hành của mọi agent)
- Không tự ý gửi tin, không tán gẫu, không nói ngoài việc. Chỉ lên tiếng khi được gọi đúng luật địa chỉ, và chỉ nói đúng việc được giao.
- Tin chỉ là xác nhận/thông báo đã xong thì KHÔNG trả lời. Vấn đề đã giải quyết là chấm dứt hội thoại ngay.
- Trả lời tối đa ~1900 ký tự/tin, ngắn gọn.
- Token, mật khẩu, khóa không bao giờ xuất hiện trong phòng.

## Kiểm chứng bắt buộc trước khi báo xong (thiếu một là chưa xong)
1. Hai chiều: chủ nhà nhắn gọi tên agent trong phòng → tin vào inbox trong <1 giây (đối chiếu trường rx), agent trả lời, tin hiện trong phòng.
2. Tự thức: agent đang nghỉ hoàn toàn, không ai mở tab chat của nó; agent điều phối (hoặc chủ nhà) gọi tên → agent tự dậy trả lời trong vòng 1 phút. (Không chấp nhận kết quả "đạt" nếu phải có người vào gọi agent dậy.)
3. Lọc đúng: một tin nhắc tên agent khác ở giữa câu (không dấu ") KHÔNG được vào inbox của agent đó; một tin dùng dấu " đúng cách chỉ vào đúng một inbox.
4. Chuyền việc: agent A đăng một số bất kỳ và gọi "B; B tự thức, nhân đôi số đó, đăng kết quả gọi "A; A kiểm chứng phép tính đúng — trọn chuỗi không có người can thiệp.
5. Chống trùng: trong suốt các bài test, không agent nào trả lời trùng một tin hai lần.

Báo cáo cuối cùng cho chủ nhà: kiến trúc đã dựng (sơ đồ chữ), nơi đặt code và dữ liệu, kết quả từng bài kiểm chứng kèm số đo độ trễ, và các giới hạn còn lại nếu có.
```

---

## PHẦN 3 — Mẹo cho người dùng khi vận hành

- Gọi một agent: `"tên` ở đầu câu là chắc ăn nhất. Gọi cả phòng: dùng chữ `tất cả`.
- Thấy bot hiện "đang nhập…" mãi không trả lời: nghĩa là tin đã tới hộp thư nhưng agent chưa dậy — kiểm tra bộ canh của agent đó trước, đừng trách đường truyền.
- Muốn thêm agent mới: lặp lại đúng quy trình (thêm bot + thêm cầu + cập nhật danh sách bot bạn ở mọi cầu + thêm khóa SSH), rồi bắt agent mới qua đủ 5 bài kiểm chứng ở Phần 2.
- Muốn đuổi một agent khỏi phòng: dừng container cầu của nó và thu hồi khóa SSH của nó — xong, không ảnh hưởng các agent còn lại.
