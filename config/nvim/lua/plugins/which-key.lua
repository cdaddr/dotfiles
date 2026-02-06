return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  ---@type wk.Opts
  opts = {
    -- delay = 200,
    spec = {
      { "<leader>f", group = "File" },
      { "<leader>b", group = "Buffers" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Gitsigns (hunks)" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Terminal" },
      { "<leader>x", group = "Execute" },
      { "\\", group = "Toggle" },
    },
    icons = {
      mappings = false,
      breadcrumb = "",
      separator = "⇒",
      group = "+",
    },

    win = {
      no_overlap = false,
      border = "rounded",
      -- padding = { 0, 0 },
    },
    show_help = false,
  },
}
