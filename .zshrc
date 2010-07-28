export PATH="~/local/bin:$PATH"
export EDITOR="vim"

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
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

setopt autopushd
setopt noclobber

export WORDCHARS="${WORDCHARS:s#/##}"

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

alias pacman=pacman-color
alias pacs='pacman -Ss'
alias paci='pacman -S'

git_prompt() {
    edits=`git status -s 2>/dev/null`
    branch=`git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/^* //'`
    if [[ -n $branch ]] {
        if [[ -n $edits ]] {
            branch="$branch*"
        }
        echo " [$branch]"
    }
}

autoload -U colors
colors

setopt prompt_subst
PROMPT='%{$fg[blue]%}%n@%m %c%{$fg[green]%}$(git_prompt)%{$fg[blue]%} %(?/%{$fg[blue]%}/%{$fg[red]%})%% %{$reset_color%}'

/usr/bin/keychain -Q -q --nogui ~/.ssh/id_rsa
if [[ -f $HOME/.keychain/$HOSTNAME-sh ]] {
    source $HOME/.keychain/$HOSTNAME-sh
}

alias gemi='gem install --no-ri --no-rdoc'
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
export RUBYOPT=
