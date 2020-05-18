#!/bin/zsh

autoload -U colors && colors

err()   { echo "$fg[red]$@$reset_color" }
note()  { echo "$fg[cyan]$@$reset_color" }
log()   { echo "$fg[green]$@$reset_color" }
goget() { go get "$@" 2>/dev/null || err "Failed" }
lns()   { ln -Tfs "$1" "$2" }

DOTFILES="${0:a:h}"

log "Linking..."
mkdir "$HOME/.bin" &>/dev/null
mkdir "$HOME/.config" &>/dev/null
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
source ~/.zshrc

log "Fetching Vim plugins..."
nvim +"PlugInstall | qall"
log "* coc"
nvim +"CocInstall -sync coc-css coc-html coc-json \
      coc-python coc-git coc-emmet coc-yank \
      coc-emmet coc-yaml coc-vimlsp coc-snippets | qall"
log "* python"
python3 -m pip install --user --upgrade pynvim
log "* node"
npm install -g neovim

if [[ `uname` == 'Darwin' ]]; then
    note "You might want to go to https://brew.sh/ and install homebrew."
    note 'Then `brew bundle`.'
fi

if [[ $SHELL != '/bin/zsh' ]]; then
    err 'Do you need to change your shell to `zsh`?'
fi

log Done.
