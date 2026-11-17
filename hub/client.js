#!/usr/bin/env node
/**
 * muse-teamwork hub — client tối giản cho mỗi Muse.
 * Không dependencies (Node >= 18, dùng fetch có sẵn). Không token/password.
 *
 * Cách dùng (thay 100.x.x.x bằng IP Tailscale của máy chạy hub, xem agents.yaml):
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 poll
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 claim 087-novelnext-retest
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 heartbeat 087-novelnext-retest
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 complete 087-novelnext-retest --branch feature/novelnext --notes "ch.1 đọc đủ" --validate PASS --device-test 0 --install 200
 *   (complete có thể nhận thêm --result-json '{"branch":"...","notes":"...","test":{"validate":"PASS"}}'
 *    để gửi result đầy đủ; các cờ --branch/--notes/--validate/--device-test/--install
 *    ghi đè từng trường. Trước đây complete không gửi result nên hub làm rơi
 *    kết quả — đã vá (F-04, 2026-11-17). Server tự merge result vào task,
 *    giữ các trường test đã có.)
 *
 * Khi hub không tới được (lỗi kết nối / timeout): client in hướng dẫn
 * fallback về GitHub — pull repo, đọc tasks/*.json, claim bằng
 * scripts/claim-task.sh. GitHub mới là nguồn sự thật (xem PROTOCOL.md).
 */
'use strict';

const FALLBACK = [
  'Hub không tới được. Fallback về GitHub (nguồn sự thật):',
  '  1. cd muse-teamwork && git pull',
  '  2. Xem task mở: grep -l \'"status": "open"\' tasks/*.json',
  '  3. Claim: ./scripts/claim-task.sh <id> <agent-id>',
  '  4. Làm theo PROTOCOL.md, cập nhật tasks/<id>.json rồi push.',
  'Nếu hub chạy trên máy khác, kiểm tra lại theo docs/SETUP-HUB.md.',
].join('\n');

function usage() {
  console.log('Dùng: node hub/client.js --hub <http://IP:8787> --agent <muse-1|muse-2|muse-main> <poll|claim|heartbeat|complete> [id] [tùy chọn complete]');
  console.log('Ví dụ: node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 poll');
  console.log('       node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 complete 087-novelnext-retest --branch feature/novelnext --validate PASS --device-test 0 --install 200 --notes "ch.1 đọc đủ"');
  console.log('Tùy chọn complete: --branch <b> --notes <n> --validate <v> --device-test <v> --install <v> --result-json \'<json>\'');
  process.exit(2);
}

function parseArgs(argv) {
  const out = { hub: '', agent: '', cmd: '', id: '', opts: {} };
  const FLAGS = ['--branch', '--notes', '--validate', '--device-test', '--install', '--result-json'];
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--hub') out.hub = argv[++i] || '';
    else if (argv[i] === '--agent') out.agent = argv[++i] || '';
    else if (FLAGS.includes(argv[i])) out.opts[argv[i].slice(2)] = argv[++i] || '';
    else if (!out.cmd) out.cmd = argv[i];
    else if (!out.id) out.id = argv[i];
    else {
      console.error('Tham số lạ: ' + argv[i]);
      usage();
    }
  }
  return out;
}

// Dựng result cho complete từ cờ dòng lệnh (vá F-04: trước đây complete
// không gửi result nên hub làm rơi kết quả test/validate/device-test).
function buildResult(opts) {
  let result = {};
  if (opts['result-json']) {
    try { result = JSON.parse(opts['result-json']); }
    catch (e) { console.error('--result-json không phải JSON hợp lệ: ' + e.message); process.exit(2); }
    if (!result || typeof result !== 'object' || Array.isArray(result)) {
      console.error('--result-json phải là object JSON.');
      process.exit(2);
    }
  }
  const test = Object.assign({}, result.test || {});
  if (opts.validate !== undefined) test.validate = opts.validate;
  if (opts['device-test'] !== undefined) test.device_test = opts['device-test'];
  if (opts.install !== undefined) test.install = opts.install;
  if (Object.keys(test).length > 0) result.test = test;
  if (opts.branch !== undefined) result.branch = opts.branch;
  if (opts.notes !== undefined) result.notes = opts.notes;
  return result;
}

async function req(hub, path, method, body) {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), 5000); // timeout 5s như probe
  try {
    const res = await fetch(hub + path, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: body ? JSON.stringify(body) : undefined,
      signal: ctrl.signal,
    });
    const text = await res.text();
    let json = null;
    try { json = JSON.parse(text); } catch (e) { /* không phải JSON */ }
    return { status: res.status, json, text };
  } finally {
    clearTimeout(timer);
  }
}

async function main() {
  const { hub, agent, cmd, id, opts } = parseArgs(process.argv.slice(2));
  if (!hub || !agent || !['poll', 'claim', 'heartbeat', 'complete'].includes(cmd)) usage();
  if (['claim', 'heartbeat', 'complete'].includes(cmd) && !id) {
    console.error('Thiếu id task. Ví dụ: ' + cmd + ' 087-novelnext-retest');
    process.exit(2);
  }
  const base = hub.replace(/\/$/, '');

  let r;
  try {
    if (cmd === 'poll') {
      r = await req(base, '/tasks?status=open', 'GET');
      if (r.status !== 200) {
        console.error('Hub trả mã ' + r.status + ': ' + (r.text || '').slice(0, 200));
        if ([403, 404, 409].includes(r.status)) console.error('Hub vẫn trả lời — xem task khác, đừng làm trùng (PROTOCOL.md §3).');
        process.exit(1);
      }
      const tasks = (r.json && r.json.tasks) || [];
      if (tasks.length === 0) {
        console.log('Không có task open trên hub. Kiểm tra GitHub nữa cho chắc: git pull rồi xem tasks/*.json.');
      } else {
        console.log('Task open (' + tasks.length + '):');
        for (const t of tasks) {
          console.log(' - ' + t.id + ' [' + (t.priority || '?') + '] ' + t.title);
        }
      }
      return;
    }

    const path = cmd === 'claim' ? '/claim' : cmd === 'heartbeat' ? '/heartbeat' : '/complete';
    const body = { id, agent };
    if (cmd === 'complete') {
      const result = buildResult(opts);
      if (Object.keys(result).length > 0) body.result = result;
      else console.error('Lưu ý: complete không kèm result — task sang review nhưng result trống (ghi chú/kết quả test nên điền đủ, xem PROTOCOL.md §4).');
    }
    r = await req(base, path, 'POST', body);
    if (r.status < 200 || r.status >= 300) {
      console.error('Thất bại (mã ' + r.status + '): ' + ((r.json && r.json.error) || r.text || '').toString().slice(0, 300));
      if (r.status === 409) console.error('Task đã có người nhận — xem task khác, đừng làm trùng (PROTOCOL.md §3).');
      if (r.status === 403) console.error('Task này của agent khác — xem task khác, đừng làm trùng (PROTOCOL.md §3).');
      if (r.status === 404) console.error('Không có task này — kiểm tra lại id, xem task mở khác.');
      process.exit(1);
    }
    console.log('OK: ' + JSON.stringify(r.json, null, 2));
  } catch (e) {
    console.error('Không kết nối được hub ' + base + ' (' + (e && e.message || e) + ').');
    console.error(FALLBACK);
    process.exit(1);
  }
}

main();
