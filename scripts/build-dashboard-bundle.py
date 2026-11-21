#!/usr/bin/env python3
"""Standalone single-producer bundler for Muse Teamwork Dashboard v2.0.

Reads tasks/*.json, tasks/*/*.json, tasks/archive/*.md, STATUS.md, agents.yaml,
and research/*.md using Python 3 stdlib only (Windows & Linux compatible).
Writes dashboard/tasks-bundle.json and optionally injects window.__DASH_SNAPSHOT__
into dashboard/index.html and syncs it to index.html.
"""

from __future__ import annotations

import argparse
import datetime as dt
import glob
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any

TZ_VN = dt.timezone(dt.timedelta(hours=7))
EXCLUDED_TASK_FILES = {"_template.json", "000-template.json"}
VALID_STATUSES = ("open", "claimed", "doing", "review", "done", "blocked", "cancelled")
NEEDS_ANH_RE = re.compile(
    r"CẦN ANH|CHỜ Anh|cần Anh quyết|chờ Anh quyết|CẦN ANH QUYẾT",
    re.IGNORECASE,
)


def now_vn_iso() -> str:
    """Return current timestamp in +07:00 ISO format."""
    return dt.datetime.now(TZ_VN).strftime("%Y-%m-%dT%H:%M:%S+07:00")


def load_json_safe(path: Path) -> dict[str, Any] | None:
    """Load a JSON file as UTF-8 dict, returning None on error."""
    try:
        with path.open("r", encoding="utf-8") as fh:
            data = json.load(fh)
        return data if isinstance(data, dict) else None
    except (OSError, json.JSONDecodeError):
        return None


def parse_task_num(task_id: str) -> int | None:
    """Extract leading integer task number from task id (e.g. '203-...' or 'closed-108-...')."""
    m = re.match(r"^(?:closed-)?(\d{2,4})\b", str(task_id))
    return int(m.group(1)) if m else None


def load_all_tasks(root: Path) -> list[dict[str, Any]]:
    """Load all task JSON files from tasks/*.json and tasks/*/*.json."""
    tasks_dir = root / "tasks"
    patterns = [str(tasks_dir / "*.json"), str(tasks_dir / "*" / "*.json")]
    seen_paths: set[Path] = set()
    raw_tasks: list[tuple[Path, dict[str, Any]]] = []

    for pat in patterns:
        for file_str in sorted(glob.glob(pat)):
            p = Path(file_str)
            if p in seen_paths or p.name in EXCLUDED_TASK_FILES:
                continue
            seen_paths.add(p)
            data = load_json_safe(p)
            if data is None:
                continue
            rel = p.relative_to(root).as_posix()
            data["_file"] = rel
            data["_is_closed_archive"] = p.name.startswith("closed-")
            raw_tasks.append((p, data))

    def sort_key(item: tuple[Path, dict[str, Any]]) -> tuple[int, str]:
        _, d = item
        num = parse_task_num(str(d.get("id", "")))
        return (num if num is not None else 999999, str(d.get("id", "")))

    raw_tasks.sort(key=sort_key, reverse=True)
    return [d for _, d in raw_tasks]


def parse_agents_yaml(path: Path) -> list[dict[str, Any]]:
    """Parse agents.yaml using stdlib only (no PyYAML dependency)."""
    if not path.is_file():
        return []
    agents: list[dict[str, Any]] = []
    current: dict[str, Any] | None = None
    current_list_key: str | None = None

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.split("#", 1)[0].rstrip()
        if not line.strip():
            continue
        m_item = re.match(r"^\s{2}-\s+id:\s*(.+)$", line)
        if m_item:
            if current is not None:
                agents.append(current)
            current = {"id": m_item.group(1).strip().strip('"\'')}
            current_list_key = None
            continue
        if current is None:
            continue
        m_list = re.match(r"^\s{6}-\s+(.+)$", line)
        if m_list and current_list_key:
            val = m_list.group(1).strip().strip('"\'')
            current.setdefault(current_list_key, []).append(val)
            continue
        m_kv = re.match(r"^\s{4}([a-zA-Z0-9_]+):\s*(.*)$", line)
        if m_kv:
            key, val = m_kv.group(1), m_kv.group(2).strip().strip('"\'')
            if val == "":
                current[key] = []
                current_list_key = key
            elif val.lower() in ("true", "false"):
                current[key] = val.lower() == "true"
                current_list_key = None
            else:
                current[key] = val
                current_list_key = None
    if current is not None:
        agents.append(current)
    return agents


