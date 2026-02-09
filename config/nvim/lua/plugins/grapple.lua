return {
  "cbochs/grapple.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  opts = {
    scope = "git", -- also try out "git_branch"
    statusline = {
      include_icon = false,
      active = "[%s]",
      inactive = " %s ",
    },
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  keys = {
    { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle" },
    { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple list tags" },
    { "<leader>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },

    { "<leader>]", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple next" },
    { "<tab>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple next" },

    { "<leader>[", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple previous" },
    { "<s-tab>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple previous" },
  },
}
