#! /usr/bin/env oi

# TODO: change to `run_once_` - https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#understand-how-scripts-work

function install::atuin {
  # Install https://atuin.sh.
  # Atuin only has binaries available so other install methods (e.g. from GitHub) are less viable.
  #
  local install_script;

  if ! atuin --help >/dev/null 2>&1; then
    if command -v curl >/dev/null 2>&1; then
      install_script="$(curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh)";
    elif command -v wget >/dev/null 2>&1; then
      install_script="$(wget -qO- https://setup.atuin.sh)";
    else
      oi::log.error "To install atuin, you must have curl or wget installed.";
      oi::exit.error;
    fi
  fi

  sh -c "${install_script}"
}

function login::atuin {
  # Run `atuin login` if credentials are provided and not already logged in.
  #
  local atuin_key="${ATUIN_KEY:-}";
  local atuin_password="${ATUIN_PASSWORD:-}";
  local atuin_username="${ATUIN_USERNAME:-}";

  if oi::fs.file_exists "/run/secrets/ATUIN_USERNAME"; then atuin_username="$(cat /run/secrets/ATUIN_USERNAME)"; fi

  if oi::var.has_value "$atuin_username"; then
    if ! atuin account verify >/dev/null 2>&1; then
      if oi::fs.file_exists "/run/secrets/ATUIN_KEY"; then atuin_key="$(cat /run/secrets/ATUIN_KEY)"; fi
      if oi::fs.file_exists "/run/secrets/ATUIN_PASSWORD"; then atuin_password="$(cat /run/secrets/ATUIN_KEY)"; fi

      if oi::var.is_empty "${atuin_key}" || oi::var.is_empty "${atuin_password}"; then
        oi::log.error "unable to login with atuin; missing key or password";
      fi

      oi::log.info "attempting to login with atuin...";
      atuin login --username "${atuin_username}" --password "${atuin_password}" --key "${atuin_key}" \
        || oi::log.error "failed to login to atuin sync server";
      atuin sync \
        || oi::log.error "failed to sync atuin";
    fi
  fi
}

install::atuin;
login::atuin;
