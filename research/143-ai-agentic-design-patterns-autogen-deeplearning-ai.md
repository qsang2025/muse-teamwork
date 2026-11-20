# AI Agentic Design Patterns with AutoGen (DeepLearning.AI) — Báo cáo tự học (task 143)

- **Khóa học:** AI Agentic Design Patterns with AutoGen, DeepLearning.AI (hợp tác Microsoft)
- **Trang khóa:** https://www.deeplearning.ai/courses/ai-agentic-design-patterns-with-autogen
- **Giảng viên:** Chi Wang (Principal Researcher, Microsoft Research) và Qingyun Wu (Assistant Professor, Penn State University) — hai đồng tác giả của AutoGen
- **Học viên:** muse-1 (Ú) — vai build, theo phân vai Anh chốt 20/11 (PROTOCOL §9/§10)
- **Ngày học:** 20/11/2026
- **Bối cảnh task:** muse-main tạo theo ủy quyền 20/11 (§10: Ú rảnh sau khi task 140 merge xong, không còn task mở). Đây là **khóa số 14 trong danh sách 32 khóa AI miễn phí đã duyệt** (Vinmedia Global, Anh chốt 20/11); bằng chứng danh sách đầy đủ đã có trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main — không kiểm chứng lại từ đầu theo chỉ dẫn task. Khóa nối tiếp mạch agents sau 140 (Agentic AI: 4 pattern khung) — khóa này đi sâu **pattern multi-agent bằng AutoGen**, đối chiếu với kiến trúc phân cấp 3 Muse của team.
- **Hình thức:** chỉ học nội dung FREE công khai, **không đăng ký Pro/trả phí, không chạy lab/API tốn phí, không tạo tài khoản trả phí**. Báo cáo học qua trang khóa chính thức + trang giới thiệu khóa + tài liệu AutoGen công khai của Microsoft (xem mục Nguồn).
- **Quy mô khóa:** xuất bản 29/05/2024 (trang chính thức ghi Published: 2024-05-29), cập nhật 07/10/2025; mức Beginner, 1 giờ 35 phút, 8 bài video, 6 ví dụ code, 1 graded assignment (PRO). Yêu cầu: biết Python cơ bản. Khóa dùng OpenAI API trong lab (ngoài phạm vi FREE → không chạy).

## Kiểm chứng mức FREE trước khi học (checklist mục 1)

- **Thuộc danh sách đã duyệt: CÓ.** AI Agentic Design Patterns with AutoGen là khóa số 14 trong danh sách 32 khóa Vinmedia đã đọc đủ bằng browser thật tối 20/11 (bằng chứng trong `research/140-governing-ai-agents-deeplearning-ai.md` trên main). muse-main đã ghi rõ vào task file.
- **Khóa học: Freemium — audit FREE xem được video, graded assignment/chứng chỉ cần PRO.** Trang khóa chính thức ghi: "Earn an accomplishment with PRO", "1 Graded Assignment PRO". Cùng mẫu với task 128/132/135/137/140. Hệ quả: **chỉ học khái niệm, pattern và phương pháp qua nội dung công khai, không đăng ký Pro, không chạy lab** — đúng checklist.
- **Phần không FREE nếu chạy thật:** (a) gói PRO cho graded assignment/certificate, (b) API key LLM (khóa dùng OpenAI API) để chạy 6 ví dụ code, (c) môi trường thực thi code/sandbox cho bài coding/financial analysis. Tất cả ngoài phạm vi FREE → **không chạy**, chỉ học phương pháp.
- **Pattern không bị khóa sau sản phẩm:** 4 pattern khóa dạy (Reflection, Tool use, Planning, Multi-agent collaboration) là pattern chung của ngành — AutoGen chỉ là một cách triển khai. Toàn bộ giá trị khái niệm lấy được từ syllabus + tài liệu AutoGen công khai, giống kết luận ở các task trước.

## Cấu trúc khóa (syllabus)

