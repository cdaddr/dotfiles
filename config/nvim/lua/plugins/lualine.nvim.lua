local util = require("util")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local status, theme = pcall(require, "lualine.themes." .. _G.theme.lualine)
    if not status then
      theme = require("lualine.themes.catppuccin")
    end

    theme.normal.c.bg = util.copy_hl("LineNr").bg
    theme.inactive.c.bg = util.copy_hl("LineNr").bg
    theme.inactive.c.fg = util.copy_hl("WinSeparator").fg

    local sections_mod = require("plugins._lualine.sections")
    local active, inactive = sections_mod.sections()

    local ext = require("plugins._lualine.extensions")

    require("lualine").setup({
      extensions = {
        "mason",
        "lazy",
        ext.quickfix,
        ext.oil,
        ext.diffview,
        ext.nvim_tree,
        ext.toggleterm,
      },
      options = {
        theme = theme,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = {
          "grapple",
        },
      },
      sections = active,
      inactive_sections = inactive,
    })
  end,
}
