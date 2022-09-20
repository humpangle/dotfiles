#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155,2139

###### START COMMONS ##################

if [[ -e /usr/local/bin/aws_completer ]]; then
  complete -C '/usr/local/bin/aws_completer' aws
fi

export EDITOR="nvim"
# install with: `sudo apt-get install ssh-askpass-gnome ssh-askpass -y`
# shellcheck disable=2155
export SUDO_ASKPASS=$(command -v ssh-askpass)

# Add to $PATH only if `it` does not exist in the $PATH
# fish shell has the `fish_add_path` function which does something similar
# CREDIT: https://unix.stackexchange.com/a/217629
# USAGE:
#     pathmunge /sbin/             ## Add to the start; default
#     pathmunge /usr/sbin/ after   ## Add to the end
pathmunge() {
  # first check if folder exists on filesystem
  if [ -d "$1" ]; then
    if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)"; then
      if [ "$2" = "after" ]; then
        PATH="$PATH:$1"
      else
        PATH="$1:$PATH"
      fi
    fi
  fi
}

# docker
export DOCKER_BUILDKIT=1
export DOCKER0="$(ip route | awk '/docker0/ { print $9 }')"

alias d='docker'
alias docker-compose='docker compose'
# docker remove all containers
alias drac='docker rm $(docker ps -a -q)'
# docker remove all containers force
alias dracf='docker rm $(docker ps -a -q) --force'
alias drim='docker rmi'
alias dim='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dc='docker compose'
alias dce='docker compose exec'
alias de='docker exec -it'
alias dcu='docker compose up'
alias dcub='docker compose up --build'
alias dcud='docker compose up -d'
alias dcb='docker compose build'
alias db='docker build -t'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dck='docker compose kill'
alias dcd='docker compose down'
alias dcdv='docker compose kill && docker compose down -v'
alias dvra='docker volume rm $(docker volume ls -q)'
alias dvls='docker volume ls'
alias dvlsq='docker volume ls -q'
alias ds='sudo service docker start'
alias dn='docker network'
alias dnls='docker network ls'
alias dcps='docker compose ps'
alias dcpsa='docker compose ps -a'

alias drmlogs--description='drmlogs container_name_or_ID [..container_name_or_ID] ,,, docker remove logs:'

alias d-dangling='dim -qf dangling=true | xargs docker rmi -f'
alias ddangling='dim -qf dangling=true | xargs docker rmi -f'

# docker compose up --daemon and logs --follow
dcudlf() {
  docker compose up -d "$@"
  docker compose logs -f "$@"
}

alias dcudl='dcudlf'
alias dcudl--description='docker up daemon and logs'

# docker compose restart and logs --follow
dcrsf() {
  docker compose restart "$@"
  docker compose logs -f "$@"
}
alias dcrs='dcrsf'

dimgf() {
  docker images | grep -P "$1" | awk '{print $3}'
}
alias dimg='dimgf'
alias drimg='dimgf'
# shellcheck disable=2027,2086
alias dimg___description="docker images | grep "$1" | awk '{print $3}'"

