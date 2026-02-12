local helpers = require("plugins._lualine.helpers")

local M = {}

function M.component(palette, active)
  local color = active and palette.mid_diff or palette.inactive_mid

  return {
    function()
      if vim.bo.modified then
        return "●"
      end
      return ""
    end,
    color = color,
    padding = { left = 0, right = 1 },
    cond = helpers.is_normal,
  }
end

return M
