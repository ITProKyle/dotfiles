#! /usr/bin/env oi

function post-install::bat {
  # Perform post-install steps for: bat

  if [[ -f "/usr/bin/batcat" ]] && ! command -v bat >/dev/null; then
    mkdir -p "${HOME}/.local/bin";
    ln -s /usr/bin/batcat "${HOME}/.local/bin/bat";

    if command -v sudo >/dev/null && [[ "${USER}" != "root" ]]; then
      sudo mkdir -p "/home/root/.local/bin";
      sudo ln -s /usr/bin/batcat "/home/root/.local/bin/bat";
    fi
  fi
}

function install::packages.apt {
  # Install packages using: apt
  local _sudo=${1};

  # shellcheck disable=SC2086
  ${_sudo}apt-get update -y;

  # base set of packages
  # shellcheck disable=SC2086
  ${_sudo}apt-get install -y \
    bat \
    build-essential \
    ca-certificates \
    curl \
    direnv \
    git \
    net-tools \
    zsh \
    zsh-syntax-highlighting

  post-install::bat;

  # packages required for pyenv
  # cspell:ignore libbz2
  # shellcheck disable=SC2086
  ${_sudo}apt-get install -y \
    ccache \
    llvm \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
    libxml2-dev \
    libxmlsec1-dev
}

function install::packages {
  # Install packages.
  local _sudo;

  if command -v sudo >/dev/null; then _sudo="sudo "; else _sudo=""; fi

  if command -v curl >/dev/null; then
    oi::log.notice "using apt to install system packages...";
    install::packages.apt "${_sudo}";
  else
    oi::log.error "unable to determine package manager!";
    oi::log.error "system packages will not be installed";
  fi
};
