#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155,2139,2086,1090

# The full path to this script --> /some_prefix/dotfiles/regular_shell.sh
_bash_src="${BASH_SOURCE[0]}"

# MOTIVATION:
#   I started using ubuntu multipass as I am unable to get docker desktop working on my macbook pro 3. In this case, I
#   mount my home directory inside multipass as `/home/kanmii` and use the contents of `/home/kanmii/dotfiles` to
#   configure multipass shell (I want to re-use as much as possible from my current dotfiles). The problem now is that
#   any reference to `$HOME` inside multipass will resolve to `/home/ubuntu`. So I have created this variable to hold
#   the path to `dotfiles` parent whether inside multipass or not.
# On:
#   macos      -> /User/<username>
#   linux      -> /home/<username>
#   multipass  -> /home/<host_username>
export DOTFILE_PARENT_PATH="${_bash_src/\/dotfiles\/regular_shell.sh/''}"

# Add to $PATH only if `it` does not exist in the $PATH
# fish shell has the `fish_add_path` function which does something similar
# CREDIT: https://unix.stackexchange.com/a/217629
# USAGE:
#     pathmunge /sbin/             ## Add to the start; default
#     pathmunge /usr/sbin/ after   ## Add to the end
pathmunge() {
  # first check if folder exists on filesystem
  if [ -d "$1" ]; then
    if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)"; then
      if [ "$2" = "after" ]; then
        PATH="$PATH:$1"
      else
        PATH="$1:$PATH"
      fi
    fi
  fi
}

_is_linux() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    return 0
  else
    return 1
  fi
}

_is_darwin() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}

copy() {
  if _is_darwin; then
    pbcopy <<<"${*}"
  elif command -v xclip &>/dev/null; then
    xclip -selection c <<<"${*}"
  fi
}

export -f copy

if _is_linux; then
  __shell_path='/usr/bin/bash'
  google_chrome_bin="$(which google-chrome)"
elif _is_darwin; then
  # Cnfigure shell prompt
  # PS1='\h:\W \u\$ \n\$' # [default] - host:short_path user
  PS1='\u@\h:\w\$' # user@host:full_path

  # TODO:configure VsCode
  # ~/Library/Application Support/Code/User/settings.json
  # ~/Library/Application Support/Code/User/settings.json
  # /Users/kanmii/Library/Application Support/Google/Chrome/Profile 2

  __shell_path='/opt/homebrew/bin/bash'

  # Export google chrome binary so we can launch google chrome from command line.
  export google_chrome_bin='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  export google_chrome_bin="open -na 'Google Chrome' --args"
fi

# Put the prompt on a new line in case we have very long PWD pathname.
_PS1_APPEND='\n\$ '

# Inverted cursor workaround for windows terminal
# https://github.com/microsoft/terminal/issues/9610#issuecomment-944940268
if [ -n "$WT_SESSION" ]; then
  PS1="\[\e[0 q\e[?12l\]$PS1$_PS1_APPEND"
else
  PS1="$PS1$_PS1_APPEND"
fi

###### START COMMONS ##################

export EDITOR="nvim"

# install with: `sudo apt-get install ssh-askpass-gnome ssh-askpass -y`
# shellcheck disable=2155
export SUDO_ASKPASS=$(command -v ssh-askpass)

alias ug='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'

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
# one theme
alias vt1d='export EBNIS_VIM_THEME=one EBNIS_VIM_THEME_BG=d'
alias vt1l='export EBNIS_VIM_THEME="one" EBNIS_VIM_THEME_BG=l'
# gruvbox8 themes
alias vtg8sd='export EBNIS_VIM_THEME=gruvbox8_soft EBNIS_VIM_THEME_BG=d'
alias vtg8sl='export EBNIS_VIM_THEME=gruvbox8_soft EBNIS_VIM_THEME_BG=l'
alias vtg8hd='export EBNIS_VIM_THEME=gruvbox8_hard EBNIS_VIM_THEME_BG=d'
alias vtg8hl='export EBNIS_VIM_THEME=gruvbox8_hard EBNIS_VIM_THEME_BG=l'
# solarized8 themes
alias vts8d='export EBNIS_VIM_THEME=solarized8 EBNIS_VIM_THEME_BG=d'
alias vts8l='export EBNIS_VIM_THEME=solarized8 EBNIS_VIM_THEME_BG=l'
alias vts8hd='export EBNIS_VIM_THEME=solarized8_high EBNIS_VIM_THEME_BG=d'
alias vts8hl='export EBNIS_VIM_THEME=solarized8_high EBNIS_VIM_THEME_BG=l'

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
  __run-well-known-paths program_o_run path