| Bài | Nội dung chính | Pattern / khái niệm |
|---|---|---|
| 1. Introduction | Tổng quan AutoGen, khái niệm framework multi-agent hội thoại | Multi-agent collaboration (khung) |
| 2. Multi-Agent Conversation and Stand-up Comedy | `ConversableAgent` — khối xây dựng lõi; hội thoại 2 agent (hai diễn viên hài) | ConversableAgent, two-agent chat |
| 3. Sequential Chats and Customer Onboarding | Chuỗi hội thoại tuần tự qua nhiều agent cho onboarding khách hàng | Sequential chats |
| 4. Reflection and Blogpost Writing | Viết blogpost chất lượng cao bằng reflection; reviewer agent lồng trong critic agent | Reflection + Nested chats |
| 5. Tool Use and Conversational Chess | Cờ vua hội thoại: agent gọi tool kiểm tra nước đi hợp lệ | Tool use |
| 6. Coding and Financial Analysis | Agent viết code vẽ biểu đồ lợi nhuận cổ phiếu, thực thi trong sandbox; hai hệ: code sinh từ LLM vs code người dùng cấp, có phản hồi người dùng | Coding + code execution, human-in-the-loop |
| 7. Planning and Stock Report Generation | Group chat tùy chỉnh nhiều agent tạo báo cáo hiệu suất cổ phiếu chi tiết, có planning agent, tùy chỉnh luồng hội thoại | Planning + Group chat |
| 8. Conclusion | Tổng kết | — |

Đường đi của khóa: **2 agent nói chuyện → chuỗi tuần tự → lồng nhau để tự sửa → gọi tool → viết & chạy code → nhóm có người lập kế hoạch**. Đây là thang leo độ phức tạp của tương tác multi-agent: mỗi bài thêm đúng một cơ chế phối hợp mới.

## 1. Ý tưởng lõi của AutoGen: hội thoại là runtime

- **Định nghĩa của khóa:** AutoGen là framework hội thoại multi-agent (multi-agent conversational framework) cho phép tạo nhanh nhiều agent với vai trò, persona và năng lực khác nhau để triển khai ứng dụng AI phức tạp bằng các agentic design pattern.
- **Khác biệt kiến trúc:** thay vì đồ thị trạng thái viết cứng (như LangGraph ở task 125) hay giao việc tuyến tính theo task (như CrewAI), AutoGen mô hình hóa tính toán thành **hội thoại nhiều lượt giữa các agent ngang hàng**: phân rã việc, viết code, chạy code, đọc lỗi, sửa, đánh giá — tất cả diễn ra qua trao đổi tin nhắn. Hệ quả thực hành: (a) vòng phản hồi là tự nhiên (executor trả nguyên văn lỗi terminal, coder đọc ở lượt sau và sửa, không cần dây retry viết cứng); (b) con người tham gia được như một nút trong hội thoại (human-in-the-loop); (c) lịch sử hội thoại chính là trace kiểm toán được.
- **Ánh xạ sang team:** team 3 Muse **không** chạy hội thoại tự do — team chạy qua hiện vật bền (task file GitHub là nguồn sự thật, PROTOCOL §1/§6). AutoGen cho thấy mặt trái của hội thoại thuần: khi không có hiện vật bền ngoài transcript, việc truy vết "ai quyết cái gì, dựa trên bằng chứng nào" phụ thuộc hoàn toàn vào việc đọc lại cả cuộc hội thoại. Đây chính là lý do team đã chọn task file + STATUS.md thay vì nhắn tin tất-cả (kết luận task 140 §7 được khóa này củng cố từ phía framework).

## 2. ConversableAgent: khối xây dựng lõi

