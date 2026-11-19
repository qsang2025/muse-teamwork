#!/usr/bin/env python3
"""Ap dung cac lenh cua Anh gui tu Dashboard Muse Teamwork qua GitHub issue.

Dashboard (static, khong ghi truc tiep duoc) mo link tao issue moi da dien
san theo mau; Anh bam Submit tren GitHub. Cron muse-teamwork-dashboard-inbox
(15 phut/lan) chay script nay: doc cac issue mo co tieu de bat dau bang
"[dashboard]", ap dung vao tasks/*.json, commit + push, dong issue kem xac
nhan. Chi xu ly issue do qsang2025 (Anh) mo.

Dinh dang issue (do dashboard sinh):
  Tieu de: [dashboard] 094: giao cho muse-2
  Body:
    task: 094
    action: assign | comment | decide | new-task
    assignee: muse-1 | muse-2 | muse-main      (khi action=assign)
    decision: approve | block | reopen | cancel | priority-high | priority-medium | priority-low
    reason: <ly do>                             (khi decide=block/cancel)

  Giao viec moi (mot issue = mot task moi):
    task: new
    action: new-task
    title: <ten viec>
    assignee: muse-1 | muse-2 | muse-main      (thanh preferred_assignee)
    priority: high | medium | low             (mac dinh medium)
    type: vbook-extension | research | ...     (mac dinh vbook-extension)
    repo: Qsang_vbook | muse-teamwork          (mac dinh Qsang_vbook)
    <mo ta viec>
    <noi dung binh luan tu do>                  (khi action=comment)

Neu body thieu khoi header, script thu doc so task + tu khoa tieng Viet tu
tieu de (giao cho / binh luan / duyet / chan / mo lai / huy / uu tien).

Hanh dong ap dung:
  assign   -> preferred_assignee = X (claim-task.sh ton trong truong nay);
              khong doi assignee (quyen claim cua agent).
  comment  -> them dong vao notes: [Dashboard - Anh, dd/mm HH:MM] <text>
  decide approve -> ghi nhan "Anh DUYET" vao notes; viec merge van do
              muse-main/watchdog lam khi du 3 dieu kien (validate +
              device test + install), khong doi status o day.
  decide block   -> status=blocked, blocked_reason=<reason>
  decide reopen  -> status=open, blocked_reason=""
  decide cancel  -> status=cancelled
  decide priority-* -> priority=high|medium|low
  new-task -> tao tasks/<id>-<slug>.json moi tu _template.json (id = so
              lon nhat hien co + 1), preferred_assignee neu co, notes = mo
              ta. Chi Anh moi tao duoc task qua dashboard.

Cach dung:  python3 scripts/apply-dashboard-issues.py [--dry-run]
  --dry-run: chi in ra se lam gi, khong sua file, khong dong issue.
"""
import json
import re
import subprocess
import sys
from datetime import datetime, timedelta, timezone
from glob import glob
from pathlib import Path

REPO = "qsang2025/muse-teamwork"
OWNER_LOGIN = "qsang2025"
REPO_DIR = Path(__file__).resolve().parent.parent
ASSIGNEES = {"muse-1", "muse-2", "muse-main"}
DECISIONS = {"approve", "block", "reopen", "cancel",
             "priority-high", "priority-medium", "priority-low"}
HEADER_KEYS = {"task", "action", "assignee", "decision", "reason", "title",
               "type", "repo"}

VN_TZ = timezone(timedelta(hours=7))


def run(cmd, check=True):
    r = subprocess.run(cmd, cwd=REPO_DIR, capture_output=True, text=True)
    if check and r.returncode != 0:
        raise RuntimeError(f"$ {' '.join(cmd)}\n{r.stdout}{r.stderr}")
    return r


def now_stamp():
    return datetime.now(VN_TZ).strftime("%d/%m %H:%M")


def gh_api(path):
    r = run(["gh", "api", path], check=False)
    if r.returncode != 0:
        raise RuntimeError(f"gh api {path} failed: {r.stderr.strip()}")
    return json.loads(r.stdout or "[]")


def gh_issue_close(number, comment):
    run(["gh", "issue", "close", str(number), "--repo", REPO,
         "--comment", comment], check=False)


