# Termux

`bashrc` is Termux's `~/.bashrc` on the phone (outside Debian):

- `deb` / `debc` shortcuts to start Debian, or Debian + Claude Code.
- Starts the [Pocket Terminal](../pocket-terminal/) menu once per session.
- eza and starship, only if installed (`pkg install eza starship`).

## Install

In Termux (not inside Debian):

```bash
cp ~/dotfiles/termux/bashrc ~/.bashrc
```

If the repo is cloned inside Debian instead:

```bash
cp $(find $PREFIX/var/lib/proot-distro -path '*/root/dotfiles/termux/bashrc') ~/.bashrc
```

This overwrites `~/.bashrc`. The menu itself is installed separately by
`pocket-terminal/install.sh`, which skips its `.bashrc` hook when this file
is already in place.
