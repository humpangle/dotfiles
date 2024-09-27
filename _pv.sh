#!/usr/bin/env bash
# shellcheck disable=

_pv() {
  set -eup
  local help_=
  read -r -d '' help_ <<'EOF' || :
Create/activate/deactivate a Virtualenv environment. If no directory is specified, we assume .venv .
Requires python executable in path.

This is an intelligent tool that will do the right thing. What does this mean? If you invoke `_pv` with no argument,
we will take one of the following actions depending on the state of your environment.

If there is a .venv/specified directory and virtualenv is not activated, we will activate your virtualenv environment.
If there is a .venv/specified directory and virtualenv is activated, we will deactivate your virtualenv environment.
If there is no .venv/specified directory, we will create one and activate virtualenv environment.

Usage:
  _pv -h
  _pv [OPTION] [VIRTUALENV_DIRECTORY]

Options:
  -h
      Print help information and exit.
  -s
      Create a Virtualenv environment.
  -d
      Deactivate

Examples:
  # Get help
  _pv -h

  # Choose what to do dpending on state of user environment
  _pv
  _pv directory

  # Create
  _pv -s directory
  _pv -s

  # activate
  _pv directory

  # deactivate
  _pv -d
EOF

  if ! command -v python &>/dev/null; then
    _echo "$help_"
    return
  fi

  local create_=

  local arg_=

  if ! arg_="$(getopt \
    -o h,s,d \
    -n "$0" \
    -- "$@")"; then
    _echo "$help_"
    return
  fi

  eval set -- "$arg_"

  while true; do
    case "$1" in
    -h)
      _echo "$help_"
      return
      ;;

    -d)
      _ebnis-deactivate-venv
      return
      ;;

    -s)
      create_=1
      shift
      ;;

    --)
      shift
      break
      ;;

    *)
      echo "Unknown argument $1"
      _echo "$help_"
      return
      ;;
    esac
  done

  local dir_="${1:-.venv}"

  # Explicit instruction from user to initialize virtualenv.
  if [ -n "$create_" ]; then
    _ebnis-create-venv "$dir_"
    _ebnis-activate-venv "$dir_"
    return
  fi

  # Virtualenv has not been initialized.
  # initialize and activate.
  if [ ! -d "$dir_" ]; then
    _ebnis-create-venv "$dir_"
    _ebnis-wait-for-venv-creation "$dir_"
    _ebnis-activate-venv "$dir_"
    return
  fi

  # We are in a virtualenv, activate.
  if [ -n "${VIRTUAL_ENV:-}" ]; then
    _ebnis-deactivate-venv
    return
  fi

  # We are not in a virtualenv, activate.
  _ebnis-activate-venv "$dir_"
}

_ebnis-activate-venv() {
  local dir_="$1"

  # Without this, the shell might die (try `rm -rf some_pa` and tab for completion).
  set +eup
  # shellcheck source=/dev/null
  source "$dir_/bin/activate"
}

_ebnis-create-venv() {
  local dir_="$1"
  python -m venv "$dir_"
}

_ebnis-deactivate-venv() {
  # Without this, the shell might die (try `rm -rf some_pa` and tab for completion).
  set +eup
  deactivate || :
}

_ebnis-wait-for-venv-creation() {
  local dir_="$1"

  while [ ! -d "$dir_" ]; do
    sleep
  done
}
