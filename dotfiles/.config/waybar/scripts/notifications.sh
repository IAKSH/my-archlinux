#!/usr/bin/env bash
# 通知中心指示器：显示当前 mako 通知数量（用 python3 解析 JSON，不再依赖 jq）
count=0
readarray -t summaries < <( makoctl list -j 2>/dev/null | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    d = []
for n in d:
    s = (n.get("summary") or {}).get("data", "")
    if s:
        print(s)
' )
count=${#summaries[@]}
count=${count:-0}

if [ "$count" -gt 0 ]; then
    text=" $count"
    cls="has-notifications"
    IFS=$'\n'; tooltip="${summaries[*]}"; unset IFS
    tooltip="$tooltip\n---\n点击查看通知"
else
    text=""
    cls="none"
    tooltip="无通知\n---\n点击查看通知"
fi

printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$cls" "$tooltip"
