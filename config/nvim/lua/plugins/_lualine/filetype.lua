local util = require("util")

local M = {}

function M.component(palette, active)
  if active then
    return {
      "filetype",
      colored = false,
      color = function()
        local normal_bg = util.copy_hl("lualine_a_normal").bg
        return { fg = normal_bg, bg = palette.mid_default.bg }
      end,
    }
  end
  return {
    "filetype",
    colored = false,
    color = palette.inactive_mid,
  }
end

return M
