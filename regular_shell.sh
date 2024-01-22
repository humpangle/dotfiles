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
alias vi='/usr/bin/vim'
alias vimdiff="nvim -d"
alias v="nvim"
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

function _run_f {
  local _script_name

  local _script_pattern=(
    run
    run.sh
    .run
    .run.sh
    do-run.sh
  )

  # Let us search 5 directories level deep for the environment file
  local _parent_search_paths=(
    .
    ..
    ../..
    ../../..
    ../../../..
    ../../../../..
    ../../z
    ../../../z
    "${HOME}"
  )

  local exit_parent

  for parent_dir in "${_parent_search_paths[@]}"; do
    unset exit_parent

    for path in "${_script_pattern[@]}"; do
      complete_path="${parent_dir}/$path"

      if [[ -e "$complete_path" ]]; then
        _script_name="$(realpath "$complete_path")"
        exit_parent=1
        break
      fi
    done

    if [[ -n "${exit_parent}" ]]; then break; fi
  done

  local _script_dir="$(dirname "$_script_name")"

  # Let us run the script at the root of script file
  cd "$_script_dir" || true
  bash "$_script_name" "$@"
  cd - &>/dev/null || true
}

alias r='_run_f'

function _____run-well-known-paths-help {
  : "___help___ _____run-well-known-paths-help"
  read -r -d '' var <<'eof'
Run a program against some well known filesystem paths. Usage:
  __run-well-known-paths program path

The program we want to run: may be a binary or an alias. E.g.
  alias c = $HOME/.vscode-server/bin/0ee/bin/remote-cli/code
  alias v=/usr/bin/nvim

Available paths:
dot
wiki
py
web

Examples:
  __run-well-known-paths code wiki
  __run-well-known-paths c py
eof

  echo -e "${var}"
}

function __run-well-known-paths {
  if [[ "$1" == '-h' ]] ||
    [[ "$1" == '--help' ]]; then
    _____run-well-known-paths-help
    return
  fi

  local _user_supplied_program_to_run="$1"

  if [[ -z "$_user_supplied_program_to_run" ]]; then
    echo -e "Program to run is required. Exiting!\n"

    _____run-well-known-paths-help
    return
  fi

  # The path we wish to run program against
  local _app="$2"

  if [[ -z "$_app" ]]; then
    echo -e "Path to run program against is required. Exiting!\n"

    _____run-well-known-paths-help
    return
  fi

  # Here is the shared directory where we keep our most popular app
  local _shared_0_prefix='/c/0000-shared'

  # The apps we are interested in
  local _dot='dot'
  local _wiki='wiki'
  local _py='py'
  local _web='web'

  # A mapping of apps to directory where they are located
  declare -A _app_to_path_mapping=()

  _app_to_path_mapping["$_dot"]="$HOME/dotfiles"
  _app_to_path_mapping["$_wiki"]="$_shared_0_prefix/wiki"
  _app_to_path_mapping["$_py"]="$_shared_0_prefix/py"
  _app_to_path_mapping["$_web"]="$_shared_0_prefix/web-pages"

  # If the program to run is visual studio code, the app may contain a file *.code-workspace. This will be
  # appended to the app's path
  declare -A _app_to_code_workspace_file_mapping=()

  _app_to_code_workspace_file_mapping["$_dot"]='dotfiles.code-workspace'
  _app_to_code_workspace_file_mapping["$_wiki"]='wiki.code-workspace'
  _app_to_code_workspace_file_mapping["$_py"]='py.code-workspace'
  _app_to_code_workspace_file_mapping["$_web"]='web-pages.code-workspace'

  # The filesystem path to the app
  local _app_path="${_app_to_path_mapping["$_app"]}"

  # If we are running visual studio code, append code workspace path (if it exists)
  if {
    echo "$_user_supplied_program_to_run" | grep -qP "code$" ||
      [[ "$_user_supplied_program_to_run" == 'c' ]]
  }; then
    _app_path="$_app_path/${_app_to_code_workspace_file_mapping["$_app"]}"
  fi

  local _program_to_run
  _parse-command-to-run _program_to_run "$_user_supplied_program_to_run"

  if [[ -z "$_program_to_run" ]]; then
    echo "'$_user_supplied_program_to_run' is not a valid program or shell alias"
    return
  fi

  eval "$_program_to_run $_app_path"
}

