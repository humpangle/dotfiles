#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

if [[ -n "$HAS_WSL2" ]]; then
  path="$(wslpath -w "$1")" # Convert unix to windows path
  /c/WINDOWS/explorer.exe "$path"
fi
