vim.pack.add({
  'https://github.com/AckslD/nvim-neoclip.lua',
  'https://github.com/kkharji/sqlite.lua',
})
require('neoclip').setup({
  history = 50,
  enable_persistent_history = true,
  continuous_sync = false,
  -- disable built-in telescope/fzf-lua integrations
  keys = { telescope = {}, fzf = {} },
})
vim.keymap.set("n", "<leader>sy", function() require("config.pickers").neoclip() end, { desc = "Yank History" })
