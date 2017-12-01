if whence dircolors >/dev/null; then
    eval `dircolors ~/.dir_colors`
fi
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
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt histignoredups
setopt histignorespace
setopt incappendhistory
setopt extendedglob
setopt nobeep
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ":completion:*:commands" rehash 1

if [[ "$OSTYPE"=~"darwin" ]]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit

# autoload -Uz promptinit
# promptinit

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
ls --color=auto &>/dev/null && alias ls="ls --color=auto" || alias ls="ls -G"
alias la="ls -alh"
alias ll="ls -lh"
alias lss="ls -lh --sort=size -r"
alias pps="ps aux | grep"

alias pacs='pacman -Ss'
alias paci='pacman -S'

autoload -U colors
colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}S'
zstyle ':vcs_info:*' unstagedstr '%F{red}M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b%F{green}:%F{red}%r'
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla git-p4 git-svn hg-git hg-hgsubversion hg-hgsvn
# list untracked files
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%%b%F{blue}[git:%F{green}%b%F{blue}:%%B%c%u%%b%F{blue}]'
    } else {
        zstyle ':vcs_info:*' formats '%%b%F{blue}[git:%F{green}%b%F{blue}:%%B%c%u%F{red}?%%b%F{blue}]'
    }

    vcs_info
}

setopt prompt_subst
if [ $HOST = 'saber' ]
then
    PROMPT='%F{magenta}%n@%M %B%F{green}%~ ${vcs_info_msg_0_}%F{blue}%B%(?/%F{blue}/%F{red})$ %F{reset}%b';
else
    PROMPT='%F{blue}%n@%M %B%F{green}%~ ${vcs_info_msg_0_}%F{blue}%B%(?/%F{blue}/%F{red})$ %F{reset}%b';
fi

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

zstyle :omz:plugins:ssh-agent agent-forwarding on

alias gemi='gem install --no-ri --no-rdoc'

if [[ -f /usr/local/share/chruby/chruby.sh ]] {
    source /usr/local/share/chruby/chruby.sh
    chruby ruby-2.4.1
}

# export VIRTUAL_ENV_DISABLE_PROMPT=1
# source ~/mypython/bin/activate

alias ls="LC_COLLATE=POSIX ls --group-directories-first --color"
export PATH="$HOME/go/bin:$PATH"
