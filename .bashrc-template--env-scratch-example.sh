#!/usr/bin/env bash
# shellcheck disable=2034

# See $HOME/dotfiles/.bashrc-template--env-scratch-example.sh
# Example common entries in `.___scratch-env.sh`

# Prepend to PATH so your executables/scripts are first in line
export PATH="$PWD/node_modules/.bin/:$PATH"

# When present, invoke with NVIM user command :Lint and keymap <leader>NN
export EBNIS_LINT_CMDS="eslint --fix __f_::stylelint --fix __f_"

# Allows nvim gf keymap to work properly, especially, in git diff views where the root of the project is not git root
export NVIM_GO_TO_FILE_GF_STRIP_PREFIX=backend/api.scheduler/::/opt/app/
export NVIM_GO_TO_FILE_GF_PREPEND_PREFIX=db/changelog/::a/b

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
# LLMs
# -----------------------------------------------------------------------------
# export NVIM_ENABLE_AVANTE_AI_PLUGIN=1
export NVIM_ENABLE_CODECOMPANION_AI_PLUGIN=1
# -----------------------------------------------------------------------------
# /END/ LLMs
# -----------------------------------------------------------------------------
