-- Filetypes where sunglasses should be completely disabled (not just excluded)
local disable_filetypes = {
  "help",
  "qf",
  "oil",
  "man",
  "Trouble",
}

return {
  "miversen33/sunglasses.nvim",
  opts = {
    filter_percent = 0.3,
    -- excluded_filetypes = {
    --   "help",
    --   "qf",
    --   "oil",
    --   "man",
    --   "Trouble",
    -- },
    excluded_highlights = {
      "StatusLine",
      "WinSeparator",
    },
  },
  -- this disables ALL sunglasses shadinw when entering one of these filetypes
  -- e.g. I want to see ALL buffers when looking at a help file
  init = function()
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
  end,
}
