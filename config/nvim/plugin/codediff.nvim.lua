vim.pack.add({
  'https://github.com/esmuellert/codediff.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
})
require('codediff').setup({
  explorer = { view_mode = "tree" },
})
