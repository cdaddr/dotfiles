return {
	'echasnovski/mini.nvim',
  config = function()
    -- require('mini.jump').setup{}

    require('mini.align').setup{
      mappings = {
        start_with_preview = 'ga',
      },
    }

    require('mini.splitjoin').setup{}

    -- require('mini.pairs').setup{}

    require('mini.surround').setup{
      mappings = {
        add = 'mS', -- Add surrounding in Normal and Visual modes
        delete = 'mD', -- Delete surrounding
        find = 'mL', -- Find surrounding (to the right)
        find_left = 'mH', -- Find surrounding (to the left)
        highlight = 'mM', -- Highlight surrounding
        replace = 'mR', -- Replace surrounding
        update_n_lines = 'mN', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
      custom_surroundings = {
        b = {
          output = { left = '{[', right = ']}' },
        },
      },
    }
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

    -- require('mini.cursorword').setup{ delay = 250 }

    -- local notify = require('mini.notify')
    -- notify.setup{}
    -- vim.notify = notify.make_notify()
  end,
}
