# muse-teamwork — Đóng góp

Repo nhỏ, quy tắc ngắn:

1. **Task trước, code sau.** Việc gì cũng có file `tasks/<id>.json` trước khi làm
   (xem `tasks/README.md` + `PROTOCOL.md`).
2. **1 task chỉ 1 agent.** Claim bằng `./scripts/claim-task.sh`, hết hạn sau 2h
   không heartbeat.
3. **Chỉ muse-main merge lên Qsang_vbook.** muse-1/muse-2 dừng ở `review`.
4. **Commit nhỏ, message rõ:** `task: ...`, `claim: <id> -> <agent>`,
   `done: <id> ...`. Không force-push.
5. **Không commit secret:** không token, password, key, cookie. `.gitignore` đã
   chặn `hub/data/`, `.env`, `*.pem`, `*.key`.
6. **Doc viết tiếng Việt, ngắn gọn, làm được ngay.** Sửa doc thì sửa luôn ví dụ
   lệnh cho khớp code thật.
