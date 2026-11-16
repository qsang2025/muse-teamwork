#!/usr/bin/env node
/**
 * muse-teamwork hub — client tối giản cho mỗi Muse.
 * Không dependencies (Node >= 18, dùng fetch có sẵn). Không token/password.
 *
 * Cách dùng (thay 100.x.x.x bằng IP Tailscale của máy chạy hub, xem agents.yaml):
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 poll
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 claim 087-novelnext-retest
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 heartbeat 087-novelnext-retest
 *   node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 complete 087-novelnext-retest
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
  console.log('Dùng: node hub/client.js --hub <http://IP:8787> --agent <muse-1|muse-2|muse-main> <poll|claim|heartbeat|complete> [id]');
  console.log('Ví dụ: node hub/client.js --hub http://100.85.79.92:8787 --agent muse-1 poll');
  process.exit(2);
}

function parseArgs(argv) {
  const out = { hub: '', agent: '', cmd: '', id: '' };
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--hub') out.hub = argv[++i] || '';
    else if (argv[i] === '--agent') out.agent = argv[++i] || '';
    else if (!out.cmd) out.cmd = argv[i];
    else if (!out.id) out.id = argv[i];
  }
  return out;
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
  const { hub, agent, cmd, id } = parseArgs(process.argv.slice(2));
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
    r = await req(base, path, 'POST', { id, agent });
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
