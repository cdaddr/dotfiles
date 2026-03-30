vim.pack.add({ 'https://github.com/XXiaoA/atone.nvim' })
require('atone').setup({})
vim.keymap.set("n", "U", "<cmd>Atone<cr>", { desc = "Atone (undo tree)" })
