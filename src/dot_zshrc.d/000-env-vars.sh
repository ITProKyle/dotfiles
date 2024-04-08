#!/usr/bin/env bash
#
# Export environment variables.

if [[ "${__FINLEY_OS}" == "darwin" ]]; then
  export PATH="${HOMEBREW_PREFIX}/opt/make/libexec/gnubin:$PATH"
fi

export ASDF_FORCE_PREPEND="no"  # https://asdf-vm.com/manage/configuration.html#asdf-force-prepend
export PYTHON_GITLAB_CFG="${HOME}/.config/python-gitlab/python-gitlab.cfg"
export REPOS="${HOME}/repos"
export REPOS_GITHUB="${REPOS}/github"
export REPOS_GITLAB="${REPOS}/gitlab"