alias rr='__run-well-known-paths'
alias rrv='__run-well-known-paths v'
alias rrc='__run-well-known-paths code'

function _parse-command-to-run {
  local -n _result=$1

  # The value to parse may be a program binary or shell alias
  local _to_parse="$2"

  local _command_v_result
  _command_v_result="$(command -v "$_to_parse")"

  if [[ -z "$_command_v_result" ]]; then return; fi

  # Check if command to parse is a shell alias and extract values.
  # We will have a pattern such as:
  #   `alias c=code`
  #   `alias c='code'`
  #   `alias   c="code"`
  # This will be extracted into (alias, c, code) where _not_used=alias
  read -r _not_used _alias_name _suffix \
    <<<"$(
      echo "$_command_v_result" |
        awk -F"[='\"]" '/^alias/{print $1, $2, $3}'
    )"

  # If we have an alias, ensure it is the same as _to_parse
  if [[ -n $_alias_name ]]; then
    # First trim
    _alias_name=$(echo "$_alias_name" | awk '{$1=$1};1')

    if [[ "$_alias_name" != "$_to_parse" ]]; then return; fi

    _command_v_result="$_suffix"
  fi

  # Replace all whitespace with '\ '. Why?
  # When using WSL, windows binaries sometimes contain space which is frowned up in path names for unix
  local _find=" "
  local _replace="\ "
  _result="${_command_v_result//$_find/$_replace}"
}

# Save bash history per tmux pane

hist_dir="$HOME/.bash_histories"

mkdir -p "$hist_dir"

if [ -n "${TMUX}" ]; then
  hist_file="$hist_dir/tmux--$(tmux display-message -p '#{session_name}--#{window_index}')--${TMUX_PANE:1}"
  export HISTFILE="$hist_file"

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

alias _c='_do-cd'
alias ..='cd ..'

alias C="clear && printf '\e[3J'"

# debian package `lrzsz`
alias rb='sudo reboot'
alias scouser='sudo chown -R $USER:$USER'
alias cdo='mkdir -p $HOME/projects/0 && cd $HOME/projects/0'
alias cdp='mkdir -p $HOME/projects && cd $HOME/projects'
alias cds='cd /c/0000-shared'
alias shl='source ~/.bashrc'

# cp -r ./xx yy -> will create yy/xx
# cp -rT ./xx yy -> will not create yy, but dump contents of xx into yy and
# if yy does not exist, it will be created. This means cp -rT ./xx ../../xx
# is the same as cp -r ./xx ../.. as ../../xx will be created if does not exist
# alias cpr='cp -rT' # The above may not work in some shell - hence _cpr below

function _cpr-help {
  echo "
Usage:
  cpr [ -h | --help ] \\
      source \\
      destination-prefix \\
      -o | --out   \\

Examples:
  cpr -h
  cpr /some/source/a /some/dirname --out some_name

  # WIll copy to /some/dirname/a
  cpr /some/source/a/ /some/dirname -o s

  # WIll copy to /some/dirname - /some/dirname must not exist
  cpr /some/source/a/ /some/dirname -o d

  # Will copy to ./a
  cpr /some/source/a/ . -o s

Options:
  --help/-h
      Print usage information and exit.
  --out/-o
      The output folder name.
      Use character 's' to make destination basename same as source basename
      Use character 'd' to write to destination basename
"
}

