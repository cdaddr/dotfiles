return {
  'https://codeberg.org/andyg/leap.nvim',
  config = function (_, opts)
    -- vim.keymap.set({'n', 'x', 'o'}, 'f',  '<Plug>(leap)')
    -- vim.keymap.set({'n'}, 'F',  '<Plug>(leap-backward)')
      --preview = function (ch0, ch1, ch2)
        -- return not(
        --   ch1:match('%s')
        --   or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
        -- )
      --end
    opts.safe_labels = 'sut/SFNLHMUGTZ?'
    opts.labels = 'sjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?'
    opts.keys = {
      next_target = '<cr>',
      prev_target = '<backspace>',
      next_group = '<space>',
      prev_group = '<bs>',
    }
    return opts
  end,
}
