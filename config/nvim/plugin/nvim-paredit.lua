-- deferred: lisp structural editing; only relevant in clojure/fennel/lisp buffers
later(function()
  vim.pack.add({ "https://github.com/julienvincent/nvim-paredit" })
  require("nvim-paredit").setup()
end)
