set -o errexit
set -o pipefail

if [[ -z "$EBNIS_PHONE_ID" ]]; then
  echo "Set \"EBNIS_PHONE_ID\" environment variable e.g." >&2
  echo "export EBNIS_PHONE_ID='android_redme_note_8_pro'" >&2
  echo "export EBNIS_PHONE_ID='samsung_galaxy_s24'" >&2
  exit 1
fi

_platform_identifier_prefix="$EBNIS_PHONE_ID"

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

git clone https://github.com/humpangle/dotfiles.git ~/dotfiles
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

(
  cd ~/dotfiles/ || exit 1
  git config user.name Kanmii
  git config user.email maneptha@gmail.com
)

_storage_download="$HOME/storage/downloads"

_android_host_out_folder="$_storage_download/__termux"
_dotfiles_termux_dir="$HOME/dotfiles"

_bashrc="$HOME/.bashrc"
cp "$PREFIX/etc/bash.bashrc" "$_bashrc"

mkdir -p "$HOME/.local/bin"

cat <<'EOM' >>"$_bashrc"

##########################################################

[ -f "$HOME/dotfiles/_shell-script" ] && source "$HOME/dotfiles/_shell-script"

export MY_TERMUX_SHARE_DIR="$HOME/storage/downloads/_termux_share"
mkdir -p "$MY_TERMUX_SHARE_DIR"

export SINGLE_FILE_WEB_PAGES_DOWNLOAD_DIR="$MY_TERMUX_SHARE_DIR/web-pages"

# -----------------------------------------------------------------------------
# PROGRAMMING LANGUAGES RELATED
# -----------------------------------------------------------------------------
PYTHON3="$(command -v python 2>/dev/null)"
export PYTHON3

# -----------------------------------------------------------------------------
# ELIXIR LEXICAL
# -----------------------------------------------------------------------------
export NVIM_USE_ELIXIR_LEXICAL=
export ELIXIR_LEXICAL_BIN=''
export ELIXIR_LEXICAL_BIN=''
# -----------------------------------------------------------------------------
# /END/ ELIXIR LEXICAL
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# ELIXIR ELIXIR_LS
# -----------------------------------------------------------------------------
export NVIM_USE_ELIXIR_LS=
export ELIXIR_LS_BIN=
# -----------------------------------------------------------------------------
# /END/ ELIXIR ELIXIR_LS
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# /END/ PROGRAMMING LANGUAGES RELATED
# -----------------------------------------------------------------------------

export DEFAULT_TMUX_SESSION=dot

export EBNIS_VIM_THEME_BG=l
export EBNIS_VIM_THEME_BG=d
EOM

echo "export EBNIS_PHONE_ID='$EBNIS_PHONE_ID'"

_ssh_dir="$HOME/.ssh"
mkdir -p "$_ssh_dir"

if [[ ! -e "$_ssh_dir/config" ]]; then touch "$_ssh_dir/config"; fi

_ssh_identity_prefix="$_ssh_dir/${_platform_identifier_prefix}__ed25519__"

_humpangle_github="${_ssh_identity_prefix}github__humpangle"
_callmiy_github="${_ssh_identity_prefix}github__callmiy"
_hellcooper_github="${_ssh_identity_prefix}github__hellcooper"
_path_array=("$_humpangle_github" "$_callmiy_github" "$_hellcooper_github")

mkdir -p "$_android_host_out_folder"

for _path in "${_path_array[@]}"; do
  _no_ssh_prefix="${_path/$_ssh_dir\//''}"
  echo -e "\n_no_ssh_prefix = $_no_ssh_prefix"
  ssh-keygen -t ed25519 -f "$_path" -C "$_no_ssh_prefix" -P ''

  _to_downloadable_file="$_android_host_out_folder/${_no_ssh_prefix}.txt"
  rm -rf "$_to_downloadable_file"
  cp "${_path}.pub" "$_to_downloadable_file"
  echo -e "\n\n"
done

cat <<EOM >>"$_ssh_dir/config"
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
EOM

# shellcheck disable=2086
chmod 600 $_ssh_dir/*

_echo "Configuring vifmrc"
_vifm_dir="$HOME/.vifm"
mkdir -p "$_vifm_dir"
rm -rf "$_vifm_dir/vifmrc"
ln -s \
  "$_dotfiles_termux_dir/.vifm/vifmrc" \
  "$_vifm_dir"

_echo "Configuring neovim config files"
rm -rf "$HOME/.config/nvim"
mkdir -p "$HOME/.config"
ln -s "$_dotfiles_termux_dir/.config/nvim" "$HOME/.config"

_echo "Linking git config files"
_git_configs=(gitignore gitconfig gitattributes)
for _elm in "${_git_configs[@]}"; do
  rm -rf "$HOME/.${_elm}"
  ln -s "$_dotfiles_termux_dir/$_elm" "$HOME/.${_elm}"
done

_echo "Setting up tmux config"
rm -rf "$HOME/.tmux.conf"
ln -s "$_dotfiles_termux_dir/.tmux.conf" "$HOME"

mkdir -p "$HOME/.tmux/resurrect"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo -e "\n\nsource $_bashrc\n\n"
