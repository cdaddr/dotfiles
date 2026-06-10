export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_PLUGINS="$XDG_CONFIG_HOME/zsh"
export FPATH="$ZSH_PLUGINS/functions:$FPATH"

# Terminal I/O must happen BEFORE the instant-prompt preamble below; once instant
# prompt takes over the TTY, stty would fail and p10k warns about console output.
# free up ^Q ^S ^P ^O
[[ -t 0 ]] && stty stop undef start undef rprnt undef discard undef

# Powerlevel10k instant prompt: render a prompt immediately while the rest of
# this file runs. Must stay near the top and before anything prints to console.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR='nvim'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PAGER="less"
export DELTA_PAGER="less -n"
export MANPAGER="nvim +Man!"
export LESS="-R -S -g -i -F -X" # raw ANSI color, lineno, chop, exit onescreen, don't clear, search, case-insensitive
export LESS_TERMCAP_mb=$'\e[1;31m'     # Begin blinking - Red
export LESS_TERMCAP_md=$'\e[1;94m'     # Begin bold - Blue
export LESS_TERMCAP_me=$'\e[0m'        # End mode
export LESS_TERMCAP_se=$'\e[0m'        # End standout-mode
export LESS_TERMCAP_so=$'\e[48;5;147m\e[38;5;235m' # Begin standout - Inverted: Lavender bg, Surface0 fg
export LESS_TERMCAP_ue=$'\e[0m'        # End underline
export LESS_TERMCAP_us=$'\e[4;38;5;150m' # Begin underline - Green

source "$HOME/.dotfiles/config/current-theme-env.zsh"

# generate LS_COLORS before completion list-colors captures it (below)
# cache vivid output; regenerate only when the theme env file changes
if command -v vivid &>/dev/null; then
  _ls_colors_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/ls_colors-$VIVID_THEME"
  [[ -d "${_ls_colors_cache:h}" ]] || mkdir -p "${_ls_colors_cache:h}"
  if [[ ! -s "$_ls_colors_cache" || "$HOME/.dotfiles/config/current-theme-env.zsh" -nt "$_ls_colors_cache" ]]; then
    vivid generate $VIVID_THEME >| "$_ls_colors_cache"
  fi
  export LS_COLORS="$(<$_ls_colors_cache)"
  unset _ls_colors_cache
fi

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

export VOLTA_HOME="$XDG_DATA_HOME/volta"
export PATH=$HOME/bin:$HOME/.local/bin:$VOLTA_HOME/bin:/usr/local/bin:$PATH

############################################################################
## From here down is all junk added by tools.  May need periodic cleanup.

export WORDCHARS="${WORDCHARS/\/}"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export HOMEBREW_NO_ENV_HINTS=1
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export JJ_CONFIG="$XDG_CONFIG_HOME/jj"
export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettierdrc.toml"

# cache a tool's init script and source it; regenerate when the binary is newer.
# converts a per-startup subprocess spawn into a plain file source.
_cache_init() {  # _cache_init <name> <binary> <command...>
  local f="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init-$1.zsh" bin=$2
  shift 2
  [[ -d "${f:h}" ]] || mkdir -p "${f:h}"
  if [[ ! -s "$f" || "$commands[$bin]" -nt "$f" ]]; then
    "$@" >| "$f" 2>/dev/null
  fi
  source "$f"
}
# rebuild cached tool init scripts (run after upgrading these tools)
cacherebuild() { rm -f "${XDG_CACHE_HOME:-$HOME/.cache}"/zsh/init-*.zsh "${XDG_CACHE_HOME:-$HOME/.cache}"/zsh/ls_colors-* && echo "Tool init cache cleared; reopen the shell." }

_cache_init zoxide zoxide zoxide init zsh
_cache_init atuin atuin atuin init zsh --disable-up-arrow

if [[ -f  "$HOME/.local/share/cargo/env" ]]; then
    source "$HOME/.local/share/cargo/env"
    export PATH="$PATH:$CARGO_HOME/bin"
fi

if [[ -f "$XDG_CONFIG_HOME/zsh-private.sh" ]]; then
    source "$XDG_CONFIG_HOME/zsh-private.sh"
fi

if type mise &>/dev/null; then
  _cache_init mise mise mise activate zsh
fi

export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$GOPATH/bin"

# Powerlevel10k prompt. Uses the gitstatus daemon (no per-prompt git fork) and
# pairs with the instant-prompt block at the top of this file. The blank line
# before each prompt is provided by POWERLEVEL9K_PROMPT_ADD_NEWLINE in p10k.zsh.
if [[ -r /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
  source "$ZSH_PLUGINS/p10k.zsh"
fi

if [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
  unsetopt no_clobber
fi

# Syntax highlighting (must be last)
source "$ZSH_PLUGINS/pnpm.sh"
eval "$(zsh-patina activate)"
