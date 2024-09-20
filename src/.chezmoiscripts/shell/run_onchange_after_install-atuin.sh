#! /usr/bin/env oi

function install::atuin {
  # Install https://atuin.sh.
  # Atuin only has binaries available so other install methods (e.g. from GitHub) are less viable.
  #
  local install_script;

  if ! atuin --help >/dev/null; then
    if command -v curl >/dev/null; then
      install_script="$(curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh)";
    elif command -v wget >/dev/null; then
      install_script="$(wget -qO- https://setup.atuin.sh)";
    else
      oi::log.error "To install atuin, you must have curl or wget installed.";
      oi::exit.nok;
    fi
  fi

  sh -c "${install_script}"
}

install::atuin;
