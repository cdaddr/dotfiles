return {
  "nvim-lualine/lualine.nvim",
  opts = {
    theme = 'catppuccin-macchiato',
    icons_enabled = false,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    sections = {
      lualine_x = {'grapple', 'encoding', 'fileformat', 'filetype'},
    }
  }
}
