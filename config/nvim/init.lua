-- https://github.com/cdaddr/dotfiles

-- dotfiles git repo is in ~/.dotfiles and individual folders are symlinked to ~/.config/*
_G.DOTFILES = vim.env.HOME .. "/.dotfiles"
_G.cdaddr = {}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- single plugin-loading mechanism, two verbs:
--   now(fn)   -> load during startup (visual baseline: colorscheme, statusline, …)
--   later(fn) -> load in the background after the UI is responsive
-- init.lua runs at vim_did_init=0 so mini needs an explicit load=true here; plugin/
-- files and later() callbacks run at vim_did_init=1, where vim.pack.add loads by default.
vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, { load = true })
_G.now, _G.later = require("mini.deps").now, require("mini.deps").later

require("config.opts")
require("config.keymaps")
require("config.autocmds")
require("config.sessions")

-- message timeout and expanded cmdline height moved to 'messagesopt' (maxheight is a % of 'lines')
vim.opt.messagesopt:append({ "timeout:4000", "maxheight:50" })
require("vim._core.ui2").enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = "cmd",
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})