def extract_qsang_meta(status_text: str) -> dict[str, Any]:
    """Extract Qsang_vbook main tip, registry count, and validate status from STATUS.md / local repo."""
    tip = ""
    reg_count = 0
    validate_status = "UNKNOWN"

    for line in status_text.splitlines():
        m_tip = re.search(r"main:\s*([0-9a-f]{7,40})", line)
        if m_tip and not tip:
            tip = m_tip.group(1)
        m_reg = re.search(r"Registry:\s*(\d+)", line)
        if m_reg and not reg_count:
            reg_count = int(m_reg.group(1))
        m_val = re.search(r"Validate:\s*([A-Z]+)", line)
        if m_val and validate_status == "UNKNOWN":
            validate_status = m_val.group(1)
        if tip and reg_count and validate_status != "UNKNOWN":
            break

    # Optional local Qsang_vbook check if present
    qsang_dir = Path.home() / "workspace" / "vbook" / "Qsang_vbook"
    if (qsang_dir / ".git").is_dir():
        try:
            res_tip = subprocess.run(
                ["git", "-C", str(qsang_dir), "rev-parse", "--short", "origin/main"],
                capture_output=True,
                text=True,
                timeout=5,
                check=False,
            )
            if res_tip.returncode == 0 and res_tip.stdout.strip():
                tip = res_tip.stdout.strip()
            res_tree = subprocess.run(
                ["git", "-C", str(qsang_dir), "ls-tree", "-r", "--name-only", "origin/main", "--", "extensions/"],
                capture_output=True,
                text=True,
                timeout=5,
                check=False,
            )
            if res_tree.returncode == 0:
                cnt = sum(1 for ln in res_tree.stdout.splitlines() if "plugin.json" in ln)
                if cnt > 0:
                    reg_count = cnt
        except (OSError, subprocess.SubprocessError):
            pass

    return {
        "main_tip": tip,
        "registry_count": reg_count,
        "validate": validate_status,
    }


def _check_status_md_sync(root: Path, status_text: str, tasks: list[dict[str, Any]]) -> tuple[list[str], int]:
    """Replicate verify-spec.sh section 1b: compare STATUS.md task statuses with tasks/*.json."""
    claimed: dict[str, str] = {}
    status_pat = "|".join(VALID_STATUSES)
    for line in status_text.splitlines():
        if "(cancelled)" in line:
            for n in re.findall(r"#(\d{2,3})", line):
                claimed[n.zfill(3)] = "cancelled"
            continue
        m = re.search(rf"\(({status_pat})\)\s*$", line)
        if m:
            for n in re.findall(r"\b(\d{3})\b", line[: m.start()]):
                claimed[n] = m.group(1)
            continue
        m2 = re.search(rf"\b(\d{{3}}) \(({status_pat})\b", line)
        if m2:
            claimed[m2.group(1)] = m2.group(2)

    top_tasks = [t for t in tasks if Path(t.get("_file", "")).parent.name == "tasks"]
    live_nums: set[str] = set()
    for d in top_tasks:
        if d.get("_is_closed_archive"):
            continue
        m = re.match(r"(\d{2,3})", str(d.get("id", "")))
        if m:
            live_nums.add(m.group(1).zfill(3))

    drifts: list[str] = []
    seen: set[str] = set()
    for d in top_tasks:
        tid = str(d.get("id", ""))
        m = re.match(r"(?:closed-)?(\d{2,3})", tid)
        if not m:
            continue
        num = m.group(1).zfill(3)
        if d.get("_is_closed_archive") and num in live_nums:
            continue
        seen.add(num)
        actual = str(d.get("status", ""))
        if num not in claimed:
            drifts.append(f"task {tid} (status={actual}) không được nhắc trong STATUS.md")
        elif claimed[num] != actual:
            drifts.append(f"STATUS.md ghi {num} ({claimed[num]}) nhưng file {tid} là {actual}")

    for num in sorted(claimed):
        if num not in seen:
            drifts.append(f"STATUS.md nhắc {num} ({claimed[num]}) nhưng không có file task tương ứng")

    return drifts, len(seen)


