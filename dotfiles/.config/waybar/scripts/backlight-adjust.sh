#!/usr/bin/env bash
# 调节屏幕亮度（±5%）
set -euo pipefail

dir=$(echo /sys/class/backlight/* 2>/dev/null | tr ' ' '\n' | sed -n '1p')
[ -n "$dir" ] || exit 0

cur=$(cat "$dir/brightness" 2>/dev/null || echo 0)
max=$(cat "$dir/max_brightness" 2>/dev/null || echo 1)
[ "$max" -le 0 ] && max=1

step=$(( max / 20 ))
[ "$step" -lt 1 ] && step=1

case "${1:-}" in
    up) new=$(( cur + step )); [ "$new" -gt "$max" ] && new=$max ;;
    down) new=$(( cur - step )); [ "$new" -lt 1 ] && new=1 ;;
    *) exit 0 ;;
esac

if command -v brightnessctl >/dev/null 2>&1; then
    brightnessctl set "$new" >/dev/null 2>&1 || true
else
    echo "$new" > "$dir/brightness" 2>/dev/null || true
fi

# 通知 waybar 刷新
pkill -RTMIN+9 -x waybar 2>/dev/null || true
