# AI For Everyone (DeepLearning.AI) — Báo cáo tự học (task 142)

- **Khóa học:** AI For Everyone, DeepLearning.AI (Andrew Ng)
- **Trang khóa:** https://www.deeplearning.ai/courses/ai-for-everyone
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE công khai; **không đăng ký trả phí/chứng chỉ, không chạy lab/API tốn phí** (theo checklist task 142 + quy tắc tự học §9).

## 0. Kiểm chứng khóa có trong danh sách 32 khóa đã duyệt — ĐẠT

Khóa này là **số 2 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11). Bằng chứng đầy đủ: Ú đã đọc đủ 32 tên bằng browser thật 20/11 21:57, ghi trong `research/140-governing-ai-agents-deeplearning-ai.md` trên branch `feature/140-tu-hoc-governing-ai-agents-deeplearning-ai` — "2. AI For Everyone — DeepLearning.AI". Theo chỉ dẫn task 142, **không kiểm chứng lại từ đầu**; bản này chỉ đối chiếu lại tên khóa với danh sách đó.

| Hạng mục | Số liệu đã kiểm chứng (20/11/2026) |
|---|---|
| Giảng viên | Andrew Ng — Founder DeepLearning.AI, Co-founder Coursera |
| Nền tảng | Coursera (học qua video + quiz); video cũng xem được trên DeepLearning.AI |
| Quy mô | 4 module (gọi là Week 1–4), **7 giờ** hoàn thành (4h23 video + 33 phút đọc + 2h quiz, tổng 47 mục); DeepLearning.AI ghi "4 tuần, 2–3 giờ/tuần" |
| Trình độ / điều kiện | Beginner, **không cần nền tảng kỹ thuật hay kinh doanh** |
| Học viên | **2.679.305** đã đăng ký; 53.559 đánh giá, **4,79/5** (81,85% đánh giá 5 sao) |
| FREE? | ✅ Video xem miễn phí (gói Free $0 của DeepLearning.AI; trên Coursera có "Full Course, No Certificate" / audit + financial aid). ❌ **Chứng chỉ $49** (hiệu lực 180 ngày, theo FAQ DeepLearning.AI); DeepLearning.AI Pro $30/tháng cũng mở quiz + chứng chỉ. Báo cáo này **không trả $49, không đăng ký Pro** |
| Cập nhật | Trang DeepLearning.AI ghi xuất bản 2025-06-27; nội dung gốc từ 2019, được cập nhật tháng 7/2026 (theo bài review đối chiếu 27/10/2026) |

**Không trùng:** quét repo + task đang mở trước khi học — khóa gần nhất là 118 Elements of AI (ĐH Helsinki, dạng text, có chứng chỉ miễn phí + 2 ECTS) và 139 Responsible AI (Google, chuyên sâu kỹ thuật). 142 là khóa **phi kỹ thuật, hướng quản lý/doanh nghiệp** của Andrew Ng — khác cả hai về đối tượng và nội dung (xem §4.3 so sánh trong 139 và phần kết luận dưới đây).

## 1. Tuần 1 — What is AI? (AI là gì)

### 1.1. Bản đồ thuật ngữ: AI ⊃ ML ⊃ DL, Data Science cắt ngang

- **AI (trí tuệ nhân tạo):** mô phỏng trí tuệ con người. Chia hai loại: **ANI (Artificial Narrow Intelligence)** — chỉ làm tốt một việc (loa thông minh, xe tự lái, tìm kiếm web); đây là nơi tiến bộ tập trung những năm gần đây. **AGI (Artificial General Intelligence)** — làm được mọi việc con người làm được; theo khóa, gần như chưa có tiến bộ và có thể còn hàng thập kỷ, thậm chí hàng thế kỷ.
- **Machine Learning (ML)** là tập con của AI; **Deep Learning (DL)** là tập con của ML, dùng mạng nơ-ron nhiều lớp (input → hidden layers → output — chỉ cần xác định đầu vào/đầu ra, phần giữa tự học). Trong thực tế hai thuật ngữ ML/DL hay được dùng lẫn nhau.
- **Supervised learning** (học có giám sát) là dạng ML phổ biến nhất: học ánh xạ **A → B** từ dữ liệu đã gán nhãn (vd: email → spam/không spam). Hầu hết giá trị thương mại của AI hiện nay nằm ở đây — đây là ý nền cho cả khóa.
- **Data Science (DS)** là tập hợp công cụ cắt ngang AI/ML/DL, nhưng **không tạo ra hệ thống AI đang chạy** — mục đích là rút insight từ dữ liệu để cải thiện quyết định kinh doanh. Thuật ngữ DS/ML không được dùng nhất quán trong ngành; khóa nhấn mạnh phân biệt theo **đầu ra** (hệ thống chạy được vs báo cáo insight).

