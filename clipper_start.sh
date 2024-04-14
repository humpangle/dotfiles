#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

start_clipper() {
  : "Start the clipper utility used to sync remote machine's clipboard with client macos'."

  # We only run this utility on macos.
  if [[ "$(uname -s)" != "Darwin" ]]; then
    return
  fi

  # Ensure clipper is installed.
  if ! command -v clipper &>/dev/null; then
    return
  fi

  # Ensure we are only running clipper when we need it for such applications as ubuntu multipass.
  if ! command -v multipass &>/dev/null; then
    return
  fi

  # Ensure clipper is not running. It runs on TCP port 8377.
  if is_clipper_running --quiet; then
    return
  fi

  # Run clipper in the background.
  clipper &
  disown

  echo "clipper is running on port 8377."
}

is_clipper_running() {
  local _quiet

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=quiet \
      --options=q \
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

  if lsof -i :8377 &>/dev/null; then
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

start_clipper
