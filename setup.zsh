#!/bin/zsh

err()   { echo "$fg[red]$@$reset_color" }
note()  { echo "$fg[cyan]$@$reset_color" }
log()   { echo "$fg[green]$@$reset_color" }
lns()   { rm -r "$2"; ln -Tfs "$1" "$2" }
skip()  { note "  already installed, skipping" }

DOTFILES="${0:a:h}"

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

log "Linking..."
mkdir "$HOME/.bin" &>/dev/null
mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" &>/dev/null
lns "$DOTFILES/ignore"                  "$HOME/.ignore"
lns "$DOTFILES/tmux.conf"               "$HOME/.tmux.conf"
lns "$DOTFILES/config/fish"             "$HOME/.config/fish"
lns "$DOTFILES/config/git"              "$HOME/.config/git"
lns "$DOTFILES/config/i3"               "$HOME/.config/i3"
lns "$DOTFILES/config/nvim"             "$HOME/.config/nvim"
lns "$DOTFILES/config/polybar"          "$HOME/.config/polybar"
lns "$DOTFILES/kitty"                   "$HOME/.config/kitty"
lns "$DOTFILES/dir_colors"              "$HOME/.dir_colors"
lns "$DOTFILES/i3status.conf"           "$HOME/.i3status.conf"
lns "$DOTFILES/rsync.excludes"          "$HOME/.rsync.excludes"

tic -o ~/.terminfo xterm-256color-italic.terminfo
tic -o ~/.terminfo tmux-256color.terminfo

fish -c fisher

log Done.
