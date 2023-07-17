#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155,2139,2086,1090

# Inverted cursor workaround for windows terminal
# https://github.com/microsoft/terminal/issues/9610#issuecomment-944940268
if [ -n "$WT_SESSION" ]; then
  PS1="\[\e[0 q\e[?12l\]$PS1"
fi

###### START COMMONS ##################

if [[ -e /usr/local/bin/aws_completer ]]; then
  complete -C '/usr/local/bin/aws_completer' aws
fi

export EDITOR="nvim"
# install with: `sudo apt-get install ssh-askpass-gnome ssh-askpass -y`
# shellcheck disable=2155
export SUDO_ASKPASS=$(command -v ssh-askpass)

# Add to $PATH only if `it` does not exist in the $PATH
# fish shell has the `fish_add_path` function which does something similar
# CREDIT: https://unix.stackexchange.com/a/217629
# USAGE:
#     pathmunge /sbin/             ## Add to the start; default
#     pathmunge /usr/sbin/ after   ## Add to the end
pathmunge() {
  # first check if folder exists on filesystem
  if [ -d "$1" ]; then
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)"; then
      if [ "$2" = "after" ]; then
        PATH="$PATH:$1"
      else
        PATH="$1:$PATH"
      fi
    fi
  fi
}

alias ug='clear && sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'

# vim
PACKER_COMPILED_PATH="$HOME/dotfiles/config/nvim/plugin/packer_compiled.lua"
alias packerdelete="rm -rf $PACKER_COMPILED_PATH; echo $PACKER_COMPILED_PATH"
alias packerremove='packerdelete'

alias vi='/usr/bin/vim'
alias vimdiff="nvim -d"
alias v="packerdelete &>/dev/null; nvim"
alias v.="v ."
alias svim='sudo -E nvim'
alias sv='sudo -E nvim'
alias vmin='v -u ~/.config/nvim/settings-min.vim'
alias vm='v -u ~/.config/nvim/settings-min.vim'
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
alias npacker="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias packerinstall="rm -rf $HOME/.local/share/nvim \
  && rm -rf $PACKER_COMPILED_PATH"

remove_vim_sessionf() {
  local ME
  local filename
  local absolute_path

  ME=$(pwd)
  filename="${ME//\//%}"
  absolute_path="$HOME/.vim/session/$filename.vim"
  rm -rf "$absolute_path"

  remove_vim_undof
}
alias remove_vim_session=remove_vim_sessionf
alias rmvs=remove_vim_sessionf

remove_vim_undof() {
  local ME
  local filename
  local absolute_path
  local prefix

  ME=$(pwd)
  filename="${ME//\//%}%"
  prefix="${HOME}/.vim/undodir"

  # shellcheck disable=2010
  mapfile -t filenames < <(ls -h "${prefix}" | grep -P "${filename}")
  for f in "${filenames[@]}"; do
    absolute_path="${prefix}/${f}"
    rm -rf "${absolute_path}"
  done
}
alias remove_vim_undo='remove_vim_undof'
alias rmvu='remove_vim_undof'

alias ta='tmux a -t'
alias tad='tmux a -d -t'
alias tap='cd ~/projects/php && tmux a -t php'
alias tls='tmux ls'
alias tp='rm -rf $HOME/.tmux/resurrect/pane_contents.tar.gz'
alias tn='rm -rf $HOME/.tmux/resurrect/pane_contents.tar.gz && tmux new -s'
alias tadd='cd ~/dotfiles && ta dot'
alias tks='tmux kill-session -t'
alias tkss='{ ebnis-save-tmux.sh || true; } && tmux kill-server'
alias ts='ebnis-save-tmux.sh'
alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'

_start-tmux() {
  if tmux ls &>/dev/null; then
    cd "${HOME}/dotfiles" || exit 1
    tmux a -d -t dot
  else
    cd "${HOME}/dotfiles" || exit 1
    tn dot
  fi
}

alias tndot=_start-tmux
alias tdot=_start-tmux
alias tnd=_start-tmux

runf() {
  local name
  local search_paths=(run run.sh .run .run.sh do-run.sh)
  local parent_dirs=(. .. ../../z ../../../z "${HOME}")
  local exit_parent

  for parent_dir in "${parent_dirs[@]}"; do
    unset exit_parent

    for path in "${search_paths[@]}"; do
      complete_path="${parent_dir}/$path"

      if [[ -e "$complete_path" ]]; then
        name="$complete_path"
        exit_parent=1
        break
      fi
    done

    if [[ -n "${exit_parent}" ]]; then break; fi
  done

  bash "$name" "$@"
}

