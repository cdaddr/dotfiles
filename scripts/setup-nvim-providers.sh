#!/usr/bin/env bash
set -e

VENV_BASE="$HOME/.local/share/venv"
mkdir -p "$VENV_BASE"

# Python provider
echo "Setting up Python provider..."
uv venv "$VENV_BASE/neovim-python"
uv pip install --python "$VENV_BASE/neovim-python/bin/python" pynvim
echo "Python provider ready: $VENV_BASE/neovim-python/bin/python"

# Ruby provider
echo "Setting up Ruby provider..."
RUBY_BIN=$(dirname "$(rv ruby find)")
"$RUBY_BIN/gem" install neovim
echo "Ruby provider ready: $RUBY_BIN/neovim-ruby-host"
