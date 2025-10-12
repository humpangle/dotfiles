#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

function __external--install-superfile {
  : "Install superfile - a pretty fancy and modern terminal file manager"

  _echo "INSTALLING SUPERFILE"

  if bash -c "$(curl -sLo- https://superfile.dev/install.sh)"; then
    _echo "Superfile installed successfully"
  else
    _echo "FAILED to install superfile"
  fi
}

__external--install-superfile "$@"
