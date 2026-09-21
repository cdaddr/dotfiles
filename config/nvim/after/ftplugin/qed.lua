-- qed interviews are indented in multiples of 4; QEDIndent() steps by &sw,
-- so the global sw=2 would auto-indent at half the file's real width
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