def parse_issue(issue):
    """Tra ve dict {task, action, assignee, decision, reason, text} hoac
    (None, ly_do_loi)."""
    title = (issue.get("title") or "").strip()
    body = (issue.get("body") or "").strip()
    m = re.match(r"\[dashboard\]\s*(\d+)\s*:\s*(.*)", title, re.I)
    title_task = m.group(1) if m else None
    title_rest = (m.group(2) if m else "").strip()

    header, free_lines = {}, []
    for line in body.splitlines():
        hm = re.match(r"^(task|action|assignee|decision|reason|title|type|"
                      r"repo|priority)\s*:\s*(.*)$", line.strip(), re.I)
        if hm:
            header[hm.group(1).lower()] = hm.group(2).strip()
        else:
            free_lines.append(line)
    text = "\n".join(free_lines).strip()

    task = header.get("task") or title_task
    action = (header.get("action") or "").lower()
    if not action and title_rest:
        low = title_rest.lower()
        if "giao cho" in low:
            action = "assign"
        elif "bình luận" in low or "binh luan" in low:
            action = "comment"
        elif "duyệt" in low or "duyet" in low:
            action, header["decision"] = "decide", "approve"
        elif "chặn" in low or "chan" in low:
            action, header["decision"] = "decide", "block"
        elif "mở lại" in low or "mo lai" in low:
            action, header["decision"] = "decide", "reopen"
        elif "hủy" in low or "huy" in low:
            action, header["decision"] = "decide", "cancel"
        elif "ưu tiên" in low or "uu tien" in low:
            action = "decide"
            if "cao" in low:
                header["decision"] = "priority-high"
            elif "thấp" in low or "thap" in low:
                header["decision"] = "priority-low"
            else:
                header["decision"] = "priority-medium"
    if action == "assign" and not header.get("assignee"):
        am = re.search(r"(muse-1|muse-2|muse-main)", title_rest, re.I)
        if am:
            header["assignee"] = am.group(1).lower()
    if action == "comment" and not text:
        text = title_rest

    if not task or (not task.isdigit() and task.lower() != "new"):
        return None, "không đọc được số task (thiếu dòng 'task: NNN')."
    if action not in ("assign", "comment", "decide", "new-task"):
        return None, ("không đọc được hành động (cần action: assign / "
                      "comment / decide / new-task).")
    if action == "new-task":
        title_text = header.get("title") or title_rest
        if not title_text:
            return None, "giao việc mới cần có tên việc (dòng 'title: ...')."
        if header.get("assignee", "").lower() not in ASSIGNEES | {""}:
            return None, ("người nhận không hợp lệ (chỉ muse-1, muse-2, "
                          "muse-main).")
        prio = header.get("priority", "medium").lower()
        if prio not in ("high", "medium", "low"):
            return None, "ưu tiên không hợp lệ (chỉ high / medium / low)."
        return {"task": "new", "action": "new-task",
                "assignee": header.get("assignee", "").lower(),
                "decision": "", "reason": "",
                "title": title_text,
                "priority": prio,
                "type": header.get("type", "vbook-extension"),
                "repo": header.get("repo", "Qsang_vbook"),
                "text": text}, None
    if action == "assign" and header.get("assignee", "").lower() not in ASSIGNEES:
        return None, ("người nhận không hợp lệ (chỉ muse-1, muse-2, "
                      "muse-main).")
    if action == "decide" and header.get("decision", "").lower() not in DECISIONS:
        return None, ("quyết định không hợp lệ (approve / block / reopen / "
                      "cancel / priority-high / priority-medium / "
                      "priority-low).")
    if action == "comment" and not text:
        return None, "bình luận trống."
    return {"task": task, "action": action,
            "assignee": header.get("assignee", "").lower(),
            "decision": header.get("decision", "").lower(),
            "reason": header.get("reason", "").strip(),
            "text": text}, None


def find_task_file(task_num):
    hits = sorted(glob(str(REPO_DIR / "tasks" / f"{task_num}-*.json")))
    return Path(hits[0]) if hits else None


def slugify(text):
    import unicodedata
    s = unicodedata.normalize("NFD", text)
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    s = s.replace("đ", "d").replace("Đ", "D").lower()
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s[:50] or "task-moi"


def apply_new_task(p, dry_run):
    """Tao tasks/<id>-<slug>.json moi. Tra ve (True, mo_ta)."""
    nums = []
    for f in glob(str(REPO_DIR / "tasks" / "[0-9]*-*.json")):
        m = re.match(r"(\d+)-", Path(f).name)
        if m:
            nums.append(int(m.group(1)))
    new_id = (max(nums) + 1) if nums else 1
    slug = slugify(p["title"])
    fname = f"{new_id:03d}-{slug}.json"
    template = json.loads((REPO_DIR / "tasks" / "_template.json")
                          .read_text(encoding="utf-8"))
    template.update({
        "id": f"{new_id:03d}-{slug}",
        "title": p["title"],
        "status": "open",
        "type": p["type"],
        "repo": p["repo"],
        "priority": p["priority"],
        "preferred_assignee": p["assignee"],
        "notes": p["text"],
        "created_at": datetime.now(VN_TZ).strftime("%Y-%m-%dT%H:%M:%S+07:00"),
        "created_by": "Anh (dashboard)",
    })
    if not dry_run:
        (REPO_DIR / "tasks" / fname).write_text(
            json.dumps(template, ensure_ascii=False, indent=2,
                       sort_keys=True) + "\n", encoding="utf-8")
    who = f", giao cho {p['assignee']}" if p["assignee"] else ""
    return True, (f"đã tạo task mới {new_id:03d} '{p['title']}'{who} "
                  f"(ưu tiên {p['priority']}).")


