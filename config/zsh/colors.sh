#!/usr/bin/env zsh

# More robust color detection and fallback
setup_colors() {
    # Check if we can use tput and have color support
    if command -v tput >/dev/null 2>&1; then
        local num_colors=$(tput colors 2>/dev/null || echo 0)

        # If tput works and reports colors, use it
        if [[ $num_colors -ge 8 ]]; then
            RED=$(tput setaf 1 2>/dev/null)
            GREEN=$(tput setaf 2 2>/dev/null)
            YELLOW=$(tput setaf 3 2>/dev/null)
            BLUE=$(tput setaf 4 2>/dev/null)
            MAGENTA=$(tput setaf 5 2>/dev/null)
            CYAN=$(tput setaf 6 2>/dev/null)
            WHITE=$(tput setaf 7 2>/dev/null)
            BOLD=$(tput bold 2>/dev/null)
            RESET=$(tput sgr0 2>/dev/null)
        fi
    fi

    # Fallback to ANSI codes if tput failed or no colors detected
    if [[ -z "$RED" ]]; then
        RED='\033[31m'
        GREEN='\033[32m'
        YELLOW='\033[33m'
        BLUE='\033[34m'
        MAGENTA='\033[35m'
        CYAN='\033[36m'
        WHITE='\033[37m'
        BOLD='\033[1m'
        RESET='\033[0m'
    fi

    # Export all variables
    export RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BOLD RESET
}

# Run the setup
setup_colors
