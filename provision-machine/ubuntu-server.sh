#!/bin/bash
# shellcheck disable=1090,2009,2046,2143,2164,2103,2230,1091

set -o pipefail

INITIAL_WSL_C_PATH=/mnt/c

ERLANG_VERSION=26.1.2
ELIXIR_VERSION=1.15.7-otp-26
BASH_APPEND_PATH="${HOME}/__bash-append.sh"
LOCAL_BIN_PATH="$HOME/.local/bin"
DOTFILE_GIT_DOWNLOAD_URL_PREFIX='https://raw.githubusercontent.com/humpangle/dotfiles/master'
PYTHON_VERSION=3.10.8
RUST_VERSION=1.65.0

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

# Shellcheck check bash/shell files for syntax/style errors
NEOVIM_DEPS=(
  'xclip'
  'shellcheck'
  'ssh-askpass-gnome'
  'ssh-askpass'
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

DOCKER_DEPS=(
  'ca-certificates'
  'curl'
  'gnupg'
  'lsb-release'
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

  echo -e "\n${text}  ${line}${line}"
}

function _asdf-bin-path {
  realpath "$HOME/.asdf/bin/asdf" 2>/dev/null
}

function _write-local-bin-path-to-paths {
  if ! grep -q "PATH=.*${LOCAL_BIN_PATH}" "$HOME/.bashrc"; then
    echo "export PATH=${LOCAL_BIN_PATH}:\$PATH" >>"$HOME/.bashrc"
  fi
}

function _wsl-setup {
  curl -fLO \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/etc/wsl.conf"

  sudo mv wsl.conf /etc/wsl.conf
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

  sudo cp ~/dotfiles/etc/wsl.conf /etc/wsl.conf

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
  sudo apt-get update
  sudo apt-get upgrade -y

  if ! _is-dev "$@"; then
    sudo apt-get install -y \
      git \
      curl
  else
    deps="${LUA_DEPS[*]} \
      ${RUST_DEPS[*]} \
      ${TMUX_DEPS[*]} \
      ${NEOVIM_DEPS[*]} \
      ${NODEJS_DEPS[*]} \
      ${PYTHON_DEPS[*]} \
      ${GOLANG_DEPS[*]} \
      ${DOCKER_DEPS[*]} "

    local cmd="sudo apt-get install -y ${deps}"
    eval "$cmd"
  fi

  sudo apt-get autoremove -y
}

function _may_be_install_asdf {
  if [[ ! -e "$(_asdf-bin-path)" ]]; then
    install-asdf "$@"
  fi
}

function _is-dev {
  [[ "${*}" =~ dev ]] && true
}

function _install-deps {
  sudo apt-get update

  local cmd="sudo apt-get install -y $1"
  eval "$cmd"
}

function _extract-version {
  awk -v word="${1}" 'match($0, word "\\s+([.a-zA-Z0-9_-]+)", a) {print a[1]}' "${2}"
}

function _tool-versions-backup {
  local _create
  local _remove
  local _doc
  local _tools

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=create,remove,doc:,tools: \
      --options=c,r,d:,t: \
      --name "$0" \
      -- "$@"
  )"; then
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
      --create | -c)
        _create=1
        shift
        ;;

      --remove | -r)
        _remove=1
        shift
        ;;

      --doc | -d)
        _doc="${2}"
        shift 2
        ;;

      --tools | -t)
        _tools="${2}"
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

  # If caller did not provide a documentation string, use the tools as
  # documentation string
  if [[ -z "${_doc}" ]]; then
    _doc="${_tools}"
  fi

  if [[ -n "${_remove}" ]]; then
    if [[ -n "${_tools}" ]]; then
      IFS=, read -r -a _tools_array <<<"${_tools}"

      for _el in "${_tools_array[@]}"; do
        "$(_asdf-bin-path)" reshim "${_el}"
      done
    fi

    _echo "Removing temporary local .tool-versions created for ${_doc}"
    rm -rf ./.tool-versions

    if [[ -e ./.tool-versions-bak ]]; then
      _echo "Rename local .tool-versions-bak to .tool-versions"
      mv ./.tool-versions-bak ./.tool-versions
    fi

    return
  fi

  _echo "Creating temporary local .tool-versions for ${_doc}"

  if [[ -e ./.tool-versions ]]; then
    _echo "Rename local .tool-versions to .tool-versions-bak"
    mv ./.tool-versions ./.tool-versions-bak
  fi
}

