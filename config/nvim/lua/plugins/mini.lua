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

    -- local make_pick = function(key, fn, desc)
    --   vim.keymap.set('n', key, fn, {desc = desc})
    -- end
    -- local pick = require('mini.pick')
    -- pick.setup()
    -- make_pick('<leader>p', pick.builtin.files, "Pick files")

    local win_config = function() 
      local pad = vim.o.cmdheight + 1
      return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
    end
    require('mini.notify').setup{
      lsp_progress = { enable = false },
      window = {
        config = win_config
      }
    }

    -- require('mini.pairs').setup{}

    require('mini.surround').setup{
      mappings = {
        add = 'ys', -- Add surrounding in Normal and Visual modes
        delete = 'yd', -- Delete surrounding
        find = 'yl', -- Find surrounding (to the right)
        find_left = 'yh', -- Find surrounding (to the left)
        highlight = 'ym', -- Highlight surrounding
        replace = 'yc', -- Replace surrounding
        update_n_lines = 'yn', -- Update `n_lines`

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
