#!/usr/bin/env node
/**
 * muse-teamwork hub — server live TÙY CHỌN (không bắt buộc).
 *
 * ⚠️ CHỈ CHẠY FILE NÀY TRÊN MÁY NÀO NHẬN INBOUND TAILSCALE ĐƯỢC
 * (muse-1 hoặc muse-2 nếu là máy thật, hoặc máy Anh nếu luôn bật).
 * KHÔNG CHẠY TRÊN VM MUSE CHÍNH — VM đó Tailscale client-only, chỉ gọi ra,
 * không nhận inbound, chạy hub ở đó thì không ai kết nối được.
 *
 * Hub chỉ giúp lấy/claim task NHANH hơn. Nguồn sự thật vẫn là file
 * tasks/*.json trên GitHub (xem PROTOCOL.md). Hub chết → fallback GitHub.
 *
 * NGUỒN THẬT DUY NHẤT (vá P0 F-04, 2026-11-17): hub đọc/ghi TRỰC TIẾP các
 * file tasks/<id>.json trong repo — KHÔNG dùng hub/data/tasks.json nữa
 * (file đó từng là bản sao riêng, bị .gitignore bỏ qua, gây split-brain:
 * claim trên hub không thấy trên GitHub và ngược lại). Sau mỗi lần đổi
 * trạng thái, hub tự commit + push lên GitHub (git pull --rebase trước,
 * push lỗi thì rollback commit local — giống cách vá P0 trong
 * scripts/claim-task.sh), để 2 kênh hub và GitHub-only luôn thấy cùng
 * 1 trạng thái. Nếu máy host không tới được GitHub, hub trả 503 và agent
 * fallback về đường GitHub-only (PROTOCOL.md) — không bao giờ ghi state
 * riêng rồi im lặng.
 *
 * Chạy:  node hub/server.js            (mặc định port 8787)
 *        PORT=8787 node hub/server.js
 * Không cần cài thêm gì (Node >= 18, không dependencies). Cần git trong
 * PATH trên máy host để đồng bộ (máy nào chạy hub cũng đã clone repo).
 *
 * Biến môi trường:
 *   TASKS_DIR             thư mục task (mặc định tasks/ cạnh hub/)
 *   HUB_GIT_SYNC=0        tắt đồng bộ git (chỉ ghi file local; chỉ dùng
 *                         để test, không dùng khi chạy thật)
 *   HUB_PULL_INTERVAL_MS  chu kỳ pull định kỳ ở GET /tasks (mặc định 60000)
 *
 * Endpoints:
 *   GET  /health     → { ok, hub, time, store, git_sync }
 *   GET  /tasks      → danh sách task (đọc từ tasks/*.json)
 *   POST /claim      → { id, agent } — claim task open, hết hạn sau 2h
 *   POST /heartbeat  → { id, agent } — gia hạn claim thêm 2h
 *   POST /complete   → { id, agent, result } — task sang review
 *
 * Không có token/password — hub chỉ chạy trong tailnet riêng của Anh,
 * không mở ra internet.
 */
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const PORT = parseInt(process.env.PORT || '8787', 10);
const HOST = '0.0.0.0';
// Nguồn thật duy nhất: thư mục tasks/*.json của repo muse-teamwork.
const TASKS_DIR = path.resolve(process.env.TASKS_DIR || path.join(__dirname, '..', 'tasks'));
const GIT_SYNC = process.env.HUB_GIT_SYNC !== '0';
const CLAIM_TTL_MS = 2 * 60 * 60 * 1000; // claim hết hạn sau 2h không heartbeat
const PULL_INTERVAL_MS = parseInt(process.env.HUB_PULL_INTERVAL_MS || '60000', 10);
const GIT_TIMEOUT_MS = 30000;
const HUB_AUTHOR = ['-c', 'user.name=muse-teamwork-hub', '-c', 'user.email=hub@muse-teamwork.local'];

let lastPullAt = 0;