# -----------------------------------------------------------------------------
# END HELPER FUNCTIONS
# -----------------------------------------------------------------------------

function install-golang {
  : "Install golang"

  _may_be_install_asdf "$@"

  _echo "INSTALLING GOLANG"

  local version=1.21.5

  if ! _is-dev "$@"; then
    _install-deps "${GOLANG_DEPS[*]}"
  fi

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add golang

  "$(_asdf-bin-path)" install golang $version
  "$(_asdf-bin-path)" global golang $version

  local go_bin_path
  go_bin_path="$(_asdf-plugin-install-root golang "$version")/go/bin/go"

  # Github repo archived
  "${go_bin_path}" install github.com/lighttiger2505/sqls@latest
  "$(_asdf-bin-path)" reshim golang
}

function install-rust {
  : "Install rust"

  _may_be_install_asdf "$@"

  _echo "INSTALLING RUST"

  if ! _is-dev "$@"; then
    _install-deps "${RUST_DEPS[*]}"
  fi

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add rust
  "$(_asdf-bin-path)" install rust $RUST_VERSION
  "$(_asdf-bin-path)" global rust $RUST_VERSION

  local rust_install_root
  rust_install_root="$(_asdf-plugin-install-root rust "$RUST_VERSION")"

  # shellcheck source=/dev/null
  source "${rust_install_root}/env"

  "$(_asdf-bin-path)" reshim rust

  # Install and set as default latest release of cargo
  rustup default stable

  "$(_asdf-bin-path)" reshim rust

  local cargo_bin_path="${rust_install_root}/bin/cargo"

  # Install the lua formatter - stylua
  "${cargo_bin_path}" install stylua --features lua52
  "$(_asdf-bin-path)" reshim rust

  local cargo_bin_dir="${HOME}/.cargo/bin"

  if [[ -d "${cargo_bin_dir}" ]]; then
    echo "export PATH=${cargo_bin_dir}:\$PATH" >>"${HOME}/.bashrc"
  fi
}

function install-docker {
  : "Install docker"

  _echo "INSTALLING DOCKER"

  # https://docs.docker.com/engine/install/ubuntu/

  if ! _is-dev "$@"; then
    _install-deps "${DOCKER_DEPS[*]}"
  fi

  if _has-wsl; then
    sudo mkdir -p /etc/docker
    echo '{ "dns": ["1.1.1.1", "10.0.0.2", "8.8.8.8"] }' | sudo tee -a /etc/docker/daemon.json
  fi

  sudo mkdir -p /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt-get update

  sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

  sudo usermod -aG docker "${USER}" || true
  # newgrp docker
}

