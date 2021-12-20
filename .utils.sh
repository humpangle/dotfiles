#!/bin/bash

function touchm() {
  local data
  local sep
  local dir_path
  data="$1"
  sep="/"

  dir_path=${data%$sep*}

  if [ "$dir_path" == "$data" ]; then
    touch "$dir_path"
  else
    mkdir -p "$dir_path"
    touch "$data"
  fi
}