def run_verify_spec(
    root: Path,
    status_text: str,
    tasks: list[dict[str, Any]],
    qsang_meta: dict[str, Any],
) -> dict[str, Any]:
    """Run verify-spec checks (bash verify-spec.sh when usable, pure-Python equivalent always/fallback)."""
    drifts: list[str] = []
    warns: list[str] = []

    if not status_text:
        drifts.append("thiếu STATUS.md ở gốc repo")
    else:
        sync_drifts, synced_count = _check_status_md_sync(root, status_text, tasks)
        drifts.extend(sync_drifts)

    now_utc = dt.datetime.now(dt.timezone.utc)
    for d in tasks:
        if Path(d.get("_file", "")).parent.name != "tasks":
            continue
        tid = str(d.get("id", "?"))
        status = str(d.get("status", ""))
        updated_at = str(d.get("updated_at", ""))

        if not updated_at:
            drifts.append(f"task {tid}: thiếu updated_at")
        else:
            try:
                ts = dt.datetime.fromisoformat(updated_at)
                if ts.tzinfo is None:
                    ts = ts.replace(tzinfo=TZ_VN)
                age_h = (now_utc - ts.astimezone(dt.timezone.utc)).total_seconds() / 3600
                if status in ("claimed", "doing") and age_h > 48:
                    drifts.append(f"task {tid}: status={status} mà updated_at đã {age_h:.0f}h trước (>48h)")
                elif status == "doing" and age_h > 12:
                    warns.append(f"task {tid}: doing mà updated_at đã {age_h:.0f}h trước (>12h)")
            except ValueError:
                drifts.append(f"task {tid}: updated_at sai định dạng ISO")

        res = d.get("result") or {}
        rb = str(res.get("branch") or "")
        tb = str(d.get("branch") or "")
        if rb and tb and tb != rb:
            drifts.append(f"task {tid}: branch cấp ngoài '{tb}' khác result.branch '{rb}'")
        if rb and not tb:
            drifts.append(f"task {tid}: branch cấp ngoài trống trong khi result.branch có giá trị")
        if len(str(d.get("notes", ""))) > 8000:
            drifts.append(f"task {tid}: notes dài {len(str(d['notes']))} ký tự (>8000, cần archive)")

        if status == "review" and not d.get("_is_closed_archive"):
            typ = str(d.get("type", ""))
            test = res.get("test") or {}
            ev = str(test.get("evidence") or res.get("evidence") or "")
            if typ == "vbook-extension":
                missing = [k for k in ("validate", "device_test", "install") if not test.get(k)]
                if missing:
                    drifts.append(f"task {tid} ở review thiếu trường test: {', '.join(missing)}")
                if not ev:
                    drifts.append(f"task {tid} ở review thiếu evidence (PROTOCOL §11.2)")
            elif typ == "research":
                if not ev or "research/" not in ev:
                    drifts.append(f"task {tid} ở review: evidence phải trỏ tới file research/ (PROTOCOL §11.2)")
            elif not ev:
                drifts.append(f"task {tid} ở review thiếu evidence (PROTOCOL §11.2)")

    ok = len(drifts) == 0
    summary = (
        f"KHÔNG lệch ({len(warns)} cảnh báo)"
        if ok
        else f"CÓ {len(drifts)} DRIFT ({len(warns)} cảnh báo)"
    )

    return {
        "ok": ok,
        "summary": summary,
        "drifts": drifts,
        "warns": warns,
        "checked_at": now_vn_iso(),
        "qsang_main_tip": qsang_meta["main_tip"],
        "qsang_registry_count": qsang_meta["registry_count"],
    }


def extract_needs_anh(tasks: list[dict[str, Any]], status_text: str) -> list[dict[str, Any]]:
    """Extract items needing Anh's decision from tasks and STATUS.md."""
    items: list[dict[str, Any]] = []
    seen_refs: set[str] = set()

    for d in tasks:
        if d.get("_is_closed_archive"):
            continue
        st = str(d.get("status", ""))
        if st in ("blocked", "review", "needs-decision"):
            tid = str(d.get("id", ""))
            num = parse_task_num(tid)
            ref = str(num).zfill(3) if num is not None else tid
            seen_refs.add(ref)
            items.append(
                {
                    "source": "task",
                    "task_id": tid,
                    "task_num": ref,
                    "status": st,
                    "title": str(d.get("title", "")),
                    "assignee": str(d.get("assignee", "")),
                    "snippet": str(d.get("notes", ""))[:240],
                }
            )

    for line in status_text.splitlines():
        if not NEEDS_ANH_RE.search(line):
            continue
        if "Anh đã quyết" in line or "ĐÃ DUYỆT" in line and "CẦN ANH" not in line and "cần Anh" not in line and "CHỜ Anh" not in line:
            continue
        m_num = re.match(r"^\s*-\s*(?:Đã xong:\s*)?(\d{3})\b", line)
        task_num = m_num.group(1) if m_num else ""
        # Extract the specific clause mentioning Anh
        m_clause = re.search(r"([^.;\n]*(?:CẦN ANH|CHỜ Anh|cần Anh quyết|chờ Anh quyết)[^.\n]*)", line, re.I)
        snippet = m_clause.group(1).strip() if m_clause else line.strip()[:240]
        if task_num and task_num in seen_refs:
            continue
        items.append(
            {
                "source": "STATUS.md",
                "task_id": task_num or None,
                "task_num": task_num or None,
                "status": "needs-decision",
                "title": f"Task {task_num} — Chờ Anh quyết" if task_num else "Chờ Anh quyết (STATUS.md)",
                "assignee": "anh",
                "snippet": snippet,
            }
        )

    return items


