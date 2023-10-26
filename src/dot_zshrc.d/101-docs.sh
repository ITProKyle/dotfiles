#!/usr/bin/env bash
#
# Function that opens documentation in the default browser.

# Open doc sites
function docs {
  local first_opt="$1"  # the tool to open docs for
  local section="${2:-}"  # options section of the docs if supported

  case $first_opt in
    chezmoi)
      open "https://www.chezmoi.io/"
      ;;

    gitlab)
      case $section in
        actions)
          # GitLab quick actions
          open "https://docs.gitlab.com/ee/user/project/quick_actions.html";
          ;;
        ci|gitlab-ci)
          # ".gitlab-ci.yml" keyword reference
          open "https://docs.gitlab.com/ee/ci/yaml/";
          ;;
        ci-vars|vars)
          # CI Predefined variables reference
          open "https://docs.gitlab.com/ee/ci/variables/predefined_variables.html";
          ;;
        *)  # default action
          echo "Jump to a section of the docs using one of the configured options:";
          echo '  - actions: GitLab quick actions'
          echo '  - ci|gitlab-ci: ".gitlab-ci.yml" keyword reference'
          echo '  - ci-vars|vars: CI Predefined variables reference'
          open "https://docs.gitlab.com/";
      esac
      ;;

    make)
      open "https://www.gnu.org/software/make/manual/make.html";
      ;;
    pipenv)
      open "https://pipenv.pypa.io/en/latest/";
      ;;
    poetry)
      open "https://python-poetry.org/docs/";
      ;;
    pyenv)
      open "https://github.com/pyenv/pyenv";
      ;;
    *)  # default action
      echo "Usage: $0 {chezmoi|gitlab|make|poetry|pyenv}";
  esac
}
