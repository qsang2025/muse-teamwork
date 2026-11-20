# Work smarter with AI (Microsoft Learn) — Báo cáo tự học (task 144)

- **Khóa học:** Work smarter with AI, Microsoft Learn (mã khóa AI-3025)
- **Trang khóa:** https://learn.microsoft.com/en-us/training/courses/ai-3025
- **Trang module tự học (nội dung chính của khóa):** https://learn.microsoft.com/en-us/training/modules/explore-microsoft-copilot-business-users/
- **Học viên:** muse-2 (Vịt) — vai research, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE công khai; **không đăng ký trả phí/chứng chỉ, không chạy lab/API tốn phí** (theo checklist task 144 + quy tắc tự học §9). Không đăng nhập tài khoản Microsoft để làm bài kiểm tra cuối module (xem §6).

## 0. Kiểm chứng khóa có trong danh sách 32 khóa đã duyệt — ĐẠT

Khóa này là **số 4 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11). Bằng chứng đầy đủ: Ú đã đọc đủ 32 tên bằng browser thật 20/11 21:57, ghi trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main — "4. Work smarter with AI — Microsoft Learn". Theo chỉ dẫn task 144, **không kiểm chứng lại từ đầu**; bản này chỉ đối chiếu lại tên khóa với danh sách đó.

| Hạng mục | Số liệu đã kiểm chứng (20/11/2026) |
|---|---|
| Đối tượng | Business user (người dùng văn phòng) mới tiếp xúc AI, **không cần nền tảng kỹ thuật**; chỉ cần quen Word/Excel/PowerPoint/Outlook |
| Quy mô | **1 module duy nhất, 42 phút** (đường học tự học); bản khóa lớp học AI-3025 Microsoft ghi 1 ngày |
| Cấu trúc | 9 mục: Introduction, What is AI?, AI at work, Why grounding matters, Work with AI agents, Use AI with confidence, Exercise: Review AI-generated content, Module assessment, Summary |
| Trình độ | Beginner, không có bài thi/chứng chỉ — chỉ có huy hiệu hoàn thành module (Learn Achievement Badge) |
| Ngôn ngữ | 12 ngôn ngữ, có tiếng Anh |
| FREE? | ✅ Toàn bộ nội dung module đọc miễn phí, không cần đăng nhập. Copilot trong ví dụ là sản phẩm minh họa — khóa **không yêu cầu** mua bản quyền Microsoft 365 Copilot để học |
| Cập nhật | Nội dung module hiện tại (đọc 20/11/2026) đã nhắc tới Researcher/Analyst agent và Work IQ — tức là bản mới, không phải bản cũ 2024 |

**Không trùng:** khóa gần nhất là 142 AI For Everyone (DeepLearning.AI, Andrew Ng — khung tư duy quản lý/dự án AI, ML cổ điển A→B). 144 là khóa **thực hành GenAI cho người dùng văn phòng** của Microsoft: ngắn (42 phút so với 7 giờ của 142), dạy cách dùng Copilot/agent trong công việc hàng ngày, không dạy lý thuyết ML. Hai khóa bổ sung nhau: 142 dạy *chọn dự án AI nào*, 144 dạy *dùng AI hàng ngày ra sao*.

## 1. What is AI? — AI khác công cụ truyền thống ở đâu

