#! /usr/bin/env bash

__PYENV_DIR="${HOME}/.pyenv";

function install::pyenv {
  if [[ ! -d "${__PYENV_DIR}/bin" ]]; then
    if command -v curl >/dev/null; then
      curl https://pyenv.run | bash;
    elif command -v wget >/dev/null; then
      wget -qO- https://pyenv.run| bash;
    else
      echo "To install atuin, you must have curl or wget installed.";
      exit 1;
    fi
  fi
}

function install::pyenv.plugins {
  local plugins="${__PYENV_DIR}/plugins";

  if [[ ! -d "${plugins}/pyenv-ccache" ]]; then
    git clone https://github.com/pyenv/pyenv-ccache.git "${plugins}/pyenv-ccache";
  fi

  if [[ ! -d "${plugins}/pyenv-default-packages" ]]; then
    git clone https://github.com/jawshooah/pyenv-default-packages.git "${plugins}/pyenv-default-packages";
  fi

  if [[ ! -d "${plugins}/pyenv-doctor" ]]; then
    git clone https://github.com/pyenv/pyenv-doctor.git "${plugins}/pyenv-doctor";
  fi

  if [[ ! -d "${plugins}/pyenv-update" ]]; then
    git clone https://github.com/pyenv/pyenv-update.git "${plugins}/pyenv-update";
  fi
}

install::pyenv;
install::pyenv.plugins;
