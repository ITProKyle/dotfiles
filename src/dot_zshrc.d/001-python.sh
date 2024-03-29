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
  export PYTHON_BUILD_SKIP_HOMEBREW="1"
  export PYTHON_CONFIGURE_OPTS="--enable-framework --enable-optimizations --with-lto"
  export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} --with-tcltk-includes='-I${TCL_TK}/include'"
  export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} --with-tcltk-libs='-L${TCL_TK}/lib -ltcl8.6 -ltk8.6'"
else
  export PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations --with-lto"
fi

if [[ "${__FINLEY_OS}" == "darwin" ]]; then
  alias poetry-python='${POETRY_HOME_MACOS}/venv/bin/python'
elif [[ "${__FINLEY_OS}" == "linux" ]]; then
  alias poetry-python='${POETRY_HOME_LINUX}/venv/bin/python'
fi

function backup-poetry {
  # Backup poetry configuration.
  local BACKUP_DIR="${HOME}/.config/pypoetry"

  mkdir -p "${BACKUP_DIR}";
  for file_name in "auth.toml" "config.toml"; do
    if [[ "${__FINLEY_OS}" == "darwin" ]]; then
      file_path="${POETRY_HOME_MACOS}/${file_name}"
    else
      file_path="${POETRY_HOME_LINUX}/${file_name}"
    fi

    if [[ -f "${file_path}" ]]; then
      cp -i "${file_path}" "${BACKUP_DIR}/${file_name}";
      echo "backed up \"${file_name}\" to \"${BACKUP_DIR}\"";
    fi
  done
}

function restore-poetry {
  # Restore poetry configuration.
  local BACKUP_DIR="${HOME}/.config/pypoetry"

  if [[ ! -d "${POETRY_HOME_MACOS}" ]]; then
    echo "poetry not installed!";
    exit 9;
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

  # TODO add '--disable-test-modules' for >= 3.11 - https://docs.python.org/3/using/configure.html#install-options

  # shellcheck disable=SC2068
  pyenv uninstall $@;
  # shellcheck disable=SC2068
  PROFILE_TASK='-m test.regrtest --pgo -j0' pyenv install $@;
}

function install-poetry {
  curl -sSL https://install.python-poetry.org | python3 -;
  restore-poetry;
}

function uninstall-poetry {
  backup-poetry;
  curl -sSL https://install.python-poetry.org | python3 - --uninstall;
}

function reinstall-poetry { uninstall-poetry; install-poetry; }
