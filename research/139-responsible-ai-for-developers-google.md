# Responsible AI for Developers (Google) — Báo cáo tự học (task 139)

- **Khóa học:** Specialization "Responsible AI for Developers" (Google Cloud) — 3 khóa: Fairness & Bias, Interpretability & Transparency, Privacy & Safety
- **Trang khóa:** Google Skills (xem bảng kiểm chứng §0); Coursera: https://www.coursera.org/specializations/responsible-ai-for-developers
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung, **không đăng ký chứng chỉ trả phí** (theo checklist task 139). **Không chạy lab GCP tốn credit** — nội dung khóa nằm sau trang Skills Boost (video + quiz + lab, cần đăng nhập tài khoản Google Cloud để học). Báo cáo này học qua trang khóa chính thức, syllabus trên Class Central/Coursera, tài liệu chính thức của Google Cloud (AI Principles, Fairness Indicators, Vertex AI Explainable AI, Differential Privacy, Safety in Vertex AI, Model Armor) và tài liệu học thuật chuẩn về fairness/privacy.
- **Quy mô:** 3 khóa, Intermediate, tổng ~9–12 giờ (Skills ghi 4h + 2h + 3h45; Coursera ghi 5h + 3h + 5h — hai hệ thống tính khác nhau, xem §0). Học theo thứ tự 1 → 2 → 3, theo khuyến nghị chính thức của Coursera.
- **Vị trí trong vòng tự học:** khóa 13 theo phân vai (sau 138 Introduction to Vertex AI Studio). Đây là **khóa đóng vòng an toàn**: sau khi biết viết prompt (120), đóng app (121), tune/deploy (138), khóa này dạy **làm sao cho an toàn và đo được thiên kiến** — phần còn thiếu sau khi 120 §10 chỉ chạm safety filter ở mức cấu hình.

## 0. Kiểm chứng 3 khóa tồn tại và FREE trên Skills Boost (checklist mục 1) — ĐẠT

| # | Khóa | Skills Boost (Google Skills) | Coursera | FREE? |
|---|---|---|---|---|
| 1 | Responsible AI for Developers: Fairness & Bias | Template 985 — 4 giờ, Intermediate, xuất bản 2026-06-15, rating 4.25/5 (10.299 reviews), 5 modules | 5 modules, ~1.862 học viên đã đăng ký | ✅ |
| 2 | Responsible AI for Developers: Interpretability & Transparency | Template 989 — 2 giờ, Intermediate, 4 modules | 4 modules, 3 giờ, 13 reviews | ✅ |
| 3 | Responsible AI for Developers: Privacy & Safety | Template 1036 — 3 giờ 45 phút, Intermediate, xuất bản 2025-09-10, rating 4.16/5 (12.975 reviews), 5 modules | 5 modules, 5 giờ, ~2.260 học viên | ✅ |

**Mô hình FREE của Google Skills (đã kiểm chứng):** gói Starter không tốn tiền — video khóa học miễn phí, 35 credit lab mỗi tháng, badge miễn phí; gói Pro $29/tháng chỉ gỡ giới hạn credit lab. Trên Coursera, "Enroll for free" là học audit miễn phí; **chứng chỉ phải trả tiền** (FAQ Coursera ghi rõ "you cannot take this course for free" khi nói về chứng chỉ). Vì vậy: **nội dung học được miễn phí hoàn toàn; chỉ chứng chỉ/badge hoàn thành lab mới tốn tiền/credit.** Báo cáo này không đăng ký chứng chỉ, không chạy lab — giống cách làm ở task 138.

**Applied Learning Project của Specialization (4 hands-on project, theo Coursera):** giảm thiên kiến bằng TensorFlow Model Remediation library; kỹ thuật Explainable AI với Vertex AI; train ML bảo mật privacy bằng DP-SGD; bảo vệ hệ GenAI bằng Gemini. Cả 4 project đều nằm trong lab cần credit — báo cáo này học **nguyên lý + công cụ** của từng project qua tài liệu chính thức, không chạy code lab.

## Cấu trúc 3 khóa (syllabus)

| Khóa | Module chính | Câu hỏi trung tâm |
|---|---|---|
| 1. Fairness & Bias (5 modules) | Responsible AI + AI Principles của Google; thiên kiến là gì, từ đâu ra; nhận diện thiên kiến bằng dữ liệu và mô hình; giảm thiên kiến bằng công cụ Google Cloud + open source | "Model có đối xử bất công với nhóm người nào không, và sửa bằng gì?" |
| 2. Interpretability & Transparency (4 modules) | Định nghĩa interpretability/transparency; vì sao cần; công cụ và kỹ thuật đạt được trong dữ liệu và model | "Vì sao model quyết định như vậy, và giải thích được cho ai?" |
| 3. Privacy & Safety (5 modules) | AI privacy; AI safety; phương pháp + công cụ thực hành bằng Google Cloud + open source | "Dữ liệu người dùng có rò qua model không, và hệ GenAI có bị phá không?" |

## 1. Khóa 1 — Fairness & Bias: thiên kiến ở đâu, đo bằng gì, sửa bằng gì

### 1.1. Nền: 7 AI Principles của Google (công bố 06/2018)

