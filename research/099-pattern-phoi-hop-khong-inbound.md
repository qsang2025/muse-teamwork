# 099 — Pattern phối hợp nhiều Muse không cần kết nối inbound

Nghiên cứu của muse-main, 19/11/2026. Task 099 (Anh giao khi hết việc).
Kết luận ngắn: **GitHub đã là xương sống và làm tốt; đừng xây thêm hạ tầng
inbound. Cải tiến đáng làm nhất là chuyển watchdog/inbox từ cron trên VM
sang GitHub Actions** — vẫn miễn phí, vẫn không cần inbound, và không chết
khi VM bị thay mới.

## 1. Hiện trạng (kiểm chứng 19/11/2026)

| Kênh | Cơ chế | Nhịp | Máy chạy | Trạng thái |
|---|---|---|---|---|
| Nguồn thật | `tasks/*.json` trên GitHub, PROTOCOL.md §1–§7 | — | — | Tốt, duy nhất |
| Watcher | `scripts/watch-tasks.sh`, `git fetch origin main`, so sánh (id, status, assignee, preferred_assignee), bỏ qua notes/`updated_at` | 5 phút | Cả 3 máy (hook `muse-teamwork-watch`, poll 300s) | Tốt (095/096 done, review 8/10) |
| Watchdog | Pull main → status-board → sweep-expired → kiểm chứng task `review` → merge khi đủ 3 điều kiện; chỉ báo Anh khi có thay đổi | 2 giờ | VM muse-main (cron) | Chạy, nhưng **phụ thuộc VM sống** |
| Dashboard inbox | `scripts/apply-dashboard-issues.py`, đọc issue `[dashboard]` của qsang2025, áp dụng vào `tasks/*.json` | 15 phút | VM muse-main (cron) | Chạy |
| Báo cáo sáng | Tổng hợp task | 07:30 | VM muse-main (cron) | Chạy |
| Hub | `hub/server.js`, port 8787, đọc/ghi trực tiếp `tasks/*.json`, tự commit+push; systemd service `Restart=always` trên muse-1 | — | muse-1 (local) | **Chỉ local**: `/health ok:true` trên máy, probe từ muse-main luôn `http=000` |

## 2. Ràng buộc cứng (đã chứng minh, không giả định)

1. **VM không nhận inbound.** Tailscale trên VM chạy qua tunnel của
   runtime, "không nhận kết nối inbound" (task 092, xác minh 19/11 19:11:
   IP đúng 100.85.79.92, `Connected`, nghe 0.0.0.0:8787, probe ngoài vẫn
   000). Mọi pattern cần webhook / server gọi vào VM đều **không làm được**.
2. **Chỉ outbound được.** `git fetch/push`, gọi API GitHub, cron, hook
   polling đều đi ra ngoài — đó là lý do watcher 5 phút hoạt động.
3. **Miễn phí.** Không đề xuất dịch vụ trả phí; không mua VPS.
4. **VM bị thay mới sẽ xóa cron/service local.** Đã xảy ra 19/11 13:35
   (VM muse-1 thay mới xóa service hub; phải cài lại 3 lần trong ngày).
   Mọi thứ quan trọng phải sống trong repo GitHub, không sống trên VM.

## 3. Các pattern khác đã so sánh

### A. GitHub Actions làm "người gác" (KHUYẾN NGHỊ — đề xuất 1)

Chuyển watchdog 2h + inbox 15 phút + báo cáo sáng từ cron trên VM sang
workflow `.github/workflows/*.yml` chạy theo lịch (`schedule: cron`).

- **Vì sao hợp ràng buộc:** Actions chạy trên runner của GitHub, không cần
  inbound vào VM; repo public nên Actions **miễn phí, không giới hạn phút**
  cho public repo; `GITHUB_TOKEN` có sẵn trong workflow, đủ quyền
  commit/push nếu đặt `permissions: contents: write`.
- **Lợi ích so với hiện tại:** không chết khi VM thay mới; chạy đúng giờ kể
  cả khi cả 3 VM cùng tắt; log mỗi lần chạy xem được công khai trên GitHub;
  cron VM hiện tại là điểm chết đơn lẻ (single point of failure) duy nhất
  còn lại của team.
- **Chi phí:** 0đ. Công làm: ~1 buổi — viết 2 workflow (watchdog 2h,
  inbox 15 phút), giữ nguyên script Python/shell hiện có, chỉ đổi chỗ chạy.
  Giữ cron VM chạy song song 1–2 ngày để đối chiếu rồi mới tắt.
- **Rủi ro:** lần đầu cần kiểm tra `GITHUB_TOKEN` có push được lên main
  không (repo public, branch protection nếu có); cron của Actions có độ
  trễ vài phút, chấp nhận được với nhịp 2h/15 phút.
- **Không làm:** đừng chuyển cả watcher 5 phút sang Actions — Actions tối
  thiểu 5 phút/lần nhưng mỗi lần chạy tốn ~1 phút khởi động runner, không
  hiệu quả bằng hook local; watcher cứ ở lại trên máy mỗi agent.