- **AI:** công nghệ làm được việc vốn cần trí tuệ con người (hiểu ngôn ngữ, nhận diện mẫu, tạo nội dung, phân tích thông tin). **Generative AI:** tạo ra nội dung mới — tóm tắt, bản nháp thuyết trình, hình ảnh, văn bản nháp để người dùng xem lại và chỉnh sửa.
- **Điểm khác cốt lõi với công cụ truyền thống:** máy tính, công thức bảng tính, workflow tự động đều chạy theo **quy tắc cố định** — cùng đầu vào thì luôn ra cùng đầu ra. GenAI **không theo quy tắc cố định**: nó sinh câu trả lời dựa trên mẫu đã học từ lượng lớn dữ liệu, nên thích ứng được với nhiều yêu cầu khác nhau và tạo nội dung mới.
- **7 việc AI giúp được trong ngày làm việc:** tóm tắt thông tin, soạn thảo nội dung, phân tích dữ liệu, sắp xếp thông tin, nảy ý tưởng, trả lời câu hỏi, tạo hình ảnh.
- **Ví dụ xuyên suốt khóa — nhân vật Jo** (quản lý dự án tư vấn, dự án thiết kế lại website Contoso): sau vài ngày vắng mặt, Jo dùng Copilot tóm tắt biên bản họp thành tóm tắt thảo luận + quyết định chính + action item + câu hỏi còn mở, thay vì đọc lại từng trang ghi chép. Bài học: AI biến thông tin sẵn có thành đầu ra dùng được ngay — người dùng bớt thời gian tìm kiếm, dành thời gian hành động.
- **Ý nền:** hiểu AI là gì là nền để dùng hiệu quả và **đánh giá được kết quả nó tạo ra** — không phải để tin mù.

## 2. AI at work — 4 cách AI giúp việc thường ngày

- **Tạo nội dung:** soạn email, tóm tắt, thuyết trình, báo cáo — bắt đầu từ bản nháp thay vì trang trắng.
- **Tìm và sắp xếp thông tin:** tóm tắt khối lượng lớn (biên bản họp, tài liệu, chuỗi email) và trích điểm chính.
- **Phân tích thông tin:** tìm xu hướng, mẫu, insight trong dữ liệu — xem bảng tính, so sánh phương án, tóm tắt phát hiện.
- **Nảy ý tưởng:** brainstorm cách tiếp cận, phương án thay thế, cơ hội.
- **Kịch bản "một ngày làm việc của Jo"** (chuỗi 7 bước nối tiếp, không phải 7 việc rời rạc): bắt kịp hoạt động gần đây → hiểu yêu cầu khách hàng → rút bài học từ dự án cũ → soạn thảo khuyến nghị → xem ngân sách và rủi ro → chuẩn bị bản briefing cho ban lãnh đạo → ghi lại quyết định và bước tiếp theo trong Teams. AI hỗ trợ suốt quy trình, từ thu thập tới theo dõi sau họp.
- **Nguyên tắc lặp lại ở mọi bài:** AI là đối tác hỗ trợ; con người vẫn chịu trách nhiệm xem lại, quyết định và đưa việc về đích.

## 3. Why grounding matters — ý quan trọng nhất của khóa

- **Grounding** = thông tin mà hệ thống AI được dùng để hiểu công việc của bạn và tạo câu trả lời phù hợp. Nguồn grounding: tài liệu, email, biên bản/họp, thuyết trình, bảng tính, dữ liệu kinh doanh, tri thức tổ chức.
- **Vì sao quan trọng:** cùng một câu hỏi, AI không có thông tin công việc chỉ tạo được câu trả lời chung chung; AI có biên bản họp, email, báo cáo thì tạo được tóm tắt phản ánh đúng trạng thái dự án, quyết định gần đây, rủi ro, việc sắp tới. **Câu hỏi không phải điểm khác biệt lớn nhất — thông tin AI được dùng mới là.**
- **Copilot dùng grounding ra sao:** qua Microsoft Graph + Work IQ, Copilot lấy email, tài liệu, thuyết trình, bảng tính, bản ghi cuộc họp, chat Teams, lịch — nhưng **chỉ trong phạm vi quyền của người dùng đó**. Không có quyền xem file thì Copilot cũng không lấy được thay bạn. (Người dùng không cần hiểu công nghệ nền mới dùng được.)
- **Kịch bản đối chứng của Jo:** cùng yêu cầu "Create a project status update" — không grounding: bản tóm tắt chung chung, không phản ánh trạng thái thật; có grounding (biên bản họp + email khách hàng + tài liệu ngân sách): bản tóm tắt gồm mốc đã xong, rủi ro hiện tại, trạng thái ngân sách, ưu tiên khách hàng, bước tiếp theo.
- **Nối 142 §1.2 + 120 §10:** grounding chính là phiên bản thực hành của "garbage in, garbage out" và RAG — chất lượng đầu ra AI phụ thuộc trực tiếp vào dữ liệu đầu vào. Khóa 142 dạy *chọn đúng dữ liệu*, khóa 144 dạy *đưa dữ liệu đó vào prompt*.

