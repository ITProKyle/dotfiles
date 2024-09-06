#!/bin/sh
#
# Primarily for Codespaces and devcontainers but can be used to aid in bootstrapping tools on any system.
#
set -o errexit;  # Exit script when a command exits with non-zero status
set -o nounset;  # Exit script on use of an undefined variable

function install::atuin {
  # Install https://atuin.sh.
  # Atuin only have binaries available so other install methods (e.g. from GitHub) are less viable.
  #
  local install_script;

  if ! atuin --help >/dev/null; then
    if command -v curl >/dev/null; then
      install_script="$(curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh)";
    elif command -v wget >/dev/null; then
      install_script="$(wget -qO- https://setup.atuin.sh)";
    else
      echo "To install atuin, you must have curl or wget installed." >&2;
      exit 1;
    fi
  fi

  sh -c "${install_script}"
}

function install::chezmoi {
  # Created from "chezmoi generate install.sh > install.sh".
  # Enables with with Codespaces and devcontainers:
  #   https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles
  #
  local bin_dir chezmoi install_script script_dir;

  if ! chezmoi="$(command -v chezmoi)"; then
    bin_dir="${HOME}/.local/bin";
    chezmoi="${bin_dir}/chezmoi";
    echo "Installing chezmoi to '${chezmoi}'" >&2;
    if command -v curl >/dev/null; then
      install_script="$(curl -fsSL get.chezmoi.io)";
    elif command -v wget >/dev/null; then
      install_script="$(wget -qO- get.chezmoi.io)";
    else
      echo "To install chezmoi, you must have curl or wget installed." >&2;
      exit 1;
    fi
    sh -c "${install_script}" -- -b "${bin_dir}";
    unset install_script bin_dir;
  fi

  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)";

  set -- init --apply --source="${script_dir}";

  echo "Running 'chezmoi $*'" >&2;
  # exec: replace current process with chezmoi
  exec "$chezmoi" "$@";
}

install::chezmoi;
install::atuin;
