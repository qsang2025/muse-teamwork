# BUILD-REPORT.md — Nhật ký build repo muse-teamwork

Build xong ngày **2026-11-16 ~21:45** (giờ Việt Nam), tại `~/workspace/muse-teamwork/`.
**CHƯA push GitHub** — để Muse chính tạo repo `qsang2025/muse-teamwork` và push sau.

## 1. File đã tạo (19 file — không tính chính BUILD-REPORT.md)

Cách đếm (chạy ngày 2026-11-16 sau khi sửa lỗi L1–L11): `find . -type f ! -name BUILD-REPORT.md | wc -l` = **19**; tính cả BUILD-REPORT thì tổng là **20 file**. `hub/data/` không tính (nằm trong `.gitignore`, chỉ chứa dữ liệu test tạm và đã dọn sạch).

| File | Nội dung |
|---|---|
| `README.md` | Tổng quan 1 trang: vấn đề, nguyên tắc, sơ đồ luồng, bảng agents, kết quả probe |
| `agents.yaml` | Registry 3 agents (IP, vai trò, năng lực, trạng thái) |
| `PROTOCOL.md` | Vòng đời task, claim 2h, chống trùng, merge, báo cáo |
| `tasks/_template.json` | Schema task mẫu |
| `tasks/README.md` | Hướng dẫn dùng thư mục tasks |
| `tasks/087-novelnext-retest.json` | Task thật: retest 1 chương novelnext.me (open, chưa gán) |
| `tasks/088-fork-rescan-13.json` | Task thật: rescan fork lần 13 (open, chưa gán) |
| `hub/server.js` | Hub live Node không dependencies, port 8787 |
| `hub/client.js` | Client poll/claim/heartbeat/complete + fallback GitHub |
| `hub/client.sh` | Vỏ bọc ngắn cho client.js (biến HUB, AGENT) |
| `hub/test-local.sh` | Test hub trên loopback |
| `scripts/new-task.sh` | Tạo task mới (tự sinh id + slug tiếng Việt) |
| `scripts/claim-task.sh` | Claim task (đổi status, ghi hạn 2h, commit + push) |
| `docs/START-MUSE-1.md` | Tin nhắn copy-paste cho muse-1 (26 dòng) |
| `docs/START-MUSE-2.md` | Tin nhắn copy-paste cho muse-2 (26 dòng) |
| `docs/SETUP-HUB.md` | 3 phương án host hub (A/B/C) + cách kiểm tra bằng curl |
| `.gitignore`, `LICENSE` (MIT, Dương Nguyễn Quốc Sáng 2026), `CONTRIBUTING.md` | Chuẩn repo |

Không có password/token/key nào trong repo. Không sửa gì ngoài
`~/workspace/muse-teamwork/`.

## 2. Kết quả probe Tailscale (2026-11-16 ~21:44)

- Probe HTTP qua Tailscale proxy port 3130 tới **muse-1 (100.85.79.92)** và
  **muse-2 (100.126.2.102)** ở các cổng **80, 8080, 18080, 3000** đều
  **timeout 5s, code 000** — không có service nào trả lời.
- Kết luận: hiện 2 bạn **không host sẵn service nào** để gọi thẳng.
- Hệ quả đã ghi vào repo: **phương án A (GitHub-only) là phương án dùng được
  ngay**, không chờ ai mở cổng (README.md, docs/SETUP-HUB.md, agents.yaml).
  Phương án B (hub Tailscale) chỉ chạy được SAU KHI một trong 2 bạn (hoặc Anh)
  chạy `node hub/server.js` trên máy của mình và mở port 8787 — kèm lệnh kiểm
  tra lại bằng curl qua proxy trong `docs/SETUP-HUB.md`.

## 3. Tên repo — đã kiểm chứng bằng `gh api`

- `qsang2025/muse-teamwork`: **404 Not Found — chưa tồn tại, dùng được.**
- `qsang2025/muse-mesh`: **404 Not Found — chưa tồn tại.**
- Repo chưa được tạo, chưa push (theo brief, để Muse chính làm sau).

## 4. Kết quả test (đều PASS)

