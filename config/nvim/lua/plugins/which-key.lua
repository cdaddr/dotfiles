return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  ---@type wk.Opts
  opts = {
    delay = 200,
    spec = {
      { "<leader>f", group = "File" },
      { "<leader>b", group = "Buffers" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Gitsigns (hunks)" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Terminal" },
      { "<leader>u", group = "Toggle" },
      { "<leader>x", group = "Execute" },
    },
    icons = {
      mappings = false,
      breadcrumb = "",
      separator = "⇒",
      group = "+",
    },

    win = {
      border = "double",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
