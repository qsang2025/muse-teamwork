# QA độc lập: kiểm chứng chuyển đổi hook tiết kiệm token (inbox + watchdog) — task 157

- **Task:** 157-qa-doc-lap-kiem-chung-chuyen-doi-hook-ti (research, repo muse-teamwork)
- **Người QA:** muse-1 (Ú) — độc lập với người viết script (muse-main), theo giao việc của Anh 21/11 01:46
- **Ngày QA:** 21/11/2026 (claim 01:56 +07, hạn claim 03:56 +07)
- **Đối tượng kiểm chứng:** `hooks/muse-teamwork-inbox.sh` (139 dòng), `hooks/muse-teamwork-watchdog.sh` (253 dòng), `hooks/README.md` (67 dòng) trên `origin/main` tại thời điểm QA; đối chiếu `scripts/watch-tasks.sh`, `scripts/apply-dashboard-issues.py`, `scripts/sweep-expired.sh`, `scripts/verify-spec.sh`, PROTOCOL §4/§7/§10.
- **Kết luận tổng:** hướng chuyển đổi ĐÚNG (script rẻ quét trước, chỉ wake agent khi có việc thật), logic wake chính chạy đúng qua test dữ liệu giả, sửa rate-limit bằng `gh api` có cơ sở. Nhưng có **1 lỗi mức cao** (lần chạy đầu/state mất nuốt mất cảnh báo idle + blocked) và **2 nhóm mức trung bình** (blocked/idle chỉ wake 1 lần không wake lại; inbox phụ thuộc `gh` auth mà lỗi thì im lặng vĩnh viễn) cần muse-main sửa trước khi coi hook là đường nhanh đáng tin duy nhất. Lưới an toàn 06:46 vẫn là đường đúng đắn cuối cùng, không bỏ được.

## Phạm vi và giới hạn kiểm chứng (đọc trước)

- **Kiểm chứng trực tiếp được trên máy muse-1:** toàn bộ logic 2 script gate trong repo (đọc code + chạy dry-run + test end-to-end bằng repo/state giả trong `/tmp/qa157`, không đụng state live, không tạo issue thật); định nghĩa hook `muse-teamwork-watch-muse-1` trên máy này (enabled, poll 300s, timeout 600s — khớp snapshot trong task); trạng thái task live trên `origin/main` (đếm snapshot, hạn claim).
- **KHÔNG kiểm chứng trực tiếp được (chỉ đối chiếu snapshot muse-main ghi trong task, flag rõ là chưa xác thực):** định nghĩa live của hook inbox + watchdog trên máy muse-main (prompt worker, enabled, poll, timeout, delivery); file state live `~/hooks/state/muse-teamwork-{inbox,watchdog}.json`; cron watchdog daily 06:46:40 còn tồn tại/enabled và prompt của nó có thật sự kiểm tra sức khỏe hook + backup inbox + sửa STATUS.md hay không; cron inbox 15 phút đã xóa thật chưa; `gh` trên máy muse-main có auth ổn định trong môi trường hook (PATH/HOME/token) hay không; mức tiết kiệm token thực tế (không có số liệu usage để đối chiếu, chỉ kiểm chứng được cơ chế).
- Mọi test giả đều chạy với `HOME` giả / state file trong `/tmp` / repo git giả có origin bare riêng. Không sửa script gate trong task này (QA độc lập chỉ báo cáo; sửa là việc của muse-main sau review).

## Phương pháp

1. Đọc kỹ 2 script + README, đối chiếu điều kiện wake với PROTOCOL §7 (watcher 5 phút, cấm quét 1 phút) và §10 (watchdog 2h cũ: rảnh → giao tự học, blocked → phân loại, việc của muse-main thì làm ngay).
2. Chạy dry-run thật: inbox (máy muse-1) và watchdog (repo thật `~/muse-teamwork`, state tạm trong `/tmp`).
3. Test đường wake bằng dữ liệu giả: inbox qua `gh` giả (shim trong PATH trả JSON giả) + `HOME` giả; watchdog qua repo git giả (commit task giả, push lên origin bare, chạy script nhiều lượt để kiểm tra dedup/rewake/baseline).
4. Kiểm tra rate-limit: gọi `GET /rate_limit` không auth từ IP egress hiện tại; kiểm tra `gh` auth trên máy muse-1.
5. Đối chiếu snapshot live: đếm task trên `origin/main`, kiểm tra task đang mở/claimed và hạn claim.

