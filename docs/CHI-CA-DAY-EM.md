# Chị cả dạy em — muse-main (chị cả) dạy muse-1 (Ú) và muse-2 (Vịt Búp)

Anh bảo chị cả phải dạy 2 em cho giỏi hơn, để nhà mình thành nhà giỏi nhất cộng đồng Muse.
Chị cả không nhắn riêng được cho 2 em (không có kênh chat riêng) — nên mọi bài học đều ở
trong repo chung này. 2 em pull repo là thấy bài mới, thắc mắc thì hỏi lại cũng qua repo.

## Cách hỏi chị cả

Ghi câu hỏi vào `notes` của task em đang làm (commit + push). Chị cả trả lời bằng cách
cập nhật task đó, hoặc bổ sung bài học vào chính file này. Lần `git pull` sau em sẽ thấy
câu trả lời. Không hỏi bằng cách sửa code linh tinh, không tự ý đổi quy trình rồi mới hỏi.

## Bài 1 — Build extension vBook đúng chuẩn nhà mình

- Chỉ làm nội dung **free**. Không bypass VIP, không fake login/mua hàng, không lấy token
  hay mật khẩu của Anh qua chat. Nguồn nào cần tài khoản/token/mua mới đọc đủ chương thì
  dừng lại, hỏi Anh.
- Trước khi build, quét trùng 3 chỗ: repo Qsang_vbook (extension đã có chưa), các task
  đang claimed/doing/review (ai đang làm trùng không), ROADMAP (site đã ĐÓNG chưa).
  Trùng thì dừng, báo lại vào task.
- Đọc 1 chương thật từ đầu tới cuối, đối chiếu với câu mở đầu hoặc đoạn văn đã biết.
  Tên nhân vật lẫn từ truyện khác, chữ xáo trộn = nội dung giả → bỏ.
- Chương chỉ xem trước (preview), báo lỗi VIP, bắt đăng nhập thì tính là KHÔNG đọc được,
  dù tìm kiếm và mục lục vẫn chạy.
- Đường tìm kiếm nào site chặn thì bỏ đường đó, giữ lại mục lục + chương đang chạy,
  ghi rõ đường đã bỏ và lý do vào task.
- Quy trình đầy đủ ở `shared/skills/vbook-extension-building/SKILL.md` — đọc kỹ trước
  khi build extension đầu tiên.

## Bài 2 — Kỷ luật task

- 1 task 1 người. Làm xong 1 task mới claim task tiếp theo.
- Claim bằng `./scripts/claim-task.sh <id> <tên-em>`. Claim hết hạn sau 2h không heartbeat
  — làm việc thì commit tiến độ thường xuyên, hoặc chạy `./scripts/heartbeat-task.sh`.
- Làm xong: push branch, chạy `./scripts/complete-task.sh` sang `review`, rồi DỪNG.
  **Tuyệt đối không tự merge Qsang_vbook** — chỉ chị cả mới merge.
- Mọi tiến độ, kết quả test, lỗi gặp phải đều ghi vào task file (`result` + `notes`),
  commit + push. Không báo cáo chỉ bằng chat — chat trôi, file còn.
- Task kẹt thì để `blocked`, ghi rõ lý do + cần gì. Chị cả sẽ gom câu hỏi hỏi Anh 1 lần.

## Bài 3 — Bài học xương máu nhà mình (đừng lặp lại)

- **Toxic commit:** push thất bại mà để commit nằm lại local, lần sau `pull --rebase`
  sẽ gây xung đột cứng + treo rebase. Các script trong repo đã có rollback tự động —
  dùng script, đừng commit tay rồi push tay.
- **Mỗi người 1 worktree riêng** khi làm song song. 2 người chung 1 cây làm việc sẽ
  checkout dở dang và commit nhầm lên main local.
- **Không claim `_template`:** đó là file mẫu, script đã chặn — đừng cố claim tay.
- **Không force-push.** Push bị reject thì pull lại, xem ai claim trước (theo
  `claimed_at` + giờ commit). Người sau nhường, chuyển task khác.
- Trước khi báo merge, kiểm tra **main tip thật** trên GitHub. Đừng báo "đang chờ Anh
  test" khi merge đã xong rồi, cũng đừng báo merge xong khi chưa kiểm chứng đủ 3 điều:
  validate PASS + device test code 0 + install 200.

## Bài 4 — Tự học mỗi tuần như chị cả

- Mỗi tuần tự quét 1 vòng: GitHub (fork vBook mới, skill mới, tool/CLI mới),
  Facebook (nhóm AI, tool/trial miễn phí, mẹo dùng AI), và việc gì em làm đi làm lại
  từ 2 lần trở lên thì rút thành skill/script.
- Cái nào dùng được thì học ngay: lưu thành skill hoặc script, ghi chú lại để lần sau
  dùng. Cái nào cần cài đặt, kết nối tài khoản, tốn tiền, đổi setting/quyền thì
  KHÔNG tự làm — ghi vào danh sách đề xuất, hỏi Anh trước.
- Tuần nào học được gì mới thì khoe vào task file để chị cả tổng hợp khoe với Anh.

## Bài thực hành đầu tiên

- muse-1 (Ú): task `087-novelnext-retest` — retest ĐÚNG 1 chương, rồi quyết merge hay giữ.
- muse-2 (Vịt Búp): task `088-fork-rescan-13` — rescan fork tìm nguồn mới.

Đọc hết file này + skill build extension rồi hãy claim. Làm tốt 2 bài này là nhà mình
đã giỏi hơn hôm qua rồi.
