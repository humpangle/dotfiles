#!/usr/bin/env bats

setup_file() {
  export _executable_under_test=cp-vim-session
  export _relative_path_from_this_file_to_executable_under_test='../scripts'

  local _this_test_file_dir
  _this_test_file_dir="$(dirname "$BATS_TEST_FILENAME")"

  local _executable_to_test_dir
  _executable_to_test_dir="$(
    realpath "$_this_test_file_dir/$_relative_path_from_this_file_to_executable_under_test"
  )"

  # -----------------------------------------------------------------------------
  # Variables that will be exported:
  # -----------------------------------------------------------------------------
  _vim_session_dir=

  set -o allexport
  # shellcheck source=/dev/null
  . "$_executable_to_test_dir/../scripts-utils/${_executable_under_test}-util.bash"
  set +o allexport
  # -----------------------------------------------------------------------------
  # /END/ Variables that will be exported:
  # -----------------------------------------------------------------------------

  _timestamp="-$(date +'%s')"
  export _timestamp

  # mktemp on debian requires at least 3 X's suffix for template.
  local _temp_dir_template="${_executable_under_test}XXX"

  _temp_dir="$HOME/${_timestamp}${_executable_under_test}"

  mkdir -p "$_temp_dir"

  export _temp_dir
}

teardown_file() {
  rm -rf "$_temp_dir"
}

setup() {
  load 'test_helper/common-setup'

  _common_setup "$_relative_path_from_this_file_to_executable_under_test"

  # Source any helper file used by executable under test. This allows us to call/test the functions directly in the
  # helper file. We may also use this method to test functions in scripts when those scripts are not executables.
  # -shellcheck source=/dev/null
  # source "$EXECUTABLE_TO_TEST_ROOT/helper.sh"
}

teardown() {
  find "$_vim_session_dir" \
    -type f \
    -name "*${_timestamp}*" \
    -delete
}

# -----------------------------------------------------------------------------
# tests helper functions
# -----------------------------------------------------------------------------
_mkdir() {
  local _dir="$_temp_dir/$1"
  mkdir -p "$_dir"
  printf "%s" "$_dir"
}

_create_vim_session_file() {
  local _dir=$1
  local -n _return=$2

  _dir="$(_mkdir "$_dir")"

  local _session
  _session="$(_convert_to_vim_session_file "$_dir")"

  local _dir_without_home_prefix
  _dir_without_home_prefix="$(_strip_home_dir_prefix "$_dir")"

  local _dir_with_unusual_chars_escaped
  _dir_with_unusual_chars_escaped="$(_escape_unusual_chars "$_dir_without_home_prefix")"

  cat <<EOM >"$_session"
~$_dir_with_unusual_chars_escaped
~$_dir_with_unusual_chars_escaped
~$_dir_with_unusual_chars_escaped
term://${HOME}${_dir_with_unusual_chars_escaped}//68905:bash
EOM

  _return="$_dir"
}

# -----------------------------------------------------------------------------
# /END/ tests helper functions
# -----------------------------------------------------------------------------

@test "from path must be absolute path" {
  run "$_executable_under_test" ./from /to
  assert_failure
  assert_output --partial "Path to rename from must be absolute path"
}

@test "from path must exist" {
  local _non_existing_from_path
  _non_existing_from_path="/none-existing/$_timestamp"

  run "$_executable_under_test" "$_non_existing_from_path" /to
  assert_failure
  assert_output --partial "$_non_existing_from_path does not exist"
}

@test "to path must be absolute path" {
  local _source_dir
  _source_dir="$(_mkdir from)"

  run "$_executable_under_test" "$_source_dir" to
  assert_failure
  assert_output --partial "Path to rename to must be absolute path"
}

@test "fails if we are unable to copy vim session from source to destination" {
  local _source_dir
  _source_dir="$(_mkdir 'source')"

  local _dest_dir="/to-${_timestamp}" # Path does not exist.

  run "$_executable_under_test" "$_source_dir" "$_dest_dir"

  assert_failure
  assert_output --partial "We are unable to create destination vim session"
}

## bats test_tags=bats:focus
@test "succeeds for unusual characters in file paths" {
  _assert 'source with spaces!@#' 'dest with spaces!@#'
}

## bats test_tags=bats:focus
@test "succeeds for very long file paths and non ascii chars" {
  local _very_long_source_prefix
  _very_long_source_prefix="ô$(printf 'a%.0s' {1..210})"

  local _very_long_dest_prefix
  _very_long_dest_prefix="Ã$(printf 'b%.0s' {1..210})"

  _assert "$_very_long_source_prefix" "$_very_long_dest_prefix"
}

_assert() {
  local _source_prefix="$1"
  local _dest_prefix="$2"

  local _source_dir=

  _create_vim_session_file "$_source_prefix" _source_dir

  local _dest_dir
  _dest_dir="$(_mkdir "$_dest_prefix")"

  run "$_executable_under_test" "$_source_dir" "$_dest_dir"
  assert_success

  local _dest_session
  _dest_session="$(_convert_to_vim_session_file "$_dest_dir")"

  local _dest_dir_unusual_chars_escaped
  _dest_dir_unusual_chars_escaped="$(_escape_unusual_chars "$_dest_dir" 2)"

  local _lines_changed
  _lines_changed="$(grep -cP "$_dest_dir_unusual_chars_escaped" "$_dest_session")"

  assert_equal "$_lines_changed" 4

  run grep -qP "$_source_dir" "$_dest_session"
  assert_failure
}
