local helpers = require("config.lualine.helpers")

local M = {}

function M.component(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
    "lsp_status",
    icon = "\u{eba2}",
    symbols = {
      done = "",
      separator = "|",
    },
    fmt = function(txt)
      if txt then
        return "⨉" .. tostring(#vim.split(txt, "|"))
      end
      return txt
    end,
    color = color,
    on_click = function()
      vim.cmd("checkhealth lsp")
    end,
    cond = helpers.is_normal,
  }
end

return M
