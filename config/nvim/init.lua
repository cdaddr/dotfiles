-- https://github.com/cdaddr/dotfiles

local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
local theme = vim.fn.filereadable(theme_file) == 1 and dofile(theme_file) or { nvim = "default", lualine = "auto" }

-- dotfiles git repo is in ~/.dotfiles and individual folders are symlinked to ~/.config/*
_G.DOTFILES = vim.env.HOME .. "/.dotfiles"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.opts")
require("config.lazy")
require("config.lsp")
require("config.keymaps")
require("config.autocmds")
require("config.sessions")

vim.cmd.colorscheme(theme.nvim)

-- experimental
-- require("vim._extui").enable({
--   enable = true, -- Whether to enable or disable the UI.
--   msg = { -- Options related to the message module.
--     ---@type 'cmd'|'msg' Where to place regular messages, either in the
--     ---cmdline or in a separate ephemeral message window.
--     target = "cmd",
--     timeout = 4000, -- Time a message is visible in the message window.
--   },
-- })
