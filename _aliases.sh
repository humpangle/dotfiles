#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155,2139,2086,2033

# Alacritty allows us to invoke only one instance from macos applications. This workaround is needed so we can have
# multiple instances.
alacritty_bin_="$(command -v Alacritty 2>/dev/null)"

if [ -z "$alacritty_bin_" ]; then
  alacritty_bin_="$(command -v alacritty 2>/dev/null)"
fi

if [ -n "$alacritty_bin_" ]; then
  __alacritty() {
    if _is_darwin; then
      env -i \
        HOME="$HOME" \
        bash -l -c \
        "$alacritty_bin_ &>/dev/null" &
      disown
    elif [ -n "$ALACRITTY_SOCKET" ]; then # Invoked from a running alacritty instance
      $alacritty_bin_ msg create-window
    else
      # env -i \ # ---> can't seem to be able to refresh environment
      bash -l -c \
        "$alacritty_bin_ &>/dev/null" &
      disown
    fi
  }

  alias ala='__alacritty'
fi

declare -A alias_map=()

# -----------------------------------------------------------------------------
# # MINIKUBE
# # -----------------------------------------------------------------------------
if command -v minikube &>/dev/null; then
  alias_map[mk]='minikube'
  alias_map[mkss]='minikube status'
  alias_map[mkp]='minikube profile'
  alias_map[mkpd]='minikube profile minikube'
  alias_map[mkpl]='minikube profile list'
  alias_map[mks]='minikube start -p'
  alias_map[mksd]='minikube start -p minikube'
  alias_map[mkst]='minikube stop -p'
  alias_map[mkstd]='minikube stop -p minikube'
  alias_map[mksv]='minikube service'
  alias_map[mkrm]='minikube delete -p'
  alias_map[mkrmd]='minikube delete -p minikube'
  alias_map[mkd]='minikube dashboard'
  alias_map[mkt]='minikube tunnel &'
  alias_map[mki]='minikube image load'
fi

# -----------------------------------------------------------------------------
# # KUBERNETES
# # -----------------------------------------------------------------------------
if command -v kubectl &>/dev/null; then
  alias_map[k]='kubectl'
  alias_map[kbg]='kubectl get --namespace'
  alias_map[kbgp]='kubectl get pod --namespace'
  alias_map[kbgpd]='kubectl get pod --namespace default'
  alias_map[kbgn]='kubectl get nodes'
  alias_map[kbga]='kubectl get all --namespace'
  alias_map[kbgad]='kubectl get all --namespace default'
  alias_map[kbgaa]='kubectl get all --all-namespaces'
  alias_map[kbgi]='kubectl get ingress --namespace'
  alias_map[kbgid]='kubectl get ingress --namespace default'
  alias_map[kbgns]='kubectl get namespaces'
  alias_map[kbgd]='kubectl get deployments --namespace'
  alias_map[kbgdd]='kubectl get deployments --namespace default'
  alias_map[kbgs]='kubectl get services --namespace'
  alias_map[kbgsd]='kubectl get services --namespace default'
  alias_map[kbapp]='kubectl apply --namespace'
  alias_map[kbappd]='kubectl apply --namespace default'
  alias_map[kbappd]='kubectl apply --namespace default'
  alias_map[kbappf]='kubectl apply --namespace -f'
  alias_map[kbappfd]='kubectl apply --namespace default -f'
  alias_map[kbd]='kubectl describe --namespace'
  alias_map[kbdd]='kubectl describe --namespace default'
  alias_map[kbrm]='kubectl delete --namespace'
  alias_map[kbrmd]='kubectl delete --namespace default'
  alias_map[kbrmp]='kubectl delete pods --namespace'
  alias_map[kbrmpd]='kubectl delete pods --namespace default'
  alias_map[kbrma]='kubectl delete all --all --namespace'
  alias_map[kbrmad]='kubectl delete all --all --namespace default'
  alias_map[kbrmn]='kubectl delete namespace'
  alias_map[kbex]='kubectl exec --namespace'
  alias_map[kbexd]='kubectl exec --namespace default'
  alias_map[kbp]='kubectl expose --namespace'
  alias_map[kbpd]='kubectl expose --namespace default'
  alias_map[kbcn]='kubectl create namespace'
  alias_map[kbc]='kubectl create --namespace'
  alias_map[kbcd]='kubectl create --namespace default'
  alias_map[kbpf]='kubectl port-forward --namespace'
  alias_map[kbpfd]='kubectl port-forward --namespace default'
  alias_map[kbe]='kubectl edit --namespace'
  alias_map[kbed]='kubectl edit --namespace default'
  alias_map[kbr]='kubectl run --namespace'
  alias_map[kbrd]='kubectl run --namespace default'
  alias_map[kbcg]='kubectl config --namespace'
  alias_map[kbs]='kubectl scale --namespace'
  alias_map[kbsd]='kubectl scale --namespace default'

  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#enable-shell-autocompletion
  # complete -o default -F __start_kubectl kb

  # -----------------------------------------------------------------------------
  # START Kind for Kubernettes
  # -----------------------------------------------------------------------------
  if command -v kind &>/dev/null; then
    alias_map[kd]='kind'
  fi
  # -----------------------------------------------------------------------------
  # END Kind for Kubernettes
  # -----------------------------------------------------------------------------

  # -----------------------------------------------------------------------------
  # START helm for Kubernettes
  # -----------------------------------------------------------------------------
  if command -v helm &>/dev/null; then
    alias_map[h]='helm'
  fi
  # -----------------------------------------------------------------------------
  # END helm for Kubernettes
  # -----------------------------------------------------------------------------