### 1.2. Dữ liệu: lấy ở đâu, sai lầm nào hay gặp

- Cách lấy dữ liệu: tải từ web, qua đối tác, quan sát hành vi trong dữ liệu sẵn có, hoặc **gán nhãn thủ công**.
- **Dữ liệu có cấu trúc** (structured): nằm trong bảng tính. **Dữ liệu phi cấu trúc** (unstructured): ảnh, âm thanh, text.
- **Hai sai lầm phổ biến nhất của công ty về dữ liệu:**
  1. Dành quá nhiều thời gian thu thập dữ liệu **trước khi nói chuyện với đội AI** — đội AI cần được xem dữ liệu sớm để phản hồi (vd: đội AI có thể đề nghị nhà máy ghi dữ liệu mỗi phút thay vì mỗi 10 phút, để làm được bảo trì dự đoán).
  2. Cho rằng **càng nhiều dữ liệu càng tốt** — dữ liệu bẩn (nhãn sai, thiếu giá trị, nhiều định dạng) thì đầu ra cũng bẩn ("garbage in, garbage out"). Chất lượng + đúng loại dữ liệu quan trọng hơn số lượng thô.

### 1.3. ML làm được gì — quy tắc "1 giây" và giới hạn

- **Quy tắc 1 giây (1-second rule):** việc gì con người làm được trong ~1 giây suy nghĩ thì ML có khả năng tự động hóa được, nay hoặc sắp tới. Ví dụ làm được: chuyển giọng nói thành text, kiểm tra lỗi bề mặt sản phẩm bằng thị giác. Ví dụ **không** làm được: phân tích thị trường rồi viết báo cáo 50 trang, thấu cảm với con người.
- Quy tắc này **không cứng**: có những việc phải cho đội kỹ thuật thẩm định sâu vài tuần mới kết luận khả thi hay không. Điều làm ML dễ hơn: khái niệm "đơn giản" + nhiều dữ liệu sẵn có.
- **"AI là điện mới"** — luận điểm mở đầu của Ng: AI sẽ tạo thêm ~$13.000 tỷ giá trị mỗi năm vào 2030 (ước tính McKinsey) và biến đổi mọi ngành, giống như điện một thế kỷ trước. Con số này là ước tính cũ (2018) — xem §7.

## 2. Tuần 2 — Building AI Projects (Xây dự án AI)

### 2.1. Hai workflow — ML vs Data Science

| | Workflow dự án ML | Workflow dự án DS |
|---|---|---|
| Bước 1 | **Thu thập dữ liệu** (vd: mẫu giọng nói cho loa thông minh) | **Thu thập dữ liệu** |
| Bước 2 | **Train model** — lặp đi lặp lại tới khi đủ tốt | **Phân tích dữ liệu** — lặp tới khi có insight tốt |
| Bước 3 | **Deploy** (đưa model vào loa, xuất xưởng) | **Đề xuất giả thuyết / hành động** |
| Sau đó | Thu dữ liệu mới từ thực tế → duy trì/cập nhật model | Triển khai thay đổi → phân tích lại dữ liệu mới định kỳ |

Điểm khác biệt cốt lõi: dự án ML kết thúc bằng **một hệ thống đang chạy**; dự án DS kết thúc bằng **một đề xuất cho lãnh đạo**. Nhầm hai workflow này là nguồn gốc nhiều kỳ vọng sai (vd: đòi đội DS "giao một con AI chạy được").

### 2.2. Chọn dự án AI nào — thẩm định 3 mặt + khung brainstorm

Chọn dự án ở **giao nhau** của: AI làm được về mặt kỹ thuật **+** có giá trị kinh doanh **+** có dữ liệu sẵn sàng. Cần đội liên chức năng (chuyên gia AI + chuyên gia nghiệp vụ) thẩm định:

