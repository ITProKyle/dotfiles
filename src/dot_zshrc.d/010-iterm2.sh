#!/usr/bin/env bash

# set iterm2 titles
export DISABLE_AUTO_TITLE="true"
function setTerminalText {
  # echo works in bash & zsh
  local mode=$1 ; shift
  # shellcheck disable=SC2145
  echo -ne "\033]$mode;$@\007"
}
function set-terminal { setTerminalText 0 "$@"; }
function set-tab { setTerminalText 1 "$@"; }
function set-title { setTerminalText 2 "$@"; }

# Set the tab color
# source: https://github.com/connordelacruz/iterm2-tab-color
function it2-tab-color {
  # takes 1 hex string argument or 3 hex values for RGB
  local R G B
  case "$#" in
    3)
      R="$1"
      G="$2"
      B="$3"
      ;;
    1)
      local hex="$1"
      # Remove leading # if present
      if [[ "${hex:0:1}" == "#" ]]; then
          hex="${hex:1}"
      fi
      # Get hex values for each channel and convert to decimal
      R="$((16#${hex:0:2}))"
      G="$((16#${hex:2:2}))"
      B="$((16#${hex:4}))"
      ;;
    *)
      echo "Usage: it2-tab-color color_hex"
      echo "          color_hex: 6 digit hex value (e.g. 1B2B34)"
      echo "       it2-tab-color r_val g_val b_val"
      echo "          *_val: values for R, G, B from 0-255 (e.g. 27 43 52)"
      return
      ;;
  esac
  echo -ne "\033]6;1;bg;red;brightness;$R\a"
  echo -ne "\033]6;1;bg;green;brightness;$G\a"
  echo -ne "\033]6;1;bg;blue;brightness;$B\a"
  # Export environment variable to maintain colors during session
  export IT2_SESSION_COLOR="$R $G $B"
}

# Reset tab color to default
# source: https://github.com/connordelacruz/iterm2-tab-color
function it2-tab-reset {
  echo -ne "\033]6;1;bg;*;default\a"
  # Unset environment variable
  unset IT2_SESSION_COLOR
}

# Restore session tab color
# source: https://github.com/connordelacruz/iterm2-tab-color
if [ -n "$IT2_SESSION_COLOR" ]; then
  it2-tab-color "$IT2_SESSION_COLOR"
fi
