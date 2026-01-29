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
    { "<leader>bt", "<cmd>Grapple tag<cr>", desc = "Grapple tag" },
    { "<leader>bu", "<cmd>Grapple untag<cr>", desc = "Grapple untag" },
    { "<leader>bl", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
    { "<leader>bn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
    { "<leader><tab>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
    { "<leader>bp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
    { "<s-tab>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
  },
}
