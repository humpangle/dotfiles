#!/bin/bash
# shellcheck disable=1090,2009,2046,2143,2164,2103,2230

set -o pipefail

INITIAL_WSL_C_PATH=/mnt/c

ERLANG_VERSION=25.1.2
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

full_line_str=''
full_line_len=$(tput cols)

function _echo-begin-install {
  local text="${*}"
  local equal='='

  local len="${#text}"
  len=$((full_line_len - len))
  local half=$((len / 2 - 1))

  local line=''

  for i in $(seq $half); do
    line="${line}${equal}"
  done

  if [[ -z "${full_line_str}" ]]; then
    # shellcheck disable=SC2034
    for i in $(seq "$full_line_len"); do
      full_line_str="${full_line_str}${equal}"
    done
  fi

  echo -e "\n\n${full_line_str}"
  echo -e "\n\n${line} ${text} ${line}"
  echo -e "\n\n${full_line_str}\n"
}

function _asdf-bin-path {
  realpath "$HOME/.asdf/bin/asdf" 2>/dev/null
}

function _write-local-bin-path-to-paths {
  if ! grep -q "PATH=.*${LOCAL_BIN_PATH}" "$HOME/.bashrc"; then
    echo -e "\nexport PATH=${LOCAL_BIN_PATH}:\$PATH" >>"$HOME/.bashrc"
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
    _echo-begin-install "DOWNLOAD AND CONFIGURE vcxsrv"

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

# -----------------------------------------------------------------------------
# END HELPER FUNCTIONS
# -----------------------------------------------------------------------------

function install-golang {
  : "Install golang"

  _may_be_install_asdf "$@"

  _echo-begin-install "INSTALLING GOLANG"

  local version=1.19.3

  if ! _is-dev "$@"; then
    _install-deps "${GOLANG_DEPS[*]}"
  fi

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

  _echo-begin-install "INSTALLING RUST"

  if ! _is-dev "$@"; then
    _install-deps "${RUST_DEPS[*]}"
  fi

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add rust
  "$(_asdf-bin-path)" install rust $RUST_VERSION
  "$(_asdf-bin-path)" global rust $RUST_VERSION

  local rust_install_root
  rust_install_root="$(_asdf-plugin-install-root rust "$RUST_VERSION")"

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
    echo -e "\nexport PATH=${cargo_bin_dir}:\$PATH" >>"${HOME}/.bashrc"
  fi
}

function install-docker {
  : "Install docker"

  _echo-begin-install "INSTALLING DOCKER"

  # https://docs.docker.com/engine/install/ubuntu/

  if ! _is-dev "$@"; then
    _install-deps "${DOCKER_DEPS[*]}"
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

  local version=14.2

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

  _echo-begin-install "INSTALLING POSTGRES"

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

  _echo-begin-install "TMUX ${tmux_version}"

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
    _echo-begin-install "DOWNLOADING TMUX CONF"

    curl -fLo ~/.tmux.conf \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/tmux.conf"
  fi

  mkdir -p "$HOME/.tmux/resurrect"
}

function install-neovim {
  : "Install neovim"

  neovim_version=v0.8.1
  RIP_GREP_VERSION=13.0.0
  # `bat` is for syntax highlighting inside `fzf`
  BAT_VERSION=0.22.1

  _echo-begin-install "INSTALLING NEOVIM VERSION ${neovim_version}"

  if ! _is-dev "$@"; then
    _install-deps "${NEOVIM_DEPS[*]}"
  fi

  if [[ ! $(dpkg -l | grep -q fuse2) ]]; then
    sudo apt-get install -y \
      fuse \
      libfuse2
  fi

  curl -fLo nvim https://github.com/neovim/neovim/releases/download/$neovim_version/nvim.appimage

  sudo chown root:root nvim

  sudo chmod +x nvim

  sudo mv nvim /usr/bin

  if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
  fi

  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RIP_GREP_VERSION}/ripgrep_${RIP_GREP_VERSION}_amd64.deb
  # shellcheck disable=SC1001
  sudo dpkg -i ripgrep*${RIP_GREP_VERSION}\_amd64.deb
  # shellcheck disable=SC1001
  rm ripgrep*${RIP_GREP_VERSION}\_amd64.deb

  bat_deb="bat_${BAT_VERSION}_amd64.deb"
  curl -LO "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${bat_deb}"
  sudo dpkg -i "${bat_deb}"
  rm "${bat_deb}"

  local shfmt_version=v3.5.1

  curl -Lo \
    "$HOME/.local/bin/shfmt" \
    --create-dirs \
    "https://github.com/mvdan/sh/releases/download/${shfmt_version}/shfmt_${shfmt_version}_linux_amd64"

  chmod ugo+x "$HOME/.local/bin/shfmt"

  if _is-dev "$@"; then
    _echo-begin-install "WE'LL BE USING DOTFILES FOR NEOVIM CONFIG. RETURNING."
    return
  fi

  # shellcheck disable=2016
  printf 'export DISPLAY="$(%s):0"' "ip route | awk '/default/ {print \$3}'"

  # mkdir -p ~/.config/nvim

  curl -fLo ~/.config/nvim/init.vim \
    --create-dirs \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/config/nvim/settings-min.vim"

  shared_path=~/.local/share/nvim

  read -r -d '' xx <<'eof'
szw/vim-maximizer
tpope/vim-obsession
tpope/vim-unimpaired
tpope/vim-fugitive
tpope/vim-surround
sbdchd/neoformat
junegunn/fzf
junegunn/fzf.vim
stsewd/fzf-checkout.vim
dhruvasagar/vim-prosession
tomtom/tcomment_vim
nelstrom/vim-visual-star-search
voldikss/vim-floaterm
voldikss/fzf-floaterm
airblade/vim-gitgutter
itchyny/lightline.vim
nelstrom/vim-visual-star-search
easymotion/vim-easymotion
elixir-editors/vim-elixir
rakr/vim-one
eof

  for line in ${xx}; do
    local plugin_owner=${line%%/*}
    local plugin_path="${line#*/}"
    local path_prefix="${shared_path}/site/pack/$plugin_path/start"
    local full_install_path="$path_prefix/$plugin_path"

    if [[ ! -d "$full_install_path" ]]; then
      mkdir -p "$path_prefix"
      echo "Installing neovim plugin ${plugin_owner}/${plugin_path}"

      git clone "https://github.com/${plugin_owner}/${plugin_path}" \
        "$full_install_path"

    else
      cd "$full_install_path"
      git pull origin master
      cd -
    fi
  done

  install-neovim-plugins-configs
}

