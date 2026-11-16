# Context Bundle: Antigravity Review & Optimization

- Date: 2026-11-16
- Repo: `https://github.com/qsang2025/muse-teamwork` (Branch: `feature/antigravity-review`)
- Task: Technical verification, failure-mode audit, scalability analysis, and optimization proposals for `muse-teamwork`
- Purpose: Context bundle for Master/Coordinator planning and sub-agent execution per `quota-workflow` skill.

---

## 1. Repo Layout That Matters
- `README.md` — High-level architecture, 1-page summary, 3-agent table, probe results, task lifecycle diagram.
- `PROTOCOL.md` — Core operating protocol: task lifecycle (`open` -> `claimed` -> `doing` -> `review` -> `done`), 2h claim expiration, anti-duplication rules, merge rules (muse-main only auto-merges), heartbeat.
- `agents.yaml` — Agent registry (3 agents: `muse-main` coordinator on VM, `muse-1` and `muse-2` workers on physical machines). Capabilities, IPs, and Tailscale roles.
- `tasks/` — Task directory containing JSON files acting as Single Source of Truth:
  - `tasks/_template.json` — Base schema for tasks.
  - `tasks/087-novelnext-retest.json` — Real sample task (vbook-extension, open, high priority).
  - `tasks/088-fork-rescan-13.json` — Real sample task (research, open, medium priority).
  - `tasks/README.md` — Guidelines for creating, claiming, and reporting tasks.
- `scripts/` — Git-first operational automation:
  - `scripts/claim-task.sh` — Bash + Python script that pulls rebase, inspects JSON status, claims task with 2h expiration, commits, and pushes.
  - `scripts/new-task.sh` — Bash + Python script generating normalized Vietnamese slugs and IDs.
- `hub/` — Optional live Tailscale coordination server (Node.js, zero dependencies, port 8787):
  - `hub/server.js` — Lightweight HTTP server handling `/health`, `/tasks`, `/claim`, `/heartbeat`, `/complete`.
  - `hub/client.js` — Client CLI with 5s timeout and automatic fallback notice to Git/GitHub.
  - `hub/client.sh` — Shell wrapper for client.
  - `hub/test-local.sh` — Loopback test suite.