function git(args) {
  return execFileSync('git', args, { encoding: 'utf8', timeout: GIT_TIMEOUT_MS, stdio: ['ignore', 'pipe', 'pipe'] });
}

function gitErr(e) {
  const s = ((e && e.stderr ? String(e.stderr) : '') + ' ' + (e && e.message ? e.message : '')).trim();
  return (s || 'lỗi git không rõ').slice(0, 300);
}

// Repo git chứa TASKS_DIR (để pull/push). null khi tắt sync hoặc không có repo.
const REPO_ROOT = (() => {
  if (!GIT_SYNC) return null;
  try {
    return git(['-C', TASKS_DIR, 'rev-parse', '--show-toplevel']).trim();
  } catch (e) {
    console.error('[hub] Không tìm được git repo cho ' + TASKS_DIR + ' — tắt đồng bộ git (chỉ ghi file local).');
    return null;
  }
})();

function gitPull() {
  if (!REPO_ROOT) return { ok: false, error: 'đồng bộ git đang tắt hoặc không có git repo' };
  try {
    git(['-C', REPO_ROOT, 'pull', '--rebase', '--autostash', '-q']);
    lastPullAt = Date.now();
    return { ok: true };
  } catch (e) {
    return { ok: false, error: 'git pull lỗi: ' + gitErr(e) };
  }
}

// Commit + push mọi file tasks/ đã đổi. Push lỗi → rollback commit local ngay
// (giống cách vá P0 trong scripts/claim-task.sh) để không để lại commit rác.
function gitSync(message) {
  if (!REPO_ROOT) return { ok: true, synced: false, note: 'đồng bộ git đang tắt' };
  try {
    git(['-C', REPO_ROOT, 'add', 'tasks/']);
    let staged = true;
    try {
      git(['-C', REPO_ROOT, 'diff', '--cached', '--quiet']);
      staged = false; // exit 0 = không có gì staged
    } catch (e) {
      staged = true; // exit 1 = có thay đổi staged
    }
    if (!staged) return { ok: true, synced: true, nothing: true };
    git(['-C', REPO_ROOT, ...HUB_AUTHOR, 'commit', '-q', '-m', message]);
    try {
      git(['-C', REPO_ROOT, 'push', '-q']);
    } catch (e) {
      try { git(['-C', REPO_ROOT, 'reset', '--hard', 'HEAD~1', '-q']); } catch (_) { /* bỏ qua */ }
      return { ok: false, error: 'git push lỗi: ' + gitErr(e) };
    }
    return { ok: true, synced: true };
  } catch (e) {
    return { ok: false, error: 'git sync lỗi: ' + gitErr(e) };
  }
}

// Giờ ISO theo múi +07:00 — cùng định dạng scripts/claim-task.sh ghi
// (vd 2026-11-17T08:30:00+07:00). new Date() đọc được cả 2 dạng.
function iso07(d) {
  const t = new Date(d.getTime() + 7 * 60 * 60 * 1000);
  const p = (n) => String(n).padStart(2, '0');
  return t.getUTCFullYear() + '-' + p(t.getUTCMonth() + 1) + '-' + p(t.getUTCDate()) +
    'T' + p(t.getUTCHours()) + ':' + p(t.getUTCMinutes()) + ':' + p(t.getUTCSeconds()) + '+07:00';
}

function taskFiles() {
  const top = fs.readdirSync(TASKS_DIR)
    .filter((f) => f.endsWith('.json') && f !== '_template.json' && f !== '000-template.json')
    .sort()
    .map((f) => path.join(TASKS_DIR, f));
  // Sharding P2.2 (2026-11-17): đọc thêm 1 tầng thư mục con (tasks/vbook/,
  // tasks/research/, tasks/infra/, tasks/archive/). Không đệ quy sâu hơn.
  const sub = [];
  for (const d of fs.readdirSync(TASKS_DIR, { withFileTypes: true })) {
    if (!d.isDirectory()) continue;
    const dir = path.join(TASKS_DIR, d.name);
    for (const f of fs.readdirSync(dir).sort()) {
      if (f.endsWith('.json') && f !== '_template.json' && f !== '000-template.json') {
        sub.push(path.join(dir, f));
      }
    }
  }
  return top.concat(sub.sort());
}

