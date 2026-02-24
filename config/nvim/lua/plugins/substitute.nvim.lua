return {
  "gbprod/substitute.nvim",
  lazy = false,
  config = function()
    require("substitute").setup()
    vim.keymap.set("n", "s", require("substitute").operator, { desc = "Substitute" })
    vim.keymap.set("n", "ss", require("substitute").line, { desc = "Substitute line" })
    vim.keymap.set("n", "S", require("substitute").eol, { desc = "Substitute eol" })
    vim.keymap.set("x", "s", require("substitute").visual, { desc = "Substitute" })
    vim.notify(vim.inspect("foo"))
  end,
}