## Kết quả inbox (`hooks/muse-teamwork-inbox.sh`)

| # | Trường hợp test | Kỳ vọng | Kết quả |
|---|---|---|---|
| I1 | Issue `[dashboard]` mới, chưa có state | WAKE + ghi `last_wake` | **PASS** — wake đúng số issue, state ghi giờ UTC |
| I2 | Cùng issue, đã wake < 2h | SILENT, giữ `last_wake` cũ | **PASS** |
| I3 | Cùng issue, đã wake 3h trước | WAKE lại (rewake 2h) | **PASS** |
| I4 | Issue đã đóng (không còn trong danh sách open) | SILENT + xóa khỏi state | **PASS** — state dọn về rỗng |
| I5 | PR mang tiêu đề `[dashboard]` + issue thường | SILENT (loại PR, lọc tiêu đề) | **PASS** |
| I6 | Tiêu đề `  [Dashboard] ...` (khoảng trắng + hoa/thường) | WAKE (strip + lower) | **PASS** — khớp bộ lọc của worker `apply-dashboard-issues.py` (cùng strip/lower/startswith) |
| I7 | State file hỏng (không phải JSON) | WAKE (hướng an toàn: thà wake thừa) | **PASS** — coi như state rỗng, wake lại |
| I8 | JSON issue hỏng | SILENT, không ghi state | **PASS** |
| I9 | Dry-run `HATCH_HOOK_DRY_RUN=1` | Quyết định wake nhưng KHÔNG ghi state | **PASS** — không tạo state file |
| I10 | Tiêu đề `[dashboard]` không có số task (worker cần regex số) | Gate vẫn wake, worker tự đóng/từ chối | **PASS có ghi chú** — wake thừa 1 lượt agent cho issue rác; worker có đóng issue không hợp lệ nên không lặp vô hạn |
| I11 | Hơn 100 issue open, issue dashboard nằm ngoài trang đầu | Phải thấy được | **FAIL (thấp)** — cả gate lẫn worker đều gọi 1 lần `per_page=100`, không `--paginate`; issue ngoài 100 đầu vô hình cho tới khi issue cũ đóng bớt. Hiện repo ít issue open nên chưa đau, nhưng là lỗ thật |
| I12 | `gh api` lỗi (máy muse-1: `gh` chưa auth, không có `~/.config/gh`, không `GH_TOKEN`) | Phải phân biệt được "lỗi" với "không có issue" | **FAIL (trung bình)** — script log + SILENT, giống hệt trường hợp không có issue. Trên muse-1 dry-run thật cho SILENT vì `gh` lỗi. Nếu trên muse-main `gh` mất auth / PATH hook thiếu `gh` / token hết hạn, inbox chết im vĩnh viễn, chỉ lượt 06:46 (nếu có chạy dry-run kiểm tra) mới phát hiện. Script cũng không có `timeout` quanh `gh api` (watchdog có timeout 30/60 cho git) — `gh` treo thì script treo tới timeout của hook |

**Rate-limit — phát hiện đã biết của muse-main: XÁC NHẬN đúng hướng sửa.** Gọi không auth từ IP egress hiện tại trả `X-RateLimit-Limit: 60`, còn 52/60 tại thời điểm đo (IP proxy dùng chung, số còn lại dao động theo người dùng khác). Inbox quét 12 req/h nếu dùng curl không auth sẽ ăn 20% ngân sách chung 60/h — bị 403 như muse-main gặp (58/60) là hoàn toàn plausibly. Đổi sang `gh api` có auth (5000 req/h) là sửa đúng. Phần chưa xác thực được: `gh` có chạy ổn định trong môi trường hook trên muse-main hay không (xem I12) và còn đường rate-limit nào khác không — `git ls-remote`/`fetch` của watchdog + watch không đi qua REST API nên không chung ngân sách 60/h này; 3 hook × 12 lượt/h là nhẹ.

