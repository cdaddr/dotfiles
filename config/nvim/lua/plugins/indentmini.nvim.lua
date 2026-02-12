local util = require("util")
return {
  "nvimdev/indentmini.nvim",
  config = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local linenr_hl = vim.api.nvim_get_hl(0, { name = "LineNr" })
        local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
        local bg = normal_hl.bg or 0x16161D
        if linenr_hl.fg then
          vim.api.nvim_set_hl(0, "IndentLine", { fg = util.blend(linenr_hl.fg, bg, 0.5) })
          vim.api.nvim_set_hl(0, "IndentLineCurrent", { fg = linenr_hl.fg })
        end
      end,
    })

    require("indentmini").setup({
      minlevel = 2,
      char = "┊",
    })
  end,
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