function install-asdf-postgres {
  : "Install postgres with asdf"

  _may_be_install_asdf "$@"

  local version=15.2

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

  "$(_asdf-bin-path)" plugin add postgres
  "$(_asdf-bin-path)" install postgres "$version"
  "$(_asdf-bin-path)" global postgres "$version"
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

function install-tmux {
  : "Install tmux"

  tmux_version='3.3a'

  _echo "TMUX ${tmux_version}"

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

  curl -LO https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz
  tar xf tmux-${tmux_version}.tar.gz
  rm -f tmux-${tmux_version}.tar.gz
  cd tmux-${tmux_version}
  ./configure
  make
  sudo make install
  cd -
  sudo rm -rf /usr/local/src/tmux-\*
  sudo mv tmux-${tmux_version} /usr/local/src

  local install_path="$HOME/.tmux/plugins/tpm"

  if [ ! -d "$install_path" ]; then
    git clone https://github.com/tmux-plugins/tpm "$install_path"
  else
    cd "$install_path"
    git pull origin master
    cd -
  fi

  if ! _is-dev "$@"; then
    _echo "DOWNLOADING TMUX CONF"

    curl -fLo ~/.tmux.conf \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/tmux.conf"
  fi

  mkdir -p "$HOME/.tmux/resurrect"
}

function install-neovim {
  : "Install neovim"

  neovim_version=v0.9.2
  RIP_GREP_VERSION=13.0.0
  # `bat` is for syntax highlighting inside `fzf`
  BAT_VERSION=0.23.0

  _echo "INSTALLING NEOVIM VERSION ${neovim_version}"

  if ! _is-dev "$@"; then
    _install-deps "${NEOVIM_DEPS[*]}"
  fi

  if [[ ! $(dpkg -l | grep -q fuse2) ]]; then
    sudo apt-get install -y \
      fuse \
      libfuse2
  fi

  curl -fLo nvim https://github.com/neovim/neovim/releases/download/$neovim_version/nvim.appimage &&
    sudo chown root:root nvim &&
    sudo chmod +x nvim &&
    sudo mv nvim /usr/bin

  if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
  fi

  rm -rf ripgrep_${RIP_GREP_VERSION}_amd64.deb
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RIP_GREP_VERSION}/ripgrep_${RIP_GREP_VERSION}_amd64.deb
  # shellcheck disable=SC1001
  sudo dpkg -i ripgrep*${RIP_GREP_VERSION}\_amd64.deb
  # shellcheck disable=SC1001
  rm ripgrep*${RIP_GREP_VERSION}\_amd64.deb

  bat_deb="bat_${BAT_VERSION}_amd64.deb"
  rm -rf $bat_deb
  curl -LO "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${bat_deb}"
  sudo dpkg -i "${bat_deb}"
  rm "${bat_deb}"

  local shfmt_version=v3.5.1

  rm -rf "$HOME/.local/bin/shfmt"
  curl -Lo \
    "$HOME/.local/bin/shfmt" \
    --create-dirs \
    "https://github.com/mvdan/sh/releases/download/${shfmt_version}/shfmt_${shfmt_version}_linux_amd64"

  chmod ugo+x "$HOME/.local/bin/shfmt"

  if _is-dev "$@"; then
    local packer_install_dir=~/.local/share/nvim/site/pack/packer/start
    rm -rf $packer_install_dir

    git clone --depth 1 \
      https://github.com/wbthomason/packer.nvim \
      "${packer_install_dir}/packer.nvim"

    nvim \
      --headless \
      -c 'autocmd User PackerComplete quitall' \
      -c 'PackerSync' 2>/dev/null

    _echo "WE'LL BE USING DOTFILES FOR NEOVIM CONFIG. RETURNING."
    return
  fi

  # shellcheck disable=2016
  printf 'export DISPLAY="$(%s):0"' "ip route | awk '/default/ {print \$3}'"

  # mkdir -p ~/.config/nvim

  curl -fLo ~/.config/nvim/init.vim \
    --create-dirs \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/.config/nvim/settings-min.vim"

  local _shared_path=~/.local/share/nvim

  # Each line is `owner plugin_name config_file`
  local plugins=(
    'szw vim-maximizer vim-maximizer.vim'
    'tpope vim-obsession'
    'tpope vim-unimpaired'
    'tpope vim-fugitive fugitive.vim'
    'tpope vim-surround'
    'sbdchd neoformat neoformat.lua'
    'jpalardy vim-slime vim-slime.lua'
    'junegunn fzf'
    'junegunn fzf.vim fzf.vim'
    'stsewd fzf-checkout.vim'
    'dhruvasagar vim-prosession'
    'tomtom tcomment_vim'
    'nelstrom vim-visual-star-search'
    'voldikss vim-floaterm floaterm.lua'
    'voldikss fzf-floaterm'
    'airblade vim-gitgutter'
    'itchyny lightline.vim lightline.vim'
    'easymotion vim-easymotion vim-easymotion.vim'
    'elixir-editors vim-elixir'
    'rakr vim-one vim-one.vim'
  )

  for _entry in "${plugins[@]}"; do
    read -r -d '' -a _value <<<"${_entry}"

    local plugin_owner="${_value[0]}"
    local plugin_path="${_value[1]}"
    local _plugin_file="${_value[2]}"

    local _path_prefix="${_shared_path}/site/pack/$plugin_path/start"
    local full_install_path="${_path_prefix}/$plugin_path"

    if [[ ! -d "$full_install_path" ]]; then
      mkdir -p "${_path_prefix}"
      echo "Installing neovim plugin ${plugin_owner}/${plugin_path}"

      git clone \
        "https://github.com/${plugin_owner}/${plugin_path}" \
        "$full_install_path"
    else
      cd "$full_install_path"
      git pull origin master
      cd -
    fi

    if [[ -z "${_plugin_file}" ]]; then
      continue
    fi

    local _plugin_config_path_prefix=.config/nvim/lua/plugins

    if [[ "${_plugin_file}" =~ .vim ]]; then
      _plugin_config_path_prefix=.config/nvim/plugins
    fi

    local _plugin_config_abs_path="${HOME}/${_plugin_config_path_prefix}/${_plugin_file}"
    rm -rf "${_plugin_config_abs_path}"

    local url="$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/${_plugin_config_path_prefix}/${_plugin_file}"

    echo "Downloading neovim plugin config"
    echo "  from         ${url}"
    echo "  into file    ${_plugin_config_abs_path}"
    echo

    curl --create-dirs -fLo "${_plugin_config_abs_path}" "${url}"
    # curl -fL "${_plugin_config_abs_path}" "${url}"
  done

  rm -rf "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/.config/nvim/lua/util.lua"
  curl -fLo ~/.config/nvim/lua/util.lua \
    --create-dirs \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/.config/nvim/lua/util.lua"
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

  mkdir -p "${LOCAL_BIN_PATH}"

  _write-local-bin-path-to-paths

  declare -a local_bin_scripts=(p-env ebnis-save-tmux.sh)

  for _script in "${local_bin_scripts[@]}"; do
    local _script_output_path="${LOCAL_BIN_PATH}/${_script}"

    curl -fLo "${_script_output_path}" \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/scripts/${_script}"

    chmod u+x "${_script_output_path}"
  done

  curl -fLo "${BASH_APPEND_PATH}" \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/regular_shell.sh"

  echo "[ -f ${BASH_APPEND_PATH} ] && source ${BASH_APPEND_PATH}" >>"$HOME/.bashrc"
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"

  install-complete-alias

  mkdir -p ~/.ssh
}

