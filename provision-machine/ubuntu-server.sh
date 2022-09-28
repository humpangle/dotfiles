#!/bin/bash
# shellcheck disable=1090,2009,2046

function _env {
  local env
  local splitted_envs=""

  if [[ -n "$1" ]]; then
    env="$1"
  elif [[ -e .env ]]; then
    env=".env"
  fi

  if [[ -n "$env" ]]; then
    set -a
    . $env
    set +a

    splitted_envs=$(splitenvs "$env" --lines)
  fi

  printf "%s" "$splitted_envs"
}

function _echo-begin-install {

  echo -e "\n\n============================================="
  echo -e "\n\n======== ${*} ============="
  echo -e "\n\n=============================================\nn"
}

function _wait_until {
  command="${1}"
  timeout="${2:-30}"

  echo -e "\n\n\n=Running: $command=\n\n"

  i=0
  until eval "${command}"; do
    ((i++))

    if [ "${i}" -gt "${timeout}" ]; then
      echo -e "\n\n\n=Command: $command="
      echo -e "failed, aborting due to ${timeout}s timeout!\n\n"
      exit 1
    fi

    sleep 1
  done

  echo -e "\n\n\n= Done successfully running: $command =\n\n"
}

function _timestamp {
  date +'%s'
}

function _raise_on_no_env_file {
  if [[ -n "$SOME_ENV_EXISTS" ]]; then
    if [[ "$SOME_ENV_EXISTS" =~ .env.example ]]; then
      printf "\nERROR: env filename can not be .env.example.\n\n"
      exit 1
    fi

    return 0
  fi

  if [[ -z "$1" ]] || [[ ! -e "$1" ]]; then
    printf "\nERROR:env filename has not been provided or invalid.\n"
    printf "You may also source your environment file.\n\n"
    exit 1
  fi
}

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
  newgrp docker
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
}

function install-tmux {
  : "Install tmux"

  tmux_version='3.2a'

  _echo-begin-install "TMUX ${tmux_version}"

  rm -rf tmux-${tmux_version}

  sudo apt remove -y --purge tmux

  sudo apt install -y \
    libevent-dev \
    ncurses-dev \
    build-essential \
    bison \
    pkg-config \
    xclip

  curl -LO https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz &&
    tar xf tmux-${tmux_version}.tar.gz &&
    rm -f tmux-${tmux_version}.tar.gz &&
    cd tmux-${tmux_version} &&
    ./configure &&
    make &&
    sudo make install &&
    cd - &&
    sudo rm -rf /usr/local/src/tmux-\* &&
    sudo mv tmux-${tmux_version} /usr/local/src &&
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&
    git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum &&
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect &&
    git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux/plugins/tmux-yank

  curl -fLo ~/.tmux.conf \
    https://raw.githubusercontent.com/humpangle/dotfiles/master/tmux.conf
}

function install-neovim {
  : "Install neovim"

  neovim_version=0.7.0

  _echo-begin-install "INSTALLING NEOVIM VERSION ${neovim_version}"

  sudo apt install -y xclip

  # shellcheck disable=2016
  printf 'export DISPLAY="$(%s):0"' "ip route | awk '/default/ {print \$3}'"

  curl -fLo nvim https://github.com/neovim/neovim/releases/download/v$neovim_version/nvim.appimage

  sudo chown root:root nvim

  sudo chmod +x nvim

  sudo mv nvim /usr/bin

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all

  # mkdir -p ~/.config/nvim

  curl -fLo ~/.config/nvim/init.vim \
    --create-dirs \
    https://raw.githubusercontent.com/humpangle/dotfiles/master/config/nvim/settings-min.vim

  shared_path=~/.local/share/nvim

  read -r -d '' xx <<'eof'
szw/vim-maximizer
tpope/vim-obsession
tpope/vim-unimpaired
tpope/vim-fugitive
sbdchd/neoformat
junegunn/fzf
junegunn/fzf.vim
stsewd/fzf-checkout.vim
dhruvasagar/vim-prosession
tomtom/tcomment_vim
nelstrom/vim-visual-star-search
voldikss/vim-floaterm
voldikss/fzf-floaterm
eof

  for line in ${xx}; do
    plugin_owner=${line%%/*}
    plugin_path="${line#*/}"

    mkdir -p "${shared_path}/site/pack/$plugin_path/start"

    echo "Installing neovim plugin ${plugin_owner}/${plugin_path}"

    git clone "https://github.com/${plugin_owner}/${plugin_path}" \
      "${shared_path}/site/pack/$plugin_path/start/$plugin_path"
  done

  read -r -d '' plug_configs <<'eof'
config/nvim/lua/plugins___neoformat.lua
config/nvim/lua/plugins___floaterm.lua
config/nvim/plugins___fzf.vim
config/nvim/plugins___fugitive.vim
eof

  for line in ${plug_configs}; do
    plugin_path=${line%%___*}
    plugin_file="${line#*___}"

    local install_path="${HOME}/.${plugin_path}/${plugin_file}"
    local url="https://raw.githubusercontent.com/humpangle/dotfiles/master/${plugin_path}/${plugin_file}"

    echo "Downloading neovim plugin config file ${plugin_path}/${plugin_file}"

    curl --create-dirs -fLo "${install_path}" "${url}"
    # curl -fL "${install_path}" "${url}"

  done
}

function install-haproxy {
  : "Install haproxy"

  local version="2.4"

  _echo-begin-install "INSTALLING HAPROXY VERSION ${version}"

  sudo apt install -y --no-install-recommends software-properties-common
  sudo add-apt-repository "ppa:vbernat/haproxy-${version}" -y
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y "haproxy=${version}.*"
}

function install-bins {
  : "Install useful binaries"

  _echo-begin-install "INSTALLING adhoc binaries"

  local bin_path="$HOME/.local/bin"

  mkdir -p "${bin_path}"

  echo "export PATH=${bin_path}:\$PATH" >>"$HOME/.bashrc"

  curl -fLo "${bin_path}/splitenvs" \
    https://raw.githubusercontent.com/humpangle/dotfiles/master/scripts/splitenvs

  chmod u+x "${bin_path}/splitenvs"

  local bash_append_path="${HOME}/__bash-append.sh"

  curl -fLo "${bash_append_path}" \
    https://raw.githubusercontent.com/humpangle/dotfiles/master/regular_shell.sh

  echo "[ -f ${bash_append_path} ] && source ${bash_append_path}" >>"$HOME/.bashrc"
  source "$HOME/.bashrc"
}

function install-vifm {
  : "Install VIFM"

  local version='0.12.1'

  _echo-begin-install "INSTALLING VIFM VERSION ${version}"

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
    https://raw.githubusercontent.com/humpangle/dotfiles/master/config/vifm/vifmrc
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
