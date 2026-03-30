-- see colorscheme.lua for highlights
vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

local copy_old_hunk_to_register = function(register)
  local gs = require("gitsigns")
  local hunks = gs.get_hunks()
  if not hunks then return end

  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local hunk = nil
  for _, h in ipairs(hunks) do
    if cursor_line >= h.added.start and cursor_line <= h.added.start + h.added.count - 1 then
      hunk = h
      break
    end
  end

  if not hunk then return end

  local old_lines = {}
  for _, line in ipairs(hunk.lines) do
    if line:sub(1, 1) == "-" then
      table.insert(old_lines, line:sub(2))
    end
  end

  vim.fn.setreg(register or "+", table.concat(old_lines, "\n"), "l")
end

require('gitsigns').setup({
  numhl = false,
  signcolumn = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
    vim.keymap.set("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { buffer = bufnr, desc = "Reset hunk" })
    vim.keymap.set("n", "<leader>hh", gs.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set("n", "<leader>h]", gs.next_hunk, { desc = "Next hunk" })
    vim.keymap.set("n", "<leader>h[", gs.prev_hunk, { desc = "Previous hunk" })
    vim.keymap.set("n", "<leader>hy", function()
      copy_old_hunk_to_register("+")
    end, { desc = "Yank old hunk to default register" })
  end,
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
})