# minikube/Kubernetes
alias mk='minikube'
alias mkss='minikube status'
alias mkp='minikube profile'
alias mkpd='minikube profile minikube'
alias mkpl='minikube profile list'
alias mks='minikube start -p'
alias mksd='minikube start -p minikube'
alias mkst='minikube stop -p'
alias mkstd='minikube stop -p minikube'
alias mksv='minikube service'
alias mkrm='minikube delete -p'
alias mkrmd='minikube delete -p minikube'
alias mkd='minikube dashboard'
alias mkt='minikube tunnel &'
alias mki='minikube image load'
alias kb='kubectl'
alias kbg='kubectl get --namespace'
alias kbgp='kubectl get pod --namespace'
alias kbgpd='kubectl get pod --namespace default'
alias kbgn='kubectl get nodes'
alias kbga='kubectl get all --namespace'
alias kbgad='kubectl get all --namespace default'
alias kbgaa='kubectl get all --all-namespaces'
alias kbgi='kubectl get ingress --namespace'
alias kbgid='kubectl get ingress --namespace default'
alias kbgns='kubectl get namespaces'
alias kbgd='kubectl get deployments --namespace'
alias kbgdd='kubectl get deployments --namespace default'
alias kbgs='kubectl get services --namespace'
alias kbgsd='kubectl get services --namespace default'
alias kbapp='kubectl apply --namespace'
alias kbappd='kubectl apply --namespace default'
alias kbappd='kubectl apply --namespace default'
alias kbappf='kubectl apply --namespace -f'
alias kbappfd='kubectl apply --namespace default -f'
alias kbd='kubectl describe --namespace'
alias kbdd='kubectl describe --namespace default'
alias kbrm='kubectl delete --namespace'
alias kbrmd='kubectl delete --namespace default'
alias kbrmp='kubectl delete pods --namespace'
alias kbrmpd='kubectl delete pods --namespace default'
alias kbrma='kubectl delete all --all --namespace'
alias kbrmad='kubectl delete all --all --namespace default'
alias kbrmn='kubectl delete namespace'
alias kbex='kubectl exec --namespace'
alias kbexd='kubectl exec --namespace default'
alias kbp='kubectl expose --namespace'
alias kbpd='kubectl expose --namespace default'
alias kbcn='kubectl create namespace'
alias kbc='kubectl create --namespace'
alias kbcd='kubectl create --namespace default'
alias kbpf='kubectl port-forward --namespace'
alias kbpfd='kubectl port-forward --namespace default'
alias kbe='kubectl edit --namespace'
alias kbed='kubectl edit --namespace default'
alias kbr='kubectl run --namespace'
alias kbrd='kubectl run --namespace default'
alias kbcg='kubectl config --namespace'
alias kbs='kubectl scale --namespace'
alias kbsd='kubectl scale --namespace default'

alias ngrokd='ngrok http'

alias ug='clear && sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y'

# vim
alias vi='/usr/bin/vim'
alias vimdiff="nvim -d"
alias v="nvim"
alias v.="nvim ."
alias svim='sudo -E nvim'
alias sv='sudo -E nvim'
alias vmin='nvim -u ~/.config/nvim/settings-min.vim'
alias vm='nvim -u ~/.config/nvim/settings-min.vim'
alias nvl="VIM_USE_COC=1 nvim "
# set vim theme and background per shell session
# unset
alias vt.='export EBNIS_VIM_THEME='
# vim-one
alias vt1d='export EBNIS_VIM_THEME=vim-one EBNIS_VIM_THEME_BG=d'
alias vt1l='export EBNIS_VIM_THEME="vim-one" EBNIS_VIM_THEME_BG=l'
# vim-gruvbox8
alias vt8d='export EBNIS_VIM_THEME=vim-gruvbox8 EBNIS_VIM_THEME_BG=d'
alias vt8l='export EBNIS_VIM_THEME=vim-gruvbox8 EBNIS_VIM_THEME_BG=l'
# vim-solarized8
alias vtsd='export EBNIS_VIM_THEME=vim-solarized8 EBNIS_VIM_THEME_BG=d'
alias vtsl='export EBNIS_VIM_THEME=vim-solarized8 EBNIS_VIM_THEME_BG=l'
# Set vim fuzzy finder
alias vff.='export EBNIS_VIM_FUZZY_FINDER='
alias vfff='export EBNIS_VIM_FUZZY_FINDER=fzf'
alias vffc='export EBNIS_VIM_FUZZY_FINDER=vim-clap'
alias npacker="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias packerinstall="rm -rf $HOME/.local/share/nvim \
  && rm -rf $HOME/dotfiles/config/nvim/plugin/packer_compiled.lua \
  && git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim"
alias packerinstall="rm -rf $HOME/.local/share/nvim \
  && rm -rf $HOME/dotfiles/config/nvim/plugin/packer_compiled.lua"

remove_vim_sessionf() {
  local ME
  local filename
  local absolute_path

  ME=$(pwd)
  filename="${ME//\//%}"
  absolute_path="$HOME/.vim/session/$filename.vim"
  rm "$absolute_path"
}
alias remove_vim_session=remove_vim_sessionf
alias rmvs=remove_vim_sessionf
alias remove_vim_undo='rm -rf $HOME/.vim/undodir/*'
alias rmvu='remove_vim_undo'

# tmux
alias ta='tmux a -t'
alias tad='tmux a -d -t'
alias tap='cd ~/projects/php && tmux a -t php'
alias tls='tmux ls'
alias tp='rm -rf $HOME/.tmux/resurrect/pane_contents.tar.gz'
alias tn='rm -rf $HOME/.tmux/resurrect/pane_contents.tar.gz && tmux new -s'
alias tndot='cd ~/dotfiles && tn dot'
alias tdot='cd ~/dotfiles && tn dot'
alias tnd='cd ~/dotfiles && tn dot'
alias tks='tmux kill-session -t'
alias tkss='tmux kill-server'
alias ts='$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'

