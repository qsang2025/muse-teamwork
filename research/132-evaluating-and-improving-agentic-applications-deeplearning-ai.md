# Evaluating and Improving Agentic Applications (DeepLearning.AI × Arize AI) — Báo cáo tự học (task 132)

> WIP — đang học, chưa xong. Commit tiến độ đầu tiên theo PROTOCOL §2.4.

- **Khóa học:** Evaluating and Improving Agentic Applications, DeepLearning.AI (hợp tác Arize AI)
- **Trang khóa:** https://www.deeplearning.ai/courses/evaluating-and-improving-agentic-applications
- **Giảng viên:** Laurie Voss (Head of Developer Relations, Arize AI; đồng sáng lập npm)
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Hình thức:** chỉ học nội dung FREE, **không đăng ký DeepLearning.AI Pro, không chạy lab/API tốn phí, không tạo tài khoản trả phí** (theo checklist task 132). **Không chạy code lab** — lab cần Arize Phoenix + LLM API; báo cáo học qua trang khóa chính thức + lecture notes công khai + tài liệu Phoenix/evals công khai.
- **Vị trí trong vòng tự học:** khép trục bộ nhớ sau task 127 (framework LangGraph/LangMem), 128 (hạ tầng Oracle), 130 (quản lý context MemGPT/Letta) bằng **đánh giá chất lượng**: nhớ sai/quên sai thì đo bằng gì; và **bảo mật bộ nhớ** nếu khóa có nhắc.

## Kiểm chứng mức FREE trước khi học (checklist mục 1) — bản nháp

- **Khóa học: FREEMIUM, không FREE toàn bộ như các short course ở task 123/125/127/128/130.** Trang khóa chính thức ghi DeepLearning.AI Pro **$25/tháng trả theo năm, $30/tháng trả theo tháng** và chứng chỉ chỉ cấp cho Pro member. Nguồn tổng hợp độc lập (beri.net, viết từ 4 nguồn) ghi rõ: *free members can watch the videos; labs, quizzes and certificates require DeepLearning.AI Pro*.
- **Phần FREE được học:** video bài giảng (free member xem được), mô tả/mục tiêu/outline công khai trên trang khóa, lecture notes PDF công khai trên DeepLearning.AI Community (M1–M5).
- **Phần không FREE, không làm:** 6 code lab, 10 graded assignment/quiz, chứng chỉ — đều cần Pro; lab còn cần LLM API key. Tất cả nằm ngoài phạm vi checklist → **không đăng ký Pro, không chạy lab**, chỉ học khái niệm và quy trình qua tài liệu FREE.

## Cấu trúc khóa (syllabus) — bản nháp

| Module | Nội dung chính |
|---|---|
| 1. Foundations of Evals | Vì sao agent khó đánh giá; một lần chạy thành công không chứng minh độ tin cậy; đọc traces (model/tool call từng bước) |
| 2. Observing & Benchmarking Agents | Biến yêu cầu ứng dụng thành test case; gán nhãn lỗi lặp lại; ưu tiên theo tần suất × mức hại; benchmark Northwind; case thật + synthetic |
| 3. Building Evaluators You Can Trust | Code evaluator (pass/fail rõ ràng) + LLM judge (cần diễn giải); custom rubric; đo độ tin cậy judge bằng precision/recall/Cohen's kappa |
| 4. Evaluating Agent Actions and Outcomes | Đánh giá tool call, thứ tự bước (trajectory), instruction following qua nhiều lượt hội thoại, task có thật sự hoàn thành ở hệ đích không |
| 5. Improving Agentic Applications | So sánh phiên bản agent trên cùng case/evaluator; xử lý regression; biến lỗi production thành regression test |

_(Đang viết tiếp…)_