- **Technical diligence:** hệ AI có đạt hiệu năng mong muốn không? Cần bao nhiêu dữ liệu (tùy bài toán)? Timeline kỹ thuật bao lâu?
- **Business diligence:** giảm được chi phí hay tăng được doanh thu ở đâu? Có nên ra sản phẩm/kinh doanh mới không?
- **Ethical diligence:** có dự án hợp lý về kinh doanh nhưng **không tốt cho xã hội** — phải loại ngay từ đầu (nối 139: đây chính là bước "quyết định chính sách trước khi đo" ở tầng chọn dự án).
- **Khung brainstorm hiệu quả:** tự động hóa **tác vụ** (task) chứ không phải tự động hóa **công việc** (job); bám vào động lực tạo giá trị chính và điểm đau chính của doanh nghiệp.

### 2.3. Build hay buy — và làm việc với đội AI

- **Build vs buy:** ML có thể tự làm hoặc thuê ngoài; DS thường làm **in-house** vì cần hiểu sâu nghiệp vụ ngày qua ngày. Quy tắc: **mua thứ sẽ thành chuẩn ngành, tự làm thứ chuyên biệt tạo lợi thế phòng thủ** — vì chuẩn ngành sớm muộn cũng có người làm sẵn.
- Làm việc với đội AI cần hai thứ từ phía nghiệp vụ: **(1) tiêu chí chấp nhận rõ ràng** (vd: độ chính xác 95%) và **(2) một tập dữ liệu để đo hiệu năng**. Đội AI phân biệt **training set** (dạy model) và **test set** (đo model) — người không kỹ thuật phải hiểu phân biệt này để không bị "đo trên dữ liệu đã học thuộc".
- **Cạm bẫy:** đừng kỳ vọng **100% chính xác** — giới hạn đến từ thiếu dữ liệu, nhãn sai, nhãn mơ hồ; có cái sửa được, có cái không.

## 3. Tuần 3 — Building AI in Your Company (Đưa AI vào công ty)

### 3.1. Hai case study: loa thông minh và xe tự lái

- **Loa thông minh** — một sản phẩm, nhiều model ML nối tiếp (AI pipeline): trigger word ("Hey Device") → speech recognition (giọng nói → text) → intent recognition (trò đùa / giờ / nhạc / thời tiết) → thực thi. Mỗi khâu là một bài toán A→B riêng, có dữ liệu và test set riêng.
- **Xe tự lái** — tương tự: ảnh từ camera → phát hiện xe/vật thể → lập kế hoạch di chuyển. Bài học: sản phẩm AI phức tạp không phải "một model", mà là **chuỗi model + phần mềm truyền thống**; hỏng một khâu là hỏng cả chuỗi — phải đo từng khâu, không chỉ đo đầu cuối (nối 132: evals theo từng bước pipeline).
- **Thế nào là "công ty AI":** không phải công ty nào dùng AI cũng là công ty AI. Theo Ng, công ty AI thực hiện **thu thập dữ liệu chiến lược** (chủ động nghĩ cách lấy dữ liệu, thậm chí ra sản phẩm chỉ để lấy dữ liệu), đầu tư **kho dữ liệu thống nhất** (unified data warehouse), **tự động hóa khắp nơi**, và có **vai trò mới** (ML engineer...) cùng cách chia việc mới.

### 3.2. Các vai trong đội AI

| Vai | Việc chính |
|---|---|
| AI Product Manager | Quyết định cái gì khả thi + có giá trị trong kỷ nguyên AI |
| Software Engineer | Phần mềm truyền thống quanh model |
| ML Engineer | Train + rà soát model |
| ML Researcher | Theo kịp tài liệu học thuật, đôi khi công bố |
| Applied ML Scientist | Nằm giữa ML Engineer và Researcher |
| Data Scientist | Rút insight kinh doanh từ dữ liệu |
| Data Engineer | Tổ chức dữ liệu: lưu trữ dễ truy cập, an toàn, tiết kiệm |

Ng nhấn mạnh: **không cần 100 người** mới làm được hầu hết dự án AI — một đội nhỏ 4–5 người cũng làm được.

### 3.3. AI Transformation Playbook — 5 bước (phần quan trọng nhất của khóa)