## 4. Work with AI agents — chat 1 câu hỏi khác agent ở đâu

- **AI agent** = trợ lý AI giúp hoàn thành một nhiệm vụ/đạt một mục tiêu bằng cách **đi qua một chuỗi hành động**, không chỉ trả lời một câu hỏi.
- **Chat vs agent:** chat là 1 yêu cầu → 1 câu trả lời (tóm tắt cuộc họp, dàn ý thuyết trình). Agent quản lý cả một quy trình: thu thập thông tin từ nhiều nguồn → phân tích → soạn bản nháp → chỉ ra rủi ro/câu hỏi mở → đề xuất bước tiếp theo.
- **Việc hợp dùng agent:** chuẩn bị đề xuất cho khách hàng, rà soát trạng thái dự án, nghiên cứu cơ hội thị trường, onboarding nhân viên mới, xử lý yêu cầu hỗ trợ khách hàng, theo dõi mốc dự án — tức việc lặp lại, nhiều bước, nhiều người.
- **Kịch bản Researcher agent:** Jo nhờ agent Researcher chuẩn bị bản nháp thuyết trình cho buổi review của ban lãnh đạo về dự án Contoso. Jo nêu mục tiêu → agent thu thập từ tài liệu dự án, trao đổi khách hàng, biên bản họp → hỏi lại Jo vài câu → tạo bản nháp gồm trạng thái dự án, rủi ro chính, câu hỏi mở, bước tiếp theo. Jo chỉ việc xem lại và chỉnh cho phù hợp đối tượng. Lưu ý của khóa: agent có thể mất thời gian thu thập/phân tích — cần kiên nhẫn.
- **Giám sát con người vẫn bắt buộc:** trước khi hành động theo thông tin agent đưa, phải xem lại kết quả, kiểm chứng thông tin quan trọng, rà soát khuyến nghị, áp dụng kiến thức nghiệp vụ. "Người vẫn chịu trách nhiệm về kết quả" — agent là đồng đội giúp thu thập và hoàn thành việc, không phải người quyết thay.

## 5. Use AI with confidence — khung Ask, review, verify, decide, act

- **Dùng AI tự tin ≠ tránh AI.** Nghĩa là biết khi nào dùng AI, khi nào xem lại việc của nó, khi nào áp dụng chuyên môn của mình. Kết hợp tốt nhất: tốc độ + quy mô của AI với bối cảnh + chuyên môn + phán đoán của con người.
- **Nội dung AI tạo ra là điểm bắt đầu, không phải sản phẩm cuối.** Trước khi chia sẻ hoặc dùng để quyết định, phải xem lại. Vai trò của con người: đánh giá khuyến nghị, cân nhắc bối cảnh kinh doanh, áp dụng phán đoán chuyên môn, ra quyết định, hành động.
- **Bảo vệ thông tin nhạy cảm:** tuân thủ chính sách tổ chức về dữ liệu khách hàng, tài chính, thông tin cá nhân, bí mật kinh doanh, sở hữu trí tuệ. Chỉ dùng công cụ AI đã được phê duyệt; Copilot chỉ truy cập nội dung người dùng đã có quyền xem.
- **6 nguyên tắc Responsible AI của Microsoft:** Fairness (công bằng), Reliability and safety (đáng tin cậy và an toàn), Privacy and security (riêng tư và bảo mật), Inclusiveness (hòa nhập), Transparency (minh bạch), Accountability (trách nhiệm giải trình).
- **Khung thực hành 5 bước: Ask (hỏi) → review (xem lại) → verify (kiểm chứng) → decide (quyết định) → act (hành động).** Đây là khung gọn nhất trong các khóa đã học để treo cạnh bàn làm việc.
- **Kịch bản Jo:** xem lại bản nháp thuyết trình do Researcher agent tạo → phát hiện một cập nhật gần đây của khách hàng chưa được phản ánh → kiểm chứng thông tin mới nhất, cập nhật slide, thêm bối cảnh → chia sẻ bản cuối. Bản cuối = khả năng tổ chức của AI + chuyên môn/phán đoán/hiểu dự án của Jo.

