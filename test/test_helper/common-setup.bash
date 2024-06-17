#!/usr/bin/env bash

_common_setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  local _relative_path_from_test_file_to_executable_under_test="${1:-..}"

  # Get the containing directory of this file using $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0, as those
  # will point to the bats executable's location or the preprocessed file respectively.
  EXECUTABLE_TO_TEST_DIR="$(
    cd "$(dirname "$BATS_TEST_FILENAME")/$_relative_path_from_test_file_to_executable_under_test" \
      >/dev/null \
      2>&1 &&
      pwd
  )"

  # Make executable visible to $PATH.
  PATH="$EXECUTABLE_TO_TEST_DIR:$PATH"
}
