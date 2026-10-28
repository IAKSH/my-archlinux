#!/usr/bin/env bash
# 通知中心：以 mako 历史作为列表，用 hyprlauncher(替代 fuzzel) 挑选展示
set -euo pipefail

history=$(makoctl history -j 2>/dev/null | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    d = []
lines = []
for n in d:
    app = (n.get("app_name") or {}).get("data", "未知应用") or "未知应用"
    summ = (n.get("summary") or {}).get("data", "") or ""
    lines.append(f"{app}：{summ}")
sys.stdout.write("\n".join(lines))
' 2>/dev/null || true)

[ -z "$history" ] && exit 0

printf '%s\n' "$history" | hyprlauncher --dmenu --quiet 2>/dev/null || true
