local util = require("util")

vim.pack.add({ "https://github.com/julienvincent/hunk.nvim" })
require("hunk").setup({
  ui = {
    tree = {
      mode = "nested",
    },
    icons = {
      enable_file_icons = true,

      selected = "󰡖",
      deselected = "",
      partially_selected = "󰛲",

      folder_open = "",
      folder_closed = "",

      expanded = "",
      collapsed = "",
    },
  },
})

util.on_colorscheme(function()
  vim.api.nvim_set_hl(0, "HunkTreeDirIcon", { link = "MiniIconsBlue" })
  vim.api.nvim_set_hl(0, "HunkTreeSelectionIcon", { link = "LineNr" })
  vim.api.nvim_set_hl(0, "HunkTreeFileModified", { link = "Changed" })
  vim.api.nvim_set_hl(0, "HunkTreeFileAdded", { link = "Added" })
  vim.api.nvim_set_hl(0, "HunkTreeFileDeleted", { link = "Removed" })
end)
