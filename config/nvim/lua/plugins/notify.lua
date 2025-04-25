return {
  'rcarriga/nvim-notify',
  config = function(_, opts)
    local notify = require('notify')
    notify.setup()
    vim.notify = notify
  end
}
