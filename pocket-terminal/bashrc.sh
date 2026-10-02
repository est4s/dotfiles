# Pocket Terminal launcher menu (~/bin/menu). Shows once per Termux session;
# pick "Termux" or press q to land in this shell, type `menu` to reopen.
# "Exit" in the menu returns 10, which closes the session.
menu() { bash ~/bin/menu "$@"; (($? == 10)) && exit; }
if [[ $- == *i* && -z $MENU_SHOWN ]]; then
  export MENU_SHOWN=1
  menu
  echo "Shortcuts: menu | deb | debc | exit"
  echo
fi
