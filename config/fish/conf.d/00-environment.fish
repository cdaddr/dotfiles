# Environment variables for Fish shell

# XDG Base Directory Specification
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# Editor and pager
set -gx EDITOR 'nvim'
set -gx LANG en_CA.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8

# Tool-specific directories
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx EZA_CONFIG_DIR "$XDG_CONFIG_HOME/eza"

# Tool options
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude '*~'"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx PRETTIERD_DEFAULT_CONFIG "$XDG_CONFIG_HOME/prettierdrc.toml"

# Color theme detection
if set -q INTELLIJ
    set -gx LIGHTDARK light
else
    set -gx LIGHTDARK (cat $XDG_CONFIG_HOME/lightdark 2>/dev/null; or echo 'dark')
end

if test "$LIGHTDARK" = "light"
    set -gx ZSH_THEME "catppuccin-frappe"
else
    set -gx ZSH_THEME "catppuccin-macchiato"
end

# Set LESS_TERMCAP variables based on theme for Catppuccin colors
if test "$LIGHTDARK" = "dark"
    # Catppuccin Mocha (dark theme)
    set -gx LESS_TERMCAP_mb \e'[1;31m'     # Begin blinking - Red
    set -gx LESS_TERMCAP_md \e'[1;94m'     # Begin bold - Blue
    set -gx LESS_TERMCAP_me \e'[0m'        # End mode
    set -gx LESS_TERMCAP_se \e'[0m'        # End standout-mode
    set -gx LESS_TERMCAP_so \e'[48;5;147m'\e'[38;5;235m' # Begin standout - Inverted
    set -gx LESS_TERMCAP_ue \e'[0m'        # End underline
    set -gx LESS_TERMCAP_us \e'[4;38;5;150m' # Begin underline - Green
else if test "$LIGHTDARK" = "light"
    # Catppuccin Latte (light theme)
    set -gx LESS_TERMCAP_mb \e'[1;91m'     # Begin blinking - Red
    set -gx LESS_TERMCAP_md \e'[1;34m'     # Begin bold - Blue
    set -gx LESS_TERMCAP_me \e'[0m'        # End mode
    set -gx LESS_TERMCAP_se \e'[0m'        # End standout-mode
    set -gx LESS_TERMCAP_so \e'[48;5;98m'\e'[38;5;254m'  # Begin standout - Inverted
    set -gx LESS_TERMCAP_ue \e'[0m'        # End underline
    set -gx LESS_TERMCAP_us \e'[4;38;5;64m' # Begin underline - Green
else
    # Default/fallback - use basic inverted colors
    set -gx LESS_TERMCAP_mb \e'[1;31m'
    set -gx LESS_TERMCAP_md \e'[1;34m'
    set -gx LESS_TERMCAP_me \e'[0m'
    set -gx LESS_TERMCAP_se \e'[0m'
    set -gx LESS_TERMCAP_so \e'[7m'        # Standard reverse video
    set -gx LESS_TERMCAP_ue \e'[0m'
    set -gx LESS_TERMCAP_us \e'[4;32m'
end

# Set pager with theme
set -gx PAGER "moor --quit-if-one-screen --style=$ZSH_THEME"

# Generate LS_COLORS if vivid is available
if command -q vivid
    set -gx LS_COLORS (vivid generate $ZSH_THEME)
end