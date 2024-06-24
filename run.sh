#!/usr/bin/env bash
# shellcheck disable=

set -o errexit
set -o pipefail
set -o noclobber

NODE_BIN=$PWD/node_modules/.bin

# -----------------------------------------------------------------------------
# Helper functions start with _ and aren't listed in this script's help menu unless you pass an argument to the help
# command.
# -----------------------------------------------------------------------------

_clear() {
  clear && printf '\e[3J'
}

# -----------------------------------------------------------------------------
# /END/ HELPER FUNCTIONS
# -----------------------------------------------------------------------------

test() {
  : "Run the BATS tests inside ./test folder."

  local _run="bash $PWD/run.sh"

  (
    cd ./test/ || exit 1

    local _files_to_watch=
    local _files_to_test=

    while IFS= read -r -d '' _file; do
      _files_to_watch+="$_file "

      if [[ "$_file" =~ .bats ]]; then
        _files_to_test+="$_file "
      fi
    done < <(
      find . \
        -type f \
        -not -path '*bats-*' \
        -print0
    )

    # shellcheck disable=2086
    BATS_NO_FAIL_FOCUS_RUN=1 \
      "$NODE_BIN/chokidar" \
      $_files_to_watch \
      --initial \
      --command "$_run _clear && bats $_files_to_test"
  )
}

help() {
  : "List available tasks."

  # Matching pattern examples:
  # `: "___help___ ___some_func_help"`
  # `: "___help___ ____some-func-help"`
  local _help_func_pattern="[_]*___[a-zA-Z][a-zA-Z0-9_-]*[_-]help"

  if [[ -z "$1" ]]; then
    # Regular functions.
    mapfile -t names < <(
      compgen -A function |
        grep -v '^_'
    )
  else
    mapfile -t names < <(
      # Helper functions.
      compgen -A function |
        grep '^_' |
        grep -v -E "$_help_func_pattern"
    )
  fi

  local _this_file_content
  _this_file_content="$(cat "$0")"

  local len=0
  declare -A name_to_len_map=()

  for name in "${names[@]}"; do
    _len="${#name}"
    name_to_len_map["$name"]="${_len}"
    if [[ "${_len}" -gt "${len}" ]]; then len=${_len}; fi
  done

  declare -A _all_output=()
  declare -A _aliases=()
  declare -A _name_spaces_map=()

  len=$((len + 10))

  for name in "${names[@]}"; do
    # Make sure we are only processing function names from this file's content and no names inherited from
    # elsewhere such as the shell.
    if ! grep -qP "^$name\(\)\s+\{" <<<"$_this_file_content" &&
      ! grep -qP "function\s+${name}\s+{" <<<"$_this_file_content"; then
      continue
    fi

    local spaces=""
    _len="${name_to_len_map[$name]}"
    _len=$((len - _len))

    for _ in $(seq "${_len}"); do
      spaces="${spaces}-"
      ((++t))
    done

    local _function_def_text
    _function_def_text="$(type "${name}")"

    local _alias_name

    # Matching pattern example:
    # `: "___alias___ install-elixir"`
    _alias_name="$(awk \
      'match($0, /^ +: *"___alias___ +([a-zA-Z_-][a-zA-Z0-9_-]*)/, a) {print a[1]}' \
      <<<"${_function_def_text}")"

    if [[ -n "${_alias_name}" ]]; then
      _aliases["${_alias_name}"]="${_aliases["${_alias_name}"]} ${name}"
      continue
    fi

    local _help_func

    _help_func="$(
      awk \
        -v _awk_help_func_pattern="$_help_func_pattern" \
        'match($0, "^ +: *\"___help___ +(" _awk_help_func_pattern ")", a) {print a[1]}' \
        <<<"$_function_def_text"
    )"

    # Get the whole function definition text and extract only the documentation
    # part.
    if [[ -n "$_help_func" ]]; then
      mapfile -t _doc_lines < <(
        eval "$_help_func" 2>/dev/null
      )
    else
      mapfile -t _doc_lines < <(
        sed -nEe "s/^[[:space:]]*: ?\"(.*)\";/\1/p" <<<"$_function_def_text"
      )
    fi

    local _output=""

    if [[ -n "${_doc_lines[*]}" ]]; then
      for _doc in "${_doc_lines[@]}"; do
        _output+="$name $spaces $_doc\n"
      done
    else
      _output="$name $spaces *************\n"
    fi

    _all_output["$name"]="$_output"
    _name_spaces_map["$name"]="$name $spaces"
  done

  for name in "${!_all_output[@]}"; do
    _output="${_all_output["${name}"]}"
    echo -e "${_output}"

    local _alias_names="${_aliases["${name}"]}"

    if [[ -n "${_alias_names}" ]]; then
      echo -e "${_name_spaces_map["${name}"]} ALIASES: ${_alias_names}\n\n"
    fi
  done
}

"${@:-help}"
