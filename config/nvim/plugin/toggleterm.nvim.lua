vim.pack.add({ { src = 'https://github.com/akinsho/toggleterm.nvim', version = vim.version.range('*') } })

require('toggleterm').setup({
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.25
    end
  end,
  direction = "horizontal",
  on_open = function(_)
    vim.cmd("startinsert!")
  end,
})

local Terminal = require("toggleterm.terminal").Terminal

local term = Terminal:new({
  cmd = "zsh",
  direction = "horizontal",
  close_on_exit = true,
  display_name = "[zsh]",
})

local claude = Terminal:new({
  cmd = "claude",
  direction = "horizontal",
  close_on_exit = true,
  display_name = "[claude]",
})

local psql = Terminal:new({
  cmd = "psql",
  direction = "horizontal",
  close_on_exit = true,
  display_name = "[psql]",
})

vim.keymap.set("n", "<leader>tt", function() term:toggle() end, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tc", function() claude:toggle() end, { desc = "Toggle Claude terminal" })
vim.keymap.set("n", "<leader>tp", function() psql:toggle() end, { desc = "Toggle psql" })

-- allow <C-w> window commands in terminal mode
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Window commands in terminal mode" })
