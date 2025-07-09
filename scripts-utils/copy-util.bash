#!/usr/bin/env bash

_copy_executables=(
  pbcopy
  termux-clipboard-set
  xclip
)

_get_copy_program() {
  if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    echo -n "_copy-ssh"
    return
  fi

  for _program in "${_copy_executables[@]}"; do
    if command -v "$_program" &>/dev/null; then
      echo -n "$_program"
      return
    fi
  done

  echo "Clipboard management program not found." >&2
  exit 1
}

____copy_help() {
  read -r -d '' var <<'eof' || true
Unifying various programs used to interact with system's clipboard under one binary - copy.
Usage:
  copy [OPTIONS] TEXT_TO_COPY

The copy programs covered so far:
  pbcopy     - macos
  xclip      - linux
  _copy-ssh  - custom copy program to sync remote clipboard to host in SSH

Options:
  -h, --help
      Print this help text and quit.
  -d, --debug
      Print confirmation about copied text and program used for copying.


Examples:
  # Get help.
  copy --help
  copy -h

  # copy some text
  copy "some_text"
  echo some_text | copy

  # Print debug information
  copy "some_text" --debug
  echo some_text | copy --debug
eof

  echo -e "${var}"
}
