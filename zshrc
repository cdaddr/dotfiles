export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_PLUGINS="$XDG_CONFIG_HOME/zsh"
export FPATH="$ZSH_PLUGINS/functions:$FPATH"

export EDITOR='nvim'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PAGER="less"
export DELTA_PAGER="less -n"
export MANPAGER="nvim +Man!"
export LESS="-R -N -S -g -i -F -X" # raw ANSI color, lineno, chop, exit onescreen, don't clear, search, case-insensitive
export LESS_TERMCAP_mb=$'\e[1;31m'     # Begin blinking - Red
export LESS_TERMCAP_md=$'\e[1;94m'     # Begin bold - Blue
export LESS_TERMCAP_me=$'\e[0m'        # End mode
export LESS_TERMCAP_se=$'\e[0m'        # End standout-mode
export LESS_TERMCAP_so=$'\e[48;5;147m\e[38;5;235m' # Begin standout - Inverted: Lavender bg, Surface0 fg
export LESS_TERMCAP_ue=$'\e[0m'        # End underline
export LESS_TERMCAP_us=$'\e[4;38;5;150m' # Begin underline - Green

source "$HOME/.dotfiles/config/current-theme-env.zsh"

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

############################################################################
## From here down is all junk added by tools.  May need periodic cleanup.

if command -v vivid &>/dev/null; then
  export LS_COLORS="$(vivid generate $VIVID_THEME)"
fi

export WORDCHARS="${WORDCHARS/\/}"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export HOMEBREW_NO_ENV_HINTS=1
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettierdrc.toml"

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

# flags
typeset -g __omp_seen=0
typeset -g __omp_last_was_clear=0

# preexec: record the command text in $1
__omp_record_cmd() {
  case "$1" in
    clear|clear\ *) __omp_last_was_clear=1 ;;
    *)              __omp_last_was_clear=0 ;;
  esac
}

# precmd: print a blank line except on first prompt; skip once after `clear`
__omp_add_newline_precmd() {
  if (( __omp_seen )); then
    if (( __omp_last_was_clear )); then
      __omp_last_was_clear=0   # consume the skip so future empty Enters still print
    else
      print ''                 # actual newline before prompt
    fi
  else
    __omp_seen=1
  fi
}

# register hooks
if type add-zsh-hook >/dev/null 2>&1; then
  add-zsh-hook preexec  __omp_record_cmd
  add-zsh-hook precmd   __omp_add_newline_precmd
else
  preexec_functions+=(__omp_record_cmd)
  precmd_functions+=(__omp_add_newline_precmd)
fi
if type add-zsh-hook >/dev/null 2>&1; then
  add-zsh-hook preexec  __omp_record_cmd
  add-zsh-hook precmd   __omp_add_newline_precmd
else
  preexec_functions+=(__omp_record_cmd)
  precmd_functions+=(__omp_add_newline_precmd)
fi
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/zsh/current-theme.omp.json)"

if [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
  unsetopt no_clobber
fi

# Syntax highlighting (must be last)
source "$ZSH_PLUGINS/pnpm.sh"
source "$ZSH_PLUGINS/current-syntax-highlighting.zsh"
source "$ZSH_PLUGINS/current-syntax-highlighting.zsh"
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
