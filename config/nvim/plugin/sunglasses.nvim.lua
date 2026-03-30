-- filetypes where sunglasses should be completely disabled (not just excluded)
local disable_filetypes = { "help", "qf", "oil", "man", "Trouble" }

vim.pack.add({ 'https://github.com/miversen33/sunglasses.nvim' })

require('sunglasses').setup({
  filter_percent = 0.1,
  excluded_filetypes = disable_filetypes,
  excluded_highlights = { "StatusLine", "WinSeparator" },
})

-- disable ALL sunglasses shading when entering certain filetypes
vim.api.nvim_create_autocmd({ "WinEnter", "FileType" }, {
  callback = function()
    if vim.tbl_contains(disable_filetypes, vim.bo.filetype) then
      vim.cmd("SunglassesDisable")
    end
  end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.tbl_contains(disable_filetypes, vim.bo.filetype) then
      vim.cmd("SunglassesEnable")
    end
  end,
})
