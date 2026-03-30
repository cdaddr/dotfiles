vim.pack.add({ 'https://github.com/sindrets/diffview.nvim' })

local close = { { "n", "x" }, "q", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" } }
require('diffview').setup({
  keymaps = {
    view = { close },
    file_panel = { close },
    file_history_panel = { close },
  },
})

vim.keymap.set("n", "<d-d>", "<cmd>DiffviewOpen HEAD -- %<cr>", { desc = "Diff current buffer" })
vim.keymap.set("n", "<d-D>", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diff history current buffer" })