alias rrun='runf'
alias runn='runf'
alias rn='runf'
alias r='runf'

# Save bash history per tmux pane
if [[ $TMUX_PANE ]]; then
  hist_dir="$HOME/.bash_histories"

  if [[ ! -d "$hist_dir" ]]; then
    mkdir "$hist_dir"
  fi

  hist_file="$hist_dir/.bash_history_tmux_${TMUX_PANE:1}"
  HISTFILE="$hist_file"

  if [[ ! -e "$hist_file" ]]; then
    touch "$hist_file"
  fi
fi

# rsync
alias rsynca='rsync -avzP --delete'
alias rsyncd='rsync -avzP --delete --dry-run'

# GIT
alias gss='git status'
# alias gst='git stash'
# alias gsp='git stash pop'
alias gsl='git stash list'
# there is a debian package gsc = gambc
alias gsc='git stash clear'
alias gcma='git commit --amend'
alias gcma='git commit -a'
alias gcme='git commit --amend --no-edit'
alias gcamupm='git commit -am "updated" && git push github master'
alias ga.='git add .'
alias gp='git push'
alias gpgm='git push github master'
# The following command has serious caveats: see wiki/git.md
# deliberately put an error: stash1 instead of stash so that user is forced
# to edit command and put stash message
alias gsstaged='git stash1 push -m "" -- $(git diff --staged --name-only)'
alias gcm='git commit'
alias grb='git rebase -i'
# debian package gpodder=gpo
alias gpo='git push origin'
alias gpf='git push --force-with-lease origin'
alias glone='git log --oneline'
alias gconflict='git diff --name-only --diff-filter=U'
alias gwt='git worktree'
# debian package gsa = gwenhywfar-tools
gsa() {
  git stash apply "stash@{$1}"
}

gsd() {
  git stash drop "stash@{$1}"
}

_do-cd() {
  local level

  if [[ -z "$1" ]] ||
    [[ "$1" == "0" ]]; then
    level=1
  else
    level="$1"
  fi

  for _l in $(seq $level); do
    cd .. || exit 1
  done
}

alias c='_do-cd'
alias ..='cd ..'

alias C="clear && printf '\e[3J'"
# debian package `lrzsz`
alias rb='sudo reboot'
alias scouser='sudo chown -R $USER:$USER'
alias cdo='mkdir -p $HOME/projects/0 && cd $HOME/projects/0'
alias cdp='mkdir -p $HOME/projects && cd $HOME/projects'
alias eshell='source ~/.bashrc'
alias cpr='cp -r'

mdf() {
  mkdir -p "$1"
  # shellcheck disable=2103,2164
  cd "$1"
}

alias mdc='mdf'
alias md='mkdir -p'

# https://unix.stackexchange.com/a/179852
# Make bash history unique

make_history_unique() {
  tac "$HISTFILE" | awk '!x[$0]++' >/tmp/tmpfile &&
    tac /tmp/tmpfile >"$HISTFILE" &&
    rm /tmp/tmpfile
}
alias hu='make_history_unique'
# also https://unix.stackexchange.com/a/613644

setenvs() {

  # TODO: can I write a project such as
  # https://github.com/andrewmclagan/react-env so users can set environment
  # vars based on shell type on different OSes - linux, Mac, windows?

  local path
  path="$1"

  # Check for path 2 parent levels deep.
  local search_paths=("$path" "../${path}" "../../${path}")

  for search_path in "${search_paths[@]}"; do
    if [[ -e "$search_path" ]]; then
      path="$(realpath "$search_path")"
      break
    fi
  done

  set -o allexport
  . "$path"
  set +o allexport

  ENV_FILE="${path}"

  # set -o allexport; source "$1"; set +o allexport
}
alias se='setenvs'
alias e='setenvs'
# p-env = parse env script
alias pe='p-env'
alias p='p-env'

_ggc() {
  if [[ "${1}" == "-h" ]]; then
    echo "Usage:"
    echo "  ggc"
    echo "  ggc -h"
    echo "  ggc --incognito"
    echo "  ggc --user-data-dir=\$HOME/.config/google-chrome/some-profile"
    return
  fi

  google-chrome "${@}" &>/dev/null &
  disown
}

