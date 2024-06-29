#!/bin/bash

resolv_conf_filename="/etc/resolv.conf"

function set-up-dns-resolver {
  : "___help___ ___set-up-dns-resolver-help"

  if [[ -z "${*}" ]]; then
    ___set-up-dns-resolver-help
    return
  fi

  local _use_native_resolver
  local _use_custom_resolver
  local _custom_resolver_server
  local _help
  local _networking_mode

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=native,cloudflare,help,query,networking:,dns: \
      --options=n,c,h,q,t:,r: \
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
      _use_custom_resolver=1
      shift
      ;;

    --dns | -r)
      _use_custom_resolver=1
      _custom_resolver_server="$2"
      shift 2
      ;;

    --networking | -t)
      _validate_networking_mode "$2"
      _networking_mode="$2"
      shift 2
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

  if [[ -n "$_use_custom_resolver" ]]; then
    # Custom resolver supercedes native resolver.
    _use_native_resolver=

    if [[ -z "$_custom_resolver_server" ]]; then
      # Use Cloudflare's resover.
      _custom_resolver_server=1.1.1.1
    fi
  fi

  if [[ -n "${_use_custom_resolver}" ]]; then
    _remove-resolv-conf
    sudo sed -i -e 's|generateResolvConf = true|generateResolvConf = false|' /etc/wsl.conf

    echo "nameserver $_custom_resolver_server" |
      sudo tee "${resolv_conf_filename}" 1>/dev/null

    set-up-dns-resolver --query
    return
  fi

  if [[ -n "${_use_native_resolver}" ]]; then
    _remove-resolv-conf
    sudo sed -i -e 's|generateResolvConf = false|generateResolvConf = true|' /etc/wsl.conf

    _echo "Restart WSL so we can regenerate /etc/resolve.conf"
    set-up-dns-resolver --query
    return
  fi

  if [[ -n "${_networking_mode}" ]]; then
    _setup_networking "$_networking_mode"
    return
  fi
}

function _remove-resolv-conf {
  sudo unlink "$resolv_conf_filename" 2>/dev/null || true
  sudo rm -rf "$resolv_conf_filename" 2>/dev/null || true
}

function ___set-up-dns-resolver-help {
  read -r -d '' var <<'eof' || true
Set up and query DNS resolver for WSL2. Usage:
  wsl-dns-resolver.sh [OPTIONS]

Options:
  --help/-h.        Print help message and exit
  --query/-q.       Ask which DNS resolver is in use.
  --native/-n.      Use WSL native NAT resolver
  --cloudflare/-c.  Use Cloudflare resolver
  --networking/-t.  Networking mode. Values are nat|mirrored
  --networking/-t.  Networking mode. Values are nat|mirrored
  --dns/-r.         Specify a custom resolver.

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

  # Use a custom (google) DNS server
  wsl-dns-resolver --dns 8.8.8.8
  wsl-dns-resolver -r 8.8.8.8
eof

  echo -e "${var}"
}

_win_wsl_conf_filename="/c/Users/$USERNAME/.wslconfig"

function _query {
  _echo "/etc/resolv.conf"
  cat /etc/resolv.conf || true

  _echo "/etc/wsl.conf"
  cat /etc/wsl.conf || true

  _echo "/c/Users/\$USERNAME/.wslconfig"
  cat "$_win_wsl_conf_filename"
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

function _setup_networking {
  local _mode="$1"

  if [ "$_mode" == "nat" ]; then
    sed -i '/####== NETWORKING ==####/,/####== END NETWORKING ==####/ s/^/#/' "$_win_wsl_conf_filename"
  else
    sed -i '/####== NETWORKING ==####/,/####== END NETWORKING ==####/ s/^#//' "$_win_wsl_conf_filename"
  fi

  set-up-dns-resolver --query
}

function _validate_networking_mode {
  local _networking_mode="$1"

  if [[ "$_networking_mode" != nat ]] &&
    [[ "$_networking_mode" != mirrored ]]; then
    echo "Invalid networking mode specified."
    ___set-up-dns-resolver-help
    exit 2
  fi
}

set-up-dns-resolver "${@}"
