
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
set -x PATH /usr/local/opt/coreutils/libexec/gnubin/ $HOME/.bin $HOME/.cargo/bin $PATH
set -x LIBRARY_PATH LIBRARY_PATH /usr/local/lib
set -x NVM_DIR "$HOME/.nvm"

status --is-interactive && type -q pyenv && source (pyenv init -|psub)
status --is-interactive && type -q rbenv && source (rbenv init -|psub)
status --is-interactive && type -q jenv && source (jenv init  -|psub)
status --is-interactive && type -q starship && starship init fish | source
function fish_right_prompt -d 'right prompt'
    printf (set_color -d brblue)
    date '+%m/%d %r'
    printf (set_color normal)
end
