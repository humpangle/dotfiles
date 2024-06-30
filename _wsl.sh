#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155,2139,2086,1090

check_wsl_distro_name() {
  : "Check if WSL distro name has been set"

  if [[ -z "$WSL_DISTRO_NAME" ]]; then
    echo -e "\n Please set WSL_DISTRO_NAME environment variable\n"
    return
  fi
}

_edit_windows_terminal_settings() {
  local _settings_path

  _settings_path="$(
    find \
      "/c/Users/$USERNAME/AppData/Local/Packages" \
      -type f -path '*/Microsoft.WindowsTerminal*/LocalState/settings.json'
  )"

  xclip -selection c <<<"${_settings_path}" &>/dev/null

  echo "$_settings_path"
}

alias edit_wt='nvim _edit_windows_terminal_settings'
alias wt='_edit_windows_terminal_settings'

____open_wsl_explorer_help() {
  read -r -d '' var <<'eof'
Open windows OS explorer from WSL. Usage:
  _open_wsl_explorer [OPTIONS] [path]

Options:
  --help/-h
    Print this help text and quit.
  --path/-p
    The unix filesystem path to convert to windows path and open and or copy. Defaults to current working directory
    ($PWD).
  --copy/-c
    Copy path only, do not open explorer.

Examples:
  # Get help.
  command _open_wsl_explorer --help

  # Open explorer in current path and copy path.
  command _open_wsl_explorer

  # Copy current path only, do not open explorer.
  command _open_wsl_explorer --copy

  # Open explorer in given path and copy path.
  command _open_wsl_explorer --path /some/path
eof

  echo -e "${var}"
}

_open_wsl_explorer() {
  : "___help___ ____open_wsl_explorer_help"

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
      ____open_wsl_explorer_help
      return
      ;;

    --copy | -c)
      _should_copy=1
      shift
      ;;

    --path | -p)
      _path="$(realpath "$2")"
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

  local _windows_path
  _windows_path="$(wslpath -w "$_path")"
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

alias e.='_open_wsl_explorer'
# shellcheck disable=2139
alias wsls="{ ebnis-save-tmux.sh || true; } && $WSL_EXE --shutdown"
# shellcheck disable=2139
alias wslt="check_wsl_distro_name && { { ebnis-save-tmux.sh || true ; } && $WSL_EXE --terminate $WSL_DISTRO_NAME ; }"
# shellcheck disable=2139
alias ubuntu18="$WSL_EXE --distribution Ubuntu"
# shellcheck disable=2139
alias ubuntu20="$WSL_EXE --distribution Ubuntu-20.04"
# shellcheck disable=2139
alias ubuntu22="$WSL_EXE --distribution Ubuntu-22.04"
# shellcheck disable=2139
alias nameserver="sudo $SETUP_DNS_RESOLVER_SCRIPT_NAME"
# shellcheck disable=2139
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