## 6. Exercise: Review AI-generated content — bài tập bẫy "On Track"

Bài tập 10 phút: xem lại bản cập nhật điều hành do AI soạn cho dự án Contoso trước khi gửi ban lãnh đạo. Đây là phần thực hành đáng giá nhất của khóa vì nó cho thấy AI sai theo kiểu **tự tin quá mức**, không phải sai trắng trợn.

**Thông tin dự án (nguồn thật):**
- Trang chủ thiết kế xong; hiệu năng mobile vẫn dưới ngưỡng mục tiêu, cần tối ưu thêm.
- Khách hàng yêu cầu cập nhật thông điệp trang chủ cho chiến dịch marketing.
- Các mục rà soát accessibility còn mở (cấu trúc heading, alt text, tương phản màu).
- Dự kiến vượt ngân sách nhẹ do chỉnh sửa nội dung/thiết kế giai đoạn cuối.
- **Khách hàng yêu cầu hoàn thành cải thiện hiệu năng mobile TRƯỚC khi phê duyệt ra mắt.**

**Bản nháp AI viết:**
- Tóm tắt: "tiếp tục tiến triển tốt, đúng kế hoạch, dự kiến ra mắt như dự kiến".
- Trạng thái tổng thể: 🟢 **On Track**.
- Bảng readiness: Mobile Performance "In Progress" 🟡, Accessibility "Open Issues" 🔴, Budget "Slight Variance" 🟡.
- Khuyến nghị: "có vẻ đã sẵn sàng tiến tới ra mắt".

**Các vấn đề cần phát hiện (đáp án bài tập, đối chiếu nguồn):**
1. **Trạng thái tổng thể sai lệch:** 🟢 On Track mâu thuẫn với chính bảng readiness của nó (có mục 🔴) và với yêu cầu chặn ra mắt của khách hàng — phải là 🟡 At Risk trở lên.
2. **Thiếu điều kiện chặn quan trọng nhất:** không nhắc khách hàng yêu cầu xong mobile performance trước khi phê duyệt ra mắt — thông tin quyết định việc có được ra mắt hay không.
3. **Làm nhẹ rủi ro:** "vượt ngân sách nhẹ" và accessibility còn mở bị chìm trong giọng văn tích cực chung; ban lãnh đạo đọc bản này sẽ tưởng mọi thứ ổn.
4. **Tự tin quá mức (overly confident):** "ready to proceed toward launch" trong khi 3/6 hạng mục chưa xong.
5. **Cách sửa:** cập nhật tóm tắt theo thông tin mới nhất, nêu rõ yêu cầu chặn của khách hàng, đánh giá lại readiness, làm nổi bật rủi ro ban lãnh đạo cần cân nhắc — rồi **vẫn phải có người xem lại bản sửa trước khi gửi** (AI sửa xong chưa chắc đã đúng).

**Bài học rút ra:** AI tạo điểm bắt đầu hữu ích; tương tác thêm giúp cải thiện; nội dung AI phải được xem lại trước khi chia sẻ; con người chịu trách nhiệm đánh giá và quyết định.

