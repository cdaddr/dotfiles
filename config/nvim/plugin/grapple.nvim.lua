vim.pack.add({
  'https://github.com/cbochs/grapple.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
})

local function g(fn_name, arg)
  return function()
    if arg then
      require("grapple")[fn_name](arg)
    else
      require("grapple")[fn_name]()
    end
    require("lualine").refresh()
  end
end

---@type grapple.settings
require('grapple').setup({
  scope = "git",
  statusline = {
    include_icon = false,
    active = "[%s]",
    inactive = " %s ",
  },
  icons = false,
})

vim.keymap.set("n", "<leader>m", g("toggle"), { desc = "Grapple toggle for this buffer" })
vim.keymap.set("n", "<leader><leader>", g("toggle"), { desc = "Grapple toggle for this buffer" })
vim.keymap.set("n", "<leader>M", function() require("config.pickers").grapple() end, { desc = "Grapple buffers & tags" })
vim.keymap.set("n", "<leader>]", g("cycle_tags", "next"), { desc = "Grapple next" })
vim.keymap.set("n", "<tab>", g("cycle_tags", "next"), { desc = "Grapple next" })
vim.keymap.set("n", "<leader>[", g("cycle_tags", "prev"), { desc = "Grapple previous" })
vim.keymap.set("n", "<s-tab>", g("cycle_tags", "prev"), { desc = "Grapple previous" })
