
if test -e $HOME/.config/fish/aliases.fish
    source $HOME/.config/fish/aliases.fish
end

if test -e $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
end

set -x EDITOR nvim
set -x PAGER less
set -x FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude '*~'"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x PATH $HOME/.bin $PATH
set NVM_DIR "$HOME/.nvm"

status --is-interactive && source (pyenv init -|psub)
status --is-interactive && source (rbenv init -|psub)
status --is-interactive && source (jenv init  -|psub)

starship init fish | source
