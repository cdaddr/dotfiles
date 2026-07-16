-- deferred: git blame/lineage viewer, on demand
later(function()
  vim.pack.add({ "https://github.com/LionyxML/gitlineage.nvim" })
  require("gitlineage").setup({})
end)
