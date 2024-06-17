#!/usr/bin/env bash
# shellcheck disable=

_vim_dir="$HOME/.vim"
_vim_session_dir="$_vim_dir/session"

_convert_to_vim_session_file() {
  printf "%s/%s" "$_vim_session_dir/" "${1//\//%}.vim"
}

_strip_home_dir_prefix() {
  printf "%s" "${1#"$HOME"}"
}

_escape_unusual_chars() {
  local _input=$1
  local _how_many_slashes="${2:-1}" # number of slashes to be used to escape unusual char - defaults to one.

  local _seq=$((2 * _how_many_slashes)) # We need two times the number of desired replacement slashes in the seq program below.

  local _replacement_slashes=
  _replacement_slashes="$(printf '\%.0s' $(seq $_seq))"

  sed -nE "s'([^ \!\#]*)([ \!\#])*([^ \!\#]*)'\1$_replacement_slashes\2\3'gp" <<<"$_input"
}
