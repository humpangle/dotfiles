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
  -l <num_level>
      How many levels up parent directory must we search for the virtualenv directory. This assumes the virtualenv
      directory already exists - it will not be created if it does not exist. NOTE: for now we just change directory to
      the nearest parent's virtualenv. User can than invoke the virtualenv activation and `cd -` back to the original
      environment.

Examples:
  # Get help
  _pv -h

  # Choose what to do dpending on state of user environment
  _pv
  _pv directory

  # Create
  _pv -s directory
  _pv -s

  # Activate virtualenv, search 4 levels up parent directories
  _pv -l 4

  # activate
  _pv directory

  # deactivate
  _pv -d
EOF

  if ! command -v python &>/dev/null; then
    _echo "$help_"
    return
  fi

  local arg_=
  local create_=
  local level_=""

  if ! arg_="$(getopt \
    -o h,s,d,l: \
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

    -l)
      level_="$2"
      shift 2
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
  if [ ! -d "$dir_" ] && [ -z "$level_" ]; then
    _ebnis-create-venv "$dir_"
    _ebnis-wait-for-venv-creation "$dir_"
    _ebnis-activate-venv "$dir_"
    return
  fi

  local cd_="$PWD"

  if [ -n "$level_" ]; then
    _www \
      cd_ \
      "$dir_" \
      "$level_"

    cd "$cd_" || exit 1
    cd - &>/dev/null
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

  # deactivate command will not exist in one of two scenarios:
  # 1. We have never activated a virtualenv.
  # 2. We have deactivated from a virtualenv, but not cleanly
  #
  # For the second case, we clean up the broken deactivated environment.
  if command -v deactivate &>/dev/null; then
    deactivate || :
  elif [ -n "${VIRTUAL_ENV:-}" ]; then
    unset VIRTUAL_ENV
    unset VIRTUAL_ENV_PROMPT
  fi
}

_ebnis-wait-for-venv-creation() {
  local dir_="$1"

  while [ ! -d "$dir_" ]; do
    sleep
  done
}

_find_nearest_virtualenv_dir() {
  local -n return_var_=$1
  local dir_nearest_="$2"
  local level_nearest_="$3"
  return_var_="$dir_nearest_"

  for _l in $(seq "$level_nearest_"); do
    if [ -e "$return_var_" ]; then
      break
    fi

    return_var_="../$return_var_"
  done

  return_var_="$(dirname "$return_var_")"
  return_var_="$(realpath "$return_var_")"
}