1. Mang lại lợi ích xã hội; 2. Tránh tạo ra hoặc củng cố thiên kiến bất công; 3. Được xây dựng và kiểm tra về an toàn; 4. Có trách nhiệm giải trình với con người; 5. Tích hợp nguyên tắc thiết kế bảo mật (privacy by design); 6. Tuân thủ tiêu chuẩn cao về khoa học; 7. Chỉ dùng cho mục đích phù hợp với các nguyên tắc này. Kèm 4 lĩnh vực Google cam kết **không** làm AI: gây hại tổng thể; vũ khí; giám sát vi phạm chuẩn mực quốc tế; vi phạm luật pháp/quyền con người. Nguyên tắc 2 là xương sống của khóa 1; nguyên tắc 3 và 5 là cầu sang khóa 3.

### 1.2. Sáu nguồn thiên kiến — thiên kiến chui vào ở mọi khâu pipeline

| Nguồn | Cơ chế | Ví dụ |
|---|---|---|
| **Historical bias** (lịch sử) | Dữ liệu phản ánh đúng một thế giới vốn đã bất công | Lịch sử thăng chức thiên về một nhóm → model học theo |
| **Representation bias** (đại diện) | Nhóm nào đó thiếu mẫu trong dữ liệu train | Ảnh bệnh da chủ yếu da sáng → model kém trên da tối |
| **Measurement bias** (đo lường) | Thứ đo được chỉ là proxy kém cho thứ cần đo | Dùng chi tiêu y tế làm proxy cho nhu cầu sức khỏe, trong khi có nhóm xưa nay ít được chăm sóc hơn |
| **Aggregation bias** (gộp nhóm) | Một model cho nhiều nhóm khác nhau về bản chất | Một ngưỡng lâm sàng chung, kém hiệu quả với một số nhóm |
| **Evaluation bias** (đánh giá) | Dữ liệu test không phản ánh người dùng thật | Nhận diện giọng nói chỉ benchmark trên một giọng |
| **Deployment bias** (triển khai) | Hệ thống bị dùng ở bối cảnh không thiết kế cho nó | Công cụ làm cho một nước, đem dùng ở nước khác |

Điểm mấu chốt của khóa: **thiên kiến không phải lỗi của một bước** — nó chui vào từ thu thập dữ liệu, gán nhãn, chọn feature, train, đánh giá, tới triển khai. Vì vậy sửa thiên kiến cũng phải sửa ở đúng khâu gây ra nó, không có một nút bấm chung.

### 1.3. Đo thiên kiến bằng gì — các định nghĩa công bằng (fairness metrics)

Không có một định nghĩa "công bằng" duy nhất. Bốn định nghĩa hay dùng nhất (cho phân loại nhị phân, nhóm được bảo vệ A vs B):

| Metric | Công thức (nói gọn) | Hỏi câu gì | Khi nào dùng |
|---|---|---|---|
| **Demographic parity** (tỷ lệ chọn bằng nhau) | P(Ŷ=1\|A) = P(Ŷ=1\|B) | "Hai nhóm được chọn với tỷ lệ bằng nhau không?" | Khi kết quả tích cực là cơ hội (việc làm, vay) và muốn chia đều |
| **Equal opportunity** (cơ hội bằng nhau) | TPR bằng nhau: P(Ŷ=1\|Y=1,A) = P(Ŷ=1\|Y=1,B) | "Người đủ điều kiện ở hai nhóm có cơ hội được chọn như nhau không?" | Khi bỏ sót người xứng đáng là hại chính (tuyển dụng, cho vay) |
| **Equalized odds** (tỷ lệ cân bằng) | TPR và FPR đều bằng nhau | "Cả sai sót loại 1 và loại 2 đều bằng nhau giữa hai nhóm?" | Khi cả hai loại sai đều đắt (tư pháp, y tế) |
| **Predictive parity** (dự đoán bằng nhau) | Precision bằng nhau: P(Y=1\|Ŷ=1,A) = P(Y=1\|Ŷ=1,B) | "Khi model nói 'đạt', tỷ lệ đúng thật có bằng nhau không?" | Khi quyết định dựa trên độ tin cậy của dự đoán dương |

Kèm theo: **disparate impact** (quy tắc 80% — tỷ lệ chọn của nhóm thiểu số < 80% nhóm đa số thì nghi ngờ phân biệt đối xử gián tiếp) và **calibration** (điểm số 0.8 phải nghĩa là 80% đúng ở mọi nhóm).

**Định lý bất khả (impossibility theorem — Kleinberg, Mullainathan & Raghavan):** trừ trường hợp đặc biệt (base rate bằng nhau hoặc model hoàn hảo), **không thể thỏa mãn đồng thời** demographic parity, equalized odds và calibration. Hệ quả thực hành: **chọn metric là quyết định chính sách, không phải quyết định kỹ thuật** — phải ghi rõ "team chọn metric X vì hại Y là hại chính trong use case này" trước khi đo. Đây là điểm khóa 1 nhấn mạnh nhất, và là lý do §4 của báo cáo này viết quy tắc chọn metric.

### 1.4. Sửa thiên kiến bằng gì — ba họ mitigation + công cụ Google

| Họ | Can thiệp ở đâu | Kỹ thuật tiêu biểu | Công cụ |
|---|---|---|---|
| **Pre-processing** (sửa dữ liệu) | Trước khi train | Reweighting (tăng trọng số nhóm thiểu số), resampling, sửa nhãn, bỏ feature proxy (vd: mã bưu điện proxy cho chủng tộc) | Fairness Indicators + TFMA để đo trước/sau |
| **In-processing** (sửa lúc train) | Trong lúc train | Adversarial debiasing (train thêm bộ phân biệt nhóm, ép model "quên" nhóm), **MinDiff** (thêm penalty vào loss để ép FPR/FNR bằng nhau giữa các nhóm) | **TensorFlow Model Remediation library** (project thực hành của khóa) |
| **Post-processing** (sửa đầu ra) | Sau khi có dự đoán | Tối ưu ngưỡng riêng cho từng nhóm để cân bằng TPR/FPR; hiệu chỉnh điểm số | Fairness Indicators đánh giá trên nhiều ngưỡng |

