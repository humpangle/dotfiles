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

# shellcheck disable=SC2016
export GIT_COMMIT_MESSAGE_FORMAT='- Subject: ~120 chars, no trailing period, starts with JIRA ticket # (e.g., `SCHED-4192`).
  Use @cmd_runner_no_approval tool to run `git branch --show-current | grep -oE "^[A-Z]+-[0-9]+"` to extract JIRA ticket #
- Body: Multi-line explanation of why changes were made (wrap ~120 chars)'

# -----------------------------------------------------------------------------
# ELIXIR
# -----------------------------------------------------------------------------
export ELIXIR_LS_BIN="$HOME/.elixir_ls_ebnis/1.18.4-otp-28--28.0.1--v0.28.0/language_server.sh"
export ELIXIR_LEXICAL_BIN="$HOME/.elixir_lexical_ebnis/1.16.3-otp-26--26.2.5--v0.6.1/bin/start_lexical.sh"
export NVIM_ENABLE_ELIXIR_LS=1
# export NVIM_ENABLE_ELIXIR_LEXICAL=1
# -----------------------------------------------------------------------------
# /END/ ELIXIR
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# DOCKER
# -----------------------------------------------------------------------------
export _DOCKER_LOCAL_LOG_DIR_=.___scratch/docker-logs
# -----------------------------------------------------------------------------
# /END/ DOCKER
# -----------------------------------------------------------------------------

export GIT_SUBMODULE_RESET_ALL='git submodule deinit -f --all
&& rm -rf api.common/*
&& git submodule init
&& git submodule update --force --recursive'
