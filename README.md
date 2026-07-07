# dotfiles

[![CI](https://github.com/ITProKyle/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/ITProKyle/dotfiles/actions/workflows/ci.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/enabled-brightgreen?logo=renovatebot&logoColor=%2373afae&label=renovate)](https://developer.mend.io/github/ITProKyle/dotfiles)

Kyle Finley's dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

Install them with:

```console
chezmoi init ITProKyle
```

Once completed, you may need to logout then back in for all changes to take effect as some things are setup in [`.zprofile`](./src/dot_zprofile).
This will always be the case for new initializations but only some updates.

## [`install.sh`](./install.sh)

The [`install.sh`](./install.sh) script can be used to setup Codespaces, devcontainers, or Linux systems.

### Linux

```console
bash -c "$(curl -s https://raw.githubusercontent.com/ITProKyle/dotfiles/master/install.sh)"
```

## Windows

This repository contains paths that include `::`.
Windows cannot create normal working-tree files with `::` in the name.
A plain `git clone`/`chezmoi init` may download the repository successfully but fail during checkout with an error like:

```text
error: invalid path 'src/dot_local/bin/executable_finley::backup.poetry'
fatal: unable to checkout working tree
```

To resolve this, use sparse checkout so Git keeps those paths in repository history but does not try to write them to the Windows filesystem.

### Clean Clone

```console
$ git clone --no-checkout https://github.com/ITProKyle/dotfiles.git ~/.local/share/chezmoi
$ cd ~/.local/share/chezmoi
$ git sparse-checkout init --no-cone && git sparse-checkout set "/*" "!src/dot_local/bin/*::*" && git checkout -f HEAD && git status --short
Your branch is up to date with 'origin/master'.
```

The final `git status --short` command should print no changes.

### Recover From A Failed Normal Clone

If you already ran a plain clone and saw the invalid-path checkout error, keep the partially cloned folder and run the following:

```console
$ cd ~/.local/share/chezmoi
$ git config --local core.protectNTFS false && git sparse-checkout init --no-cone && git sparse-checkout set "/*" "!src/dot_local/bin/*::*" && git checkout -f HEAD && git status --short
Your branch is up to date with 'origin/master'.
$ git config --local --unset core.protectNTFS
```

Git can refuse to update the index because of NTFS path protection while recovering a failed clone.
So, you may need to temporarily set `core.protectNTFS=false` for this repository.
This is already included in the commands above as is enabling it once finished.