function install-vifm {
  : "Install VIFM"

  local version='0.12.1'

  _echo "INSTALLING VIFM VERSION ${version}"

  if ! _is-dev "$@"; then
    sudo apt-get update
  fi

  rm -rf ~/.config/vifm
  mkdir -p ~/.config/vifm
  curl -LO https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2
  tar xf vifm-${version}.tar.bz2
  rm -f vifm-${version}.tar.bz2
  cd vifm-${version} || exit
  ./configure
  make
  sudo make install
  cd - || exit
  sudo rm -rf /usr/local/src/vifm-*
  sudo mv vifm-${version} /usr/local/src

  if ! _is-dev "$@"; then
    _echo "DOWNLOADING VIFM CONF"

    curl -fLo ~/.config/vifm/vifmrc \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/.config/vifm/vifmrc"
  fi
}

function install-git {
  : "Install Git"

  curl -fLo ~/.gitconfig \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/gitconfig"

  curl -fLo ~/.gitignore \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/gitignore"
}

function install-asdf {
  : "Install asdf"

  local version=v0.13.1

  _echo "INSTALLING ASDF"

  if ! _is-dev "$@"; then
    _update-and-upgrade-os-packages
  fi

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $version
}

function install-erlang {
  : "Install erlang"

  _may_be_install_asdf

  local version

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=erlang:,elixir: \
      --options=e:,x: \
      --name "$0" \
      -- "$@"
  )"; then
    exit 1
  fi

  # Provides proper quoting
  eval set -- "$parsed"

  while true; do
    case "$1" in
      --erlang | -e)
        version="$2"
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

  if [[ -z "${version}" ]] ||
    [[ "${version}" == "latest" ]]; then
    version="${ERLANG_VERSION}"
  fi

  if asdf list erlang | grep -q "${version}"; then
    _echo "Erlang version ${version} already installed. Exiting!"
    return
  fi

  _echo "INSTALLING ERLANG version: ${version}"

  _install-deps "${ERLANG_DEPS[*]}"

  sudo apt-get autoremove -y

  export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
  # Do not build erlang docs when installing with
  # asdf cos it's slow and unstable
  export KERL_BUILD_DOCS=yes
  export KERL_INSTALL_MANPAGES=
  export KERL_INSTALL_HTMLDOCS=

  "$(_asdf-bin-path)" plugin add erlang || true
  "$(_asdf-bin-path)" install erlang "${version}"
}

