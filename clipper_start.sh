#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

start-clipper() {
  : "Start the clipper utility used to sync remote machine's clipboard with local client'."

  local _quiet

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local _parsed

  if ! _parsed="$(
    getopt \
      --longoptions=quiet \
      --options=q \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$_parsed"

  while true; do
    case "$1" in
    --quiet | -q)
      _quiet=1
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

  # Ensure clipper is installed.
  if ! command -v clipper &>/dev/null; then
    return
  fi

  # Ensure clipper is not running. It runs on TCP port 8377.
  if clipper-status --quiet; then
    return
  fi

  # Ensure log directory and xonfig file exist.
  mkdir -p "$HOME/.run/logs/"

  if [ ! -e "$HOME/.clipper.json" ]; then
    local filename_="general"

    if _has_termux; then
      filename_="termux"
    fi

    ln -s "$HOME/dotfiles/clipper/configs/${filename_}.json" "$HOME/.clipper.json"
  fi

  # Run clipper in the background.
  clipper &>/dev/null &
  disown

  if [[ -z "$_quiet" ]]; then
    echo "clipper is running on port 8377."
  fi
}

clipper-status() {
  local _quiet
  local pid_

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=quiet,pid \
      --options=q,p \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --quiet | -q)
      _quiet=1
      shift
      ;;

    --pid | -p)
      pid_=1
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

  local clipper_pid_="$(pgrep clipper 2>/dev/null)"

  if [ -n "$pid_" ]; then
    echo -n "$clipper_pid_"
    return
  fi

  if [[ "$clipper_pid_" ]]; then
    if [[ -z "$_quiet" ]]; then
      echo "Clipper is running on port 8377."
    fi

    return 0
  fi

  if [[ -z "$_quiet" ]]; then
    echo "Clipper not running on port 8377."
  fi

  return 1
}

start-clipper --quiet
