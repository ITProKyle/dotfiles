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

function version-to-int {
  # Converts a SemVer version string into an integer for comparison.
  #
  # Currently supports up to 4 version parts of 3 digits each.
  #
  # Usage:
  #
  #   if [[ $(version $1) >= $(version $2) ]]; then
  #     echo "...";
  #   fi;
  #

  # TODO: add check to ensure version schema

  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
};