1. **Execute pilot projects to gain momentum (Chạy dự án thí điểm để lấy đà):** 1–2 dự án nhỏ, cho thấy kết quả trong **6–12 tháng**. Ưu tiên **khả thi kỹ thuật** hơn là giá trị kinh doanh lớn nhất ở bước đầu; có thể tự làm hoặc thuê ngoài. Mục đích: cho tổ chức "cảm" được làm dự án AI là thế nào.
2. **Build an in-house AI team (Xây đội AI nội bộ):** bắt đầu bằng việc tuyển **một trưởng nhóm AI giỏi**, làm việc liên chức năng với các phòng ban; đội tập trung, phát triển nền tảng dùng chung toàn công ty. Đội mới có thể trực thuộc CTO, CIO, CDO hoặc một CAIO mới.
3. **Provide broad AI training (Đào tạo AI rộng khắp):** không chỉ kỹ sư — quản lý, trưởng bộ phận, lãnh đạo cấp cao đều học cách **suy nghĩ về AI** ở độ sâu phù hợp với vai của mình.
4. **Develop an AI strategy (Xây chiến lược AI):** **không làm bước này đầu tiên** — công ty định chiến lược trước khi thử AI thường ra chiến lược rất học thuật. Sau khi có kinh nghiệm, xây chiến lược dựa trên **virtuous cycle of AI (vòng tròn tốt):** sản phẩm tốt hơn → nhiều người dùng hơn → nhiều dữ liệu hơn → sản phẩm tốt hơn nữa → tạo lợi thế phòng thủ theo thời gian. Kèm chiến lược dữ liệu, hiệu ứng mạng, lợi thế nền tảng.
5. **Develop internal and external communications (Truyền thông trong + ngoài):** quan hệ nhà đầu tư, chính phủ, giáo dục người dùng, tuyển dụng, truyền thông nội bộ về cách dùng AI và các lo ngại — minh bạch để tạo lòng tin.

### 3.4. Cạm bẫy cần tránh + bức tranh ứng dụng/kỹ thuật

- **5 cạm bẫy:** kỳ vọng AI giải quyết mọi thứ; thuê 2–3 ML engineer rồi trông chờ họ tự tìm use case (phải ghép kỹ thuật + kinh doanh, làm liên chức năng); kỳ vọng dự án AI chạy ngay lần đầu (phải lên kế hoạch lặp đi lặp lại); áp nguyên quy trình lập kế hoạch truyền thống (phải cùng đội AI xây quy trình mới); nghĩ rằng cần kỹ sư AI siêu sao mới bắt đầu (cứ bắt đầu với đội đang có, vừa làm vừa xây đội).
- **Lĩnh vực ứng dụng lớn:** Computer Vision, NLP, Robotics, ML tổng quát (dữ liệu có cấu trúc + phi cấu trúc). Dữ liệu có cấu trúc thường đặc thù từng công ty nên ít lên báo; dữ liệu phi cấu trúc (ảnh, âm thanh, text) được truyền thông đưa nhiều hơn — nhưng cả hai đều đang tạo giá trị kinh tế lớn.
- **Kỹ thuật chính (khảo sát):** Unsupervised Learning, Transfer Learning, Reinforcement Learning, GANs, Knowledge Graphs.

## 4. Tuần 4 — AI and Society (AI và xã hội)

