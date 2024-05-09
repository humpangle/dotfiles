#!/usr/bin/env bash

case $SHELL in
  *"com.termux"*)
    export PYTHON2="$PREFIX/bin/python2"
    export PYTHON3="$PREFIX/bin/python"
    export PGDATA=$PREFIX/var/lib/postgresql
    alias python=python2
    ;;

  *)
    # shellcheck disable=2086
    [ -f $HOME/dotfiles/regular_shell.sh ] && source $HOME/dotfiles/regular_shell.sh
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