function _cpr {
  if [[ -z "${*}" ]]; then
    _cpr-help
    return
  fi

  local _out
  local _help

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=out:,help \
      --options=o:,h \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      _cpr-help
      return
      ;;

    --out | -o)
      _out="$2"
      shift 2
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      return
      ;;
    esac
  done

  # handle non-option arguments

  if [[ $# -lt 2 ]]; then
    echo "source and destination required"
    return
  fi

  if [[ -z "${_out}" ]]; then
    echo "--out/-o option is required to be output folder or character 's'"
    return
  fi

  local _source="$(realpath $1)"
  local _destination_prefix=$2
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  # Remove trailing '/' from source otherwise source will be deleted
  _source="${_source%/}"

  _destination_prefix="${_destination_prefix%/}"
  _destination_prefix="$(realpath "${_destination_prefix}")"
  local _destination

  if [[ "${_out}" == 's' ]]; then
    local _source_base="$(basename "${_source}")"
    _destination="${_destination_prefix}/${_source_base}"
  elif [[ "${_out}" == 'd' ]]; then

    # The destination must not already exist
    if [[ -e "${_destination_prefix}" ]]; then
      echo "Destination '${_destination_prefix}' must not exist with '-o d' "
      echo "argument. Exiting!"
      return
    fi

    _destination="${_destination_prefix}"
  else
    _destination="${_destination_prefix}/${_out}"
  fi

  echo "Destination => ${_destination}"
  mkdir -p "${_destination}"

  cp -rT "${_source}" "${_destination}"
}

alias cpr=_cpr

mdf() {
  mkdir -p "$1"
  # shellcheck disable=2103,2164
  cd "$1"
}

alias mdc='mdf'
alias md='mkdir -p'

# Make bash history unique

# https://unix.stackexchange.com/a/265649
#   ignoreboth is actually just like doing ignorespace:ignoredups
export HISTCONTROL=ignoreboth:erasedups

# https://unix.stackexchange.com/a/179852

make-bash-history-unique() {
  _tmux_pane=""

  if [ -n "${1}" ]; then
    _tmux_pane="${1}"
  elif [ -n "${TMUX_PANE}" ]; then
    _tmux_pane="${TMUX_PANE:1}"
  fi

  _temp_file="/tmp/tmpfile-${_tmux_pane}"

  touch "${_temp_file}"

  tac "$HISTFILE" | awk '!x[$0]++' >"${_temp_file}"
  tac "${_temp_file}" >"$HISTFILE"
  rm "${_temp_file}"
}
export -f make-bash-history-unique
alias hu='make-bash-history-unique'
# also https://unix.stackexchange.com/a/613644

function ____setenvs-help {
  read -r -d '' var <<'eof'
Set environment variables from a file into the shell. Usage:
  _setenvs env_file_name [OPTIONS]

Options:
  --help/-h
       Print this help text and exit.

  --level/-l level
       How many levels, in integer, deep should we search parent directories if environment file can not be found in the
       current directory.
       Maximum levels is 5

Examples:
  _setenvs
  _setenvs --help
  _setenvs --level 5
eof

  echo -e "${var}"
}

function _setenvs {
  # TODO: can I write a project such as
  # https://github.com/andrewmclagan/react-env so users can set environment
  # vars based on shell type on different OSes - linux, Mac, windows?
  : "___help___ ____setenvs-help"

  local _path
  local _level=2
  local _path_to_use

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=level:,help \
      --options=l:,h \
      --name "$0" \
      -- "$@"
  )"; then
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ____setenvs-help
      return
      ;;

    --level | -l)
      _level=$2
      shift 2
      ;;

    --)
      shift
      break
      ;;

    *)
      echo "Unknown option ${1}."
      ____setenvs-help
      return
      ;;
    esac
  done

  # handle non-option arguments
  if [[ $# -ne 1 ]]; then
    echo "Non optional argument environment file to set is required."
    ____setenvs-help
    return
  fi

  if [[ "$_level" -gt 5 ]]; then
    echo -e "Maximum level of 5 allowed. Got '$_level'\n"
    ____setenvs-help
    return
  fi

  _path=$1
  _path_to_use=$1
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  _path_to_use="$(
    _compute_path_to_use \
      "$_path_to_use" "$_level"
  )"

  if [[ -z "$_path_to_use" ]]; then
    echo "$_path does not exist."
    return
  fi

  local _output="$_path_to_use--$(date +'%s')--temp"

  local _p_env="${HOME}/dotfiles/scripts/p-env"

  "$_p_env" "$_path_to_use" \
    --output "${_output}"

  set -o allexport
  . "${_output}"
  set +o allexport

  rm -rf "${_output}"
}

function _compute_path_to_use {
  local _path_to_use=$1
  local _level=$2
  local _exists

  for _l in $(seq $_level); do
    if [[ -e "$_path_to_use" ]]; then
      _exists=1
      break
    fi

    _path_to_use="../$_path_to_use"
  done

  if [[ -z "$_exists" ]]; then
    return
  fi

  echo "$_path_to_use"
}

