#!/usr/bin/env bash
# export HISTCONTROL=ignoreboth:erasedups
# export PROMPT_COMMAND="history -n; history -w; history -c; history -r"
# tac "$HISTFILE" | awk '!x[$0]++' > /tmp/tmpfile  &&
#                 tac /tmp/tmpfile > "$HISTFILE"
# rm /tmp/tmpfile

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

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  vim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}
