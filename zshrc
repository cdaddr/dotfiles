export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_PLUGINS="$XDG_CONFIG_HOME/zsh"
export FPATH="$ZSH_PLUGINS/functions:$FPATH"

# Load theme environment variables
source "$HOME/.dotfiles/config/current-theme-env.zsh"

if [[ -n $INTELLIJ ]]; then
  export LIGHTDARK=light
else
  export LIGHTDARK=$(cat $XDG_CONFIG_HOME/lightdark 2>/dev/null || echo 'dark')
fi

if [[ $LIGHTDARK == "light" ]]; then
  export ZSH_THEME="catppuccin-frappe"
else
  export ZSH_THEME="catppuccin-macchiato"
fi

# Set LESS_TERMCAP variables based on ZSH_THEME for Catppuccin colors
if [[ "$LIGHTDARK" == "dark" ]]; then
    # Catppuccin Mocha (dark theme)
    export LESS_TERMCAP_mb=$'\e[1;31m'     # Begin blinking - Red
    export LESS_TERMCAP_md=$'\e[1;94m'     # Begin bold - Blue
    export LESS_TERMCAP_me=$'\e[0m'        # End mode
    export LESS_TERMCAP_se=$'\e[0m'        # End standout-mode
    export LESS_TERMCAP_so=$'\e[48;5;147m\e[38;5;235m' # Begin standout - Inverted: Lavender bg, Surface0 fg
    export LESS_TERMCAP_ue=$'\e[0m'        # End underline
    export LESS_TERMCAP_us=$'\e[4;38;5;150m' # Begin underline - Green
elif [[ "$LIGHTDARK" == "light" ]]; then
    # Catppuccin Latte (light theme)
    export LESS_TERMCAP_mb=$'\e[1;91m'     # Begin blinking - Red
    export LESS_TERMCAP_md=$'\e[1;34m'     # Begin bold - Blue
    export LESS_TERMCAP_me=$'\e[0m'        # End mode
    export LESS_TERMCAP_se=$'\e[0m'        # End standout-mode
    export LESS_TERMCAP_so=$'\e[48;5;98m\e[38;5;254m'  # Begin standout - Inverted: Mauve bg, Surface0 fg
    export LESS_TERMCAP_ue=$'\e[0m'        # End underline
    export LESS_TERMCAP_us=$'\e[4;38;5;64m' # Begin underline - Green
else
    # Default/fallback - use basic inverted colors
    export LESS_TERMCAP_mb=$'\e[1;31m'
    export LESS_TERMCAP_md=$'\e[1;34m'
    export LESS_TERMCAP_me=$'\e[0m'
    export LESS_TERMCAP_se=$'\e[0m'
    export LESS_TERMCAP_so=$'\e[7m'        # Standard reverse video
    export LESS_TERMCAP_ue=$'\e[0m'
    export LESS_TERMCAP_us=$'\e[4;32m'
fi

if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate $VIVID_THEME)"
fi

# Homebrew coreutils (Apple Silicon path)
[[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]] && PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Completion system - cache dump file with zsh version
# Rebuild manually with: comprebuild
autoload -Uz compinit
_comp_dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d "${_comp_dump:h}" ]] || mkdir -p "${_comp_dump:h}"
comprebuild() { compinit -u -d "$_comp_dump" && echo "Completion cache rebuilt." }
compinit -C -u -d "$_comp_dump"
unset _comp_dump
autoload -Uz _git

export EDITOR='nvim'
export PAGER="moor --quit-if-one-screen --style=$MOOR_THEME"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export WORDCHARS="${WORDCHARS/\/}"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export HOMEBREW_NO_ENV_HINTS=1
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"


setopt extended_history # save timestamps with history entries
setopt hist_ignore_all_dups # remove older duplicate commands from history
setopt hist_find_no_dups # don't display dupes from history
setopt hist_ignore_space # don't save commands that start with a space
setopt hist_verify # show history expansion before executing
setopt hist_no_store # don't store history commands in history
setopt share_history # share history between all zsh sessions
setopt inc_append_history # add commands to history immediately after execution
export HISTSIZE=100000 # number of commands to keep in memory
export SAVEHIST=$HISTSIZE # number of commands to save to history file
export HISTFILE="$HOME/.zsh_history" # location of history file

