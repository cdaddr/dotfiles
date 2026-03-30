vim.pack.add({ 'https://github.com/monkoose/neocodeium' })
require('neocodeium').setup({
  show_label = false,
  silent = true,
  disable_in_special_buftypes = true,
  single_line = { enabled = false },
  filter = function(bufnr)
    if vim.endswith(vim.api.nvim_buf_get_name(bufnr), ".env") then
      return false
    end
    return true
  end,
})
-- stylua: ignore start
vim.keymap.set("i", "<D-l>", function() require'neocodeium'.accept() end, { desc = "Accept neocodeium" })
vim.keymap.set("i", "<D-L>", function() require'neocodeium'.accept_line() end, { desc = "Accept neocodeium line" })
vim.keymap.set("i", "<D-g>", function() require'neocodeium'.cycle() end, { desc = "Next neocodeium suggestion" })
vim.keymap.set("i", "<D-G>", function() require'neocodeium'.cycle(-1) end, { desc = "Prev neocodeium suggestion" })
-- stylua: ignore end
