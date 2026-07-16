-- deferred: completion-kind icons; consumed by blink which is also deferred
later(function()
  vim.pack.add({ "https://github.com/onsails/lspkind.nvim" })
  require("lspkind").setup({})
end)
