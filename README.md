# muse-teamwork — Repo phối hợp 3 Muse

Repo này là **trung tâm điều phối** cho 3 bạn Muse của Anh (Dương Nguyễn Quốc Sáng):
Muse chính (VM này) + muse-1 + muse-2. Anh giao việc **một lần**, 3 Muse tự chia
nhau làm, không trùng việc, không chờ nhau.

## Vấn đề

- 3 Muse làm việc trên 3 máy khác nhau, **không có kênh gọi thẳng** cho nhau.
- Cách cũ (hub-and-spoke qua Qsang_vbook + ROADMAP.md + todo) làm bằng tay, dễ
  trùng việc, dễ sót báo cáo.
- Muse chính chạy trên VM **Tailscale client-only**: chỉ gọi ra, không nhận
  inbound, không host được service cho tailnet.

## Nguyên tắc (nhớ kỹ)

1. **GitHub là thật.** Mọi task, claim, kết quả đều nằm trong repo này (file
   `tasks/*.json`). Mất mạng Tailscale vẫn làm việc được.
2. **Tailscale chỉ là nhanh.** Hub live (`hub/server.js`) chỉ giúp lấy task
   nhanh hơn, không phải nguồn sự thật. Hub chết thì fallback về GitHub.
3. **Chỉ muse-main merge lên Qsang_vbook.** muse-1, muse-2 chỉ build + test,
   không tự merge. Quy tắc auto-merge vẫn giữ nguyên: validate PASS +
   device test code 0 + install code 200 (xem `PROTOCOL.md`).
4. **1 task chỉ 1 agent.** Claim bằng branch + file task, hết hạn sau 2h
   không heartbeat.

## Sơ đồ luồng

```
Anh giao việc (chat với Muse chính, hoặc tạo file tasks/<id>.json)
        │
        ▼
Muse chính: tạo task → status "open" → push lên GitHub
        │
        ▼
muse-1 / muse-2: pull repo → poll task open → claim (branch + file task)
        │
        ▼
Agent làm việc trên repo đích (vd: Qsang_vbook) → test → push branch
        │
        ▼
Agent cập nhật tasks/<id>.json → status "review" (kèm branch + kết quả test)
        │
        ▼
Muse chính: kiểm tra → merge (nếu đạt) → status "done" → báo Anh 1 tin tổng hợp
```

## Bảng agents

| Agent | Tailscale IP | Vai trò gợi ý | Trạng thái |
|---|---|---|---|
| muse-main | 100.114.114.44 | Điều phối + merge + báo cáo Anh | Đang chạy (VM này) |
| muse-1 | 100.85.79.92 | Build + test song song | Đã thấy trên tailnet 2026-11-16 |
| muse-2 | 100.126.2.102 | Build + test song song | Đã thấy trên tailnet 2026-11-16 |

Chi tiết đầy đủ: xem `agents.yaml`.

> ⚠️ **Kết quả probe 2026-11-16 ~21:44:** probe HTTP qua Tailscale proxy port
> 3130 tới muse-1 và muse-2 ở các cổng 80, 8080, 18080, 3000 đều **timeout 5s,
> code 000** — hiện 2 bạn **không host sẵn service nào** để gọi thẳng.
> Vì vậy **phương án A (GitHub-only) là phương án dùng được ngay, không chờ ai
> mở cổng**. Phương án B (hub Tailscale) chỉ chạy được SAU KHI một trong 2 bạn
> (hoặc Anh) chạy `node hub/server.js` trên máy của mình và mở port 8787.
> Xem `docs/SETUP-HUB.md` để biết cách kiểm tra lại.

## Anh giao việc như thế nào

- **Cách 1 (nhanh nhất):** nhắn Muse chính "làm task X", Muse chính tạo file
  `tasks/<id>.json` rồi push. muse-1/muse-2 tự pull và claim.
- **Cách 2:** Anh (hoặc Muse chính) chạy `./scripts/new-task.sh "Tiêu đề task"`
  rồi push.
- **Cách 3:** Anh mở repo trên GitHub, tạo file `tasks/<id>.json` theo mẫu
  `tasks/_template.json` (xem `tasks/README.md`).

## Cấu trúc repo

```
README.md            — file này: tổng quan 1 trang
agents.yaml          — danh sách 3 agents (IP, vai trò, năng lực)
PROTOCOL.md          — giao thức làm việc: vòng đời task, claim, chống trùng, merge
tasks/               — task thật (1 file JSON / 1 task) + mẫu + hướng dẫn
hub/                 — hub live tùy chọn: server.js, client.js, client.sh
scripts/             — new-task.sh, claim-task.sh (bash + python3, không cần cài thêm)
docs/                — tin nhắn copy-paste cho muse-1/muse-2, hướng dẫn host hub
BUILD-REPORT.md      — nhật ký build + kết quả test của repo này
```

## Bắt đầu nhanh (cho muse-1 / muse-2)

1. Clone: `git clone https://github.com/qsang2025/muse-teamwork.git`
2. Đọc `PROTOCOL.md` (5 phút) và `docs/START-MUSE-1.md` (hoặc `START-MUSE-2.md`).
3. Lấy task: `node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 poll` (nếu có hub) hoặc `git pull` rồi đọc
   `tasks/*.json` có `status: "open"`.
4. Claim rồi làm, theo đúng `PROTOCOL.md`.

## Quy tắc merge (nhắc lại, rất quan trọng)

- Chỉ **muse-main** merge lên `Qsang_vbook` main.
- Merge khi: validate PASS + device test code 0 + install code 200 — do
  muse-main tự kiểm chứng, không hỏi lại Anh.
- muse-1/muse-2 sau khi xong thì để task ở `review`, **không merge**.

## Giấy phép

MIT — copyright Dương Nguyễn Quốc Sáng 2026. Xem `LICENSE`.