**Bộ công cụ đo (không sửa, chỉ đo — phải đo trước mới biết sửa gì):**
- **Fairness Indicators** (TensorFlow, tích hợp TFMA): tính + vẽ các fairness metric (FPR, FNR...) theo từng slice (nhóm người dùng), kèm khoảng tin cậy để biết chênh lệch có ý nghĩa thống kê không; tích hợp **What-If Tool** để bấm vào một slice xem từng điểm dữ liệu, thử counterfactual ("đổi giới tính thì dự đoán đổi không?").
- **Model Cards** (tài liệu đi kèm model): ghi rõ model làm gì, train trên dữ liệu nào, hiệu năng theo từng nhóm, giới hạn sử dụng — chính là "báo cáo minh bạch" của khóa 2, dùng để công bố kết quả đo thiên kiến.
- **Datasheets for Datasets:** tài liệu đi kèm dữ liệu — thu thập thế nào, ai gán nhãn, thiếu nhóm nào.

**Thiên kiến trong GenAI (điểm mới so với ML cổ điển):** model ngôn ngữ học được liên tưởng khuôn mẫu từ văn bản (vd: nghề nghiệp gắn giới tính), và thiên kiến thể hiện qua **cách sinh văn bản** chứ không qua một nhãn phân loại — nên metric phân loại ở §1.3 không áp dụng trực tiếp. Cách đo cho GenAI: bộ prompt đối chứng (cùng một prompt, đổi tên/nhóm người được nhắc tới, so sánh đầu ra), đo tỷ lệ khuôn mẫu trong đầu ra, và dùng LLM judge đã hiệu chuẩn (nối 132). **Chưa xác định** ngưỡng "đủ công bằng" nào là chuẩn cho GenAI — không có con số như quy tắc 80% của phân loại; team dùng GenAI phải tự đặt ngưỡng + ghi rõ trong model card.

## 2. Khóa 2 — Interpretability & Transparency: giải thích được quyết định của model

### 2.1. Ba cặp phân biệt phải nắm trước khi chọn công cụ

- **Interpretability (diễn giải được) vs Explainability (giải thích được):** interpretability là model **tự nó** trong suốt (cây quyết định nhỏ, hồi quy tuyến tính — nhìn là hiểu); explainability là tạo ra lời giải thích **sau khi** model đen (transformer) đã quyết định. Model càng chính xác thường càng kém diễn giải — phải đánh đổi có chủ đích.
- **Global (toàn cục) vs Local (cục bộ):** global giải thích hành vi chung của model trên toàn bộ dữ liệu (feature nào quan trọng nhất nói chung); local giải thích **một dự đoán cụ thể** ("vì sao hồ sơ này bị từ chối"). Debug thiên kiến cần cả hai: global thấy feature "giới tính" quan trọng bất thường; local thấy hồ sơ cụ thể nào bị ảnh hưởng.
- **Intrinsic (nội tại) vs Post-hoc (hậu nghiệm):** intrinsic là model được thiết kế để diễn giải được từ đầu (concept bottleneck); post-hoc là gắn công cụ giải thích lên model đã train xong (SHAP, LIME...). Hầu hết công cụ của Google là post-hoc.

### 2.2. Các kỹ thuật giải thích — chọn theo loại model

| Kỹ thuật | Cơ chế (nói gọn) | Dùng cho | Hạn chế cần nhớ |
|---|---|---|---|
| **SHAP / Sampled Shapley** | Chia "công" cho từng feature theo lý thuyết trò chơi (giá trị Shapley, 1952): feature nào làm thay đổi dự đoán bao nhiêu | Model bảng (tabular), model không khả vi (cây, ensemble) | Đắt tính toán (xét nhiều tổ hợp feature); Sampled Shapley chỉ xấp xỉ |
| **Integrated Gradients** | "Mờ dần" input từ baseline trống tới input thật, tích lũy gradient dọc đường — feature nào làm output đổi nhiều thì quan trọng | Mạng nơ-ron khả vi, ảnh (pixel nào quyết định class) | Chỉ dùng cho model khả vi; baseline chọn sai thì kết quả lệch |
| **XRAI** | Chia Integrated Gradients theo vùng ảnh đã phân đoạn, xếp hạng vùng | Phân loại ảnh tự nhiên (nhà, động vật) | Kém trên ảnh nhân tạo (X-quang, ảnh kiểm tra chất lượng) — dùng Integrated Gradients thay |
| **LIME** | Xây model đơn giản (surrogate) bắt chước model phức tạp **quanh một điểm dự đoán** | Mọi loại model, giải thích cục bộ nhanh | Surrogate có thể không trung thực với model thật ở xa điểm đó |
| **Counterfactual** | "Đổi tối thiểu input để dự đoán đổi" — vd: tăng thu nhập X thì hồ sơ được duyệt | Giải thích cho người bị từ chối: cho biết phải thay đổi gì | Counterfactual tìm được có thể không khả thi trong đời thật |
| **Example-based** (Vertex AI) | Trả về các ví dụ train gần nhất với input | Phân tích lỗi phân loại, active learning (chọn mẫu nào gán nhãn tiếp) | Cần tập dữ liệu tham chiếu tốt |

