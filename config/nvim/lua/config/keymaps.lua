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
map("i", "<C-k>", function()
  Snacks.picker.icons({
    confirm = function(picker, item)
      picker:close()
      vim.api.nvim_put({ item.icon }, "c", false, true)
    end,
  })
end, { desc = "Insert icon" })

map("n", "<cr>", "za", { desc = "Toggle open/close fold under cursor", buffer = true })

map("n", "t", "<cmd>bnext<cr>", { desc = ":bnext" })
map("n", "T", "<cmd>bprevious<cr>", { desc = ":bprevious" })

map("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open Oil" }) -- visual mode reselect pasted text
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

local cabbrev = vim.cmd.cabbrev

cabbrev("<expr>", "E", "(getcmdtype() == ':') ? 'e' : 'E'")
cabbrev("<expr>", "W", "(getcmdtype() == ':') ? 'w' : 'W'")
cabbrev("<expr>", "Q", "(getcmdtype() == ':') ? 'q' : 'Q'")
cabbrev("<expr>", "Qa", "(getcmdtype() == ':') ? 'qa' : 'Qa'")
cabbrev("vrc", ":e $MYVIMRC")
