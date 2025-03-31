.PHONY: brewfile docs

CI := $(if $(CI),yes,no)
SHELL := /bin/bash

ifeq ($(CI), yes)
	POETRY_OPTS = --ansi -v
	PRE_COMMIT_OPTS = --show-diff-on-failure --verbose
endif

help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

brewfile:  ## generate a Brewfile.local from the current system
	@brew bundle dump --describe --force

exe: ## make files executable
	@find ./src -type f -name 'executable_*' -print0 | xargs -0r chmod +x;

fix: run-pre-commit ## run all automatic fixes

fix.md: ## automatically fix markdown format errors
	@poetry run pre-commit run mdformat --all-files

home: ## equivalent to "chezmoi apply"
	@chezmoi apply

lint: ## run all linters
	@echo "no linters configured for this project"

# install act: gh extension install https://github.com/nektos/gh-act
lint.shellcheck: ## runs shellcheck using act
	@gh act --job shellcheck

run.pre-commit: ## run pre-commit for all files
	@poetry run pre-commit run $(PRE_COMMIT_OPTS) \
		--all-files \
		--color always

setup: setup.poetry setup.pre-commit setup.npm ## setup dev environment

setup.npm: ## install node dependencies with npm
	@npm ci

setup.poetry: ## setup python virtual environment
	@poetry sync $(POETRY_OPTS)

setup.pre-commit: ## install pre-commit git hooks
	@poetry run pre-commit install

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npm exec --no -- cspell lint . \
		--color \
		--config .vscode/cspell.json \
		--dot \
		--gitignore \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context

test: ## run all test
	@echo "no tests configured for this project"