// Đọc toàn bộ task thật từ tasks/*.json + tasks/*/*.json (_template.json là mẫu, không phải task).
function loadTasks() {
  const tasks = {};
  for (const file of taskFiles()) {
    try {
      const t = JSON.parse(fs.readFileSync(file, 'utf8'));
      if (!t || !t.id) {
        console.error('[hub] Bỏ qua file task không có id: ' + file);
        continue;
      }
      tasks[t.id] = t;
    } catch (e) {
      console.error('[hub] Không đọc được file task (bỏ qua): ' + file + ' — ' + (e && e.message || e));
    }
  }
  return tasks;
}

// Tìm file thật của task: tasks/<id>.json trước, rồi tasks/*/<id>.json
// (1 tầng, sharding P2.2). Cần thiết để saveTask() không ghi nhầm task
// trong thư mục con ra tầng trên (gây trùng task 2 chỗ).
function taskFile(id) {
  const top = path.join(TASKS_DIR, id + '.json');
  if (fs.existsSync(top)) return top;
  for (const d of fs.readdirSync(TASKS_DIR, { withFileTypes: true })) {
    if (!d.isDirectory()) continue;
    const f = path.join(TASKS_DIR, d.name, id + '.json');
    if (fs.existsSync(f)) return f;
  }
  return top; // chưa có file → mặc định tầng trên cùng
}

function readFileOrNull(file) {
  try { return fs.readFileSync(file, 'utf8'); } catch (e) { return null; }
}

// Ghi file task: ghi file tạm rồi rename (tránh file dở dang nếu crash giữa chừng).
function saveTask(t) {
  const file = taskFile(t.id);
  const tmp = file + '.tmp-' + process.pid;
  fs.writeFileSync(tmp, JSON.stringify(t, null, 2) + '\n');
  fs.renameSync(tmp, file);
}

function send(res, code, obj) {
  const body = JSON.stringify(obj);
  res.writeHead(code, { 'Content-Type': 'application/json' });
  res.end(body);
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', (c) => { data += c; if (data.length > 1e6) req.destroy(); });
    req.on('end', () => {
      if (!data) return resolve({});
      try { resolve(JSON.parse(data)); } catch (e) { reject(new Error('JSON không hợp lệ')); }
    });
    req.on('error', reject);
  });
}

// Claim quá 2h không heartbeat → trả task về open. Trả về id các task đã thu hồi.
// Caller phải saveTask() các task này (hàm này chỉ đổi trong bộ nhớ).
function sweepExpired(tasks) {
  const swept = [];
  const now = Date.now();
  for (const t of Object.values(tasks)) {
    if ((t.status === 'claimed' || t.status === 'doing') && t.claim_expires_at) {
      if (new Date(t.claim_expires_at).getTime() < now) {
        t.status = 'open';
        t.assignee = '';
        t.claimed_at = '';
        t.claim_expires_at = '';
        t.notes = (t.notes || '') + ' [hub: claim hết hạn 2h, trả về open]';
        swept.push(t.id);
      }
    }
  }
  return swept;
}

// Gộp result khi complete: merge nông 1 cấp cho test để không làm rơi
// các trường test đã có (vd chỉ gửi validate thì device_test/install vẫn giữ).
function mergeResult(oldResult, patch) {
  const out = Object.assign({}, oldResult || {});
  for (const [k, v] of Object.entries(patch || {})) {
    if (k === 'test' && v && typeof v === 'object' && !Array.isArray(v)) {
      out.test = Object.assign({}, (oldResult && oldResult.test) || {}, v);
    } else {
      out[k] = v;
    }
  }
  return out;
}

