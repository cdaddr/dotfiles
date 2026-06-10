#!/usr/bin/env zsh

# static ANSI color codes (consumed via `echo -e` / `print`)
# previously these were derived from ~9 tput subprocess calls (~55ms at startup)
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
BOLD='\033[1m'
RESET='\033[0m'
export RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BOLD RESET