alias ggc='_ggc'

# TMUX split panes and windows
splitp() {
  if [[ "$1" == '-h' ]]; then
    echo "Usage:"
    echo "splitp absolute_path window_name"
    return
  fi

  if [[ -n "$1" ]]; then
    local dir="$1"
  else
    local dir="$PWD"
  fi

  local window_name="$2"

  # shellcheck disable=2164
  cd "$dir"

  tmux rename-window "$window_name" \
    \; splitw -c "$dir" -h -p 46 \
    \; splitw -b -p 40 \
    \; splitw -t 3 -b -p 45 \
    \; splitw -t 4 -b -p 55 \
    \; select-pane -t 2 \
    \; send-keys 'nvim ,' C-m \
    \; new-window -c "$dir" \
    \; splitw -c "$dir" -h -p 45 \
    \; splitw -t 1 -p 60 \
    \; splitw -p 45 \
    \; splitw -t 4 -p 87 \
    \; splitw -p 85 \
    \; splitw -p 70 \
    \; splitw \
    \; select-pane -t 1 \
    \; send-keys 'cd storage/logs && clear' C-m \
    \; select-pane -t 2 \
    \; send-keys 'nvim ,' C-m \
    \; select-pane -t 3 \
    \; send-keys 'cd storage/app/public && clear' C-m \
    \; select-pane -t 4 \
    \; rename-window "${window_name}-L" \
    \; last-window \
    \; select-pane -t 5 \
    \; send-keys 'yarn && clear' C-m \
    \; select-pane -t 1 \
    \; send-keys 'clear' C-m
}

alias exshell='export SHELL=/usr/bin/bash'
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias cdd='cd $HOME/dotfiles'
alias pw='prettier --write'
alias hb='sudo systemctl hibernate'
alias sd='sudo shutdown now'
alias sb='sudo reboot now'

if [ -d "$HOME/.fzf" ]; then
  # ripgrep
  export RG_IGNORES="!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}"
  RG_OPTIONS="--hidden --follow --glob '$RG_IGNORES'"

  export FZF_DEFAULT_OPTS="--layout=reverse --border"
  # Use git-ls-files inside git repo, otherwise rg
  export FZF_DEFAULT_COMMAND="rg --files $RG_OPTIONS"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_COMPLETION_TRIGGER=',,'

  _fzf_compgen_dir() {
    rg --files "$RG_OPTIONS"
  }

  _fzf_compgen_path() {
    rg --files --hidden --follow --glob $RG_IGNORES
  }

  FZF_PREVIEW_APP="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"

  # shellcheck disable=2139
  alias ff="fzf $FZF_PREVIEW_APP"
  alias eff='env | fzf'
  alias aff='alias | fzf'
fi

function _ebnis-xclip {
  if command -v xclip &>/dev/null; then
    xclip -selection c <<<"${*}"
  fi
}

alias xclip='xclip -selection c'
alias cpath='pwd | xclip -selection c ; echo "${PWD}"'
alias cpt='cpath'
alias copy='_ebnis-xclip'

_purge-systemd-service() {
  sudo systemctl stop "$1"
  sudo systemctl disable "$1"
  sudo rm -rf /etc/systemd/system/"$1"
  sudo rm -rf /usr/lib/systemd/system/"$1"
  sudo systemctl daemon-reload
  sudo systemctl reset-failed
}
alias purge-systemd-service='_purge-systemd-service'

# -----------------------------------------------------------------------------
# END COMMONS
# -----------------------------------------------------------------------------

alias ngrokd='ngrok http'

[[ -e "$HOME/dotfiles/_aliases.sh" ]] && source "$HOME/dotfiles/_aliases.sh"

# -----------------------------------------------------------------------------
# PYTHON SECTION
# -----------------------------------------------------------------------------
alias py='python'

alias py-activate='. venv/bin/activate || . .venv/bin/activate'
alias pyactivate='py-activate'
alias pyactivate.='py-activate'
alias activatepy='py-activate'
alias activatepy.='py-activate'

# yarn
alias y='yarn'
alias yw='yarn workspace'
alias yW='yarn -W'
alias ys='yarn start'
alias yn='yarn nps'
alias ylsp='yarn list --pattern'
alias ywhy='yarn why'
alias ycw='clear && DISABLE_LARAVEL_MIX_NOTIFICATION=1 yarn watch'