### B. Hàng đợi qua GitHub Issues/Discussions thay cho file task

Dùng issue làm "hàng đợi việc": mỗi task là 1 issue, label là trạng thái,
assignee GitHub là người nhận; agent poll API issue thay vì đọc file JSON.

- **Vì sao không chọn:** file `tasks/*.json` đã là hàng đợi tốt và là
  nguồn thật duy nhất (PROTOCOL §1, Living Spec); chuyển sang issue sẽ có
  **2 nguồn thật** (file + issue) và lại split-brain như lỗi hub cũ
  (`hub/data/tasks.json`, đã vá P0 ngày 17/11). Issue chỉ nên giữ vai trò
  hiện tại: **kênh lệnh từ Anh qua dashboard** (đã chạy tốt), không làm
  hàng đợi task.
- **Lợi ích nếu làm:** giao diện issue dễ đọc hơn JSON cho Anh. Nhưng
  dashboard đã giải quyết việc này rồi, không cần đổi.

### C. Bot trung gian (Telegram/Discord) — các VM chỉ gọi ra

Một bot (Telegram Bot API long-polling hoặc Discord webhook) làm "tổng đài":
agent gửi tin ra bot, bot chuyển cho agent khác; không ai cần inbound.

- **Vì sao không chọn:** vẫn cần **1 máy luôn bật** để chạy bot polling —
  quay lại đúng điểm yếu của hub/VM (thay VM là mất bot). Telegram/Discord
  còn thêm tài khoản + token + kênh ngoài repo, khó kiểm chứng, khó lưu vết
  bằng git. Lợi ích (nhận tin gần như tức thì) không hơn watcher 5 phút
  bao nhiêu, trong khi độ phức tạp và điểm chết tăng.
- **Chỉ xem lại khi:** team cần chat 2 chiều giữa các agent trong lúc làm
  (hiện tại chưa cần — mọi trao đổi đã qua notes trong task file).

### D. Watcher nhẹ hơn: kiểm tra SHA trước khi fetch (KHUYẾN NGHỊ — đề xuất 2)

Watcher hiện tại `git fetch origin main` mỗi 5 phút trên 3 máy (~864
fetch/ngày). Đổi thành 2 bước: `git ls-remote origin main` lấy SHA trước
(1 request nhẹ, không tải object); chỉ fetch khi SHA đổi.

- **Lợi ích:** giảm tải GitHub, giảm nguy cơ bị chặn tạm thời vì quét dày
  (lý do đã cấm quét 1 phút); vẫn giữ nhịp phát hiện ~5 phút.
- **Chi phí:** 0đ, sửa ~20 dòng trong `scripts/watch-tasks.sh`, test
  dry-run + live-run như task 095/096 đã làm.
- **Lưu ý:** `ls-remote` vẫn cần mạng; khi lỗi thì silent chờ lần sau như
  hiện tại, không đổi hành vi.

### E. Ghi chú: pattern đã loại — webhook, hub inbound, VPS riêng

- Webhook GitHub → VM: cần inbound, đã chứng minh không được (mục 2.1).
- Hub mở cho cả team: chỉ local trên muse-1, giữ nguyên làm công cụ tùy
  chọn, không phải xương sống (đúng như `hub/server.js` đã ghi).
- VPS riêng / máy luôn bật: tốn phí, trái ràng buộc miễn phí, Anh đã bỏ
  Oracle Cloud 14/11 nên không đề xuất lại hạ tầng trả phí.

## 4. Đề xuất cụ thể (theo thứ tự ưu tiên)

| # | Việc | Ai | Chi phí | Lợi ích |
|---|---|---|---|---|
| 1 | Chuyển watchdog 2h + inbox 15 phút sang GitHub Actions (workflow cron, dùng lại script hiện có; chạy song song cron VM 1–2 ngày rồi tắt cron) | muse-main (task mới) | 0đ, ~1 buổi | Hết điểm chết đơn lẻ: automation sống trong repo, VM thay mới cũng không mất |
| 2 | Watcher `ls-remote` kiểm tra SHA trước khi fetch | muse-1 hoặc muse-2 (task mới) | 0đ, sửa 1 script | Giảm ~90% lượng fetch, giảm nguy cơ GitHub chặn |
| 3 | Không đổi: giữ file task làm nguồn thật duy nhất; issue chỉ làm kênh lệnh từ Anh; hub chỉ local tùy chọn | — | 0đ | Tránh split-brain, tránh phức tạp hóa |

## 5. Checklist task 099

- [x] Tổng hợp hiện trạng: watcher 5 phút, watchdog 2h, inbox 15 phút, hub (chỉ local)
- [x] Nghiên cứu 2–3 pattern khác (ưu tiên miễn phí, không cần inbound): Actions (A), Issues-queue (B), bot trung gian (C), watcher nhẹ (D)
- [x] Báo cáo này (`research/099-...md`) + đề xuất 2 cải tiến cụ thể kèm chi phí/lợi ích (mục 4)
- [ ] Đề xuất 1 + 2 làm task riêng khi Anh đồng ý (chưa tự làm — cần Anh quyết vì đổi chỗ chạy automation)
