#!/bin/bash
# shellcheck disable=1090,2009,2046,2143,2164,2103,2230

set -o pipefail

ERLANG_VERSION=25.1.2
BASH_APPEND_PATH="${HOME}/__bash-append.sh"
LOCAL_BIN_PATH="$HOME/.local/bin"
DOTFILE_GIT_DOWNLOAD_URL_PREFIX='https://raw.githubusercontent.com/humpangle/dotfiles/master'
PYTHON_VERSION=3.10.8

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

function _asdf-plugin-root {
  local plugin="$1"
  local version="$2"

  printf '%s' "$HOME/.asdf/installs/${plugin}/$version"
}

# -----------------------------------------------------------------------------
# END HELPER FUNCTIONS
# -----------------------------------------------------------------------------

function install-docker {
  : "Install docker"

  _echo-begin-install "INSTALLING DOCKER"

  # https://docs.docker.com/engine/install/ubuntu/

  sudo apt update

  sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

  sudo mkdir -p /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt update

  sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

  sudo usermod -aG docker "${USER}"
  # newgrp docker

  sudo apt-get autoremove -y
}

function install-asdf-postgres {
  : "Install postgres with asdf"

  if [[ ! -e "$(_asdf-bin-path)" ]]; then
    install-asdf
  fi

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
  fi

  sudo apt update

  sudo apt remove -y --purge tmux

  sudo apt install -y \
    libevent-dev \
    ncurses-dev \
    build-essential \
    bison \
    pkg-config \
    xclip

  sudo apt-get autoremove -y

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

  curl -fLo ~/.tmux.conf \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/tmux.conf"

  mkdir -p "$HOME/.tmux/resurrect"
}

function install-neovim {
  : "Install neovim"

  neovim_version=v0.8.1
  RIP_GREP_VERSION=13.0.0

  _echo-begin-install "INSTALLING NEOVIM VERSION ${neovim_version}"

  sudo apt update
  sudo apt install -y xclip

  # shellcheck disable=2016
  printf 'export DISPLAY="$(%s):0"' "ip route | awk '/default/ {print \$3}'"

  curl -fLo nvim https://github.com/neovim/neovim/releases/download/$neovim_version/nvim.appimage

  sudo chown root:root nvim

  sudo chmod +x nvim

  sudo mv nvim /usr/bin

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all

  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RIP_GREP_VERSION}/ripgrep_${RIP_GREP_VERSION}_amd64.deb
  # shellcheck disable=SC1001
  sudo dpkg -i ripgrep*${RIP_GREP_VERSION}\_amd64.deb
  # shellcheck disable=SC1001
  rm ripgrep*${RIP_GREP_VERSION}\_amd64.deb

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

  sudo apt-get update

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

  curl -fLo ~/.config/vifm/vifmrc \
    "$DOTFILE_GIT_DOWNLOAD_URL_PREFIX/config/vifm/vifmrc"
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

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $version

  # shellcheck disable=SC2016
  if [[ ! -e "$BASH_APPEND_PATH" ]] && [[ ! "$(grep -q '. $HOME/.asdf/asdf.sh' "$HOME/.bashrc")" ]]; then
    echo ". \$HOME/.asdf/asdf.sh" >>"$HOME/.bashrc"
    echo ". \$HOME/.asdf/completions/asdf.bash" >>"$HOME/.bashrc"
  fi
}

function install-erlang {
  : "Install erlang"

  if [[ ! -e "$(_asdf-bin-path)" ]]; then
    install-asdf
  fi

  _echo-begin-install "INSTALLING ERLANG"

  sudo apt-get update

  sudo apt-get -y install \
    g++ \
    build-essential \
    autoconf \
    m4 \
    libncurses5-dev \
    libwxgtk3.0-gtk3-dev \
    libwxgtk-webview3.0-gtk3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libssh-dev \
    unixodbc-dev \
    xsltproc \
    fop \
    libxml2-utils \
    libncurses-dev

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

  if [[ ! -e "$(_asdf-bin-path)" ]]; then
    install-asdf
  fi

  if ! "$(_asdf-bin-path)" current erlang | grep -q "$ERLANG_VERSION"; then
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

  local mix_bin_path="$HOME/.asdf/installs/elixir/$version/bin/mix"

  "$mix_bin_path" local.hex --force --if-missing
  "$mix_bin_path" local.rebar --force --if-missing

  "$(_asdf-bin-path)" reshim elixir
}

function install-node {
  : "Install nodejs"

  install-nodejs
}

function install-nodejs {
  : "Install nodejs"

  if [[ ! -e "$(_asdf-bin-path)" ]]; then
    install-asdf
  fi

  _echo-begin-install "INSTALLING NODEJS"

  local version=16.18.1

  sudo apt-get update

  sudo apt-get install -y \
    python3 \
    g++ \
    make \
    python3-pip \
    build-essential

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add nodejs

  "$(_asdf-bin-path)" install nodejs $version
  "$(_asdf-bin-path)" global nodejs $version

  "$(_asdf-bin-path)" reshim nodejs

  npm install --global \
    npm \
    yarn
}

function install-python {
  : "Install python"

  install-py
}

function install-py {
  : "Install python"

  if [[ ! -e "$(_asdf-bin-path)" ]]; then
    install-asdf
  fi

  _echo-begin-install "INSTALLING PYTHON"

  sudo apt-get update

  sudo apt-get install -y \
    g++ \
    make \
    build-essential \
    libssl-dev zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

  . "$HOME/.asdf/asdf.sh"

  "$(_asdf-bin-path)" plugin add python

  "$(_asdf-bin-path)" install python $PYTHON_VERSION
  "$(_asdf-bin-path)" global python $PYTHON_VERSION

  pip install -U \
    pip

  "$(_asdf-bin-path)" reshim python
}

function install-ansible {
  : "Install ansible"

  if [[ ! -d "$(_asdf-plugin-root python "$PYTHON_VERSION")" ]]; then
    install-py
  fi

  . "$HOME/.asdf/asdf.sh"

  pip install -U \
    psycopg2 \
    ansible
}

function set-password-less-shell {
  : "Allow current shell user to run root commands without sudo password"

  echo "$USER ALL=(ALL) NOPASSWD:ALL" |
    sudo tee -a /etc/sudoers.d/set-password-less-shell
}

function setup-machine {
  : "Setup the machine"

  if [[ "$(uname -r)" == *WSL2 ]]; then
    _wsl-setup
  fi

  install-bins
  install-git
  install-neovim
  install-tmux
  install-vifm
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