alias se='_setenvs'
alias e='_setenvs'

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

export TP="${TMUX_PANE}"

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
alias copy='_ebnis-xclip'

function ____cpath-help {
  read -r -d '' var <<'eof'
Copy path to current working directory or file name to system clipboard. Usage:
  _cpath [OPTIONS] [filename]

Options:
  --basename/-b
      Copy only the basename
  --help/-h
      Print this help text and exit
Examples:
  _cpath
  _cpath -h
  _cpath some-file
eof

  echo -e "${var}"
}

function _cpath {
  : "___help___ ____cpath-help"

  local _base_only=

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=basename,help \
      --options=b,h \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ____cpath-help
      return
      ;;

    --basename | -b)
      _base_only=1
      shift
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      return
      ;;
    esac
  done

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  local _path="${PWD}"
  local _filename="$1"

  if [[ -n "$_filename" ]]; then
    _path="$_path/$_filename"
  fi

  if [[ -n "${_base_only}" ]]; then
    _path="$(basename "${_path}")"
  fi

  echo -n "${_path}" | xclip -selection c
  echo "${_path}"
}

alias cpath=_cpath
alias cpt=_cpath

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

# IEx Persistent History (https://tylerpachal.medium.com/iex-persistent-history-5d7d64e905d3)
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 10240000"

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

function rel-asdf-plugin-version {
  local _plugin="${1}"

  asdf current "${_plugin}" |
    awk '{print $2}'
}

ELIXIR_LS_BASE="$HOME/.elixir-ls"
ELIXIR_LS_SCRIPTS_BASE="${ELIXIR_LS_BASE}/ebnis-scripts"
# Aug 14, 2022 v0.11.0 fe11910
# Nov 8, 2022 v0.12.0 77670d5
# May 6, 2023 v0.14.6 15c0052
# Jun 29, 2023 v0.15.1 9427f7f
# Oct 24, 2023 v0.17.3 d2eb6f3
ELIXIR_LS_STABLE_HASH='d2eb6f3'

