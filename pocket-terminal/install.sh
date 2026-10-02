#!/bin/bash
# Installs the Pocket Terminal launcher menu into Termux.
# Usage (in Termux, not inside Debian): bash install.sh
set -e

if [ -z "$TERMUX_VERSION" ] && [[ $PREFIX != */com.termux/* ]]; then
  echo "Pocket Terminal is for Termux only; nothing installed." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/bin"
cp "$SCRIPT_DIR/menu" "$HOME/bin/menu"
chmod +x "$HOME/bin/menu"

# Hook into ~/.bashrc once (skipped if a menu hook is already there)
if grep -q 'bin/menu' "$HOME/.bashrc" 2>/dev/null; then
  echo "~/.bashrc already starts the menu; left it unchanged"
else
  { echo; cat "$SCRIPT_DIR/bashrc.sh"; } >>"$HOME/.bashrc"
  echo "Added the menu hook to ~/.bashrc"
fi

echo "Installed ~/bin/menu. Open a new session or type: menu"
