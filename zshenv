# read by every zsh, including scripts and `ssh host cmd`; keep it fast and silent.
# interactive-only setup (prompt, aliases, completion, plugins) belongs in zshrc.

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR='nvim'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PAGER="less"
export DELTA_PAGER="less -n"
export MANPAGER="nvim +Man!"
export LESS="-R -S -g -i -F -X" # raw ANSI color, lineno, chop, exit onescreen, don't clear, search, case-insensitive

export VOLTA_HOME="$XDG_DATA_HOME/volta"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export HOMEBREW_NO_ENV_HINTS=1
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export JJ_CONFIG="$XDG_CONFIG_HOME/jj"
# trailing colon keeps julia's bundled stdlib depot after the user depot
export JULIA_DEPOT_PATH="$XDG_CONFIG_HOME/julia:"
export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettierdrc.toml"

# what `brew shellenv` exports, minus its subprocess; PATH and fpath are handled below and in zshrc
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew HOMEBREW_CELLAR=/opt/homebrew/Cellar HOMEBREW_REPOSITORY=/opt/homebrew
fi

# put our dirs in front of PATH and tool dirs at the end; (N-/) drops dirs that don't exist.
# zshrc calls this again because /etc/zprofile's path_helper pushes these behind the
# system dirs in login shells (every terminal tab on macOS).
typeset -U path # drop duplicate PATH entries, keeping the first
_dotfiles_path() {
  path=(
    $HOME/bin(N-/) $HOME/.local/bin(N-/) $VOLTA_HOME/bin(N-/) /usr/local/bin(N-/)
    /opt/homebrew/opt/coreutils/libexec/gnubin(N-/) /opt/homebrew/bin(N-/) /opt/homebrew/sbin(N-/)
    $path
    $HOME/local/bin(N-/) $CARGO_HOME/bin(N-/) $HOME/.dotnet/tools(N-/) $GOPATH/bin(N-/)
    $HOME/.orbstack/bin(N-/) "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"(N-/)
  )
}
# skip when inheriting a configured PATH from a parent shell, so scripts and :! in nvim keep
# its order (mise etc.)
(( ${path[(Ie)/opt/homebrew/bin]} )) || _dotfiles_path
