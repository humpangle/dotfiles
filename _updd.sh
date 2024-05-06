#!/usr/bin/env bash
# shellcheck disable=

set -o errexit
set -o pipefail
set -o noclobber

# system settings -> privacy & security -> accessibility -> /Library/Application Support/UPDD/updd.app
# system settings -> privacy & security -> accessibility -> /Library/Application Support/UPDD/UPDD Commander.app

_this_dir="$(
  dirname "$0"
)"

_previous_loop_process_pid_file="$_this_dir/.___scratch-_updd.sh--pid"

_CRACKER_NAME_INDICATOR='personal'
_cracker_plist_path="/Library/LaunchDaemons/com.touch-base.updd.$_CRACKER_NAME_INDICATOR.plist"
_PROGRAM_ARGUMENT="/Library/Application Support/UPDD/updd.app/Contents/MacOS/updd"

full_line_len=$(tput cols)

_echo() {
  local text="${*}"
  local equal='*'

  local len="${#text}"
  len=$((full_line_len - len))
  local half=$((len / 2 - 1))

  local line=''

  for _ in $(seq $half); do
    line="${line}${equal}"
  done

  echo -e "\n${text}  ${line}${line}\n"
}

_timestamp() {
  date +'%s'
}

_get_names() {
  # Default is external function names.
  mapfile -t _names < <(compgen -A function | grep -v '^_')

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=all,internal,external \
      --options=a,i,e: \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --all | -a)
      mapfile -t _names < <(compgen -A function)
      shift
      ;;

    --internal | -i)
      mapfile -t _names < <(compgen -A function | grep '^_')
      shift
      ;;

    --external | -e)
      # mapfile -t _names < <(compgen -A function | grep -v '^_')
      shift
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      return
      ;;
    esac
  done

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  declare -a _names_from_this_file=()

  local _this_file_content
  _this_file_content="$(cat "${0}")"

  for _name in "${_names[@]}"; do
    # Make sure we are only processing function names from this file's content and no names inherited from
    # elsewhere such as the shell.
    if grep -qP "^$_name\(\)\s+\{" <<<"$_this_file_content" ||
      grep -qP "function\s+${_name}\s+{" <<<"$_this_file_content"; then
      _names_from_this_file+=("$_name")
    fi
  done

  echo "${_names_from_this_file[*]}"
}

# -----------------------------------------------------------------------------
# END HELPER FUNCTIONS
# -----------------------------------------------------------------------------

setup() {
  : "Replace default UPDD programs with ours."

  # Stop and disable the default launch daemon.
  sudo launchctl unload -w /Library/LaunchDaemons/com.touch-base.updd.plist &>/dev/null || true
  _kill_previous_loop_process || true
  _stop &>/dev/null || true

  local _cache_dir="$HOME/.cache/updd-work"
  mkdir -p "$_cache_dir"

  local _original_db_path="/Library/Preferences/updd/db/updd.db"
  local _db_backup_path=""$_cache_dir/updd.db.backup""

  # Make backup of the database if we have not already done so.
  if [[ ! -s "$_db_backup_path" ]]; then
    cp "$_original_db_path" "$_db_backup_path"
  fi

  # Set up temporary names.
  local _now
  _now="$(
    _timestamp
  )"

  local _name_prefix_prefix="___temp-file"
  local _name_prefix_timestamped
  _name_prefix_timestamped="$_name_prefix_prefix-$_now"
  local _name_prefix="$_cache_dir/$_name_prefix_timestamped"

  local _temp_db_path="$_name_prefix.db"
  cp "$_original_db_path" "$_temp_db_path"

  # Update password expiry, registration and support dates in temporary copy of database.
  cat <<"eof" | sqlite3 "$_temp_db_path" -
    UPDATE
      amf_user
    SET
      password_expires='2099-12-31';

    UPDATE
      updd_backup
    SET
      value='2099-12-31'
    WHERE
      name LIKE '%registration%'
    AND
      name LIKE '%until%';

    UPDATE
      updd_setting
    SET
      value='2099-12-31'
    WHERE
      name LIKE '%registration%'
    AND
      name LIKE '%until%';

    -- This is not neccessary. I thought I could increase the click limits - but it does not work.
    UPDATE
      updd_setting
    SET
      value='200'
    WHERE
      name='license.444.eval_click_limit';
