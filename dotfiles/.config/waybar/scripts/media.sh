#!/usr/bin/env bash
# 无媒体时显示的占位文字。
# 可修改为任意字符串；设为 ""（空字符串）时，无媒体时该区域将完全隐藏。
PLACEHOLDER="无媒体"

status=$(playerctl status 2>/dev/null)

if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    echo ""
else
    echo "$PLACEHOLDER"
fi
