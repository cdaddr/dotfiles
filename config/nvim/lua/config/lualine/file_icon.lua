local helpers = require("config.lualine.helpers")

local M = {}

function M.component(palette, active)
  local normal = active and palette.mid_keyword or palette.inactive_mid
  local readonly = active and palette.mid_warning or palette.inactive_mid

  return {
    function()
      if helpers.is_special() then
        return
      end
      if helpers.is_readonly() then
        return "\u{ea75}"
      end
      return "\u{eb60}"
    end,
    color = function()
      if helpers.is_readonly() then
        return readonly
      end
      return normal
    end,
    padding = { left = 1, right = 0 },
    cond = helpers.is_normal,
  }
end

return M
