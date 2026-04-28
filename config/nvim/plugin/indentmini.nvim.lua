local util = require("util")

vim.pack.add({ "https://github.com/nvimdev/indentmini.nvim" })

require("indentmini").setup({
  minlevel = 2,
  char = "┊",
})

util.on_colorscheme(function()
  local linenr_hl = vim.api.nvim_get_hl(0, { name = "LineNr" })
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local bg = normal_hl.bg or 0x16161D
  if linenr_hl.fg then
    vim.api.nvim_set_hl(0, "IndentLine", { fg = util.blend(linenr_hl.fg, bg, 0.5) })
    vim.api.nvim_set_hl(0, "IndentLineCurrent", { fg = linenr_hl.fg })
  end
end)
