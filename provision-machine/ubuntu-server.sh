#!/usr/bin/env bash
# shellcheck disable=1090,2009,2046,2143,2164,2103,2230,1091

set -o pipefail

INITIAL_WSL_C_PATH=/mnt/c

# -----------------------------------------------------------------------------
# START version identifier
# -----------------------------------------------------------------------------

# Version Identifiers. Syntax is:
#   WHATEVER_VERSION="version number"
PYTHON_VERSION="3.11.9"
RUST_VERSION="1.65.0"

# -----------------------------------------------------------------------------
# END version identifier
# -----------------------------------------------------------------------------

BASH_APPEND_PATH="${HOME}/__bash-append.sh"
LOCAL_BIN="$HOME/.local/bin"

PROJECT_0_PATH="$HOME/projects/0"
mkdir -p "$PROJECT_0_PATH"

DOTFILE_ROOT="$HOME/dotfiles"
DOTFILE_GIT_DOWNLOAD_URL_PREFIX='https://raw.githubusercontent.com/humpangle/dotfiles/master'

BASH_COMPLETION_DIR=/etc/bash_completion.d

LUA_DEPS=(
  'unzip'
  'g++'
  'build-essential'
  'make'
)

RUST_DEPS=(
  'g++'
  'build-essential'
)

TMUX_DEPS=(
  'libevent-dev'
  'ncurses-dev'
  'build-essential'
  'bison'
  'pkg-config'
  'xclip'
)

NODEJS_DEPS=(
  'python3'
  'g++'
  'make'
  'python3-pip'
  'build-essential'
)

PYTHON_DEPS=(
  'g++'
  'make'
  'build-essential'
  'libssl-dev zlib1g-dev'
  'libbz2-dev'
  'libreadline-dev'
  'libsqlite3-dev'
  'wget'
  'curl'
  'llvm'
  'libncursesw5-dev'
  'xz-utils'
  'tk-dev'
  'libxml2-dev'
  'libxmlsec1-dev'
  'libffi-dev'
  'liblzma-dev'
)

GOLANG_DEPS=(
  'coreutils'
)

ERLANG_DEPS=(
  'g++'
  'build-essential'
  'autoconf'
  'm4'
  'libncurses5-dev'
  'libwxgtk3.0-gtk3-dev'
  'libwxgtk-webview3.0-gtk3-dev'
  'libgl1-mesa-dev'
  'libglu1-mesa-dev'
  'libpng-dev'
  'libssh-dev'
  'unixodbc-dev'
  'xsltproc'
  'fop'
  'libxml2-utils'
  'libncurses-dev'
  'inotify-tools'
)

full_line_len=$(tput cols)
full_line_str=''
line_marker_for__echo='+'

function _full-line-str {
  if [[ -z "${full_line_str}" ]]; then
    # shellcheck disable=SC2034
    for i in $(seq "$full_line_len"); do
      full_line_str="${full_line_str}${line_marker_for__echo}"
    done
  fi
}

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

  echo -e "\n${text}  ${line}${line}\n"
}

function _write-local-bin-path-to-paths {
  if ! grep -q "PATH=.*${LOCAL_BIN}" "$HOME/.bashrc"; then
    echo "export PATH=${LOCAL_BIN}:\$PATH" >>"$HOME/.bashrc"
  fi
}

function _wsl-setup {
  curl -fLO \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/etc/wsl.conf"

  run_as_root \
    mv wsl.conf /etc/wsl.conf
}

install-asdf() {
  : "___alias___ install_asdf"
  install_asdf "${@}"
}

install_asdf() {
  _echo "Installing asdf"

  local arg_=""
  local force_=""

  while getopts ":hf" arg_; do
    case "$arg_" in
    h)
      echo ""
      return
      ;;
    f)
      force_=1
      ;;
    *)
      echo "Unknown option \"$OPTARG\" "
      exit 1
      ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ -z "$force_" ] && command -v asdf &>/dev/null; then
    return
  fi

  if _is_darwin; then
    brew install asdf
    return
  fi

  run_as_root \
    apt-get install \
    --no-install-recommends -y \
    dirmngr \
    gpg \
    gawk

  local version_=""
  version_="$(get_latest_github_release asdf-vm/asdf)"

  local archi_="linux-amd64"

  if _is_arm_hardware; then
    archi_="linux-arm64"
  fi

  curl -Lo asdf.tar.gz \
    "https://github.com/asdf-vm/asdf/releases/download/$version_/asdf-$version_-$archi_.tar.gz"

  tar -xzf asdf.tar.gz
  rm -rf asdf.tar.gz
  mv asdf "$LOCAL_BIN"
}

function _asdf-plugin-install-root {
  local plugin="$1"
  local version="$2"

  printf '%s' "$HOME/.asdf/installs/${plugin}/$version"
}

function _has-wsl {
  [[ "$(uname -r)" == *WSL2 ]] && true
}

function _setup-wsl-home {
  if ! _has-wsl; then
    return
  fi

  if [[ -e /etc/wsl.conf ]]; then
    _echo "WSL already setup."
    return
  fi

  run_as_root \
    cp ~/dotfiles/etc/wsl.conf /etc/wsl.conf

  echo 'export USE_WSL_INTERNET_RESOLVER=1' >>~/.bashrc

  local wsl_user_home_dir="${INITIAL_WSL_C_PATH}/Users/${USERNAME}"

  local vcxsrv_output="${wsl_user_home_dir}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
  local vcxsrv_file='vcxsrv-config.xlaunch'
  local vcxsrv_full_path="${vcxsrv_output}/${vcxsrv_file}"

  if [[ ! -e "$vcxsrv_full_path" ]]; then
    _echo "DOWNLOAD AND CONFIGURE vcxsrv"

    local vcxsrv_download_url="https://sourceforge.net/projects/vcxsrv/files/vcxsrv/1.20.14.0/vcxsrv-64.1.20.14.0.installer.exe/download"

    curl -fLo ~/vcxsrv "${vcxsrv_download_url}"

    mv ~/vcxsrv "${wsl_user_home_dir}/Desktop/vcxsrv.exe"

    cp "$HOME/dotfiles/c/Users/USERNAME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/${vcxsrv_file}" \
      "${vcxsrv_full_path}"
  fi

  if [[ ! -e "${wsl_user_home_dir}/AppData/Roaming/wsltty" ]]; then
    cp "$HOME/dotfiles/c/Users/USERNAME/AppData/Roaming/wsltty/config" \
      "${wsl_user_home_dir}/AppData/Roaming/wsltty"
  fi
}

function _update-and-upgrade-os-packages {
  if _is_linux; then
    run_as_root \
      apt-get update

    run_as_root \
      apt-get upgrade -y

    if ! _is-dev "$@"; then
      run_as_root \
        apt-get install -y \
        git \
        curl
    else
      deps="${LUA_DEPS[*]} \
        ${RUST_DEPS[*]} \
        ${TMUX_DEPS[*]} \
        ${NODEJS_DEPS[*]} \
        ${PYTHON_DEPS[*]} \
        ${GOLANG_DEPS[*]} "

      local cmd="sudo apt-get install -y ${deps}"
      eval "$cmd"
    fi

    run_as_root \
      apt-get autoremove -y
  fi
}

function _is-dev {
  [[ "${*}" =~ dev ]] && true
}

function _install-deps {
  run_as_root \
    apt-get update

  local cmd="sudo apt-get install -y $1"
  eval "$cmd"
}

function _extract-version {
  awk -v word="${1}" 'match($0, word "\\s+([.a-zA-Z0-9_-]+)", a) {print a[1]}' "${2}"
}

function _get_script_version {
  echo -n "$(
    type "${FUNCNAME[1]}" |
      awk -F'=' '/local\s+__VERSION__=/ { match($2, "\"?([^;\"]+)\"?", a) } END {print a[1]}'
  )"
}

_is_linux() {
  if [ "$(uname -s)" = "Linux" ]; then
    return 0
  else
    return 1
  fi
}

_is_darwin() {
  if [ "$(uname -s)" = "Darwin" ]; then
    return 0
  else
    return 1
  fi
}

_is_arm_hardware() {
  local _hardware_platform
  _hardware_platform="$(
    uname -m
  )"

  if [[ "$_hardware_platform" == "arm64" ]] ||
    [[ "$_hardware_platform" == "aarch64" ]]; then
    return 0
  else
    return 1
  fi
}

