return {
  -- config = function(_, opts)
  --   local notify = require('notify')
  --   notify.setup(
  --     vim.tbl_extend('force', opts,
  --     {
  --       render = "compact",
  --     }))
  --   vim.notify = notify
  -- end
  'j-hui/fidget.nvim',
  opts = {
    notification = {
      override_vim_notify = true,
      window = {
        y_padding = 2,
        x_padding = 1,
        border = "rounded",
        border_hl = 'WarningMsg',
        -- normal_hl = 'Comment',
        windblend = 50,
      },
    },
  },
  -- config = function (_, opts)
  --   local fidget = require'fidget'
  --   vim.notify = fidget.notify
  -- end
}
