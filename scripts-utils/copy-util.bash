#!/usr/bin/env bash

_copy_executables=(
  pbcopy
  termux-clipboard-set
  xclip
)

_get_copy_program() {

  if command -v "$__COPY_PROGRAM__" &>/dev/null; then
    echo -n "$__COPY_PROGRAM__"
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
  pbcopy - macos
  xclip  - linux
  clip   - custom copy program I use in ubuntu multipass - based on clipper on macos.

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
