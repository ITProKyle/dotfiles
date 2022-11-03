#!/usr/bin/env bash
#
# Exports for Homebrew installed openssl.

OPENSSL="${HOMEBREW_PREFIX}/opt/openssl@1.1"

export CPPFLAGS="-I/${OPENSSL}/include ${CPPFLAGS}"
export LDFLAGS="-L/${OPENSSL}/lib ${LDFLAGS}"
