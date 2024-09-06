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