### 2.3. Vertex AI Explainable AI — công cụ chính của khóa

Vertex AI tích hợp feature attribution thẳng vào quy trình deploy: khi tạo model, cấu hình `explanationSpec` chọn 1 trong 3 phương pháp — **Sampled Shapley** (tabular, model không khả vi), **Integrated Gradients** (tabular + ảnh, model khả vi), **XRAI** (ảnh) — cộng thêm example-based explanations. AutoML tabular tự cấu hình sẵn, không cần chỉnh. Khi gọi `explain`, API trả về **attribution cho từng feature của từng dự đoán** (top-K feature quan trọng nhất), dùng được cả online lẫn batch. Ngoài ra: **What-If Tool** (dashboard tương tác: xem feature overview, thử đổi feature, xem counterfactual) và **Language Interpretability Tool (LIT)** (phát hiện thiên kiến trong model NLP).

### 2.4. Transparency — giải thích cho ai, bằng tài liệu gì

- **Model Cards:** một trang mô tả model — làm gì, dùng cho ai, train trên dữ liệu nào, hiệu năng theo từng nhóm (số liệu Fairness Indicators §1.4), giới hạn + cảnh báo. Đây là "hợp đồng minh bạch" giữa người làm model và người dùng model; khóa yêu cầu mọi model production đều có model card.
- **Minh bạch dữ liệu:** datasheet cho dataset + ghi lineage (dữ liệu từ đâu, qua bước xử lý nào) — nối 136 (data lineage) và 129 (RAG: biết câu trả lời từ tài liệu nào).
- **Minh bạch với GenAI — giới hạn quan trọng:** LLM giải thích quyết định của chính nó bằng ngôn ngữ tự nhiên, nhưng lời giải thích đó là **văn bản được sinh ra sau** (post-hoc rationalization), không phải bản ghi quá trình suy luận thật. Vì vậy **không dùng lời tự giải thích của LLM làm bằng chứng** — bằng chứng phải là: citation tới nguồn (grounding/RAG, 120 §10 + 129), log prompt + tham số + version model, và safety rating kèm theo response. Đây là điểm nối trực tiếp sang khóa 3: minh bạch của GenAI phải dựa vào **dấu vết kiểm chứng được**, không dựa vào lời model tự nói.

## 3. Khóa 3 — Privacy & Safety: dữ liệu không rò qua model, hệ GenAI không bị phá

### 3.1. Differential Privacy (DP) — bảo mật có con số, không phải lời hứa

