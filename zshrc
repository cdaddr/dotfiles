# env
export LANG=en_CA.UTF-8
export EDITOR="vim"
export PAGER="less"
export GOPATH="$HOME/Documents/go"

# zsh options
autoload -Uz colors && colors

export extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_no_store
setopt hist_ignore_space
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
setopt auto_pushd
setopt extended_glob
setopt no_beep
setopt complete_aliases
setopt no_clobber
setopt short_loops
setopt check_jobs
setopt notify
setopt auto_menu
setopt autolist
setopt list_types
setopt no_list_ambiguous
setopt no_auto_remove_slash
setopt auto_param_keys
setopt prompt_subst

fpath=("$HOME/.zshfunctions" $fpath)
autoload -U promptinit && promptinit
prompt pure


# keybinds
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

export WORDCHARS="${WORDCHARS/\/}"

if [[ `uname` == 'Darwin' ]]; then
    local gnubin="/usr/local/opt/coreutils/libexec/gnubin" 
    local findbin="/usr/local/opt/findutils/libexec/gnubin" 
    if [[ -d $gnubin ]]; then
        export PATH="${gnubin}:$PATH"
    fi
    if [[ -d $findbin ]]; then
        export PATH="${findbin}:$PATH"
    fi
fi


if [[ `ls --color=auto 2>/dev/null` ]]; then
    alias ls="LC_COLLATE=POSIX ls --group-directories-first --color=auto"
    alias ll="ls -lh"
    alias la="la -a"
fi

if [[ $(command dircolors) && -f "$HOME/.dir_colors" ]]; then
    eval $(dircolors "$HOME/.dir_colors")
fi
