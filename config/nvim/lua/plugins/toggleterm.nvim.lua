return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.25
      end
    end,
    direction = 'horizontal',
    on_open = function(_)
      vim.cmd("startinsert!")
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Automatically enter insert mode when focusing a terminal buffer
    vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
      pattern = "term://*",
      callback = function()
        vim.schedule(function()
          vim.cmd('startinsert')
        end)
      end,
    })

    local Terminal = require('toggleterm.terminal').Terminal

    local term = Terminal:new({
      cmd = "zsh",
      direction = "horizontal",
      close_on_exit = true,
      display_name = "[zsh]"
    })

    -- Claude terminal
    local claude = Terminal:new({
      cmd = "claude",
      direction = "horizontal",
      close_on_exit = true,
      display_name = "[claude]"
    })

    -- psql terminal
    local psql = Terminal:new({
      cmd = "psql",
      direction = "horizontal",
      close_on_exit = true,
      display_name = "[psql]"
    })

    -- lazygit terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      direction = "horizontal",
      close_on_exit = true,
      display_name = "[lazygit]"
    })

    vim.keymap.set('n', '<leader>tt', function() term:toggle() end, { desc = 'Toggle terminal' })
    vim.keymap.set('n', '<leader>tc', function() claude:toggle() end, { desc = 'Toggle Claude terminal' })
    vim.keymap.set('n', '<leader>tp', function() psql:toggle() end, { desc = 'Toggle psql' })
    vim.keymap.set('n', '<leader>tg', function() lazygit:toggle() end, { desc = 'Toggle lazygit' })

    -- Allow <C-w> window commands to work in terminal mode
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { desc = 'Window commands in terminal mode' })
  end
}
