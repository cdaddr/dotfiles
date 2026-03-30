-- see colorscheme.lua for highlights
vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })
require('render-markdown').setup({
  render_modes = { "n", "c", "v", "V", "Vs", "", "i", "R", "Rv" },
  heading = {
    border = true,
    above = "▂",
    below = "▀🮂",
    border_virtual = true,
    icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
  },
  code = {
    border = "thin",
    position = "left",
    disable_background = { "diff" },
    width = "block",
  },
  anti_conceal = {
    ignore = { code_border = false },
  },
  completions = {
    lsp = { enabled = true },
    blink = { enabled = true },
  },
  quote = { repeat_linebreak = true },
  sign = { enabled = false },
  patterns = {
    markdown = {
      disable = true,
      directives = {
        { id = 17, name = "conceal_lines" },
        { id = 18, name = "conceal_lines" },
      },
    },
  },
  win_options = {
    showbreak = { default = vim.o.showbreak, rendered = "  " },
    breakindent = { default = vim.o.breakindent, rendered = true },
    breakindentopt = { default = vim.o.breakindentopt, rendered = "" },
  },
})
