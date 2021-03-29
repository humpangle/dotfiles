#!/bin/bash

function touchm() {
  local data;
  local sep;
  local dir_path;
  data="$1";
  sep="/";

  dir_path=${data%$sep*}

  if [ "$dir_path" == "$data" ]; then
    touch "$dir_path";
  else
    mkdir -p "$dir_path";
    touch "$data";
  fi
}

function install_nvim_unstable() {
  local location="$HOME/.local/bin/nv"
  mkdir -p "$HOME/.local/bin"
  wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O "$location"
  chmod u+x "$location"
}
