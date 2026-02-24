return {
  "bullets-vim/bullets.vim",
  setup = function()
    vim.g.bullets_enabled_file_types = { "markdown", "text" }
  end,
}