The program we want to run: may be a binary or an alias. E.g.
  alias c=$HOME/.vscode-server/bin/0ee/bin/remote-cli/code
  alias v=/usr/bin/nvim

Available paths:
dot
wiki
py
web

Examples:
  # Run vscode (binary) with path `wiki`
  __run-well-known-paths code wiki

  # Run vscode (alias) with the path `py`
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

  _app_to_path_mapping["$_dot"]="$DOTFILE_PARENT_PATH/dotfiles"
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

  # If the version of vscode invoked is from WSL, replace with version installed on windows OS. Why?
  # WSL version of the binary does not work when invoked from tmux launched inside vscode.
  if echo "$_command_v_result" | grep -qP "/home/.+\.vscode-server/bin.+bin/remote-cli/code"; then
    _command_v_result="/c/Users/$USERNAME/AppData/Local/Programs/Microsoft VS Code/bin/code"
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

# hist_file="$hist_dir/tmux--$(tmux display-message -p '#{session_name}--#{window_index}')--${TMUX_PANE:1}"
hist_file="$HOME/.bash_history"
export HISTFILE="$hist_file"

if [[ ! -e "$hist_file" ]]; then
  touch "$hist_file"
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
alias ls='ls --color=auto'
alias ll='ls -AlhF'

alias C="clear && printf '\e[3J'"

# debian package `lrzsz`
alias rb='sudo reboot'
alias scouser='sudo chown -R $USER:$USER'
alias cdo="mkdir -p $DOTFILE_PARENT_PATH/projects/0 && cd $DOTFILE_PARENT_PATH/projects/0"
alias cdp="mkdir -p $DOTFILE_PARENT_PATH/projects && cd $DOTFILE_PARENT_PATH/projects"
alias cds='cd /c/0000-shared'
alias cdd="cd $DOTFILE_PARENT_PATH/dotfiles"
alias shl='source ~/.bashrc'
alias exshell="export SHELL=$__shell_path"
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias pw='prettier --write'
alias hb='sudo systemctl hibernate'
alias sd='sudo shutdown now'
alias sb='sudo reboot now'

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

  local _p_env="${DOTFILE_PARENT_PATH}/dotfiles/scripts/p-env"

  "$_p_env" "$_path_to_use" \
    --output "${_output}"

  if [[ -s "$_output" ]]; then
    set -o allexport
    . "${_output}"
    set +o allexport

    rm -rf "${_output}"
  else
    echo "Environment vairables can not be written to shell. File \"$_output\" does not exist."
  fi
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

____ggc-help() {
  read -r -d '' var <<'eof'
Launch google chrome browser. Usage:
  _ggc [OPTIONS]

Options:
  --help/-h
      Print this help text and quit (same as called with no arguments).
  --default/-o
      Open the default profile.
  --new/-n profile
      New profile.
  --user/-u profile
      Exisiting user profile.
  --delete/-d profile
      Delete a profile.
  --profiles/-p
      List profiles
  --debug/-D
      See what arguments and flags we are sending to the google chrome binary.

Examples:
  # Get help
  _ggc
  _ggc -h

  # Open default profile
  _ggc --default

  # Create new `some-user` profile
  _ggc --new some-user

  # Open `some-user` profile
  _ggc --user some-user

  # Delete `some-user` profile
  _ggc --delete some-user

  # List profiles
  _ggc --profiles

  # Debug
  _ggc --debug
eof

  echo -e "\n${var}\n\n\n"
}

