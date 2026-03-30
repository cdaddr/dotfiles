vim.pack.add({ 'https://github.com/folke/which-key.nvim' })
require('which-key').setup({
  preset = "helix",
  delay = 100,
  spec = {
    { "<leader>f", group = "File" },
    { "<leader>b", group = "Buffers" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Gitsigns (hunks)" },
    { "<leader>l", group = "LSP" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Terminal" },
    { "<leader>x", group = "Execute" },
    { "\\", group = "Toggle" },
  },
  icons = {
    mappings = false,
    breadcrumb = "",
    separator = "⇒",
    group = "+",
  },
  win = {
    no_overlap = true,
    border = "rounded",
    padding = { 0, 0 },
    wo = { winblend = 25 },
  },
  show_help = false,
  disable = { bt = { "nofile" } },
  keys = {
    scroll_down = "<c-j>",
    scroll_up = "<c-k>",
  },
})