- **Cái nhìn thực tế:** có người quá lạc quan (tin vào siêu trí tuệ) và người quá bi quan (tin vào mùa đông AI). Sự thật ở giữa: AI không làm được mọi thứ, nhưng **sẽ biến đổi các ngành**.
- **Thiên kiến / phân biệt đối xử:** AI thiên kiến **qua dữ liệu nó nhận được**. Ví dụ trong khóa: công cụ tuyển dụng phân biệt phụ nữ; nhận diện khuôn mặt kém hơn trên da tối. Cách khắc phục: dữ liệu bao hàm hơn, quy trình audit, đội ngũ đa dạng hơn. Đây là bản tóm lược phi kỹ thuật của toàn bộ khóa 139 (fairness metrics, 6 nguồn bias, mitigation 3 họ) — 142 chỉ nêu vấn đề, 139 dạy cách đo + sửa.
- **Tấn công đối kháng (adversarial attacks):** thay đổi gần như không nhận thấy trên ảnh/dữ liệu có thể đánh lừa model (vd: vẽ graffiti lên biển stop khiến AI không nhận ra). Có biện pháp phòng thủ nhưng tốn chi phí — có thể thành cuộc chạy đua vũ trang. Nối 137 (red-teaming): 142 nêu nguy cơ, 137 dạy cách tấn công thử có hệ thống.
- **Sử dụng xấu (adverse uses):** DeepFake, ảnh/video giả, bình luận giả mạo vì mục đích xấu; chính phủ dùng AI để giám sát đàn áp.
- **AI và nước đang phát triển:** làm sao để AI tạo của cải và nâng đỡ mọi quốc gia, không chỉ nước giàu. Gợi ý: đóng góp cho cộng đồng AI, tập trung AI vào ngành dọc thế mạnh của nước mình, hợp tác công–tư, đầu tư giáo dục. Ng nhấn mạnh AI còn rất non trẻ nên còn nhiều cơ hội cho người học và lãnh đạo mới.
- **AI và việc làm:** báo cáo McKinsey được trích: **400–800 triệu việc làm bị thay thế và 555–890 triệu việc làm mới được tạo ra vào 2030**. Cách ứng phó được đề xuất: thu nhập cơ bản có điều kiện gắn với học tập, xã hội học tập suốt đời, giải pháp chính trị. Lời khuyên cá nhân của Ng: **học và áp dụng AI lên trên chuyên môn sẵn có** của mình để trở nên độc nhất — đừng đổi nghề, hãy cộng AI vào nghề đang làm.
- **Kết luận — "smart vs wise":** AI thì **thông minh (smart)** nhưng chưa **khôn ngoan (wise)**; con người phải là phía khôn ngoan — quyết định dùng AI vào việc gì, giới hạn ở đâu.

## 5. Áp dụng được ngay cho việc chung

Khóa này phi kỹ thuật, hướng quản lý — giá trị của nó không phải code mà là **khung ra quyết định**. Áp dụng cho team (nối các báo cáo trước):

1. **Chọn dự án AI bằng giao nhau 3 vòng (nối 142 §2.2 + 120 §9).** Trước khi team nhận một tool/probe mới dùng Gemini: hỏi 3 câu — (a) kỹ thuật làm được không (quy tắc 1 giây + thẩm định nhỏ)? (b) có giá trị thật cho Anh/team không (tiết kiệm thời gian, giảm lỗi)? (c) có dữ liệu để đo không (bộ case test)? Thiếu (c) thì đừng bắt đầu — đúng lỗi từng gặp ở task 112 (kẹt vì không có cách đo). *Áp dụng ngay:* thêm 3 câu này vào checklist khi muse-main chia task build/probe.
2. **Tiêu chí chấp nhận + test set trước khi build (nối 142 §2.3 + 132 evals).** Khi Anh giao "làm extension X", task nên ghi sẵn tiêu chí chấp nhận (vd: "validate PASS, device test code 0, install 200" — team đã làm đúng điều này) và bộ case đo. Đây chính là thực hành "specify acceptance criteria + provide a test set" của khóa, team đã áp dụng mà chưa gọi tên.
3. **Playbook 5 bước thu nhỏ cho team (nối 142 §3.3).** Team 3 Muse thực chất đang chạy playbook thu nhỏ: pilot (task 112 Otofun forum — thí điểm loại nội dung mới) → đội nội bộ (3 Muse + phân vai §9) → đào tạo rộng (chuỗi tự học 118–142) → chiến lược (registry + ROADMAP, chọn nguồn theo backlog) → truyền thông (báo Anh 1 tin sau mỗi task). Bài học từ bước 4: **đừng viết chiến lược trước khi thử** — đúng cách team làm: thử probe trước, chốt nguồn sau (vd: Tinhte task 141 sau khi probe 200).
4. **Cạm bẫy "kỳ vọng 100%" trong review (nối 142 §2.3 + §3.4).** Extension đọc web không bao giờ đạt 100% (site đổi layout, chống bot, font encryption — xem 098/107). Review nên chấm theo **ngưỡng chấp nhận đã định trước** (validate PASS + device test), không đòi hoàn hảo — và ghi rõ giới hạn đã biết vào task (như 139 §5.5 đề xuất model card cho tool).
5. **Tự động hóa tác vụ, không phải công việc (nối 142 §2.2).** Khi Anh hỏi "AI làm được gì cho xưởng": ứng viên tốt theo quy tắc 1 giây là **kiểm tra lỗi bao bì bằng thị giác** (nhìn 1 giây là thấy lỗi), **đọc log OEE**, **phân loại tài liệu** — không phải "viết báo cáo 50 trang thay anh". Khung này giúp trả lời câu hỏi "AI làm được gì ở FrieslandCampina" mà không thổi phồng.
6. **Build vs buy cho tool của team (nối 142 §2.3).** Dùng Gemini API free tier / Meta Model API (đã chốt ở Fleet Console) thay vì tự train model — đúng quy tắc "mua thứ thành chuẩn ngành, tự làm thứ chuyên biệt tạo lợi thế" (extension vBook là thứ chuyên biệt, model là thứ chuẩn ngành).

