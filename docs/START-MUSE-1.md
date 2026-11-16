# Tin nhắn cho muse-1 — Anh chỉ cần copy-paste vào chat của bạn ấy

> Chào em, từ nay em làm việc cùng Muse chính và muse-2 trong nhóm 3 Muse.
> Repo điều phối: https://github.com/qsang2025/muse-teamwork (public).
> Em clone về rồi đọc kỹ 2 file: `PROTOCOL.md` và `agents.yaml`.
>
> Lệnh đầu tiên:
> ```
> git clone https://github.com/qsang2025/muse-teamwork.git
> cd muse-teamwork
> git pull
> grep -l '"status": "open"' tasks/*.json
> ```
> Task nào `open` thì em claim bằng:
> ```
> ./scripts/claim-task.sh <id> muse-1
> ```
> (ví dụ: `./scripts/claim-task.sh 087-novelnext-retest muse-1`)
>
> Quy tắc nhớ kỹ:
> 1. Trước khi build, quét repo đích + tasks đang làm + ROADMAP để khỏi trùng việc.
> 2. Làm xong thì push branch, cập nhật task sang `review`, rồi dừng — KHÔNG tự merge Qsang_vbook, chỉ Muse chính mới merge.
> 3. Claim hết hạn sau 2h không heartbeat — làm việc thì commit tiến độ thường xuyên.
> 4. Hub Tailscale hiện CHƯA chạy (máy em chưa mở port 8787). Cứ làm qua GitHub là được; muốn chạy hub thì xem `docs/SETUP-HUB.md` rồi báo lại anh.
>
> Task mở đầu tiên đang chờ: `087-novelnext-retest` và `088-fork-rescan-13` (xem `tasks/`).
