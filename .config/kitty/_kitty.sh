#!/usr/bin/env bash
# shellcheck disable=

export EBNIS_KITTY_CONFIG_DIR="${HOME}/.config/kitty"
export EBNIS_KITTY_SESSION_DIR="$EBNIS_KITTY_CONFIG_DIR/.___scratch-sessions"
export EBNIS_KITTY_SOCKET_PATH='unix:/tmp/kitty-ebnis.sock'
export FZF_KITTY_SESSION_OPTS="--height=80% --border-label='Kitty Sessions' --border-label-pos=2 --prompt='Session> ' --preview='cat {} 2>/dev/null'"

if _is_darwin; then
  kt() {
    open -na kitty.app --args "$@"
  }
else
  alias kt=kitty
fi

alias lskd='kt --session $EBNIS_KITTY_SESSION_DIR/dot.kitty-session --start-as=maximized --detach &>/dev/null'
alias ks="kitty +kitten ssh"
alias kt-debug='kt --debug-input'

__fzf_kitty_sessions__() {
  local output
  # shellcheck disable=SC2091
  output=$(
    if [[ -d "$EBNIS_KITTY_SESSION_DIR" ]]; then
      command find "$EBNIS_KITTY_SESSION_DIR" -maxdepth 1 -type f -name "*.kitty-session" 2>/dev/null
    fi |
      FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse" "${FZF_KITTY_SESSION_OPTS-} +m") \
      FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd)
  ) || return
  echo "$output" | copy
  echo "$output"
}
alias ksff='__fzf_kitty_sessions__'
