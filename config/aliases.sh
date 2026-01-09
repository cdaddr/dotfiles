[[ -f $XDG_CONFIG_HOME/zsh/colors.sh ]] && source $XDG_CONFIG_HOME/zsh/colors.sh

alias eza="eza --git --group-directories-first --icons=never --no-quotes"
alias ls="eza"
alias ll="eza -lhmM -o --icons=never"
alias la="eza -a"
alias lla="ll -a"
alias lls="ll --sort=size"
alias lld="ll --sort=modified"
alias llt="ll -T --level=1"
alias rg="rg --sort=path --follow --smart-case --column --colors='match:fg:red' --colors='line:fg:147,153,178' --colors='column:fg:147,153,178' --colors='path:fg:yellow'"
alias rgs="rg --no-heading --no-line-number --no-column"
alias gg="lazygit"
alias h="atuin"
alias hh="atuin history list --human"

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
alias vrc='cd $XDG_CONFIG_HOME/nvim && nvim && popd'
alias history='history 0'

alias_reminder() {
  local original="$1"
  local replacement="$2"
  local RED=$RED

  eval "$original() {
    echo -e \"${RED}** reminder: use $replacement instead of $original ${RESET}\n\"
    command $replacement \"\$@\"
  }"
}

alias_reminder "du" "dua"
alias_reminder "grep" "rg"