def apply_parsed(task_num, p, dry_run):
    """Ap dung vao file task. Tra ve (changed_bool, mo_ta_tieng_Viet)."""
    path = find_task_file(task_num)
    if path is None:
        return False, f"không tìm thấy task {task_num} trong tasks/."
    t = json.loads(path.read_text(encoding="utf-8"))
    stamp = now_stamp()
    notes = t.get("notes") or ""

    def add_note(line):
        return (notes + f"\n\n[Dashboard — Anh, {stamp}] {line}"
                if notes else f"[Dashboard — Anh, {stamp}] {line}")

    if p["action"] == "assign":
        t["preferred_assignee"] = p["assignee"]
        t["notes"] = add_note(f"giao task cho {p['assignee']}.")
        desc = f"đã giao task {task_num} cho {p['assignee']} (preferred_assignee)."
    elif p["action"] == "comment":
        t["notes"] = add_note(p["text"])
        desc = f"đã thêm bình luận của Anh vào task {task_num}."
    else:  # decide
        d = p["decision"]
        if d == "approve":
            extra = (" (task đang review — muse-main sẽ merge khi đủ 3 điều "
                     "kiện validate + device test + install)"
                     if t.get("status") == "review" else "")
            t["notes"] = add_note(f"DUYỆT.{extra}")
            desc = f"đã ghi nhận Anh DUYỆT task {task_num}{extra}."
        elif d == "block":
            t["status"] = "blocked"
            t["blocked_reason"] = p["reason"] or "Anh chặn qua dashboard."
            t["notes"] = add_note(f"chặn task. Lý do: {t['blocked_reason']}")
            desc = f"đã chặn task {task_num} ({t['blocked_reason']})."
        elif d == "reopen":
            t["status"] = "open"
            t["blocked_reason"] = ""
            t["notes"] = add_note("mở lại task.")
            desc = f"đã mở lại task {task_num}."
        elif d == "cancel":
            t["status"] = "cancelled"
            t["notes"] = add_note(f"hủy task. {p['reason']}".strip())
            desc = f"đã hủy task {task_num}."
        else:  # priority-*
            level = d.split("-", 1)[1]
            t["priority"] = level
            t["notes"] = add_note(f"đổi ưu tiên thành {level}.")
            desc = f"đã đổi ưu tiên task {task_num} thành {level}."
    if not dry_run:
        path.write_text(json.dumps(t, ensure_ascii=False, indent=2,
                                   sort_keys=True) + "\n", encoding="utf-8")
    return True, desc


def main():
    dry_run = "--dry-run" in sys.argv
    run(["git", "pull", "--ff-only"])
    issues = gh_api(f"repos/{REPO}/issues?state=open&per_page=100")
    mine = [i for i in issues
            if (i.get("title") or "").strip().lower().startswith("[dashboard]")
            and not i.get("pull_request")]
    print(f"Tim thay {len(mine)} issue [dashboard] dang mo.")
    if not mine:
        return 0
    applied, changed_files = [], set()
    for issue in mine:
        num = issue["number"]
        author = (issue.get("user") or {}).get("login", "")
        if author.lower() != OWNER_LOGIN:
            msg = (f"Issue này không phải của Anh ({author}) nên không áp "
                   f"dụng — chỉ Anh mới ra lệnh qua dashboard.")
            print(f"#{num}: {msg}")
            if not dry_run:
                gh_issue_close(num, msg)
            continue
        parsed, err = parse_issue(issue)
        if err:
            msg = f"Không áp dụng được: {err} Anh sửa lại issue rồi mở lại nhé."
            print(f"#{num}: {msg}")
            if not dry_run:
                gh_issue_close(num, msg)
            continue
        changed, desc = apply_new_task(parsed, dry_run) \
            if parsed["action"] == "new-task" \
            else apply_parsed(parsed["task"], parsed, dry_run)
        if not changed:
            msg = f"Không áp dụng được: {desc}"
            print(f"#{num}: {msg}")
            if not dry_run:
                gh_issue_close(num, msg)
            continue
        changed_files.add(parsed["task"])
        applied.append((num, desc))
        print(f"#{num}: {desc}")
        if not dry_run:
            gh_issue_close(num, f"Đã áp dụng: {desc}\nDashboard sẽ hiện "
                                f"kết quả khi làm mới.")
    if applied and not dry_run:
        run(["git", "add", "tasks/"])
        nums = ", ".join(f"#{n}" for n, _ in applied)
        run(["git", "commit", "-m",
             f"dashboard: ap dung lenh cua Anh tu issue {nums}"])
        run(["git", "push"])
        print(f"Da commit + push ({len(applied)} issue).")
    elif applied:
        print(f"[dry-run] Se commit {len(applied)} thay doi, khong dong issue.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as e:
        print(f"LOI: {e}", file=sys.stderr)
        raise SystemExit(1)
