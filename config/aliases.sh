alias eza="eza --git --group-directories-first --icons=auto"
alias ls="eza"
alias ll="eza -lhmgM --no-permissions -o --icons=auto"
alias la="eza -a"
alias lla="ll -a"
alias lls="ll --sort=size"
alias lld="ll --sort=modified"
alias llt="ll -T --level=1"

alias mkvenv='python3 -m venv .venv'
alias venv='source .venv/bin/activate'
alias novenv='deactivate'
alias npm-installed='npm list -g --depth=0'
alias brew-installed='brew bundle dump'
alias rsync="rsync --exclude='.DS_Store'"

alias cfg='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias c='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cg='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim=nvim

alias zrc='vim ~/.zshrc'
alias vimdiff='nvim -d'
alias vrc='cd $XDG_CONFIG_HOME/nvim && nvim -O init.lua lua/plugins/plugins.lua && popd'
alias history='history 0'
