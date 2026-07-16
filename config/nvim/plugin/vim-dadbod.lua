-- deferred: DB UI (:DBUI) + default DB for SQL completion, loaded on demand
later(function()
  vim.pack.add({
    "https://github.com/kristijanhusak/vim-dadbod-ui",
    "https://github.com/tpope/vim-dadbod",
    -- "https://github.com/kristijanhusak/vim-dadbod-completion",
  })

  vim.g.db_ui_use_nerd_fonts = 1

  -- set default DB for standalone SQL file completions (via vim-dotenv .env).
  -- This used to run on VimEnter; later() already fires after VimEnter, so detect
  -- directly. Needs DotenvGet, so vim-dotenv stays eager (not deferred).
  if not vim.g.db then
    local ok, url = pcall(vim.fn.DotenvGet, "DATABASE_URL")
    if ok and url and url ~= "" then
      vim.g.db = url
    elseif vim.env.DATABASE_URL and vim.env.DATABASE_URL ~= "" then
      vim.g.db = vim.env.DATABASE_URL
    end
  end
end)