runf() {
  local name
  if [[ -e "./run" ]]; then
    name="./run"
  else
    name="./run.sh"
  fi

  bash "$name" "$@"
}

alias rrun='runf'
alias runn='runf'
alias rn='runf'
alias r='runf'

# Save bash history per tmux pane
if [[ $TMUX_PANE ]]; then
  hist_dir="$HOME/.bash_histories"

  if [[ ! -d "$hist_dir" ]]; then
    mkdir "$hist_dir"
  fi

  hist_file="$hist_dir/.bash_history_tmux_${TMUX_PANE:1}"
  HISTFILE="$hist_file"

  if [[ ! -e "$hist_file" ]]; then
    touch "$hist_file"
  fi
fi

# rsync
alias rsynca='rsync -avzP --delete'
alias rsyncd='rsync -avzP --delete --dry-run'

# GIT
alias gss='git status'
# alias gst='git stash'
# alias gsp='git stash pop'
alias gsl='git stash list'
# there is a debian package gsc = gambc
alias gsc='git stash clear'
alias gcma='git commit --amend'
alias gcma='git commit -a'
alias gcme='git commit --amend --no-edit'
alias gcamupm='git commit -am "updated" && git push github master'
alias ga.='git add .'
alias gp='git push'
alias gpgm='git push github master'
# The following command has serious caveats: see wiki/git.md
# deliberately put an error: stash1 instead of stash so that user is forced
# to edit command and put stash message
alias gsstaged='git stash1 push -m "" -- $(git diff --staged --name-only)'
alias gcm='git commit'
alias grb='git rebase -i'
# debian package gpodder=gpo
alias gpo='git push origin'
alias gpf='git push --force-with-lease origin'
alias glone='git log --oneline'
alias gconflict='git diff --name-only --diff-filter=U'
alias gwt='git worktree'
# debian package gsa = gwenhywfar-tools
gsa() {
  git stash apply "stash@{$1}"
}

gsd() {
  git stash drop "stash@{$1}"
}

# python
alias py='python'

alias py-activate='. venv/bin/activate || . .venv/bin/activate'
alias pyactivate='py-activate'
alias pyactivate.='py-activate'
alias activatepy='py-activate'
alias activatepy.='py-activate'

alias ..='cd ..'
alias 2.='cd ../..'
alias 3.='cd ../../..'
alias 4.='cd ../../../..'
alias .2=2.
alias .3=3.
alias .4=4.
alias C="clear && printf '\e[3J'"
# debian package `lrzsz`
alias rb='sudo reboot'
alias scouser='sudo chown -R $USER:$USER'
alias cdo='mkdir -p $HOME/projects/0 && cd $HOME/projects/0'
alias cdp='mkdir -p $HOME/projects && cd $HOME/projects'
alias eshell='source ~/.bashrc'
alias cpr='cp -r'

mdf() {
  mkdir -p "$1"
  # shellcheck disable=2103,2164
  cd "$1"
}

alias mdc='mdf'
alias md='mkdir -p'

# https://unix.stackexchange.com/a/179852
# Make bash history unique

make_history_unique() {
  tac "$HISTFILE" | awk '!x[$0]++' >/tmp/tmpfile &&
    tac /tmp/tmpfile >"$HISTFILE" &&
    rm /tmp/tmpfile
}
alias hu='make_history_unique'
# also https://unix.stackexchange.com/a/613644

setenvs() {

  # TODO: can I write a project such as
  # https://github.com/andrewmclagan/react-env so users can set environment
  # vars based on shell type on different OSes - linux, Mac, windows?

  local path
  path="$1"

  # Check for path 3 levels deep.
  if ! [[ -e "$path" ]]; then
    path="../$path"

    if ! [[ -e "$path" ]]; then
      path="../$path"
    fi
  fi

  set -a
  # shellcheck disable=1090
  . "$path"
  set +a
  # set -o allexport; source "$1"; set +o allexport
}
alias se='setenvs'
alias e='setenvs'

alias rebar='rebar3'

###### END COMMONS ##################