## Kết quả watchdog (`hooks/muse-teamwork-watchdog.sh`)

| # | Trường hợp test | Kỳ vọng | Kết quả |
|---|---|---|---|
| W0 | Lần chạy đầu, 2 worker đều bận | SILENT baseline, ghi snapshot | **PASS** — `tasks_seen` khớp đếm độc lập (repo thật: 88 file JSON − 1 template = 87) |
| W1 | Task claimed/doing quá `claim_expires_at` | WAKE expired | **PASS** |
| W1b | Cùng task hết hạn, chạy lại ngay (SHA không đổi, cached) | SILENT (đã alert < 2h) | **PASS** — dedup theo `expires_at` + giờ alert |
| W2 | Task mới chuyển blocked | WAKE blocked | **PASS có ghi chú** — đồng thời wake thêm idle cho chính worker đó (blocked không tính là "đang có task mở" nên worker bị coi là rảnh). Đúng chữ spec §10(a) nhưng muse-main nhận 2 việc cùng lúc: nên phân loại blocked trước, đừng giao tự học ngay khi task blocked đang chờ quyết |
| W2b | Blocked giữ nguyên, chạy lại | (Thiết kế hiện tại: SILENT) | **FAIL (trung bình)** — blocked KHÔNG có rewake. Lượt wake đầu mà worker lỗi/crash thì blocked không bao giờ được báo lại, chỉ còn lượt 06:46 trong vòng 24h |
| W3 | Task vào review | KHÔNG wake (watch hook đã gọi muse-main) | **PASS** — điểm quan trọng nhất để tránh 2 agent cùng merge; review vẫn tính là "bận" cho idle nên không wake idle oan |
| W4 | Cả muse-1 + muse-2 hết task mở | WAKE idle ×2, kèm `last_done_task` | **PASS** |
| W4b | Idle giữ nguyên episode, chạy lại | (Thiết kế: SILENT 1 lần/episode) | **FAIL (trung bình)** — giống W2b: muse-main lỗi không tạo được task tự học thì idle không báo lại cho tới khi có task done mới đổi episode, hoặc lượt 06:46 |
| W5 | Có task open chưa gán ai (không assignee, không preferred) | Worker coi như có việc claim được | **FAIL (trung bình-thấp)** — busy chỉ tính assignee/preferred bằng agent; task open vô chủ không tính bận cho ai → vẫn wake idle đòi giao tự học trong khi task claim được đang nằm đó. Đối chiếu watch hook: `mine()` cũng chỉ wake khi assignee/preferred khớp agent → task open vô chủ không wake ai cả. Hiện muse-main luôn đặt preferred khi tạo task (155/156/157 đều có) nên ít xảy ra, nhưng hook instruction của muse-1 cho phép claim task vô chủ mà không hook nào đánh thức vì nó |
| W6 | **State mất/mới (lần chạy đầu) khi worker đang idle** | Phải wake idle (hoặc ít nhất không đánh dấu đã alert) | **FAIL (CAO)** — baseline SILENT nhưng vẫn ghi `idle_alerted` như đã alert; lượt sau SILENT vĩnh viễn cho episode đó. Tức là: cài hook mới, thay VM mất state, hay state hỏng → idle (và blocked có sẵn từ trước, cùng cơ chế snapshot) bị nuốt mất, chỉ expired mới thoát baseline. Đã tái hiện: state mới + idle → silent, `idle_alerted={muse-1: 006-f, muse-2: 002-b}`, lượt 2 vẫn silent |
| W7 | Lần chạy đầu nhưng có task hết hạn thật | WAKE expired (ngoại lệ baseline) | **PASS** |
| W8 | Expired đã alert 3h trước, vẫn hết hạn | WAKE lại (rewake 2h) | **PASS** — kể cả ở chế độ cached SHA không đổi |
| W9 | State file hỏng | Không crash, tự hồi phục | **PASS có ghi chú** — không crash, ghi lại JSON hợp lệ, expired vẫn wake; nhưng idle/blocked rơi vào đúng lỗi W6 |
| W10 | `claim_expires_at` dạng UTC `Z`, dạng `+07:00`, dạng naive không tz | Parse đúng, so sánh đúng với giờ hiện tại | **PASS cả 3** — naive được hiểu là +07 (khớp claim-task.sh ghi +07:00); không thấy lệch clock trong logic |
| W11 | 12 task blocked cùng lúc | Báo đủ 12 | **FAIL (thấp)** — payload bị cắt ở 10 (`wakes[:10]`), 2 task cuối + wake idle bị rớt nhưng state vẫn đánh dấu đã alert → mất vĩnh viễn. Xác suất 12 blocked cùng lúc thấp, nhưng cơ chế "cắt payload mà vẫn ghi đã alert" là sai nguyên tắc |