function install-neovim-plugins-configs {
  : "Install configuration files of neovim plugins"

  read -r -d '' plug_configs <<'eof'
config/nvim/lua/plugins___neoformat.lua
config/nvim/lua/plugins___floaterm.lua
config/nvim/plugins___fzf.vim
config/nvim/plugins___fugitive.vim
config/nvim/plugins___lightline.vim
config/nvim/plugins___vim-easymotion.vim
config/nvim/plugins___vim-maximizer.vim
config/nvim/plugins___vim-one.vim
eof

  for line in ${plug_configs}; do
    plugin_path=${line%%___*}
    plugin_file="${line#*___}"

    local install_path="${HOME}/.${plugin_path}/${plugin_file}"

    local url="$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/${plugin_path}/${plugin_file}"

    echo "Downloading neovim plugin config file ${plugin_path}/${plugin_file}"

    curl --create-dirs -fLo "${install_path}" "${url}"
    # curl -fL "${install_path}" "${url}"
  done

  curl -fLo ~/.config/nvim/lua/util.lua \
    --create-dirs \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/config/nvim/lua/util.lua"
}

function install-haproxy {
  : "Install haproxy"

  local version="2.4"

  _echo-begin-install "INSTALLING HAPROXY VERSION ${version}"

  sudo apt install -y --no-install-recommends software-properties-common
  sudo add-apt-repository "ppa:vbernat/haproxy-${version}" -y
  sudo apt update
  sudo apt install -y "haproxy=${version}.*"
}

function install-bins {
  : "Install useful binaries"

  _echo-begin-install "INSTALLING adhoc binaries"

  sudo apt-get update

  mkdir -p "${LOCAL_BIN_PATH}"

  _write-local-bin-path-to-paths

  curl -fLo "${LOCAL_BIN_PATH}/p-env" \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/scripts/p-env"

  chmod u+x "${LOCAL_BIN_PATH}/p-env"

  curl -fLo "${BASH_APPEND_PATH}" \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/regular_shell.sh"

  echo "[ -f ${BASH_APPEND_PATH} ] && source ${BASH_APPEND_PATH}" >>"$HOME/.bashrc"
  source "$HOME/.bashrc"

  curl -fLo "$HOME/complete_alias.sh" \
    https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias

  echo -e "\n. \$HOME/complete_alias.sh" >>"$HOME/.bash_completion"

  mkdir -p ~/.ssh
}

