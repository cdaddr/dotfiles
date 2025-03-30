export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_PLUGINS="$XDG_CONFIG_HOME/zsh"

if type brew &>/dev/null; then
    local zc="$(brew --prefix)/share/zsh-completions"
    local bc="$(brew --prefix)/share/zsh/site-functions"
    export FPATH="$zc:$bc:$FPATH"

    PATH="$(brew --prefix)/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"

    if [[ `ls --color=auto 2>/dev/null` ]]; then
        alias ls="LC_COLLATE=POSIX ls --group-directories-first --color=auto"
        if type dircolors &>/dev/null && [[ -f "$XDG_CONFIG_HOME/dircolors" ]]; then
            eval $(dircolors "$XDG_CONFIG_HOME/dircolors")
        fi
    fi
fi


source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_PLUGINS/zsh-z/zsh-z.plugin.zsh"
export ZSHZ_CMD=z

autoload -U compinit; compinit

export EDITOR='nvim'
export PAGER="less"
export LANG=en_CA.UTF-8
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude '*~'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export WORDCHARS="${WORDCHARS/\/}"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export HOMEBREW_NO_ENV_HINTS=1

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
setopt no_auto_remove_slash
setopt auto_param_keys
setopt prompt_subst
setopt no_extended_glob
setopt short_loops
setopt check_jobs
setopt notify

source "$XDG_CONFIG_HOME/LS_COLORS.sh"

zstyle ":completion:*" matcher-list ''
zstyle ':completion:*' menu select search
zstyle ':completion:*' fuzzy-match yes
zstyle ':completion:*' rehash true
zstyle ':completion:*:*:-command-:*:*' group-order aliases functions builtins commands
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}" "ma=48;5;153;1"

setopt no_beep
setopt no_clobber
# setopt menu_complete
# setopt auto_menu
setopt auto_list # show completions immediately when >2
setopt list_types
setopt no_list_ambiguous
setopt glob_complete

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

if [[ -f  "$XDG_CONFIG_HOME/aliases.sh" ]]; then
    source "$XDG_CONFIG_HOME/aliases.sh"
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.config/p10k.zsh ]] || source ~/.config/p10k.zsh

if [[ -f  "$HOME/.local/share/cargo/env" ]]; then
    source "$HOME/.local/share/cargo/env"
    export PATH="$PATH:$CARGO_HOME/bin"
fi

[ -f $XDG_CONFIG_HOME/fzf.zsh ] && source $XDG_CONFIG_HOME/fzf.zsh

## From here down is all junk added by tools.  May need periodic cleanup.

export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettierdrc.toml"

typeset -aU path
if [[ -f "$XDG_CONFIG_HOME/zsh-private" ]]; then
    source "$XDG_CONFIG_HOME/zsh-private"
fi
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if type mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi
eval "$($HOME/.local/bin/mise activate zsh)"

source "$HOME/.config/zsh/catppuccin-syntax.zsh"

export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/opt/homebrew/opt/dotnet@9/bin:$PATH"

export DOTNET_ROOT="/opt/homebrew/opt/dotnet@9/libexec"
