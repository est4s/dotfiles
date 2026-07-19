#!/bin/bash
# Claude Code status line: shows model name and smart context usage.
input=$(cat)

used=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
window_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
model=$(echo "$input" | jq -r '.model.display_name // empty')

if [ -z "$window_size" ] || [ "$window_size" = "0" ] || [ "$window_size" = "null" ]; then
  printf "Smart Context: n/a"
  exit 0
fi

fmt_k() {
  awk -v n="$1" 'BEGIN { printf "%.1fk", n/1000 }'
}

# ---- Smart context budget & used-token color thresholds (edit these to adjust) ----
SMART_CONTEXT_LIMIT=140000  # smart context budget shown as the denominator; used can exceed it
GREEN_BELOW=100000          # used < this          -> green
ORANGE_BELOW=140000         # this <= used < below -> orange; used >= this -> red
# -------------------------------------------------------------------------------

YELLOW="\033[33m"
GREEN="\033[32m"
ORANGE="\033[38;5;208m"
RED="\033[31m"
CLAUDE_ORANGE="\033[38;2;218;119;86m"
RESET="\033[0m"

used_fmt=$(fmt_k "$used")
total_fmt=$(fmt_k "$SMART_CONTEXT_LIMIT")
pct_fmt=$(awk -v u="$used" -v t="$SMART_CONTEXT_LIMIT" 'BEGIN { printf "%.0f", (u/t)*100 }')

if [ "$used" -lt "$GREEN_BELOW" ] 2>/dev/null; then
  used_color="$GREEN"
elif [ "$used" -lt "$ORANGE_BELOW" ] 2>/dev/null; then
  used_color="$ORANGE"
else
  used_color="$RED"
fi

if [ -n "$model" ]; then
  model_part="${CLAUDE_ORANGE}[$model]${YELLOW} | "
else
  model_part=""
fi

printf "${model_part}${YELLOW}Smart Context: ${used_color}%s${YELLOW}/%s tokens (%s%%)${RESET}" "$used_fmt" "$total_fmt" "$pct_fmt"