alias luamake=${HOME}/.local/bin/lua/sumneko/lua-language-server/3rd/luamake/luamake

ltf() {
  lt --subdomain "$1" --port "$2" &
}

if [ -x "$(command -v sort-package-json)" ]; then
  alias spj='sort-package-json'
fi

# Erlang and elixir flags

# skip the java dependency during installation
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
# Do not build erlang docs when installing with
# asdf cos it's slow and unstable
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_MANPAGES=
export KERL_INSTALL_HTMLDOCS=

alias rebar='rebar3'

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
pathmunge "$GEM_HOME/bin"

# PHP SECTION
# Do not use PHP PEAR when installing PHP with asdf
# export PHP_WITHOUT_PEAR='yes'

function _phpunit {
  if command -v phpunit >/dev/null; then
    phpunit --testdox "$@"
  else
    ./vendor/bin/phpunit --testdox "$@"
  fi
}

if [ -x "$(command -v php)" ]; then
  alias php-unit='_phpunit'
  alias pu='_phpunit'

  # debian pkg bsdgames
  alias sail='./vendor/bin/sail'
  alias sailartisan='./vendor/bin/sail artisan'

  alias artisan='php artisan'

  alias scmstorage='sudo chmod -R 777 storage'

  alias cmp='composer'
  alias cmpi='composer install'
  alias cmpr='composer require'
  alias cmprd='composer require --dev'
  alias cmpd='composer dumpautoload -o'
fi

pathmunge "/usr/lib/dart/bin" "after"

function python-current {
  asdf current python | awk '{print $2}'
}

function current-python {
  python-current
}

function pyenv-install-current {
  pyenv install "$(python-current)"
}

if [ -z "${PYENV_ROOT}" ] && [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:${PATH}"

  eval "$(pyenv init -)"

  if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

ELIXIR_LS_SCRIPTS_BASE="$HOME/projects/elixir/elixir-ls/00scripts"
# Release v0.14.6
ELIXIR_LS_STABLE_HASH='15c0052'

get-hash() {
  local args="${*}"

  # args is equal to `some text --hash=git-hash` or `some text --hash git-hash`
  # sed: may be some text --hash(=)(git-hash)
  local hash="$(
    echo "${args}" |
      sed -n -E "s/.*--hash(=|\s+)([a-zA-Z0-9]+)?.*/\2/p"
  )"

  if [[ -z "${hash}" ]]; then
    hash="${ELIXIR_LS_STABLE_HASH}"
  fi

  echo -n "${hash}"
}

check-elixir_ls-vsn() {
  if [ -n "${1}" ]; then printf y; fi
}

elixir_ls-install-dir() {
  if ! [ "$(check-elixir_ls-vsn "${@}")" ]; then
    return
  fi

  local install_dir="$HOME/projects/elixir/elixir-ls/${1}/$(get-hash "${@}")"

  printf '%s' "${install_dir}"
}

rel_asdf_elixir-build-f() {
  local elixir_version="$1"
  local install_dir="$HOME/projects/elixir/elixir-ls/${elixir_version}"

  rm -rf mix.lock _build deps

  # shellcheck disable=SC1010
  mix do deps.get, compile

  local release_dir="${ELIXIR_LS_SCRIPTS_BASE}/$elixir_version"
  mkdir -p "$release_dir"
  mix elixir_ls.release -o "$release_dir"

  # Print the path to the language server script so we can use it in LSP
  # client.
  echo -e '\n\n=> The path to the language server script:'
  echo "$release_dir/language_server.sh"

  # shellcheck disable=2103,2164
  cd - >/dev/null
}

rel_asdf_elixir-build-current-f() {
  rel_asdf_elixir-build-f "$(rel-asdf-elixir-current-f)"
}

