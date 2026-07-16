-- eager (now): provides DotenvGet, which deferred vim-dadbod needs at load
now(function()
  vim.pack.add({ "https://github.com/tpope/vim-dotenv" })
end)
