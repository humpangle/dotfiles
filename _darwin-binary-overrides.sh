#!/usr/bin/env bash
# shellcheck disable=

xargs() {
  if ! command -v gxargs &>/dev/null; then
    echo "Install gxargs with 'brew install findutils'"
    exit 1
  fi

  gxargs "$@"
}

realpath() {
  if ! command -v grealpath &>/dev/null; then
    echo "Install grealpath with 'brew install findutils'"
    exit 1
  fi

  grealpath "$@"
}
