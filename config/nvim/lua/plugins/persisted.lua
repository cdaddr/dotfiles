-- reopens files last opened, saved per directory (project)
return {
  "olimorris/persisted.nvim",
  config = function()
    vim.opt.sessionoptions = {
      "buffers",
      "curdir",
      "folds",
      "tabpages",
      "winpos",
      "winsize",
    }
    -- Mark special buffers as nofile so they're excluded from session
    -- https://github.com/neovim/neovim/issues/12242
    local saved_buftypes = {}
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistedSavePre",
      callback = function()
        saved_buftypes = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype ~= "" and vim.bo[buf].buftype ~= "nofile" then
            saved_buftypes[buf] = vim.bo[buf].buftype
            vim.bo[buf].buflisted = false
            vim.bo[buf].buftype = "nofile"
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistedSavePost",
      callback = function()
        for buf, buftype in pairs(saved_buftypes) do
          if vim.api.nvim_buf_is_valid(buf) then
            vim.bo[buf].buftype = buftype
          end
        end
        saved_buftypes = {}
      end,
    })
    require("persisted").setup({
      autoload = true, -- automatically load session for the cwd
      autosave = true, -- automatically save session on exit
    })
  end,
}
