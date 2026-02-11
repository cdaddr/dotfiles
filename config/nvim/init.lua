-- nvim config
-- https://github.com/cdaddr/dotfiles

-- Load theme from generated config
local theme_file = vim.fn.expand("~/.dotfiles/config/current-theme.lua")
local theme = dofile(theme_file)
_G.theme = theme
_G.DOTFILES = vim.env.HOME .. "/.dotfiles"

-- Silence deprecation warnings
vim.deprecate = function() end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.opts")
require("config.lazy")
require("config.lsp")
require("config.keymaps")
require("config.autocmds")

vim.cmd.colorscheme(theme.nvim)

vim.diagnostic.config({ virtual_text = true, virtual_lines = false, underline = true, signs = false })

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
