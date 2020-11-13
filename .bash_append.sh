#!/usr/bin/env bash
# export HISTCONTROL=ignoreboth:erasedups
# export PROMPT_COMMAND="history -n; history -w; history -c; history -r"
# tac "$HISTFILE" | awk '!x[$0]++' > /tmp/tmpfile  &&
#                 tac /tmp/tmpfile > "$HISTFILE"
# rm /tmp/tmpfile

[ -f $HOME/dotfiles/.bash_aliases ] && source $HOME/dotfiles/.bash_aliases
[ -f $HOME/dotfiles/.utils.sh ] && source $HOME/dotfiles/.utils.sh
export EDITOR="nvim"

case $SHELL in
  *"com.termux"*)
    export PYTHON2="$PREFIX/bin/python2"
    export PYTHON3="$PREFIX/bin/python"
    export PGDATA=$PREFIX/var/lib/postgresql
    alias python=python2
  ;;

  *)
  [ -f $HOME/dotfiles/.regular_shell.sh ] && source $HOME/dotfiles/.regular_shell.sh
  ;;
esac

[ -f $HOME/dotfiles/.fzf.sh ] && source $HOME/dotfiles/.fzf.sh