eof

  # Replace original database with our own.
  cp "$_temp_db_path" "$_original_db_path"

  # Let us replace programs with our own.
  if [[ -e "$_cracker_plist_path" ]]; then
    sudo launchctl unload -w "$_cracker_plist_path" &>/dev/null || true
    sudo rm -rf "$_cracker_plist_path"
  fi

  local _cracker_script_path="/Library/LaunchDaemons/com.touch-base.updd.$_CRACKER_NAME_INDICATOR.sh"
  sudo rm -rf "$_cracker_script_path"

  cat <<EOF | sudo tee "$_cracker_plist_path" >/dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.touch-base.updd.$_CRACKER_NAME_INDICATOR</string>

  <key>ProgramArguments</key>
  <array>
    <string>$_PROGRAM_ARGUMENT</string>
  </array>

  <key>KeepAlive</key>
  <true/>

  <key>ProcessType</key>
  <string>Standard</string>

  <key>Nice</key>
  <integer>-18</integer>

  <key>Program</key>
  <string>$_cracker_script_path</string>

  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF

  sudo chown root:wheel "$_cracker_plist_path"

  local _timeout_bin
  _timeout_bin="$(
    command -v timeout
  )"

  cat <<EOF | sudo tee "$_cracker_script_path" >/dev/null
#!/usr/bin/env bash
launchctl unload /Library/LaunchDaemons/com.touch-base.updd.plist &>/dev/null || true

"$_PROGRAM_ARGUMENT" -e
EOF

  sudo chmod +x "$_cracker_plist_path"
  sudo chmod +x "$_cracker_script_path"

  sudo launchctl load -w "$_cracker_plist_path"

  # Delete all temporary working files.
  find "$_cache_dir" \
    -type f \
    -name "$_name_prefix_prefix*" \
    -exec rm -rf {} +
}

_stop_updd_processes() {
  upddprocesses stop --commander &>/dev/null || true

  launchctl stop -w /Library/LaunchAgents/com.touch-base.upddcommander.plist &>/dev/null || true

  launchctl unload -w /Library/LaunchAgents/com.touch-base.upddcommander.plist &>/dev/null || true

  launchctl stop -w /Library/LaunchAgents/com.touch-base.updddaemon.plist &>/dev/null || true

  launchctl unload -w /Library/LaunchAgents/com.touch-base.updddaemon.plist &>/dev/null || true

  sudo launchctl unload "$_cracker_plist_path" &>/dev/null || true

  # End all updd processes.
  sudo ps aux |
    awk \
      -v cracker_name_indicator="$_CRACKER_NAME_INDICATOR" \
      '/updd\.(app|cracker_name_indicator)/ {print $2}' |
    xargs sudo kill -KILL \
      &>/dev/null

  sudo ps aux |
    awk \
      '/UPDD\s+Daemon\.app/ {print $2}' |
    xargs sudo kill -KILL \
      &>/dev/null

  echo -e "\n\nupdd off."
}

_start_updd_processes() {
  sudo launchctl load "$_cracker_plist_path" &>/dev/null
  launchctl load -w /Library/LaunchAgents/com.touch-base.updddaemon.plist &>/dev/null
  launchctl load -w /Library/LaunchAgents/com.touch-base.upddcommander.plist &>/dev/null

  # The upddprocesses commander invocation has never worked. May be it will work someday.
  upddprocesses start --commander 2>&1

  # upddutils nodevice set minimum_notify_level 0 # Show all notifications.
  upddutils nodevice set minimum_notify_level 2 # Show critical notifications only.

  echo -e "\n\nupdd on."
}

_kill_previous_loop_process() {
  if [[ -s "$_previous_loop_process_pid_file" ]]; then
    local _pid
    _pid="$(
      cat "$_previous_loop_process_pid_file"
    )"

    if [[ -n "$_pid" ]]; then
      sudo kill -KILL "$_pid" &>/dev/null || true
    fi

  fi

  rm -rf "$_previous_loop_process_pid_file"
}

_loop() {
  # The 200 click limits means we need to restart every 2 minutes so click count will reset.
  # TODO: make restart interval configurable.
  while true; do
    _stop_updd_processes || true
    _start_updd_processes || true
    sleep 120
  done
}

