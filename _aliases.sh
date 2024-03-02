#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155,2139,2086,2033

declare -A alias_map=()

# -----------------------------------------------------------------------------
# DOCKER
# -----------------------------------------------------------------------------
if command -v docker &>/dev/null; then
  export DOCKER_BUILDKIT=1
  export DOCKER0="$(ip route | awk '/docker0/ { print $9 }')"

  # shellcheck disable=2230
  export _docker_bin="$(which docker)"

  # shellcheck disable=2032
  function docker {
    if [[ "${1}" == 'compose' ]] &&
      [[ -n "${DOCKER_COMPOSE_FILENAME}" ]] &&
      [[ -e "${DOCKER_COMPOSE_FILENAME}" ]]; then
      "${_docker_bin}" compose \
        --file "${DOCKER_COMPOSE_FILENAME}" \
        "${@:2}"
    else
      "${_docker_bin}" "${@}"
    fi
  }
  export -f docker

  function docker-compose {
    docker compose "${@}"
  }

  export -f docker-compose

  alias_map[d]='docker'
  # docker remove all containers
  # shellcheck disable=2016
  alias_map[drac]='docker rm $(docker ps -a -q)'
  # shellcheck disable=2016
  alias_map[dracf]='drac --force'
  alias_map[drac__description]='docker rm all containers force'
  alias_map[drim]='docker rmi'
  alias_map[dim]='docker images'
  alias_map[dps]='docker ps'
  alias_map[dpsa]='docker ps -a'
  alias_map[dc]='docker compose'
  alias_map[dcp]='docker compose'
  alias_map[dce]='docker compose exec'
  alias_map[de]='docker exec -it'
  alias_map[dcu]='docker compose up'
  alias_map[dcub]='docker compose up --build'
  alias_map[dcud]='docker compose up -d'
  alias_map[dcb]='docker compose build'
  alias_map[db]='docker build -t'
  alias_map[dcl]='docker compose logs'
  alias_map[dclf]='docker compose logs -f'
  alias_map[dck]='docker compose kill'
  alias_map[dcd]='docker compose down'
  alias_map[dcdv]='docker compose kill && docker compose down -v'
  # shellcheck disable=2016
  alias_map[dvra]='docker volume rm $(docker volume ls -q)'
  alias_map[dvls]='docker volume ls'
  alias_map[dvlsq]='docker volume ls -q'
  alias_map[ds]='sudo service docker start'
  alias_map[dn]='docker network'
  alias_map[dnls]='docker network ls'
  alias_map[dcps]='docker compose ps'
  alias_map[dcpsa]='docker compose ps -a'
  alias_map[drmlogs__description]='docker rm logs containers..'
  alias_map['d-dangling']='dim -qf dangling=true | xargs docker rmi -f 2>/dev/null'
  alias_map[ddangling]='d-dangling'
  alias_map[dcrml]='dcps -aq | xargs drmlogs'

  # docker compose up --daemon and logs --follow
  _dcudlf() {
    docker compose up -d "$@"
    docker compose logs -f "$@"
  }

  alias_map[dcudlf]='_dcudlf'
  alias_map[dcudfl]='_dcudlf'
  alias_map[dcudlf__description]='docker up daemon and logs'

  # docker compose restart and logs --follow
  dcrsf() {
    docker compose restart "$@"
    docker compose logs -f "$@"
  }
  alias_map[dcrs]='dcrsf'
  alias_map[dcrs__description]='docker compose restart then logs'

  dimgf() {
    if [ -n "$1" ]; then
      docker images |
        grep -P "$1"
    else
      printf 'false'
    fi
  }

  drimgf() {
    docker images |
      grep -P "$1" |
      awk '{print $3}' |
      xargs docker rmi
  }

  alias_map[dimg]='dimgf'
  alias_map[drimg]='drimgf'
  alias_map[dimg___description]='docker images grep'

  _docker_compose_build_no_cache() {
    docker compose build "${@}" --no-cache
  }

  alias_map[dcbn]='_docker_compose_build_no_cache'
  alias_map[dcbn___description]='docker build no cache'

  _docker_image_repo_tag_merge_func() {
    local _pattern=""

    for arg in "$@"; do
      _pattern+="($arg).*"
    done

    local _result
    _result="$(
      docker image ls |
        awk -v p="$_pattern" '
          BEGIN{
              OFS=":";
          }
          match($0, p) {print $1,$2}
        '
    )"

    if [[ -n "$_result" ]]; then
      echo -n "$_result" |
        xclip -selection c

      echo "$_result"
    fi
  }

  alias dimrt='_docker_image_repo_tag_merge_func'
  alias dimrt__description='_docker_image_repo_tag_merge_func dimm docker image repo tag merge/join'
fi

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
# TERRAFORM
# -----------------------------------------------------------------------------

if command -v terraform &>/dev/null; then
  alias_map[tf]='terraform'
  alias_map[tfi]='terraform init'
  alias_map[tfp]='terraform plan'
  alias_map[tfpd]='terraform plan -destroy'
  alias_map[tfa]='terraform apply'
  alias_map[tfar]='terraform apply -replace'
  alias_map[tfaa]='terraform apply -auto-approve'
  alias_map[tfstl]='terraform state list'
  alias_map[tfsts]='terraform state show' # terraform state show [options] ADDRESS
  alias_map[tfs]='terraform show'
  alias_map[tfd]='terraform destroy'
  alias_map[tfdt]='terraform destroy -target'
  alias_map[tfda]='terraform destroy -auto-approve'
  alias_map[tfdta]='terraform destroy -auto-approve -target'
  alias_map[tfdat]='tfdta'
  alias_map[tfc]='terraform console'
  alias_map[tfv]='terraform validate'
  alias_map[tfo]='terraform output'
fi

# -----------------------------------------------------------------------------
# END TERRAFORM
# -----------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Complete all bash aliases
# See https://github.com/cykerway/complete-alias#faq
#------------------------------------------------------------------------------
for key in "${!alias_map[@]}"; do
  val="${alias_map[$key]}"
  eval "alias $key='$val'"
  complete -F _complete_alias "$key" 2</dev/null || true
done

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
  local _script="${HOME}/dotfiles/provision-machine/ubuntu-server.sh"

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

export VSCODE_BINARY="/c/Users/$USERNAME/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"
alias c="$VSCODE_BINARY" # vs code
