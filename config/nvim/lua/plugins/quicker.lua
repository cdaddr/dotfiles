return {
  "stevearc/quicker.nvim",
  lazy = false,
  ft = "qf",
  ---
  ---@type quicker.SetupOptions
  opts = {
    -- stylua: ignore
    on_qf = function()
      vim.keymap.set("n", "<leader>q", function() require("quicker").close() end, { desc = "Close quickfix", buffer = true })
      vim.keymap.set("n", "q", function() require("quicker").close() end, { desc = "Close quickfix", buffer = true })
      vim.keymap.set("n", "<f2>", function() require("quicker").close() end, { desc = "Close quickfix", buffer = true })
      vim.keymap.set("n", "r", function() require("quicker").refresh() end, { desc = "Refresh quickfix", buffer = true })
    end,
  },
  keys = {
    {
      "<leader>q",
      function()
        require("quicker").open({ focus = true })
      end,
      desc = "Open quickfix",
    },
    -- { "<leader>l", function() require'quicker'.toggle({loclist = true}) end, desc = "Toggle loclist" },
  },
}