rel_asdf_elixir-install-f() {
  if ! [ "$(check-elixir_ls-vsn "${@}")" ]; then
    echo "The elixir version is required."
    echo "Usages:"
    echo "  rel_asdf_elixir-install-f elixir-ls-version [--hash git-hash]"
    return
  fi

  local elixir_version="$1"

  local hash
  hash="$(get-hash "${@}")"

  local install_dir
  install_dir="$(elixir_ls-install-dir "${@}")"

  echo "$install_dir"

  if ! [[ -d "$install_dir" ]]; then
    git clone https://github.com/elixir-lsp/elixir-ls.git "$install_dir"
  fi

  (
    echo -e "\n=> Entering install directory ${install_dir} ===\n"

    if ! cd "${install_dir}"; then
      echo -e "\n${install_dir} does not exist, exiting.\n"
      exit 1
    fi

    git restore . &>/dev/null
    git checkout "${hash}"

    rm -rf _build deps

    mix deps.get
    mix compile

    echo -e '=> Creating the language server scripts.\n'

    local release_dir
    release_dir="$(elixir_ls-rel-bin-dir "${@}")"

    mkdir -p "$release_dir"

    mix elixir_ls.release -o "$release_dir"

    # Print the path to the language server script so we can use it in LSP
    # client.
    echo -e '\n\n=> The path to the language server script:'
    echo "${release_dir}/language_server.sh"
  )
}

elixir_ls-rel-bin-dir() {
  local hash
  hash="$(get-hash "${@}")"

  local elixir_version="${1}"

  echo -n "${ELIXIR_LS_SCRIPTS_BASE}/${elixir_version}/${hash}"
}

rel_asdf_elixir_exists_f() {
  local elixir_version="$1"

  local server_bin_path="$(elixir_ls-rel-bin-dir "${@}")/language_server.sh"

  printf "\n%s\n\n" "$server_bin_path"

  if [[ -e "$server_bin_path" ]]; then
    _ebnis-xclip "${server_bin_path}"

    printf "Exists\n\n"
  else
    printf "Does not exist\n\n"
  fi
}

rel-asdf-elixir-current-f() {
  asdf current elixir | awk '{print $2}'
}

rel-asdf-elixir-install-current-f() {
  rel_asdf_elixir-install-f "$(rel-asdf-elixir-current-f)" "${@}"
}

rel-asdf-elixir-exists-current-f() {
  rel_asdf_elixir_exists_f "$(rel-asdf-elixir-current-f)" "${@}"
}

alias rel-asdf-elixir-current='rel-asdf-elixir-current-f'
alias rel-asdf-elixir-install='rel_asdf_elixir-install-f'
alias rel-asdf-elixir-install-current='rel-asdf-elixir-install-current-f'
alias rel-asdf-elixir-exists=rel_asdf_elixir_exists_f
alias rel-asdf-elixir-exists-current=rel-asdf-elixir-exists-current-f
alias rel-asdf-elixir-current-exists=rel-asdf-elixir-exists-current-f
alias mxg='mix deps.get'
alias mxgc='mix do deps.get, compile'
alias mxc='mix compile'
alias mxer='mix ecto.reset'
alias mxes='mix ecto.setup'
alias mxem='mix ecto.migrate'
alias mxec='mix ecto.create'
alias mxed='mix ecto.drop'
alias mxt='mix test'
alias mxn='mix new'
alias mxps='mix phx.server'
alias mxti='mix test.interactive'
alias iexmxps='iex -S mix phx.server'
alias iexmx='iex -S mix'

##################### mysql

_mysql-dir() {
  local current

  current="$(asdf current mysql | awk '{print $2}')"

  printf '%s' "$HOME/mysql_data_${current//./_}"
}

mysql-setupf() {
  local DATADIR

  DATADIR="$(_mysql-dir)"

  mkdir -p "$DATADIR"
  mysqld --initialize-insecure --datadir="$DATADIR"
  mysql_ssl_rsa_setup --datadir="$DATADIR"
}

alias mysql-setup='mysql-setupf'
alias setup-mysql='mysql-setupf'

mysql-startf() {
  local path

  path="$(_mysql-dir)"

  if [[ ! -e "$path" ]]; then
    printf "\n\nDirectory data of the mysql version, '%s', does not exist.\n\n" "${path}"
    return
  fi

  mysqld_safe --datadir="$path" &
  disown
}

alias mysql-start='mysql-startf'
alias mysqls='mysql-startf'
alias start-mysql='mysql-startf'
alias smysql='mysql-startf'
# -----------------------------------------------------------------------------
# END MYSQL
# -----------------------------------------------------------------------------

