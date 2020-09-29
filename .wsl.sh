#!/usr/bin/env bash

if [ -n "$WSL_DISTRO_NAME" ]; then
  # following needed so that cypress browser testing can work in WSL2
  export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"
  # without the next line, linux executables randomly fail in TMUX in WSL
  export PATH="$PATH:/c/WINDOWS/system32"

  alias wslexe='/c/WINDOWS/system32/wsl.exe '
  alias ubuntu20='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu-20.04'
  alias ubuntu18='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu'
fi
