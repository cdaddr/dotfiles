return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    default_file_explorer = true,
    columns = {
      { "permissions", highlight = "String" },
      { "mtime", highlight = "Keyword" },
      { "size", align = "left", highlight = "Constant" },
      "icon",
    },
    confirmation = {
      border = "single",
      win_options = { winblend = 0 },
    },
    constrain_cursor = "name",
    watch_for_changes = true,
    keymaps = {
      -- ["<esc>"] = { "actions.close", mode = "n" },
      ["q"] = { "actions.close", mode = "n" },
    },
  },
  keys = {
    { "<Leader>o", "<cmd>Oil<cr>", desc = "Open Oil" },
  },
  lazy = false,
}