## 6. Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill research — thêm recipe "Chọn dự án AI: giao nhau 3 vòng" (từ §2.2 + §5.1):** khả thi kỹ thuật + giá trị kinh doanh + có dữ liệu để đo; thiếu vòng nào thì dừng hoặc thu nhỏ pilot. Kèm quy tắc "tự động hóa tác vụ, không phải công việc" và quy tắc 1 giây để sàng lọc nhanh ý tưởng AI.
2. **Skill research — thêm mục "Playbook 5 bước thu nhỏ cho team" (từ §3.3 + §5.3):** pilot 6–12 tháng → đội nội bộ → đào tạo → chiến lược sau khi thử → truyền thông; kèm cảnh báo "đừng viết chiến lược trước khi thử" (đã đúng với cách team probe trước, chốt nguồn sau).
3. **Không đề xuất sửa `vbook-extension-building`:** khóa này không dạy kỹ thuật build; hai thực hành liên quan (tiêu chí chấp nhận + test set) team đã có trong PROTOCOL §4.
4. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc phân vai §9/§10 vẫn đứng vững.

## 7. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa xem video gốc của khóa:** nội dung khóa nằm sau trang Coursera/DeepLearning.AI (video + quiz, cần tài khoản miễn phí để xem). Báo cáo này học qua trang khóa chính thức (DeepLearning.AI + Coursera) + syllabus đầy đủ trên Coursera (47 mục) + ghi chú chi tiết công khai của học viên (dev.to, Montreal AI Ethics Institute, Shiksha). Các điểm trong syllabus khớp hoàn toàn với mô tả khóa; các con số (2.679.305 học viên, 4,79/5, 7 giờ) lấy trực tiếp từ trang Coursera ngày 20/11/2026.
- **Khóa ra đời trước làn sóng LLM — một số khẳng định đã lỗi thời:** nội dung gốc 2019, cập nhật 2025–2026 nhưng khung tư duy vẫn là ML cổ điển (học có giám sát, A→B). Hai điểm cần đọc với dấu hoa thị: (a) quy tắc 1 giây — LLM ngày nay làm được việc cần suy nghĩ lâu hơn 1 giây (viết báo cáo, lập kế hoạch); (b) "ML không viết được báo cáo 50 trang" — GenAI hiện viết được bản nháp dài, dù vẫn cần người kiểm chứng (nối 120 §10: grounding + evals). Khóa này dạy **chọn dự án và tổ chức**, không dạy GenAI — muốn học GenAI thì xem khóa 119/121 (đã học) hoặc khóa "Generative AI for Everyone" (không nằm trong danh sách 32 đã duyệt — cần muse-main quyết nếu muốn thêm).
- **Số liệu McKinsey là ước tính cũ:** $13.000 tỷ/năm vào 2030 và 400–800 triệu việc làm bị thay thế / 555–890 triệu việc làm mới — đều từ báo cáo McKinsey 2017–2018, trích trong khóa; dùng làm định hướng, không phải số liệu 2026.
- **Số liệu Coursera thay đổi theo thời gian:** số học viên/đánh giá ghi ngày 20/11/2026; giá chứng chỉ $49 lấy từ FAQ DeepLearning.AI (Coursera chỉ hiện giá sau khi đăng nhập).
- **Lưu ý vận hành:** task 142 claim trơn tru bằng `claim-task.sh` (khác 139: lần này file task để `assignee` trống nên script không từ chối). WIP commit trong 15 phút sau claim theo PROTOCOL §2.4.

