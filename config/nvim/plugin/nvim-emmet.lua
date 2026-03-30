vim.pack.add({ 'https://github.com/olrtg/nvim-emmet' })
vim.keymap.set({ "n", "v" }, "<leader>ew", function()
  require("nvim-emmet").wrap_with_abbreviation()
end, { desc = "Emmet wrap" })
