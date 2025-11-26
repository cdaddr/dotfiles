return {
	'echasnovski/mini.nvim',
  config = function()
    require('mini.jump').setup{}

    require('mini.align').setup{
      mappings = {
        start_with_preview = 'ga',
      },
    }

    require('mini.splitjoin').setup{}

    -- require('mini.pairs').setup{}

    require('mini.surround').setup{
      mappings = {
        add = 'S', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
      custom_surroundings = {
        b = {
          output = { left = '{[', right = ']}' },
        },
      },
    }

    -- require('mini.cursorword').setup{ delay = 250 }

    -- local notify = require('mini.notify')
    -- notify.setup{}
    -- vim.notify = notify.make_notify()
  end,
}
