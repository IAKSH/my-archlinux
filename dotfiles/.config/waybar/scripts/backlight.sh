#!/usr/bin/env bash
# 屏幕亮度（JSON）。仅在存在背光设备时由 exec-if 触发，台式机自动隐藏。
dir=$(echo /sys/class/backlight/* 2>/dev/null | tr ' ' '\n' | sed -n '1p')
[ -n "$dir" ] || exit 1

cur=$(cat "$dir/brightness" 2>/dev/null || echo 0)
max=$(cat "$dir/max_brightness" 2>/dev/null || echo 1)
[ "$max" -le 0 ] && max=1

pct=$(( cur * 100 / max ))
if [ "$pct" -le 33 ]; then
    icon="󰃞"
elif [ "$pct" -le 66 ]; then
    icon="󰃟"
else
    icon="󰃠"
fi

printf '{"text":"%s %s%%","class":"screen","tooltip":"屏幕亮度 %s%%"}\n' \
    "$icon" "$pct" "$pct"
