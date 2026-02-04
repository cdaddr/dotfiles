return {
  "sindrets/diffview.nvim",
  opts = function(_)
    local close = { { "n", "x" }, "q", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" } }
    return {
      keymaps = {
        view = { close },
        file_panel = { close },
        file_history_panel = { close },
      },
    }
  end,
  keys = {
    { "<d-d>", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff current buffer" },
  },
}
