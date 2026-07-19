#!/bin/bash
# Installs the custom Claude Code statusline on this machine.
# Usage: bash install.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

mkdir -p "$CLAUDE_DIR"
cp "$SCRIPT_DIR/statusline-context.sh" "$CLAUDE_DIR/statusline-context.sh"
chmod +x "$CLAUDE_DIR/statusline-context.sh"

if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

tmp=$(mktemp)
jq '.statusLine = {"type": "command", "command": "bash ~/.claude/statusline-context.sh"}' "$SETTINGS" > "$tmp"
mv "$tmp" "$SETTINGS"

echo "Installed statusline-context.sh and wired it up in $SETTINGS"