function get-hash {
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

function elixir_ls-install-dir {
  local install_dir="${ELIXIR_LS_BASE}/$(rel-asdf-plugin-version elixir)___$(rel-asdf-plugin-version erlang)/$(get-hash "${@}")"

  printf '%s' "${install_dir}"
}

function rel_asdf_elixir-build-f {
  local elixir_version="$1"
  local install_dir="${ELIXIR_LS_BASE}/${elixir_version}"

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

function rel_asdf_elixir-install-f {
  local hash
  hash="$(get-hash "${@}")"

  local install_dir
  install_dir="$(elixir_ls-install-dir "${@}")"

  if ! [[ -d "$install_dir" ]]; then
    git clone https://github.com/elixir-lsp/elixir-ls.git "$install_dir"
  fi

  local _elixir_version
  local _erlang_version
  _elixir_version="$(rel-asdf-plugin-version elixir)"
  _erlang_version="$(rel-asdf-plugin-version erlang)"

  (
    echo -e "\n=> Entering install directory ${install_dir} ===\n"

    if ! cd "${install_dir}"; then
      echo -e "\n${install_dir} does not exist, exiting.\n"
      return
    fi

    git restore . &>/dev/null
    git checkout "${hash}"

    rm -rf _build deps

    # There is this situation where `mix.lock` file with the `jason_vendored`
    # dependency is wrongly configured. Let's fix it.
    # ***NOTE*** The `e23c65b98411a3066ca73534b4aed1d23bcf0356` hash is gotten
    # from:
    #  git https://github.com/elixir-lsp/jason.git
    #  git checkout vendored
    #  Copy the hash from where the app name in mix.exs is jason_vendored
    sed -i -E \
      "s/(.*jason_vendored.+jason\.git\", +)\"([^,]+)\"(.*)/\1\"e23c65b98411a3066ca73534b4aed1d23bcf0356\"\3/" \
      mix.lock

    asdf local elixir "${_elixir_version}"
    asdf local erlang "${_erlang_version}"

    mix local.hex --force --if-missing
    mix local.rebar --force --if-missing

    asdf reshim elixir
    asdf reshim erlang

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

function elixir_ls-rel-bin-dir {
  local hash
  hash="$(get-hash "${@}")"

  local elixir_version="${1}"

  echo -n "${ELIXIR_LS_SCRIPTS_BASE}/$(rel-asdf-plugin-version elixir)___$(rel-asdf-plugin-version erlang)/${hash}"
}

function rel_asdf_elixir_exists_f {
  local server_bin_path="$(elixir_ls-rel-bin-dir "${@}")/language_server.sh"

  printf "\n%s\n\n" "$server_bin_path"

  if [[ -e "$server_bin_path" ]]; then
    _ebnis-xclip "${server_bin_path}"

    printf "Exists\n\n"
  else
    printf "Does not exist\n\n"
  fi
}

alias rel-asdf-elixir-install='rel_asdf_elixir-install-f'
alias rel-asdf-elixir-exists=rel_asdf_elixir_exists_f

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
    return
  fi
}

function _edit-windows-terminal-settings {
  local _settings_path

  _settings_path="$(
    find \
      "/c/Users/$USERNAME/AppData/Local/Packages" \
      -type f -path '*/Microsoft.WindowsTerminal*/LocalState/settings.json'
  )"

  xclip -selection c <<<"${_settings_path}" &>/dev/null

  echo "$_settings_path"
}

alias edit_wt='nvim _edit-windows-terminal-settings'
alias wt='_edit-windows-terminal-settings'

if [[ "$(uname -r)" == *WSL2 ]]; then

  function ____open-wsl-explorer-help {
    read -r -d '' var <<'eof'
What does function do. Usage:
  _open-wsl-explorer [OPTIONS]

Options:
  --verbose/-v
       Description should be capitalized and end in a period.

Examples:
  _open-wsl-explorer
eof

    echo -e "${var}"
  }

  function _open-wsl-explorer {
    : "___help___ ____open-wsl-explorer-help"

    local _path="$PWD"
    local _should_copy

    # --------------------------------------------------------------------------
    # PARSE ARGUMENTS
    # --------------------------------------------------------------------------
    local parsed

    if ! parsed="$(
      getopt \
        --longoptions=help,copy,path: \
        --options=h,c,p: \
        --name "$0" \
        -- "$@"
    )"; then
      exit 1
    fi

    # Provides proper quoting
    eval set -- "$parsed"

    while true; do
      case "$1" in
      --help | -h)
        ____open-wsl-explorer-help
        return
        ;;

      --copy | -c)
        _should_copy=1
        shift
        ;;

      --path | -p)
        _path="$(realpath $2)"
        shift 2
        ;;

      --)
        shift
        break
        ;;

      *)
        Echo "Unknown option ${1}."
        return
        ;;
      esac
    done

    # --------------------------------------------------------------------------
    # END PARSE ARGUMENTS
    # --------------------------------------------------------------------------

    local _windows_path="$(wslpath -w "$_path")"
    echo -n "$_windows_path" | xclip -selection c

    if [[ -n "$_should_copy" ]]; then
      return
    fi

    if [ -e "$_path" ]; then
      (
        cd "$_path" || true
        /c/WINDOWS/explorer.exe .
      )
    else
      /c/WINDOWS/explorer.exe .
    fi
  }

  export HAS_WSL2=1

  # Without the next line, linux executables randomly fail in TMUX in WSL
  # (**NOT ANY MORE**)
  # export PATH="$PATH:/c/WINDOWS/system32"

  SETUP_DNS_RESOLVER_SCRIPT_NAME="$HOME/dotfiles/etc/wsl-dns-resolver.sh"

  export WSL_EXE='/c/WINDOWS/system32/wsl.exe'

  alias e.='_open-wsl-explorer'
  alias wsls="{ ebnis-save-tmux.sh || true; } && $WSL_EXE --shutdown"
  alias wslt="check-wsl-distro-name && { { ebnis-save-tmux.sh || true ; } && $WSL_EXE --terminate $WSL_DISTRO_NAME ; }"
  alias ubuntu18="$WSL_EXE --distribution Ubuntu"
  alias ubuntu20="$WSL_EXE --distribution Ubuntu-20.04"
  alias ubuntu22="$WSL_EXE --distribution Ubuntu-22.04"
  alias nameserver="sudo $SETUP_DNS_RESOLVER_SCRIPT_NAME"
  alias _dns="sudo -E $SETUP_DNS_RESOLVER_SCRIPT_NAME"

  # This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
  # up memory, this command will free your memory after about 20-30 seconds.
  #   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
  # alias dpc="clear && sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
  # shellcheck disable=2139
  alias dpc="sudo $HOME/dotfiles/etc/wsl-drop-caches.sh"
  # Reset/update clock/time. Sometimes, WSL time lags
  # sudo apt-get install -y ntpdate
  alias rst="sudo ntpdate -u pool.ntp.org"
  alias rsc='rst'
  alias uc='rst'
  alias ut='rst'
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

