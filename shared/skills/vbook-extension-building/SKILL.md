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

- Build baseline-first, escalate only on evidence: (a) direct selectors/regex on static HTML, (b) real hrefs/attributes read from the page; use JS-rendered rendering, font decryption, or proxies only after (a) and (b) fail with recorded evidence. In the task report, record every approach tried and its result ('đã thử / không thử lại') so the next worker does not repeat dead ends — searching a state space means marking visited nodes. (Task 118, Elements of AI ch. 2–5.)

- Read a real chapter end to end and compare it with a known opening line or a known passage, and treat mixed character names from other novels or scrambled text as fake content.

- Treat a chapter that returns only a preview, a VIP error or a login error as not readable, even when search and the table of contents work.

- When a site or tool advertises "AI", check what its output is before calling it AI: labels or numbers (recommendations, genre filters, search ranking) mean a discriminative model, not content generation; only newly generated text, images or audio is generative AI. Record which one it is in the report so the team does not call every classifier "AI". (Task 119, Introduction to Generative AI §3.)

- Drop a search path the site blocks and keep the working table of contents and chapter paths, and record the dropped path with its reason.

## Test on the device and merge

- Run the repo validator and count a pass only when it reports PASS with zero warnings for the full registry.

- Run the device test and the install yourself and count the build ready only when every main case returns code 0 and the install returns code 200.

- Write every checklist item like a prompt for an instruction-tuned model: each item needs a measurable pass/fail criterion (validate PASS, device test code 0, install 200), never a vague "test carefully". A vague checklist is a bad prompt and gives a skewed output; fixing the checklist (prompt) is cheaper than changing the process or the tool. (Task 119, Introduction to Generative AI — prompt design vs engineering, PETM.)

- Never conclude 'the site works' from model reasoning alone: every such claim needs live evidence (HTTP status from your machine + device test on the phone). LLMs are Weak AI — large-scale statistical pattern matching, not understanding — so hallucination is expected, not exceptional; verify live before reporting. (Task 118, Elements of AI ch. 1, 5.)

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

## Handle difficult sites (JS-rendered, WAF, font encryption, encoding)

- When the static HTML comes back empty where the chapter should be (for example empty `#text` / `#subtitle` / `#content`), the content loads through JavaScript — use the headless WebView: `Engine.newBrowser()`, `launch(url, 15000)`, then poll `html()` until the content element holds enough text, and always `close()` in a `finally`. Real pattern: `8book/src/chap.js` polls up to 14 times for `#text` to reach 200 characters, and checks the rendered body for login/paywall markers before returning anything. There is no `.get()` API that returns a Document — use only `launch` / `callJs` / `html` / `close`.
- Never fetch in `home.js`: the first tab must be static, because a failed fetch there blocks the whole home page.
- A Cloudflare challenge can return HTTP 200, so never trust `res.ok`: detect it by title ("Just a moment...", or the localized "Chờ một chút..."), body markers (`challenges.cloudflare.com`, `__cf_chl`, `cf-turnstile`), or the `cf-mitigated: challenge` header, then fall back to the WebView, which shares the app browser's cookies — see `isChallengeDoc` / `fetchViaBrowser` in `lib/fetch-helpers.js` and `lib/challenge-handler.js`. If the browser cannot pass either, return a Vietnamese `Response.error` telling the user to verify in the app's built-in browser and come back.
- Never rotate the User-Agent on a site behind Cloudflare: `cf_clearance` is bound to the verified browser's UA, and a rotated UA gets 403 even after the user verified.
- Pace requests (one at a time per host, `rateLimitDelay()` with jitter before each request, never parallel on the same host). On 429 / 405 / 503, back off exponentially with jitter up to 3 times, respect `Retry-After` (cap 30 seconds), record a cooldown, and do not use the browser fallback — same IP, no use. Do not close a source over a single 429 round; retest once after a long quiet period.
- A site that encrypts chapter text with a custom font (`@font-face` + shuffled `cmap`: the DOM text is garbage while the rendered page reads fine) cannot be built: the vBook runtime has no API to load a font or read a `cmap`, so write plainly "cannot build" and close the task instead of guessing a mapping table. (Live-verified 19/11/2026, task 107: fanqienovel.com serves a guest preview whose DOM text holds 150 PUA characters (U+E000–U+F8FF) rendered correctly only by a per-page subset font of SourceHanSansSC (362 glyphs; `cmap` maps PUA codes to bare `gidNNNNN` names with no original Unicode, so the cmap alone cannot decode); the full chapter still sits behind the APP/SVIP login gate, so do not bypass it. Detect this in `chap.js` by PUA ratio and return a clear Vietnamese `Response.error` instead of returning garbage text — see `research/FONT-ENCRYPTION-LIVE-2026-11-19.md`. Do not confuse this with blob encryption like qimao's AES/DES API content, which plain JS in the extension can decrypt.)
- For GBK-encoded Chinese sources, decode with `response.html('gbk')` / `response.text('gbk')` via `lib/gbk.js` (inline it into `src/` at build time), and run search through the site's own form in the WebView so the keyword is encoded in GBK — sending a UTF-8 keyword returns mojibake. Real proof: `jjwxc/src/gbk.js` and `jjwxc/src/search.js`, verified live 19/11/2026 (chapter 1 decodes to the exact fixture opening line).

## Alternatives for better results

- Port from a close base in a fork when one exists, and compare a rival build before you finish your own.

- Prefer a source whose chapters read fully without a login, and keep a login gated source waiting until the user verifies it in the app.

- Check the chapter text yourself from your own machine instead of trusting the site metadata or its claims.
