return {
  "kristijanhusak/vim-dadbod-ui",
  lazy = false,
  dependencies = {
    { "tpope/vim-dadbod", lazy = false },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = false },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