alias ng="sudo nginx -g 'daemon off; master_process on;' &"
alias ngd="sudo nginx -g 'daemon on; master_process on;'"
alias ngk='pgrep -f nginx | xargs sudo kill -9'
alias ngkill='pgrep -f nginx | xargs sudo kill -9'
alias ngstop='pgrep -f nginx | xargs sudo kill -9'

if [ -d "$HOME/.asdf" ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash

  if command -v asdf 1>/dev/null 2>&1; then
    TS_SERVER_GBLOBAL_LIBRARY_PATH="$HOME/.asdf/installs/nodejs/$(asdf current nodejs | awk '{print $2}')/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js"
    export TS_SERVER_GBLOBAL_LIBRARY_PATH
  fi

  if [[ -f "$HOME/.asdf/plugins/java/set-java-home.bash" ]]; then
    . "$HOME/.asdf/plugins/java/set-java-home.bash"
  fi
fi

function check-wsl-distro-name {
  : "Check if WSL distro name has been set"

  if [[ -z "$WSL_DISTRO_NAME" ]]; then
    echo -e "\n Please set WSL_DISTRO_NAME environment variable\n"
    exit 1
  fi
}

function _edit-windows-terminal-settings {
  local settings_path

  settings_path="$(
    find \
      "/c/Users/$USERNAME/AppData/Local/Packages" \
      -type f -path '*/Microsoft.WindowsTerminal*/LocalState/settings.json'
  )"

  echo "$settings_path"
}

alias edit_wt='nvim _edit-windows-terminal-settings'
alias wt='_edit-windows-terminal-settings'

function _set-display {
  echo "$(ip route | awk '/default/ {print $3}'):0.0"
}

if [[ "$(uname -r)" == *WSL2 ]]; then
  function _open-wsl-explorer {
    if [ -e "$1" ]; then
      (
        cd "${1}" || exit 1
        /c/WINDOWS/explorer.exe .
      )
    else
      /c/WINDOWS/explorer.exe .
    fi
  }

  export HAS_WSL2=1
  # following needed so that cypress browser testing can work in WSL2
  # WSL_HOST_IP environment var no longer works in microsoft version of WLS If
  # using WSLg, you must not set DISPLAY env var and in
  # `/c/Users/username/.wslconfig`, set `guiApplications` to `true`
  export DISPLAY="$(ip route | awk '/default/ {print $3}'):0.0"

  # Without the next line, linux executables randomly fail in TMUX in WSL
  # (**NOT ANY MORE**)
  # export PATH="$PATH:/c/WINDOWS/system32"

  NAME_SERVER_SCRIPT="$HOME/dotfiles/etc/wsl-nameserver.sh"

  export WSL_EXE='/c/WINDOWS/system32/wsl.exe'

  alias e.='_open-wsl-explorer'
  alias wsls="{ ebnis-save-tmux.sh || true; } && $WSL_EXE --shutdown"
  alias wslt="check-wsl-distro-name && { { ebnis-save-tmux.sh || true ; } && $WSL_EXE --terminate $WSL_DISTRO_NAME ; }"
  alias ubuntu18="$WSL_EXE --distribution Ubuntu"
  alias ubuntu20="$WSL_EXE --distribution Ubuntu-20.04"
  alias ubuntu22="$WSL_EXE --distribution Ubuntu-22.04"
  alias nameserver="sudo $NAME_SERVER_SCRIPT"
  alias set-display="export DISPLAY=$(_set-display)"

  # This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
  # up memory, this command will free your memory after about 20-30 seconds.
  #   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
  # alias dpc="clear && sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
  # shellcheck disable=2139
  alias dpc="sudo $HOME/dotfiles/etc/wsl-drop-caches.sh"
  # Reset/update clock/time. Sometimes, WSL time lags
  alias rst="sudo ntpdate pool.ntp.org"
  alias rsc='rst'
  alias uc='rst'
  alias ut='rst'

  if [[ -z "$USE_WSL_INTERNET_RESOLVER" ]]; then
    if { ! [[ -e /etc/resolv.conf ]]; } || { ! grep -q 1.1.1.1 /etc/resolv.conf; }; then
      if [[ -x "$NAME_SERVER_SCRIPT" ]]; then
        sudo "$NAME_SERVER_SCRIPT"
      fi
    fi
  fi

fi

# Start postgres automatically when logging in.
# if [ -x "$(command -v pg_ctl)" ]; then
#   POSTGRES_RUNNING=$(pgrep -f postgres)
#
#   if [ -z "$POSTGRES_RUNNING" ]; then
#     pg_ctl start >/dev/null 2>&1 &
#     disown
#   fi
# fi

