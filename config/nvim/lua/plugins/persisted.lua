-- reopens files last opened, saved per directory (project)
return {
  'olimorris/persisted.nvim',
  config = function()
    vim.opt.sessionoptions = {
      "buffers",
      "curdir",
      "folds",
      "tabpages",
      "winpos",
      "winsize",
    }
    -- close everything I don't want to save to the session
    -- vim.api.nvim_create_autocmd("ExitPre", {
    --   callback = function()
    --     local buftypes_to_close = { "help", "quickfix", "nofile", "terminal", "prompt" }
    --     local filetypes_to_close = { "", "neo-tree", "oil", "toggleterm", "notify" }
    --
    --     for _, win in ipairs(vim.api.nvim_list_wins()) do
    --       local buf = vim.api.nvim_win_get_buf(win)
    --       local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
    --       local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    --
    --       if vim.tbl_contains(buftypes_to_close, buftype) or
    --         vim.tbl_contains(filetypes_to_close, filetype) then
    --         local success, err = pcall(vim.api.nvim_win_close, win, false)
    --         if not success then
    --           vim.notify(err)
    --         end
    --       end
    --     end
    --   end,
    -- })
    require('persisted').setup({
      autoload = true,  -- automatically load session for the cwd
      autosave = true,  -- automatically save session on exit
    })
  end
}
