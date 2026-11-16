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
 * Chạy:  node hub/server.js            (mặc định port 8787)
 *        PORT=8787 node hub/server.js
 * Không cần cài thêm gì (Node >= 18, không dependencies).
 *
 * Endpoints:
 *   GET  /health     → { ok, hub, time }
 *   GET  /tasks      → danh sách task (đọc từ hub/data/tasks.json)
 *   POST /claim      → { id, agent } — claim task open, hết hạn sau 2h
 *   POST /heartbeat  → { id, agent } — gia hạn claim thêm 2h
 *   POST /complete   → { id, agent, result } — task sang review
 *
 * Dữ liệu lưu ở hub/data/tasks.json (file JSON thường, có thể mở đọc tay).
 * Không có token/password — hub chỉ chạy trong tailnet riêng của Anh,
 * không mở ra internet.
 */
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = parseInt(process.env.PORT || '8787', 10);
const HOST = '0.0.0.0';
const DATA_DIR = path.join(__dirname, 'data');
const DATA_FILE = path.join(DATA_DIR, 'tasks.json');
const CLAIM_TTL_MS = 2 * 60 * 60 * 1000; // claim hết hạn sau 2h không heartbeat

fs.mkdirSync(DATA_DIR, { recursive: true });

function loadTasks() {
  try {
    return JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
  } catch (e) {
    return {}; // chưa có file → bắt đầu rỗng
  }
}

function saveTasks(tasks) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(tasks, null, 2) + '\n');
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

function sweepExpired(tasks) {
  // Claim quá 2h không heartbeat → trả task về open.
  const now = Date.now();
  for (const t of Object.values(tasks)) {
    if ((t.status === 'claimed' || t.status === 'doing') && t.claim_expires_at) {
      if (new Date(t.claim_expires_at).getTime() < now) {
        t.status = 'open';
        t.assignee = '';
        t.claimed_at = '';
        t.claim_expires_at = '';
        t.notes = (t.notes || '') + ' [hub: claim hết hạn 2h, trả về open]';
      }
    }
  }
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://x');

    if (req.method === 'GET' && url.pathname === '/health') {
      return send(res, 200, { ok: true, hub: 'muse-teamwork', time: new Date().toISOString() });
    }

    if (req.method === 'GET' && url.pathname === '/tasks') {
      const tasks = loadTasks();
      sweepExpired(tasks);
      saveTasks(tasks);
      const status = url.searchParams.get('status');
      const list = Object.values(tasks).filter((t) => !status || t.status === status);
      return send(res, 200, { tasks: list });
    }

    if (req.method === 'POST' && url.pathname === '/claim') {
      const { id, agent } = await readBody(req);
      if (!id || !agent) return send(res, 400, { ok: false, error: 'thiếu id hoặc agent' });
      const tasks = loadTasks();
      sweepExpired(tasks);
      const t = tasks[id];
      if (!t) return send(res, 404, { ok: false, error: 'không có task ' + id });
      if (t.status !== 'open') {
        return send(res, 409, { ok: false, error: 'task đã có người nhận', status: t.status, assignee: t.assignee });
      }
      const now = new Date();
      t.status = 'claimed';
      t.assignee = agent;
      t.claimed_at = now.toISOString();
      t.claim_expires_at = new Date(now.getTime() + CLAIM_TTL_MS).toISOString();
      saveTasks(tasks);
      return send(res, 200, { ok: true, task: t });
    }

    if (req.method === 'POST' && url.pathname === '/heartbeat') {
      const { id, agent } = await readBody(req);
      if (!id || !agent) return send(res, 400, { ok: false, error: 'thiếu id hoặc agent' });
      const tasks = loadTasks();
      const t = tasks[id];
      if (!t) return send(res, 404, { ok: false, error: 'không có task ' + id });
      if (t.assignee !== agent) {
        return send(res, 403, { ok: false, error: 'task này của ' + (t.assignee || 'chưa ai nhận') });
      }
      if (t.status === 'claimed') t.status = 'doing';
      t.claim_expires_at = new Date(Date.now() + CLAIM_TTL_MS).toISOString();
      saveTasks(tasks);
      return send(res, 200, { ok: true, task: t });
    }

    if (req.method === 'POST' && url.pathname === '/complete') {
      const { id, agent, result } = await readBody(req);
      if (!id || !agent) return send(res, 400, { ok: false, error: 'thiếu id hoặc agent' });
      const tasks = loadTasks();
      const t = tasks[id];
      if (!t) return send(res, 404, { ok: false, error: 'không có task ' + id });
      if (t.assignee !== agent) {
        return send(res, 403, { ok: false, error: 'task này của ' + (t.assignee || 'chưa ai nhận') });
      }
      t.status = 'review';
      if (result) t.result = Object.assign({}, t.result, result);
      saveTasks(tasks);
      return send(res, 200, { ok: true, task: t, note: 'muse-main sẽ kiểm tra và merge, xem PROTOCOL.md' });
    }

    return send(res, 404, { ok: false, error: 'không có endpoint này' });
  } catch (e) {
    return send(res, 500, { ok: false, error: String(e && e.message || e) });
  }
});

server.listen(PORT, HOST, () => {
  console.log('muse-teamwork hub đang chạy: http://' + HOST + ':' + PORT);
  console.log('Dữ liệu: ' + DATA_FILE);
  console.log('Nhớ: hub chỉ là tăng tốc — nguồn sự thật vẫn là tasks/*.json trên GitHub.');
});
