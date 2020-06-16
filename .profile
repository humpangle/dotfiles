# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.poetry" ]; then
  export PATH="$HOME/.poetry/bin:$PATH"
  alias poetry-shell='. "$(dirname $(poetry run which python))/activate"'
fi

# start cron job to reclaim WSL2 memory for windows OS re-use every minute
# https://github.com/microsoft/WSL/issues/4166#issuecomment-604707989
if [ -n "$WSL_DISTRO_NAME" ]; then
  sudo /etc/init.d/cron start &> /dev/null
  umask 022

  # if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  #   tmux new-session -A -D -s wiki -c $HOME/wiki &> /dev/null
  # fi
fi
