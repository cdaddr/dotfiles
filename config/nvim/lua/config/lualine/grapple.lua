local helpers = require("config.lualine.helpers")

local M = {}

function M.component(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
    function()
      -- grapple loads via later(); guard in case lualine draws before it's ready
      local ok, grapple = pcall(require, "grapple")
      local txt = ok and grapple.name_or_index()
      if txt then
        return string.format("󰛢:%s", txt)
      end
    end,
    cond = function()
      local ok, grapple = pcall(require, "grapple")
      return ok and helpers.is_normal() and grapple.exists()
    end,

    color = color,
  }
end

return M
