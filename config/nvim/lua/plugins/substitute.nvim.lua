return {
  "gbprod/substitute.nvim",
  lazy = false,
  config = function()
    require("substitute").setup()
    vim.keymap.set("n", "<leader>s", require("substitute").operator, { desc = "Substitute" })
    vim.keymap.set("n", "<leader>S", require("substitute").line, { desc = "Substitute line" })
    vim.keymap.set("n", "S", require("substitute").eol, { desc = "Substitute eol" })
    vim.keymap.set("x", "s", require("substitute").visual, { desc = "Substitute" })
  end,
}
