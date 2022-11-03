#!/usr/bin/env bash
#
# Exports for Homebrew installed tcl-tk.

TCL_TK="${HOMEBREW_PREFIX}/opt/tcl-tk"
XCRUN="$(xcrun --show-sdk-path)"

export CPPFLAGS="-I${TCL_TK}/include ${CPPFLAGS}"
export LDFLAGS="-L${TCL_TK}/lib -L${XCRUN}/usr/lib ${LDFLAGS}"
export PATH="${TCL_TK}/bin:${PATH}"
export PKG_CONFIG_PATH="${TCL_TK}/lib/pkgconfig"
