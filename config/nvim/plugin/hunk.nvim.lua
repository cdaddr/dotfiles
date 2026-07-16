local util = require("util")

-- deferred: git-hunk staging UI, opened on demand
-- hunk depends on nui.nvim; declare it explicitly rather than relying on another
-- plugin (codediff) having added it first — that ordering breaks once either defers.
later(function()
  vim.pack.add({
    "https://github.com/julienvincent/hunk.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
  })
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
end)
