#!/bin/bash

data="$1"
sep="/"

dir_path=${data%$sep*}

if [ "$dir_path" == "$data" ]; then
  touch "$dir_path"
else
  mkdir -p "$dir_path"
  touch "$data"
fi