fi

# -----------------------------------------------------------------------------
# START microk8s for Kubernettes
# -----------------------------------------------------------------------------
if command -v microk8s &>/dev/null; then
  alias_map[m8]='microk8s'
  alias_map[mk]='microk8s kubectl'
fi
# -----------------------------------------------------------------------------
# END microk8s for Kubernettes
# -----------------------------------------------------------------------------

alias_map[ctl]='systemctl --user'
alias_map[sctl]='sudo systemctl'

if command -v sqlite3 &>/dev/null; then
  alias_map[sq3]='sqlite3'
fi

# -----------------------------------------------------------------------------
# START PYTHON POETRY
# -----------------------------------------------------------------------------
alias py='python'

if command -v poetry &>/dev/null; then
  alias_map['pt']='poetry'
fi
# -----------------------------------------------------------------------------
# END PYTHON POETRY
# -----------------------------------------------------------------------------

if command -v tmux &>/dev/null; then
  export TP="${TMUX_PANE}"

  alias kts='{ ebnis-save-tmux.sh || true; } && tmux kill-server'
  alias ts='ebnis-save-tmux.sh'
  alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'

  _c_tmux_script="${DOTFILE_PARENT_PATH}/dotfiles/scripts/c-tmux"

  if [[ -e "$_c_tmux_script" ]]; then
    chmod 755 "$_c_tmux_script"

    alias st='c-tmux start_tmux'
    alias lst='c-tmux list'
    alias kt='c-tmux kill_tmux'
  fi

  unset _c_tmux_script
fi

# -----------------------------------------------------------------------------
# START multipass
# -----------------------------------------------------------------------------
if command -v multipass &>/dev/null; then
  alias_map[m]='multipass'