function install-rebar3 {
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

function install-elixir {
  : "___help___ ___elixir-help"

  _may_be_install_asdf

  local version="${ELIXIR_VERSION}"
  local _erlang_version
  local _file

  local _args=("${*}")

  # --------------------------------------------------------------------------
  # PARSE ARGUMENTS
  # --------------------------------------------------------------------------
  local parsed

  if ! parsed="$(
    getopt \
      --longoptions=help,file:,elixir:,erlang: \
      --options=h,f:,x:,e: \
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

      --elixir | -x)
        version="${2}"
        _no_set_global=1
        shift 2
        ;;

      --erlang | -e)
        _erlang_version="$2"
        shift 2
        ;;

      --file | -f)
        _file="${2}"
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

  if [[ -n "${_file}" ]] && [[ -e "${_file}" ]]; then
    local _content
    _content="$(cat "${_file}")"

    version="$(
      _extract-version elixir "${_file}"
    )"

    _erlang_version="$(
      _extract-version erlang "${_file}"
    )"
  fi

  # We install erlang if no erlang previously installed on this machine or
  # user specifies an erlang version
  if [[ -n "${_erlang_version}" ]] ||
    [[ "${_erlang_version}" == "latest" ]] ||
    ! "$(_asdf-bin-path)" current erlang 2>/dev/null | grep -q "$ERLANG_VERSION"; then
    install-erlang --erlang "${_erlang_version}" &
  fi

  if asdf list elixir | grep -q "${version}"; then
    _echo "Elixir version ${version} already installed. Exiting!"
    wait
    return
  fi

  _echo "INSTALLING ELIXIR ${version}"

  sudo apt-get update

  sudo apt-get install -y \
    unzip

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add elixir || true

  "$(_asdf-bin-path)" install elixir "$version" &
  wait
}

function elixir-post-install {
  : "Install hex and rebar"

  mix local.hex --force --if-missing
  mix local.rebar --force --if-missing
}

function ___elixir-help {
  read -r -d '' var <<'eof'
Install elixir with ASDF. Usage:
  ./run.sh install-elixir [OPTIONS]

Options:
  --help/-h.                    Print help message and exit
  --elixir/-x elixir_version.   Specify elixir version.
  --erlang/-e erlang_version.   Specify erlang version.

Examples:
  ./run.sh install-elixir --help
  ./run.sh install-elixir
  ./run.sh i-elixir
  ./run.sh install-elixir --elixir=1.14.3 --erlang=25.2
  ./run.sh install-elixir --elixir=1.14.3 --erlang=latest
eof

  echo "${var}"
}

