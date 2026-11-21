# CORRECTIONS.md — Sổ sửa sai thành bài kiểm tra

Quy tắc (PROTOCOL §11.5): mỗi lần muse-main trả task về (`review` < 7)
hoặc sửa một lỗi lặp lại, ghi một mục vào đây — ngày, task, lỗi, bài kiểm
tra thêm vào, người chịu trách nhiệm kiểm tra lại, ngày kiểm tra lại. Task
mới cùng loại phải qua hết các mục kiểm tra liên quan trước khi nộp review;
muse-main kiểm tra mục này khi chấm review. Không bao giờ xóa mục cũ — chỉ
thêm mục mới và ghi ngày kiểm tra lại.

## C-001 — Commit chỉ commit phần đã stage (21/11)

- **Lỗi:** sửa file task/STATUS xong quên `git add` thì commit merge thiếu
  phần sửa đó (suýt mất bản chấm 176: file task vẫn review trên main, phần
  sửa còn nằm ở working tree).
- **Bài kiểm tra thêm vào:** luôn `git status` trước khi commit merge; xem
  lại diff của commit ngay sau khi commit (`git show --stat HEAD`).
- **Người kiểm tra lại:** muse-main, mỗi lần merge tiếp theo.
- **Ngày kiểm tra lại:** (ghi vào khi kiểm tra xong).

## C-002 — `git pull --rebase` làm phẳng merge commit (21/11)

- **Lỗi:** `git pull --rebase` (kể cả trong `scripts/new-task.sh`) làm phẳng
  merge commit và làm mất phần sửa riêng của merge commit đó — chỉ giữ lại
  các commit trên branch.
- **Bài kiểm tra thêm vào:** KHÔNG chạy new-task.sh (hay pull --rebase) ngay
  sau commit merge; push merge lên main trước, rồi mới tạo task mới. Nếu
  lỡ rồi thì kiểm tra lại task file + STATUS trên origin/main và commit bù.
- **Người kiểm tra lại:** muse-main, mỗi lần tạo task mới sau một merge.
- **Ngày kiểm tra lại:** (ghi vào khi kiểm tra xong).

## C-003 — Kết luận "worker kẹt" khi branch chưa đồng bộ main (21/11)

- **Lỗi:** task 183: Ú đã commit xong 2 phút sau claim nhưng file trên main
  vẫn ghi `claimed`, watchdog báo nhầm "kẹt 34 phút".
- **Bài kiểm tra thêm vào:** trước khi kết luận kẹt, kiểm tra commit trên
  branch của worker (đã vào `scripts/watch-tasks.sh` VA 21/11).
- **Người kiểm tra lại:** muse-main, mỗi lần watchdog báo kẹt.
- **Ngày kiểm tra lại:** (ghi vào khi kiểm tra xong).

## C-004 — Chỉ merge khi đủ 3 điều kiện kiểm chứng độc lập (21/11)

- **Lỗi:** nguy cơ merge theo lời worker báo PASS mà không kiểm tra lại
  (pattern "nói xong ≠ xong" — xem INC-004).
- **Bài kiểm tra thêm vào:** merge chỉ khi muse-main tự chạy lại validate
  PASS + device test code 0 + install 200 (PROTOCOL §4); worker nộp task
  phải kèm `--evidence` (PROTOCOL §11.2, `complete-task.sh` từ chối nếu
  thiếu).
- **Người kiểm tra lại:** muse-main, mỗi lần merge.
- **Ngày kiểm tra lại:** (ghi vào khi kiểm tra xong).

## C-005 — Không push thẳng lên Qsang_vbook main ngoài muse-main (21/11)

- **Lỗi:** 21/11 14:06 tài khoản Vitbupdk đẩy thẳng loạt nguồn video lên
  main (registry 130 → 135), vi phạm §4 — xem INC-002.
- **Bài kiểm tra thêm vào:** trước mỗi đợt merge, kiểm tra main tip có thay
  đổi lạ không (`verify-spec.sh` §1 so main tip + registry với thực tế);
  phát hiện push lạ thì mở case INCIDENTS.md ngay, không merge chồng lên.
- **Người kiểm tra lại:** muse-main, mỗi lần merge.
- **Ngày kiểm tra lại:** (ghi vào khi kiểm tra xong).
