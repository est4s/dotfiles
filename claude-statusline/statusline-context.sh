#!/bin/bash
# Claude Code status line: shows model name, smart context usage, and 5h rate limit.
input=$(cat)

used=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
window_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
model=$(echo "$input" | jq -r '.model.display_name // empty')
five_h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

if [ -z "$window_size" ] || [ "$window_size" = "0" ] || [ "$window_size" = "null" ]; then
  printf "Smart Context: n/a"
  exit 0
fi

fmt_k() {
  awk -v n="$1" 'BEGIN { printf "%.1fk", n/1000 }'
}

# ---- Smart context budget & used-token gradient stops (edit these to adjust) ----
SMART_CONTEXT_LIMIT=140000  # smart context budget shown as the denominator; used can exceed it
GREEN_AT=0                  # used <= this          -> pure green
ORANGE_AT=100000            # used at this point     -> pure orange (midpoint of gradient)
RED_AT=140000               # used >= this           -> pure hot red
# ----------------------------------------------------------------------------

WHITE="\033[37m"
CLAUDE_ORANGE="\033[38;2;218;119;86m"
SLATE_BLUE="\033[38;2;108;113;196m"
RESET="\033[0m"

# Truecolor gradient: green -> orange -> hot red, interpolated smoothly by value.
# Args: value, green_at, orange_at, red_at
gradient_color() {
  awk -v u="$1" -v g_at="$2" -v o_at="$3" -v r_at="$4" 'BEGIN {
    gr=0;   gg=200; gb=0
    orr=255; org=135; orb=0
    rr=255; rg=0;   rb=0
    if (u <= g_at) { r=gr; g=gg; b=gb }
    else if (u < o_at) {
      t = (u-g_at) / (o_at-g_at)
      r = gr  + (orr-gr)*t;  g = gg  + (org-gg)*t;  b = gb  + (orb-gb)*t
    } else if (u < r_at) {
      t = (u-o_at) / (r_at-o_at)
      r = orr + (rr-orr)*t;  g = org + (rg-org)*t;  b = orb + (rb-orb)*t
    } else {
      r=rr; g=rg; b=rb
    }
    printf "\033[38;2;%d;%d;%dm", r, g, b
  }'
}

used_fmt=$(fmt_k "$used")
total_fmt=$(fmt_k "$SMART_CONTEXT_LIMIT")
pct_fmt=$(awk -v u="$used" -v t="$SMART_CONTEXT_LIMIT" 'BEGIN { printf "%.0f", (u/t)*100 }')
used_color=$(gradient_color "$used" "$GREEN_AT" "$ORANGE_AT" "$RED_AT")

if [ -n "$model" ]; then
  model_part="${CLAUDE_ORANGE}[$model]${WHITE} | "
else
  model_part=""
fi

if [ -n "$five_h_pct" ] && [ "$five_h_pct" != "null" ]; then
  five_h_pct_fmt=$(awk -v p="$five_h_pct" 'BEGIN { printf "%.0f", p }')
  five_h_color=$(gradient_color "$five_h_pct" 0 50 100)
  if [ -n "$five_h_resets_at" ] && [ "$five_h_resets_at" != "null" ]; then
    five_h_left_fmt=$(awk -v r="$five_h_resets_at" 'BEGIN {
      diff = r - systime(); if (diff < 0) diff = 0
      h = int(diff/3600); m = int((diff%3600)/60)
      if (h > 0) { printf "%dh %dm", h, m } else { printf "%dm", m }
    }')
    rate_part=$(printf "${WHITE} | ${SLATE_BLUE}5h limit: ${five_h_color}%s%%${WHITE} (%s left)" "$five_h_pct_fmt" "$five_h_left_fmt")
  else
    rate_part=$(printf "${WHITE} | ${SLATE_BLUE}5h limit: ${five_h_color}%s%%" "$five_h_pct_fmt")
  fi
else
  rate_part=""
fi

printf "${model_part}${SLATE_BLUE}Smart Context: ${used_color}%s${WHITE}/%s ${used_color}(%s%%)%s${RESET}" "$used_fmt" "$total_fmt" "$pct_fmt" "$rate_part"