- **Cơ chế:** `ConversableAgent` là lớp agent nền của AutoGen, hỗ trợ hội thoại, tool use và thực thi code. Hai vai chuyên biệt thường gặp: `AssistantAgent` (do LLM điều khiển, suy luận/viết code/viết phản hồi, **không tự chạy code**) và `UserProxyAgent` (đại diện người dùng, **chạy code** Assistant viết, có thể hỏi người thật hoặc chạy tự động hoàn toàn). Bài 2 dùng hai ConversableAgent đóng vai diễn viên hài để dạy cơ chế hội thoại 2 agent ở dạng tối giản nhất.
- **Điểm thiết kế đáng nhớ:** tách "người viết" khỏi "người chạy" là một quyết định an toàn, không chỉ là tiện lợi — agent sinh code không có quyền thực thi, agent thực thi không tự sinh nội dung. Người dùng kiểm soát mức tự chủ của UserProxy (hỏi trước mỗi lần chạy hay chạy luôn).
- **Ánh xạ sang team:** sự tách vai này đã có trong team ở quy mô tổ chức: worker (Ú/Vịt) viết/build trên branch, chị cả (muse-main) là cổng kiểm chứng + merge — worker không tự merge lên main (PROTOCOL §4). Khóa cho ngôn ngữ để gọi tên: team đang áp dụng nguyên tắc "tách quyền sinh nội dung khỏi quyền thực thi lên hệ thật" ở tầng quy trình, AutoGen áp dụng ở tầng code.

## 3. Sequential chats: bàn giao tuần tự có thứ tự định trước

- **Cơ chế:** một danh sách task được thực thi từng bước qua chuỗi hội thoại giữa các agent — mỗi cặp agent xử lý một bước, kết quả bước trước là đầu vào bước sau. Ví dụ khóa: onboarding khách hàng (chào → thu thập thông tin → giới thiệu sản phẩm...).
- **Khi nào dùng:** khi thứ tự bước **biết trước và ổn định** — đây là mẫu tuyến tính (linear pipeline) trong 3 mẫu multi-agent của task 140 §7, dạng đáng tin cậy nhất vì luồng chạy dự đoán được.
- **Ánh xạ sang team:** checklist trong mỗi task file (quét chống trùng → claim → build → test → review) là sequential chat ở dạng văn bản: bước sau không bắt đầu khi bước trước chưa xong, và kết quả mỗi bước ghi vào task file. Khóa xác nhận: việc nào thứ tự đã rõ thì đừng để agent tự quyết thứ tự — viết cứng thứ tự rẻ hơn và an toàn hơn planning tự do.

## 4. Reflection + Nested chats: agent quản lý agent

- **Cơ chế reflection:** agent xem lại đầu ra (của mình hoặc của agent khác) để phê bình và cải thiện, lặp tới khi đạt chất lượng — cùng pattern Module 2 của task 140.
- **Cơ chế nested chats (mới ở khóa này):** khi một agent nhận task, nó **không trả lời ngay** mà mở hội thoại nội bộ với một nhóm agent khác, lặp với chúng một lúc, rồi mới trả kết quả ra ngoài. Ví dụ khóa: critic agent chứa các reviewer agent lồng bên trong để phản biện blogpost do agent viết viết ra. Ẩn dụ của giảng viên: nếu lập trình viên là quản lý của vài agent, thì nested chat là cho agent mình quản lý **tự quản lý agent của nó**.
- **Giá trị và rủi ro:** nested chat đóng gói độ phức tạp (bên ngoài chỉ thấy một agent, một kết quả) nhưng cũng che trace nội bộ — bên ngoài khó biết vòng lặp bên trong đã chạy bao nhiêu lượt, tốn bao nhiêu, và kẹt ở đâu nếu kết quả xấu. Cần giới hạn số vòng và ghi trace nội bộ.
- **Ánh xạ sang team:** team hiện **không** dùng nested chat — mọi việc đều phẳng: task file công khai, chị cả thấy mọi bước. Khóa gợi ý đúng chỗ nested chat sẽ có ích nếu team lớn thêm: một worker tự mở vòng reflection nội bộ (tự phê bình bản nháp trước khi nộp review) mà không cần chị cả tham gia từng vòng — nhưng phải kèm luật ghi trace (số vòng, điểm trước/sau) vào task file, nếu không sẽ mất tính truy vết mà team đang có. Đây là đề xuất có điều kiện, không phải việc làm ngay (xem §9).

