#!/bin/bash

resolv_conf_filename="/etc/resolv.conf"

function set-up-dns-resolver {
  if [[ -z "${*}" ]]; then
    ___set-up-dns-resolver-help
    return
  fi

  local _use_native_resolver
  local _use_cloudflare_resolver
  local _help

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=native,cloudflare,help,query \
      --options=n,c,h,q \
      --name "$0" \
      -- "$@"
  )"; then
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
      --help | -h)
        ___set-up-dns-resolver-help
        return
        ;;

      --query | -q)
        _query
        return
        ;;

      --native | -n)
        _use_native_resolver=1
        shift
        ;;

      --cloudflare | -c)
        _use_cloudflare_resolver=1
        _use_native_resolver=
        shift
        ;;

      --)
        shift
        break
        ;;

      *)
        Echo "Unknown option ${1}."
        exit 1
        ;;
    esac
  done

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  if [[ -n "${_use_cloudflare_resolver}" ]]; then
    _remove-resolv-conf
    sudo sed -i -e 's|generateResolvConf = true|generateResolvConf = false|' /etc/wsl.conf
    echo 'nameserver 1.1.1.1' | sudo tee "${resolv_conf_filename}" 1>/dev/null

    set-up-dns-resolver --query
    return
  fi

  if [[ -n "${_use_native_resolver}" ]]; then
    _remove-resolv-conf
    sudo sed -i -e 's|generateResolvConf = false|generateResolvConf = true|' /etc/wsl.conf

    _echo "Restart WSL so we can regenerate /etc/resolve.conf"
    set-up-dns-resolver --query
  fi
}

function _remove-resolv-conf {
  sudo unlink "$resolv_conf_filename" 2>/dev/null || true
  sudo rm -rf "$resolv_conf_filename" 2>/dev/null || true
}

function ___set-up-dns-resolver-help {
  : "___help___ ___set-up-dns-resolver-help"
  read -r -d '' var <<'eof'
Set up and query DNS resolver for WSL2. Usage:
  wsl-dns-resolver.sh [OPTIONS]

Options:
  --help/-h.        Print help message and exit
  --query/-q.       Ask which DNS resolver is in use.
  --native/-n.      Use WSL native NAT resolver
  --cloudflare/-c.  Use Cloudflare resolver

* Without an option - print this help message and exit

* Cloudflare resolver takes precedence over native resolver.
So if both options --native and --cloudflare are provided,
--cloudflare will take precedence.

Examples:
  wsl-dns-resolver.sh
  wsl-dns-resolver.sh --help
  wsl-dns-resolver.sh --native
  wsl-dns-resolver.sh --cloudflare
  wsl-dns-resolver.sh --query
eof

  echo -e "${var}"
}

function _query {
  _echo "/etc/resolv.conf"
  cat /etc/resolv.conf || true

  _echo "/etc/wsl.conf"
  cat /etc/wsl.conf || true
}

full_line_len=$(tput cols)

function _echo {
  local text="${*}"
  local equal='*'

  local len="${#text}"
  len=$((full_line_len - len))
  local half=$((len / 2 - 1))

  local line=''

  for _ in $(seq $half); do
    line="${line}${equal}"
  done

  echo -e "\n${text} ${equal}${line}${line}"
}

set-up-dns-resolver "${@}"
