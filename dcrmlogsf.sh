#!/usr/bin/env bash

# https://stackoverflow.com/a/42510314

if [[ "$1" == "-h" ]] || [[ -z "$1" ]]; then
  echo "Usage: dcrmlogs container_name_or_ID"
else
  local log_path

  for var in "$@"
  do
      log_path=$(docker inspect --format='{{.LogPath}}' "$var")
      echo "truncating $log_path"
      echo "" | sudo tee "$log_path"
  done
fi
