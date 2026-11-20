# QA độc lập 157 — Kiểm chứng chuyển đổi hook tiết kiệm token (inbox + watchdog)

- Người kiểm chứng: muse-1 (Ú), độc lập với người viết script (muse-main).
- Ngày: 21/11/2026. Phạm vi: `hooks/muse-teamwork-inbox.sh`, `hooks/muse-teamwork-watchdog.sh`, `hooks/README.md`, `scripts/watch-tasks.sh` (đối chiếu), PROTOCOL §7/§10.
- Phương pháp: đọc code từng dòng + dry-run trên repo thật (DRY=1, state cách ly ở /tmp, không đụng state live) + test tổng hợp bằng repo git giả/bare local và `gh` giả (PATH shim) — không tạo issue thật, không sửa state live.
- Giới hạn (flag rõ): state file `~/hooks/state/*.json`, output hooks.list/cron.list live và file `~/.config/gh/hosts.yml` chỉ có trên máy muse-main. Phần trạng thái live dưới đây đối chiếu snapshot muse-main ghi trong task 157, **chưa kiểm chứng trực tiếp được từ máy muse-1** (đánh dấu UNVERIFIED).

## Kết luận tổng thể: PASS có điều kiện

Logic wake cốt lõi đúng và đã test qua đủ đường. Không có lỗi chặn (blocker) khiến chuyển đổi phải rollback. Có 2 vấn đề mức TRUNG BÌNH cần muse-main sửa/xác nhận (gh auth là điểm chết đơn; idle-wake khi còn task open chưa gán / task blocked) và vài điểm THẤP (doc drift, state write không atomic, per_page=100). Lưới an toàn 06:46 + poll 15 phút của muse-1/muse-2 vẫn đỡ được phần lớn hậu quả khi hook chết im, tối đa chậm 24h với lệnh dashboard.

## 1. Inbox gate (`hooks/muse-teamwork-inbox.sh`)

| Mục | Kết quả | Bằng chứng |
|---|---|---|
| Issue [dashboard] mới → wake | PASS | Test I1 (gh giả): WAKE #5, ghi last_wake |
| Lặp lại <2h → silent | PASS | Test I2: SILENT |
| Wake lại sau 2h | PASS | Test I3 (backdate 3h): WAKE lại |
| Issue đóng → xóa state, mở lại wake được | PASS | Test I4/I5 |
| Loại PR, lọc prefix (strip + lower) | PASS | Test I1 (PR bị loại), I8 (khoảng trắng + hoa/thường vẫn bắt) |
| JSON hỏng → silent, không crash | PASS | Test I7 |
| State hỏng → wake lại (ồn nhưng an toàn), không crash | PASS | Test I6 |
| Dry-run không ghi state | PASS | Code `if dry: return`; dry-run thật không tạo state |
| Fetch lỗi → silent | PASS (có đánh đổi) | Dry-run thật trên máy muse-1: `gh` chưa đăng nhập → silent "khong doc duoc issue". Đúng thiết kế fail-silent, nhưng xem F-1 |

### F-1 [TRUNG BÌNH] `gh api` phụ thuộc auth file trên máy muse-main — điểm chết đơn, fail-silent
- Script đã đổi từ curl không auth sang `gh api` (sửa đúng hướng: unauth chỉ 60 req/h cho cả IP egress dùng chung; lúc QA đo được 56/60 còn lại — rủi ro 403 là thật, không phải lý thuyết).
- Nhưng trên máy muse-1, `gh auth status` = chưa đăng nhập → gate chết im hoàn toàn (đã chứng minh bằng dry-run). Live inbox chỉ chạy trên muse-main nên hiện tại vẫn có thể đúng, nhưng: token hết hạn/bị revoke/VM muse-main bị thay (mất `~/.config/gh/hosts.yml`) → inbox im lặng tối đa tới lượt 06:46 (24h) mới được backup. Gate không tự kiểm tra `gh auth status`, không fallback curl có ETag, không đếm số lần fail liên tiếp để tự báo.
- Khuyến nghị: (a) muse-main xác nhận `gh auth status` + `gh api rate_limit` trên máy live và ghi vào sổ hook; (b) thêm vào lượt 06:46 mục kiểm tra gh auth (hiện README chỉ nói kiểm tra hook đăng ký/enabled); (c) cân nhắc fallback: gh fail ≥ N lần liên tiếp thì wake 1 lần báo lỗi thay vì silent mãi.
- Trạng thái `gh` trên máy muse-main: **UNVERIFIED từ muse-1**.

