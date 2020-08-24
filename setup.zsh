#!/bin/zsh

autoload -U colors && colors

err()   { echo "$fg[red]$@$reset_color" }
note()  { echo "$fg[cyan]$@$reset_color" }
log()   { echo "$fg[green]$@$reset_color" }
goget() { go get "$@" 2>/dev/null || err "Failed" }
lns()   { ln -Tfs "$1" "$2" }
skip()  { note "  already installed, skipping" }

DOTFILES="${0:a:h}"

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

log "Linking..."
mkdir "$HOME/.bin" &>/dev/null
mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" &>/dev/null
lns "$DOTFILES/gitconfig"               "$HOME/.gitconfig"
lns "$DOTFILES/gitignore"               "$HOME/.gitignore"
lns "$DOTFILES/ignore"                  "$HOME/.ignore"
lns "$DOTFILES/tmux.conf"               "$HOME/.tmux.conf"
lns "$DOTFILES/zsh"                     "$HOME/.zsh"
lns "$DOTFILES/zshrc"                   "$HOME/.zshrc"
lns "$DOTFILES/config/nvim"             "$HOME/.config/nvim"
lns "$DOTFILES/config/i3"               "$HOME/.config/i3"
lns "$DOTFILES/dir_colors"              "$HOME/.dir_colors"
lns "$DOTFILES/i3status.conf"           "$HOME/.i3status.conf"
lns "$DOTFILES/rsync.excludes"          "$HOME/.rsync.excludes"

tic -o ~/.terminfo xterm-256color-italic.terminfo
tic -o ~/.terminfo tmux-256color.terminfo

log "Sourcing zshrc..."
source "$HOME/.zshrc"

log "Version managers..."
log "* node (nvm)..."
if type pyenv > /dev/null; then
    skip
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi

log "* python (pyenv)"
if type pyenv > /dev/null; then
    skip
else
    curl https://pyenv.run | bash
fi


log "* ruby (rbenv)"
if [[ `uname` == 'Darwin' ]]; then
    if type rbenv > /dev/null; then
        skip
    else
        brew install rbenv
    fi
else
    err "Install rbenv manually: https://github.com/rbenv/rbenv"
fi

log "* rust (cargo)"
if type rustup > /dev/null; then
    skip
else
    curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
    rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
fi

log "Vim plugins and LSP..."
python3 -m pip install --user --upgrade pynvim

pip install python-language-server rope pyflakes pycodestyle yapf
npm upgrade -g dockerfile-language-server-nodejs
npm upgrade -g vscode-css-languageserver-bin
npm upgrade -g neovim
npm upgrade -g vim-language-server
npm upgrade -g vscode-html-languageserver-bin
gem install solargraph

if [[ `uname` == 'Darwin' ]]; then
    note "You might want to go to https://brew.sh/ and install homebrew."
    note 'Then `brew bundle`.'
fi

if [[ $SHELL != '/bin/zsh' ]]; then
    err 'Do you need to change your shell to `zsh`?'
fi

log Done.
