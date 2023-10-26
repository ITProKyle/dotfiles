#!/usr/bin/env bash
#
# Various utility functions.

function escape-slashes {
  sed 's/\//\\\//g'
}

function git-default-branch {
  git remote show origin | awk '/HEAD branch/ {print $NF}'
}

function pem {
  if [[ ! -d "${HOME}/pem" ]]; then mkdir -p "${HOME}/pem"; fi
  find "${HOME}/pem" -name '*pem' -type f -exec chmod 600 {} \;
  # shellcheck disable=SC2164
  cd "${HOME}/pem"
  tree
}
