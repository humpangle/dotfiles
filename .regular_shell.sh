#!/usr/bin/env bash

# Add to $PATH only if `it` does not exist in the $PATH
# fish shell has the `fish_add_path` function which does something similar
# CREDIT: https://unix.stackexchange.com/a/217629
# USAGE:
#     pathmunge /sbin/             ## Add to the start; default
#     pathmunge /usr/sbin/ after   ## Add to the end
pathmunge () {
  # first check if folder exists on filesystem
  if [ -d "$1" ]; then
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
      if [ "$2" = "after" ] ; then
        PATH="$PATH:$1"
      else
        PATH="$1:$PATH"
      fi
    fi
  fi
}

export EDITOR="nvim"

# skip the java dependency during installation
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
# Do not build erlang docs when installing with
# asdf cos it's slow and unstable
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_MANPAGES=
export KERL_INSTALL_HTMLDOCS=
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
pathmunge "$GEM_HOME/bin"
# Do not use PHP PEAR when installing PHP with asdf
export PHP_WITHOUT_PEAR='yes'
# install with: `sudo apt install ssh-askpass-gnome ssh-askpass -y`
export SUDO_ASKPASS=$(which ssh-askpass)

# docker
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
alias ds='sudo service docker start'
alias ug='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias gc='google-chrome -incognito &'

# yarn
alias yw='yarn workspace '
alias yW='yarn -W '
alias ys='yarn start '
alias ylsp='yarn list --pattern '
alias ywhy='yarn why '

# vim
alias vi='/usr/bin/vim'
alias vimdiff="nvim -d"
alias vim="nvim"
alias v="nvim"
alias svim='sudo nvim -u ~/dotfiles/.config/init-min.vim '
alias nvl="VIM_USE_COC=1 nvim "
# set vim theme and background per shell session
# unset
alias vt.='export EBNIS_VIM_THEME='
# vim-one
alias vt1d='export EBNIS_VIM_THEME=vim-one EBNIS_VIM_THEME_BG=d'
alias vt1l='export EBNIS_VIM_THEME="vim-one" EBNIS_VIM_THEME_BG=l'
# vim-gruvbox8
alias vt8d='export EBNIS_VIM_THEME=vim-gruvbox8 EBNIS_VIM_THEME_BG=d'
alias vt8l='export EBNIS_VIM_THEME=vim-gruvbox8 EBNIS_VIM_THEME_BG=l'
# vim-solarized8
alias vtsd='export EBNIS_VIM_THEME=vim-solarized8 EBNIS_VIM_THEME_BG=d'
alias vtsl='export EBNIS_VIM_THEME=vim-solarized8 EBNIS_VIM_THEME_BG=l'
# Set vim fuzzy finder
alias vff.='export EBNIS_VIM_FUZZY_FINDER='
alias vfff='export EBNIS_VIM_FUZZY_FINDER=fzf'
alias vffc='export EBNIS_VIM_FUZZY_FINDER=vim-clap'
alias vscode-vim="MYVIMRC_DIR=$HOME/.config/nvim-vscode/ XDG_DATA_HOME=~/.local/share/nvim-vscode NVIM_RPLUGIN_MANIFEST=~/.local/share/nvim-vscode/rplugin.vim MYVIMRC=$HOME/.config/nvim-vscode/init-vscode.vim nvim -u $HOME/.config/nvim-vscode/init-vscode.vim nvim"

# tmux
alias ta='tmux a -t'
alias tls='tmux ls'
alias tn='tmux new -s '
alias tks='tmux kill-session -t'
alias tkss='tmux kill-server'
alias ts='$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'

# rsync
alias rsynca='rsync -avzP --delete '
alias rsyncd='rsync -avzP --delete --dry-run '

