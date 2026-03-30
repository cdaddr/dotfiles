vim.pack.add({ 'https://github.com/nvim-tree/nvim-tree.lua' })

-- apply git marker colors; linked to standard diff/diagnostic highlights so they
-- work across themes without hardcoding palette values
local function set_git_hl()
  vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { link = "DiffChange" })
  vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { link = "DiffAdd" })
  vim.api.nvim_set_hl(0, "NvimTreeGitMerge", { link = "DiffDelete" })
  vim.api.nvim_set_hl(0, "NvimTreeGitRenamed", { link = "Special" })
  vim.api.nvim_set_hl(0, "NvimTreeGitNew", { link = "DiffAdd" })
  vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { link = "DiffDelete" })
  vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { link = "Comment" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_git_hl })
set_git_hl()

require('nvim-tree').setup({
  renderer = {
    icons = {
      git_placement = "right_align",
      glyphs = {
        git = {
          unstaged = "M",
          staged = "A",
          unmerged = "U",
          renamed = "R",
          untracked = "A",
          deleted = "D",
          ignored = "!",
        },
      },
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.map.on_attach.default(bufnr)
    vim.keymap.set("n", "<Esc>", "<Cmd>wincmd p<CR>", opts("Focus previous window"))
    vim.keymap.set("n", "<C-[>", api.tree.change_root_to_parent, opts("Up"))
  end,
})

-- stylua: ignore start
vim.keymap.set("n", "<d-e>", function() require("nvim-tree.api").tree.open() end, { desc = "nvim-tree: toggle (cwd)" })
vim.keymap.set("n", "<d-E>", function() require("nvim-tree.api").tree.open({ path = vim.fn.expand('%:h') }) end, { desc = "nvim-tree: toggle (buffer dir)" })
-- stylua: ignore end
