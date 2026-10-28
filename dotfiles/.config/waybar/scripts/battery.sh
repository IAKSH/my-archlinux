#!/usr/bin/env bash
# 电池状态（JSON）。仅在存在电池设备时由 exec-if 触发，台式机自动隐藏。
dir=$(echo /sys/class/power_supply/BAT* 2>/dev/null | tr ' ' '\n' | sed -n '1p')
[ -n "$dir" ] && [ -e "$dir/capacity" ] || exit 1

cap=$(cat "$dir/capacity" 2>/dev/null || echo 0)
status=$(cat "$dir/status" 2>/dev/null || echo Unknown)

icons=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂂 󰁹)
idx=$(( cap / 10 ))
[ "$idx" -gt 9 ] && idx=9

if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    icon="󰂄"
    cls="charging"
elif [ "$cap" -le 20 ]; then
    icon="${icons[$idx]}"
    cls="critical"
else
    icon="${icons[$idx]}"
    cls="normal"
fi

printf '{"text":"%s %s%%","class":"%s","tooltip":"电量 %s%% · 状态 %s"}\n' \
    "$icon" "$cap" "$cls" "$cap" "$status"
