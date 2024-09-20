#! /usr/bin/env oi

if command -v brew >/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)";
  __USE_BREW="true";
else
  __USER_BREW="false";
fi

__NVM_DIR="${HOME}/.nvm";

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  __NVM_DIR="${HOMEBREW_PREFIX}/opt/nvm";
fi

function install::nvm {
  if [[ ! -d "${__NVM_DIR}" ]]; then
    if [[ "${__USER_BREW}" == "true" ]]; then
      brew install nvm;
    elif command -v curl >/dev/null; then
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash;
    elif command -v wget >/dev/null; then
      wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash;
    else
      oi::log.error "To install atuin, you must have homebrew, curl, or wget installed.";
      oi::exit.nok;
    fi
  fi
}

install::nvm;
