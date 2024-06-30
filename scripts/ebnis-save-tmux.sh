#!/usr/bin/env bash

main() {
  # Do not invoke if there is no active tmux session.
  if ! tmux ls &>/dev/null; then
    return
  fi

  "$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh" "$@" &>/dev/null
}

main "$@"
