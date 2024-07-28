#!/usr/bin/env bash
# shellcheck disable=

_is_local_function() {
  local _function_name="$1"
  local _this_file_content="$2"

  # Function name is not a local function - but perhaps inherited from the shell.
  if ! grep -qP "^$_function_name\(\)\s+\{" <<<"$_this_file_content" &&
    ! grep -qP "function\s+${_function_name}\s+{" <<<"$_this_file_content"; then
    return 1
  fi

  return 0
}

_command_exists() {
  local _command_to_test="$1"
  local _this_file_content
  _this_file_content="$(cat "$0")"

  mapfile -t _all_function_names < <(compgen -A function | grep -v '^_')

  for _func_name in "${_all_function_names[@]}"; do
    if ! _is_local_function "$_func_name" "$_this_file_content"; then
      continue
    fi

    if [[ "$_func_name" == "$_command_to_test" ]]; then
      return 0
    fi
  done

  return 1
}

___help_help() {
  local _usage

  read -r -d '' _usage <<'eom' || :
Get documentation about available commands/functions. Usage:
  script_or_executable help [OPTIONS]

By default, we return only external functions unless option `i` is passed in which case we return only internal
(helper) functions or option `a` is given which causes us to print both internal and external functions.

Options:
  -h
    Print this helper information and exit.
  -i
    Return only internal (helper) functions.
  -a
    Return all functions - both internal and external.
  -p
    Prepend prefix i.e. _func_name ----------- to every line so developer can grep the functon name and get all
    documentation strings for that function name. Without this option, caller may only get examples where the functon
    name is referenced.

Examples:
  # Get help
  script_or_executable help -h

  # Grep for command/function documentation
  script_or_executable help -p | grep ^func_or_command_name
eom

  echo -e "$_usage"
}

help() {
  : "___help___ ___help_help"

  local _opt
  local _function_type="external"
  local _include_prefix

  while getopts 'aip' _opt; do
    case "$_opt" in
    a)
      _function_type='all'
      shift
      ;;

    i)
      _function_type='internal'
      shift
      ;;

    p)
      _include_prefix=1
      shift
      ;;

    *)
      ___help_help
      exit 1
      ;;
    esac
  done

  # Matching pattern examples:
  # `: "___help___ ___some_func_help"`
  # `: "___help___ ____some-func-help"`
  local _help_func_pattern="[_]*___[a-zA-Z][a-zA-Z0-9_-]*[_-]help"

  if [ "$_function_type" = external ]; then
    # External functions do not start with _.
    mapfile -t _function_names < <(
      compgen -A function |
        grep -v '^_'
    )
  elif [ "$_function_type" = internal ]; then
    # Internal helper functions start with _.
    mapfile -t _function_names < <(
      compgen -A function |
        grep '^_' |
        grep -v -E "$_help_func_pattern"
    )
  elif [ "$_function_type" = all ]; then
    mapfile -t _function_names < <(compgen -A function)
  fi

  local _this_file_content
  _this_file_content="$(cat "$0")"

  local _longest_func_name_len=0
  local _func_name_len
  declare -A name_to_len_map=()

  for _func_name in "${_function_names[@]}"; do
    _func_name_len="${#_func_name}"
    name_to_len_map["$_func_name"]="${_func_name_len}"
    if [[ "${_func_name_len}" -gt "${_longest_func_name_len}" ]]; then
      _longest_func_name_len=${_func_name_len}
    fi
  done

  declare -A _all_output=()
  declare -A _aliases=()
  declare -A _name_spaces_map=()

  _longest_func_name_len=$((_longest_func_name_len + 10))

  local _output_prefix=

  for _func_name in "${_function_names[@]}"; do
    if ! _is_local_function "$_func_name" "$_this_file_content"; then
      continue
    fi

    local spaces=""
    _func_name_len="${name_to_len_map[$_func_name]}"
    _func_name_len=$((_longest_func_name_len - _func_name_len))

    for _ in $(seq "${_func_name_len}"); do
      spaces+="-"
    done

    local _function_def_text
    _function_def_text="$(type "${_func_name}")"

    local _alias_name

    # Matching pattern example:
    # `: "___alias___ install-elixir"`
    # Extracts install-elixir
    _alias_name="$(awk \
      'match($0, /^ +: *"___alias___ +([a-zA-Z_-][a-zA-Z0-9_-]*)/, a) {print a[1]}' \
      <<<"${_function_def_text}")"

    if [[ -n "${_alias_name}" ]]; then
      _aliases["${_alias_name}"]="${_aliases["${_alias_name}"]} ${_func_name}"
      continue
    fi

    local _help_func

    _help_func="$(
      # `: "___help___ ___some_func_help"`
      # Extracts ___some_func_help into variable a[1]
      awk \
        -v _awk_help_func_pattern="$_help_func_pattern" \
        'match($0, "^[[:space:]]+:[[:space:]]*\"___help___[[:space:]]+(" _awk_help_func_pattern ")", a) {print a[1]}' \
        <<<"$_function_def_text"
    )"

    # Get the whole function definition text and extract only the documentation
    # part.
    if [[ -n "$_help_func" ]]; then
      # So we have a helper function - we just eval the helper function and split by new lines.
      mapfile -t _doc_lines < <(
        eval "$_help_func" 2>/dev/null
      )
    else
      # Function is not using a helper function but documentation texts - so we extract the documentation texts and
      # split by new lines.
      mapfile -t _doc_lines < <(
        # ^              Assert position at the start of the line
        # [[:space:]]*   Match any whitespace (spaces, tabs) zero or more times
        # :              Match a literal colon
        # [[:space:]]?   Match an optional whitespace
        # \"(.*)\"       Match a quoted string and capture the content within the quotes (documentation text)
        # ;              Match a semicolon (shell line termination placed there by command: type _func_name)
        #
        # Examples:
        # : "This is a documentation line";
        # :"This is a documentation line";
        sed -nEe "s/^[[:space:]]*:[[:space:]]?\"(.*)\";/\1/p" <<<"$_function_def_text"
      )
    fi

    local _output=""
    _output_prefix="$_func_name $spaces "

    if [[ -n "${_doc_lines[*]}" ]]; then
      if [ -z "$_include_prefix" ]; then
        _output+="${_output_prefix}\n"
        _output_prefix=""
      fi

      for _doc in "${_doc_lines[@]}"; do
        # _func_name -------------------- List tmux sessions and clients. Usage:
        _output+="${_output_prefix}$_doc\n"
      done
    else
      # _func_name -------------------- *************
      _output="${_output_prefix}*************\n"
    fi

    _all_output["$_func_name"]="$_output"
    _name_spaces_map["$_func_name"]="$_output_prefix"
  done

  for _func_name in "${!_all_output[@]}"; do
    _output="${_all_output["$_func_name"]}"
    echo -e "$_output"

    local _alias_names="${_aliases["$_func_name"]}"

    if [[ -n "${_alias_names}" ]]; then
      echo -e "${_name_spaces_map["$_func_name"]} ALIASES: ${_alias_names}\n\n"
    fi
  done
}

### USE THIS
if [[ -z "$1" ]]; then
  default_command "$@"
elif [[ "$1" == "--help" ||
  "$1" == "-h" ]]; then
  help "${@:2}"
elif _command_exists "$1"; then
  "$@"
else
  echo "Command not found \"$1\". Type \"___executable___ help\" for available commands." >&2
  exit 127
fi

### OR THIS
"${@:-help}"

### OR THIS
TIMEFORMAT=$'\n\nTask completed in %3lR\n'
time "${@:-help}"
