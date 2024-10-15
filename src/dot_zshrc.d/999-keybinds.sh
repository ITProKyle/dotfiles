#!/usr/bin/env bash
#
# Add keybinds.

bindkey "^[[H" beginning-of-line  # HOME
bindkey "^[[F" end-of-line  # END
bindkey "^[^[[C" forward-word  # macOS `Alt + ->` or `Option + ->` depending on keyboard (linux might need "^[[1;3C")
bindkey "^^[^[[D" backward-word  # macOS `Alt + <-` or `Option + <-` depending on keyboard (linux might need "^[[1;3D")