fi
# -----------------------------------------------------------------------------
# END multipass
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# START nvim
# -----------------------------------------------------------------------------
if command -v nvim &>/dev/null; then
  export EDITOR="nvim"

  # vim
  alias vi='/usr/bin/vim'
  alias vimdiff="nvim -d"
  alias v="nvim"
  alias v.="nvim ."
  alias sv="sudo -E nvim_sudo_e"
  alias vmin='nvim -u ~/.config/nvim/settings-min.vim'
  alias vm='nvim -u ~/.config/nvim/settings-min.vim'
  alias vc='nvim --clean'

  # set vim theme and background per shell session
  # unset
  # one theme
  alias vt1d='export EBNIS_VIM_THEME=one EBNIS_VIM_THEME_BG=d'
  alias vt1l='export EBNIS_VIM_THEME="one" EBNIS_VIM_THEME_BG=l'
  # gruvbox8 themes
  alias vtg8sd='export EBNIS_VIM_THEME=gruvbox8_soft EBNIS_VIM_THEME_BG=d'
  alias vtg8sl='export EBNIS_VIM_THEME=gruvbox8_soft EBNIS_VIM_THEME_BG=l'
  alias vtg8hd='export EBNIS_VIM_THEME=gruvbox8_hard EBNIS_VIM_THEME_BG=d'
  alias vtg8hl='export EBNIS_VIM_THEME=gruvbox8_hard EBNIS_VIM_THEME_BG=l'
  # solarized8 themes
  alias vts8d='export EBNIS_VIM_THEME=solarized8 EBNIS_VIM_THEME_BG=d'
  alias vts8l='export EBNIS_VIM_THEME=solarized8 EBNIS_VIM_THEME_BG=l'
  alias vts8hd='export EBNIS_VIM_THEME=solarized8_high EBNIS_VIM_THEME_BG=d'
  alias vts8hl='export EBNIS_VIM_THEME=solarized8_high EBNIS_VIM_THEME_BG=l'

  remove_vim_sessionf() {
    local ME
    local filename
    local absolute_path

    ME=$(pwd)
    filename="${ME//\//%}"
    absolute_path="$HOME/.vim/session/$filename.vim"
    rm -rf "$absolute_path"

    remove_vim_undof
  }
  alias remove_vim_session=remove_vim_sessionf
  alias rmvs=remove_vim_sessionf

  remove_vim_undof() {
    local ME
    local filename
    local absolute_path
    local prefix

    ME=$(pwd)
    filename="${ME//\//%}%"
    prefix="${HOME}/.vim/undodir"

    # shellcheck disable=2010
    mapfile -t filenames < <(ls -h "${prefix}" | grep -P "${filename}")
    for f in "${filenames[@]}"; do
      absolute_path="${prefix}/${f}"
      rm -rf "${absolute_path}"
    done
  }
  alias remove_vim_undo='remove_vim_undof'
  alias rmvu='remove_vim_undof'

  # shellcheck disable=SC2016
  export MANPAGER='nvim -c "%! col -b" -c "set ft=man nomod | let &titlestring=$MAN_PN"'
fi
# -----------------------------------------------------------------------------
# END nvim
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# START OLLAMA
# -----------------------------------------------------------------------------

if command -v ollama &>/dev/null; then
  alias_map[o]=ollama
fi

# -----------------------------------------------------------------------------
# END OLLAMA
# -----------------------------------------------------------------------------

_alias_map_complete() {
  #------------------------------------------------------------------------------
  # Complete all bash aliases
  # See https://github.com/cykerway/complete-alias#faq
  #------------------------------------------------------------------------------
  local -n _map=$1

  for key in "${!_map[@]}"; do
    val="${_map[$key]}"
    eval "alias $key='$val'"
    complete -F _complete_alias "$key" 2</dev/null || true
  done
}

_alias_map_complete alias_map

# -----------------------------------------------------------------------------
# ANSIBLE
# -----------------------------------------------------------------------------
if command -v ansible &>/dev/null; then
  alias an='ansible'
  alias ap='ansible-playbook'
fi
# -----------------------------------------------------------------------------
# END ANSIBLE
# -----------------------------------------------------------------------------

if ! command -v nps &>/dev/null; then
  alias nps='npm start'
fi

if command -v grep &>/dev/null; then
  function g {
    grep "${@}"
  }

  export -f g
fi

if command -v mongodb-compass &>/dev/null; then
  function mongoc {
    mongodb-compass &>/dev/null &
    disown
  }

  export -f mongoc
fi

##################### mysql

_mysql-dir() {
  local _data_dir="${MYSQL_DATA_DIR}"

  if [[ -n "${_data_dir}" ]]; then
    echo -n "${_data_dir}"
    return
  fi

  _data_dir="$(asdf current mysql | awk '{print $2}')"

  printf '%s' "$HOME/mysql_data_${_data_dir//./_}"
}

mysql-setupf() {
  local _data_dir

  _data_dir="$(_mysql-dir)"

  mkdir -p "${_data_dir}"
  mysqld --initialize-insecure --datadir="${_data_dir}"
  mysql_ssl_rsa_setup --datadir="${_data_dir}"
}