**Module assessment (quiz cuối module):** chưa làm — cần đăng nhập tài khoản Microsoft để ghi điểm; theo §9 không đăng ký/đổi cài đặt tài khoản trong lúc học nên bỏ qua, không ảnh hưởng nội dung báo cáo (quiz chỉ kiểm tra lại 3 mục tiêu học đã nêu ở đầu module, nội dung đã đọc đủ ở 6 bài trên).

## 7. So sánh với các khóa đã học + nối tiếp 142

| Khía cạnh | 142 AI For Everyone (Ng) | 144 Work smarter with AI (Microsoft) |
|---|---|---|
| Đối tượng | Quản lý/doanh nghiệp, phi kỹ thuật | Người dùng văn phòng, phi kỹ thuật |
| Thời lượng | 7 giờ, 4 module | 42 phút, 1 module |
| AI dạy | ML cổ điển: A→B, học có giám sát | GenAI + Copilot + agent trong công việc |
| Trọng tâm | Chọn dự án AI, tổ chức, dữ liệu | Dùng AI hàng ngày: tóm tắt, soạn thảo, grounding, agent, kiểm chứng |
| Quy tắc nhớ | Quy tắc 1 giây; giao nhau 3 vòng | Grounding; khung Ask–review–verify–decide–act |
| Hạn chế | Ra đời trước làn sóng LLM; 2 khẳng định đã lỗi thời (xem 142 §kết luận) | Rất cơ bản — người đã dùng AI hàng ngày sẽ thấy ít mới; ví dụ gắn chặt hệ Microsoft 365/Copilot |

**Nối 142 — quy tắc 1 giây, bản cập nhật từ 144:** 142 nói việc làm trong ~1 giây suy nghĩ thì ML tự động hóa được (vd: kiểm tra lỗi bề mặt bằng thị giác). 144 cho thấy GenAI + agent đã vượt khỏi khung đó: tóm tắt biên bản họp, soạn briefing cho ban lãnh đạo, điều phối cả quy trình chuẩn bị review — những việc cần suy nghĩ lâu hơn 1 giây rất nhiều. Nhưng 144 cũng đặt lại ranh giới mới: AI làm được **tác vụ** (soạn nháp, tổng hợp, điều phối bước), còn **quyết định và trách nhiệm** vẫn thuộc về người — đúng như 142 đã cảnh báo "ML không viết được báo cáo 50 trang thay anh", nay GenAI viết được nháp nhưng vẫn cần người kiểm chứng (nối 120 §10: grounding + evals). Khung chọn việc của 142 (§2.2: giao nhau 3 vòng) vẫn dùng được, chỉ cần thay câu (a) "quy tắc 1 giây" bằng "AI làm được tác vụ nào trong quy trình, người giữ khâu quyết định nào".

**Nối 140/143 (agentic):** 144 là bản giới thiệu phi kỹ thuật của cùng chủ đề 140 Governing AI Agents và 143 AI Agentic Design Patterns — agent = chuỗi hành động hướng tới mục tiêu, cần giám sát con người. Ai đã đọc 144 sẽ hiểu nhanh 143; ai làm 143 nên đọc 144 để biết người dùng cuối kỳ vọng gì ở agent.

## 8. Áp dụng ngay cho Anh / team (đề xuất, muse-main quyết)

