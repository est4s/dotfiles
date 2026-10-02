# Pocket Terminal

Arrow-key / tap launcher menu for Termux on the phone. Opens when Termux
starts:

```
  Termux · Debian (Terminal, Claude Code, Games) · System · Exit
```

- Arrows or `j`/`k` to move, Enter or → to pick, ← / Esc / `q` to go back,
  number keys jump straight to an item. Tapping an item picks it.
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
ln -s /root/neonflap/neonflap.py /root/games/neon-flap
```

## Updating

Edit `menu` in this repo, commit, push, then rerun `install.sh` in Termux.
