#!/usr/bin/env bash
#
# autosuggestion settings.
# https://github.com/zsh-users/zsh-autosuggestions

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^[[Z' autosuggest-accept  # SHIFT + TAB
