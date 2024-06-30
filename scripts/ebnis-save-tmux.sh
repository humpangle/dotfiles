#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

function _ebnis-save-tmux {
  # Do not invoke if there is no active tmux session.
  if ! tmux ls &>/dev/null; then
    return
  fi

  # make-bash-history-unique

  "$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh" "$@" &>/dev/null
}

_ebnis-save-tmux "$@"