_install_erlang_os_deps() {
  if _is_darwin; then
    brew install \
      autoconf \
      openssl@1.1 \
      openssl \
      wxwidgets \
      libxslt \
      fop
  else
    _install-deps "${ERLANG_DEPS[*]}"
    run_as_root \
      apt-get autoremove -y
  fi
}

_install_tmux_plugins() {
  _echo "Installing tmux plugins."

  local install_path="$HOME/.tmux/plugins/tpm"

  if [ ! -d "$install_path" ]; then
    git clone https://github.com/tmux-plugins/tpm "$install_path"
  else
    cd "$install_path"
    git pull origin master
    cd - &>/dev/null
  fi

  if ! _is-dev "$@"; then
    _echo "DOWNLOADING TMUX CONF"

    curl -fLo ~/.tmux.conf \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/.tmux.conf"
  fi

  mkdir -p "$HOME/.tmux/resurrect"
}

# -----------------------------------------------------------------------------
# END HELPER FUNCTIONS
# -----------------------------------------------------------------------------

function install-golang {
  : "Install golang"

  local version_="${1:-latest}"

  _echo "INSTALLING GOLANG $version_"

  if ! _is-dev "$@"; then
    _install-deps "${GOLANG_DEPS[*]}"
  fi

  asdf plugin add golang
  asdf install golang "$version_"
}

function install-rust {
  : "Install rust"

  local version_="${1:-latest}"

  _echo "INSTALLING RUST version $version_"

  if ! _is-dev "$@"; then
    _install-deps "${RUST_DEPS[*]}"
  fi

  asdf plugin add rust

  if [ "$version_" = latest ]; then
    version_="$(
      asdf list all rust |
        tail -n1
    )"

    _echo "INSTALLING RUST latest version $version_"
  fi

  _echo "Caching current directory $PWD"
  local this_dir_="$PWD"

  _echo "Changing directory to $PROJECT_0_PATH"
  cd "$PROJECT_0_PATH" || :

  _echo "Begin installing rust $version_"
  asdf install rust "$version_"
  _echo "Rust $version_ installed. Configuring..."

  _echo "Setting global rust version to $version_"
  asdf set rust "$version_"

  local rust_install_root
  rust_install_root="$(_asdf-plugin-install-root rust "$version_")"

  # shellcheck source=/dev/null
  source "${rust_install_root}/env"

  asdf reshim rust

  _echo "Install and set as default latest release of cargo"
  rustup default stable

  asdf reshim rust

  local cargo_bin_dir="${HOME}/.cargo/bin"

  if [[ -d "${cargo_bin_dir}" ]]; then
    _echo "Configure cargo bin directory to $cargo_bin_dir"
    echo "export PATH=${cargo_bin_dir}:\$PATH" >>"${HOME}/.bashrc"
  fi

  cd "$this_dir_"
}

uninstall-docker() {
  : "Uninstall docker on debian linux"

  # We don't want to get apt autoremove suggestions.
  run_as_root \
    apt autoremove -y

  run_as_root \
    apt-get purge -y \
    docker.io \
    docker-doc \
    docker-compose \
    docker-compose-v2 \
    podman-docker \
    containerd \
    runc \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
}

install-docker() {
  : "Install docker on debian linux"

  _echo "INSTALLING DOCKER"

  # https://docs.docker.com/engine/install/ubuntu/

  uninstall-docker

  # Delete this file in case docker was previously installed as the new installation below will append to the file
  # causing invalid json.
  run_as_root \
    rm -rf /etc/docker/daemon.json

  # Add Docker's official GPG key:
  run_as_root \
    apt-get update

  run_as_root \
    apt-get install ca-certificates curl

  run_as_root \
    install -m 0755 -d /etc/apt/keyrings

  run_as_root \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

  run_as_root \
    chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    run_as_root \
      tee /etc/apt/sources.list.d/docker.list >/dev/null

  run_as_root \
    apt-get update

  # Install docker and its components:
  sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

  sudo apt autoremove -y

  sudo groupadd docker >/dev/null || :
  sudo usermod -aG docker "${USER}" || :

  # Confirm if docker can not run for whatever reason.
  sudo dockerd --debug
}

___install-asdf-postgres_help() {
  read -r -d '' var <<'eof' || true
Install postgres with ASDF. Usage:
  install-asdf-postgres [OPTIONS]

Options:
  -h
    Print this help text and quit.
  -v  VERSION
    Install VERSION

Examples:
  # Get help.
  install-asdf-postgres -h

  # Install latest version from asdf plugin postgres
  install-asdf-postgres

  # Install specific version
  install-asdf-postgres -v 15.4
eof

  echo -e "${var}"
}

install-asdf-postgres() {
  : "___alias___ install_asdf_postgres"
  install_asdf_postgres "$@"
}

install_asdf_postgres() {
  : "___help___ ___install-asdf-postgres_help"

  local version_=
  local _o=

  while getopts 'hv:' o_; do
    case "$o_" in
    h)
      ___install-asdf-postgres_help
      return
      ;;
    v)
      version_="$2"
      ;;

    *)
      echo "Unknown option: $o_"
      exit 1
      ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -z "$_version" ]]; then
    _version="$(
      asdf list all postgres |
        grep -P "^\d+\.\d+$" |
        tail -1
    )"
  fi

  if _is_linux; then
    sudo apt-get update

    sudo apt-get install -y \
      g++ \
      build-essential \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      libcurl4-openssl-dev \
      uuid-dev

    sudo apt-get autoremove -y
  else
    brew install \
      gcc \
      readline \
      zlib \
      curl \
      ossp-uuid \
      icu4c
  fi

  asdf plugin add postgres
  asdf install postgres "$version_"

  echo -e \
    "Set global version using command: \nasdf set -u postgres $version_"
}

function install-postgres {
  : "Install postgres"

  if [ -x "$(command -v psql)" ]; then
    echo "Postgres already installed. Exiting."
    exit 0
  fi

  _echo "INSTALLING POSTGRES"

  # https://www.postgresql.org/download/linux/ubuntu/

  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt update
  sudo apt -y install postgresql

  sudo apt-get autoremove -y
}

install_tmux() {
  : "Install tmux"

  if _is_darwin; then
    brew install tmux
  else
    local tmux_version

    tmux_version="$(
      get_latest_github_release tmux/tmux
    )"

    _echo "Installing tmux version ${tmux_version}"

    local current_tmux_bin_path
    current_tmux_bin_path="$(command -v tmux)"

    if [ -e "$current_tmux_bin_path" ]; then
      tmux kill-server &>/dev/null || true
      sudo rm -rf "$current_tmux_bin_path"
      sudo apt remove -y --purge tmux
    fi

    if ! _is-dev "$@"; then
      _install-deps "${TMUX_DEPS[*]}"
    fi

    curl -LO "https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz"
    tar xf "tmux-${tmux_version}.tar.gz"
    rm -f "tmux-${tmux_version}.tar.gz"
    cd "tmux-${tmux_version}"
    ./configure
    make
    sudo make install
    cd - &>/dev/null
    sudo rm -rf /usr/local/src/tmux-\*
    sudo mv "tmux-${tmux_version}" /usr/local/src
  fi

  _install_tmux_plugins "$@"
}

install-neovim() {
  : "___alias___ install_neovim"
  install_neovim
}

install_neovim() {
  : "Install neovim"

  _echo "Installing neovim"

  install_asdf
  asdf plugin add neovim
  asdf install neovim latest
  asdf set -u neovim "$(asdf list neovim)"

  mkdir -p "$HOME/.config"

  if [[ -d "$DOTFILE_ROOT" ]]; then
    local _dest="$HOME/.config/nvim"
    local _source="$DOTFILE_ROOT/.config/nvim"

    _echo "Linking $_source to $_dest."
    ln -s "$_source" "$_dest"
  fi

  if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
  fi

  install_bat
  install_ripgrep
}

install_neovim_from_source() {
  sudo apt update
  sudo apt install ninja-build gettext cmake unzip curl build-essential

  git clone https://github.com/neovim/neovim.git
  cd neovim
  git checkout v0.11.1
  make CMAKE_BUILD_TYPE=Release
  sudo make install
  cd -
  sudo rm -rf neovim
}

