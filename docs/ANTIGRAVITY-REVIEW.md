# Gói bàn giao — Nhờ Antigravity kiểm chứng repo muse-teamwork

- Ngày gửi: 2026-11-16 (21:56, giờ Việt Nam)
- Chủ repo: Anh Dương Nguyễn Quốc Sáng
- Repo cần review: https://github.com/qsang2025/muse-teamwork
- Main đã push: `cc4a96d`, 20 file, public, MIT
- File này: `docs/ANTIGRAVITY-REVIEW.md` — đọc 1 file này là đủ hiểu hết.
  File gốc đầy đủ: `README.md`, `PROTOCOL.md`, `agents.yaml`,
  `tasks/087-novelnext-retest.json`, `tasks/088-fork-rescan-13.json`,
  `hub/server.js`, `hub/client.js`, `scripts/new-task.sh`,
  `scripts/claim-task.sh`, `docs/SETUP-HUB.md`.
- Cách gửi: Anh (hoặc Muse chính) gửi file này + link repo cho Antigravity.
  Antigravity CHỈ review + đề xuất, không sửa repo chính (xem §6).

## 1. Ý tưởng (1 đoạn)

Anh có 3 Muse chạy trên 3 máy khác nhau — muse-main (VM này),
muse-1, muse-2 — nhưng 3 bạn không có kênh gọi thẳng cho nhau, trước giờ
phối hợp bằng tay qua Qsang_vbook + ROADMAP.md + chat, dễ trùng việc và
sót báo cáo. Ý tưởng là lập 1 repo trung tâm `qsang2025/muse-teamwork`:
Anh giao việc 1 lần bằng 1 file task, 3 Muse tự pull repo, claim task,
làm song song trên branch riêng, muse-main kiểm chứng rồi merge duy nhất
lên Qsang_vbook. GitHub làm trung tâm thật, Tailscale chỉ là đường nhanh
tùy chọn — mất mạng Tailscale vẫn làm việc được.

## 2. Mục tiêu cuối cùng (đo được)

- D1: Repo `qsang2025/muse-teamwork` tồn tại trên GitHub, public, clone được.
- D2: Claim chống trùng chạy được: 2 agent cùng claim 1 task → chỉ 1 được.
- D3: Hub Tailscale (tùy chọn) chạy được ở loopback (`/health` trả 200).
- D4: 2 task mẫu chạy xong thật, có kết quả + branch + log test (không chỉ
  có file kế hoạch): 087 retest novelnext 1 chương; 088 rescan fork lần 13.
- D5: muse-1 và muse-2 đã đọc repo và xác nhận + tên task đầu tiên mình nhận.
- D6: Anh giao được 1 việc mới qua repo, trong 1 ngày có agent claim và báo
  tiến độ, không cần họp hay chuyển tin tay.
- D7: Không lộ secret (password, token, key, cookie) trong repo.
- Mốc cuối: khi D1–D7 đều PASS thì coi như hệ 3 Muse vận hành được bằng repo,
  Anh chỉ việc giao task và nhận báo cáo tổng hợp sau mỗi task xong.

## 3. Thực trạng đã làm xong (tới 21:56 ngày 16/11/2026)

- Repo đã tạo + push: https://github.com/qsang2025/muse-teamwork,
  main `cc4a96d`, 20 file, đã clone lại từ remote kiểm chứng đủ file.
- Kiến trúc GitHub-first: mọi task, claim, kết quả đều là file
  `tasks/*.json` trong repo; trạng thái chỉ tin GitHub, không tin hub.
  Lý do bắt buộc: VM muse-main là Tailscale client-only (chỉ gọi ra,
  không nhận inbound, không host được service); probe 16/11 qua proxy
  port 3130 tới muse-1 (100.85.79.92) và muse-2 (100.126.2.102) ở 5 cổng
  80/8080/18080/3000/8787 đều timeout 5s, code 000 — 2 bạn không host sẵn
  service nào để gọi thẳng. Tailscale thấy đủ 5 máy (thêm TV và điện thoại
  Anh 100.90.26.91), nhưng "thấy máy" không đồng nghĩa "gọi được việc".