# skip the java dependency during installation
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
# Do not build erlang docs when installing with
# asdf cos it's slow and unstable
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_MANPAGES=
export KERL_INSTALL_HTMLDOCS=
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
pathmunge "$GEM_HOME/bin"
# Do not use PHP PEAR when installing PHP with asdf
export PHP_WITHOUT_PEAR='yes'

ggc() {
  google-chrome -incognito &
  disown
}

# yarn
alias yw='yarn workspace'
alias yW='yarn -W'
alias ys='yarn start'
alias yn='yarn nps'
alias ylsp='yarn list --pattern'
alias ywhy='yarn why'
alias ycw='clear && DISABLE_LARAVEL_MIX_NOTIFICATION=1 yarn watch'

# TMUX split panes and windows
splitp() {
  if [[ "$1" == '-h' ]]; then
    echo "Usage:"
    echo "splitp absolute_path window_name"
    return
  fi

  if [[ -n "$1" ]]; then
    local dir="$1"
  else
    local dir="$PWD"
  fi

  local window_name="$2"

  # shellcheck disable=2164
  cd "$dir"

  tmux rename-window "$window_name" \
    \; splitw -c "$dir" -h -p 46 \
    \; splitw -b -p 40 \
    \; splitw -t 3 -b -p 45 \
    \; splitw -t 4 -b -p 55 \
    \; select-pane -t 2 \
    \; send-keys 'nvim ,' C-m \
    \; new-window -c "$dir" \
    \; splitw -c "$dir" -h -p 45 \
    \; splitw -t 1 -p 60 \
    \; splitw -p 45 \
    \; splitw -t 4 -p 87 \
    \; splitw -p 85 \
    \; splitw -p 70 \
    \; splitw \
    \; select-pane -t 1 \
    \; send-keys 'cd storage/logs && clear' C-m \
    \; select-pane -t 2 \
    \; send-keys 'nvim ,' C-m \
    \; select-pane -t 3 \
    \; send-keys 'cd storage/app/public && clear' C-m \
    \; select-pane -t 4 \
    \; rename-window "${window_name}-L" \
    \; last-window \
    \; select-pane -t 5 \
    \; send-keys 'yarn && clear' C-m \
    \; select-pane -t 1 \
    \; send-keys 'clear' C-m
}

alias exshell='export SHELL=/usr/bin/bash'
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias cdd='cd $HOME/dotfiles'
alias pw='prettier --write'
alias hb='sudo systemctl hibernate'
alias sd='sudo shutdown now'
alias luamake=/home/kanmii/.local/bin/lua/sumneko/lua-language-server/3rd/luamake/luamake

alias scmstorage='sudo chmod -R 777 storage'

ltf() {
  lt --subdomain "$1" --port "$2" &
}

if [ -x "$(command -v sort-package-json)" ]; then
  alias spj='sort-package-json'
fi

if [ -x "$(command -v php)" ]; then
  # debian pkg bsdgames
  alias sail='./vendor/bin/sail'
  alias sailartisan='./vendor/bin/sail artisan'

  alias artisan='php artisan'
fi

pathmunge "/usr/lib/dart/bin" "after"

# if [ -d "$HOME/.pyenv" ]; then
#   export PYENV_ROOT="$HOME/.pyenv"
#   pathmunge "$PYENV_ROOT"
#
#   if command -v pyenv 1>/dev/null 2>&1; then
#     eval "$(pyenv init -)"
#
#     if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
#       eval "$(pyenv virtualenv-init -)"
#     fi
#   fi
# fi

if [ -d "$HOME/.fzf" ]; then
  # ripgrep
  export RG_IGNORES="!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}"
  RG_OPTIONS="--hidden --follow --glob '$RG_IGNORES'"

  export FZF_DEFAULT_OPTS="--layout=reverse --border"
  # Use git-ls-files inside git repo, otherwise rg
  export FZF_DEFAULT_COMMAND="rg --files $RG_OPTIONS"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_COMPLETION_TRIGGER=',,'

  _fzf_compgen_dir() {
    rg --files "$RG_OPTIONS"
  }

  _fzf_compgen_path() {
    rg --files --hidden --follow --glob $RG_IGNORES
  }

  FZF_PREVIEW_APP="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"

  # shellcheck disable=2139
  alias ff="fzf $FZF_PREVIEW_APP"
  alias eff='env | fzf'
  alias aff='alias | fzf'
fi

