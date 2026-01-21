return {
  "echasnovski/mini.nvim",
  config = function()
    -- require('mini.jump').setup{}

    require("mini.align").setup({
      mappings = {
        start_with_preview = "ga",
      },
    })

    require("mini.splitjoin").setup({})

    -- local make_pick = function(key, fn, desc)
    --   vim.keymap.set('n', key, fn, {desc = desc})
    -- end
    -- local pick = require('mini.pick')
    -- pick.setup()
    -- make_pick('<leader>p', pick.builtin.files, "Pick files")

    local win_config = function()
      local pad = vim.o.cmdheight + 1
      return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
    end
    require("mini.notify").setup({
      lsp_progress = { enable = false },
      window = {
        config = win_config,
      },
    })

    require("mini.pairs").setup({
      mappings = {
        ['"'] = false,
        ["'"] = false,
        ["`"] = false,
        -- ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^[({%a\\].", register = { cr = false } },
        -- ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^[({%a\\].", register = { cr = false } },
        -- ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^[({%a\\].", register = { cr = false } },
      },
    })

    -- require("mini.surround").setup({
    --  respect_selection_type = true,
    --  mappings = {
    --    add = "sa", -- Add surrounding in Normal and Visual modes
    --    delete = "sd", -- Delete surrounding
    --    replace = "sc", -- Replace surrounding
    --    suffix_last = "l", -- Suffix to search with "prev" method
    --    suffix_next = "n", -- Suffix to search with "next" method
    --  },
    --  custom_surroundings = {
    --    b = {
    --      output = { left = "{[", right = "]}" },
    --    },
    --  },
    -- })
    -- vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

    -- require('mini.cursorword').setup{ delay = 250 }

    -- local notify = require('mini.notify')
    -- notify.setup{}
    -- vim.notify = notify.make_notify()
  end,
}
