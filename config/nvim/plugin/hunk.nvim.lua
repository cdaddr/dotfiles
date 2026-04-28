vim.pack.add({ "https://github.com/julienvincent/hunk.nvim" })
require("hunk").setup({
  keys = {
    tree = {
      toggle_file = { "<space>" },
    },
  },
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
  hooks = {
    on_tree_mount = function(context)
      -- shadow global <leader>X mappings with buffer-local <nop> so that
      -- nowait on <space> fires immediately without waiting for global matches
      for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
        if map.lhs:sub(1, 1) == " " and #map.lhs > 1 then
          vim.keymap.set("n", map.lhs, "<nop>", { buffer = context.buf, nowait = true, silent = true })
        end
      end
    end,
  },
})

local function set_hl()
  vim.api.nvim_set_hl(0, "HunkTreeDirIcon", { link = "MiniIconsBlue" })
  vim.api.nvim_set_hl(0, "HunkTreeSelectionIcon", { link = "LineNr" })
  vim.api.nvim_set_hl(0, "HunkTreeFileModified", { link = "Changed" })
  vim.api.nvim_set_hl(0, "HunkTreeFileAdded", { link = "Added" })
  vim.api.nvim_set_hl(0, "HunkTreeFileDeleted", { link = "Removed" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
set_hl()
