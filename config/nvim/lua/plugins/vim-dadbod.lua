return {
  "kristijanhusak/vim-dadbod-ui",
  lazy = false,
  dependencies = {
    { "tpope/vim-dadbod", lazy = false },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    -- Set default DB for standalone SQL file completions (via vim-dotenv .env)
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        if not vim.g.db then
          local ok, url = pcall(vim.fn.DotenvGet, "DATABASE_URL")
          if ok and url and url ~= "" then
            vim.g.db = url
          elseif vim.env.DATABASE_URL and vim.env.DATABASE_URL ~= "" then
            vim.g.db = vim.env.DATABASE_URL
          end
        end
      end,
    })
  end,
}
