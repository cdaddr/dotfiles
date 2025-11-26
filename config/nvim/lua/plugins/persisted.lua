return {
  'olimorris/persisted.nvim',
  config = function()
    require('persisted').setup({
      autoload = true,  -- automatically load session for the cwd
      autosave = true,  -- automatically save session on exit
      should_autosave = function()
        -- Don't autosave if there's only one empty buffer
        if vim.fn.argc() == 0 and vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
          return false
        end
        return true
      end,
    })
  end
}
