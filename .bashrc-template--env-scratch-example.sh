#!/usr/bin/env bash
# shellcheck disable=2034

# Example common entries in `.___scratch-env.sh`

# Allows nvim gf keymap to work properly, especially, in git diff views where the root of the project is not git root
export NVIM_GO_TO_FILE_GF_STRIP_PREFIX=backend/api.patients/

# Source python virtualenv helper script
# shellcheck disable=1091
source "$DOTFILE_ROOT/_pv.sh"
# For python projects - invoke virtualenv
_pv -d
_pv

# Use tmux for such things as running tests and one-off commands.
export TMUX_POPUP_SESSION_NAME_AND_PATH="some-session-name:/some-path"
export TMUX_POPUP_SESSION_NAME_AND_PATH="some-session-name"

_setenvs .env.d