# GIT
alias gss='git status '
# alias gst='git stash '
# alias gsp='git stash pop'
alias gsl='git stash list'
# there is a debian package gsc = gambc
alias gsc='git stash clear'
alias gcma='git commit --amend '
alias gcma='git commit -a '
alias gcme='git commit --amend --no-edit '
alias gcamupm='git commit -am "updated" && git push github master'
alias ga.='git add . '
alias gp='git push '
alias gpgm='git push github master'
# The following command has serious caveats: see wiki/git.md
# deliberately put an error: stash1 instead of stash so that user is forced
# to edit command and put stash message
alias gsstaged='git stash1 push -m "" -- $(git diff --staged --name-only)'
alias gcm='git commit '
alias grb='git rebase -i'
# debian package gpodder=gpo
alias gpo='git push origin'
alias gpf='git push --force origin'
alias glone='git log --oneline'
# there is a debian package gsa = gwenhywfar-tools
function gsa() {
  git stash apply "stash@{$1}"
}

function gsd() {
  git stash drop "stash@{$1}"
}

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias cdo="mkdir -p $HOME/projects/0 && cd $HOME/projects/0"
alias cdp="mkdir -p $HOME/projects && cd $HOME/projects"
alias md='mkdir -p'
alias ff='fzf'
# alias c="clear && printf '\e[3J'"
# alias C=clear
alias py='python '
alias pw='prettier --write '
alias eshell='exec $SHELL'
alias exshell='export SHELL=/usr/bin/bash'
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias hb='sudo systemctl hibernate'
alias luamake=/home/kanmii/.local/bin/lua/sumneko/lua-language-server/3rd/luamake/luamake

export DOCKER_BUILDKIT=1

if [ -x "$(command -v sort-package-json)" ]; then
  alias spj='sort-package-json '
fi

function setenvs {
  set -a; . "$1"; set +a;
}

if [ -x "$(command -v php)" ]; then
  # debian pkg bsdgames
  alias sail='./vendor/bin/sail'
  alias sailartisan='./vendor/bin/sail artisan'

  alias artisan='php artisan'
fi

pathmunge "/usr/lib/dart/bin" "after"

if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  pathmunge "$PYENV_ROOT"

  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"

    if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
      eval "$(pyenv virtualenv-init -)"
    fi
  fi
fi

if [ -d "$HOME/.fzf" ]; then
  # ripgrep
  export RG_IGNORES="!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}"
  RG_OPTIONS="--hidden --follow --glob '$RG_IGNORES'"

  FZF_PREVIEW_APP="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"
  export FZF_DEFAULT_OPTS="--layout=reverse --border $FZF_PREVIEW_APP"
  # Use git-ls-files inside git repo, otherwise rg
  export FZF_DEFAULT_COMMAND="rg --files $RG_OPTIONS"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_COMPLETION_TRIGGER=',,'

  _fzf_compgen_dir() {
    rg --files $RG_OPTIONS
  }

  _fzf_compgen_path() {
    rg --files --hidden --follow --glob $RG_IGNORES
  }
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
      activated="$(asdf current $plugin)"

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

    alias adf='asdf '

    # add_asdf_plugins_to_path elixir
    # add_asdf_plugins_to_path erlang
  fi
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
  # following needed so that cypress browser testing can work in WSL2
  export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"
  # without the next line, linux executables randomly fail in TMUX in WSL
  # export PATH="$PATH:/c/WINDOWS/system32"

  alias e.='/c/WINDOWS/explorer.exe .'
  alias wslexe='/c/WINDOWS/system32/wsl.exe '
  alias ubuntu20='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu-20.04'
  alias ubuntu18='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu'

  # This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
  # up memory, this command will free your memory after about 20-30 seconds.
  #   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
  alias drop-cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
fi

# The minimal, blazing-fast, and infinitely customizable prompt for any shell!
# https://github.com/starship/starship
# eval "$(starship init bash)" ## will use only in fish shell for now

function touchm() {
  local data
  local sep
  local dir_path
  data="$1"
  sep="/"

  dir_path=${data%$sep*}

  if [ "$dir_path" == "$data" ]; then
    touch "$dir_path"
  else
    mkdir -p "$dir_path"
    touch "$data"
  fi
}
