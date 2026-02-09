local helpers = require("config.lualine.helpers")

local M = {}

function M.component(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
    function()
      local txt = require("grapple").name_or_index()
      if txt then
        return string.format("󰛢:%s", txt)
      end
    end,
    cond = function()
      return helpers.is_normal() and require("grapple").exists()
    end,

    color = color,
  }
end

return M
