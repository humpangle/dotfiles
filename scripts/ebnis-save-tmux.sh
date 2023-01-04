#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

tmux ls &>/dev/null &&
  {
    "$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh" &>/dev/null || true
  }