function install-vifm {
  : "Install VIFM"

  local version='0.12.1'

  _echo-begin-install "INSTALLING VIFM VERSION ${version}"

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
    _echo-begin-install "DOWNLOADING VIFM CONF"

    curl -fLo ~/.config/vifm/vifmrc \
      "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/config/vifm/vifmrc"
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

  local version=v0.10.2

  _echo-begin-install "INSTALLING ASDF"

  if ! _is-dev "$@"; then
    _update-and-upgrade-os-packages
  fi

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $version

  # shellcheck disable=SC2016
  if [[ ! -e "$BASH_APPEND_PATH" ]] && [[ ! "$(grep -q '. $HOME/.asdf/asdf.sh' "$HOME/.bashrc")" ]]; then
    echo ". \$HOME/.asdf/asdf.sh" >>"$HOME/.bashrc"
    echo ". \$HOME/.asdf/completions/asdf.bash" >>"$HOME/.bashrc"
  fi
}

function install-erlang {
  : "Install erlang"

  _may_be_install_asdf

  _echo-begin-install "INSTALLING ERLANG"

  _install-deps "${ERLANG_DEPS[*]}"

  sudo apt-get autoremove -y

  export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
  # Do not build erlang docs when installing with
  # asdf cos it's slow and unstable
  export KERL_BUILD_DOCS=yes
  export KERL_INSTALL_MANPAGES=
  export KERL_INSTALL_HTMLDOCS=

  "$(_asdf-bin-path)" plugin add erlang
  "$(_asdf-bin-path)" install erlang "$ERLANG_VERSION"
  "$(_asdf-bin-path)" global erlang "$ERLANG_VERSION"

  install-rebar3
}

function install-rebar3 {
  : "Install rebar3"

  local rebar3_version=3.20.0

  _echo-begin-install "INSTALLING REBAR3"

  curl -fLo "$HOME/.local/bin/rebar3" \
    --create-dirs \
    https://github.com/erlang/rebar3/releases/download/${rebar3_version}/rebar3

  chmod u+x "$HOME/.local/bin/rebar3"

  _write-local-bin-path-to-paths
}

function install-elixir {
  : "Install elixir"

  _may_be_install_asdf

  if ! "$(_asdf-bin-path)" current erlang 2>/dev/null | grep -q "$ERLANG_VERSION"; then
    install-erlang
  fi

  _echo-begin-install "INSTALLING ELIXIR"

  local version=1.14.2-otp-25

  sudo apt-get update

  sudo apt-get install -y \
    unzip

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add elixir

  "$(_asdf-bin-path)" install elixir $version
  "$(_asdf-bin-path)" global elixir $version

  local mix_bin_path
  mix_bin_path="$(_asdf-plugin-install-root elixir "$version")/bin/mix"

  "$mix_bin_path" local.hex --force --if-missing
  "$mix_bin_path" local.rebar --force --if-missing

  "$(_asdf-bin-path)" reshim elixir
}

function install-nodejs {
  : "Install nodejs"

  _may_be_install_asdf "$@"

  _echo-begin-install "INSTALLING NODEJS"

  local version=16.18.1

  if ! _is-dev "$@"; then
    _install-deps "${NODEJS_DEPS[*]}"
  fi

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add nodejs

  "$(_asdf-bin-path)" install nodejs $version
  "$(_asdf-bin-path)" global nodejs $version

  "$(_asdf-bin-path)" reshim nodejs

  if _is-dev "$@"; then
    npm install --global \
      npm \
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
      @tailwindcss/language-server
  else
    npm install --global \
      npm \
      yarn
  fi
}

function install-python {
  : "Install python"

  _may_be_install_asdf "$@"

  _echo-begin-install "INSTALLING PYTHON"

  if ! _is-dev "$@"; then
    _install-deps "${PYTHON_DEPS[*]}"
  fi

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add python

  "$(_asdf-bin-path)" install python $PYTHON_VERSION
  "$(_asdf-bin-path)" global python $PYTHON_VERSION

  . "$HOME/.asdf/asdf.sh"

  if _is-dev "$@"; then
    pip install -U \
      pip \
      pynvim \
      jupyterlab \
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

  . "$HOME/.asdf/asdf.sh"

  pip install -U \
    psycopg2 \
    ansible
}

