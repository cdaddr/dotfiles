-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- helper for mapping
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-W>", { desc = "Backward delete word" })

-- toggle options
map("n", "\\h", "<cmd>nohls<CR>", { silent = true })
map("n", "\\w", "<cmd>setlocal nowrap!<CR>", { silent = true })

-- moving between windows
map("n", "<Tab>", "<C-w>w")
map("n", "<S-Tab>", "<C-w>W")
map("n", "]]", "<cmd>bnext<cr>")
map("n", "[[", "<cmd>bprev<cr>")

---- delete to black hole
-- map("n", "<Leader>d", '"_d')
-- map("n", "<Leader>D", '"_D')
-- map("n", "<Leader>x", '"_x')
-- map("n", "<Leader>s", '"_s')
-- map("n", "<Leader>S", '"_S')
-- map("n", "<Leader>c", '"_c')
-- map("n", "<Leader>C", '"_C')
