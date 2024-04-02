#!/usr/bin/env bash

ELIXIR_LS_BASE="$HOME/.elixir-ls"
ELIXIR_LS_SCRIPTS_BASE="${ELIXIR_LS_BASE}/ebnis-scripts"
# Aug 14, 2022 v0.11.0 fe11910
# Nov 8,  2022 v0.12.0 77670d5
# May 6,  2023 v0.14.6 15c0052
# Jun 29, 2023 v0.15.1 9427f7f
# Oct 24, 2023 v0.17.3 d2eb6f3
# Feb 21, 2024 v0.20.0 824fbe0
ELIXIR_LS_STABLE_HASH='824fbe0'

get_hash() {
  local args="${*}"

  # args is equal to `some text --hash=git-hash` or `some text --hash git-hash`
  # sed: may be some text --hash(=)(git-hash)
  local hash="$(
    echo "${args}" |
      sed -n -E "s/.*--hash(=|\s+)([a-zA-Z0-9]+)?.*/\2/p"
  )"

  if [[ -z "${hash}" ]]; then
    hash="${ELIXIR_LS_STABLE_HASH}"
  fi

  echo -n "${hash}"
}

rel_asdf_plugin_version() {
  local _plugin="${1}"

  asdf current "${_plugin}" |
    awk '{print $2}'
}

elixir_ls_install_dir() {
  local install_dir="$ELIXIR_LS_BASE/$(rel_asdf_plugin_version elixir)___$(rel_asdf_plugin_version erlang)/$(get_hash "${@}")"

  printf '%s' "${install_dir}"
}

rel_asdf_elixir_build_f() {
  local elixir_version="$1"
  local install_dir="${ELIXIR_LS_BASE}/${elixir_version}"

  rm -rf mix.lock _build deps

  # shellcheck disable=SC1010
  mix do deps.get, compile

  local release_dir="${ELIXIR_LS_SCRIPTS_BASE}/$elixir_version"
  mkdir -p "$release_dir"
  mix elixir_ls.release -o "$release_dir"

  # Print the path to the language server script so we can use it in LSP
  # client.
  echo -e '\n\n=> The path to the language server script:'
  echo "$release_dir/language_server.sh"

  # shellcheck disable=2103,2164
  cd - >/dev/null
}

rel_asdf_elixir_install_f() {
  local hash
  hash="$(get_hash "${@}")"

  local install_dir
  install_dir="$(elixir_ls_install_dir "${@}")"

  if ! [[ -d "$install_dir" ]]; then
    git clone https://github.com/elixir-lsp/elixir-ls.git "$install_dir"
  fi

  local _elixir_version
  local _erlang_version
  _elixir_version="$(rel_asdf_plugin_version elixir)"
  _erlang_version="$(rel_asdf_plugin_version erlang)"

  (
    echo -e "\n=> Entering install directory ${install_dir} ===\n"

    if ! cd "${install_dir}"; then
      echo -e "\n${install_dir} does not exist, exiting.\n"
      return
    fi

    git restore . &>/dev/null
    git checkout "${hash}"

    rm -rf _build deps

    # There is this situation where `mix.lock` file with the `jason_vendored`
    # dependency is wrongly configured. Let's fix it.
    # ***NOTE*** The `e23c65b98411a3066ca73534b4aed1d23bcf0356` hash is gotten
    # from:
    #  git https://github.com/elixir-lsp/jason.git
    #  git checkout vendored
    #  Copy the hash from where the app name in mix.exs is jason_vendored
    sed -i -E \
      "s/(.*jason_vendored.+jason\.git\", +)\"([^,]+)\"(.*)/\1\"e23c65b98411a3066ca73534b4aed1d23bcf0356\"\3/" \
      mix.lock

    asdf local elixir "${_elixir_version}"
    asdf local erlang "${_erlang_version}"

    # Compile Hex from scratch for this OTP version (fix for apple silicon)
    #   https://elixirforum.com/t/crash-dump-when-installing-phoenix-on-mac-m2-eheap-alloc-cannot-allocate-x-bytes-of-memory-of-type-heap-frag/62154/9?u=samba6
    mix archive.install --force github hexpm/hex branch latest

    mix local.hex --force --if-missing
    mix local.rebar --force --if-missing

    asdf reshim elixir
    asdf reshim erlang

    mix deps.get
    MIX_ENV=prod mix compile

    echo -e '=> Creating the language server scripts.\n'

    local release_dir
    release_dir="$(elixir_ls_rel_bin_dir "${@}")"

    mkdir -p "$release_dir"

    MIX_ENV=prod mix elixir_ls.release2 -o "$release_dir"

    # Print the path to the language server script so we can use it in LSP
    # client.
    echo -e '\n\n=> The path to the language server script:'
    echo "$release_dir/language_server.sh"
  )
}

elixir_ls_rel_bin_dir() {
  local hash
  hash="$(get_hash "${@}")"

  local elixir_version="${1}"

  echo -n "${ELIXIR_LS_SCRIPTS_BASE}/$(rel_asdf_plugin_version elixir)___$(rel_asdf_plugin_version erlang)/${hash}"
}

rel_asdf_elixir_exists_f() {
  local server_bin_path="$(elixir_ls_rel_bin_dir "${@}")/language_server.sh"

  printf "\n%s\n\n" "$server_bin_path"

  if [[ -e "$server_bin_path" ]]; then
    copy "${server_bin_path}"

    printf "Exists\n\n"
  else
    printf "Does not exist\n\n"
  fi
}

alias rel_asdf_elixir_install=rel_asdf_elixir_install_f
alias rel_asdf_elixir_exists=rel_asdf_elixir_exists_f
