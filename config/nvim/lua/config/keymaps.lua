-- stylua: ignore start
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

map("n", "/", "ms/", { desc = "Mark pre-search location when searching" })

map("n", "z1", function() vim.opt.foldlevel = 1 end, { desc = "Set foldlevel=1" })
map("n", "z2", function() vim.opt.foldlevel = 2 end, { desc = "Set foldlevel=2" })
map("n", "z3", function() vim.opt.foldlevel = 3 end, { desc = "Set foldlevel=3" })
map("n", "z4", function() vim.opt.foldlevel = 4 end, { desc = "Set foldlevel=4" })
map("n", "z5", function() vim.opt.foldlevel = 5 end, { desc = "Set foldlevel=5" })
map("n", "z6", function() vim.opt.foldlevel = 6 end, { desc = "Set foldlevel=6" })
map("n", "z7", function() vim.opt.foldlevel = 7 end, { desc = "Set foldlevel=7" })
map("n", "z8", function() vim.opt.foldlevel = 8 end, { desc = "Set foldlevel=8" })
map("n", "z9", function() vim.opt.foldlevel = 9 end, { desc = "Set foldlevel=9" })

map("x", ">", ">gv")
map("x", "<", "<gv")
map("x", "/", "<esc>/\\%V", { desc = "Search in visual selection" })

vim.cmd.cabbrev("<expr>", "E", "(getcmdtype() == ':') ? 'e' : 'E'")
vim.cmd.cabbrev("<expr>", "W", "(getcmdtype() == ':') ? 'w' : 'W'")
vim.cmd.cabbrev("<expr>", "Q", "(getcmdtype() == ':') ? 'q' : 'Q'")
vim.cmd.cabbrev("<expr>", "Qa", "(getcmdtype() == ':') ? 'qa' : 'Qa'")
vim.cmd.cabbrev("vrc", ":e $MYVIMRC")

-- close buffer; also close window if it's a special buffer or unnamed
vim.api.nvim_create_user_command("C", function()
  local is_special = vim.bo.buftype ~= ""
  local is_new = vim.api.nvim_buf_get_name(0) == ""

  if is_special or is_new then
    local ok = pcall(vim.cmd.close)
    if not ok then
    end
  else
    require("mini.bufremove").delete()
  end
  vim.fn.histdel("cmd", "^C$")
end, { desc = "Close buffer (mini.bufremove)" })

vim.cmd.cnoreabbrev("c", "C")