___on_help() {
  read -r -d '' var <<'eof' || true
Start the Universal Pointer Device Driver Processes. Usage:
  _updd.sh
  _updd.sh on

Options:
  --help/-h
    Print this help text and quit.

Examples:
  # Get help.
  _updd.sh --help
  _updd.sh -h
  _updd.sh on --help
  _updd.sh on -h

  # Start all processes and restart every 2 minutes.
  _updd.sh
  _updd.sh on
eof

  echo -e "${var}"
}

on() {
  : "___help___ ___on_help"

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local _parsed

  if ! _parsed="$(
    getopt \
      --longoptions=help \
      --options=h \
      --name "$0" \
      -- "$@"
  )"; then
    ___on_help
    exit 129
  fi

  # Provides proper quoting
  eval set -- "$_parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___on_help
      exit 129
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___on_help
      exit 129
      ;;
    esac
  done
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  _kill_previous_loop_process || true

  local _loop_id
  _loop &>/dev/null &
  _loop_id="$!"
  disown

  echo "$_loop_id" >"$_previous_loop_process_pid_file"
}

___off_help() {
  read -r -d '' var <<'eof' || true
Stop the Universal Pointer Device Driver Processes. Usage:
  _updd.sh off [OPTIONS]
  _updd.sh o [OPTIONS]
  _updd.sh 0 [OPTIONS]

Options:
  --help/-h
    Print this help text and quit.

Examples:
  # Get help.
  _updd.sh off --help
  _updd.sh off -h
  _updd.sh o --help
  _updd.sh o -h

  # Stop all processes.
  _updd.sh off
  _updd.sh 0
  _updd.sh o
eof

  echo -e "${var}"
}

off() {
  : "___help___ ___off_help"

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local _parsed

  if ! _parsed="$(
    getopt \
      --longoptions=help \
      --options=h \
      --name "$0" \
      -- "$@"
  )"; then
    ___off_help
    exit 129
  fi

  # Provides proper quoting
  eval set -- "$_parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___off_help
      exit 129
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___off_help
      exit 129
      ;;
    esac
  done
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  _kill_previous_loop_process || true

  _stop_updd_processes
}

proc() {
  : "Print all running updd processes."

  local _func_name="${FUNCNAME[0]}"

  # Get headers using PID 0. Since PID 0 does not exist, we will get exit code greater than 0.
  ps u -p 0 || true

  local _pid_lines
  mapfile -t _pid_lines < <(
    sudo ps aux | awk '/updd/ {print $0}'
  )

  for _line in "${_pid_lines[@]}"; do
    if ! grep -qP "( awk |$_func_name$)" <<<"$_line"; then
      echo "$_line"
    fi
  done
}

help() {
  : "The following tasks are available:"

  if [[ -z "${1}" ]]; then
    mapfile -t names < <(compgen -A function | grep -v '^_')
  else
    mapfile -t names < <(compgen -A function | grep '^_')
  fi

  local _this_file_content
  _this_file_content="$(cat "${0}")"

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

    local _help_func=''

    # Matching pattern example:
    # `: "___help___ ___elixir[_-]help"`
    _help_func="$(awk \
      'match($0, /^ +: *"___help___ +(___[a-zA-Z][a-zA-Z0-9_-]*[_-]help)/, a) {print a[1]}' \
      <<<"${_function_def_text}")"

    # Get the whole function definition text and extract only the documentation
    # part.
    if [[ -n "${_help_func}" ]]; then
      mapfile -t _doc_lines < <(
        eval "${_help_func}" 2>/dev/null
      )
    else
      mapfile -t _doc_lines < <(
        sed -nEe "s/^[[:space:]]*: ?\"(.*)\";/\1/p" <<<"${_function_def_text}"
      )
    fi

    local _output=""

    if [[ -n "${_doc_lines[*]}" ]]; then
      for _doc in "${_doc_lines[@]}"; do
        _output+="${name} ${spaces} ${_doc}\n"
      done
    else
      _output="${name} ${spaces} *************\n"
    fi

    _all_output["${name}"]="${_output}"
    _name_spaces_map["${name}"]="${name} ${spaces}"
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

if [[ -z "$1" ]]; then
  on "$@"
elif [[ "$1" == "0" ]] ||
  [[ "$1" == "o" ]]; then
  off "${@:2}"
elif [[ "$1" == "--help" ]] ||
  [[ "$1" == "-h" ]]; then
  help "${@:2}"
else
  "$@"
fi
