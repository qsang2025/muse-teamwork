#!/usr/bin/env bash
# verify-spec.sh — kiểm chứng Living Spec với thực tế.
# CHỈ ĐỌC + BÁO DRIFT, không tự sửa file nào.
# Chạy từ gốc repo muse-teamwork: ./scripts/verify-spec.sh
# Thoát 0 = không lệch, 1 = có DRIFT (WARN không tính là lệch).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
QSANG="$HOME/workspace/vbook/Qsang_vbook"
ROADMAP="$HOME/workspace/vbook/work/ext-review/ROADMAP.md"
DRIFT=0
drift() { echo "DRIFT: $1"; DRIFT=1; }
ok()    { echo "OK: $1"; }
warn()  { echo "WARN: $1"; }

# --- 0. Chuẩn bị: main tip + registry thật của Qsang_vbook ---
if [ -d "$QSANG/.git" ]; then
  TIP=$(git -C "$QSANG" rev-parse --short origin/main 2>/dev/null || echo "")
  REG=$(git -C "$QSANG" ls-tree -r --name-only origin/main -- extensions/ 2>/dev/null | grep -c "plugin.json" || echo "0")
else
  TIP=""; REG="0"
  warn "không có clone Qsang_vbook tại $QSANG — bỏ qua kiểm chứng main tip/registry"
fi
[ -n "$TIP" ] && echo "Thực tế: Qsang_vbook origin/main=$TIP, registry=$REG nguồn"

# --- 1. STATUS.md khớp main tip + registry ---
if [ -f "$ROOT/STATUS.md" ]; then
  STIP=$(grep -o "main: [0-9a-f]*" "$ROOT/STATUS.md" | head -1 | awk '{print $2}')
  SREG=$(grep -o "Registry: [0-9]*" "$ROOT/STATUS.md" | head -1 | awk '{print $2}')
  if [ -n "$TIP" ]; then
    [ "$STIP" = "$TIP" ] && ok "STATUS.md main tip=$STIP khớp origin/main" || drift "STATUS.md main tip=$STIP, thực tế origin/main=$TIP"
    [ "$SREG" = "$REG" ] && ok "STATUS.md registry=$SREG khớp thực tế" || drift "STATUS.md registry=$SREG, thực tế=$REG"
  fi
else
  drift "thiếu STATUS.md ở gốc repo"
fi

# --- 1b. STATUS.md: trạng thái từng task khớp tasks/*.json (vá D8, QA dashboard 19/11) ---
# STATUS.md nhắc trạng thái task theo 3 dạng: "NNN (doing, ...)", "087, 088, ... (done)"
# ở cuối dòng, và "#14, #16, ... (cancelled)". So với file task thật; lệch nào
# cũng là DRIFT (trường hợp 094: STATUS.md ghi doing trong khi file đã review).
SPEC_ROOT="$ROOT" python3 - "$ROOT" <<'PYEOF' || DRIFT=1
import json, glob, os, re, sys
root = sys.argv[1]
st = open(os.path.join(root, "STATUS.md"), encoding="utf-8").read()
claimed = {}
for line in st.splitlines():
    if "(cancelled)" in line:
        for n in re.findall(r"#(\d{2,3})", line):
            claimed[n.zfill(3)] = "cancelled"
        continue
    m = re.search(r"\((open|claimed|doing|review|done|blocked|cancelled)\)\s*$", line)
    if m:
        for n in re.findall(r"\b(\d{3})\b", line[:m.start()]):
            claimed[n] = m.group(1)
        continue
    m2 = re.search(r"\b(\d{3}) \((open|claimed|doing|review|done|blocked|cancelled)\b", line)
    if m2:
        claimed[m2.group(1)] = m2.group(2)
errs = []
seen = set()
files = sorted(glob.glob(os.path.join(root, "tasks", "*.json")))
# So task song (khong tinh closed-*/_template): file closed-* chi duoc tinh
# khi so cua no CHUA dung lai cho task song (108/111 da dung lai tu 19/11).
live_nums = set()
for f in files:
    if os.path.basename(f) == "_template.json":
        continue
    if os.path.basename(f).startswith("closed-"):
        continue
    d = json.load(open(f, encoding="utf-8"))
    m = re.match(r"(\d{2,3})", str(d.get("id", "")))
    if m:
        live_nums.add(m.group(1).zfill(3))
for f in files:
    if os.path.basename(f) == "_template.json":
        continue
    d = json.load(open(f, encoding="utf-8"))
    tid = str(d.get("id", ""))
    m = re.match(r"(?:closed-)?(\d{2,3})", tid)
    if not m:
        continue
    num = m.group(1).zfill(3)
    if os.path.basename(f).startswith("closed-") and num in live_nums:
        continue  # so da dung lai cho task song, bo qua lich su archive
    seen.add(num)
    actual = d.get("status", "")
    if num not in claimed:
        errs.append(f"task {tid} (status={actual}) không được nhắc trong STATUS.md")
    elif claimed[num] != actual:
        errs.append(f"STATUS.md ghi {num} ({claimed[num]}) nhưng file {tid} là {actual}")
for num in sorted(claimed):
    if num not in seen:
        errs.append(f"STATUS.md nhắc {num} ({claimed[num]}) nhưng không có file task tương ứng")
if errs:
    for e in errs:
        print(f"DRIFT: {e}")
    sys.exit(1)
print(f"OK: STATUS.md khớp trạng thái của {len(seen)} task trong tasks/*.json")
PYEOF

