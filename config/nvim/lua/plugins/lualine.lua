return {
  "nvim-lualine/lualine.nvim",
  opts = {
    theme = 'catppuccin-macchiato',
    icons_enabled = false,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    sections = {
      lualine_c = {
        {'filename', path = 1, separator = '' },
        {
          '%f',
          path = 3,
          separator = '',
          fmt = function(item) return '(' .. vim.fn.fnamemodify( item, ':p:h') .. ')' end,
          color = "lualine_c_inactive",
        },
      },
      lualine_x = {'grapple', 'encoding', 'fileformat', 'filetype'},
    }
  }
}
