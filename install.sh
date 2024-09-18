#! /usr/bin/env bash
#
# Primarily for Codespaces and devcontainers but can be used to aid in bootstrapping tools on any system.
#
set -o errexit;  # Exit script when a command exits with non-zero status
set -o nounset;  # Exit script on use of an undefined variable

__OI_EXIT_OK=0
__OI_EXIT_NOK=1


function var_equals {
  #
  # Checks if a value equals.
  #
  # Arguments:
  #   $1 Variable
  #   $2 Equals value
  #
  local variable=${1};
  local equals=${2};

  if [[ "${variable}" = "${equals}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function var_has_value {
  #
  # Checks if a variable has actual value.
  #
  # Arguments:
  #   $1 Value
  #
  local value=${1:-};

  if [[ -n "${value}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function is_devcontainer {
  #
  # Checks if running in a dev container.
  #
  if var_has_value "${CODESPACES:-}" \
    || var_has_value "${GITPOD_HOST:-}" \
    || var_has_value "${VSCODE_REMOTE_CONTAINERS_SESSION:-}" \
    || var_equals "${USER:-}" "vscode"; then
      return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function install_atuin {
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

function install_chezmoi {
  # Created from "chezmoi generate install.sh > install.sh".
  # Enables with with Codespaces and devcontainers:
  #   https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles
  #
  local bin_dir chezmoi git_repo install_script script_dir;

  git_repo="${1:-ITProKyle}";

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

  if is_devcontainer; then
    init_chezmoi_devcontainer "${chezmoi}";
  else
    if [[ ! -d "${HOME}/.local/share/chezmoi" ]]; then
      # has to be HTTPS as the system likely won't have an SSH key. SSH requires auth.
      "${chezmoi}" init "${git_repo}" --apply;
    else
      echo "not running 'chezmoi init' as it is already initalized.";
      echo "it can be run manually if desired.";
    fi
  fi
}

function init_chezmoi_devcontainer {
  # Run `chezmoi init` for devcontainers & Codespaces.
  #
  local chezmoi_bin script_dir;

  chezmoi_bin="${1:-chezmoi}";

  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)";

  set -- init --apply --source="${script_dir}";

  echo "Running 'chezmoi $*'" >&2;
  # exec: replace current process with chezmoi
  exec "$chezmoi_bin" "$@";
}

install_chezmoi "$@";
install_atuin;
