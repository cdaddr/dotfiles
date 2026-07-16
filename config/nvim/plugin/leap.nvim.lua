-- deferred: leap motions; the leap keys start working a beat after the UI paints
later(function()
  vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" })
  require("leap").setup({
    safe_labels = "sut/SFNLHMUGTZ?",
    labels = "sjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?",
    keys = {
      next_target = "<cr>",
      prev_target = "<backspace>",
      next_group = "<space>",
      prev_group = "<bs>",
    },
  })
end)
