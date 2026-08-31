-- eager (now): statusline is part of the first frame. setup() runs via
-- util.on_colorscheme so it (re)builds after the colorscheme is applied and on
-- every colorscheme change, keeping the statusline in sync with the active theme.
now(function()
  local util = require("util")

  vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

  local nvim_theme = dofile(vim.fn.stdpath("config") .. "/theme.lua")
  local sections_mod = require("config.lualine.sections")
  local ext = require("config.lualine.extensions")

  local function resolve_theme()
    -- prefer the lualine palette matching the active colorscheme (so runtime theme
    -- switches are honored), then the generated theme name, then auto.
    for _, name in ipairs({ vim.g.colors_name, nvim_theme.lualine }) do
      if name then
        local ok, theme = pcall(require, "lualine.themes." .. name)
        if ok then
          return theme
        end
      end
    end
    -- no theme-provided palette: fall back to auto and blend the middle (c)
    -- section into the gutter/window border so it isn't a flat default.
    local theme = require("lualine.themes.auto")
    theme.normal.c.bg = util.copy_hl("LineNr").bg
    theme.inactive.c.bg = util.copy_hl("LineNr").bg
    theme.inactive.c.fg = util.copy_hl("WinSeparator").fg
    return theme
  end

  local function setup()
    -- build sections here, not at load time: the section palette derives its
    -- colors from theme highlight groups (DiffChange/Keyword/StatusLineNC/…), so
    -- it must run after the colorscheme is applied — otherwise it captures the
    -- default (dark) palette and bakes it into every theme (a dark near-black
    -- middle section regardless of the theme selected).
    local active, inactive = sections_mod.sections()
    require("lualine").setup({
      extensions = {
        ext.quickfix,
        ext.oil,
        ext.diffview,
        ext.nvim_tree,
        ext.toggleterm,
      },
      options = {
        theme = resolve_theme(),
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = { "grapple" },
      },
      sections = active,
      inactive_sections = inactive,
    })
  end

  util.on_colorscheme(setup)
end)