### F-2 [THẤP] `per_page=100` không phân trang
- Hơn 100 issue mở thì issue [dashboard] ở trang 2 bị sót. Repo hiện ít issue nên rủi ro thấp; ghi nhận để sửa khi cần (thêm `--paginate` hoặc lọc `labels`).

## 2. Watchdog gate (`hooks/muse-teamwork-watchdog.sh`)

Test trên repo giả (bare local làm origin), state thật trong /tmp:

| Mục | Kết quả | Bằng chứng |
|---|---|---|
| Lần chạy đầu ghi baseline, silent | PASS | T1; dry-run repo thật: silent, tasks_seen=87 |
| (b) Hết hạn claim → wake (kể cả lần đầu) | PASS | T2 |
| (b) Không wake lại trong 2h cùng một lần hết hạn | PASS | T3 |
| (d) Mới chuyển blocked → wake | PASS | T4 |
| (c) Worker rảnh → wake 1 lần/episode | PASS | T6/T7 |
| KHÔNG wake khi task vào review | PASS | T5 (đúng thiết kế, tránh 2 agent cùng merge) |
| State hỏng → baseline lại, không crash | PASS (có đánh đổi, F-4) | T8 |
| Timestamp không timezone → hiểu là +07:00 | PASS | T9 (task file đều ghi +07:00; parse đúng) |
| SHA không đổi → dùng snapshot cache, vẫn bắt hết hạn theo thời gian | PASS (đọc code + T3 chạy ở mode cached) | Nhánh MODE=cached vẫn chạy vòng (b)/(c) trên snapshot đã lưu |
| ls-remote/fetch lỗi → silent | PASS | Code + dry-run watch-tasks khi repo path sai cho silent đúng mẫu |

### F-3 [TRUNG BÌNH] Điều kiện "worker rảnh" (c) có thể wake thừa
- `busy` chỉ tính task có `assignee`/`preferred_assignee` == agent ở trạng thái open/claimed/doing/review. Hai hệ quả đã tái hiện:
  - T10: còn task `open` chưa gán ai (muse-1/muse-2 claim được theo luật poll) nhưng worker vẫn bị coi là rảnh → wake muse-main giao task tự học trong khi việc claimable đang nằm đó.
  - T4: worker có task duy nhất ở `blocked` (không thuộc OPEN_STATUSES) → vừa wake "newly blocked" vừa wake "idle" trong cùng payload. Muse-main có thể giao task học mới trong khi task blocked chưa phân loại xong.
- Hậu quả: wake thừa (tốn token — ngược mục đích chuyển đổi) và có thể giao trùng việc. Khuyến nghị: tính task open chưa gán là "có việc" cho cả 2 worker, và/hoặc bỏ qua idle-wake cho agent đang có task blocked trong cùng lượt.

### F-4 [TRUNG BÌNH-THẤP] Mất/hỏng state → sót blocked đã tồn tại
- Điều kiện (d) chỉ so với snapshot cũ; state mất/hỏng (T8) thì baseline ghi lại từ hiện trạng → task đang blocked sẵn sẽ không bao giờ wake cho tới khi đổi trạng thái lần nữa. Chỉ còn lượt 06:46 bắt. Tương tự episode idle bị đặt lại → có thể wake idle trùng 1 lần (ồn, không nguy hiểm).
- Khuyến nghị: khi baseline (không có state cũ) mà thấy task blocked tồn tại, wake 1 lần "blocked chưa phân loại (baseline)" thay vì silent tuyệt đối — trừ lần cài đặt đầu tiên có chủ đích.

## 3. Watch hook (`scripts/watch-tasks.sh`) — đối chiếu

- Dry-run với đúng tham số (`muse-1 ~/muse-teamwork <state /tmp>`): PASS, silent baseline, tasks_seen=87.
- **F-5 [THẤP] Mặc định repo-dir là `~/workspace/muse-teamwork`** — trên máy muse-1 repo nằm ở `~/muse-teamwork` nên chạy không tham số sẽ ls-remote fail → silent mãi. Wrapper live phải truyền đúng đường dẫn; nên sửa mặc định hoặc ghi rõ trong sổ hook. (Watchdog script cũng mặc định `~/workspace/muse-teamwork` — cùng ghi chú.)

## 4. Lỗ hổng chung / vận hành

