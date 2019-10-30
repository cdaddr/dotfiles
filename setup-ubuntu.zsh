#!/bin/zsh
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt install -y git zsh docker docker-compose \
    python3 python-dev python-pip python3-dev python3-pip python-openssl \
    i3-gaps npm tmux feh hsetroot fzf tldr ripgrep fd-find neovim \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev
