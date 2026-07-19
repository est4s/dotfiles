# Claude Code Statusline

Custom statusline for Claude Code showing context window usage:
- Whole line renders yellow.
- The used-token count turns red once it exceeds 100k tokens.

## Install on a new machine

Requires `bash`, `jq`, and `awk` (all present in Git Bash on Windows, or natively on macOS/Linux).

```bash
git clone <your-remote-url> ~/dotfiles
bash ~/dotfiles/claude-statusline/install.sh
```

This copies `statusline-context.sh` into `~/.claude/` and merges the
`statusLine` entry into `~/.claude/settings.json` (existing settings are
preserved).

## Updating

Edit `statusline-context.sh` in this repo, commit, push, then on each
other machine:

```bash
cd ~/dotfiles && git pull
bash claude-statusline/install.sh
```
