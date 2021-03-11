#!/usr/bin/env bash

# skip the java dependency during installation
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
# Do not build erlang docs when installing with
# asdf cos it's slow and unstable
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_MANPAGES=
export KERL_INSTALL_HTMLDOCS=
# docker remove all containers
alias drac='docker rm $(docker ps -a -q) '
# docker remove all containers force
alias dracf='docker rm $(docker ps -a -q) --force'
alias drmi='docker rmi '
alias drim='docker rmi '
alias dim='docker images '
alias dps='docker ps '
alias dpsa='docker ps -a '
alias dc='docker-compose '
alias dce='docker-compose exec '
alias dcu='docker-compose up '
alias dcrs='docker-compose restart '
alias dcd='docker-compose down '
alias dvra='docker volume rm $(docker volume ls -q)'
alias dvls='docker volume ls'
alias dvlsq='docker volume ls -q'
alias ug='sudo apt update && sudo apt upgrade -y'
alias gc='google-chrome -incognito &'

[ -f $HOME/dotfiles/.pyenv.sh ] && source $HOME/dotfiles/.pyenv.sh
[ -f $HOME/dotfiles/.wsl.sh ] && source $HOME/dotfiles/.wsl.sh
[ -f $HOME/dotfiles/.asdf.sh ] && source $HOME/dotfiles/.asdf.sh

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
# Do not use PHP PEAR when installing PHP with asdf
export PHP_WITHOUT_PEAR='yes'
# heroku autocomplete setup
if [ -x "$(command -v heroku)" ]; then
  HEROKU_AC_BASH_SETUP_PATH=/home/kanmii/.cache/heroku/autocomplete/bash_setup
  test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;
fi