# --- 2. Task JSON: updated_at, branch trùng, notes quá dài, claim hết hạn ---
for f in "$ROOT"/tasks/*.json; do
  [ "$(basename "$f")" = "_template.json" ] && continue
  id=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1])).get('id','?'))" "$f")
  python3 - "$f" <<'PYEOF' || DRIFT=1
import json, sys, re
from datetime import datetime, timezone
f = sys.argv[1]
d = json.load(open(f))
errs = []
if not d.get("updated_at"):
    errs.append("thiếu updated_at")
else:
    try:
        ts = datetime.fromisoformat(d["updated_at"])
        age_h = (datetime.now(timezone.utc) - ts).total_seconds() / 3600
        if d.get("status") in ("claimed", "doing") and age_h > 48:
            errs.append(f"status={d['status']} mà updated_at đã {age_h:.0f}h trước (>48h)")
    except ValueError:
        errs.append("updated_at sai định dạng ISO")
rb = (d.get("result") or {}).get("branch") or ""
if rb and d.get("branch") and d["branch"] != rb:
    errs.append(f"branch cấp ngoài '{d['branch']}' khác result.branch '{rb}'")
if rb and not d.get("branch"):
    errs.append("branch cấp ngoài trống trong khi result.branch có giá trị")
if len(str(d.get("notes", ""))) > 8000:
    errs.append(f"notes dài {len(str(d['notes']))} ký tự (>8000, cần archive)")
for e in errs:
    print(f"DRIFT: task {d.get('id')}: {e}")
sys.exit(1 if errs else 0)
PYEOF
done
# (không có DRIFT in ra ở vòng này = các task đều đạt 3 mục trên)

# --- 3. Task done/review: branch đã merge vào main chưa (chỉ kiểm khi ref còn) ---
if [ -d "$QSANG/.git" ]; then
  for f in "$ROOT"/tasks/*.json; do
    [ "$(basename "$f")" = "_template.json" ] && continue
    st=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1])).get('status',''))" "$f")
    br=$(python3 -c "import json,sys; print((json.load(open(sys.argv[1])).get('result') or {}).get('branch',''))" "$f")
    id=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1])).get('id','?'))" "$f")
    [ -z "$br" ] && continue
    case "$st" in
      done|review)
        # Ưu tiên tip của branch local (muse-main giữ nhiều worktree);
        # branch merge bằng rebase/tmp branch thì tip gốc không còn là ancestor
        # dù nội dung đã vào main — trường hợp đó chỉ WARN để kiểm tra tay.
        CAND=""
        if git -C "$QSANG" show-ref --verify --quiet "refs/heads/$br"; then
          CAND=$(git -C "$QSANG" rev-parse "$br")
        elif git -C "$QSANG" show-ref --verify --quiet "refs/remotes/origin/$br"; then
          CAND="origin/$br"
        fi
        if [ -z "$CAND" ]; then
          warn "task $id: branch $br không còn ref local lẫn origin — không kiểm chứng được bằng ref"
        elif git -C "$QSANG" merge-base --is-ancestor "$CAND" origin/main 2>/dev/null; then
          ok "task $id: branch $br đã merge vào main"
        else
          warn "task $id: branch $br ($CAND) chưa phải ancestor của main — có thể merge bằng rebase/tmp branch, kiểm tra tay (vd: extension đã có trong main tree?)"
        fi
        ;;
    esac
  done
fi

# --- 4. ROADMAP local (chỉ kiểm được trên máy muse-main) ---
if [ -f "$ROADMAP" ]; then
  if [ -n "$TIP" ]; then
    grep -q "main $TIP" "$ROADMAP" && ok "ROADMAP nhắc main tip $TIP" || drift "ROADMAP không nhắc main tip thực tế $TIP (footer cũ?)"
    grep -q "$REG nguồn" "$ROADMAP" && ok "ROADMAP nhắc registry $REG nguồn" || drift "ROADMAP không nhắc registry thực tế $REG nguồn"
  fi
  # số mục trong tiêu đề "Chờ Anh chọn" khớp số dòng đang mở thật
  TITLE_N=$(grep -m1 "^## Chờ Anh chọn" "$ROADMAP" | grep -o "([0-9]* mục" | grep -o "[0-9]*" || echo "?")
  OPEN_N=$(python3 - "$ROADMAP" <<'PYEOF'
import sys, re
lines = open(sys.argv[1], encoding="utf-8").read().splitlines()
start = next(i for i, l in enumerate(lines) if l.startswith("## Chờ Anh chọn"))
end = next(i for i, l in enumerate(lines) if i > start and l.startswith("## "))
rows = [l for l in lines[start:end] if l.startswith("|") and not l.startswith("| #") and not l.startswith("|---")]
closed = ["ĐÃ MERGE", "MERGED", "ĐÃ ĐÓNG", "ĐÓNG", "ĐÃ BỎ", "DỪNG", "ĐÃ HỦY"]
print(len([l for l in rows if not any(m in l for m in closed)]))
PYEOF
)
  [ "$TITLE_N" = "$OPEN_N" ] && ok "ROADMAP 'Chờ Anh chọn': tiêu đề ghi $TITLE_N mục, đếm thật $OPEN_N dòng mở" \
    || drift "ROADMAP 'Chờ Anh chọn': tiêu đề ghi $TITLE_N mục nhưng đếm thật $OPEN_N dòng mở"
else
  warn "không có ROADMAP.md local — bỏ qua kiểm chứng ROADMAP (chỉ muse-main có file này)"
fi

if [ "$DRIFT" -eq 0 ]; then echo "KẾT LUẬN: KHÔNG lệch"; else echo "KẾT LUẬN: CÓ DRIFT — xem các dòng DRIFT ở trên"; fi
exit "$DRIFT"
