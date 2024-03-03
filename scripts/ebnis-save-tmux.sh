#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

_IFS=$IFS

function _ebnis-save-tmux {
  if [ -z "${TMUX}" ]; then
    return
  fi

  # make-bash-history-unique

  "$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh" &>/dev/null
}

_ebnis-save-tmux

IFS=$_IFS