function install-lua {
  : "Install lua"

  _may_be_install_asdf "$@"

  local version=5.4.4

  _echo-begin-install "INSTALLING LUA VERSION ${version}"

  if ! _is-dev "$@"; then
    _install-deps "${LUA_DEPS[*]}"
  fi

  if ! _has-wsl; then
    sudo apt-get install -y \
      linux-headers-$(uname -r)
  fi

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add lua

  "$(_asdf-bin-path)" install lua $version
  "$(_asdf-bin-path)" global lua $version

  # We source scripts to bring stylua executable into shell
  . "$HOME/.bashrc"
  . "$HOME/.asdf/asdf.sh"

  if ! command -v stylua; then
    install-rust "$@"
  fi
}

function set-password-less-shell {
  : "Allow current shell user to run root commands without sudo password"

  echo "$USER ALL=(ALL) NOPASSWD:ALL" |
    sudo tee -a /etc/sudoers.d/set-password-less-shell
}

function setup-machine {
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

  if _has-wsl && [[ -z "$USERNAME" ]]; then
    echo -e "\nWindows OS username is required as USERNAME environment variable"
    exit
  fi

  _echo-begin-install "SETUP DEV MACHINE WITH DOTFILE"

  echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf >/dev/null

  _update-and-upgrade-os-packages dev

  install-tmux dev
  install-vifm dev
  install-neovim dev

  mkdir -p "${LOCAL_BIN_PATH}" \
    ~/projects/0 \
    ~/.ssh \
    ~/.config \
    ~/.config/erlang_ls

  _write-local-bin-path-to-paths

  git clone https://github.com/humpangle/dotfiles ~/dotfiles

  _setup-wsl-home

  cp ~/dotfiles/etc/sudoers.d/user_defaults "${HOME}"

  sed -i -e "s/username/$USER/g" ~/user_defaults
  sed -i -e "s|__NEOVIM_BIN__|$(which nvim)|g" ~/user_defaults
  sudo chown root:root ~/user_defaults
  sudo mv ~/user_defaults /etc/sudoers.d/

  ln -s ~/dotfiles/gitignore ~/.gitignore
  ln -s ~/dotfiles/gitconfig ~/.gitconfig
  ln -s ~/dotfiles/config/nvim ~/.config
  ln -s ~/dotfiles/config/erlang_ls/erlang_ls.config ~/.config/erlang_ls
  ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
  ln -s ~/dotfiles/config/vifm/vifmrc ~/.config/vifm/vifmrc
  ln -s ~/dotfiles/.config/shellcheckrc ~/.config

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

  chmod 755 ~/dotfiles/scripts/*
  find ~/dotfiles/etc/ -type f -name "*.sh" -exec chmod 755 {} \;

  echo "[ -f $HOME/dotfiles/bash_append.sh ] && source $HOME/dotfiles/bash_append.sh" >>~/.bashrc

  # shellcheck disable=SC2016
  echo '[ -f "$HOME/dotfiles/profile_append.sh" ] && source "$HOME/dotfiles/profile_append.sh"' >>~/.profile

  echo "export INTELEPHENSE_LICENCE=''" >>~/.bashrc

  # Other things to install
  install-nodejs dev || true
  install-python dev || true
  install-golang dev || true

  # Installing lua will also install rust because of stylua
  install-lua dev || true

  . "$HOME/.asdf/asdf.sh"

  # Many times, installing rust will just error (mostly for network reasons)
  # So we try again just one more time.
  # shellcheck disable=SC2076
  if ! [[ "$(_asdf-bin-path current rust 2>/dev/null)" =~ "$RUST_VERSION" ]]; then
    install-rust dev
  fi

  install-docker dev || true

  sudo apt-get autoremove -y

  sudo rm -rf /etc/resolv.conf

  echo "${INITIAL_WSL_C_PATH}/WINDOWS/system32/wsl.exe --terminate"
}

function install-terraform-lsp {
  : "Install terraform"

  cd ~/projects/0

  local version=0.0.12

  curl -fLO "https://github.com/juliosueiras/terraform-lsp/releases/download/v${version}/terraform-lsp_${version}_linux_amd64.tar.gz"
  tar xzf "terraform-lsp_${version}_linux_amd64.tar.gz"
  sudo mv terraform-lsp /usr/local/bin/

  cd - >/dev/null
}

function help {
  : "List available tasks."
  compgen -A function | grep -v "^_" | while read -r name; do
    paste <(printf '%s' "$name") <(type "$name" | sed -nEe 's/^[[:space:]]*: ?"(.*)";/    \1/p')
  done

  printf "\n"
}

TIMEFORMAT=$'Task completed in %3lR\n'
time "${@:-help}"
