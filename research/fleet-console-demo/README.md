# Fleet Console Demo

Bản demo phòng chỉ huy cho một đội agent AI — dựng tối 13/11/2026 từ nghiên cứu
hai dự án đang trending trên GitHub: **Buzz** (Block) và **Plannotator**.
Link chia sẻ muse.ai gốc bị chặn (`control_plane_destination_blocked`) nên toàn
bộ source được đẩy lên đây để team nghiên cứu trực tiếp.

## Demo làm gì

Mô phỏng một ca làm việc của đội agent trong phòng chat chung:

- Bấm **"Phát lệnh mẫu: điều tra retry checkout"** — đội agent nhận việc, gửi
  bản vá, chờ anh duyệt rồi phát hành.
- Mọi bước hiện đồng thời ở **ba góc nhìn**:
  1. **Phòng lệnh** — chat kiểu Discord: sidebar phòng (fleet, releases,
     incidents, recon, billing-retry), kanban Backlog → Done, danh sách agent.
  2. **Hộp thư duyệt** — kiểu Plannotator: agent để lại câu hỏi/file, anh duyệt
     bằng một cú nhấp, không giữ phiên agent lại.
  3. **Nhật ký sự kiện** — log thô các sự kiện đã ký (mô phỏng Nostr: pubkey,
     kind, tags, content; chuỗi băm kiểm toán liên tục).
- Gõ `@scout`, `@forge`, `@sentry`, `@herald` để giao việc cho từng agent.
- Mục "Hai dự án gốc" giải thích vì sao ghép Buzz + Plannotator lại, kèm số
  sao/fork tại thời điểm nghiên cứu (13–14/11/2026, sẽ thay đổi).

**Lưu ý:** agent trong demo là **mô phỏng bằng kịch bản** — chưa nối API hay
backend thật, relay `ws://localhost:3000` chỉ là chữ mô phỏng.

## Chạy / xem thế nào

Không cần build, không cần server:

```bash
# Cách 1: mở trực tiếp
xdg-open research/fleet-console-demo/index.html   # hoặc double-click file

# Cách 2: serve tĩnh (tuỳ chọn)
cd research/fleet-console-demo && python3 -m http.server 8000
# rồi mở http://localhost:8000/
```

Trang duy nhất là `index.html` (tự chứa CSS/JS, font Google Fonts qua CDN).
`assets/ref-console.jpg` là ảnh mẫu anh gửi hôm 13/11 mà demo bám theo bố cục.

## Có gì mượn được cho team

| Ý tưởng | Nguồn | Mượn cho team thế nào |
|---|---|---|
| Agent là thành viên phòng, không phải bot gắn thêm — mỗi agent có cặp khóa riêng, tư cách thành viên theo phòng, nhật ký kiểm toán riêng | Buzz | Mô hình danh tính cho hub: giới hạn theo danh tính, không theo cờ quyền chung chung |
| Mọi hành động là một sự kiện có chữ ký trong cùng một nhật ký (kind = công tắc định tuyến duy nhất; tính năng mới = kind mới, không phá client cũ) | Buzz | Nhật ký sự kiện chung cho tasks/*.json + hub, thay vì chat trôi |
| Mỗi nhiệm vụ/nhánh code là một phòng riêng — nhiệm vụ, bản vá, CI, review, quyết định phát hành nằm chung một chỗ, thành hồ sơ giải thích vì sao code tồn tại | Buzz | Thay cho việc task chỉ là 1 file JSON rời rạc |
| Hộp thư duyệt bất đồng bộ: agent để lại câu hỏi/file, người duyệt bằng một cú nhấp mà không giữ phiên agent lại | Plannotator | Điểm kiểm soát của con người cho vòng review (hiện muse-main duyệt bằng tay trong file task) |
| Ba góc nhìn cùng một dữ liệu: phòng lệnh / hộp thư duyệt / nhật ký thô | Bản demo | Dashboard hiện tại của team (`tasks/*.json` + hub) mới chỉ có 1 góc nhìn là file task; console thật cần cả ba |

## So với dashboard tasks/*.json hiện có và hub

- **Dashboard hiện tại:** file `tasks/*.json` trong repo này + hub trên cổng 8787
  (chỉ `GET /health`, chạy local, Tailscale built-in không nhận inbound nên
  muse-main không gọi được). Là "sổ việc" — đúng, đủ, nhưng chỉ đọc/ghi bằng tay.
- **Demo này:** chỉ là **giao diện mô phỏng**, không có dữ liệu thật, không nối
  hub, không đọc/ghi `tasks/*.json`. Giá trị của nó là **bố cục + mô hình**:
  phòng lệnh, hộp thư duyệt, nhật ký sự kiện — ba thứ dashboard hiện tại chưa có.
- **Hướng ghép (nếu team làm thật):** giữ `tasks/*.json` làm nguồn sự thật,
  hub làm relay/API, và lấy bố cục 3 tab của demo này làm mặt trước; mỗi task
  thành một "phòng riêng" kiểu Buzz, mỗi lần đổi status là một sự kiện có chữ ký
  trong nhật ký.

## File trong thư mục

| File | Gì |
|---|---|
| `index.html` | Toàn bộ demo (HTML + CSS + JS tự chứa) |
| `space.json` | Khai báo runtime của artifact gốc (static, slug `fleet-console-demo`) |
| `AGENTS.md` | Ghi chú build của artifact gốc (chỉ build qua web-artifact tools) |
| `icon.webp` | Icon của artifact gốc |
| `assets/ref-console.jpg` | Ảnh mẫu anh gửi 13/11 — bố cục tham chiếu của demo |

Không kèm thư mục `audits/` và `.space-build*/` của artifact gốc (ảnh chụp
kiểm thử + bản build tạm, ~15 MB, không phải source).

## Nguồn nghiên cứu

- Buzz — Block, "A hive mind communication platform", Apache-2.0
  (github.com/block/buzz). Số liệu trong demo lấy ngày 13–14/11/2026.
- Plannotator — hộp thư duyệt bất đồng bộ cho agent.
- Trang nghiên cứu gốc: space "Làm Fleet Console như thế nào"
  (slug `lam-fleet-console-nhu-the-nao`).
