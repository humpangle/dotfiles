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

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'
alias yarnw="yarn workspace "
alias yarns="yarn start "
alias ff='fzf'
alias vim="nvim"
alias vi="/usr/bin/vim"
alias vimdiff="nvim -d"
alias c=clear
alias t="tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -s"
alias tks="t kill-session -t"
alias tkss="t kill-server"
alias py='python '
alias pw='prettier --write '

# ENVIRONMENT VARIABLES

export EDITOR="nvim"

case $SHELL in
  *"com.termux"*)
    export PYTHON2="$PREFIX/bin/python2"
    export PYTHON3="$PREFIX/bin/python"
    export PGDATA=$PREFIX/var/lib/postgresql
    alias python=python2
  ;;

  *)
    # Do not build erlang docs when installing with
    # asdf cos it's slow and unstable
    # skip the java dependency during installation
    export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
    export KERL_BUILD_DOCS=
    export KERL_INSTALL_MANPAGES=
    export KERL_INSTALL_HTMLDOCS=
    export PYTHON2="~/.pyenv/versions/2.7.17/bin/python"
    export PYTHON3="~/.pyenv/versions/3.8.2/bin/python"
    # docker remove all containers
    alias drac='docker rm $(docker ps -a -q) '
    # docker remove all containers force
    alias dracf='docker rm $(docker ps -a -q) --force'
    alias drmi='docker rmi '

    if [ -d "$HOME/.pyenv" ]; then
      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$PATH"

      if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
      fi
    fi

    if [ -n "$WSL_DISTRO_NAME" ]; then
      # following needed so that cypress browser testing can work in WSL2
      export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"
      # without the next line, linux executables randomly fail in TMUX in WSL
      export PATH="$PATH:/c/WINDOWS/system32"

      alias wslexe='/c/WINDOWS/system32/wsl.exe '
      # helpers to make WSL play nice
      alias tmux-save="bash $HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh"
    fi

    if [ -d "$HOME/.asdf" ]; then
      . $HOME/.asdf/asdf.sh
      . $HOME/.asdf/completions/asdf.bash

      if command -v asdf 1>/dev/null 2>&1; then
        # Preprend asdf bin paths for programming executables
        # required to use VSCODE for some programming languages

        no_version_set="No version set"

        add_asdf_plugins_to_path() {
          plugin=$1
          activated="$( asdf current $plugin )"

          case "$no_version_set" in
            *$activated*)
              # echo "not activated"
            ;;

            *)
              version="$(echo $activated | cut -d' ' -f1)"
              bin_path="$HOME/.asdf/installs/$plugin/$version/bin"
              export PATH="$bin_path:$PATH"
            ;;
          esac
        }

        # add_asdf_plugins_to_path elixir
        # add_asdf_plugins_to_path erlang
      fi
    fi
  ;;
esac

# ripgrep
RG_OPTIONS="--hidden --follow --glob '!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}'"

# fzf fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
FZF_PREVIEW_APP="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"
export FZF_DEFAULT_OPTS="--layout=reverse --border --bind alt-j:down,alt-k:up $FZF_PREVIEW_APP"
# Use git-ls-files inside git repo, otherwise rg
export FZF_DEFAULT_COMMAND="rg --files $RG_OPTIONS"

_fzf_compgen_dir() {
  rg --files $RG_OPTIONS
}

_fzf_compgen_path() {
  rg --files --hidden --follow --glob '!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}'
}

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
# Do not use PHP PEAR when installing PHP with asdf
export PHP_WITHOUT_PEAR='yes'
