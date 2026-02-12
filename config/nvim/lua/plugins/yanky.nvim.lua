return {
  "gbprod/yanky.nvim",
  opts = {},
  -- config = function ()
  --   -- vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
  --   -- vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
  --   -- vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
  --   -- vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
  --   --
  --   -- vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
  --   -- vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
  --   --
  --   -- vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
  --   -- vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
  --   -- vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
  --   -- vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
  --   require'yanky'.setup {
  --
  --   }
  -- end,
  keys = {
    -- { "<leader>p", "<cmd>YankyRingHistory<cr>", mode = { "n", "x" }, desc = "Open Yank History" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
  },
}
