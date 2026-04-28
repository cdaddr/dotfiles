-- https://github.com/cdaddr/dotfiles

-- dotfiles git repo is in ~/.dotfiles and individual folders are symlinked to ~/.config/*
_G.DOTFILES = vim.env.HOME .. "/.dotfiles"
_G.cdaddr = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.opts")
require("config.keymaps")
require("config.autocmds")
require("config.sessions")
