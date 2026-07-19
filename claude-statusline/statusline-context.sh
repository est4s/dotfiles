#!/bin/bash
# Claude Code status line: shows model name and context window usage.
input=$(cat)

used=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

if [ -z "$total" ] || [ "$total" = "0" ] || [ "$total" = "null" ]; then
  printf "Context: n/a"
  exit 0
fi

fmt_k() {
  awk -v n="$1" 'BEGIN { printf "%.1fk", n/1000 }'
}

# ---- Used-token color thresholds (edit these to adjust) ----
GREEN_BELOW=100000   # used < this          -> green
ORANGE_BELOW=140000  # this <= used < below -> orange; used >= this -> red
# --------------------------------------------------------------

YELLOW="\033[33m"
GREEN="\033[32m"
ORANGE="\033[38;5;208m"
RED="\033[31m"
TEAL="\033[36m"
RESET="\033[0m"

used_fmt=$(fmt_k "$used")
total_fmt=$(fmt_k "$total")

if [ "$used" -lt "$GREEN_BELOW" ] 2>/dev/null; then
  used_color="$GREEN"
elif [ "$used" -lt "$ORANGE_BELOW" ] 2>/dev/null; then
  used_color="$ORANGE"
else
  used_color="$RED"
fi

if [ -n "$model" ]; then
  model_part="${TEAL}[$model] "
else
  model_part=""
fi

if [ -n "$pct" ] && [ "$pct" != "null" ]; then
  pct_fmt=$(awk -v p="$pct" 'BEGIN { printf "%.0f", p }')
  printf "${model_part}${YELLOW}Context: ${used_color}%s${YELLOW}/%s tokens (%s%%)${RESET}" "$used_fmt" "$total_fmt" "$pct_fmt"
else
  printf "${model_part}${YELLOW}Context: ${used_color}%s${YELLOW}/%s tokens${RESET}" "$used_fmt" "$total_fmt"
fi
