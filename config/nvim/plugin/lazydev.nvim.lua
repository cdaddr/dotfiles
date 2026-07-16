-- deferred: lua LSP dev support; only needed once an LSP attaches
later(function()
  vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end)
