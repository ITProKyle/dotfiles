#!/usr/bin/env bash
#
# Docker aliases, functions, and whatnot.

# cleanup after docker (e.g. dangling images)
alias docker-prune="docker image prune --force"

# stops and removes all docker containers
function docker-kill {
  echo "stopping all containers..."
  # shellcheck disable=SC2046
  docker container stop $(docker container ls -aq)
  echo "removing all containers..."
  # shellcheck disable=SC2046
  docker container rm $(docker container ls -aq)
}

# update docker images
function docker-update {
  docker image prune --force;
  docker image ls --format '{{json .}}' | jq -r '[([.Repository, .Tag] | join(":"))] | @tsv' | xargs -L1 docker pull;
}
