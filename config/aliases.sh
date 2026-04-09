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
alias j="jjui"
alias h="atuin"
alias hh="atuin history list --human"

alias mkvenv='python3 -m venv .venv'
alias venv='source .venv/bin/activate'
alias novenv='deactivate'
alias npm-installed='npm list -g --depth=0'
alias brew-installed='brew bundle dump'
alias rsync="rsync --exclude='.DS_Store'"

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

# fetch from remote and rebase @ onto the updated remote bookmark
jjp() {
  local bookmark
  bookmark=$(jj log -r 'latest(ancestors(@) & bookmarks())' --no-graph -T 'bookmarks' 2>/dev/null | head -1)
  if [[ -z "$bookmark" ]]; then
    echo "jjp: could not determine bookmark" >&2
    return 1
  fi
  echo "jjp: rebasing onto ${bookmark}@origin"
  jj git fetch && jj rebase -d "${bookmark}@origin"
}

# [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
