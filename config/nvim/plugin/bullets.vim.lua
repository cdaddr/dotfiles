-- deferred: markdown/text bullet lists; only relevant in those filetypes
later(function()
  vim.g.bullets_enabled_file_types = { "markdown", "text" }
  vim.pack.add({ "https://github.com/bullets-vim/bullets.vim" })
end)
