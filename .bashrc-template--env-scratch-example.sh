#!/usr/bin/env bash
# shellcheck disable=2034

# Example common entries in `.___scratch-env.sh`

# Allows nvim gf keymap to work properly, especially, in git diff views where the root of the project is not git root
export NVIM_GO_TO_FILE_GF_STRIP_PREFIX=backend/api.scheduler/::/opt/app/

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

# -----------------------------------------------------------------------------
# NVIM
# -----------------------------------------------------------------------------
EBNIS_VIM_THEME=gruvbox8_hard
EBNIS_VIM_THEME=solarized8
export EBNIS_VIM_THEME_BG=l
export EBNIS_VIM_THEME_BG=d
# -----------------------------------------------------------------------------
# /END/ NVIM
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# SSH FROM TERMUX
# -----------------------------------------------------------------------------
export __COPY_PROGRAM__=clip
export ___EBNIS_SMALL_SCREEN___=1
# unset __COPY_PROGRAM__
unset ___EBNIS_SMALL_SCREEN___
# -----------------------------------------------------------------------------
# /END/ SSH FROM TERMUX
# -----------------------------------------------------------------------------