- Hub Tailscale port 8787 (Node, không dependencies: `hub/server.js`,
  `hub/client.js`): CHỈ là tùy chọn tăng tốc. Chưa bật, chưa có máy host.
  Muốn bật phải có 1 máy chạy hub + mở 8787, rồi probe lại
  `curl --proxy "$tunnel_proxy" http://<IP-hub>:8787/health` trả 200 mới
  ghi là "đã chạy". Mọi claim qua hub phải ghi thành commit GitHub trong 1h.
- Claim chống trùng đã test thật: đường hub claim trùng bị HTTP 409,
  heartbeat sai chủ bị 403, task không có bị 404; đường git
  `scripts/claim-task.sh` claim trùng bị từ chối exit 3; claim hết hạn 3h
  qua hub tự trả về `open` và claim lại được.
- Verified độc lập: Team Verified kiểm trên bản sao sạch, kết quả 3 PASS
  (D2 claim, D3 hub loopback, D7 không secret) / 4 FAIL đều là "chưa tới
  giai đoạn" (D1/D4/D5/D6). Họ tìm ra 11 lỗi L1–L11, nặng nhất là L1 (task
  088 gợi ý lại 4 host Anh đã đóng/đã merge) và L2 (mẫu grep không khớp
  JSON minified). Đã sửa hết L1–L11, re-verify L1–L4 đạt 4/4 PASS rồi mới
  push. Chi tiết nằm ở work files của Muse (không trong repo này):
  PLAN, SURVEY, VERIFICATION-REPORT, REVERIFY-REPORT.
