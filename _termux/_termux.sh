set -o errexit

_local_bin="$HOME/.local/bin"
_storage_download="$HOME/storage/downloads"

# Our out folder on the android host.
_storage_download_termux="$HOME/storage/downloads/__termux"

_bashrc="$HOME/.bashrc"
cp "$PREFIX/etc/bash.bashrc" "$_bashrc"

mkdir -p "$_local_bin"
echo -e "\nexport LOCAL_BIN='$_local_bin'\n" >>"$_bashrc"

cat <<'eof' >>"$_bashrc"
if ! grep -qE "$LOCAL_BIN" <<<"$PATH"; then
  export PATH="$LOCAL_BIN:$PATH"
fi

export EDITOR='nvim'

alias which='command -v'
alias ..='cd ..'
alias ls='ls --color=auto'
alias ll='ls -AlhF'
alias C="clear && printf '\e[3J'"
alias cb=clipboard

_do_cd() {
  local level

  if [[ -z "$1" ]] ||
    [[ "$1" == "0" ]]; then
    level=1
  else
    level="$1"
  fi

  for _l in $(seq $level); do
    cd .. || exit 1
  done
}
alias _c='_do_cd'

alias v=nvim
alias fm=vifm

_mdf() {
  mkdir -p "$1"
  # shellcheck disable=2103,2164
  cd "$1"
}

alias mdc='_mdf'
alias md='mkdir -p'

alias ug='apt update && apt upgrade -y'

_run_f() {
  local _script_name

  local _script_pattern=(
    run
    run.sh
    .run
    .run.sh
    do-run.sh
  )

  # Let us search 5 directories level deep for the environment file
  local _parent_search_paths=(
    .
    ..
    ../..
    ../../..
    ../../../..
    ../../../../..
    ../../z
    ../../../z
    "$HOME"
  )

  local exit_parent

  for parent_dir in "${_parent_search_paths[@]}"; do
    unset exit_parent

    for path in "${_script_pattern[@]}"; do
      complete_path="${parent_dir}/$path"

      if [[ -e "$complete_path" ]]; then
        _script_name="$(realpath "$complete_path")"
        exit_parent=1
        break
      fi
    done

    if [[ -n "${exit_parent}" ]]; then break; fi
  done

  local _script_dir="$(dirname "$_script_name")"

  # Let us run the script at the root of script file
  cd "$_script_dir" || true

  bash "$_script_name" "$@"
  local _exit_code="$?"

  cd - &>/dev/null || true

  return "$_exit_code"
}

alias r='_run_f'
eof

_ssh_dir="$HOME/.ssh"
mkdir -p "$_ssh_dir"

if [[ ! -e "$_ssh_dir/config" ]]; then touch "$_ssh_dir/config"; fi

_platform_identifier_prefix="android_redme_note_8_pro"
_ssh_identity_prefix="$_ssh_dir/${_platform_identifier_prefix}__ed25519__"

_humpangle_github="${_ssh_identity_prefix}github__humpangle"
_callmiy_github="${_ssh_identity_prefix}github__callmiy"
_hellcooper_github="${_ssh_identity_prefix}github__hellcooper"
_path_array=("$_humpangle_github" "$_callmiy_github" "$_hellcooper_github")

mkdir -p "$_storage_download_termux"

for _path in "${_path_array[@]}"; do
  _no_ssh_prefix="${_path/$_ssh_dir\//''}"
  echo -e "\n_no_ssh_prefix = $_no_ssh_prefix"
  ssh-keygen -t ed25519 -f "$_path" -C "$_no_ssh_prefix" -P ''

  _to_downloadable_file="$_storage_download_termux/${_no_ssh_prefix}.txt"
  rm -rf "$_to_downloadable_file"
  cp "${_path}.pub" "$_to_downloadable_file"
  echo -e "\n\n"
done

cat <<EOF >>"$_ssh_dir/config"
# git@github.humpangle:humpangle/repo.git
Host github.humpangle
  HostName github.com
  User git
  IdentityFile $_humpangle_github
  StrictHostKeyChecking no

# git@github.callmiy:callmiy/repo.git
Host github.callmiy
  HostName github.com
  User git
  IdentityFile $_callmiy_github
  StrictHostKeyChecking no

# git@github.hellcooper:hellcooper/repo.git
Host github.hellcooper
  HostName github.com
  User git
  IdentityFile $_hellcooper_github
  StrictHostKeyChecking no
EOF

# shellcheck disable=2086
chmod 600 $_ssh_dir/*

_vifm_dir="$HOME/.vifm"
mkdir -p "$_vifm_dir"
rm -rf "$_vifm_dir/vifmrc"

DOTFILE_GIT_DOWNLOAD_URL_PREFIX='https://raw.githubusercontent.com/humpangle/dotfiles/master'

cp \
  "$_storage_download/_termux/vifmrc" \
  "$_vifm_dir"

curl \
  -fLo "$_local_bin/p-env" \
  "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/scripts/p-env"

chmod 755 "$_local_bin/p-env"

echo -e "\n\nsource $_bashrc"
