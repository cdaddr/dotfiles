local util = require 'util'
return {
  'nvimdev/indentmini.nvim',
  config = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local cursorline = util.copy_hl('LineNr')
        vim.cmd.highlight('IndentLine guifg=' .. cursorline.fg )
        vim.cmd.highlight('link IndentLineCurrent CursorLineSign')
      end
    })

    require'indentmini'.setup{
      minlevel = 1,
      char = "▏"
    }
  end
  -- "lukas-reineke/indent-blankline.nvim",
  -- main = "ibl",
  -- config = function()
  --   require'ibl'.setup{
  --     scope = {
  --       enabled = false
  --     },
  --     indent = {
  --       char = '▏'
  --     }
  --   }
  -- end
}

--• left aligned solid
--  • `▏`
--  • `▎` (default)
--  • `▍`
--  • `▌`
--  • `▋`
--  • `▊`
--  • `▉`
--  • `█`
