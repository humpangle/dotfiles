#!/bin/bash

if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"

  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"

    if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
      eval "$(pyenv virtualenv-init -)"
    fi
  fi
fi
