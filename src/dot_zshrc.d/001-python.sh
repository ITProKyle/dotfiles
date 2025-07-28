#!/usr/bin/env bash
#
# Exports for Python and Python utilities.

if [[ "${__FINLEY_OS}" == "darwin" ]]; then
  TCL_TK="${HOMEBREW_PREFIX}/opt/tcl-tk"
fi

export POETRY_HOME_LINUX="${HOME}/.local/share/pypoetry"
export POETRY_HOME_MACOS="${HOME}/Library/Application Support/pypoetry"

# pipenv settings
export PIPENV_VENV_IN_PROJECT=1  # pipenv venv in the project dir (.venv/)
export PIPENV_HIDE_EMOJIS=1  # hide emojis in pipenv output

# pyenv setup
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# pyenv build options
# https://github.com/pyenv/pyenv/blob/master/plugins/python-build/README.md#building-for-maximum-performance
export PYTHON_CFLAGS='-march=native -mtune=native'
if [[ "${__FINLEY_OS}" == "darwin" ]]; then
  export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} --with-tcltk-includes='-I${TCL_TK}/include'"
  export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} --with-tcltk-libs='-L${TCL_TK}/lib -ltcl8.6 -ltk8.6'"
  export PYTHON_CONFIGURE_OPTS="--enable-framework --enable-optimizations --with-lto"
else
  export PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations --with-lto"
fi

# TODO (kyle): change for pipx install as that is the new recommended install method
if [[ "${__FINLEY_OS}" == "darwin" ]]; then
  alias poetry-python='${POETRY_HOME_MACOS}/venv/bin/python'
elif [[ "${__FINLEY_OS}" == "linux" ]]; then
  alias poetry-python='${POETRY_HOME_LINUX}/venv/bin/python'
fi

function restore-poetry {
  # Restore poetry configuration.
  local BACKUP_DIR="${HOME}/.config/pypoetry"

  if [[ "${__FINLEY_OS}" == "darwin" ]]; then
    if [[ ! -d "${POETRY_HOME_MACOS}" ]]; then
      mkdir -p "${POETRY_HOME_MACOS}";
    fi
  elif [[ "${__FINLEY_OS}" == "linux" ]]; then
    if [[ ! -d "${POETRY_HOME_LINUX}" ]]; then
      mkdir -p "${POETRY_HOME_LINUX}";
    fi
  fi

  for file_name in "auth.toml" "config.toml"; do
    file_path="${BACKUP_DIR}/${file_name}"
    if [[ -f "${file_path}" ]]; then
      if [[ "${__FINLEY_OS}" == "darwin" ]]; then
        cp -i "${file_path}" "${POETRY_HOME_MACOS}/${file_name}";
        echo "restored \"${file_name}\" to \"${POETRY_HOME_MACOS}\"";
      else
        cp -i "${file_path}" "${POETRY_HOME_LINUX}/${file_name}";
        echo "restored \"${file_name}\" to \"${POETRY_HOME_LINUX}\"";
      fi
    fi
  done
}

function py-install {
  # Faster 'pyenv install' using a faster profile task.
  # Uninstalls before trying to install.
  #
  local options;

  if [[ $(version-to-int "$1") -ge $(version-to-int '3.10.0') ]]; then
    options="--disable-test-modules";  # https://docs.python.org/3/using/configure.html#install-options
  fi

  # shellcheck disable=SC2068
  pyenv uninstall $@;
  # shellcheck disable=SC2068
  PROFILE_TASK='-m test.regrtest --pgo -j0' PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} ${options}" pyenv install $@;
}

function uninstall-poetry {
  local use_pipx
  local use_script
  backup-poetry;
  echo "Uninstall can be performed for pipx or the https://install.python-poetry.org script.";
  echo;

  printf "Uninstall using pipx? (Y/n) ";
  read -n 1 use_pipx;
  use_pipx="${use_pipx:-y}"
  case $use_pipx in
    Y|y)
      pipx uninstall poetry;
      ;;
    *)
      printf "Uninstall using https://install.python-poetry.org script? (Y/n) ";
      read -n 1 use_script;
      use_script="${use_script:-y}"
      case $use_script in
        Y|y)
          curl -sSL https://install.python-poetry.org | python3 - --uninstall;
          ;;
        *)
          printf "\e[31;1m";
          printf "[ERROR] unable to determine uninstall method";
          printf "\e[0m";
          ;;
      esac;
  esac;
}

function update-poetry {
  local use_pipx
  local use_script
  echo "Update can be performed for pipx or the https://install.python-poetry.org script.";
  echo;

  printf "Update using pipx? (Y/n) ";
  read -n 1 use_pipx;
  use_pipx="${use_pipx:-y}"
  case $use_pipx in
    Y|y)
      pipx upgrade poetry --include-injected;
      ;;
    *)
      printf "Update using https://install.python-poetry.org script? (Y/n) ";
      read -n 1 use_script;
      use_script="${use_script:-y}"
      case $use_script in
        Y|y)
          poetry self update;
          poetry self add poetry-plugin-export@latest;
          poetry self add poetry-dynamic-versioning@latest;
          ;;
        *)
          printf "\e[31;1m";
          printf "[ERROR] unable to determine update method";
          printf "\e[0m";
          ;;
      esac;
  esac;
}

function reinstall-poetry { uninstall-poetry; install-poetry; }