alias mysql-setup='mysql-setupf'
alias setup-mysql='mysql-setupf'

mysql-startf() {
  local _data_dir

  _data_dir="$(_mysql-dir)"

  if [[ ! -e "${_data_dir}" ]]; then
    printf "\n\nDirectory data of the mysql version, '%s', does not exist.\n\n" "${_data_dir}"
    return
  fi

  mysqld_safe --datadir="${_data_dir}" &
  disown
}

alias mysql-start='mysql-startf'
alias mysqls='mysql-startf'
alias start-mysql='mysql-startf'
alias smysql='mysql-startf'
# -----------------------------------------------------------------------------
# END MYSQL
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# START PROVISION MACHINE
# -----------------------------------------------------------------------------

function __pm {
  local _script="${DOTFILE_PARENT_PATH}/dotfiles/provision-machine/ubuntu-server.sh"

  if [[ ! -e "${_script}" ]]; then
    echo "Script \"${_script}\" does not exist. Exiting!"
    return
  fi

  chmod 755 "${_script}"

  "${_script}" "${@}"
}

alias _pm='__pm'
alias _pm----help='provison machine'

# -----------------------------------------------------------------------------
# END PROVISION MACHINE
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# START VSCODE
# -----------------------------------------------------------------------------

if _has_wsl; then
  export VSCODE_BINARY="/c/Users/$USERNAME/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"
else
  export VSCODE_BINARY="$(which code)"
fi

_____c_help() {
  read -r -d '' var <<'eof' || true
Launch visual studio code VSCODE. Usage:
  __c -h|--help
  __c [OPTIONS] <FILE_PATH> [ -- <vscode args> ]

By default, we launch vscode with a clean environment.

Options:
  -h,--help
    Print this help text and quit.
  -p,--preserve
    Preserve environment - do not launch with a clean environment.
  -d,--debug
    Print command that will be ran.

Examples:
  # Get help.
  __c --help
  __c -h

  # No arguments
  __c filepath

  # Preserve environment
  __c -p filepath
  __c --preserve filepath

  # Debug command
  __c -d filepath
  __c --debug filepath

  # Pass VsCode command line arguments
  __c filepath -- --status
eof

  echo -e "${var}"
}

__c() {
  : "___help___ _____c_help"

  local _preverve_env
  local _debug
  local _parsed
  local filepath_=

  if ! _parsed="$(
    getopt \
      --options=h,p,d \
      --longoptions=help,preserve,debug \
      --name "$0" \
      -- "$@"
  )"; then
    return
  fi

  eval set -- "$_parsed"

  while :; do
    case "$1" in
    --help | -h)
      _____c_help
      return
      ;;

    --preserve | -p)
      _preverve_env=1
      shift
      ;;

    --debug | -d)
      _debug=1
      shift
      ;;

    --)
      shift
      break
      ;;

    *)
      echo "Unknown option $1"
      _____c_help
      return
      ;;
    esac
  done

  filepath_="$1"

  if [ -z "$filepath_" ]; then
    echo -e "File path is required.\n"
    _____c_help
    return
  fi

  local vscode_args_=("${@:2}")

  filepath_="$(
    if command -v grealpath &>/dev/null; then grealpath "$filepath_"; else realpath $filepath_; fi
  )"

  local _cmd="$VSCODE_BINARY"

  if _has_wsl; then
    _cmd+=" --remote wsl+$WSL_DISTRO_NAME"
  fi

  _cmd+=" ${vscode_args_[*]} $filepath_ &>/dev/null"

  if [[ -n "$_debug" ]]; then
    echo -e "\n_preverve_env = $_preverve_env"
    echo -e "\nvscode args = ${vscode_args_[*]}"
    echo -e "\nCommand:\n$_cmd\n"
    return
  fi

  if [[ -n "$_preverve_env" ]]; then
    bash -lc \
      "$_cmd" &
  else
    env -i \
      HOME="$HOME" \
      bash -lc \
      "$_cmd" &
  fi

  disown
}
alias c="__c"

# Launch VS code and pick up environment variables.
alias ce="$VSCODE_BINARY"

