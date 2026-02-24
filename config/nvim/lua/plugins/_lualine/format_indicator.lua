local helpers = require("plugins._lualine.helpers")

local M = {}

function M.component(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
    function()
      if vim.b.disable_format_on_save then
        return ""
      else
        return "󰁨  "
      end
    end,
    padding = 0,
    color = color,
    cond = helpers.is_normal,
  }
end

return M
