#!/usr/bin/env bats

setup_file() {
  export _executable_under_test=copy
  export _relative_path_from_this_file_to_executable_under_test='../scripts'

  local _this_test_file_dir
  _this_test_file_dir="$(dirname "$BATS_TEST_FILENAME")"

  local _executable_to_test_dir
  _executable_to_test_dir="$(
    realpath "$_this_test_file_dir/$_relative_path_from_this_file_to_executable_under_test"
  )"

  # -----------------------------------------------------------------------------
  # Variables and functions that will be exported:
  # -----------------------------------------------------------------------------
  # _get_copy_program
  # ____copy_help
  set -o allexport
  # shellcheck source=/dev/null
  . "$_executable_to_test_dir/../scripts-utils/${_executable_under_test}-util.bash"
  set +o allexport
  # -----------------------------------------------------------------------------
  # /END/ Variables and functions that will be exported:
  # -----------------------------------------------------------------------------

  _COPY_PROGRAM="$(_get_copy_program)"
  export _COPY_PROGRAM
}

setup() {
  load 'test_helper/common-setup'

  _common_setup "$_relative_path_from_this_file_to_executable_under_test"
}

_make_text() {
  echo -n "hello $(date +'%s')"
}

_copy_via_stdin_helper() {
  echo "$1" | "$_executable_under_test" --debug
}

@test "Fails if there is nothing to copy" {
  run "$_executable_under_test"
  assert_failure
  assert_output "Nothing to copy"
}

@test "Copies to clipboard using shell arguments" {
  local _text
  _text="$(_make_text)"

  run "$_executable_under_test" "$_text" --debug
  assert_success
  assert_output "$_COPY_PROGRAM $_text"
}

@test "Copies to clipboard using stdin" {
  local _text
  _text="$(_make_text)"

  run _copy_via_stdin_helper "$_text"
  assert_success
  assert_output "$_COPY_PROGRAM $_text"
}

@test "Help text" {
  run ____copy_help
  assert_success
  assert_output --partial "Unifying various programs used to interact with system's clipboard under one binary - copy."
}