- 2 task mẫu đang `open`, chưa gán: 087 novelnext retest 1 chương sau thời
  gian lặng (MERGE HELD vì 429, nhưng ảnh Anh 21:13 ngày 16/11 cho thấy
  chương 1 đọc đủ trong app → chặn theo burst); 088 rescan fork tìm host
  mới (rescan #12 ngày 16/11: kho build-ready đã cạn, 109 host).
- Công cụ sẵn có: Node v24.22.1, Python 3.12.3, gh 2.102.0, git 2.43.0.

## 4. Plan chi tiết tóm tắt (4 giai đoạn)

- Giai đoạn 1 — Khảo sát (đã xong): xác nhận 3 máy + IP, probe cổng,
  xác nhận tên repo trống, đọc ROADMAP lấy 2 task thử.
- Giai đoạn 2 — Xây dựng (đã xong): build repo local 20 file, kèm
  BUILD-REPORT.md ghi kết quả test + probe. Cấm push khi chưa verified.
- Giai đoạn 3 — Verified độc lập (đã xong vòng 1 + sửa + re-verify):
  kiểm trên bản sao sạch, thử tranh claim, thử hub loopback, quét secret.
  1 FAIL ở D2/D5/D7 là quay lại giai đoạn 2 (đã xảy ra với L1–L4).
- Giai đoạn 4 — Bàn giao (đang làm): push repo, gửi Anh 2 tin mẫu
  (`docs/START-MUSE-1.md`, `docs/START-MUSE-2.md`) để Anh copy-paste cho
  2 bạn, chạy task thử 087 rồi 088.

### RACI (mỗi việc chỉ 1 người chịu trách nhiệm cuối)

| Việc | muse-main | muse-1 | muse-2 | Anh |
|---|---|---|---|---|
| Giao việc / chốt ưu tiên | I | I | I | A |
| Điều phối, chia task, xử tranh claim | R + A | C | C | I |
| Build / research song song | R (khi cần) | R | R | I |
| Device-test + install trên điện thoại Anh | R + A | — (không có máy test) | — (không có máy test) | C |
| Merge lên Qsang_vbook main | R + A (duy nhất) | — | — | I |
| Review chéo | R | R (cho muse-2) | R (cho muse-1) | I |

### Vòng đời task

`open → claimed → doing → review → done` (kẹt thì `blocked`, hủy thì
`cancelled`). Claim bằng commit: đổi `status` → `claimed`, ghi `assignee`
+ `claim_expires_at` = giờ claim + 2h, push lên main. Heartbeat mỗi ≤ 2h
(1 commit tiến độ). Hết hạn 2h không heartbeat: qua hub tự trả về `open`;
qua GitHub thì muse-main dọn tay mỗi lần chia việc. Tranh claim: ai push
lên main trước thì được, người sau dừng, không sửa đè, không force-push
lên main. Mỗi agent tối đa 2 task `doing` cùng lúc. Làm trên branch riêng
(`feature/<tên-task>`), xong mở PR, nhờ 1 agent khác review, để `review`
chờ muse-main. Merge Qsang_vbook chỉ khi muse-main tự kiểm chứng đủ:
validate PASS + device test code 0 + install code 200. Rollback bằng
`git revert`; xóa nguồn vBook phải backup branch trước.

### Rủi ro chính (R1–R10 trong PLAN)

R1 Tailscale rớt → GitHub-only vẫn chạy. R2 hub không mở được cổng → bỏ
hub, ghi "chưa bật". R3 push GitHub lỗi → retry tối đa 3 lần, kiểm tra
main thực tế trước khi báo merge. R5 trùng build → luật claim xử lý.
R7 site chặn 429 → retest đúng 1 chương sau thời gian lặng, không lách
chặn. R8 agent im lặng quá 2h → thu hồi task. R9 lộ secret → revert +
rotate. R10 Anh bận chưa chốt → làm tiếp phần không cần quyết định đó.

## 5. Yêu cầu Antigravity: dùng /swarm /plan để kiểm chứng + tối ưu

Trước khi làm gì, đọc skill quota-workflow tại
https://github.com/qsang2025/antigravity-skills (repo public, MIT):
master lập plan bằng Gemini 4 Argon Medium (pro tier), sub chạy Gemini 3.8
Flash Medium — khi dispatch sub-agent ghi rõ TypeName: 'self',
Workspace: 'inherit', Model: 'flash'. Không lập plan bằng Gemini web app.
Nếu hết quota ở bước nào thì dừng, lưu tiến độ vào file plan, commit, báo
lại — không retry trong vòng lặp.

Việc cần làm:

- (a) Check tính đúng đắn của kiến trúc GitHub-first + hub tùy chọn: có
  đúng là lựa chọn duy nhất khả thi với VM client-only + 2 bạn chưa mở
  cổng không? Có kiến trúc nào tốt hơn mà không cần thêm máy hay thêm
  tài khoản không? Trả lời có bằng chứng (trích file:dòng, lệnh probe).
- (b) Tìm lỗ hổng, ưu tiên theo mức độ gây hỏng việc thật: race claim
  (2 agent cùng claim 1 task qua git — ai push trước được, người sau xử
  lý ra sao khi đã làm dở?), xung đột merge (2 người cùng sửa 1 file
  task, 2 branch cùng tên nguồn), task hết hạn (hub tự sweep nhưng
  GitHub phải dọn tay — khoảng trống này gây kẹt bao lâu?), hub mất đồng
  bộ với GitHub (claim qua hub chưa ghi commit trong 1h thì sao?),
  1 agent ôm việc rồi im lặng, muse-main là điểm nghẽn duy nhất (merge +
  device-test + điều phối — nếu muse-main bận thì cả hệ dừng?).
- (c) Tối ưu quy trình chia việc cho 3 Muse, và nêu rõ nếu mở rộng lên
  3 Muse + 4 Antigravity khác (tổng 7 agent) thì chỗ nào vỡ trước:
  claim, review chéo, merge, hay heartbeat? Đề xuất ngưỡng (số agent,
  số task song song) và cách chia nhóm.
- (d) Đề xuất cải tiến cụ thể, xếp theo ưu tiên P0 (chặn làm việc) /
  P1 (nên làm ngay) / P2 (làm sau). Mỗi đề xuất ghi rõ file:dòng cần sửa,
  sửa thành gì, và cách kiểm chứng sau khi sửa (lệnh + kết quả mong đợi).
  Không đề xuất chung chung kiểu "nên cải thiện bảo mật".

## 6. Giới hạn cứng (vi phạm là dừng ngay)

- CHỈ review + đề xuất. KHÔNG merge vào Qsang_vbook, KHÔNG push thẳng
  lên main của muse-teamwork, KHÔNG tự tạo task mới trong repo chính.
- KHÔNG sửa task 087/088 đang `open` (2 task này đang chờ chạy thật).
- KHÔNG ghi password, token, key, cookie vào bất kỳ file hay báo cáo nào.
- KHÔNG đổi luật merge (chỉ muse-main merge Qsang_vbook) và không đổi
  quy tắc auto-merge (validate PASS + device test code 0 + install 200).
- Kết quả ghi vào branch mới `feature/antigravity-review`, file
  `ANTIGRAVITY-FINDINGS.md` trong branch đó, rồi báo lại tóm tắt cho
  Muse chính (không push lên main, không mở PR merge). Nếu phát hiện
  secret trong lúc review thì báo riêng, không ghi giá trị secret ra.

## 7. Quyết định đã chốt (Anh chốt lúc 21:56 ngày 16/11/2026)

1. GIỮ tên repo `muse-teamwork` (không đổi sang `muse-mesh`).
2. Máy host hub để Muse tự chọn — Muse chọn GitHub-only trước, hub
   Tailscale để sau khi cần, không ép bật hub ngay.
3. ĐƯỢC retest novelnext 1 chương sáng 17/11 (task 087, chỉ 1 chương,
   sau thời gian lặng; vẫn 429 thì giữ MERGE HELD, không retest dồn).
4. 2 bạn muse-1/muse-2 DÙNG CHUNG GitHub qsang2025 — 2 bạn push branch
   trực tiếp được; chỉ muse-main merge lên Qsang_vbook main (2 bạn không
   tự merge, không tự push lên main).

## 8. Câu hỏi cần Antigravity trả lời (trả lời thẳng từng câu)

1. Kiến trúc GitHub-first + hub tùy chọn có đủ để 3 Muse làm song song
   không? Nếu chưa đủ thì thiếu mảnh nào?
2. Điểm yếu lớn nhất của thiết kế hiện tại là gì (chỉ nêu 1 điểm)?
3. Có nên bật hub Tailscale ngay hay GitHub-only là đủ cho 2 task mẫu
   087/088? Nếu nên bật thì host trên máy nào, kiểm chứng bằng lệnh gì?
4. Race claim qua git có cần khóa mạnh hơn (vd. GitHub Issue, PR check)
   hay "ai push trước được" là đủ với 3 agent?
5. Nếu mở rộng lên 7 agent (3 Muse + 4 Antigravity) thì cần đổi gì đầu
   tiên, và có cần tách repo hay tách hàng đợi task không?
6. Cần Anh quyết thêm gì trước khi 2 bạn bắt đầu nhận task thật?

## Phụ lục — Sơ đồ file để review nhanh

```
README.md / PROTOCOL.md / agents.yaml — luật chơi, đọc trước (3 file)
tasks/087-novelnext-retest.json, tasks/088-fork-rescan-13.json — task thật
tasks/_template.json, tasks/README.md — mẫu task
hub/server.js, hub/client.js — hub port 8787 (đọc kỹ phần claim/expire)
scripts/new-task.sh, scripts/claim-task.sh — claim bằng git
docs/START-MUSE-1.md, docs/START-MUSE-2.md — tin mẫu gửi 2 bạn
docs/SETUP-HUB.md — cách host + probe hub qua proxy 3130
```

## Lệnh mẫu gửi cho Antigravity

> Trước khi làm gì, đọc skill quota-workflow tại
> https://github.com/qsang2025/antigravity-skills và làm theo.
> Đọc file `docs/ANTIGRAVITY-REVIEW.md` trong repo
> https://github.com/qsang2025/muse-teamwork (main cc4a96d) rồi dùng
> /swarm /plan để kiểm chứng + tối ưu theo đúng §5 và §6 trong file đó.
> Master lập plan bằng Gemini 4 Argon Medium, sub chạy Gemini 3.8 Flash
> Medium (TypeName: 'self', Workspace: 'inherit', Model: 'flash').
> Kết quả ghi vào branch mới `feature/antigravity-review`, file
> `ANTIGRAVITY-FINDINGS.md`, rồi báo lại tóm tắt.
