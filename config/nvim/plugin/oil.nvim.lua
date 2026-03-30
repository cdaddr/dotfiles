vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
})

require('oil').setup({
  default_file_explorer = true,
  columns = {
    { "permissions", highlight = "String" },
    { "mtime", highlight = "Keyword" },
    { "size", align = "left", highlight = "Constant" },
    "icon",
  },
  float = { padding = 4 },
  confirmation = {
    border = "single",
    win_options = { winblend = 0 },
  },
  constrain_cursor = "name",
  watch_for_changes = true,
  keymaps = {
    ["q"] = { "actions.close", mode = "n" },
    ["<bs>"] = { "actions.parent", mode = "n" },
    ["<s-cr>"] = { "actions.select", opts = { vertical = true, close = true }, mode = "n" },
    ["<s-d-cr>"] = { "actions.select", opts = { horizontal = true, close = true }, mode = "n" },
    ["<C-h>"] = false,
  },
})

vim.keymap.set("n", "<Leader>o", function() require("oil").open_float() end, { desc = "Open Oil (float)" })
vim.keymap.set("n", "<Leader>O", function() require("oil").open() end, { desc = "Open Oil" })
