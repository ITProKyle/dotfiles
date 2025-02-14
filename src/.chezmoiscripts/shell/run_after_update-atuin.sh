#! /usr/bin/env oi
# shellcheck shell=bash
# ==============================================================================
# Always attempt to install atuin.
# ==============================================================================
if command -v atuin-update >/dev/null 2>&1; then
  atuin-update \
    || oi::log.error "failed to update atuin";
else
  if command -v atuin >/dev/null 2>&1; then
    if ! command -v brew >/dev/null 2>&1; then
      oi::log.warning "atuin not updated; 'atuin-update' is missing which can be caused by atuin being installed with homebrew";
    else
      oi::log.debug "atuin not updated; managed by homebrew";
    fi
  else
    oi::log.debug "atuin not updated; not installed";
  fi
fi
