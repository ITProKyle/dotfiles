#! /usr/bin/env bash
#
# Functions & environment variables that can be used to print colored messages.

export _STYLE_BOLD="\e[1m";
export _STYLE_DIM="\e[2m";
export _STYLE_ITALIC="\e[3m";
export _STYLE_UNDERLINE="\e[4m";

export _STYLE_BLACK="\e[30m";
export _STYLE_BLACK_BOLD="\e[30;1m";

export _STYLE_RED="\e[31m";
export _STYLE_RED_BOLD="\e[31;1";

export _STYLE_GREEN="\e[32m";
export _STYLE_GREEN_BOLD="\e[32;1m";

export _STYLE_YELLOW="\e[33m";
export _STYLE_YELLOW_BOLD="\e[33;1m";

export _STYLE_BLUE="\e[34m";
export _STYLE_BLUE_BOLD="\e[34;1m";

export _STYLE_MAGENTA="\e[35m";
export _STYLE_MAGENTA_BOLD="\e[35;1m";

export _STYLE_CYAN="\e[36m";
export _STYLE_CYAN_BOLD="\e[36;1m";

export _STYLE_RESET="\e[0m";

secho() {
  # Stylized echo.
  #
  # Usage: secho TEXT COLOR [STYLE]
  #
  # Arguments:
  #   TEXT: Any text to be printed.
  #   color: Human readable color name. If it does not match a supported color,
  #           no color is applied. If no color is desired, "bold" can be provided.
  #   bold: Optionally provide a style as the third argument to make the text bold, dim, or italic.
  #
  local color="",
  local text="${1}"; shift;

  case "${1}" in
    black) color="\e[30"; shift;;
    red) color="\e[31"; shift;;
    green) color="\e[32"; shift;;
    yellow) color="\e[33"; shift;;
    blue) color="\e[34"; shift;;
    magenta | purple) color="\e[35"; shift;;
    cyan) color="\e[36"; shift;;
    gray | grey) color="\e[37"; shift;;
    bold) color="\e[1"; shift;;
    *)
      echo -e "${_STYLE_RED_BOLD}[ERROR] Unrecognized argument: $1${_STYLE_RESET}";
      exit 1;
      ;;
  esac

  while [[ "$1" != "" ]]; do
    case "${1}" in
      bold) color="${color};1"; shift;;
      dim) color="${color};2"; shift;;
      italic) color="${color};3"; shift;;
      *)
        echo -e "${_STYLE_RED_BOLD}[ERROR] Unrecognized argument: $1${_STYLE_RESET}";
        exit 1;
        ;;
    esac
  done

  echo -e "${color}m${text}${_STYLE_RESET}";
}

function log-debug { secho "[DEBUG] ${1}" cyan dim italic; }
function log-deprecated { secho "[DEPRECATED] ${1}" cyan bold; }
function log-error { secho "[ERROR] ${1}" red bold; }
function log-notice { secho "[NOTICE] ${1}" magenta bold; }
function log-warning { secho "[WARNING] ${1}" yellow bold; }
