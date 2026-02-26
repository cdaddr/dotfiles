return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
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
    { "<d-d>", "<cmd>DiffviewOpen HEAD -- %<cr>", desc = "Diff current buffer" },
    { "<d-D>", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff history current buffer" },
  },
}
