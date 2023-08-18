#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

_IFS=$IFS

function _ebnis-save-tmux {
  if [ -z "${TMUX}" ]; then
    return
  fi

  IFS=$'\n' read -r -d '' -a _current_panes <<<"$(tmux list-panes -a -F "#{pane_id}")"

  for _current_pane in "${_current_panes[@]}"; do
    if ! [[ "${_current_pane}" == "${TMUX_PANE}" ]]; then

      (
        # Background process running in the tmux pane
        tmux send-keys -t "${_current_pane}" 'C-z' Enter
        sleep 1
        # Save bash history
        tmux send-keys -t "${_current_pane}" 'history -w' Enter
        make-bash-history-unique "${_current_pane:1}"
      ) &
    fi
  done

  wait

  tmux send-keys -t "${TMUX_PANE}" 'history -w' Enter
  make-bash-history-unique

  "$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh" &>/dev/null
}

_ebnis-save-tmux

IFS=$_IFS