# -----------------------------------------------------------------------------
# END VSCODE
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# TERRAFORM
# -----------------------------------------------------------------------------
if command -v terraform &>/dev/null; then
  alias tf='terraform'
fi
# -----------------------------------------------------------------------------
# END TERRAFORM
# -----------------------------------------------------------------------------

alias el='echo -e "\n# -----------------------------------------------------------------------------\n"'
alias elp='echo -e "\n# -----------------------------------------------------------------------------\n" >> p'
alias epl=elp

alias fm=vifm
alias sfm="sudo -E vifm_sudo_e --server-name vifm_root_1716773602"

alias up="sudo $DOTFILE_PARENT_PATH/dotfiles/_updd.sh"
alias open_webui="chmod +x $DOTFILE_PARENT_PATH/dotfiles/_open_webui && $DOTFILE_PARENT_PATH/dotfiles/_open_webui"

alias sudoe="bash ${DOTFILE_PARENT_PATH}/dotfiles/_sudoe"

_elixir_lexical_script="${DOTFILE_PARENT_PATH}/dotfiles/scripts/install-elixir-lexical"
if [[ -e "$_elixir_lexical_script" ]]; then
  alias ilexical="chmod 755 $_elixir_lexical_script && $_elixir_lexical_script"
fi
unset _elixir_lexical_script

_elixir_ls_script="${DOTFILE_PARENT_PATH}/dotfiles/scripts/c-elixir-ls"
if [[ -e "$_elixir_ls_script" ]]; then
  alias ielixir-ls="chmod 755 $_elixir_ls_script && $_elixir_ls_script"
fi
unset _elixir_ls_script

if [ -x "$(command -v sort-package-json)" ]; then
  alias spj='sort-package-json'
fi

# PHP SECTION
# Do not use PHP PEAR when installing PHP with asdf
# export PHP_WITHOUT_PEAR='yes'

if command -v php &>/dev/null; then
  _phpunit() {
    if command -v phpunit >/dev/null; then
      phpunit --testdox "$@"
    else
      ./vendor/bin/phpunit --testdox "$@"
    fi
  }

  alias php-unit='_phpunit'
  alias pu='_phpunit'

  # debian pkg bsdgames
  alias sail='./vendor/bin/sail'
  alias sailartisan='./vendor/bin/sail artisan'

  alias artisan='php artisan'

  alias scmstorage='sudo chmod -R 777 storage'

  alias cmp='composer'
  alias cmpi='composer install'
  alias cmpr='composer require'
  alias cmprd='composer require --dev'
  alias cmpd='composer dumpautoload -o'
fi

if command -v nginx &>/dev/null; then
  alias ng="sudo nginx -g 'daemon off; master_process on;' &"
  alias ngd="sudo nginx -g 'daemon on; master_process on;'"
  alias ngk='pgrep -f nginx | xargs sudo kill -9'
  alias ngkill='pgrep -f nginx | xargs sudo kill -9'
  alias ngstop='pgrep -f nginx | xargs sudo kill -9'
fi

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

if _is_linux && ! _has_termux; then
  # install with: `sudo apt-get install ssh-askpass-gnome ssh-askpass -y`
  # shellcheck disable=2155
  export SUDO_ASKPASS=$(command -v ssh-askpass)

  alias ug='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'

  # rsync
  alias rsynca='rsync -avzP --delete'
  alias rsyncd='rsync -avzP --delete --dry-run'

  alias scouser='sudo chown -R $USER:$USER'
  alias hb='sudo systemctl hibernate'
  alias sd='sudo shutdown now'
  alias sb='sudo reboot now'
  # debian package `lrzsz`
  alias rb='sudo reboot'

  _purge-systemd-service() {
    sudo systemctl stop "$1"
    sudo systemctl disable "$1"
    sudo rm -rf /etc/systemd/system/"$1"
    sudo rm -rf /usr/lib/systemd/system/"$1"
    sudo systemctl daemon-reload
    sudo systemctl reset-failed
  }
  alias purge-systemd-service='_purge-systemd-service'
fi

if _has_termux; then
  alias ug='pkg update && pkg upgrade'
fi

if command -v livebook &>/dev/null; then
  alias lb=livebook
fi