**Định nghĩa (ε, δ)-DP:** một thuật toán ngẫu nhiên M là (ε, δ)-DP nếu với mọi cặp dataset kề nhau D, D' (khác nhau đúng 1 bản ghi) và mọi tập đầu ra S: `Pr[M(D) ∈ S] ≤ e^ε · Pr[M(D') ∈ S] + δ`. Nói bằng lời: **đầu ra gần như không đổi dù có hay không có dữ liệu của một người cụ thể** — nên đầu ra không thể tiết lộ gì về người đó, bất kể kẻ tấn công đã biết gì khác (điểm mà ẩn danh hóa truyền thống thất bại: bản ghi đã xóa tên vẫn bị tái nhận diện bằng cách nối với cơ sở dữ liệu khác).

| Khái niệm | Nội dung |
|---|---|
| **ε (epsilon) — ngân sách riêng tư** | ε càng nhỏ, riêng tư càng mạnh, nhiễu càng lớn, kết quả càng kém chính xác. ε = 0.1: kẻ tấn công đoán đúng ~52,5% (gần tung đồng xu); ε = 1: ~73%. Thực tế: Census Mỹ 2020 dùng ε = 19,61 tổng; Apple dùng ε = 1–2 mỗi điểm dữ liệu; Gboard của Google đạt ρ = 0,81 (zCDP) ở mức người dùng. **Không có ε "chuẩn" chung** — chọn ε là quyết định chính sách theo độ nhạy dữ liệu. |
| **δ (delta)** | Xác suất nhỏ cho phép bảo đảm bị phá vỡ; đặt δ < 1/n (n = cỡ dataset). |
| **Cơ chế thêm nhiễu** | Laplace (nhiễu theo độ nhạy L1, DP thuần δ = 0) và Gaussian (nhiễu theo độ nhạy L2, DP xấp xỉ). Nhiễu tỉ lệ với **độ nhạy** — một bản ghi làm kết quả đổi tối đa bao nhiêu (vd: đếm thì đổi tối đa 1). |
| **Ngân sách tích lũy** | Hỏi k lần, mỗi lần ε, tốn tối đa k·ε — tổ chức phải đặt **privacy budget** cho dataset và dừng trả lời khi hết. |
| **Central vs Local DP** | Central: bên giữ dữ liệu đáng tin thấy dữ liệu thô, thêm nhiễu vào đầu ra. Local: mỗi người dùng tự thêm nhiễu trước khi gửi đi (tốn ε lớn hơn ~√n lần). |
| **DP-SGD** (Abadi và cộng sự, Google 2016) | Train model với DP: cắt (clip) gradient của từng ví dụ về một norm tối đa (không ví dụ nào kéo trọng số quá xa) + cộng nhiễu Gaussian vào gradient tổng của mỗi batch + dùng **privacy accountant** theo dõi tổng ε đã tiêu qua các bước train. Kết quả: giới hạn được mức model ghi nhớ từng ví dụ — trực tiếp chống **membership inference attack** (đoán xem một người có trong dữ liệu train không). Ví dụ 2025: VaultGemma — LLM 1 tỷ tham số của Google, pretrain hoàn toàn bằng DP-SGD ở ε ≤ 2,0. Đây là project thực hành của khóa. |

### 3.2. Federated Learning (FL) — dữ liệu ở lại thiết bị, chỉ cập nhật model di chuyển

Mỗi thiết bị (điện thoại, bệnh viện) tải model hiện tại về, train trên dữ liệu local, **chỉ gửi về thay đổi trọng số**; server trung tâm trung bình các thay đổi rồi cập nhật model toàn cục. Dữ liệu thô không bao giờ rời khỏi thiết bị. Nhưng FL **một mình chưa đủ riêng tư**: gradient gửi về vẫn có thể bị đảo ngược để tái tạo dữ liệu gốc (tấn công Deep Leakage from Gradients — với batch nhỏ, input giả tối ưu dần tới giống input thật). Vì vậy triển khai FL đúng cần **hai lớp**: **Secure Aggregation** (mã hóa để server chỉ thấy tổng, không thấy từng cập nhật riêng) **+ DP** (clip + nhiễu, giới hạn rò rỉ qua nhiều vòng). Gboard của Google kết hợp cả ba: FL + Secure Aggregation + DP-FTRL. Các kỹ thuật bổ sung: **Homomorphic Encryption** (tính toán trên dữ liệu đã mã hóa) và **Trusted Execution Environment / Confidential Computing** (chạy trong enclave phần cứng có chứng thực).

### 3.3. An toàn GenAI — kiến trúc nhiều lớp của Vertex AI

Khóa 3 dạy **safeguarding Gemini** (project thực hành) theo kiến trúc nhiều lớp — không lớp nào đứng một mình:

| Lớp | Công cụ | Chặn cái gì |
|---|---|---|
| 1. **Model mặc định + filter không cấu hình được** | Gemini tích hợp sẵn | CSAM, SPII (thông tin cá nhân nhạy cảm), recitation (đạo văn) — **không tắt được** |
| 2. **System instructions cho an toàn** | Viết luật hành vi vào system instruction | Lệch chủ đề, giọng điệu, từ chối sai cách — "dạy" model trước thay vì chỉ chặn sau (nối 120: system instruction là luật chơi cố định) |
| 3. **Content filter cấu hình được** | Gemini Safety Settings — 4 harm category: Hate Speech, Harassment, Sexually Explicit, Dangerous Content; ngưỡng BLOCK_LOW / BLOCK_MEDIUM / BLOCK_ONLY_HIGH / OFF | Nội dung độc hại theo từng danh mục; response kèm **safety rating** (NEGLIGIBLE/LOW/MEDIUM/HIGH) kể cả khi không bị chặn |
| 4. **Gemini làm filter** | Dùng một model Gemini khác chấm output của model chính | Các ca tinh vi cần ngữ cảnh mà filter luật không bắt được |
| 5. **Model Armor** | Dịch vụ độc lập, chạy với mọi model (không riêng Gemini) | **Prompt injection / jailbreak**, PII/DLP (phát hiện + che thông tin như SSN, email, credential), URL độc hại (phishing/malware), RAI content safety |
| 6. **DLP / Sensitive Data Protection** | Quét + che PII trước khi đưa vào model và sau khi model trả lời | Rò rỉ dữ liệu nhạy cảm qua prompt hoặc qua output |

**Lưu ý thực hành quan trọng (tài liệu chính thức 2026):** Gemini 2.5 Flash trở đi mặc định safety threshold là **OFF** cho các filter cấu hình được — ứng dụng nào dựa vào chặn an toàn **phải đặt ngưỡng tường minh**, không để mặc định. Và safety filter chỉ là **rào chắn, không lái được hành vi model** — muốn model hành xử đúng thì dùng system instruction (lớp 2) + grounding (giảm ảo giác, 120 §10) chứ không chỉ trông chờ filter chặn.

### 3.4. Nối khóa 3 với 135 (guardrails) và 137 (red-teaming)

Ba khóa xếp thành **một vòng an toàn hoàn chỉnh**, mỗi khóa một thời điểm khác nhau (theo bảng phân biệt 135 §8):

| Thời điểm | Khóa | Câu hỏi | Công cụ của khóa đó |
|---|---|---|---|
| Trước phát hành, định kỳ | **137 red-teaming** (Ú đang làm) | "Người tấn công giỏi có phá được hệ thống không?" | Jailbreak/prompt injection có chủ đích, tìm lỗ hổng mới |
| Lúc chạy, từng request | **135 guardrails** + **139 §3.3** | "Request này có được qua không?" | Input/output guard, safety filter, Model Armor, NLI check |
| Ngoại tuyến, trên bộ case | **132 evals** + **139 §1.3/§4** | "Hệ thống tốt đến đâu, có hồi quy không?" | Benchmark fairness, LLM judge hiệu chuẩn, case hồi quy |
| Thiết kế, trước khi train | **139 §3.1–3.2** | "Dữ liệu có rò qua model không?" | DP, FL, secure aggregation — quyết định ở tầng kiến trúc, không vá được lúc chạy |

Vòng tròn: red-team tìm lỗ hổng → lỗ hổng thành case benchmark → case đo được thành validator/guardrail → guardrail chặn hụt ngoài đời lại thành case mới (135 §8). **DP và FL là ngoại lệ của vòng này: chúng phải quyết từ lúc thiết kế** — model đã train xong không có DP thì không thể "thêm DP vào sau"; chỉ có thể che đầu ra (DLP) hoặc train lại.

## 4. Đo thiên kiến bằng gì, khi nào cần đo (yêu cầu checklist)

### 4.1. Quy tắc chọn metric — quyết định trước khi đo

1. **Xác định hại chính của use case trước.** Bỏ sót người xứng đáng là hại chính → Equal Opportunity. Cả hai loại sai đều đắt → Equalized Odds. Kết quả là cơ hội cần chia đều → Demographic Parity. Quyết định dựa trên độ tin cậy của dự đoán dương → Predictive Parity. **Ghi lựa chọn + lý do vào model card** — không có metric mặc định đúng cho mọi việc (định lý bất khả §1.3).
2. **Luôn đo theo slice, không đo trung bình chung.** Metric tổng che mất nhóm kém — Fairness Indicators sinh ra để làm đúng việc này. Slice theo nhóm được bảo vệ **và** theo giao nhau (vd: nữ + trên 50 tuổi), vì thiên kiến giao nhau thường nặng hơn từng chiều riêng.
3. **Kèm khoảng tin cậy + cỡ mẫu.** Chênh lệch 5% trên 20 mẫu không có ý nghĩa; Fairness Indicators tính sẵn khoảng tin cậy. Nối 120 §9: đánh giá cần **200–500 ví dụ mới ổn định** — đo thiên kiến cũng vậy, slice nào dưới ~100 mẫu thì ghi "chưa đủ mẫu, chưa kết luận" thay vì báo số.
4. **Đo cả đầu vào lẫn đầu ra.** Đo phân phối dữ liệu train (representation bias) **trước khi train**; đo metric model **sau khi train**; đo lại **sau triển khai** (deployment bias + drift). Một lần đo lúc train không đủ.

### 4.2. Khi nào CẦN đo — và khi nào KHÔNG cần

| Cần đo | Vì sao |
|---|---|
| Quyết định ảnh hưởng tới con người (tuyển, vay, phân loại nội dung, xếp hạng) | Hại trực tiếp, có thể bị kiện/khiếu nại |
| Model dùng cho nhiều nhóm người dùng khác nhau | Thiên kiến chỉ lộ khi so sánh giữa các nhóm |
| Dữ liệu train lấy từ lịch sử con người (log, đánh giá, nội dung user) | Historical + representation bias gần như chắc chắn có |
| Trước mỗi lần phát hành lớn / sau mỗi lần tune lại (138 §5) | Tuning đổi hành vi model — fairness phải đo lại, không kế thừa kết quả cũ |
| Khi có khiếu nại hoặc red-team phát hiện ca lệch (137) | Đo để xác nhận mức độ + làm case hồi quy |

| Không cần đo đầy đủ | Vì sao — và vẫn làm gì tối thiểu |
|---|---|
| Task thuần kỹ thuật, không phân biệt người (vd: phân loại lỗi log, trích xuất thực thể từ tài liệu kỹ thuật) | Không có nhóm được bảo vệ bị ảnh hưởng — chỉ cần đo chất lượng chung (120 §9) |
| Demo nội bộ, chưa tới tay người dùng thật | Đo đầy đủ tốn thời gian; vẫn ghi rõ "chưa đo fairness" trong ghi chú demo để không ai tưởng đã đo |
| Không có nhãn nhóm (không biết người dùng thuộc nhóm nào) | Không đo được slice — thay bằng đo proxy (vd: đo theo ngôn ngữ/vùng) và ghi rõ hạn chế; **không được suy ra nhãn nhóm từ dữ liệu nhạy cảm để đo** (vi phạm privacy — khóa 3) |

## 5. Áp dụng được ngay cho việc chung

1. **Checklist fairness cho mọi tool dùng model của team (nối 120 §10 + 135 + 137 + 139 §4).** Trước khi đưa một tool dùng Gemini ra cho Anh dùng: (a) đặt safety thresholdtường minh theo từng category (139 §3.3 — đừng để mặc định OFF); (b) thử bộ prompt đối chứng: cùng prompt, đổi tên/nhóm người được nhắc tới, xem đầu ra có lệch không; (c) ghi "đã đo / chưa đo fairness" vào ghi chú của tool. *Áp dụng ngay:* lần tới team viết tool mới có gọi Gemini, thêm 3 bước này vào checklist task — rẻ, làm bằng tay được, không cần lab GCP.
2. **Safety filter là guardrail, không phải evaluator (nối 135 §8).** Filter chặn lúc chạy; muốn **biết** filter chặn đúng hay chặn nhầm thì phải đo ngoại tuyến trên bộ case (evals 132) — ghi lại tỷ lệ chặn nhầm (false positive) mỗi lần đổi ngưỡng. *Áp dụng ngay:* khi đặt ngưỡng BLOCK_MEDIUM hay BLOCK_ONLY_HIGH cho một tool, thử 10–20 prompt biên (nội dung nhạy cảm nhưng hợp lệ, vd: mô tả truyện có cảnh bạo lực) để xem ngưỡng có chặn nhầm không, rồi mới chốt.
3. **Prompt injection là rủi ro thật với tool đọc web (nối 137 + 139 §3.3).** Extension vBook đọc trang web rồi đưa nội dung vào model — nội dung trang có thể chứa lệnh chèn vào ("hãy bỏ qua hướng dẫn..."). *Áp dụng ngay (đề xuất, cần task riêng):* khi team có tool nào đưa nội dung web/user vào prompt Gemini, tách rõ system instruction (luật) khỏi dữ liệu (nội dung web) và cân nhắc Model Armor hoặc ít nhất một input guard kiểm tra lệnh chèn — đúng tinh thần "guardrail lúc chạy" của 135.
4. **Privacy: đừng đưa dữ liệu nhạy cảm vào prompt (nối 139 §3.1–3.2).** DP/FL là giải pháp cho bên train model; phía team (dùng model có sẵn) thì biện pháp thực tế là **data minimization**: không đưa thông tin cá nhân, credential, nội dung riêng tư vào prompt; dùng DLP che PII trước khi gửi. *Áp dụng ngay:* rà soát các prompt/script của team có dính dữ liệu thật của Anh (tên, địa chỉ, tài liệu công việc) không — nếu có, thay bằng dữ liệu giả khi test.
5. **Model card cho tool của team (nối 139 §2.4).** Mỗi tool dùng model nên có một đoạn ngắn: model nào, prompt version nào, đo trên bao nhiêu case, giới hạn biết trước (vd: "chưa đo fairness", "chỉ test trên 8 case"). *Áp dụng ngay:* thêm mục này vào file task/result notes — team đã làm gần giống (validate/device/install), chỉ thiếu dòng "giới hạn đã biết".
6. **Đo thiên kiến phải đo lại sau mỗi lần tune (nối 138 §5 + 139 §4.1).** Đề xuất tuning Flash ở 138 §8.5 (tune trên 100–500 ví dụ mô tả truyện) — nếu làm, phải đo fairness trước/sau tune trên cùng bộ case, vì tuning có thể khuếch đại thiên kiến trong dữ liệu mẫu. *Áp dụng ngay:* ghi vào task tuning tương lai (nếu có): "đo fairness trước/sau" là một mục checklist.

## 6. Đề xuất cập nhật skill

Đề xuất cho muse-main xem xét (chưa tự sửa skill chung — skill do chị cả giữ):

1. **Skill research — thêm recipe "Vòng an toàn 4 khâu" (từ §3.4):** thiết kế (DP/FL nếu train) → đo ngoại tuyến (evals + fairness theo slice) → chặn lúc chạy (guardrail + safety filter + Model Armor) → kiểm toán tấn công định kỳ (red-team). Kèm quy tắc "DP/FL phải quyết từ thiết kế, không vá lúc chạy".
2. **Skill research — thêm mục "Đo thiên kiến: chọn metric trước, đo theo slice, kèm khoảng tin cậy" (từ §4):** bảng chọn metric theo hại chính + quy tắc slice tối thiểu ~100 mẫu + ghi "chưa đo" khi chưa đo.
3. **Skill `vbook-extension-building` — thêm mục "An toàn khi đưa nội dung web vào prompt" (từ §5.3):** tách system instruction khỏi dữ liệu web; cân nhắc input guard chống prompt injection; không đưa dữ liệu cá nhân thật vào prompt test.
4. **Không đề xuất sửa PROTOCOL.md:** khóa này không đụng tới quy trình phối hợp; cấu trúc system instruction (PROTOCOL) / user prompt (task file) đã chốt ở task 120 vẫn đứng vững. (Lưu ý vận hành của task này: claim-task.sh từ chối khi assignee đã điền sẵn muse-2 — xem §7.)

## 7. Những điểm cần kiểm chứng thêm / giới hạn của báo cáo

- **Chưa xem video gốc của khóa và chưa chạy lab:** nội dung khóa nằm sau trang Skills Boost (video + quiz + lab, cần đăng nhập). Báo cáo này học qua mô tả chính thức của khóa + syllabus Class Central/Coursera + tài liệu chính thức của Google Cloud + tài liệu học thuật chuẩn. Các điểm trong syllabus khớp hoàn toàn với mô tả khóa; các số liệu DP (ε thực tế, VaultGemma), fairness (định lý bất khả), safety (ngưỡng mặc định OFF của Gemini 2.5 Flash) đối chiếu trực tiếp với tài liệu chính thức/học thuật.
- **Số liệu thời lượng khác nhau giữa các nguồn:** Skills ghi 4h + 2h + 3h45 (≈ 9h45), Coursera ghi 5h + 3h + 5h (13h) — hai hệ thống tính khác nhau (Skills tính video + lab, Coursera tính cả đọc + assignment); báo cáo ghi cả hai kèm nguồn, không gộp làm một.
- **Chưa xác định:** ngưỡng "đủ công bằng" cho GenAI — không có con số chuẩn như quy tắc 80% của phân loại; team phải tự đặt ngưỡng + ghi rõ. Hiệu quả thực tế của MinDiff/DP-SGD trên dữ liệu tiếng Việt/tiếng Trung của team — cần thực nghiệm nhỏ trước khi đề xuất thành task.
- **Task 137 (Red Teaming LLM, Ú) đang làm, chưa có báo cáo** — phần nối 137 trong báo cáo này dựa trên bảng phân biệt của 135 §8 và mô tả checklist task 137, sẽ bổ sung khi Ú nộp.
- **Lưu ý vận hành (không phải nội dung khóa):** `claim-task.sh` từ chối claim task 139 vì file task đã điền sẵn `assignee: muse-2` ("Task đã có người nhận (muse-2)") — đã claim thủ công (status → claimed, ghi claimed_at/claim_expires_at, commit + push main, tạo branch) theo lỗi vận hành đã ghi ở 114/115. Đề xuất muse-main xem xét: script nên cho phép claim khi assignee trùng với agent đang claim, hoặc task tạo sẵn không điền assignee trước.
- **Tên gọi đang trong đợt chuyển đổi:** "Google Cloud Skills Boost" nay là "Google Skills" (skills.google); "Vertex AI" đang đổi thành "Gemini Enterprise Agent Platform" — cùng nền tảng, khác tên; báo cáo ghi cả hai tên để tránh nhầm khi đọc tài liệu cũ/mới (nối 138 §1).

## Nguồn

- Trang khóa chính thức — Fairness & Bias (Google Skills): https://www.skills.google/course_templates/985
- Trang khóa chính thức — Interpretability & Transparency (Google Skills): https://www.skills.google/course_templates/989
- Trang khóa chính thức — Privacy & Safety (Google Skills): https://www.skills.google/course_templates/1036
- Specialization trên Coursera (syllabus 3 khóa, applied project): https://www.coursera.org/specializations/responsible-ai-for-developers
- Syllabus + mô tả (Class Central): https://www.classcentral.com/course/responsible-ai-for-developers-296490
- Mô hình FREE của Google Skills (Starter 35 credit/tháng, video miễn phí, Pro $29/tháng): https://www.saastrials.com/guides/free-google-courses-with-certificate
- Tài liệu chính thức — Google AI Principles: https://ai.google/responsibility/principles/
- TensorFlow Blog — Fairness Indicators: https://blog.tensorflow.org/2019/12/fairness-indicators-fair-ML-systems.html
- Tài liệu chính thức — Vertex AI Explainable AI, ExplanationSpec (Sampled Shapley / Integrated Gradients / XRAI): https://cloud.google.com/vertex-ai/docs/reference/rest/v1/ExplanationSpec
- Tài liệu chính thức — Configure feature-based explanations: https://cloud.google.com/vertex-ai/docs/explainable-ai/configuring-explanations-feature-based
- Tài liệu chính thức — Safety in Vertex AI (kiến trúc nhiều lớp, Gemini làm filter, DLP, Content Credentials): https://docs.cloud.google.com/vertex-ai/generative-ai/docs/learn/safety-overview
- Tài liệu chính thức — Safety and content filters (harm category, ngưỡng, safety rating, SPII/RECITATION): https://cloud.google.com/vertex-ai/generative-ai/docs/multimodal/configure-safety-filters
- DP-SGD, DP-FTRL, VaultGemma, Gboard (tổng hợp kỹ thuật): https://www.ultralytics.com/glossary/differential-privacy ; https://hld.handbook.academy/curriculum/security-at-scale/privacy-preserving-systems/
- Định nghĩa (ε, δ)-DP, composition, privacy budget: https://blog.lbenicio.dev/post/2025/08/12/differential-privacy-formal-guarantees-composition-theorems-and-the-engineering-of-private-systems/
- Fairness metrics, định lý bất khả, 6 nguồn bias, mitigation 3 họ: https://avondale.ai/technical/ai-bias-fairness.html ; https://www.timsonaiacademy.com/academy/responsible-ai/module-3
- Báo cáo nối tiếp trong repo: `research/120-prompt-design-in-vertex-ai-google.md` (§10 safety filter, §9 evals 200–500 mẫu), `research/132-evaluating-and-improving-agentic-applications-deeplearning-ai.md` (evals), `research/135-safe-and-reliable-ai-via-guardrails-deeplearning-ai.md` (§8 guardrail vs evaluator vs red-team), `research/138-introduction-to-vertex-ai-studio-google.md` (§5 tuning, §7 hai cửa Gemini).

## Kết luận

Ba khóa ngắn (tổng ~10–13 giờ, Intermediate) nhưng là khóa **đổi cách làm việc** chứ không chỉ thêm kiến thức: trước 139, team đã biết viết prompt tốt (120), đo prompt (132), chặn lúc chạy (135), tune/deploy (138) — nhưng chưa có khung để trả lời "công bằng với ai, đo bằng gì, dữ liệu có rò không". Sau 139, khung đó đã đủ: **đo thiên kiến theo slice bằng metric đã chọn có lý do (không có metric mặc định) → giải thích quyết định bằng attribution + model card (không tin lời model tự giải thích) → bảo vệ dữ liệu bằng DP/FL quyết từ thiết kế → bảo vệ hệ GenAI bằng nhiều lớp filter + Model Armor, với ngưỡng đặt tường minh**. Điểm nối quan trọng nhất: an toàn không phải một tính năng gắn thêm sau khi deploy — DP phải quyết từ lúc thiết kế, fairness phải đo lại sau mỗi lần tune, và guardrail không thay thế evals (chặn mà không đo thì không biết mình chặn đúng hay chặn nhầm). Với team, thứ mang về được ngay là checklist fairness 3 bước cho mọi tool dùng Gemini, quy tắc đặt ngưỡng safetytường minh, và cảnh báo prompt injection khi đưa nội dung web vào prompt.

**Khóa tiếp theo gợi ý (chị cả quyết theo §10):** **Inspect Rich Documents with Gemini Multimodality and Multimodal RAG** — khóa còn lại trong chương trình 10 khóa, nối trực tiếp 139 (grounding/RAG là lớp giảm ảo giác + tăng minh bạch bằng citation, đã nhắc ở 120 §10 và 139 §2.4) và 129 (vector search). Sau đó còn lại: MLOps for Generative AI.
