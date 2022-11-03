.PHONY: docs

SHELL := /bin/bash

help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

fix-md: ## automatically fix markdown format errors
	@poetry run pre-commit run mdformat --all-files

run-pre-commit: ## run pre-commit for all files
	@poetry run pre-commit run -a

setup: setup-poetry setup-pre-commit setup-npm ## setup dev environment

setup-npm: ## install node dependencies with npm
	@npm ci

setup-poetry: ## setup python virtual environment
	@poetry install \
		--remove-untracked

setup-pre-commit: ## install pre-commit git hooks
	@poetry run pre-commit install

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npx cspell "**/*" \
		--color \
		--config .vscode/cspell.json \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context
