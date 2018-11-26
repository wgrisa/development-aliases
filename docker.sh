alias c='docker-compose'
alias cb='docker-compose build'
alias cup='docker-compose up'
alias cr='docker-compose run --rm'
alias cps='docker-compose ps'
alias clogs='docker-compose logs'

dreset() {
  docker stop $(docker ps -q) || true
  docker rm $(docker ps -aq) || true
}

dresetf() {
  docker rm -f $(docker ps -aq) || true
}

dps() {
  local OS=$(uname -r)

  local SEARCH="$1"
  local ARGS="$2"
  local FILTER=""

  if [[ $SEARCH == \-* ]]; then
    SEARCH=""
    ARGS="$1"
  fi

  if [[ " ${ARGS[@]} " =~ " -a " ]]; then
    FILTER="-a"
  elif [[ " ${ARGS[@]} " =~ " -e " ]]; then
    FILTER="--filter status=exited"
  else
    FILTER="--filter status=running"
  fi

  if [[ $OS != *"coreos" ]]; then
    FILTER=(`echo ${FILTER}`)
  fi

  docker ps $FILTER --filter "name=$SEARCH" --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'
}

dbash() {
  echo ""
  docker ps -a --filter "name=$1" --format "{{.Names}}\t{{.ID}}" | sort -r | head -1
  docker exec -it $(docker ps -aq --filter "name=$1" | sort -r | head -1) bash
}

dsrestart() {
  echo ""
  docker ps -a --filter "name=$1" --format "{{.Names}}" | sort -r | head -1
  docker restart $(docker ps -aq --filter "name=$1" | sort -r | head -1)
}

dsstop() {
  echo ""
  docker ps -a --filter "name=$1" --format "{{.Names}}" | sort -r | head -1
  docker stop $(docker ps -aq --filter "name=$1" | sort -r | head -1)
}

dlogs() {
  local NAME=$1
  local ARGS=${@:2}
  ARGS=(`echo ${ARGS}`)

  echo ""
  docker ps -a --filter "name=$NAME" --format "{{.Names}}\t{{.ID}}" | sort -r | head -1
  docker logs $ARGS $(docker ps -aq --filter "name=$NAME" | sort -r | head -1)
}