| Test | Kết quả |
|---|---|
| `node --check hub/server.js` | PASS |
| `node --check hub/client.js` | PASS |
| `python3 -m json.tool` cho 3 file `tasks/*.json` | PASS (template + 087 + 088) |
| `bash -n` cho 4 script shell | PASS |
| `./hub/test-local.sh` | PASS — /health, /tasks, claim → heartbeat → complete → review, dọn sạch |
| `hub/client.js` thật với hub local | PASS — poll thấy task 087; claim OK (muse-1); claim trùng bị 409 đúng như thiết kế; heartbeat đổi sang `doing`, gia hạn 2h |
| `scripts/new-task.sh` thật | PASS — tạo `089-test-build-extension-vi-du.json` hợp lệ, đã xóa file test sau đó |
| `scripts/claim-task.sh` end-to-end (repo git tạm trong /tmp, remote bare local) | PASS — claim 087 → muse-1, hết hạn +2h đúng giờ VN, commit + push OK; claim trùng bị từ chối, exit 3 |

### 2 lỗi phát hiện trong lúc test — đã sửa

1. **Slug tiếng Việt bị cắt sai:** `new-task.sh` bỏ dấu không đúng nên
   "ví dụ" thành "v-d". Đã sửa: dùng `unicodedata` bỏ dấu (đ→d, í→i...)
   trước khi slugify — test lại ra `089-test-build-extension-vi-du.json` đúng.
2. **claim-task.sh `git pull` lỗi khi branch chưa có upstream:** đã sửa —
   script tự `git branch --set-upstream-to=origin/<branch>` trước khi pull
   (clone thường đã có upstream sẵn, đây chỉ là phòng hờ).

Lưu ý nhỏ: hub lưu `claim_expires_at` theo giờ UTC (dạng `Z`), còn file task
GitHub dùng giờ Việt Nam (+07:00) — cả hai đều là ISO 8601 hợp lệ, không ảnh
hưởng logic hết hạn 2h.

## 5. Trạng thái cuối

- 2 task mẫu đều `status: "open"`, `assignee` trống — sẵn sàng để muse-1/muse-2 claim.
- Không còn tiến trình hub test nào chạy; `hub/data/` đã dọn sạch (thư mục này
  nằm trong `.gitignore`).
- Repo local chưa `git init` — để Muse chính tạo repo GitHub rồi init + push một lượt.

## 7. Sửa lỗi sau verified độc lập (L1–L11) — 2026-11-16 ~21:52

Team Verified kiểm chứng độc lập ngày 2026-11-16 ~21:47–21:50 (xem
`~/workspace/muse-teamwork-work/VERIFICATION-REPORT.md` §3–§4) và tìm ra 11 lỗi.
Team Sửa lỗi đã sửa hết trong `~/workspace/muse-teamwork/`, KHÔNG push GitHub.
Tên file task giữ nguyên (087/088), không đổi tên file.