## Nguồn

- Trang khóa chính thức — DeepLearning.AI (outline 4 tuần, FAQ $49/180 ngày, 2–3h/tuần, xuất bản 2025-06-27): https://www.deeplearning.ai/courses/ai-for-everyone
- Trang khóa trên Coursera (2.679.305 học viên, 53.559 đánh giá, 4,79/5, 7 giờ, 4 module, Beginner): https://www.coursera.org/learn/ai-for-everyone
- Syllabus đầy đủ theo tuần (Shiksha, liệt kê từng bài): https://www.shiksha.com/online-courses/ai-for-everyone-course-courl261
- Ghi chú chi tiết từng tuần + Playbook 5 bước (DEV, 2023): https://dev.to/jingjing142/ai-for-everyone-18h8
- Phân tích khóa + Playbook + Virtuous Cycle (Montreal AI Ethics Institute): http://montrealethics.ai/andrew-ngs-ai-for-everyone-the-definitive-starting-block-for-ai-novices/
- Đối chiếu FREE/chứng chỉ + tổng thời lượng 6h57 (The AI School, 27/10/2026): https://the-aischool.com/guides/ai-for-everyone-review
- Danh sách 32 khóa đã duyệt (bằng chứng Ú đọc bằng browser thật 20/11 21:57): `research/140-governing-ai-agents-deeplearning-ai.md` trên branch `feature/140-tu-hoc-governing-ai-agents-deeplearning-ai` — khóa này là số 2
- Báo cáo nối tiếp trong repo: `research/118-elements-of-ai.md` (intro AI khác, ĐH Helsinki), `research/120-prompt-design-in-vertex-ai-google.md` (§9 evals, §10 safety), `research/132-evaluating-and-improving-agentic-applications-deeplearning-ai.md` (evals theo pipeline), `research/137-tu-hoc-red-teaming-llm-applications-deeplearning-ai.md` (tấn công thử), `research/139-responsible-ai-for-developers-google.md` (fairness/adversarial bản chuyên sâu)

## Kết luận

Khóa ngắn (7 giờ, Beginner, phi kỹ thuật) nhưng là khóa **đổi cách ra quyết định** chứ không chỉ thêm kiến thức: trước 142, team đã biết viết prompt (120), đo prompt (132), chặn lúc chạy (135), đo thiên kiến (139) — nhưng chưa có khung để trả lời "chọn dự án AI nào, làm với ai, theo trình tự nào, kỳ vọng bao nhiêu là đủ". Sau 142, khung đó đã đủ: **chọn dự án ở giao nhau 3 vòng (khả thi + giá trị + có dữ liệu) → làm việc với đội AI bằng tiêu chí chấp nhận + test set → đưa AI vào tổ chức theo Playbook 5 bước (pilot trước, chiến lược sau) → nhìn xã hội bằng con mắt thực tế (AI thông minh nhưng chưa khôn ngoan)**. Điểm nối quan trọng nhất với việc chung: team đã vô thức chạy đúng playbook thu nhỏ (probe trước, chốt nguồn sau; tiêu chí chấp nhận ghi sẵn trong task) — khóa này chỉ gọi tên nó ra, để lần sau làm có chủ đích thay vì theo bản năng. Hạn chế lớn nhất cũng rõ ràng: khóa ra đời trước LLM, nên quy tắc 1 giây và danh sách "ML không làm được" phải đọc kèm với kiến thức GenAI ở 119/121, không áp dụng máy móc.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** trong danh sách 32 còn nhiều khóa chưa ai nhận; theo phân vai research của Vịt, ứng viên nhẹ tiếp theo là **#4 "Work smarter with AI" (Microsoft Learn)** — ngắn, thực hành, nối trực tiếp 142 (dùng AI trong công việc hàng ngày). Các ứng viên khác trong danh sách: #5 AI Fluency (Anthropic — thuộc lane muse-main theo §9), #11 AI Agents in LangGraph / #13 Agentic AI (DeepLearning.AI — thuộc lane build của Ú theo §9).
