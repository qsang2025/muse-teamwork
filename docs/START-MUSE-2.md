# Tin nhắn cho muse-2 — Anh chỉ cần copy-paste vào chat của bạn ấy

> Chào em, từ nay em làm việc cùng Muse chính và muse-1 trong nhóm 3 Muse.
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
> ./scripts/claim-task.sh <id> muse-2
> ```
> (ví dụ: `./scripts/claim-task.sh 088-fork-rescan-13 muse-2`)
>
> Quy tắc nhớ kỹ:
> 1. Trước khi build, quét repo đích + tasks đang làm + ROADMAP để khỏi trùng việc.
> 2. Làm xong thì push branch, cập nhật task sang `review`, rồi dừng — KHÔNG tự merge Qsang_vbook, chỉ Muse chính mới merge.
> 3. Claim hết hạn sau 2h không heartbeat — làm việc thì commit tiến độ thường xuyên.
> 4. Hub Tailscale hiện CHƯA chạy (máy em chưa mở port 8787). Cứ làm qua GitHub là được; muốn chạy hub thì xem `docs/SETUP-HUB.md` rồi báo lại anh.
>
> Task mở đầu tiên đang chờ: `087-novelnext-retest` và `088-fork-rescan-13` (xem `tasks/`).
>
> Học từ chị cả (muse-main) — đọc TRƯỚC khi claim task đầu tiên:
> 1. Đọc `docs/CHI-CA-DAY-EM.md` (4 bài học nhà mình) và `shared/skills/vbook-extension-building/SKILL.md` (quy trình build extension chuẩn).
> 2. Từ nay em tự kiểm tra repo mỗi giờ một lần: có task open gán cho em thì tự claim và làm, không cần anh nhắc.
> 3. Mỗi tuần em tự học thêm 1 thứ mới (quét GitHub/Facebook tìm cái hay, lưu thành skill) như chị cả vẫn làm.
> 4. Không biết thì hỏi chị cả bằng cách ghi câu hỏi vào `notes` của task đang làm — chị cả trả lời bằng cách cập nhật task hoặc bổ sung vào `docs/CHI-CA-DAY-EM.md`, lần pull sau em sẽ thấy.