## Kiểm tra chéo

- **Race 2 hook cùng dậy:** inbox dùng API (không đụng git), watchdog + watch cùng `git fetch origin main` trên cùng clone muse-main (giả định wrapper trỏ cùng repo — chưa xác thực được wrapper live). Chạy 2 `git fetch` song song trên repo giả: cả hai exit 0. Trường hợp xấu nhất là 1 lượt fetch lỗi → SILENT → lượt poll sau tự lành. State file của 3 hook tách riêng nên không ghi đè nhau. **PASS (rủi ro thấp, tự lành).** Còn lại: không thấy khóa chống 2 lượt cùng 1 hook chạy chồng nhau nếu script chạy quá 300s (watchdog đọc từng file bằng `git show`, repo thật 87 task vẫn nhanh; timeout hook của inbox/watchdog live chưa xem được).
- **State file hỏng/mất:** cả hai script đều không crash (inbox → wake thừa hướng an toàn; watchdog → baseline). Nhưng ghi state không nguyên tử (`open(..., "w")` ghi thẳng) — chết giữa lúc ghi là hỏng JSON; hậu quả đã nêu ở W6/W9. Nên ghi tmp + rename.
- **Clock lệch:** inbox dùng UTC nhất quán (ghi `Z`, parse `Z`/naive-as-UTC); watchdog parse `+07:00`/`Z`/naive-as-+07 rồi so với UTC now — đúng. Không phát hiện lỗi tz. **PASS.**
- **Đường dẫn mặc định:** watchdog (và watch-tasks.sh) mặc định repo `$HOME/workspace/muse-teamwork` — đường dẫn này KHÔNG tồn tại trên muse-1 (repo ở `~/muse-teamwork`). Nếu wrapper live trên muse-main không truyền tham số repo đúng, watchdog sẽ `ls-remote` lỗi → SILENT vĩnh viễn. Chưa xác thực được wrapper live → **flag cần muse-main xác nhận wrapper truyền đúng repo dir** (dry-run QA phải truyền tay `~/muse-teamwork` mới chạy).
- **Tài liệu lệch code:** README §2 + header inbox vẫn ghi "API public không cần auth" trong khi code đã dùng `gh` auth; README mục QA ghi "Task 156 giao muse-1" (thực tế QA là 157, 156 là Ahrefs giao muse-2); header watchdog ghi lượt quét ngày "06:00" trong khi README/task ghi 06:46. **FAIL (thấp)** — sửa tài liệu để người sau không tin sai.
- **Tương tác với task 155 (live, cần chú ý ngay):** trên `origin/main`, 155 vẫn `claimed` muse-1 hết hạn 03:25 21/11 trong khi việc đã xong ở branch `feature/155-...` (review trên branch, chờ merge). Nếu muse-main chưa merge trước 03:25, watchdog sẽ wake "expired needs sweep" và `sweep-expired.sh` sẽ trả 155 về open trên main dù branch đã có báo cáo xong. Worker xử lý wake expired phải kiểm tra branch trước khi sweep. Đây không phải lỗi của script gate (nó chỉ đọc main, đúng thiết kế) nhưng là rủi ro vận hành có deadline cụ thể.
- **Lưới an toàn 06:46:** theo README, lượt ngày kiểm tra 3 hook còn enabled (thiếu thì cài lại), backup inbox quá 24h, sửa lệch STATUS.md, sweep, review/merge, quản lý §10. QA xác nhận được: `verify-spec.sh` chỉ BÁO drift chứ không tự sửa (việc sửa do agent của lượt 06:46 làm — prompt đó nằm trên muse-main, chưa xem được). Đánh giá: lưới đủ rộng để bắt mọi lỗi mất wake ở trên trong vòng ≤24h, và README thừa nhận đúng giới hạn đó ("hook chết im thì lượt 06:46 bắt trong 24h"). Nhưng cần nói thẳng: với các lỗi W2b/W4b/W6/W11, độ trễ thực tế khi worker lỗi là tới 24h chứ không phải 2–3 phút như hook hứa. Và nếu chính cron 06:46 chết thì không còn lưới nào nữa — nên lượt 06:46 cần tự kiểm tra `gh` + dry-run 2 gate và báo rõ khi gate lỗi (hiện lỗi gate = silent, không phân biệt được với "không có việc").

