# Tool integrations for Fish shell

# PATH modifications
fish_add_path $HOME/bin $HOME/.local/bin /usr/local/bin

# Homebrew setup
if command -q brew
    set -l brew_prefix (brew --prefix)

    # Add GNU coreutils to PATH (with priority)
    fish_add_path --prepend $brew_prefix/opt/coreutils/libexec/gnubin
end

# Cargo (Rust) setup
if test -f "$HOME/.local/share/cargo/env"
    source "$HOME/.local/share/cargo/env"
end
if test -d "$CARGO_HOME/bin"
    fish_add_path $CARGO_HOME/bin
end

# Go setup
if test -d "$GOPATH/bin"
    fish_add_path $GOPATH/bin
end

# .NET setup
if test -d "$HOME/.dotnet/tools"
    fish_add_path $HOME/.dotnet/tools
end
if test -d "/opt/homebrew/opt/dotnet@9/bin"
    fish_add_path /opt/homebrew/opt/dotnet@9/bin
    set -gx DOTNET_ROOT "/opt/homebrew/opt/dotnet@9/libexec"
end

# PostgreSQL setup
if test -d "/opt/homebrew/opt/postgresql@16/bin"
    fish_add_path /opt/homebrew/opt/postgresql@16/bin
end

# Mise (tool version manager) setup
if command -q mise
    mise activate fish | source
end

# Load private configuration if it exists
if test -f "$XDG_CONFIG_HOME/fish-private.fish"
    source "$XDG_CONFIG_HOME/fish-private.fish"
end