- `docs/` — Operational and onboarding guides:
  - `docs/ANTIGRAVITY-REVIEW.md` — Comprehensive review brief (§1-§8) detailing requirements, RACI, risks R1-R10, limits, and review questions.
  - `docs/SETUP-HUB.md` — 3 deployment plans (Plan A: GitHub-only, Plan B: Worker host, Plan C: Anh's PC).
  - `docs/START-MUSE-1.md` & `docs/START-MUSE-2.md` — Onboarding prompts for workers.
- `BUILD-REPORT.md` — Build logs, independent verification results, and fixes for L1-L11.

---

## 2. Project Rules & Mandatory Constraints

### Mandatory Rules (from PROTOCOL.md & AGENTS.md)
1. **GitHub is the Single Source of Truth:** `tasks/*.json` on GitHub is authoritative. Hub is purely optional for latency reduction.
2. **Task Lifecycle & Heartbeat:**
   - Status flow: `open` -> `claimed` -> `doing` -> `review` -> `done` (or `blocked`/`cancelled`).
   - Claim lock expires after 2 hours without heartbeat/progress commit.
   - Workers cannot claim more than 1 build task concurrently.
3. **Merge Authority:**
   - Only `muse-main` merges to `Qsang_vbook` `main`.
   - Auto-merge criteria strictly enforced: `validate PASS` + `device test code 0` + `install code 200`. Workers (`muse-1`, `muse-2`) never push to main or self-merge.
4. **Anti-Duplication Before Build:**
   - Scan target repo (`Qsang_vbook`) registry.
   - Scan `muse-teamwork` active tasks (`tasks/*.json`).
   - Scan `ROADMAP.md` of `Qsang_vbook` (never reopen closed sites without Anh's explicit approval).
5. **Conflict Resolution:**
   - Always `git pull --rebase` before push. First push wins. Rejection means claim lost -> agent yields immediately.
   - No force-pushing to main.

### Hard Prohibitions (docs/ANTIGRAVITY-REVIEW.md §6)
- **Review Only:** Do NOT merge into `Qsang_vbook`, DO NOT push to `main` of `muse-teamwork`, DO NOT create new tasks on `main`.
- **Do NOT touch open tasks:** `tasks/087-novelnext-retest.json` and `tasks/088-fork-rescan-13.json` must remain pristine.
- **Strictly No Secrets:** Never log, store, or output tokens, passwords, API keys, or cookies.
- **Maintain Branch Isolation:** All review outputs and intermediate files must live solely on `feature/antigravity-review`.

---

## 3. Verified Facts & Empirical Baseline

1. **Network Connectivity & Tailscale Inbound Restrictions:**
   - `muse-main` is hosted on a VM configured as a Tailscale client-only node (`can_host_hub: false` in `agents.yaml`). It cannot bind ports for inbound traffic across the tailnet.
   - Empirical probe on 2026-11-16 ~21:44 via proxy `*:3130` to `muse-1` (`100.85.79.92`) and `muse-2` (`100.126.2.102`) on ports 80, 8080, 18080, 3000 returned timeout (exit code 28 / HTTP code 000). Neither worker currently exposes an open listening daemon.
   - Consequently, **GitHub-First (Plan A)** is the only immediately functional communication channel without manual host intervention.
2. **Current Git State:**
   - Upstream main tip: `735a892` (`Add Antigravity review request: idea + plan + goal for muse-teamwork`).
   - Branch `feature/antigravity-review` successfully branched from `735a892`.
3. **Repository Environment:**
   - Debian 12 Linux VM with pre-installed Node v24.22.1, Python 3.12.3, git 2.43.0, gh 2.102.0.
   - Subagents run via `quota-workflow` using `TypeName: "self"`, `Workspace: "inherit"`, `Model: "flash"`.

---

## 4. Key Items for Verification & Optimization (§5 & §8)

### A. Architectural Evaluation (§5.a, §8.Q1, §8.Q3)
- Verify if GitHub-first + optional hub is technically the soundest zero-maintenance pattern for asymmetric network topology (client-only VM vs unexposed physical nodes).
- Evaluate alternatives: GitHub Actions / Webhooks / Issue Ops vs pure git commits vs Cloudflare Worker / VPS hub.
- Assess whether Tailscale Hub should be deployed immediately or deferred until task volume warrants it.

### B. Vulnerabilities & Failure Mode Analysis (§5.b, §8.Q2, §8.Q4)
- **Race Condition in Git Claiming:**
  In `scripts/claim-task.sh`, lines 36-63 do `git pull --rebase` -> python script edits JSON -> `git commit` -> `git push`. If Agent A and Agent B pull simultaneously, Agent A pushes first; Agent B's push will be rejected by remote. When Agent B pulls/rebases, git will detect a merge conflict on the exact same lines of `tasks/<id>.json`. Is the standard rejection and failure handler clean, or will it leave a broken rebase state on worker machines?
- **Desynchronization between Hub and Git:**
  If Hub is active: Agent claims on Hub, but network/process fails before committing to GitHub within 1 hour. Hub marks task `claimed`, while GitHub still shows `open`.
- **Claim Expiration Deadlock:**
  In `hub/server.js:72-86`, `sweepExpired` sweeps expired tasks back to `open` on request. But in GitHub-only mode, there is no background daemon; tasks remain stuck in `claimed` if an agent crashes unless `muse-main` cleans manually.
- **SPOF (Single Point of Failure) at muse-main:**
  `muse-main` is the sole entity with `can_merge_qsang_vbook: true` and the only runner with a verified Android device testing connection (`device-test`). If `muse-main` goes down or exhausts quota, the entire pipeline halts at `review`.

### C. Scalability Analysis: 3 Agents -> 7 Agents (§5.c, §8.Q5)
- Model the impact of scaling from 3 Muse agents to 7 agents (3 Muse + 4 Antigravity).
- Identify which component bottlenecks first:
  1. Git commit lock contention on `main` branch of `muse-teamwork`.
  2. Merge bottleneck at `muse-main` (device testing + verification queue).
  3. GitHub API secondary rate limits on aggressive polling.
  4. Cross-review coordination latency.
- Propose team topology, task queue partitioning (e.g. `tasks/vbook/`, `tasks/research/`), and role specializations.

### D. Prioritized Remediation & Proposals (P0/P1/P2) (§5.d, §8.Q6)
- Formulate concrete recommendations categorized into P0 (blocking), P1 (near-term stability), P2 (long-term scalability).
- Each proposal must have exact file:line references, drop-in replacement code/scripts, and executable verification test cases.

---

## 5. Output Target
- Full technical findings and optimization blueprint compiled in:
  `/home/antigravity/qsang2025/muse-teamwork/ANTIGRAVITY-FINDINGS.md` on branch `feature/antigravity-review`.