rel_asdf_elixirf() {
  local elixir_version="$1"

  if [[ -z "$elixir_version" ]]; then
    printf "The elixir version is required.\n"
    return 0
  fi

  local install_dir="$HOME/projects/elixir/elixir-ls"

  if ! [[ -d "$install_dir" ]]; then
    git clone https://github.com/elixir-lsp/elixir-ls.git "$install_dir"
  fi

  local release_dir="$install_dir/elixir_ls-releases/$elixir_version"
  mkdir -p "$release_dir"

  # shellcheck disable=SC2164
  cd "$install_dir"

  printf '\n\n\t# Update to the latest code base of elixir LSP server.\n'
  git pull origin master

  printf '\n\n\t# Remove the previous dependencies and recompile.\n'
  rm -rf deps _build

  printf '\n\n\t# Fetch current dependencies and compile the code.\n'
  # shellcheck disable=SC1010
  mix do deps.get, compile

  printf '\n\n\t\t# Create the language server scripts.\n'
  mix elixir_ls.release -o "$release_dir"

  # Print the path to the language server script so we can use it in LSP
  # client.
  printf '\n\n\nThe path to the language server script:'
  printf '\n\t%s\n\n' "$release_dir/language_server.sh"

  # shellcheck disable=2103,2164
  cd -
}

rel_asdf_elixir_exists_f() {
  local elixir_version="$1"

  local server_path="$HOME/projects/elixir/elixir-ls/elixir_ls-releases/$elixir_version/language_server.sh"

  printf "\n%s\n\n" "$server_path"

  if [[ -e "$server_path" ]]; then
    printf "Exists\n\n"
  else
    printf "Does not exist\n\n"
  fi
}

alias rel_asdf_elixir=rel_asdf_elixirf
alias rel_asdf_elixir_exists=rel_asdf_elixir_exists_f
alias mxg='mix deps.get'
alias mxgc='mix do deps.get, compile'
alias mxc='mix compile'
alias mxer='mix ecto.reset'
alias mxes='mix ecto.setup'
alias mxem='mix ecto.migrate'
alias mxec='mix ecto.create'
alias mxed='mix ecto.drop'
alias mxt='mix test'
alias mxn='mix new'
alias mxps='mix phx.server'
alias mxti='mix test.interactive'
alias iexmxps='iex -S mix phx.server'
alias iexmx='iex -S mix'

##################### mysql

mysql_startf() {
  local current
  local path

  current="$(asdf current mysql | awk '{print $2}')"
  path="$HOME/mysql_data_${current//./_}"

  if [[ ! -e "$path" ]]; then
    printf "\n\nDirectory data of the mysql version does not exist.\n\n"
    exit 1
  fi

  mysqld_safe --datadir="$path" &
  disown
}

alias mysql_start='mysql_startf'
alias start_mysql='mysql_startf'

# -----------------------------------------------------------------------------
# TERRAFORM
# -----------------------------------------------------------------------------

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfpd='terraform plan -destroy'
alias tfa='terraform apply'
alias tfar='terraform apply -replace'
alias tfaa='terraform apply -auto-approve'
alias tfsl='terraform state list'
alias tfss='terraform state show'
alias tfs='terraform show'
alias tfd='terraform destroy'
alias tfdt='terraform destroy -target'
alias tfda='terraform destroy -auto-approve'
alias tfc='terraform console'

alias ng="sudo nginx -g 'daemon off; master_process on;' &"
alias ngd="sudo nginx -g 'daemon on; master_process on;'"
alias ngk='pgrep -f nginx | xargs sudo kill -9'
alias ngkill='pgrep -f nginx | xargs sudo kill -9'
alias ngstop='pgrep -f nginx | xargs sudo kill -9'