install_ripgrep() {
  _echo "Attempting to install ripgrep"

  if _is_darwin; then
    brew install ripgrep
    return
  fi

  local _version
  _version="$(
    get_latest_github_release BurntSushi/ripgrep
  )"

  if _is_arm_hardware; then
    local _folder_name="ripgrep-${_version}-aarch64-unknown-linux-gnu"
    local _filename="${_folder_name}.tar.gz"

    rm -rf "$_filename" "$_folder_name"

    curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${_version}/$_filename"

    tar xzvf "$_filename"

    local _bin="${_folder_name}/rg"

    sudo chown root:root "$_bin"
    sudo chmod +x "$_bin"
    sudo mv "$_bin" /usr/bin

    rm -rf "$_filename" "$_folder_name"
  else
    local filename_="ripgrep_${_version}-1_amd64.deb"
    rm -rf "$filename_"

    local url_="https://github.com/BurntSushi/ripgrep/releases/download/${_version}/$filename_"
    _echo "Downloading from\n$url_"
    curl -LO "$url_"

    sudo dpkg -i "$filename_"
    rm -rf "$filename_"
  fi
}

install_bat() {
  : "'bat' is for syntax highlighting inside 'fzf'"

  if _is_darwin; then
    brew install bat
  else
    local _version
    _version="$(
      get_latest_github_release sharkdp/bat
    )"

    _version="${_version/v/''}"

    local _machine_archi="amd64"

    if _is_arm_hardware; then
      _machine_archi="arm64"
    fi

    local bat_deb="bat_${_version}_${_machine_archi}.deb"
    rm -rf "$bat_deb"
    curl -LO "https://github.com/sharkdp/bat/releases/download/v${_version}/${bat_deb}"
    sudo dpkg -i "${bat_deb}"
    rm "${bat_deb}"
  fi
}

function install-haproxy {
  : "Install haproxy"

  local version="2.4"

  _echo "INSTALLING HAPROXY VERSION ${version}"

  sudo apt install -y --no-install-recommends software-properties-common
  sudo add-apt-repository "ppa:vbernat/haproxy-${version}" -y
  sudo apt update
  sudo apt install -y "haproxy=${version}.*"
}

function install-bins {
  : "Install useful binaries"

  _echo "INSTALLING adhoc binaries"

  sudo apt-get update

  mkdir -p "${LOCAL_BIN}"

  _write-local-bin-path-to-paths

  declare -a local_bin_scripts=(p-env ebnis-save-tmux.sh)

  for _script in "${local_bin_scripts[@]}"; do
    local _script_output_path="${LOCAL_BIN}/${_script}"

    curl -fLo "${_script_output_path}" \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/scripts/${_script}"

    chmod u+x "${_script_output_path}"
  done

  curl -fLo "${BASH_APPEND_PATH}" \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/_shell-script"

  echo "[ -f ${BASH_APPEND_PATH} ] && source ${BASH_APPEND_PATH}" >>"$HOME/.bashrc"
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"

  install-complete-alias

  mkdir -p ~/.ssh
}

install_vifm() {
  : "Install VIFM"

  local version
  version="$(
    get_latest_github_release vifm/vifm
  )"

  local _version_no_prefix="${version/v/''}"

  _echo "INSTALLING VIFM VERSION ${version}"

  if ! _is-dev "$@"; then
    run_as_root apt-get update

    run_as_root \
      apt-get install -y `# I need to determine minimum deps for building vifm.` \
      curl \
      g++ \
      ca-certificates \
      gnupg \
      build-essential \
      make \
      libevent-dev \
      ncurses-dev \
      libncursesw5-dev \
      libssh-dev \
      lsb-release \
      bison \
      xclip `# for yanking file paths`
  fi

  local _filename="vifm-${_version_no_prefix}.tar.bz2"

  curl -LO "https://github.com/vifm/vifm/releases/download/${version}/$_filename"
  tar xf "$_filename"
  rm -f "$_filename"
  cd "vifm-${_version_no_prefix}" || exit
  ./configure
  make
  sudo make install
  cd - &>/dev/null || exit
  sudo rm -rf /usr/local/src/vifm-*
  sudo mv "vifm-${_version_no_prefix}" /usr/local/src

  _echo "Setting up vifmrc"

  local _dest="$HOME/.vifm/vifmrc"

  if [[ -s "$_dest" ]]; then
    local _dest_bak
    _dest_bak="$_dest-$(date +'%s')"

    _echo "Backing up $_dest to $_dest_bak"

    mv "$_dest" "$_dest_bak"
  else
    mkdir -p "$(dirname "$_dest")" # In case the directory does not exist previously.
  fi

  if [[ -d "$DOTFILE_ROOT" ]]; then
    local _source="$DOTFILE_ROOT/.vifm/vifmrc"
    _echo "Linking $_source to $_dest."
    ln -s "$_source" "$_dest"
  else
    local _source="$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/.vifm/vifmrc"
    _echo "Downloading $_source to ${_dest}."
    curl --create-dirs -fLo "$_dest" "$_source"
  fi
}

function install-git {
  : "Install Git"

  curl -fLo ~/.gitconfig \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/gitconfig"

  curl -fLo ~/.gitignore \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/gitignore"
}

install-erlang() {
  : "Install erlang"

  local version_=latest

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=erlang: \
      --options=v: \
      --name "$0" \
      -- "$@"
  )"; then
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --version | -v)
      version_="$2"
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

  _echo "INSTALLING ERLANG version: ${version_}"

  _install_erlang_os_deps

  export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
  # Do not build erlang docs when installing with
  # asdf cos it's slow and unstable
  export KERL_BUILD_DOCS=yes
  export KERL_INSTALL_MANPAGES=
  export KERL_INSTALL_HTMLDOCS=

  asdf plugin add erlang || :
  asdf install erlang "${version_}"
}

install-rebar3() {
  : "Install rebar3"

  local rebar3_version=3.20.0

  _echo "INSTALLING REBAR3"

  curl -fLo "$HOME/.local/bin/rebar3" \
    --create-dirs \
    https://github.com/erlang/rebar3/releases/download/${rebar3_version}/rebar3

  chmod u+x "$HOME/.local/bin/rebar3"

  _write-local-bin-path-to-paths
}

function i-elixir {
  : "___alias___ install-elixir"

  install-elixir "${@}"
}

install-elixir() {
  : "___help___ ___elixir-help"

  local version_="latest"

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,version: \
      --options=h,v: \
      --name "$0" \
      -- "$@"
  )"; then
    ___elixir-help
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___elixir-help
      return
      ;;

    --version | -v)
      version_="${2}"
      shift 2
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___elixir-help
      return
      ;;
    esac
  done

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  _echo "INSTALLING ELIXIR ${version_}"

  if _is_darwin; then
    brew install unzip
  else
    sudo apt-get update

    sudo apt-get install -y \
      unzip
  fi

  asdf plugin add elixir || :

  asdf install elixir "$version_"
}

elixir-post-install() {
  : "Install hex and rebar"

  # Compile Hex from scratch for this OTP version (fix for apple silicon)
  #   https://elixirforum.com/t/crash-dump-when-installing-phoenix-on-mac-m2-eheap-alloc-cannot-allocate-x-bytes-of-memory-of-type-heap-frag/62154/9?u=samba6
  mix archive.install --force github hexpm/hex branch latest

  mix local.hex --force --if-missing
  mix local.rebar --force --if-missing
}

function ___elixir-help {
  read -r -d '' var <<'eof'
Install elixir with ASDF. Usage:
  pm install-elixir [OPTIONS]

Without specifying an option, we will install latest asdf elixir version.

Options:
  --help/-h.                    Print help message and exit
  -v/--version.                 Specify elixir version.

Examples:
  # Get help
  pm install-elixir -h
  pm install-elixir --help

  # Install latest asdf elixir
  pm install-elixir
  pm i-elixir

  # Install specified version
  pm install-elixir --version=1.14.3
  pm install-elixir -v 1.14.3
eof

  echo "${var}"
}

install-nodejs() {
  : "___alias___ install_nodejs"
  install_nodejs "$@"
}

install_nodejs() {
  : "___help___ ___nodejs-help"

  local version
  local _dev

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,dev,local,version: \
      --options=h,d,l,a: \
      --name "$0" \
      -- "$@"
  )"; then
    ___nodejs-help
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___nodejs-help
      return
      ;;

    --version | -a)
      version="${2}"
      shift 2
      ;;

    --dev | -d)
      _dev=1
      shift 1
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___nodejs-help
      exit 1
      ;;
    esac
  done

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  if [[ -z "${version}" ]]; then
    version=latest
  fi

  _echo "INSTALLING NODEJS version ${version}"

  if [[ -n "${_dev}" ]]; then
    if _is_linux; then
      _install-deps "${NODEJS_DEPS[*]}"
    else
      brew install \
        gcc \
        make
    fi
  fi

  asdf plugin add nodejs || true

  asdf install nodejs "${version}"
}