_ggc() {
  if [[ -z "$*" ]]; then
    ____ggc-help
    return
  fi

  local _profile_directory_base="$HOME/.config/google-chrome/profiles"

  local _user
  local _user_dir
  local _new_user
  local _debug
  local _args=''

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,default,delete:,user:,profiles,debug,new:,incognito \
      --options=h,o,d:,u:,p,D,n:,i \
      --name "$0" \
      -- "$@"
  )"; then
    ____ggc-help
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ____ggc-help
      return
      ;;

    --profiles | -p)
      echo -e "\nBase profile directory:\n  $_profile_directory_base\n"

      # Copy the path to the clipboard (why ??)
      copy "$_profile_directory_base"

      echo "Available Profiles:"

      ls -1 "$_profile_directory_base"

      echo

      return
      ;;

    --new | -n)
      _new_user=$2
      shift 2
      ;;

    --user | -u)
      _user=$2
      shift 2
      ;;

    --delete | -d)
      mv "$_profile_directory_base/$2" /tmp

      echo -e "\n$_profile_directory_base/$2 Profile deleted successfully.\n"

      return
      ;;

    --debug | -D)
      _debug=1
      shift
      ;;

    --incognito | -i)
      _args+=' -incognito'
      shift
      ;;

    --default | -o)
      shift
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ____ggc-help
      return
      ;;
    esac
  done

  local _other_args="$*"

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  if [[ -n "$_user" ]] ||
    [[ -n "$_new_user" ]]; then

    if [[ -n "$_new_user" ]]; then
      _user="$_new_user"
    else
      if ! grep -q "$_user" <<<"$(ls $_profile_directory_base)"; then
        echo -e "\nProfile \"$_user\" does not exist. Type \"_ggc --help\" to get help.\n"
        return
      fi
    fi

    _user="$_profile_directory_base/$_user"

    mkdir -p "$_user"

    _args+=" --user-data-dir=$_user"
  fi

  _args+=" $_other_args"

  if [[ -n "$_debug" ]]; then
    echo -e "\n$_args\n"
    return
  fi

  if _is_darwin; then
    bash -c "$google_chrome_bin $_args"
  else
    "$google_chrome_bin" "$_args" \
      &>/dev/null &

    disown
  fi
}

alias ggc='_ggc'
alias ggcbin="$google_chrome_bin"

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
  alias fff='compgen -A function | fzf'
fi

____cpath-help() {
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

_cpath() {
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

  copy ${_path}
  echo ${_path}
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

[[ -e "$DOTFILE_PARENT_PATH/dotfiles/_aliases.sh" ]] && source "$DOTFILE_PARENT_PATH/dotfiles/_aliases.sh"

# -----------------------------------------------------------------------------
# PYTHON SECTION
# -----------------------------------------------------------------------------
alias py='python'

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

if command -v php &>/dev/null; then
  _phpunit() {
    if command -v phpunit >/dev/null; then
      phpunit --testdox "$@"
    else
      ./vendor/bin/phpunit --testdox "$@"
    fi
  }

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

# shellcheck source=/dev/null
[[ -e "$DOTFILE_PARENT_PATH/dotfiles/elixir-ls-install.sh" ]] && source "$DOTFILE_PARENT_PATH/dotfiles/elixir-ls-install.sh"

alias ng="sudo nginx -g 'daemon off; master_process on;' &"
alias ngd="sudo nginx -g 'daemon on; master_process on;'"
alias ngk='pgrep -f nginx | xargs sudo kill -9'
alias ngkill='pgrep -f nginx | xargs sudo kill -9'
alias ngstop='pgrep -f nginx | xargs sudo kill -9'

if [ -d "$HOME/.asdf" ]; then
  # shellcheck source=/dev/null
  . $HOME/.asdf/asdf.sh
  # shellcheck source=/dev/null
  . $HOME/.asdf/completions/asdf.bash

  if asdf current nodejs &>/dev/null; then
    export TS_SERVER_GBLOBAL_LIBRARY_PATH="$HOME/.asdf/installs/nodejs/$(asdf current nodejs | awk '{print $2}')/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js"
  fi

  if [[ -f "$HOME/.asdf/plugins/java/set-java-home.bash" ]]; then
    # shellcheck source=/dev/null
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

  SETUP_DNS_RESOLVER_SCRIPT_NAME="$DOTFILE_PARENT_PATH/dotfiles/etc/wsl-dns-resolver.sh"

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
  alias dpc="sudo $DOTFILE_PARENT_PATH/dotfiles/etc/wsl-drop-caches.sh"
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

MY_ANDROID_STUDIO_PATH="$DOTFILE_PARENT_PATH/projects/android-studio"
if [ -d "$MY_ANDROID_STUDIO_PATH" ]; then
  export ANDROID_HOME="$MY_ANDROID_STUDIO_PATH"
  pathmunge "$ANDROID_HOME"
  pathmunge "$ANDROID_HOME/bin"
fi

MY_ANDROID_SDK_PATH="$DOTFILE_PARENT_PATH/projects/android-sdk"
if [ -d "$MY_ANDROID_SDK_PATH" ]; then
  pathmunge "$MY_ANDROID_SDK_PATH/tools"
  pathmunge "$MY_ANDROID_SDK_PATH/tools/bin"
  pathmunge "$MY_ANDROID_SDK_PATH/platform-tools"
fi

MY_FLUTTER_PATH="$DOTFILE_PARENT_PATH/projects/flutter"
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
