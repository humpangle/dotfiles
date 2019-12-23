# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'
alias yarnw="yarn workspace "
alias ff='fzf'
alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"

# ENVIRONMENT VARIABLES

export EDITOR="nvim"
# build erlang docs when installing with asdf
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_MANPAGES=yes
export KERL_INSTALL_HTMLDOCS=yes
export PYTHON2="~/.pyenv/versions/2.7.17/bin/python"
export PYTHON3="~/.pyenv/versions/3.7.5/bin/python"

# required to install erlang via asdf
# https://www.geofis.org/en/install/install-on-linux/install-openjdk-8-on-ubuntu-trusty/
# sudo add-apt-repository ppa:openjdk-r/ppa
# sudo apt-get update
# sudo apt-get install openjdk-8-jdk
# sudo update-java-alternatives --list
# sudo update-alternatives --config java
# sudo update-alternatives --config javac
# Check with java -version and javac -version that version 8 is the default JDK.
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# fzf fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# - The first argument to the function ($1) is the base path to start traversal
# Use fd to generate the list for directory completion
 _fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}' "

_fzf_compgen_path() {
  rg --files --hidden --follow --glob '!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}'
}

# If you're running fzf in a large git repository, git ls-tree can boost up the speed of the traversal.
# I found that if I create and save a new file, it does not pick it up.
#export FZF_DEFAULT_COMMAND='
#  (git ls-tree -r --name-only HEAD ||
#   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
#      sed s/^..//) 2> /dev/null'

# darcula color scheme
# eval 'dircolors ~/.dir_colors/dircolors'


# Preprend asdf bin paths for programming executables
export PATH="$HOME/.asdf/installs/elixir/1.9.1-otp-22/bin:$HOME/.asdf/installs/erlang/22.0.7/bin:$HOME/.pyenv/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source $HOME/.poetry/env
alias poetry-shell='. "$(dirname $(poetry run which python))/activate"'
