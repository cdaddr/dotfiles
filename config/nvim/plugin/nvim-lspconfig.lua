-- deferred: LSP setup; servers attach to the first buffer a beat after the UI paints
later(function()
  vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
  require("config.lsp")
end)