function ___nodejs-help {
  read -r -d '' var <<'eof'
Install nodejs with ASDF. Usage:
  pm install-nodejs [OPTIONS]

Options:
  --help/-h.                   Print help message and exit
  --local/-l.                  Whether to set the nodejs version we are
                               installing as the version for the folder from
                               where we are installing. If you do not specify
                               --version/-a option, this option will be ignored.
  --dev/-d.                    Set specified nodejs and erlang versions as
                               global versions
  --version/-a nodejs_version. Install specific nodejs version

Examples:
  pm install-nodejs --help
  pm install-nodejs # install default nodejs version
  pm install-nodejs --version=17.9.1
  pm install-nodejs -a 17.9.1 --local
eof

  echo "${var}"
}

function install-nodejs-dev-pkgs {
  # https://github.com/websockets/wscat - curl for websockets

  npm install --global \
    yarn \
    eslint_d \
    goops \
    typescript \
    prettier \
    @fsouza/prettierd \
    sort-package-json \
    intelephense \
    chokidar-cli \
    graphql-language-service-cli \
    @tailwindcss/language-server \
    wscat
}

install-python() {
  : "Install python"

  local _version="$PYTHON_VERSION"
  local _dev

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=global,dev,version: \
      --options=g,d,v: \
      --name "$0" \
      -- "$@"
  )"; then
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --dev | -d)
      _dev='dev'
      shift
      ;;

    --version | -v)
      _version="$2"
      shift 2
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

  _echo "INSTALLING PYTHON $_version"

  if _is_darwin; then
    brew install \
      openssl \
      readline \
      sqlite3 \
      xz \
      zlib \
      tcl-tk
  else
    _install-deps "${PYTHON_DEPS[*]}"
  fi

  asdf plugin add python 2>/dev/null

  asdf install python "$_version"
}

function install-ansible {
  : "Install ansible"

  # if [[ ! -d "$(_asdf-plugin-install-root python "$PYTHON_VERSION")" ]]; then
  #   install-py
  # fi

  pip install -U \
    psycopg2 \
    ansible
}

function install-lua {
  : "Install lua"

  local version=5.4.4

  _echo "INSTALLING LUA VERSION ${version}"

  if ! _is-dev "$@"; then
    _install-deps "${LUA_DEPS[*]}"
  fi

  if ! _has-wsl; then
    sudo apt-get install -y \
      linux-headers-$(uname -r)
  fi

  asdf plugin add lua
  asdf install lua $version
}

function install-mysql {
  : "Install mysql"

  _echo "INSTALLING msql"

  local version=8.0.32

  sudo apt-get update

  sudo apt-get install -y \
    curl \
    libaio1 \
    libtinfo5 \
    libncurses5 \
    numactl

  asdf plugin add mysql
  asdf install mysql $version

  export DATADIR="$HOME/mysql_data_${version//./_}"
  mkdir -p "$DATADIR"
  mysqld --initialize-insecure --datadir="$DATADIR"
  mysql_ssl_rsa_setup --datadir="$DATADIR"

  asdf reshim mysql

  unset DATADIR
}

function install-php {
  : "Install php"

  local version_="${1:-latest}"

  _echo "INSTALLING PHP $version_"

  sudo apt-get update

  sudo apt-get install -y \
    autoconf \
    bison \
    build-essential \
    curl \
    gettext \
    git \
    libgd-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libicu-dev \
    libjpeg-dev \
    libmysqlclient-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libzip-dev \
    openssl \
    pkg-config \
    re2c \
    zlib1g-dev \
    plocate

  asdf plugin add php

  asdf install php "$version_"
}

post-install-php() {
  local version_=""
  version_="$(
    asdf current php 2>/dev/null |
      awk '{print $2}'
  )"

  if [ -z "$version_" ]; then
    echo -e "Error: version is required. Exiting!"
    return
  fi

  curl -fL \
    https://cs.symfony.com/download/php-cs-fixer-v3.phar -o /tmp/php-cs-fixer

  sudo chmod a+x /tmp/php-cs-fixer
  sudo mv /tmp/php-cs-fixer /usr/local/bin/php-cs-fixer

  local _php_version_install_root
  _php_version_install_root="$(_asdf-plugin-install-root php "$version_")"

  local _ini_file="${_php_version_install_root}/conf.d/php.ini"
  local _extensions_root="${_php_version_install_root}/lib/php/extensions"

  asdf reshim php

  pear config-set php_ini "${_ini_file}"
  pecl config-set php_ini "${_ini_file}"
  asdf reshim php

  pecl channel-update pecl.php.net
  pecl install xdebug

  local _opcache_extension_path
  _opcache_extension_path="$(find "${_extensions_root}" -type f -name opcache.so)"

  if [[ -n "${_opcache_extension_path}" ]]; then
    # opcache extension needs to be the first line
    echo -e "zend_extension=${_opcache_extension_path}\n$(cat "${_ini_file}")" >"${_ini_file}"
  else
    _echo "opcache extension path not found"
  fi

  asdf reshim php
}

function set-password-less-shell {
  : "Allow current shell user to run root commands without sudo password"

  echo "$USER ALL=(ALL) NOPASSWD:ALL" |
    sudo tee -a /etc/sudoers.d/set-password-less-shell
}

function min-machine {
  : "Setup the machine"
  setup-machine-min "$@"
}

function setup-machine-min {
  : "Setup the machine"

  if _has-wsl; then
    _wsl-setup
  fi

  install-bins
  install-git
  install_neovim "$@"
  install_tmux
  install_vifm
}

function install-dev {
  : "See setup-dev"
  setup-dev "$@"
}

function provision-dev {
  : "See setup-dev"
  setup-dev "$@"
}

