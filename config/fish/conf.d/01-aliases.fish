# Aliases for Fish shell

# eza (modern ls replacement)
alias eza "eza --git --group-directories-first --icons=never --no-quotes"
alias ls "eza"
alias ll "eza -lhmM -o --icons=never"
alias la "eza -a"
alias lla "ll -a"
alias lls "ll --sort=size"
alias lld "ll --sort=modified"
alias llt "ll -T --level=1"

# ripgrep (rg) with nice colors
alias rg "rg --sort=path --follow --smart-case --column --colors='match:fg:red' --colors='line:fg:147,153,178' --colors='column:fg:147,153,178' --colors='path:fg:yellow'"
alias rgs "rg --no-heading --no-line-number --no-column"

# Python virtual environments
alias mkvenv 'python3 -m venv .venv'
alias venv 'source .venv/bin/activate'
alias novenv 'deactivate'

# Package managers
alias npm-installed 'npm list -g --depth=0'
alias brew-installed 'brew bundle dump'

# Utilities
alias rsync "rsync --exclude='.DS_Store'"
alias vim nvim
alias vimdiff 'nvim -d'
alias history 'history --max=0'  # Fish history command

# Configuration shortcuts
alias zrc 'vim ~/.zshrc'
alias frc 'vim $XDG_CONFIG_HOME/fish/config.fish'
alias vrc 'cd $XDG_CONFIG_HOME/nvim && nvim init.lua'

# Git shortcuts (for dotfiles)
alias cfg 'git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias c 'git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cg 'lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Tool reminder functions (Fish style)
function du
    echo -e "\033[31m** reminder: use dua instead of du \033[0m"
    command dua $argv
end

function grep
    echo -e "\033[31m** reminder: use rg instead of grep \033[0m"
    command rg $argv
end