| # | Lỗi | Cách sửa | Kiểm chứng lại |
|---|---|---|---|
| L1 NẶNG | `tasks/088-...json` notes gợi ý 4 host đã đóng/đã merge (idejian.com, zingtruyen.store, piaotian/lwxs/biqugezz) | Xoá hẳn cụm gợi ý; chỉ giữ "ưu tiên host MỚI sau 16/11 + kiểm tra ROADMAP mục đã đóng/đã merge trước khi liệt kê" | `grep -E "idejian\|zingtruyen\|lwxs\|biqugezz" tasks/088-...json` → không thấy gì (exit 1). Đối chiếu ROADMAP: idejian + zingtruyen ĐÓNG 15/11, lwxs MERGE 15/11 ~16:24, biqugezz MERGE 15/11 ~18:00 |
| L2 NẶNG | Mẫu grep `"status": "open"` không khớp JSON minified | Pretty-print cả 3 file `tasks/*.json` (indent 2 + newline cuối) | `grep -l '"status": "open"' tasks/*.json` → thấy đủ `087-novelnext-retest.json`, `088-fork-rescan-13.json` (+ `_template.json` là mẫu, status open là đúng vì nó là template) |
| L3 | `docs/SETUP-HUB.md:33` curl ghi cứng `-x http://127.0.0.1:3130` | Đổi sang `tunnel_proxy="${HTTPS_PROXY%:*}:3130"; curl -m 5 --proxy "$tunnel_proxy" ...` | Chạy thử cú pháp: curl exit 28 (timeout — chưa có hub trên muse-1:8787), không phải lỗi cú pháp; biến proxy được thay đúng từ HTTPS_PROXY |
| L4 | `README.md:92` ghi `node hub/client.js poll` thiếu tham số | Sửa thành `node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 poll` | Đọc lại README: lệnh đã đủ `--hub` + `--agent`; `grep "node hub/client.js poll"` trong repo → không còn chỗ nào thiếu tham số |
| L5 | BUILD-REPORT đếm "18 file" (sai) | Sửa thành **19 file (không tính BUILD-REPORT)**, ghi rõ cách đếm ở §1 | `find . -type f` = 20; `find . -type f ! -name BUILD-REPORT.md` = 19 |
| L6 | 3 JSON thiếu newline cuối file | Gộp với L2: pretty-print + newline cuối cho cả 3 file | `tail -c1` cả 3 file đều là `\n` |
| L7 | `hub/client.js` in fallback cả khi hub trả 409/403/404 | Chỉ in FALLBACK trong khối `catch` (lỗi kết nối/timeout); 409/403/404 chỉ in lỗi + gợi ý chọn task khác | Test thật trên hub loopback port 18787: claim trùng 409, heartbeat sai chủ 403, claim task không có 404 — cả 3 đều KHÔNG in fallback; tắt hub rồi poll thì CÓ in "Fallback về GitHub" |
| L8 | PLAN dùng id `T-001`/`T-002`, repo dùng `087-...`/`088-...` | Chốt chuẩn **`<số-roadmap>-<slug>`**, sửa PLAN.md §5.1, §5.3, §7, §8, §9 cho khớp; không đổi tên file task | `grep "T-00" PLAN.md` chỉ còn 1 chỗ — chính câu "(KHÔNG dùng dạng `T-001` nữa)" |
| L9 | `agents.yaml` cấp `device-test` cho cả muse-1/muse-2 | Gỡ khỏi capabilities của muse-1 và muse-2, ghi chú rõ chỉ muse-main device-test (PLAN §3) | `grep "device-test" agents.yaml` chỉ còn dòng của muse-main + 2 dòng ghi chú |
| L10 | PROTOCOL.md §2 bước 4 viết "task tự trở lại open" (sai với đường GitHub) | Sửa rõ: qua hub thì tự sweep về open; qua GitHub (đường chính) thì muse-main dọn claim hết hạn mỗi lần chia việc | Đọc lại PROTOCOL.md §2 bước 4 đã ghi đủ 2 đường |
| L11 | Mốc retest novelnext chênh nhau 3 phút giữa task 087 và PLAN §7 | Thống nhất thành **"tối 16/11"** trong task 087 (checklist + notes) và PLAN.md §7 | Grep mốc giờ cũ trong tasks/ + PLAN → không còn |

### Kết quả test chạy lại sau khi sửa (đều PASS, 2026-11-16 ~21:52)

| Test | Kết quả |
|---|---|
| `node --check hub/server.js` + `node --check hub/client.js` | PASS cả 2 |
| `python3 -m json.tool` cho 3 file `tasks/*.json` | PASS cả 3 |
| `bash -n` cho 4 script (`hub/client.sh`, `hub/test-local.sh`, `scripts/new-task.sh`, `scripts/claim-task.sh`) | PASS cả 4 |
| `./hub/test-local.sh` | PASS, exit 0 — /health ok, claim → heartbeat → complete → review, dọn sạch |
| `grep -l '"status": "open"' tasks/*.json` (L2) | Thấy đủ 087 + 088 (+ _template.json là mẫu) |
| `grep -E "idejian\|zingtruyen\|lwxs\|biqugezz" tasks/088-...json` (L1) | Không thấy gì |
| Test hành vi L7 trên hub loopback port 18787 | 409/403/404 không fallback; tắt hub → poll in fallback |
| L3: chạy thử 2 dòng curl mới trong SETUP-HUB.md | Cú pháp đúng; curl exit 28 timeout (chưa có hub thật trên muse-1:8787) |
| Không còn tiến trình hub test chạy; `hub/data/` đã dọn sạch | `ps` không thấy `server.js`; `hub/data/` trống |