# The minimal, blazing-fast, and infinitely customizable prompt for any shell!
# https://github.com/starship/starship
# eval "$(starship init bash)" ## will use only in fish shell for now

# Set the title string at the top of your current terminal window or terminal window tab
# https://github.com/mgedmin/scripts/blob/master/title
# https://discourse.gnome.org/t/rename-terminal-tab/3200/5
set-title() {
  # usage: set-title string
  # Works for xterm clones
  printf "\033]0;%s\a" "$*"
}

MY_JAVA_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
if [ -d "$MY_JAVA_PATH" ]; then
  export JAVA_HOME="$MY_JAVA_PATH"
  pathmunge "$JAVA_HOME/bin"
fi

MY_ANDROID_STUDIO_PATH="$HOME/projects/android-studio"
if [ -d "$MY_ANDROID_STUDIO_PATH" ]; then
  export ANDROID_HOME="$MY_ANDROID_STUDIO_PATH"
  pathmunge "$ANDROID_HOME"
  pathmunge "$ANDROID_HOME/bin"
fi

MY_ANDROID_SDK_PATH="$HOME/projects/android-sdk"
if [ -d "$MY_ANDROID_SDK_PATH" ]; then
  pathmunge "$MY_ANDROID_SDK_PATH/tools"
  pathmunge "$MY_ANDROID_SDK_PATH/tools/bin"
  pathmunge "$MY_ANDROID_SDK_PATH/platform-tools"
fi

MY_FLUTTER_PATH="$HOME/projects/flutter"
if [ -d "$MY_FLUTTER_PATH" ]; then
  pathmunge "$MY_FLUTTER_PATH/bin"
  pathmunge "$MY_FLUTTER_PATH/.pub-cache/bin"
fi

# THIS IS NO LONGER REQUIRED NOW THAT WE HAVE systemd working
# Automatically start dbus (stop getting dbus error when running google chrome)
# To solve google chrome warning: `Failed to connect to the bus: Could not
# parse server address` See:
# https://github.com/microsoft/WSL/issues/7915#issuecomment-1163333151
# sudo /etc/init.d/dbus start &>/dev/null

function _cert-etc {
  : "Publish host to /etc/hosts"
  if [ -z "$1" ]; then
    echo -e "\n Please provide a domain\n"
    return
  fi

  local host_entry="127.0.0.1 ${1}"

  if [[ ! "$(cat /etc/hosts)" =~ $host_entry ]]; then
    printf "%s\n" "$host_entry" | sudo tee -a /etc/hosts

    # On chrome browser, enter into address bar:
    #      chrome://flags/#allow-insecure-localhost
  fi

  echo -e "\n\n##### Also update on windows OS:"
  echo -e "C:\Windows\System32\drivers\etc\hosts\n\n"
}

alias cert-etc='_cert-etc'

# -----------------------------------------------------------------------------
# INTELLIJ IDEA IDE
# -----------------------------------------------------------------------------
# In `~/.bashrc`
# export INTELLIJ_VERSION='IntelliJIdea2022.3'
# export INTELLIJ_IDEA_BIN_PATH="${HOME}/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/223.8836.41/bin/idea.sh"

if [[ -e "${INTELLIJ_IDEA_BIN_PATH}" ]]; then
  pathmunge "$(dirname "${INTELLIJ_IDEA_BIN_PATH}")"

  function _intellij {
    local settings_sync_dir="${HOME}/.config/JetBrains/${INTELLIJ_VERSION:-bahridarnish}/settingsSync"

    (
      if cd "${settings_sync_dir}" &>/dev/null; then
        local timestamp
        timestamp="$(date +'%s')"

        local commit_message="Launching intellij checkpoint -- $(hostname) -- $(date)"

        if git commit \
          --allow-empty \
          -m "${commit_message}"; then

          # Sometime to allow the commit to complete
          sleep 2

          echo -e "\nCommit message: \"${commit_message}\"\n"
        else
          echo -e "${settings_sync_dir}"
        fi
      fi
    )

    "${INTELLIJ_IDEA_BIN_PATH}" &>/dev/null &
    disown
  }

  alias intellij='_intellij'
  alias idea='intellij'
fi
