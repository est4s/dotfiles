#!/bin/bash
# Claude Code status line: shows context window usage only.
input=$(cat)

used=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -z "$total" ] || [ "$total" = "0" ] || [ "$total" = "null" ]; then
  printf "Context: n/a"
  exit 0
fi

fmt_k() {
  awk -v n="$1" 'BEGIN { printf "%.1fk", n/1000 }'
}

YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

used_fmt=$(fmt_k "$used")
total_fmt=$(fmt_k "$total")

if [ "$used" -gt 100000 ] 2>/dev/null; then
  used_color="$RED"
else
  used_color="$YELLOW"
fi

if [ -n "$pct" ] && [ "$pct" != "null" ]; then
  pct_fmt=$(awk -v p="$pct" 'BEGIN { printf "%.0f", p }')
  printf "${YELLOW}Context: ${used_color}%s${YELLOW}/%s tokens (%s%%)${RESET}" "$used_fmt" "$total_fmt" "$pct_fmt"
else
  printf "${YELLOW}Context: ${used_color}%s${YELLOW}/%s tokens${RESET}" "$used_fmt" "$total_fmt"
fi