function install-nodejs {
  : "___help___ ___nodejs-help"

  local version
  local _dev
  local _set_global=1
  local _set_local

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
        _set_global=
        shift 2
        ;;

      --local | -l)
        _set_local=1
        shift 1
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
    version=18.17.1
    _set_global=1
    _set_local=
  fi

  _may_be_install_asdf "$@"

  _echo "INSTALLING NODEJS version ${version}"

  if [[ -n "${_dev}" ]]; then
    _install-deps "${NODEJS_DEPS[*]}"
  fi

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add nodejs || true

  "$(_asdf-bin-path)" install nodejs "${version}"

  if [[ -n "${_set_global}" ]]; then
    "$(_asdf-bin-path)" global nodejs "${version}"
  fi

  if [[ -z "${_set_local}" ]]; then
    _tool-versions-backup --doc="nodejs"
  fi

  "$(_asdf-bin-path)" local nodejs "${version}"

  if [[ -n "${_dev}" ]]; then
    install-nodejs-dev-pkgs
  else
    npm install --global \
      npm \
      yarn
  fi

  "$(_asdf-bin-path)" reshim nodejs

  if [[ -z "${_set_local}" ]]; then
    _tool-versions-backup --remove --tools=nodejs
  fi
}

function ___nodejs-help {
  read -r -d '' var <<'eof'
Install nodejs with ASDF. Usage:
  ./run.sh install-nodejs [OPTIONS]

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
  ./run.sh install-nodejs --help
  ./run.sh install-nodejs # install default nodejs version
  ./run.sh install-nodejs --version=17.9.1
  ./run.sh install-nodejs -a 17.9.1 --local
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

function install-python {
  : "Install python"

  _may_be_install_asdf "$@"

  _echo "INSTALLING PYTHON"

  if ! _is-dev "$@"; then
    _install-deps "${PYTHON_DEPS[*]}"
  fi

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add python

  "$(_asdf-bin-path)" install python $PYTHON_VERSION
  "$(_asdf-bin-path)" global python $PYTHON_VERSION

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  if _is-dev "$@"; then
    pip install -U \
      pip \
      yt-dlp \
      pynvim \
      jupyterlab \
      jedi-language-server \
      black \
      2>/dev/null ||
      true
  else
    pip install -U \
      pip \
      2>/dev/null ||
      true
  fi

  "$(_asdf-bin-path)" reshim python || true

  # shellcheck disable=SC2016
  echo 'export PYTHON3="$( asdf which python 2>/dev/null )"' >>~/.bashrc
}

function install-ansible {
  : "Install ansible"

  if [[ ! -d "$(_asdf-plugin-install-root python "$PYTHON_VERSION")" ]]; then
    install-py
  fi

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  pip install -U \
    psycopg2 \
    ansible
}

function install-lua {
  : "Install lua"

  _may_be_install_asdf "$@"

  local version=5.4.4

  _echo "INSTALLING LUA VERSION ${version}"

  if ! _is-dev "$@"; then
    _install-deps "${LUA_DEPS[*]}"
  fi

  if ! _has-wsl; then
    sudo apt-get install -y \
      linux-headers-$(uname -r)
  fi

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add lua

  "$(_asdf-bin-path)" install lua $version
  "$(_asdf-bin-path)" global lua $version

  # We source scripts to bring stylua executable into shell
  # shellcheck source=/dev/null
  . "$HOME/.bashrc"
  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  if ! command -v stylua; then
    install-rust "$@"
  fi
}

function install-mysql {
  : "Install mysql"

  _may_be_install_asdf

  _echo "INSTALLING msql"

  local version=8.0.32

  sudo apt-get update

  sudo apt-get install -y \
    curl \
    libaio1 \
    libtinfo5 \
    libncurses5 \
    numactl

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add mysql
  "$(_asdf-bin-path)" install mysql $version
  "$(_asdf-bin-path)" global mysql $version

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  export DATADIR="$HOME/mysql_data_${version//./_}"
  mkdir -p "$DATADIR"
  mysqld --initialize-insecure --datadir="$DATADIR"
  mysql_ssl_rsa_setup --datadir="$DATADIR"

  "$(_asdf-bin-path)" reshim mysql

  unset DATADIR
}

function install-php {
  : "Install php"

  _may_be_install_asdf

  _echo "INSTALLING PHP"

  local version=8.2.11

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

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add php

  "$(_asdf-bin-path)" install php $version
  "$(_asdf-bin-path)" global php $version

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  curl -fL \
    https://cs.symfony.com/download/php-cs-fixer-v3.phar -o /tmp/php-cs-fixer

  sudo chmod a+x /tmp/php-cs-fixer
  sudo mv /tmp/php-cs-fixer /usr/local/bin/php-cs-fixer

  local _php_version_install_root
  _php_version_install_root="$(_asdf-plugin-install-root php "$version")"

  local _ini_file="${_php_version_install_root}/conf.d/php.ini"
  local _extensions_root="${_php_version_install_root}/lib/php/extensions"

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"
  "$(_asdf-bin-path)" reshim php

  pear config-set php_ini "${_ini_file}"
  pecl config-set php_ini "${_ini_file}"
  "$(_asdf-bin-path)" reshim php

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

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"
  "$(_asdf-bin-path)" reshim php
}

function set-password-less-shell {
  : "Allow current shell user to run root commands without sudo password"

  echo "$USER ALL=(ALL) NOPASSWD:ALL" |
    sudo tee -a /etc/sudoers.d/set-password-less-shell
}

function min-machine {
  : "Setup the machine"
  setup-machine-min
}

function setup-machine-min {
  : "Setup the machine"

  if _has-wsl; then
    _wsl-setup
  fi

  install-bins
  install-git
  install-neovim
  install-tmux
  install-vifm
}

function install-dev {
  : "See setup-dev"
  setup-dev
}

function provision-dev {
  : "See setup-dev"
  setup-dev
}

function setup-dev {
  : "Setup dev machine with dotfiles"

  USERNAME="$(cmd.exe /c echo %USERNAME% 2>/dev/null)"

  if _has-wsl && [[ -z "$USERNAME" ]]; then
    echo -e "\nWindows OS username is required as USERNAME environment variable"
    exit
  else
    echo "export USERNAME=${USERNAME}" >>~/.bashrc
  fi

  _echo "SETUP DEV MACHINE WITH DOTFILE"

  echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf >/dev/null

  _update-and-upgrade-os-packages dev

  mkdir -p ~/.ssh
  install-complete-alias

  install-tmux dev
  install-vifm dev
  install-chrome

  mkdir -p "${LOCAL_BIN_PATH}" \
    ~/projects/0 \
    ~/.ssh \
    ~/.config \
    ~/.config/erlang_ls

  git clone https://github.com/humpangle/dotfiles ~/dotfiles

  _setup-wsl-home

  sudo chown root:root ~/user_defaults
  sudo mv ~/user_defaults /etc/sudoers.d/

  ln -s ~/dotfiles/gitignore ~/.gitignore
  ln -s ~/dotfiles/gitconfig ~/.gitconfig
  ln -s ~/dotfiles/.config/nvim ~/.config
  ln -s ~/dotfiles/.iex.exs ~/.iex.exs
  ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
  ln -s ~/dotfiles/.config/vifm/vifmrc ~/.config/vifm/vifmrc
  ln -s ~/dotfiles/.config/shellcheckrc ~/.config

  touch ~/dotfiles/snippet_in.txt
  touch ~/dotfiles/snippet_out.json

  sed -i -e "s/filemode = true/filemode = false/" ~/dotfiles/.git/config

  [[ -e ~/dotfiles/to_snippet_vscode.py ]] &&
    chmod 755 ~/dotfiles/to_snippet_vscode.py

  curl -fLo "$HOME/complete_alias.sh" \
    https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias

  touch "${HOME}/.hushlogin"

  # We preliminary save tmux sessions every minute instead of default to 15.
  # After the first save, we must revert back to 15 - so git does not record
  # any changes.
  sed -i -e "s/set -g @continuum-save-interval '15'/set -g @continuum-save-interval '1'/" ~/dotfiles/tmux.conf

  # Install tmux plugins specified in .tmux.conf
  chmod 755 ~/.tmux/plugins/tpm/bin/install_plugins
  ~/.tmux/plugins/tpm/bin/install_plugins

  # ~/dotfiles/scripts/* added to path in `profile_append.sh`
  chmod 755 ~/dotfiles/scripts/*
  find ~/dotfiles/etc/ -type f -name "*.sh" -exec chmod 755 {} \;

  echo "[ -f $HOME/dotfiles/bash_append.sh ] && source $HOME/dotfiles/bash_append.sh" >>~/.bashrc

  # shellcheck disable=SC2016
  echo '[ -f "$HOME/dotfiles/profile_append.sh" ] && source "$HOME/dotfiles/profile_append.sh"' >>~/.profile

  echo "export INTELEPHENSE_LICENCE=''" >>~/.bashrc

  install-golang dev || true
  install-nodejs --dev || true
  install-python dev || true

  # Installing lua will also install rust because of stylua
  install-lua dev || true

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  # Many times, installing rust will just error (mostly for network reasons)
  # So we try again just one more time.
  rust_path="$(_asdf-plugin-install-root rust "${RUST_VERSION}")"
  if ! [[ -e "${rust_path}" ]]; then
    install-rust dev
  fi

  install-docker dev || true
  install-neovim dev

  sudo apt-get autoremove -y

  cp ~/dotfiles/etc/sudoers.d/user_defaults "${HOME}"

  sed -i -e "s/__USERNAME__/$USER/g" ~/user_defaults
  sed -i -e "s|__NEOVIM_BIN__|$(which nvim)|g" ~/user_defaults
  sudo mv ~/user_defaults /etc/sudoers.d/
  sudo chown root:root /etc/sudoers.d/user_defaults

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

  local _ls_version=0.32.3

  # This one works with COC-nvim
  local _lsp_version=0.0.12 # 2021-05-13

  if [[ "${_flavor}" == 'ls' ]]; then
    version="${_ls_version}"
  else
    version="${_lsp_version}"
  fi

  if [[ -n "${_print_version}" ]]; then
    echo "Version of terraform ${_flavor}: ${version}"
    return
  fi

  cd ~/projects/0

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
  ./run.sh install-terraform-lsp flavor [OPTIONS]

Options:
  --version/-v. Print version information and exit.
  --help/-h.    Print this help information and exit.
  --flavor/-f.  The flavor you wish to install. The possible values are ls|lsp

Examples:
  ./run.sh install-terraform-lsp --help
  ./run.sh install-terraform-lsp --version
  ./run.sh install-terraform-lsp lsp
eof

  echo -e "${var}"
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

  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add sqlite || true

  "$(_asdf-bin-path)" install sqlite "${version}"
  "$(_asdf-bin-path)" global sqlite "${version}"

  "$(_asdf-bin-path)" reshim sqlite
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

  return

  # To prevent unintended upgrades, you can pin the package at the currently
  # installed version
  echo "mongodb-org hold" | sudo dpkg --set-selections
  echo "mongodb-org-database hold" | sudo dpkg --set-selections
  echo "mongodb-org-server hold" | sudo dpkg --set-selections
  echo "mongodb-mongosh hold" | sudo dpkg --set-selections
  echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
  echo "mongodb-org-tools hold" | sudo dpkg --set-selections
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
      sudo tee /etc/bash_completion.d/mongo-db-atlas
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
  ./run.sh install-aws-cli

Examples:
  ./run.sh install-aws-cli
eof

  echo -e "${var}"
}

function help {
  : "List available tasks."

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
    if ! grep -qP "function\s+${name}\s+{" <<<"${_this_file_content}"; then
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
    # `: "___help___ ___elixir-help"`
    _help_func="$(awk \
      'match($0, /^ +: *"___help___ +(___[a-zA-Z][a-zA-Z0-9_-]+-help)/, a) {print a[1]}' \
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

TIMEFORMAT=$'Task completed in %3lR\n'
time "${@:-help}"
