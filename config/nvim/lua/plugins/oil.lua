return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
      default_file_explorer = true,
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
      },
      constrain_cursor = "name",
      watch_for_changes = true,
      keymaps = {
        ["<esc>"] = { "actions.close", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      }
    }
}
