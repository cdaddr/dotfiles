export PATH="$HOME/local/bin:$PATH"
export EDITOR="vim"
export PAGER="less"
export RUBYOPT=rubygems

bindkey -e
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\e[5~' history-beginning-search-backward
bindkey '\e[6~' history-beginning-search-forward
bindkey '\e[1;3D' emacs-backward-word
bindkey '\e[1;3C' emacs-forward-word
bindkey '\e[3~' delete-char
bindkey '\e[3;3~' delete-word
bindkey -s '\e[' '\\\C-v['

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt histignoredups
setopt histignorespace
setopt incappendhistory
setopt extendedglob
setopt nobeep
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

setopt autopushd
setopt noclobber
setopt rc_quotes
setopt shortloops
setopt check_jobs
setopt notify

export WORDCHARS="${WORDCHARS//[\/_.]/}"

setopt autolist
setopt listtypes
setopt nolist_ambiguous
setopt nomenucomplete
setopt noautoremoveslash
setopt auto_param_keys

setopt sharehistory

alias info=pinfo
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias la="ls -alh"
alias ll="ls -lh"
alias lss="ls -lh --sort=size -r"
alias pps="ps aux | grep"

alias pacs='pacman -Ss'
alias paci='pacman -S'

autoload -U colors
colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{28}●'
zstyle ':vcs_info:*' unstagedstr '%F{11}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' [%F{green}%b%c%u%F{blue}]'
    } else {
        zstyle ':vcs_info:*' formats ' [%F{green}%b%c%u%F{red}●%F{blue}]'
    }

    vcs_info
}

setopt prompt_subst
PROMPT='%F{blue}%n@%m %c${vcs_info_msg_0_}%F{blue} %(?/%F{blue}/%F{red})%% %F{reset}'

/usr/bin/keychain -Q -q --nogui ~/.ssh/id_rsa
if [[ -f $HOME/.keychain/$HOST-sh ]] {
    source $HOME/.keychain/$HOST-sh
}

alias gemi='gem install --no-ri --no-rdoc'
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
