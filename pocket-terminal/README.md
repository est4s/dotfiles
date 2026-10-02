# Pocket Terminal

Arrow-key launcher menu for Termux on the phone. Opens when Termux
starts:

```
  Termux · Debian (Terminal, Files, Claude Code, Games) · System · Exit
```

- Arrows or `j`/`k` to move, Enter or → to pick, ← / Esc / `q` to go back,
  number keys jump straight to an item.
- Remembers the last pick in each menu and the chosen theme
  (`~/.local/state/pocket-terminal/state`).
- Status bar (time, Debian installed, free storage, uptime), boot splash
  once per session, themes: neon / amber / phosphor.
- System menu: update Termux + Debian packages, back up Debian to
  `~/backups/`, system info, theme, edit the menu.

Termux only: the PC never uses anything in this folder.

## Install

In Termux (not inside Debian), from a clone of this repo:

```bash
bash ~/dotfiles/pocket-terminal/install.sh
```

If the repo is cloned inside Debian instead:

```bash
bash $(find $PREFIX/var/lib/proot-distro -path '*/root/dotfiles/pocket-terminal/install.sh')
```

This copies `menu` to `~/bin/menu` and appends `bashrc.sh` to
`~/.bashrc` (skipped if `~/.bashrc` already starts the menu). Needs only
bash; no `tput` / ncurses-utils.

## Games

Every file in Debian's `/root/games/` is listed under Games, named after the
file (`neon-flap` → "Neon Flap") and run inside Debian. Add one with:

```bash
ln -s /root/games/neonflap/neonflap.py /root/games/neon-flap
```

## Files

Debian → Files opens Midnight Commander (`mc`) in `/root`, installing it
first if needed. The phone keyboard has no F keys, so press **ESC then a
number** instead (or tap the labels on mc's bottom bar):

| Keys    | Does         | Keys    | Does         |
|---------|--------------|---------|--------------|
| ESC 1   | help         | ESC 6   | move/rename  |
| ESC 2   | user menu    | ESC 7   | new folder   |
| ESC 3   | view file    | ESC 8   | delete       |
| ESC 4   | edit file    | ESC 9   | top menu     |
| ESC 5   | copy         | ESC 0   | quit         |

Select several files with **Ctrl+T**, switch panel with **TAB**, and stack
the two panels top/bottom (better in portrait) with **Alt+,** (ALT key, then comma).

## Updating

Edit `menu` in this repo, commit, push, then rerun `install.sh` in Termux.
