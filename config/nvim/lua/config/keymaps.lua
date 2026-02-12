local map = function(mode, key, fn, opts)
  opts = vim.tbl_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, key, fn, opts)
end

map({ "i", "c" }, "<M-BS>", "<C-W>", { desc = "Backward delete word" })

map("n", "<esc>", "<cmd>nohls<cr>")

map("n", "<C-j>", "<C-w>j", { desc = "select window down <C-w>j" })
map("n", "<C-k>", "<C-w>k", { desc = "select window up <C-w>k" })
map("n", "<C-h>", "<C-w>h", { desc = "select window left <C-w>h" })
map("n", "<C-l>", "<C-w>l", { desc = "select window right <C-w>l" })

map("n", "<cr>", "za", { desc = "Toggle open/close fold under cursor", buffer = true })

map("n", "t", "<cmd>bnext<cr>", { desc = ":bnext" })
map("n", "T", "<cmd>bprevious<cr>", { desc = ":bprevious" })

map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

map("n", "<C-w>N", "<cmd>botright new<cr>", { desc = "open new split horizontally BOTTOM" })
map("n", "<C-w><C-N>", "<cmd>botright new<cr>", { desc = "open new split horizontally BOTTOM" })

map("n", "<C-w>v", "<cmd>vnew<cr>", { desc = "open new split vertically" })
map("n", "<C-w><C-v>", "<cmd>vnew<cr>", { desc = "open new split vertically" })

map("n", "<C-w>V", "<cmd>topleft vnew<cr>", { desc = "open new split vertically LEFT" })
map("n", "<C-w><C-V>", "<cmd>topleft vnew<cr>", { desc = "open new split vertically LEFT" })

map("n", "<leader>P", '"_Dp', { desc = "Paste to end of line" })

map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", "/", "ms/", { desc = "Mark pre-search location when searching" })
map("v", "/", "<esc>/\\%V", { desc = "Search in visual selection" })

vim.cmd.cabbrev("<expr>", "E", "(getcmdtype() == ':') ? 'e' : 'E'")
vim.cmd.cabbrev("<expr>", "W", "(getcmdtype() == ':') ? 'w' : 'W'")
vim.cmd.cabbrev("<expr>", "Q", "(getcmdtype() == ':') ? 'q' : 'Q'")
vim.cmd.cabbrev("<expr>", "Qa", "(getcmdtype() == ':') ? 'qa' : 'Qa'")
vim.cmd.cabbrev("vrc", ":e $MYVIMRC")
vim.cmd.cnoreabbrev("c", "close")