## 5. Tool use: cấp hàm cho agent gọi

- **Cơ chế:** lập trình viên định nghĩa hàm (ví dụ: kiểm tra nước cờ có hợp lệ không), đăng ký cho agent; agent quyết định khi nào gọi, hệ thống chạy hàm và trả kết quả về hội thoại để agent tiếp tục. Ví dụ khóa: cờ vua hội thoại — hai agent chơi cờ, mỗi nước đi đều qua tool kiểm tra hợp lệ.
- **Điểm nhấn của khóa:** tool là cách đưa **sự thật bên ngoài model** vào hội thoại (luật cờ, dữ liệu thật, API) thay vì để model tự đoán — cùng bài học task 140 §4. Chất lượng mô tả tool (tên, tham số, khi nào dùng) quyết định agent gọi đúng hay sai.
- **Ánh xạ sang team:** worker gọi git/script/hub/browser hằng ngày chính là tool use ở quy mô hệ thống; PROTOCOL + skill là "mô tả tool". Bài học lặp lại từ task 123/140: mô tả rõ là một nửa của việc gọi đúng — checklist task mơ hồ thì agent gọi sai tool hoặc sai thứ tự.

## 6. Coding + code execution: viết code rồi chạy trong sandbox

- **Cơ chế:** khi không có hàm định sẵn, agent tự viết code cần thiết, hệ thống kiểm tra rồi thực thi trong môi trường sandbox, kết quả (kể cả lỗi) quay lại hội thoại để agent sửa. Ví dụ khóa: phân tích tài chính — agent viết code vẽ biểu đồ lợi nhuận cổ phiếu; hai biến thể: code sinh hoàn toàn từ LLM vs code người dùng cấp sẵn, cả hai đều có vòng phản hồi người dùng (human feedback).
- **An toàn:** thực thi code do LLM sinh là năng lực nguy hiểm nhất trong khóa — sandbox + tách vai viết/chạy (§2) + điểm dừng hỏi người là ba lớp chặn đi kèm, không phải tùy chọn. Đây là dạng "code-as-action" mà task 140 §6 đã so sánh với JSON plan: linh hoạt nhất, khó dự đoán nhất, cần chặn mạnh nhất.
- **Ánh xạ sang team:** worker của team cũng viết và chạy code thật (build extension, chạy validate) — nhưng trong ranh giới đã định: chỉ trên branch feature, chỉ trong repo được giao, merge phải qua chị cả. Khóa củng cố nguyên tắc team đang giữ: **quyền thực thi luôn đi kèm sandbox/cổng kiểm chứng**, không bao giờ để agent sinh code chạy thẳng lên hệ thật (main) không qua kiểm chứng.

## 7. Planning + Group chat: nhóm có người điều phối

- **Cơ chế:** group chat là nhiều agent chuyên biệt cùng tham gia một hội thoại, có cơ chế điều khiển ai nói tiếp (GroupChatManager / luồng tùy chỉnh). Bài 7 thêm **planning agent**: agent lập kế hoạch chuỗi hành động (thu thập dữ liệu → phân tích → viết → sửa) rồi điều phối các agent khác thực thi, để tạo báo cáo hiệu suất cổ phiếu chi tiết.
- **Điểm thiết kế:** planning trong group chat khác planning đơn agent (task 140 §6) ở chỗ kế hoạch được **thực thi bởi nhiều vai chuyên biệt** và luồng hội thoại có thể tùy chỉnh (ai được nói sau ai, khi nào dừng). Đổi lại, đây là cấu hình khó dự đoán nhất của khóa: nhiều agent + kế hoạch tự sinh + luồng tùy chỉnh = nhiều điểm có thể lệch.
- **Ánh xạ sang team:** team 3 Muse là group chat có điều phối ở dạng tổ chức, nhưng với hai khác biệt quan trọng: (a) "planning agent" của team là chị cả + Anh (con người chốt hướng), không phải LLM tự lập kế hoạch; (b) luồng không phải hội thoại tự do mà là task file có trạng thái rõ (open → claimed → doing → review → done). Khóa cho thấy team đang cố ý chọn phiên bản **ít tự chủ hơn nhưng truy vết được** của cùng một pattern — và đó là lựa chọn đúng cho việc có hậu quả thật như merge/push.

## 8. AutoGen sau khóa học: bối cảnh hiện tại (2025–2026)

- **Tiến hóa phiên bản:** khóa dạy AutoGen thế hệ đầu (0.2, ConversableAgent/GroupChat). Từ 0.4, AutoGen chuyển sang kiến trúc event-driven, phân tán (autogen-core, runtime, topic/subscription), với các pattern mới trong tài liệu chính thức như Concurrent Agents (một tin nhắn nhiều agent xử lý song song, định tuyến theo topic, direct messaging) và Mixture of Agents (worker nhiều lớp + một orchestrator tổng hợp từng lớp).
- **Trạng thái dự án:** AutoGen hiện ở chế độ maintenance — Microsoft đang hợp nhất vào Microsoft Agent Framework; tính năng mới không còn thêm vào AutoGen, chỉ sửa lỗi, và tài liệu chính thức có đường migration. Hệ quả thực hành: **học pattern từ khóa này thì bền, nhưng không nên bắt đầu dự án mới bằng AutoGen 0.2** — nếu cần framework hội thoại multi-agent, cân nhắc Agent Framework/AG2 hoặc giữ nguyên hệ tự xây như team đang có.
- **Ánh xạ sang team:** đây là ví dụ rõ cho bài học "học pattern, không học sản phẩm" đã lặp ở task 125/128/130/140: framework đến rồi đi (LangGraph, AutoGen, Agent Framework), còn 4 pattern (reflection, tool use, planning, multi-agent) và kỷ luật đo/chặn (132/135/137) thì ở lại. Team không phụ thuộc framework nào cho việc phối hợp — task file + git + hub tự xây — nên không bị cuốn theo vòng đời sản phẩm.

## 9. Đối chiếu với mạch tự học đã qua (123→140)

| Khóa | Đóng góp một mảnh | Khóa 143 xếp mảnh đó vào đâu |
|---|---|---|
| 123 ChatGPT Prompt Engineering | Viết prompt/checklist rõ | Mô tả tool + system prompt theo vai (§5) — agent gọi đúng tool nhờ mô tả |
| 125 AI Agents in LangGraph | Framework đồ thị trạng thái | Đối trọng kiến trúc: LangGraph = luồng viết cứng theo node/edge; AutoGen = hội thoại là runtime (§1). Hai cực của cùng một phổ kiểm soát |
| 127/128/130 Bộ nhớ agent | Lưu/truy xuất ngữ cảnh dài hạn | AutoGen giữ ngữ cảnh trong transcript hội thoại; khóa không dạy bộ nhớ dài hạn — giữ vai trò bổ trợ như ở 140 |
| 132 Evaluating Agentic Applications | Đo: benchmark, judge, regression | Khóa 143 không dạy evals — vòng reflection (§4) không có đo thì thành lặp mù, đúng cảnh báo task 140 §3 |
| 135 Safe & Reliable AI via Guardrails | Chặn lúc chạy | Lớp chặn quanh code execution (§6) và nested chat (§4): sandbox, giới hạn vòng, cổng người duyệt |
| 137 Red Teaming LLM Applications | Tấn công thử chủ động | Kiểm chứng đối kháng cho group chat/planning tự sinh (§7) — cấu hình khó dự đoán nhất cần tấn công thử nhất |
| 140 Agentic AI (khung tổng hợp) | 4 pattern + evals/error analysis | Khóa 143 là **bản triển khai multi-agent chuyên sâu** của pattern thứ 4 trong 140, cộng thêm 2 cơ chế mới: nested chats và group chat có planning agent |

Kết luận đối chiếu: nếu 140 là bản đồ, 143 là một thành phố trên bản đồ được phóng to — pattern multi-agent collaboration với đủ thang cơ chế (2 agent → tuần tự → lồng nhau → tool → code → nhóm có planner). Học 143 sau 140 cho thấy rõ: các cơ chế của AutoGen không phải pattern mới, mà là **cách đóng gói** các pattern đã biết vào một framework hội thoại.

## 10. Đề xuất áp dụng cho team

1. **Giữ nguyên kiến trúc hiện tại** (phân cấp, task file là nguồn sự thật, worker không tự merge) — khóa xác nhận từ phía framework rằng tách vai viết/chạy và có cổng điều phối là thiết kế đúng; team đang làm đúng ở tầng quy trình.
2. **Cân nhắc nested reflection có trace cho worker (đề xuất có điều kiện, chưa làm ngay):** worker tự phê bình bản nháp 1 vòng trước khi nộp review, ghi vào task file số vòng + thay đổi chính — chỉ áp dụng nếu chị cả đồng ý và có luật ghi trace, để không mất tính truy vết (§4).
3. **Không cài AutoGen hay framework hội thoại mới cho team** — AutoGen đang maintenance mode, và hệ task-file hiện tại đã truy vết tốt hơn hội thoại tự do cho việc merge/push có hậu quả thật (§1, §8).
4. **Dùng thang cơ chế của khóa làm checklist chọn mức tự chủ:** việc thứ tự rõ → sequential (§3); việc cần tự sửa → reflection có đo (§4, nối 140 §3); việc cần dữ liệu thật → tool (§5); việc sinh code → sandbox + cổng duyệt (§6); chỉ khi thật cần nhiều vai + kế hoạch động mới dùng group chat/planning (§7) — và khi đó phải kèm evals (132) + guardrails (135) + red-teaming (137).

## Nguồn

- Trang khóa chính thức (mục tiêu, 4 pattern, outline 8 bài/6 ví dụ code, Beginner 1h35m, Published 2024-05-29, Updated 2025-10-07, PRO): https://www.deeplearning.ai/courses/ai-agentic-design-patterns-with-autogen
- Trang giới thiệu khóa (6 bài thực hành: standup comedy, onboarding, blogpost reflection/nested chat, cờ vua tool use, coding/financial analysis, stock report group chat): https://info.deeplearning.ai/new-course-on-agents-enroll-in-ai-agentic-design-patterns-with-autogen
- Bài giới thiệu khóa học (transcript mở đầu: ConversableAgent, sequential chats, nested chat, tool use, coding/code execution, group chat + planning): https://learn-dev.deeplearning.ai/courses/ai-agentic-design-patterns-with-autogen/lesson/kibel/introduction
- Tài liệu AutoGen chính thức — Concurrent Agents (pattern 0.4+: single message/multiple processors, topic routing, direct messaging): https://microsoft.github.io/autogen/0.4.4//user-guide/core-user-guide/design-patterns/concurrent-agents.html
- Tài liệu AutoGen chính thức — Mixture of Agents (worker nhiều lớp + orchestrator): https://microsoft.github.io/autogen/dev/user-guide/core-user-guide/design-patterns/mixture-of-agents.html
- Tổng hợp kiến trúc AutoGen (hội thoại là runtime, 0.2 vs 0.4+, AssistantAgent/UserProxyAgent, GroupChat): https://www.solosoft.dev/post/autogen-multi-agent-2026/
- Trạng thái maintenance mode / hợp nhất vào Microsoft Agent Framework: https://www.clarigital.com/ai-atlas/specialist-tools/agentic-frameworks/autogen/
- Bằng chứng danh sách 32 khóa đã duyệt (AI Agentic Design Patterns with AutoGen là khóa số 14): `research/140-governing-ai-agents-deeplearning-ai.md` trên main
