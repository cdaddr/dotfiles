-- qed interviews are indented in multiples of 4; QEDIndent() steps by &sw,
-- so the global sw=2 would auto-indent at half the file's real width
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- let conjure evaluate clojure from qed buffers, e.g. :ConjureEval (qed.parser/compile-file "name")
vim.g["conjure#filetype#qed"] = "conjure.client.clojure.nrepl"

-- compile the current interview in the running `lein dev` instance
vim.api.nvim_buf_create_user_command(0, "QedCompile", function()
  vim.cmd("update")
  vim.cmd(('ConjureEval (qed.parser/compile-file "%s")'):format(vim.fn.expand("%:t:r")))
end, { desc = "Compile current interview (qed)" })
vim.keymap.set("n", "<leader>qc", "<cmd>QedCompile<cr>", { buffer = true, desc = "Compile interview (qed)" })