## 7. Vá P0 "TOXIC UNPUSHED COMMIT" trong `scripts/claim-task.sh` (2026-11-16 ~22:25, branch `fix/claim-toxic-commit`, CHƯA push)

- **Lỗi (Antigravity review 22:19):** `git push` cuối script chạy dưới `set -e`
  mà không có rollback. Khi 2 agent cùng claim 1 task, agent đến sau bị remote
  từ chối push (exit 1) → bash dừng đột ngột, commit claim vẫn nằm ở local.
  Lần chạy sau, `git pull --rebase` cố rebase commit lỗi đè lên commit của
  agent kia → hard merge conflict + treo rebase, tê liệt quy trình.
- **Cách vá (chỉ sửa `scripts/claim-task.sh`):** vòng lặp tối đa 3 lần — mỗi lần
  `git pull --rebase` lại trạng thái mới nhất → kiểm tra task còn open (python
  trả 3 = đã có người nhận → dừng ngay, exit 3) → commit `claim: <id> -> <agent>`
  → push. Push thất bại → `git reset --hard HEAD~1` rollback commit local ngay,
  rồi thử lại sau 2 giây. Hết 3 lần vẫn fail → exit 1, local sạch. Giữ nguyên:
  kiểm tra status open/assignee trống, `claimed_at`/`claim_expires_at` +07:00,
  commit message, mọi thông báo cũ.
- **Kiểm chứng thực nghiệm (remote bare local trong `/tmp/mt-claim-test/`,
  KHÔNG động vào origin thật):** Test 1 — pre-push hook luôn reject: 3 lần
  push fail đều rollback, exit 1, `git log` không có commit claim, `git status`
  sạch, task vẫn open. Test 2 — race thật (B kẹt 8s ở pre-push, A claim + push
  trước): B push bị reject → rollback → thử lại → thấy task claimed bởi muse-1
  → dừng exit 3, local B sạch. Test 3 — claim bình thường 1 agent: exit 0,
  status claimed, assignee muse-1, `claimed_at`/`claim_expires_at` +07:00 cách
  nhau đúng 2h, commit đã lên origin test. Cả 3 PASS.
- **Rủi ro khác phát hiện (ngoài phạm vi vá, chỉ ghi nhận):** `git pull --rebase`
  ở đầu mỗi lần thử vẫn có thể kẹt nếu working tree bẩn vì lý do khác (file
  task bị sửa tay, hoặc agent đang có commit chưa push khác) — lúc đó script
  exit 1 với thông báo "git pull lỗi" và commit claim chưa tạo nên không để lại
  rác, nhưng agent phải tự dọn working tree. Ngoài ra nếu `git push` fail vì
  mất mạng cả 3 lần thì task vẫn open (an toàn), agent chỉ cần chạy lại.

## 6. Còn cần Anh quyết (2 điểm)

1. **Tên repo chốt chưa?** Đề xuất `qsang2025/muse-teamwork` (đã kiểm chứng chưa
   tồn tại, dùng được). Tên dự phòng `muse-mesh` cũng còn trống. Anh chốt tên
   nào thì Muse chính tạo repo đúng tên đó rồi push.
2. **Chọn máy nào host hub (phương án B)?** Hiện chưa máy nào mở được port 8787
   (probe đều timeout). Lựa chọn: (a) cứ dùng phương án A GitHub-only trước,
   khỏi cần host; (b) nhờ muse-1 hoặc muse-2 chạy `node hub/server.js` trên máy
   của bạn ấy rồi kiểm tra lại bằng curl; (c) chạy hub trên PC Windows của Anh
   nếu có máy luôn bật. Nếu Anh chọn (a) thì không cần làm gì thêm — repo dùng
   được ngay sau khi push.

## 8. Vá P0 F-04 "Split-Brain hub ↔ GitHub" (2026-11-17 ~08:30, branch `fix/hub-2027-f04`, CHƯA push)

- **Lỗi (Antigravity review qsang2027, Turn 4):** `hub/server.js` đọc/ghi
  `hub/data/tasks.json` — file riêng, còn bị `.gitignore` bỏ qua, tách rời
  hoàn toàn với `tasks/*.json` trên GitHub: claim trên hub không thấy trên
  GitHub và ngược lại. Thêm 2 lỗi kèm: POST `/heartbeat` và POST `/complete`
  quên gọi `sweepExpired` (task quá hạn 2h không được thu hồi khi dùng hub),
  và `hub/client.js` lệnh `complete` không gửi `result` nên hub làm rơi kết
  quả test/validate/device-test.
