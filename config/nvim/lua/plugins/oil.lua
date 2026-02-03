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
    float = {
      padding = 4,
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
      ["<s-cr>"] = { "actions.select", opts = { vertical = true, close = true }, mode = "n" },
      ["<s-d-cr>"] = { "actions.select", opts = { horizontal = true, close = true }, mode = "n" },
    },
  },
  keys = {
    {
      "<Leader>o",
      function()
        require("oil").open_float()
      end,
      desc = "Open Oil",
    },
  },
  lazy = false,
}
