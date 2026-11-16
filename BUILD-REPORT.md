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