- **Cách vá (đồng bộ đầy đủ, không chọn phương án tối thiểu "hub chỉ đọc"):**
  `tasks/*.json` là nguồn thật duy nhất.
  - `hub/server.js`: đọc/ghi trực tiếp `tasks/<id>.json` (bỏ `_template.json`
    vì là mẫu, không phải task); ghi file kiểu atomic (file tạm + rename);
    giờ `claimed_at`/`claim_expires_at` theo +07:00 như `scripts/claim-task.sh`.
    Trước mỗi lần đổi trạng thái: `git pull --rebase --autostash`, rồi
    `sweepExpired` (cả `/heartbeat` và `/complete` đều gọi — trước đây quên),
    rồi mới đổi + commit + push (`git add tasks/`, commit
    `hub: <hành động> <id>`, push). Push lỗi → `git reset --hard HEAD~1`
    rollback commit local (giống cách vá P0 trong `scripts/claim-task.sh`)
    + khôi phục nội dung file, trả 503 để agent fallback về GitHub-only.
    Pull lỗi cũng trả 503, không ghi state riêng rồi im lặng. GET `/tasks`
    pull định kỳ (throttle 60s, lỗi thì dùng trạng thái local). Thêm biến
    `TASKS_DIR` (mặc định `tasks/` cạnh `hub/`) và `HUB_GIT_SYNC=0` (tắt sync,
    chỉ dùng để test). `hub/data/tasks.json` không còn được đọc/ghi.
  - `hub/client.js`: lệnh `complete` nhận thêm `--branch/--notes/--validate/
    --device-test/--install` hoặc `--result-json '<json>'` để gửi đủ `result`;
    server merge sâu 1 cấp cho `test` (chỉ gửi `validate` thì
    `device_test`/`install` đã có vẫn giữ).
  - `hub/test-local.sh`: viết lại thành bộ kiểm chứng đầy đủ, chạy hoàn toàn
    trong `/tmp` với remote bare local + 2 clone (host chạy hub, client kênh
    GitHub-only), không động origin thật hay repo thật.
  - `docs/SETUP-HUB.md`: ghi rõ hub lưu ở `tasks/*.json` + auto-sync, và
    cách xử lý khi hub trả 503.
- **Kiểm chứng thực nghiệm (`./hub/test-local.sh`, 16/16 PASS, exit 0):**
  (a) test-local.sh PASS — /health, /tasks thấy 087+088 open, không liệt kê
  `_template`; (b) claim 087 qua API → file `tasks/087-...json` đổi đúng
  `claimed`/`muse-1`/`claimed_at`+`claim_expires_at` +07:00, đã push lên
  remote (clone B pull thấy ngay); (c) heartbeat đổi sang `doing` + gia hạn,
  complete qua `client.js` ghi đủ `result` (branch, notes, test validate/
  device_test/install) vào file và lên remote; (d) task 088 claimed quá hạn
  → gọi `/heartbeat` trả 409, file về `open`; (e) claim 088 qua hub rồi
  `scripts/claim-task.sh` claim lại → từ chối đúng, exit 3, clone B sạch
  không commit rác. Lỗi gặp lúc test (đã sửa trong script test, không phải
  lỗi hub): clone B checkout `main` bị abort vì copy `claim-task.sh` vào
  trước, và grep `"ok":true` không khớp JSON pretty-print của client.js.
- **Lưu ý:** làm trong worktree riêng `/tmp/mt-hub-f04` (branch
  `fix/hub-2027-f04` từ main 705c625) vì checkout chính đang ở branch
  `fix/claim-2027-f02-f03` của agent khác (đang sửa `scripts/claim-task.sh`,
  có thay đổi chưa commit) — không động vào file của nhau. `.gitignore` vẫn
  giữ dòng `hub/data/` (thư mục không còn dùng, không cần xóa gấp). Trong lúc
  làm, main đã có thêm merge F-02/F-03 (cd1b8db) — branch này không sửa
  `scripts/` hay `tasks/` nên merge sau không xung đột.
