return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    explorer = {
      view_mode = "tree",
    },
  },
  keys = {
    { "<d-d>", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff current buffer" },
  },
}