setopt auto_pushd # automatically push directories onto directory stack
setopt extended_glob # enable extended globbing patterns
setopt no_auto_remove_slash # don't remove trailing slash from completed directories
setopt auto_param_keys # automatically insert closing brackets/quotes
setopt prompt_subst # enable parameter expansion in prompts
setopt short_loops # allow short forms of for/while/if loops
setopt check_jobs # check for running jobs before exiting shell
setopt notify # report job status changes immediately
setopt no_beep # disable terminal beeping
setopt no_clobber # don't overwrite existing files with > redirection

# completion
setopt list_types # show file types in completion listings
setopt glob_complete # don't expand * into multiple words when completing
setopt auto_list # show completions immediately
setopt auto_menu # menu after 2nd tab
setopt complete_in_word # complete mid-word

zstyle ":completion:*" matcher-list '' # disable case-insensitive matching
zstyle ':completion:*' menu select # enable interactive completion menu
zstyle ':completion:*:*:-command-:*:*' group-order aliases functions builtins commands # set completion grouping order
zstyle ':completion:*' group-name '' # enable grouping of completion matches
zstyle ':completion:*' squeeze-slashes true # remove duplicate slashes in paths

# fix to make the completion menu selected item text black
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f' # format for group descriptions (duplicate)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=00;30;48;5;111' # override selected item colors to black text

zstyle ':completion:*:*:git:*' script $XDG_CONFIG_HOME/bash/git-completion.bash


# zstyle ':completion::complete:git-checkout:argument-rest:headrefs' command "git for-each-ref --format='%(refname)' refs/heads 2>/dev/null"
# zstyle ':completion::*:git::*' remote-branches false
# zstyle ':completion::complete:git-checkout:*' tag-refs false

# free up ^Q ^S ^P ^O
stty stop undef start undef rprnt undef discard undef

bindkey -e # emacs style
bindkey '\e[H' beginning-of-line # home
bindkey '\e[1~' beginning-of-line # home
bindkey '\e[F' end-of-line # end
bindkey '\e[4~' end-of-line # end
bindkey '\e[5~' history-beginning-search-backward # pageup
bindkey '\e[6~' history-beginning-search-forward # pagedown
bindkey '\e[1;3D' emacs-backward-word # alt-left
bindkey '\e[1;3C' emacs-forward-word # alt-right
bindkey '\e[3~' delete-char # del
bindkey '\e[3;3~' delete-word # alt-del

zmodload zsh/complist
bindkey -M menuselect '^S' history-incremental-search-forward
bindkey -M menuselect '^R' history-incremental-search-backward
bindkey '^[[Z' reverse-menu-complete # shift-tab (in menus)

if [[ -f  "$XDG_CONFIG_HOME/aliases.sh" ]]; then
    source "$XDG_CONFIG_HOME/aliases.sh"
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


# export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
# help() {
#   "$@" --help 2>&1 | bat --plain --language=help
# }

export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettierdrc.toml"

## From here down is all junk added by tools.  May need periodic cleanup.

eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

if [[ -f  "$HOME/.local/share/cargo/env" ]]; then
    source "$HOME/.local/share/cargo/env"
    export PATH="$PATH:$CARGO_HOME/bin"
fi

if [[ -f "$XDG_CONFIG_HOME/zsh-private.sh" ]]; then
    source "$XDG_CONFIG_HOME/zsh-private.sh"
fi

if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$GOPATH/bin"

eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/zsh/current-theme.omp.json)"

if [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
  unsetopt no_clobber
fi

# Syntax highlighting (must be last)
source "$ZSH_PLUGINS/current-syntax-highlighting.zsh"
source "$ZSH_PLUGINS/current-syntax-highlighting.zsh"
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