function setup-dev {
  : "Setup dev machine with dotfiles"

  USERNAME="$(
    cmd.exe /c echo %USERNAME% 2>/dev/null |
      tr -d '\r\n '
  )"

  if _has-wsl; then
    if [[ -z "$USERNAME" ]]; then
      echo -e "\nWindows OS username is required as USERNAME environment variable"
      exit
    else
      echo "export USERNAME='$USERNAME'" >>~/.bashrc
      echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf >/dev/null
    fi
  fi

  _echo "SETUP DEV MACHINE WITH DOTFILE"

  _update-and-upgrade-os-packages dev

  mkdir -p ~/.ssh
  install-complete-alias

  install_tmux dev
  install_vifm dev
  install-chrome

  mkdir -p "${LOCAL_BIN}" \
    ~/.ssh \
    ~/.config \
    ~/.vifm \
    ~/.config/erlang_ls

  if [[ ! -d "$HOME/dotfiles" ]]; then
    git clone https://github.com/humpangle/dotfiles ~/dotfiles
    touch ~/dotfiles/snippet_in.txt
    touch ~/dotfiles/snippet_out.json

    sed -i -e "s/filemode = true/filemode = false/" ~/dotfiles/.git/config

    [[ -e ~/dotfiles/to_snippet_vscode.py ]] &&
      chmod 755 ~/dotfiles/to_snippet_vscode.py
  fi

  _setup-wsl-home

  declare -a _file_src_to_link_dest=(
    'gitignore .gitignore'
    'gitconfig .gitconfig'
    '.config/nvim'
    '.iex.exs'
    '.tmux.conf'
    '.config/shellcheckrc'
  )

  for _string in "${_file_src_to_link_dest[@]}"; do
    IFS=' ' read -r -a _array <<<"$_string"
    local _src="${_array[0]}"
    local _dest="${_array[1]}"

    if [[ -z "$_dest" ]]; then
      _dest="$_src"
    fi

    _dest="$HOME/$_dest"

    rm -rf "$_dest"
    ln -s "$HOME/dotfiles/$_src" "$_dest"
  done

  curl -fLo "$HOME/complete_alias.sh" \
    https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias

  touch "${HOME}/.hushlogin"

  # We preliminary save tmux sessions every minute instead of default to 15.
  # After the first save, we must revert back to 15 - so git does not record
  # any changes.
  sed -i -E "s/set -g @continuum-save-interval '15'/set -g @continuum-save-interval '1'/" ~/dotfiles/.tmux.conf

  # Install tmux plugins specified in .tmux.conf
  chmod 755 ~/.tmux/plugins/tpm/bin/install_plugins
  ~/.tmux/plugins/tpm/bin/install_plugins

  chmod 755 ~/dotfiles/scripts/*
  find ~/dotfiles/etc/ -type f -name "*.sh" -exec chmod 755 {} \;

  echo "export INTELEPHENSE_LICENCE=''" >>~/.bashrc

  install-golang dev || true
  install-nodejs --dev || true
  install-python --dev --global || true

  # Installing lua will also install rust because of stylua
  install-lua dev || true

  # Many times, installing rust will just error (mostly for network reasons)
  # So we try again just one more time.
  rust_path="$(_asdf-plugin-install-root rust "${RUST_VERSION}")"
  if ! [[ -e "${rust_path}" ]]; then
    install-rust dev
  fi

  install_neovim dev

  sudo apt-get autoremove -y

  if [[ ! -e /etc/sudoers.d/user_defaults ]]; then
    cp ~/dotfiles/etc/sudoers.d/user_defaults "${HOME}"

    sed -i -e "s/__USERNAME__/$USER/g" ~/user_defaults
    sed -i -e "s|__NEOVIM_BIN__|$(which nvim)|g" ~/user_defaults
    sudo mv ~/user_defaults /etc/sudoers.d/
    sudo chown root:root /etc/sudoers.d/user_defaults
  fi

  if _has-wsl; then
    # Date and time are not usually updated when WSL sleeps - this package
    # is needed to sync date and time
    sudo apt-get install -y ntpdate

    echo -e "\n\n\nRun command below to shutdown the entire WSL and not just this distribution."
    echo -e "\t\t***USE WITH CARE***"
    echo "  ${INITIAL_WSL_C_PATH}/WINDOWS/system32/wsl.exe --shutdown"
  fi

  echo -e "\n\n\n"
}

function install-complete-alias {
  curl -fLo "$HOME/complete_alias.sh" \
    https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias

  echo ". ${HOME}/complete_alias.sh" >>"${HOME}/.bash_completion"
}

function install-terraform-lsp {
  : "___help___ ___install-terraform-lsp-help"

  local _flavor
  local _print_version

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=version,help \
      --options=v,h \
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
      ___install-terraform-lsp-help
      return
      ;;

    --version | -v)
      _print_version=1
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

  # handle non-option arguments
  if [[ $# -ne 1 ]]; then
    echo "$0: Flavor is required."
    return
  fi

  _flavor="$1"

  if [[ $# -ne 1 ]]; then
    echo "$0: Flavor is required."
    return
  fi

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  # Official binary from hashicorp
  local _ls_version=0.32.3

  # This one works with COC-nvim
  local _lsp_version=0.0.12 # 2021-05-13

  local _flavor_description

  if [[ "${_flavor}" == 'lsp' ]]; then
    version="${_lsp_version}"
    _flavor_description='unofficial'
  else
    version="${_ls_version}"
    _flavor_description='official'
  fi

  if [[ -n "${_print_version}" ]]; then
    echo "Version of terraform ${_flavor} - $_flavor_description binary: ${version}"
    return
  fi

  cd "$PROJECT_0_PATH"

  local _binary="terraform-${_flavor}"

  if [[ "${_flavor}" == 'ls' ]]; then
    sudo apt-get install -y \
      unzip

    local _output="${_binary}_${version}_linux_amd64.zip"

    curl -fLO \
      "https://releases.hashicorp.com/${_binary}/0.32.3/${_output}"

    unzip "${_output}"
    chmod 755 "${_binary}"
    sudo mv "${_binary}" /usr/local/bin/
  else
    local _output="${_binary}_${version}_linux_amd64.tar.gz"

    curl -fLO \
      "https://github.com/juliosueiras/${_binary}/releases/download/v${version}/${_output}"

    tar xzf "${_output}"
    chmod 755 "${_binary}"
    sudo mv "${_binary}" /usr/local/bin/
  fi

  cd - >/dev/null

  # Usage with neovim:
  # https://github.com/hashicorp/terraform-ls/blob/main/docs/USAGE.md#vim--neovim
  # {
  #   "languageserver": {
  #     "terraform": {
  #       "command": "terraform-ls",
  #       "args": ["serve"],
  #       "filetypes": ["terraform", "tf"],
  #       "initializationOptions": {},
  #       "settings": {}
  #     }
  #   }
  # }
}

function ___install-terraform-lsp-help {
  read -r -d '' var <<'eof'
Install terraform language server protocol binary.
There are two flavors of the LSP:
    terraform-ls: the official binary.
    terraform-lsp: the older project.
For this reason, you must specify the flavor you wish to install.

Usage:
  pm install-terraform-lsp flavor [OPTIONS]

Options:
  --version/-v. Print version information and exit.
  --help/-h.    Print this help information and exit.
  --flavor/-f.  The flavor you wish to install. The possible values are:
                  ls - the official terraform binary from hashicorp -
                    does not work with COC-nvim
                  lsp - the unofficial binary that works with COC-nvim

Examples:
  pm install-terraform-lsp --help
  pm install-terraform-lsp --version
  pm install-terraform-lsp lsp
eof

  echo -e "${var}"
}

function ___install-terraform-help {
  : "___help___ ___install-terraform-help"
  read -r -d '' var <<'eof' || :
Install hashicorp terraform binary. Usage:
  pm install-terraform [OPTIONS]

Options:
  -h,--help
      Print this help information and exit.
  -v,--version
      Specify version to install. If user specifies no version, then we will install latest remote version.

Examples:
  # Get help
  install-terraform -h
  install-terraform --help

  # Install latest version.
  install-terraform

  # Install specified version.
  install-terraform -v 1.1.1
  install-terraform --version 1.1.1

eof

  echo -e "${var}"
}

function install-terraform {
  : "___install-terraform-help"

  local _version

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,version: \
      --options=h,v: \
      --name "$0" \
      -- "$@"
  )"; then
    ___install-terraform-help
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___install-terraform-help
      exit 0
      ;;

    --version | -v)
      _version=$2
      shift 2
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___install-terraform-help
      exit 1
      ;;
    esac
  done

  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  asdf plugin add \
    terraform \
    https://github.com/asdf-community/asdf-hashicorp.git &>/dev/null

  if [[ -z "$_version" ]]; then
    _version="$(
      asdf list all terraform |
        grep -P "^\d+\.\d+\.\d+$" |
        tail -1
    )"
  fi

  _echo "Installing terraform version $_version"
  asdf install terraform "$_version"

  _echo "Installing terraform auto completion"
  install-terraform-completion
}

install-terraform-completion() {
  set -eup

  local _completion_filename='terraform_bash_completion.sh'
  local _dotfile_completion_path="$DOTFILE_ROOT/$_completion_filename"

  if [ -f "$_dotfile_completion_path" ]; then
    _place_bash_completion -l \
      "$_dotfile_completion_path" \
      "$_completion_filename"

    return
  fi

  _place_bash_completion -c \
    "$(curl -fL "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/$_completion_filename")" \
    "$_completion_filename"
}

function install-chrome {
  _echo "Installing google chrome"

  curl --remote-name \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

  sudo dpkg -i google-chrome-stable_current_amd64.deb
  sudo apt -y -f install
}

function install-sqlite {
  local version=3.43.2

  _echo "Installing sqlite version: ${version}"

  sudo apt-get update

  sudo apt-get install -y \
    curl \
    build-essential \
    file

  asdf plugin add sqlite || true
  asdf install sqlite "${version}"
}

function install-mongo-db {
  : "Install Mongo DB Community edition"

  sudo apt-get install -y \
    gnupg \
    curl

  curl -fL \
    https://pgp.mongodb.com/server-7.0.asc |
    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
      --dearmor

  local _lsb
  _lsb="$(cat /etc/lsb-release)"

  # Create the /etc/apt/sources.list.d/mongodb-org-7.0.list file
  if [[ "${_lsb}" =~ DISTRIB_CODENAME=jammy ]]; then
    echo \
      "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" |
      sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  else
    echo \
      "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" |
      sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  fi

  sudo apt-get update

  # To install the latest stable version

  sudo apt-get install -y \
    mongodb-org

  # To prevent unintended upgrades, you can pin the package at the currently
  # installed version
  # echo "mongodb-org hold" | sudo dpkg --set-selections
  # echo "mongodb-org-database hold" | sudo dpkg --set-selections
  # echo "mongodb-org-server hold" | sudo dpkg --set-selections
  # echo "mongodb-mongosh hold" | sudo dpkg --set-selections
  # echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
  # echo "mongodb-org-tools hold" | sudo dpkg --set-selections
}

function install-mongosh {
  : "___alias___ install-mongo-db-shell"
  install-mongo-db-shell
}

function install-mongo-db-shell {
  : "Install Mongo DB Shell"

  local _version=2.0.2

  _echo "Installing Mongo DB Shell Version ${_version}"

  local _filename="mongodb-mongosh_${_version}_amd64.deb"

  curl -fLO \
    https://downloads.mongodb.com/compass/${_filename}

  sudo dpkg -i "${_filename}"
  rm -rf "${_filename}"
}

function install-mongo-db-atlas-cli {
  : "Install Mongo DB Atlas CLI"

  local _version=1.13.0

  _echo "Installing Mongo DB Atlas CLI version ${_version}"

  local _filename="mongodb-atlas-cli_${_version}_linux_x86_64.deb"

  curl -fLO \
    https://fastdl.mongodb.org/mongocli/${_filename}

  sudo dpkg -i "${_filename}"
  rm -rf "${_filename}"

  if command -v atlas &>/dev/null; then
    atlas completion bash |
      sudo tee "$BASH_COMPLETION_DIR/mongo-db-atlas"
  fi
}

function install-mongo-db-compass {
  : "Install Mongo DB Atlas CLI"

  local _version=1.40.4

  _echo "Installing Mongo DB Compass version ${_version}"

  local _filename="mongodb-compass_${_version}_amd64.deb"

  curl -fLO \
    https://downloads.mongodb.com/compass/${_filename}

  sudo dpkg -i "${_filename}"
  rm -rf "${_filename}"
}

function install-aws-cli {
  : "___help___ ___install-aws-cli-help"

  curl \
    -o "awscliv2.zip" \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

  unzip awscliv2.zip
  sudo ./aws/install

  local _completer_path
  _completer_path="$(which aws_completer)"

  if [[ -n "${_completer_path}" ]]; then
    complete -C "${_completer_path}" aws
  fi
}

function ___install-aws-cli-help {
  read -r -d '' var <<'eof'
Install aws cli including configuring auto completion for /bin/bash. Usage:
  pm install-aws-cli

Examples:
  pm install-aws-cli
eof

  echo -e "${var}"
}

function install-kind {
  cd "$PROJECT_0_PATH" || exit 1

  local _latest_version
  _latest_version="$(
    get_latest_github_release kubernetes-sigs/kind
  )"

  curl -Lfo ./kind \
    "https://github.com/kubernetes-sigs/kind/releases/download/$_latest_version/kind-linux-amd64"

  chmod 755 ./kind
  mv ./kind "$LOCAL_BIN"

  cd - &>/dev/null
}

function install-kubectl {
  cd "$PROJECT_0_PATH" || exit 1

  local latest_version
  latest_version="$(
    curl -L -s https://dl.k8s.io/release/stable.txt
  )"

  _echo "Downloading \"kubectl\" version \"$latest_version\" "

  curl -LfO \
    "https://dl.k8s.io/release/$latest_version/bin/linux/amd64/kubectl"

  _echo "kubectl downloaded, moving to local bin."

  chmod 755 kubectl
  mv kubectl "$LOCAL_BIN"

  _echo "Installing bash completion for kubectl"

  kubectl completion bash |
    sudo tee "$BASH_COMPLETION_DIR/kubectl" >/dev/null

  cd - &>/dev/null
}

function install-helm {
  cd "$PROJECT_0_PATH" || exit 1

  local _latest_version
  _latest_version="$(
    get_latest_github_release helm/helm
  )"

  _echo "Installing helm version \"$_latest_version\""

  local _dirname='linux-amd64'
  local _filename="helm-$_latest_version-$_dirname.tar.gz"

  rm -rf "$_filename"
  curl -fLO "https://get.helm.sh/$_filename"

  tar xvzf "$_filename"

  chmod +x "$_dirname/helm"
  mv "$_dirname/helm" "$LOCAL_BIN"

  rm -rf "$_dirname" "$_filename"

  _echo "Installing bash completion for helm"

  helm completion bash |
    sudo tee "$BASH_COMPLETION_DIR/helm.sh" >/dev/null

  cd - &>/dev/null
}

function install_shfmt {
  set -o errexit

  : "Shfmt is the code formatter binary for bash/sh"

  local shfmt_version

  shfmt_version="$(
    get_latest_github_release mvdan/sh
  )"

  _echo "Installing shfmt version \"$shfmt_version\""

  mkdir -p "${LOCAL_BIN}"

  rm -rf "$HOME/.local/bin/shfmt"

  local os
  local _archi

  os="$(uname -s)"
  os="${os,,}"

  _archi="amd64"

  if _is_arm_hardware; then
    _archi="arm64"
  fi

  local _url="https://github.com/mvdan/sh/releases/download/${shfmt_version}/shfmt_${shfmt_version}_${os}_${_archi}"

  curl -fLo \
    "$HOME/.local/bin/shfmt" \
    --create-dirs \
    "$_url"

  chmod u+x "$HOME/.local/bin/shfmt"
}

function ___get_latest_github_release-help {
  read -r -d '' var <<'eof'
Get the latest release from github. Usage:
  _pm get_latest_github_release user/repo [OPTIONS]

Options:
  --help/-h
    Print this help text and quit.

Available user/repo (the indented identifiers are the repos):
  kubernetes-sigs
    kind
  helm
    helm
  kubernetes
    kubernetes
  neovim
    neovim
  mvdan
    sh               -> shfmt
  tmux
    tmux
  vifm
    vifm
  sharkdp
    bat             -> bat syntax highlighting

Examples:
  # Get help.
  _pm get_latest_github_release --help

  # Get latest for user/repo.
  _pm get_latest_github_release kubernetes-sigs/kind
eof

  echo -e "${var}\n"
}

function get_latest_github_release {
  : "___help___ ___get_latest_github_release-help"

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help \
      --options=h \
      --name "$0" \
      -- "$@"
  )"; then
    ___get_latest_github_release-help
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___get_latest_github_release-help
      return
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___get_latest_github_release-help
      return
      ;;
    esac
  done

  # handle non-option arguments
  if [[ $# -ne 1 ]]; then
    echo "$0: Non optional user/repo is required."
    return
  fi

  local _user_repo=$1
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  curl --silent "https://api.github.com/repos/$_user_repo/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                                     # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                             # Pluck JSON value
}

function ___update_latest_global_version-help {
  read -r -d '' var <<'eof'
Update a binary's global version. Usage:
  _pm update_latest_global_version [OPTIONS]
  _pm update_latest_global_version version_identifier version

Options:
  --help/-h
    Print this help text and quit.

Available version identifiers:
  ELIXIR_VERSION
  ERLANG_VERSION
  PYTHON_VERSION
  RUST_VERSION

Examples:
  # Get help.
  _pm update_latest_global_version --help

  # Specify version identifier to upgrade.
  _pm update_latest_global_version ELIXIR_VERSION 1.15.7-otp-26
  _pm update_latest_global_version ERLANG_VERSION 26.1.2
eof

  echo -e "${var}\n"
}

function update_latest_global_version {
  : "___help___ ___update_latest_global_version-help"

  local _this_file="$0"

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,version: \
      --options=h,v: \
      --name "$0" \
      -- "$@"
  )"; then
    ___update_latest_global_version-help
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___update_latest_global_version-help
      return
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___update_latest_global_version-help
      return
      ;;
    esac
  done

  # handle non-option arguments
  if [[ $# -ne 2 ]]; then
    echo "$0: Non optional argument version identifier and version are required."
    ___update_latest_global_version-help
    return
  fi

  local _version_identifier=$1
  local _user_version=$2
  # --------------------------------------------------------------------------
  # END PARSE ARGUMENTS
  # --------------------------------------------------------------------------

  sed -E -i \
    "s|(${_version_identifier}=\")(.+)(\")|\1${_user_version}\3|" \
    "$_this_file"
}

darwin_bash_profile() {
  local _profile_path="$HOME/.bash_profile"

  # shellcheck disable=SC2016
  if ! _is_darwin ||
    ! [[ -s "$_profile_path" ]] ||
    grep -qP 'PATH="\$_joined_paths\$PATH"' "$_profile_path"; then
    return
  fi

  local _temp_profile_path="$PROJECT_0_PATH/.bash_profile"

  # shellcheck disable=SC2064
  trap "rm -rf $_temp_profile_path" EXIT

  cat "$_profile_path" >"$_temp_profile_path"

  cat <<'EOF' >"$_profile_path"
######################################################################
# Prepend the GNU binaries to the path
_paths=(
  '/opt/homebrew/opt/gnu-tar/libexec/gnubin'
  '/opt/homebrew/opt/make/libexec/gnubin'
  '/opt/homebrew/opt/gnu-sed/libexec/gnubin'
  '/opt/homebrew/opt/gawk/libexec/gnubin'
  '/opt/homebrew/opt/grep/libexec/gnubin'
  '/opt/homebrew/opt/gnu-getopt/bin'
  '/opt/homebrew/opt/unzip/bin'
  '/opt/homebrew/opt/m4/bin'
  '/opt/homebrew/opt/icu4c/bin'
  '/opt/homebrew/opt/icu4c/sbin'
  '/opt/homebrew/opt/mysql-client/bin'
  "$HOME/.local/bin"
  "$HOME/dotfiles/scripts"
)

_joined_paths=''

for __path in "${_paths[@]}"; do
  _joined_paths="$__path:$_joined_paths"
done

# Remove our custom paths if already exists.
PATH="${PATH//$_joined_paths/''}"
PATH="$_joined_paths$PATH"

pkgs_=(
  zlib
  icu4c
  mysql-client
)
ldflags_=
cppflags_=
pkg_config_paths_=

for pkg_ in "${pkgs_[@]}"; do
  ldflag_="-L/opt/homebrew/opt/$pkg_/lib"

  if ! grep -qE -- "${ldflag_}" <<<"${LDFLAGS}"; then
    ldflags_+=" $ldflag_"
    cppflags_+=" -I/opt/homebrew/opt/$pkg_/include"
    pkg_config_paths_+="/opt/homebrew/opt/$pkg_/lib/pkgconfig:"
  fi
done

export LDFLAGS="$LDFLAGS $ldflags_"
export CPPFLAGS="$CPPFLAGS $cppflags_"
export PKG_CONFIG_PATH="${pkg_config_paths_}${PKG_CONFIG_PATH}"

unset _paths
unset __path
unset _joined_paths
unset pkgs_
unset pkg_
unset ldflags_
unset cppflags_
unset pkg_config_paths_
######################################################################

EOF

  cat "$_temp_profile_path" >>"$_profile_path"
}

___setup_multipass_help() {
  read -r -d '' var <<'eof'
Setup ubuntu multipass. Usage:
  _pm setup_multipass [OPTIONS] <mounted_host_home_path>

<mounted_host_home_path> is the path on the multipass instance where we have mounted host user's $HOME directory like
so:

```sh
multipass mount $HOME instance_name:/mounted_host_home_path
```

Options:
  --help/-h
    Print this help text and quit.

Examples:
  # Get help.
  _pm setup_multipass --help

  # Setup multipass.
  _pm setup_multipass /home/kanmii
eof

  echo -e "${var}\n"
}

setup_multipass() {
  : "___help___ ___setup_multipass_help"

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,dry,timeout: \
      --options=h,d,t: \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
    --help | -h)
      ___setup_multipass_help
      return
      ;;

    --)
      shift
      break
      ;;

    *)
      Echo "Unknown option ${1}."
      ___setup_multipass_help
      return
      ;;
    esac
  done

  # This condition will be met if this is the first time we are setting up this machine.
  if [[ ! -d "$HOME/.local/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.vifm"
    touch "$HOME/.hushlogin"

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get upgrade -y

    _echo "We need to reboot for OS upgrade to be completed."

    sudo reboot now
  fi

  # handle non-option arguments
  if [[ $# -ne 1 ]]; then
    echo "$0: Non optional argument \"mounted_host_home_path\" is required."
    ___setup_multipass_help
    return
  fi

  local _mounted_home_path=$1
  local _dotfiles_path="$_mounted_home_path/dotfiles"

  # Ensure dotfiles path has been properly mounted from host before continueing.
  if [[ ! -d "$_dotfiles_path" ]]; then
    echo "Path \"$_dotfiles_path\" is not a valid directory. Exiting!"
    return
  fi

  sudo apt-get install -y \
    curl \
    g++ \
    ca-certificates \
    gnupg \
    build-essential \
    make \
    libevent-dev \
    ncurses-dev \
    libncursesw5-dev \
    libssh-dev \
    lsb-release \
    bison

  install-complete-alias

  ######### Update .bashrc
  cat <<EOF >>"$HOME/.bashrc"

if [[ -d "$_dotfiles_path" ]]; then
  source "$_dotfiles_path/_shell-script"
fi
EOF

  ####### Update .profile
  cat <<EOF >>"$HOME/.profile"

if [[ -d "$_dotfiles_path" ]]; then
  export PATH="$_dotfiles_path/scripts:\$PATH"
fi
EOF

  install_neovim
  ln -s "$_dotfiles_path/.config/nvim" "$HOME/.config"
  ln -s "$_dotfiles_path/gitconfig" "$HOME/.gitconfig"
  ln -s "$_dotfiles_path/gitignore" "$HOME/.gitignore"

  install_vifm
  rm -rf "$HOME/.vifm/vifmrc"
  ln -s "$_dotfiles_path/.config/vifm/vifmrc" "$HOME/.vifm"

  install-elixir
  elixir-post-install
  ln -s "$_dotfiles_path/.iex.exs" "$HOME"

  install_tmux
  ln -s "$_dotfiles_path/.tmux.conf" "$HOME"

  install-python --global
  install-nodejs dev
  install-asdf-postgres 1 || true
}

_confirm_git_lfs_installed_successfully() {
  if git lfs install | grep -qP 'Git LFS initialized' &>/dev/null; then
    echo "Git Large File Storage installed successfully"
    return 0
  fi

  echo "Git Large File Storage could not be installed." >&2
  return 1
}

install_git_lfs() {
  : "Install Git Large File Storage"

  set -o errexit

  if _is_darwin; then
    brew install git-lfs
    _confirm_git_lfs_installed_successfully
    return
  fi

  local _version=v3.5.1
  local _project_name='git-lfs'
  local _filename="${_project_name}-linux-amd64-$_version.tar.gz"
  local _extracted_folder_name="${_project_name}-${_version#v}"

  local _download_url="https://github.com/git-lfs/git-lfs/releases/download/$_version/$_filename"

  (
    cd "$PROJECT_0_PATH" || exit 1

    curl -fLO "$_download_url"
    tar xf "$_filename"

    _echo "Entering $_extracted_folder_name"
    cd "$_extracted_folder_name" || exit 1

    _echo "Executing ./install.sh >/dev/null"
    sudo ./install.sh >/dev/null

    cd - &>/dev/null

    _echo "Cleaning up by removing $_extracted_folder_name and $_filename ."
    rm -rf "$_extracted_folder_name" "$_filename"
  )

  _confirm_git_lfs_installed_successfully
}

_bash_completion_dir() {
  if _is_linux; then
    echo -n "$BASH_COMPLETION_DIR"
  elif _is_darwin; then
    echo -n "$(brew --prefix)/etc/bash_completion.d"
  fi
}

_place_bash_completion() {
  local f="${FUNCNAME[0]}"
  local o
  local u
  read -r -d '' u <<eom || :
Usage:
  $f -c <DATA> <COMPLETION_FILENAME>
  $f -l <SRC> <COMPLETION_FILENAME>

Options:
  -l  link SRC to COMPLETION_FILENAME
  -c  Create COMPLETION_FILENAME and write DATA into it.
eom

  local _link=
  local _create=

  while getopts "lc" o; do
    case "$o" in
    l)
      _link=1
      shift
      ;;

    c)
      _create=1
      shift
      ;;

    *)
      echo -e "$u"
      exit 1
      ;;
    esac
  done

  local _src_or_data="$1"
  local _completion_filename="$2"

  local _completion_destination_fullpath
  _completion_destination_fullpath="$(_bash_completion_dir)/$_completion_filename"

  if [ -s "$_completion_destination_fullpath" ]; then
    _echo "Completion exists already, returning!\n$_completion_destination_fullpath"
    return
  fi

  local _action=

  if _is_linux; then
    if [ -n "$_create" ]; then
      echo -e "$_src_or_data" | sudo tee "$_completion_destination_fullpath" >/dev/null

      _action='created'
    else
      sudo ln -s "$_src_or_data" "$_completion_destination_fullpath"
      _action='linked'
    fi
  elif _is_darwin; then
    if [ -n "$_create" ]; then
      echo -e "$_src_or_data" >"$_completion_destination_fullpath"
      _action='created'
    else
      ln -s "$_src_or_data" "$_completion_destination_fullpath"
      _action='linked'
    fi
  fi

  if [ -s "$_completion_destination_fullpath" ]; then
    _echo "Completion $_action successfully!\n$_completion_destination_fullpath"
  fi
}

install-docker-hadolint() {
  : "Install hadolint dockerfile linter"

  set -eu

  local archi_=''

  if _is_darwin; then
    _echo "Installing hadolint via homebrew."
    brew install hadolint
    return
  fi

  if _is_arm_hardware; then
    archi_="Linux-arm64"
  else
    archi_="Linux-x86_64"
  fi

  local url_="https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-$archi_"
  _echo "Will download URL: $url_"

  local file_="$HOME/projects/0/hadolint"

  _echo "Removing previous download of $file_"
  rm -rf "$file_"

  _echo "Downloading..."
  curl --create-dirs -sfLo "$file_" "$url_"

  _echo "Making downloaded file into executable"
  chmod 755 "$file_"

  local bin_path_="$HOME/.local/bin/hadolint"

  _echo "Removing previously installed version from $bin_path_"
  rm -rf "$bin_path_"

  _echo "Moving to bin directory"
  mv "$file_" "$bin_path_"
}

install-draw-on-your-screen() {
  local extensions_path_="$HOME/.local/share/gnome-shell/extensions"
  local download_basename_="draw-on-your-screen2@zhrexl.github.com"
  local download_full_path_="$extensions_path_/$download_basename_"

  _echo "Cloning to $download_full_path_"
  git clone \
    https://github.com/zhrexl/DrawOnYourScreen2.git \
    "$download_full_path_"

  _echo "Saving gsettings"
  sudo cp "$download_full_path_/schemas/org.gnome.shell.extensions.draw-on-your-screen.gschema.xml" \
    /usr/share/glib-2.0/schemas/

  sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
}

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

install-inotify-info() {
  : "___alias___ install_inotify_info"
  install_inotify_info
}

install_inotify_info() {
  : "Install inotify-info for trouble shooting inotify issues"

  local here_="$PWD"
  cd "$PROJECT_0_PATH"
  rm -rf "inotify-info"
  git clone \
    https://github.com/mikesart/inotify-info
  cd inotify-info
  run_as_root make
  run_as_root make install
  cd - &>/dev/null
  run_as_root rm -rf inotify-info
  cd "$here_"
}

# -----------------------------------------------------------------------------
# GLOBAL HELP FUNCTION
# -----------------------------------------------------------------------------

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
  local command_to_test_="$1"
  local this_file_content_=""
  this_file_content_="$(cat "$0")"

  local all_function_names_=()
  mapfile -t all_function_names_ < <(
    compgen -A function
  )

  local func_name_=""
  for func_name_ in "${all_function_names_[@]}"; do
    if ! _is_local_function "$func_name_" "$this_file_content_"; then
      continue
    fi

    if [[ "$func_name_" == "$command_to_test_" ]]; then
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
  local function_type_="external"
  local include_prefix_=""

  local opt_=""
  while getopts ':aip' opt_; do
    case "$opt_" in
    a)
      function_type_='all'
      ;;

    i)
      function_type_='internal'
      ;;

    p)
      include_prefix_=1
      ;;

    *)
      ___help_help
      exit 1
      ;;
    esac
  done
  shift $((OPTIND - 1))

  # Matching pattern examples:
  # `: "___help___ ___some_func_help"`
  # `: "___help___ ____some-func-help"`
  local _help_func_pattern="[_]*___[a-zA-Z][a-zA-Z0-9_-]*[_-]help"

  local function_names_=()

  if [ "$function_type_" = external ]; then
    # External functions do not start with _.
    mapfile -t function_names_ < <(
      compgen -A function |
        grep -v '^_'
    )
  elif [ "$function_type_" = internal ]; then
    # Internal helper functions start with _, but not __
    mapfile -t function_names_ < <(
      compgen -A function |
        grep '^_' |
        grep -v '^__' |
        grep -v -E "$_help_func_pattern"
    )
  elif [ "$function_type_" = all ]; then
    mapfile -t function_names_ < <(
      compgen -A function |
        grep -v '^__' |
        grep -v -E "$_help_func_pattern"
    )
  fi

  local this_file_content_=""
  this_file_content_="$(cat "$0")"

  local longest_func_name_len_=0
  local func_name_len_=0
  declare -A name_to_len_map_=()

  local func_name_=""
  for func_name_ in "${function_names_[@]}"; do
    func_name_len_="${#func_name_}"
    name_to_len_map_["$func_name_"]="${func_name_len_}"
    if [[ "${func_name_len_}" -gt "${longest_func_name_len_}" ]]; then
      longest_func_name_len_=${func_name_len_}
    fi
  done

  declare -A all_output_=()
  declare -A _aliases=()
  declare -A name_spaces_map_=()

  longest_func_name_len_=$((longest_func_name_len_ + 10))

  local output_prefix_=""

  for func_name_ in "${function_names_[@]}"; do
    if ! _is_local_function "$func_name_" "$this_file_content_"; then
      continue
    fi

    local spaces_=""
    func_name_len_="${name_to_len_map_[$func_name_]}"
    func_name_len_=$((longest_func_name_len_ - func_name_len_))

    for _ in $(seq "${func_name_len_}"); do
      spaces_+="-"
    done

    local function_def_text_=""
    function_def_text_="$(type "${func_name_}")"

    local alias_name_=""

    # Matching pattern example:
    # `: "___alias___ install-elixir"`
    alias_name_="$(
      sed -n \
        's/^ *: *"___alias___ *\([a-zA-Z_-][a-zA-Z0-9_-]*\).*/\1/p' \
        <<<"${function_def_text_}"
    )"

    if [[ -n "${alias_name_}" ]]; then
      _aliases["${alias_name_}"]="${_aliases["${alias_name_}"]} ${func_name_}"
      continue
    fi

    local help_func_=""
    help_func_="$(
      # Given:
      # `: "___help___ ___some_func_help"`
      # Then we extract "___some_func_help" into variable help_func_
      sed -nE \
        "s/^[[:space:]]+:[[:space:]]*\"___help___[[:space:]]+([a-zA-Z0-9_-]*).*/\1/p" \
        <<<"${function_def_text_}"
    )"

    # Get the whole function definition text and extract only the documentation
    # part.
    local doc_lines_=()
    if [[ -n "$help_func_" ]]; then
      # So we have a helper function - we just eval the helper function and split by new lines.
      mapfile -t doc_lines_ < <(
        eval "$help_func_" 2>/dev/null
      )
    else
      # Function is not using a helper function but documentation texts - so we extract the documentation texts and
      # split by new lines.
      mapfile -t doc_lines_ < <(
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
        sed -nEe "s/^[[:space:]]*: ?\"(.*)\";/\1/p" <<<"$function_def_text_"
      )
    fi

    local output_=""
    output_prefix_="$func_name_ $spaces_ "

    if [[ -n "${doc_lines_[*]}" ]]; then
      if [ -z "$include_prefix_" ]; then
        output_+="${output_prefix_}\n"
        output_prefix_=""
      fi

      for _doc in "${doc_lines_[@]}"; do
        # _func_name -------------------- List tmux sessions and clients. Usage:
        output_+="${output_prefix_}$_doc\n"
      done
    else
      # _func_name -------------------- *************
      output_="${output_prefix_}*************\n"
    fi

    all_output_["$func_name_"]="$output_"
    name_spaces_map_["$func_name_"]="$output_prefix_"
  done

  for func_name_ in "${!all_output_[@]}"; do
    output_="${all_output_["$func_name_"]}"
    echo -e "$output_"

    local alias_names_="${_aliases["$func_name_"]}"

    if [[ -n "${alias_names_}" ]]; then
      echo -e "${name_spaces_map_["$func_name_"]} ALIASES: ${alias_names_}\n\n"
    fi
  done
}

if [ -z "$1" ]; then
  # default_command "$@"
  help "$@"
elif [[ "$1" == "help" ]]; then
  help "${@:2}"
elif [[ "$1" == -h* || "$1" == -i* || "$1" == -a* || "$1" == -p* ]]; then
  help "$@"
elif _command_exists "$1"; then
  "$@"
else
  echo "Command not found \"$1\". Type \"help -a\" for available commands." >&2
  exit 127
fi
