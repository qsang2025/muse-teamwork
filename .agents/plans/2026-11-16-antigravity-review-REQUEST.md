# Task Request: Antigravity Review & Optimization

- Date: 2026-11-16
- Task: Review & Optimization of `muse-teamwork` Multi-Agent Coordination System
- Repo: `https://github.com/qsang2025/muse-teamwork`
- Working Branch: `feature/antigravity-review` (branched from `main` @ `735a892`)
- Request Source: `docs/ANTIGRAVITY-REVIEW.md`

## 1. Goal
Execute a comprehensive technical review, vulnerability audit, scalability assessment, and optimization plan for `muse-teamwork` according to §5 and §6 of `docs/ANTIGRAVITY-REVIEW.md`. Provide verifiable, concrete evidence and precise code modifications to compile into `ANTIGRAVITY-FINDINGS.md` on branch `feature/antigravity-review`.

## 2. Scope & Core Requirements
The review must thoroughly address all 4 core mandates from §5 and answer all 6 direct questions from §8:
1. **Core Review Mandates (§5):**
   - **(a) Architectural Validation:** Verify GitHub-first + optional hub architecture given VM client-only status and unreachable ports. Evaluate alternative zero-infrastructure designs.
   - **(b) Failure Mode & Edge Case Analysis:** Deep audit on git claim race conditions, merge conflicts on task files, expired claim sweep desynchronization (Hub vs GitHub), out-of-sync Hub vs Git state, unresponsive/abandoned task handling, and single point of failure (SPOF) at muse-main.
   - **(c) Scalability Stress-testing:** Analyze operational breaking points if expanded from 3 agents to 7 agents (3 Muse + 4 Antigravity) across claim, cross-review, merge, and heartbeat channels. Propose concurrency thresholds and task partitioning.
   - **(d) Concrete Actionable Proposals (P0/P1/P2):** Concrete, specific line-by-line modifications (`file:line`), exact replacement code, and unambiguous verification commands.
2. **Direct Questions (§8):**
   - Q1: Is GitHub-first + optional hub sufficient for 3 Muse parallel work? What missing piece is needed?
   - Q2: What is the single biggest design flaw/bottleneck?
   - Q3: Should Tailscale Hub be started immediately or is GitHub-only sufficient for sample tasks 087/088? If started, where and how to verify?
   - Q4: Does Git race claim need stronger locking (e.g. GitHub Issues, PR checks) or is "first push wins" adequate for 3 agents?
   - Q5: Expanding to 7 agents (3 Muse + 4 Antigravity): what breaks first, and should repos or task queues be split?
   - Q6: What additional decisions does Anh need to make before agents start real tasks?

## 3. Definition of Done (DoD)
- [ ] Working branch `feature/antigravity-review` created and checked out from `main` tip `735a892`.
- [ ] Context bundle and Request documents recorded under `.agents/plans/`.
- [ ] Detailed architectural analysis, edge cases, and benchmarks validated with file:line citations and test commands.
- [ ] Final comprehensive report `ANTIGRAVITY-FINDINGS.md` created on branch `feature/antigravity-review`.
- [ ] Zero secrets (tokens, passwords, keys, cookies) present in any file, report, or commit.
- [ ] Status recorded in `.agents/reports/INBOX.md` and concise summary reported back to coordinator.

## 4. Hard Constraints & Prohibitions (§6)
- **REVIEW ONLY**: DO NOT merge into `Qsang_vbook`, DO NOT push directly to `main` of `muse-teamwork`, DO NOT create new tasks in the main repo.
- **NO MODIFICATION OF REAL TASKS**: DO NOT edit open tasks `tasks/087-novelnext-retest.json` or `tasks/088-fork-rescan-13.json`.
- **NO CREDENTIAL LEAKS**: DO NOT write tokens, passwords, keys, or cookies into any file, report, or log.
- **PRESERVE MERGE CONTRACTS**: DO NOT modify the rule that only `muse-main` merges to `Qsang_vbook`, nor alter the auto-merge criteria (`validate PASS` + `device test code 0` + `install code 200`).
- **WORKING BRANCH ISOLATION**: All artifacts and reports remain strictly on `feature/antigravity-review`. DO NOT open PR or merge to `main`.