def build_research_index(root: Path) -> list[dict[str, Any]]:
    """Scan research/*.md (excluding *.WIP.md) and extract metadata."""
    res_dir = root / "research"
    if not res_dir.is_dir():
        return []
    index: list[dict[str, Any]] = []
    for p in sorted(res_dir.glob("*.md"), reverse=True):
        if p.name.endswith(".WIP.md"):
            continue
        try:
            raw = p.read_bytes()
            text = raw.decode("utf-8", errors="replace")
        except OSError:
            continue
        lines = text.splitlines()
        title = p.stem
        for ln in lines:
            s = ln.strip()
            if s.startswith("# "):
                title = s[2:].strip()
                break
        m_num = re.match(r"^(\d{2,4})-", p.name)
        task_num = m_num.group(1) if m_num else ""
        index.append(
            {
                "file": f"research/{p.name}",
                "task_num": task_num,
                "title": title,
                "lines": len(lines),
                "bytes": len(raw),
            }
        )
    return index


def build_learning_tracks(
    tasks: list[dict[str, Any]],
    research_index: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    """Compute learning tracks dynamically from tasks/*.json and research/."""
    res_by_num = {r["task_num"]: r for r in research_index if r.get("task_num")}

    track_defs = [
        {
            "id": "ai-dev-wave",
            "name": "Đợt AI & Dev Web (191–203)",
            "description": "MCP, AI Visibility, Kaggle Agents, LangGraph, Azure/GCP Agents, Odin JS, GitHub Skills, Figma",
            "match": lambda num, d: num is not None and num >= 191,
        },
        {
            "id": "factory-fssc-ops",
            "name": "An toàn thực phẩm FSSC 22000 & Vận hành nhà máy",
            "description": "Danh sách 20 khóa công việc đã duyệt (Mạch A: FSSC/HACCP/GMP + Mạch B: TPM/OEE/Six Sigma/SCM)",
            "match": lambda num, d: num is not None and 171 <= num <= 190,
        },
        {
            "id": "ai-marketing-seo",
            "name": "AI, Marketing, SEO & Analytics (Vinmedia)",
            "description": "Chuỗi khóa AI ứng dụng, Automation, Content, SEO, Ads, Design & Analytics",
            "match": lambda num, d: num is not None and 142 <= num <= 170 and num not in (149, 157),
        },
        {
            "id": "ai-llm-foundations",
            "name": "Nền tảng AI, LLM & Agentic Memory",
            "description": "Generative AI, Prompt Engineering, LangGraph, Memory, Guardrails & Red Teaming",
            "match": lambda num, d: num is not None and 118 <= num <= 140 and num != 133,
        },
    ]

    tracks_map: dict[str, dict[str, Any]] = {
        td["id"]: {
            "id": td["id"],
            "name": td["name"],
            "description": td["description"],
            "total": 0,
            "done": 0,
            "active": 0,
            "open": 0,
            "task_ids": [],
        }
        for td in track_defs
    }
    other_research = {
        "id": "tech-research",
        "name": "Khảo sát kỹ thuật & Hạ tầng vBook",
        "description": "Nghiên cứu anti-bot, font encryption, port news/forum, Discord bridge & kiến trúc team",
        "total": 0,
        "done": 0,
        "active": 0,
        "open": 0,
        "task_ids": [],
    }

    for d in tasks:
        if d.get("_is_closed_archive") or d.get("status") == "cancelled":
            continue
        if d.get("type") != "research":
            continue
        tid = str(d.get("id", ""))
        num = parse_task_num(tid)
        st = str(d.get("status", ""))

        target = other_research
        for td in track_defs:
            if td["match"](num, d):
                target = tracks_map[td["id"]]
                break

        target["total"] += 1
        if st == "done":
            target["done"] += 1
        elif st in ("claimed", "doing", "review", "blocked"):
            target["active"] += 1
        elif st == "open":
            target["open"] += 1

        num_str = str(num).zfill(3) if num is not None else tid
        target["task_ids"].append(
            {
                "id": tid,
                "num": num_str,
                "status": st,
                "title": str(d.get("title", "")),
                "research_file": res_by_num.get(num_str, {}).get("file", ""),
            }
        )

    result = [tracks_map[td["id"]] for td in track_defs if tracks_map[td["id"]]["total"] > 0]
    if other_research["total"] > 0:
        result.append(other_research)
    return result


def list_archives(root: Path) -> list[dict[str, Any]]:
    """List markdown files in tasks/archive/*.md."""
    arch_dir = root / "tasks" / "archive"
    if not arch_dir.is_dir():
        return []
    out: list[dict[str, Any]] = []
    for p in sorted(arch_dir.glob("*.md")):
        try:
            st = p.stat()
            out.append({"file": f"tasks/archive/{p.name}", "bytes": st.st_size})
        except OSError:
            continue
    return out


def inject_html_snapshot(root: Path, bundle: dict[str, Any], quiet: bool = False) -> bool:
    """Inject window.__DASH_SNAPSHOT__ into dashboard/index.html and sync to index.html."""
    dash_html = root / "dashboard" / "index.html"
    root_html = root / "index.html"
    if not dash_html.is_file():
        return False

    html_text = dash_html.read_text(encoding="utf-8")
    snapshot_json = json.dumps(bundle, ensure_ascii=False, separators=(",", ":"))
    # Escape </script> inside JSON to prevent breaking HTML script tag
    snapshot_json = snapshot_json.replace("</", "<\\/")
    replacement = f'<script id="dash-snapshot">window.__DASH_SNAPSHOT__={snapshot_json};</script>'

    pat_tag = re.compile(
        r'<script\s+id=["\']dash-snapshot["\']\s*>.*?</script>',
        re.DOTALL | re.IGNORECASE,
    )
    if pat_tag.search(html_text):
        updated_html = pat_tag.sub(lambda _: replacement, html_text, count=1)
    else:
        pat_var = re.compile(r"window\.__DASH_SNAPSHOT__\s*=\s*\{.*?\};", re.DOTALL)
        if pat_var.search(html_text):
            updated_html = pat_var.sub(
                lambda _: f"window.__DASH_SNAPSHOT__={snapshot_json};", html_text, count=1
            )
        else:
            if not quiet:
                print("WARN: dash-snapshot placeholder not found in dashboard/index.html", file=sys.stderr)
            return False

    dash_html.write_text(updated_html, encoding="utf-8")
    shutil.copyfile(dash_html, root_html)
    return True


def build_bundle(root: Path, quiet: bool = False, no_html: bool = False) -> dict[str, Any]:
    """Build tasks-bundle.json and optionally update HTML snapshots."""
    status_path = root / "STATUS.md"
    status_text = status_path.read_text(encoding="utf-8") if status_path.is_file() else ""

    tasks = load_all_tasks(root)
    agents = parse_agents_yaml(root / "agents.yaml")
    qsang_meta = extract_qsang_meta(status_text)
    spec_check = run_verify_spec(root, status_text, tasks, qsang_meta)
    needs_anh = extract_needs_anh(tasks, status_text)
    research_index = build_research_index(root)
    learning_tracks = build_learning_tracks(tasks, research_index)
    archives = list_archives(root)

    bundle: dict[str, Any] = {
        "schema_version": 2,
        "generated_at": now_vn_iso(),
        "qsang": qsang_meta,
        "spec_check": spec_check,
        "agents": agents,
        "tasks": tasks,
        "needs_anh": needs_anh,
        "research_index": research_index,
        "learning_tracks": learning_tracks,
        "archives": archives,
        "status_text": status_text,
    }

    out_dir = root / "dashboard"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / "tasks-bundle.json"
    out_file.write_text(
        json.dumps(bundle, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )

    html_synced = False
    if not no_html:
        html_synced = inject_html_snapshot(root, bundle, quiet=quiet)

    if not quiet:
        print(
            f"Bundle OK: {len(tasks)} tasks, {len(research_index)} research, "
            f"{len(learning_tracks)} tracks, {len(needs_anh)} needs_anh | "
            f"spec_check={spec_check['ok']} ({spec_check['summary']}) | "
            f"html_synced={html_synced} -> {out_file}"
        )
    return bundle


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")

    parser = argparse.ArgumentParser(description="Build Muse Teamwork dashboard bundle.")
    parser.add_argument("--quiet", action="store_true", help="Suppress stdout summary")
    parser.add_argument("--no-html", action="store_true", help="Skip HTML snapshot injection")
    args = parser.parse_args()

    root = Path(__file__).resolve().parent.parent
    build_bundle(root, quiet=args.quiet, no_html=args.no_html)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