if [ -d "$HOME/.asdf" ]; then
  # shellcheck disable=2086,1090
  . $HOME/.asdf/asdf.sh
  # shellcheck disable=2086,1090
  . $HOME/.asdf/completions/asdf.bash

  if command -v asdf 1>/dev/null 2>&1; then
    TS_SERVER_GBLOBAL_LIBRARY_PATH="$HOME/.asdf/installs/nodejs/$(asdf current nodejs | awk '{print $2}')/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js"
    export TS_SERVER_GBLOBAL_LIBRARY_PATH
  fi

  if [[ -f "$HOME/.asdf/plugins/java/set-java-home.bash" ]]; then
    # shellcheck disable=1090
    . "$HOME/.asdf/plugins/java/set-java-home.bash"
  fi
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
  # following needed so that cypress browser testing can work in WSL2
  export DISPLAY="$WSL_HOST_IP:0"
  # without the next line, linux executables randomly fail in TMUX in WSL
  # export PATH="$PATH:/c/WINDOWS/system32"

  alias e.='/c/WINDOWS/explorer.exe .'
  alias wslexe='/c/WINDOWS/system32/wsl.exe'
  alias wsls="wslexe --shutdown"
  alias ubuntu20='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu-20.04'
  alias ubuntu18='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu'
  alias nameserver="sudo $HOME/dotfiles/etc/wsl-nameserver.sh"

  # This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
  # up memory, this command will free your memory after about 20-30 seconds.
  #   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
  # alias dpc="clear && sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
  # shellcheck disable=2139
  alias dpc="sudo $HOME/dotfiles/etc/wsl-drop-caches.sh"

  if [ -x "$(command -v docker)" ]; then
    # export DOCKER_HOST="unix:///mnt/wsl/shared-docker/docker.sock"

    # https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/

    # Start Docker daemon automatically when logging in.
    DOCKER_DAEMON_RUNNING=$(pgrep -f dockerd)

    if [ -z "$DOCKER_DAEMON_RUNNING" ]; then
      sudo dockerd >/dev/null 2>&1 &
      disown
    fi
  fi

  if [[ -z "$USE_WSL_INTERNET_RESOLVER" ]]; then
    if { ! [[ -e /etc/resolv.conf ]]; } || { ! grep -q 1.1.1.1 /etc/resolv.conf; }; then
      sudo "$HOME/dotfiles/etc/wsl-nameserver.sh"
    fi
  fi

fi

# Start postgres automatically when logging in.
# if [ -x "$(command -v pg_ctl)" ]; then
#   POSTGRES_RUNNING=$(pgrep -f postgres)
#
#   if [ -z "$POSTGRES_RUNNING" ]; then
#     pg_ctl start >/dev/null 2>&1 &
#     disown
#   fi
# fi

# The minimal, blazing-fast, and infinitely customizable prompt for any shell!
# https://github.com/starship/starship
# eval "$(starship init bash)" ## will use only in fish shell for now

# Set the title string at the top of your current terminal window or terminal window tab
# https://github.com/mgedmin/scripts/blob/master/title
# https://discourse.gnome.org/t/rename-terminal-tab/3200/5
set-title() {
  # usage: set-title string
  # Works for xterm clones
  printf "\033]0;%s\a" "$*"
}

MY_JAVA_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
if [ -d "$MY_JAVA_PATH" ]; then
  export JAVA_HOME="$MY_JAVA_PATH"
  pathmunge "$JAVA_HOME/bin"
fi

MY_ANDROID_STUDIO_PATH="$HOME/projects/android-studio"
if [ -d "$MY_ANDROID_STUDIO_PATH" ]; then
  export ANDROID_HOME="$MY_ANDROID_STUDIO_PATH"
  pathmunge "$ANDROID_HOME"
  pathmunge "$ANDROID_HOME/bin"
fi

MY_ANDROID_SDK_PATH="$HOME/projects/android-sdk"
if [ -d "$MY_ANDROID_SDK_PATH" ]; then
  pathmunge "$MY_ANDROID_SDK_PATH/tools"
  pathmunge "$MY_ANDROID_SDK_PATH/tools/bin"
  pathmunge "$MY_ANDROID_SDK_PATH/platform-tools"
fi

MY_FLUTTER_PATH="$HOME/projects/flutter"
if [ -d "$MY_FLUTTER_PATH" ]; then
  pathmunge "$MY_FLUTTER_PATH/bin"
  pathmunge "$MY_FLUTTER_PATH/.pub-cache/bin"
fi

# Automatically start dbus
# sudo /etc/init.d/dbus start &>/dev/null

if [ -d "$HOME/.poetry" ]; then
  pathmunge "$HOME/.poetry/bin"
  alias ptys='poetry shell'
  alias pty='poetry'
fi

#------------------------------------------------------------------------------
# Complete all bash aliases
# See https://github.com/cykerway/complete-alias#faq
#------------------------------------------------------------------------------
if [[ -e "$HOME/.bash_completion" && -e "$HOME/complete_alias.sh" ]]; then
  complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi
