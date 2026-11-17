# vBook Extension Building (bản dùng chung nhà Muse)

> Chị cả (muse-main) viết từ kinh nghiệm làm cùng Anh. Đường dẫn `~/workspace/vbook/...`
> trong file này nghĩa là bản clone Qsang_vbook + ROADMAP trên máy của em — đổi cho đúng
> máy em. Báo cáo thì ghi vào task file theo PROTOCOL.md, không nhắn riêng cho Anh
> từng bước — chị cả sẽ tổng hợp báo Anh sau mỗi task xong.

## Pick and scope the source

- Scan the current repo and its forks before you propose a source, and build only sources that are not already present.

- Check that the site answers live from your machine before you start.

- Record the roadmap number for the source in the ROADMAP.md of Qsang_vbook.

- Build only free content, and never bypass a VIP lock, fake a login or a purchase, or take a token or password from the user through chat.

- Stop and ask the user when a source needs an account, a token or a purchase to read full chapters.

## Build on a branch and verify the content is genuine

- Create a branch named for the source from the current main tip, and back up the work before you edit an existing extension.

- Try both a mobile user agent and a desktop user agent when a site returns an empty template, because some sites serve content only to one of them.

- Read a real chapter end to end and compare it with a known opening line or a known passage, and treat mixed character names from other novels or scrambled text as fake content.

- Treat a chapter that returns only a preview, a VIP error or a login error as not readable, even when search and the table of contents work.

- Drop a search path the site blocks and keep the working table of contents and chapter paths, and record the dropped path with its reason.

## Test on the device and merge

- Run the repo validator and count a pass only when it reports PASS with zero warnings for the full registry.

- Run the device test and the install yourself and count the build ready only when every main case returns code 0 and the install returns code 200.

- Rebase the branch onto the current main tip before you finish, and check the actual main tip before you claim any merge state.

- Never merge Qsang_vbook yourself — only muse-main merges. Your job ends at `review`: push the branch, fill in `result.branch` and `result.test` (validate + device test + install) in the task file, and stop.

- Hold the task and ask (via the task file, status `blocked`) when the content is fake, preview only or login gated, and say plainly which gate failed.

- Tell the user (via the task file) to delete a tested source in the app by hand when the command line cannot uninstall it, because no remote uninstall exists.

## Handle the failures you will meet

- Retry a failed push a few times on a network error and verify the remote main tip after it succeeds.

- Check the device link before every device test and confirm the phone answers, and restart the tailnet forwarder first when the link is dead, because a runtime restart can kill the forwarder and a dead link looks like a site failure.

- Compare the phone result with your own machine before you call a 403 or 429 a site block, and hold the task when your machine returns 200 while the phone returns 403 or 429 or cannot load the chapter images.

- Ask the user (via the task file) for one phone check when only the phone returns 403 or 429, and ask him to open the site in the phone browser and then switch between WiFi and 5G to change the egress IP.

- Retest a 429 once after a long quiet period and then decide, and do not close the source on a single 429 round.

- Close a source the user drops by backing up its branch first, then deleting the branch locally and remotely and leaving main untouched.

- Keep the roadmap current after each project, with the next waiting sources verified live and the closed ones marked closed with their reason.

## Alternatives for better results

- Port from a close base in a fork when one exists, and compare a rival build before you finish your own.

- Prefer a source whose chapters read fully without a login, and keep a login gated source waiting until the user verifies it in the app.

- Check the chapter text yourself from your own machine instead of trusting the site metadata or its claims.
