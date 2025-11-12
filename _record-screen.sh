#!/usr/bin/env bash
# shellcheck disable=

# Start recording terminal session with timestamped log file
r0() {
  local dir ts
  dir="${TMPDIR:-/tmp}"
  ts=$(date +"%Y%m%d-%H%M%S")
  export RECLOG="${dir}/tty-${ts}.log"
  printf 'Recording to: %s\n' "$RECLOG"
  script -qf "$RECLOG"
}

# Open the most recent (or current) recording in Neovim
r1() {
  # Prefer current shell's RECLOG if it exists
  if [[ -n "${RECLOG:-}" && -f "$RECLOG" ]]; then
    printf 'Opening: %s\n' "$RECLOG"
    nvim -c 'set nobackup nowritebackup noswapfile' \
      -c 'DeAnsify' \
      -c 'normal G' \
      -- "$RECLOG"
    return
  fi

  local dir lastlog
  dir="${TMPDIR:-/tmp}"

  # Find newest tty-*.log safely
  lastlog=$(
    find "$dir" -maxdepth 1 -type f -name 'tty-*.log' -printf '%T@ %p\0' |
      sort -z -nr |
      head -z -n 1 |
      cut -z -d ' ' -f2-
  )

  if [[ -n "$lastlog" ]]; then
    printf 'Opening: %s\n' "$lastlog"
    nvim -c 'set nobackup nowritebackup noswapfile' \
      -c 'DeAnsify' \
      -c 'normal G' \
      -- "$lastlog"
  else
    printf 'No log files found in %s\n' "$dir"
    return 1
  fi
}
