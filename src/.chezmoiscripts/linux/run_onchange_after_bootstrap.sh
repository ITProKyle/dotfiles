#! /usr/bin/env oi
# shellcheck disable=SC2086

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


function install::packages.apt.repositories {
  # Add apt repositories that are not added by default.

  local _sudo=${1};

  ${_sudo}apt-get update -y >/dev/null;

  # contains "add-apt-repository" to simplify adding repositories
  ${_sudo}apt-get install -y software-properties-common;

  oi::log.info "adding apt repositories...";
  ${_sudo}add-apt-repository --no-update --yes ppa:aos1/diff-so-fancy;
  oi::log.success "all apt repositories have been added!";
}

function install::packages.apt {
  # Install packages using: apt

  local _sudo=${1};

  install::packages.apt.repositories "${_sudo}";

  ${_sudo}apt-get update -y >/dev/null;

  oi::log.info "installing initial set of packages..."
  ${_sudo}apt-get install -y \
    bat \
    build-essential \
    ca-certificates \
    curl \
    diff-so-fancy \
    direnv \
    git \
    net-tools \
    zsh \
    zsh-syntax-highlighting;

  post-install::bat;

  oi::log.info "installing packages required by pyenv...";
  # cspell:ignore libbz2
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
    libxmlsec1-dev;
}

function install::packages {
  # Install packages.
  local _sudo;

  if command -v sudo >/dev/null; then _sudo="sudo "; else _sudo=""; fi

  if command -v apt-get >/dev/null; then
    oi::log.notice "using apt to install system packages...";
    install::packages.apt "${_sudo}";
  else
    oi::log.error "unable to determine package manager!";
    oi::log.error "system packages will not be installed";
  fi

  oi::log.success "finished installing packages!";
};