## Danh sách phát hiện xếp theo mức độ (đề xuất sửa, muse-main quyết)

1. **CAO — W6: baseline nuốt idle/blocked.** Sửa: lần chạy đầu cũng wake idle + blocked như expired, hoặc không ghi `idle_alerted`/snapshot-blocked như đã alert khi chưa wake. Ít nhất phải có 1 trong 2, nếu không mỗi lần mất state là mất cảnh báo.
2. **TRUNG BÌNH — W2b/W4b: blocked + idle không có rewake.** Sửa: thêm rewake 2h như expired/inbox, hoặc ghi rõ trong PROTOCOL rằng blocked/idle chấp nhận trễ tới lượt 06:46 khi lượt wake đầu lỗi.
3. **TRUNG BÌNH — I12: inbox chết im khi `gh` lỗi + thiếu timeout.** Sửa: `timeout 30 gh api ...`; lượt 06:46 chạy dry-run inbox và coi `gh` lỗi là sự cố phải báo, không phải silent bình thường; xác nhận `gh` auth + PATH trong môi trường hook trên muse-main.
4. **TRUNG BÌNH-THẤP — W5: task open vô chủ bị orphan.** Sửa: watchdog tính task open vô chủ là "có việc" (đừng wake idle đòi tự học), và/hoặc watch wake muse-main khi có task open vô chủ mới để gán người.
5. **THẤP — W11: cắt payload 10 mà vẫn đánh dấu đã alert.** Sửa: chỉ đánh dấu alert cho wake thật sự đã gửi, phần dư để lượt sau.
6. **THẤP — I11: phân trang issue.** Sửa: `gh api --paginate` ở cả gate lẫn `apply-dashboard-issues.py`.
7. **THẤP — ghi state không nguyên tử + tài liệu lệch (auth/156-vs-157/06:00-vs-06:46).** Sửa: tmp+rename; đồng bộ README/header với code.
8. **VẬN HÀNH — merge 155 trước 03:25 21/11** hoặc dặn worker sweep kiểm tra branch review trước khi trả task về open.

## Nguồn kiểm chứng độc lập (theo PROTOCOL §4)

Mọi kết luận trên dựa trên: đọc trực tiếp 2 script gate + README trong repo tại `origin/main` hiện tại; chạy dry-run thật trên máy muse-1; test end-to-end bằng `gh` giả + repo git giả + state giả trong `/tmp/qa157` (11 ca inbox I1–I12 tính cả dry-run, 12 ca watchdog W0–W11); đo `X-RateLimit` không auth từ IP egress hiện tại (60/h, còn 52); đếm độc lập snapshot `origin/main` (88 JSON − 1 template = 87, khớp `tasks_seen` của watchdog); đối chiếu bộ lọc của `apply-dashboard-issues.py` và `mine()` của `watch-tasks.sh`. Không dựa vào kết luận sẵn của muse-main ngoài snapshot trạng thái live đã flag là chưa xác thực ở mục Phạm vi.
