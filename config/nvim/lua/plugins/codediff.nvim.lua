return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- see colorscheme.lua for highlights
  opts = {
    explorer = {
      view_mode = "tree",
    },
  },
  keys = {
    -- { "<d-d>", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff current buffer" },
  },
}