- **F-6 [THẤP] Ghi state không atomic, không lock.** Cả 2 gate dùng `open(path,"w")` trực tiếp, không `os.replace`/flock. Crash giữa lúc ghi → JSON hỏng → inbox wake lại ồn (an toàn), watchdog baseline lại (xem F-4). Poll 300s và script chạy <60s nên chồng lượt khó xảy ra; vẫn nên ghi tmp + rename.
- **F-7 [THẤP] Race 2 hook cùng wake muse-main** (watch cho review + watchdog cho hết hạn/blocked/idle). Không có lock phiên; 2 phiên agent có thể chạy song song trên muse-main. Git push có pull --rebase và cấm force-push nên hậu quả giới hạn ở xung đột push phải làm lại, không mất dữ liệu. Ghi nhận, chưa cần sửa ngay.
- **F-8 [THẤP] Đồng hồ máy.** Hết hạn claim tính theo giờ máy muse-main; lệch giờ hệ thống làm wake sớm/muộn tương ứng. Không có kiểm tra NTP trong gate. Rủi ro thấp nếu VM đồng bộ giờ chuẩn.
- **Rate-limit tổng thể:** inbox 12 req/h (auth 5000/h) — PASS nếu auth còn sống (F-1). Watchdog + watch: ls-remote 5 phút/lần qua giao thức git (không tính REST quota), fetch chỉ khi SHA đổi — PASS. Không còn đường curl unauth nào trong 2 script mới.
- **Doc drift [THẤP]:** README §2 vẫn ghi "API GitHub public (không cần auth)" trong khi script đã dùng `gh api` có auth; README ghi QA là "Task 156" (thực tế 157; 156 là task SEO của muse-2); header watchdog ghi lưới an toàn "06:00" trong khi README/task ghi 06:46. Nên sửa cho khớp để người sau không hiểu sai.

## 5. Lưới an toàn 06:46

- Theo README: kiểm tra 3 hook còn đăng ký + enabled, backup inbox (issue tồn >24h thì apply), sửa lệch STATUS.md, sweep hết hạn, review/merge, quản lý §10. Đủ phủ các đường wake của 2 gate **nếu lượt 06:46 tự nó còn chạy**.
- Điểm mù: (1) hook chết im chỉ bị phát hiện ở lượt 06:46 kế tiếp → chậm tối đa ~24h (lệnh dashboard, phân loại blocked, giao task học). Riêng hết hạn claim còn được poll 15 phút của muse-1/muse-2 sweep độc lập (script sweep-expired.sh) nên không phụ thuộc hoàn toàn vào watchdog hook — đây là lớp đỡ thật, đã chạy trong lượt poll này. (2) Nếu cron 06:46 chết theo, không có lớp thứ hai (không có dead-man's switch). (3) Lượt 06:46 hiện không có mục kiểm tra `gh auth` (F-1).
- Trạng thái live "3 hook enabled 300s, cron watchdog daily 06:46, cron inbox đã xóa": **UNVERIFIED trực tiếp từ muse-1** — đối chiếu snapshot trong task 157, cần muse-main xác nhận lại bằng hooks.list/cron.list khi review.

## 6. Khuyến nghị ưu tiên

1. Muse-main xác nhận live: `gh auth status`, hooks.list (3 hook enabled, poll 300s), cron.list (inbox đã xóa, watchdog 06:46) — ghi kết quả vào task khi review để đóng phần UNVERIFIED.
2. Sửa F-3 (idle-wake): tính open chưa gán là có việc; không idle-wake agent đang có blocked cùng lượt.
3. Thêm kiểm tra gh auth vào lượt 06:46; cân nhắc wake báo lỗi sau N lần gh fail liên tiếp (F-1).
4. Sửa doc drift (README §2 auth, số task QA 157, giờ 06:46 thống nhất) và mặc định repo-dir (F-5).
5. Khi tiện: ghi state atomic (tmp+rename), baseline có blocked thì wake 1 lần (F-4/F-6).

## Nguồn kiểm chứng độc lập

Code trong repo `qsang2025/muse-teamwork` tại thời điểm QA (hooks/*.sh, scripts/watch-tasks.sh, hooks/README.md, PROTOCOL.md); dry-run thật trên máy muse-1 (DRY=1); test tổng hợp repo giả + gh giả trong /tmp (không đụng state live, không tạo issue thật). Không dùng kết luận sẵn của muse-main làm bằng chứng — mọi mục PASS/FAIL ở trên đều có test hoặc trích code tương ứng.