// Pull mới nhất từ GitHub trước khi đổi trạng thái — để không claim/đổi task
// mà agent khác vừa đổi qua đường GitHub-only. Lỗi pull → 503, agent fallback
// về GitHub-only thay vì ghi state riêng rồi im lặng (đó chính là split-brain).
function pullForMutation(res) {
  if (!REPO_ROOT) return true; // sync tắt (chỉ test): cho qua, ghi file local
  const r = gitPull();
  if (!r.ok) {
    send(res, 503, { ok: false, error: r.error + ' — hub không đồng bộ được với GitHub, dùng đường GitHub-only (PROTOCOL.md) thay cho hub lúc này.' });
    return false;
  }
  return true;
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://x');

    if (req.method === 'GET' && url.pathname === '/health') {
      return send(res, 200, { ok: true, hub: 'muse-teamwork', time: new Date().toISOString(), store: 'tasks/*.json', git_sync: !!REPO_ROOT });
    }

    if (req.method === 'GET' && url.pathname === '/tasks') {
      // Pull định kỳ (throttle 60s) để thấy task agent khác đổi qua GitHub.
      // Lỗi pull thì dùng trạng thái local, không chặn đọc.
      if (REPO_ROOT && Date.now() - lastPullAt > PULL_INTERVAL_MS) {
        const r = gitPull();
        if (!r.ok) console.error('[hub] Pull định kỳ lỗi (dùng trạng thái local): ' + r.error);
      }
      const tasks = loadTasks();
      const swept = sweepExpired(tasks);
      for (const sid of swept) saveTask(tasks[sid]);
      const status = url.searchParams.get('status');
      const list = Object.values(tasks).filter((t) => !status || t.status === status);
      return send(res, 200, { tasks: list, source: 'tasks/*.json', synced: !!REPO_ROOT, swept: swept.length });
    }

    if (req.method === 'POST' && url.pathname === '/claim') {
      const { id, agent } = await readBody(req);
      if (!id || !agent) return send(res, 400, { ok: false, error: 'thiếu id hoặc agent' });
      if (!pullForMutation(res)) return;
      const tasks = loadTasks();
      const swept = sweepExpired(tasks);
      for (const sid of swept) saveTask(tasks[sid]);
      const t = tasks[id];
      if (!t) return send(res, 404, { ok: false, error: 'không có task ' + id });
      if (t.status !== 'open' || t.assignee) {
        return send(res, 409, { ok: false, error: 'task đã có người nhận', status: t.status, assignee: t.assignee });
      }
      // F-03 (cùng quy tắc scripts/claim-task.sh): task đã gán cho agent khác
      // (preferred_assignee) thì từ chối claim qua hub — không đi đường vòng.
      if (t.preferred_assignee && t.preferred_assignee !== agent) {
        return send(res, 409, { ok: false, error: 'task đã được gán cho ' + t.preferred_assignee + ' (preferred_assignee) — ' + agent + ' không được claim task này' });
      }
      const before = readFileOrNull(taskFile(id));
      const now = new Date();
      t.status = 'claimed';
      t.assignee = agent;
      t.claimed_at = iso07(now);
      t.claim_expires_at = iso07(new Date(now.getTime() + CLAIM_TTL_MS));
      saveTask(t);
      const sync = gitSync('hub: claim ' + id + ' -> ' + agent);
      if (!sync.ok) {
        if (before !== null) fs.writeFileSync(taskFile(id), before);
        return send(res, 503, { ok: false, error: sync.error + ' — claim chưa ghi, thử lại hoặc dùng GitHub-only (PROTOCOL.md).' });
      }
      return send(res, 200, { ok: true, task: t, synced: true });
    }

    if (req.method === 'POST' && url.pathname === '/heartbeat') {
      const { id, agent } = await readBody(req);
      if (!id || !agent) return send(res, 400, { ok: false, error: 'thiếu id hoặc agent' });
      if (!pullForMutation(res)) return;
      const tasks = loadTasks();
      const swept = sweepExpired(tasks);
      for (const sid of swept) saveTask(tasks[sid]);
      if (swept.includes(id)) {
        return send(res, 409, { ok: false, error: 'claim đã hết hạn 2h, task đã trả về open — claim lại từ đầu' });
      }
      const t = tasks[id];
      if (!t) return send(res, 404, { ok: false, error: 'không có task ' + id });
      if (t.assignee !== agent) {
        return send(res, 403, { ok: false, error: 'task này của ' + (t.assignee || 'chưa ai nhận') });
      }
      if (t.status !== 'claimed' && t.status !== 'doing') {
        return send(res, 409, { ok: false, error: 'task không còn ở trạng thái claimed/doing', status: t.status });
      }
      const before = readFileOrNull(taskFile(id));
      if (t.status === 'claimed') t.status = 'doing';
      t.claim_expires_at = iso07(new Date(Date.now() + CLAIM_TTL_MS));
      saveTask(t);
      const sync = gitSync('hub: heartbeat ' + id + ' (' + agent + ')');
      if (!sync.ok) {
        if (before !== null) fs.writeFileSync(taskFile(id), before);
        return send(res, 503, { ok: false, error: sync.error + ' — heartbeat chưa ghi, thử lại hoặc dùng GitHub-only (PROTOCOL.md).' });
      }
      return send(res, 200, { ok: true, task: t, synced: true });
    }

    if (req.method === 'POST' && url.pathname === '/complete') {
      const { id, agent, result } = await readBody(req);
      if (!id || !agent) return send(res, 400, { ok: false, error: 'thiếu id hoặc agent' });
      if (!pullForMutation(res)) return;
      const tasks = loadTasks();
      const swept = sweepExpired(tasks);
      for (const sid of swept) saveTask(tasks[sid]);
      if (swept.includes(id)) {
        return send(res, 409, { ok: false, error: 'claim đã hết hạn 2h, task đã trả về open — claim lại từ đầu' });
      }
      const t = tasks[id];
      if (!t) return send(res, 404, { ok: false, error: 'không có task ' + id });
      if (t.assignee !== agent) {
        return send(res, 403, { ok: false, error: 'task này của ' + (t.assignee || 'chưa ai nhận') });
      }
      if (t.status !== 'claimed' && t.status !== 'doing') {
        return send(res, 409, { ok: false, error: 'task không còn ở trạng thái claimed/doing', status: t.status });
      }
      const before = readFileOrNull(taskFile(id));
      t.status = 'review';
      if (result) t.result = mergeResult(t.result, result);
      saveTask(t);
      const sync = gitSync('hub: complete ' + id + ' -> review (' + agent + ')');
      if (!sync.ok) {
        if (before !== null) fs.writeFileSync(taskFile(id), before);
        return send(res, 503, { ok: false, error: sync.error + ' — complete chưa ghi, thử lại hoặc dùng GitHub-only (PROTOCOL.md).' });
      }
      return send(res, 200, { ok: true, task: t, synced: true, note: 'muse-main sẽ kiểm tra và merge, xem PROTOCOL.md' });
    }

    return send(res, 404, { ok: false, error: 'không có endpoint này' });
  } catch (e) {
    return send(res, 500, { ok: false, error: String(e && e.message || e) });
  }
});

server.listen(PORT, HOST, () => {
  console.log('muse-teamwork hub đang chạy: http://' + HOST + ':' + PORT);
  console.log('Nguồn thật: ' + TASKS_DIR + ' (tasks/*.json, đọc/ghi trực tiếp)');
  console.log('Đồng bộ git: ' + (REPO_ROOT ? 'BẬT — repo ' + REPO_ROOT : 'TẮT (chỉ ghi file local)'));
  console.log('hub/data/tasks.json KHÔNG còn dùng nữa (vá F-04: hết split-brain).');
  console.log('Nhớ: hub chỉ là tăng tốc — nguồn sự thật vẫn là tasks/*.json trên GitHub.');
});