function archive-projects-f {
  local _extract_path

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=extract: \
      --options=x: \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --extract | -x)
      _extract_path="$2"
      shift 2
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      exit 1
      ;;
    esac
  done
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  # Remove trailing '/'
  local _output_dir="${ARCHIVE_PROJECT_OUTPUT_DIR%/}"

  if [ -z "${ARCHIVE_PROJECT_OUTPUT_DIR}" ]; then
    echo "You must provide a value for the 'ARCHIVE_PROJECT_OUTPUT_DIR' environment variable"
    return
  fi

  local _absolute_filename="${_output_dir}/proj-archive.tar.gz"

  if [[ -n "${_extract_path}" ]]; then
    local _prefix='Extraction location'

    # Extraction location must be an absolute path
    if [[ ! "${_extract_path}" == /* ]]; then
      echo "${_prefix} '${_extract_path}' is not an absolute path."

      return
    fi

    if echo "${_extract_path}" | grep -q "${_output_dir}"; then
      echo "${_prefix} '${_extract_path}' must not contain '${_output_dir}'."

      return
    fi

    (
      if ! cd "${_extract_path}"; then
        echo "'${_extract_path}' can not be read. Exiting."
        return
      fi

      tar -xzvf "${_absolute_filename}"
    )

    return
  fi

  (
    if ! cd "${HOME}"; then
      echo "'${HOME}' can not be read. Exiting."
      return
    fi

    tar -czvf "${_absolute_filename}" \
      --exclude "**/node_modules/**" \
      --exclude "**/_build/**" \
      --exclude "**/deps/**" \
      --exclude "**/vendor/**" \
      --exclude "**/docker/data/**" \
      --exclude "**/.elixir_ls/**" \
      --exclude "**/.terraform/providers/**" \
      --exclude "**/*cache/**" \
      projects/
  )
}

alias archive-projects='archive-projects-f'

# -----------------------------------------------------------------------------
# INTELLIJ IDEA IDE
# -----------------------------------------------------------------------------
# In `~/.bashrc`
# export INTELLIJ_VERSION='IntelliJIdea2022.3' # Found at /home/kanmii/.config/JetBrains/IntelliJIdea2023.2
# export INTELLIJ_IDEA_BIN_VERSION='intellij-idea-ultimate'
# export GIT_USER='your-name'
# export GIT_EMAIL='your-email@email.email'

_intellij_idea_bin_path="${HOME}/.local/share/JetBrains/Toolbox/apps/${INTELLIJ_IDEA_BIN_VERSION}/bin/idea.sh"

if [[ -e "${_intellij_idea_bin_path}" ]]; then
  pathmunge "$(dirname "${_intellij_idea_bin_path}")"

  function _intellij {
    local settings_sync_dir="${HOME}/.config/JetBrains/${INTELLIJ_VERSION:-bahridarnish}/settingsSync"

    (
      if cd "${settings_sync_dir}" &>/dev/null; then
        local _git_config="${settings_sync_dir}/.git/config"

        if ! grep -q "name = Kanmii" "${_git_config}"; then
          if [[ -n "${GIT_USER}" ]]; then
            git config user.name "${GIT_USER}"
          fi

          if [[ -n "${GIT_EMAIL}" ]]; then
            git config user.email "${GIT_EMAIL}"
          fi
        fi

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

    "${_intellij_idea_bin_path}" &>/dev/null &
    disown
  }

  alias intellij='_intellij'
  alias idea='intellij'
fi
