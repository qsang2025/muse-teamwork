# SETUP-HUB.md — 3 phương án host hub live

Hub (`hub/server.js`) chỉ là **tăng tốc** — không bắt buộc. Nguồn sự thật vẫn là
file `tasks/*.json` trên GitHub. Chọn 1 trong 3 phương án dưới đây.

## Kết quả probe thực tế (2026-11-16 ~21:44)

Probe HTTP qua Tailscale proxy port 3130 tới muse-1 (100.85.79.92) và muse-2
(100.126.2.102) ở các cổng **80, 8080, 18080, 3000** đều **timeout 5s, code 000**
— hiện 2 bạn **không host sẵn service nào** để gọi thẳng. Vì vậy phương án B
chỉ chạy được SAU KHI một máy chạy hub và mở port 8787 (xem cách kiểm tra bên dưới).

## Phương án A — GitHub-only (DÙNG ĐƯỢC NGAY, không chờ ai)

- Không cần hub, không cần mở cổng.
- Luồng: Muse chính tạo task → push → muse-1/muse-2 `git pull` → claim bằng
  `./scripts/claim-task.sh` → làm → push branch + cập nhật task → muse-main merge.
- Nhược điểm duy nhất: phải `git pull` tay để thấy task mới (chậm hơn hub vài phút).
- **Đây là phương án mặc định. Nếu chưa quyết được máy host hub thì cứ dùng A.**

## Phương án B — Chạy hub trên muse-1 hoặc muse-2

Điều kiện: máy đó phải nhận được inbound qua Tailscale ở port 8787
(VM Muse chính thì KHÔNG được — client-only).

1. Trên máy host (muse-1 hoặc muse-2), trong repo muse-teamwork:
   ```
   node hub/server.js
   ```
   (giữ terminal chạy, hoặc chạy nền. Port mặc định 8787.)
2. Kiểm tra từ VM Muse chính — qua Tailscale proxy port 3130:
   ```
   tunnel_proxy="${HTTPS_PROXY%:*}:3130"
   curl -m 5 --proxy "$tunnel_proxy" http://100.85.79.92:8787/health
   ```
   Thay IP bằng IP máy host (muse-1: 100.85.79.92, muse-2: 100.126.2.102).
   Trả về `{"ok":true,...}` là được. Timeout / code 000 là chưa mở được cổng.
3. Kiểm tra từ máy host xem port có lắng nghe không:
   ```
   ss -tlnp | grep 8787
   ```
   Phải thấy `0.0.0.0:8787`. Nếu không thấy, firewall của máy đó đang chặn —
   mở port 8787 cho Tailscale (cách mở tùy OS, hỏi lại Anh nếu kẹt).
4. Khi hub chạy: các Muse dùng `node hub/client.js --hub http://<IP-host>:8787
   --agent <muse-1|muse-2> poll` (hoặc `hub/client.sh` với biến `HUB`, `AGENT`).
   Hub chết thì client tự in hướng dẫn fallback về GitHub.
5. Nhớ cập nhật `agents.yaml` (ghi máy nào đang host hub) và báo Anh.

## Phương án C — Chạy hub trên máy Anh (PC Windows luôn bật)

- Cài Node.js (https://nodejs.org, bản LTS) trên PC Windows.
- Clone repo `qsang2025/muse-teamwork`, chạy `node hub/server.js` trong
  thư mục repo.
- Kiểm tra giống phương án B (curl tới IP Tailscale của PC đó, port 8787).
- Chỉ nên dùng C nếu PC luôn bật; PC tắt là hub tắt, lúc đó cả nhóm lại
  fallback về GitHub (phương án A) — không sao cả.

## Khi hub gặp sự cố

- Hub không phản hồi → **không chờ, làm tiếp qua GitHub** (phương án A).
  Client (`hub/client.js`) đã tự in hướng dẫn fallback khi lỗi.
- Hub và GitHub mâu thuẫn (task trên hub khác file task) → **tin file GitHub**,
  muse-main là người dọn dẹp.