1. **Khung 5 bước Ask–review–verify–decide–act cho mọi bản AI soạn trước khi gửi sếp/khách hàng.** Treo cạnh quy tắc 1 giây của 142. Áp dụng ngay: mọi tóm tắt/báo cáo do AI soạn (biên bản họp, báo cáo ca, email) đều phải qua bước verify trước khi gửi — không gửi thẳng bản AI.
2. **Bài học từ bẫy "On Track":** khi nhờ AI tóm tắt trạng thái sản xuất/OEE/sự cố, phải đối chiếu số liệu nguồn (downtime, lỗi bao bì, tồn kho) thay vì tin trạng thái tổng thể AI kết luận. AI có xu hướng làm nhẹ rủi ro và viết giọng tích cực — đúng lỗi nguy hiểm nhất trong báo cáo sản xuất (báo xanh trong khi thực tế đỏ). *Áp dụng ngay:* checklist 5 câu hỏi của bài tập (§6: thiếu gì? sai/misleading chỗ nào? trạng thái có khớp nguồn không? có dám gửi như vậy không?) dùng làm checklist review cho báo cáo ca/AI.
3. **Grounding = đưa đúng tài liệu vào prompt.** Khi hỏi AI về công việc xưởng: đính kèm đúng file (biên bản họp ca, SOP, số liệu OEE) thay vì hỏi chung chung. Không có grounding thì câu trả lời chỉ là kiến thức chung — giống lỗi "hỏi AI chung chung rồi nhận câu trả lời chung chung" từng gặp.
4. **Agent cho việc lặp lại nhiều bước:** chuẩn bị hồ sơ audit FSSC 22000 v7 (đang mở) là ứng viên agent tốt — thu thập tài liệu từ nhiều nguồn → đối chiếu checklist → soạn bản nháp → chỉ ra khoảng trống; người vẫn quyết cuối. Tương tự: chuẩn bị briefing họp giao ban từ email + biên bản + số liệu ca.
5. **Quyền và dữ liệu nhạy cảm:** chỉ dùng công cụ AI đã duyệt cho dữ liệu công việc; không đưa dữ liệu khách hàng/tài chính/sản xuất nhạy cảm vào chatbot công cộng chưa được phê duyệt — Copilot tôn trọng quyền truy cập, chatbot công cộng thì không có cơ chế đó.

## 9. Đề xuất cập nhật skill / khóa tiếp theo

- **Skill research — thêm recipe "Review bản AI soạn: 5 câu hỏi" (từ §6):** thiếu gì? sai/misleading chỗ nào? trạng thái tổng thể có khớp nguồn không? có điều kiện chặn nào bị giấu không? có dám gửi như vậy không? Kèm khung Ask–review–verify–decide–act (§5) và cảnh báo "AI làm nhẹ rủi ro, viết giọng tích cực".
- **Khóa tiếp theo gợi ý (chị cả quyết theo §10):** trong danh sách 32, ứng viên thực hành tiếp theo cho lane research của Vịt là **#16 "Demonstrate the capabilities of Power Automate" (Microsoft Learn)** — tự động hóa tác vụ lặp lại, nối trực tiếp 144 (từ "dùng AI hỗ trợ việc" sang "tự động hóa việc"). Ứng viên khác: #10 "Get started with AI agent development on Azure" (Microsoft Learn — nối 144 §4 sang phía kỹ thuật, nhưng thuộc lane build của Ú nhiều hơn). #5 AI Fluency (Anthropic) thuộc lane muse-main theo §9, không nhận.

## Nguồn đã kiểm chứng

- Trang khóa AI-3025: https://learn.microsoft.com/en-us/training/courses/ai-3025
- Module "Work smarter with AI" (9 mục, đọc đủ 6 bài nội dung + bài tập): https://learn.microsoft.com/en-us/training/modules/explore-microsoft-copilot-business-users/
  - 2-what-is-ai, 3-ai-at-work, 4-why-grounding-matters, 5-work-with-ai-agents, 6-use-ai-with-confidence, 7-exercise-review-ai-generated-content
- Danh sách 32 khóa đã duyệt (bằng chứng Ú đọc bằng browser thật 20/11 21:57): `research/140-governing-ai-agents-deeplearning-ai.md` trên main
- Báo cáo 142 (quy tắc 1 giây, khung 3 vòng): `research/142-ai-for-everyone-deeplearning-ai.md`
