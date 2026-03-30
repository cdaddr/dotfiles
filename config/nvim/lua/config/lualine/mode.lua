local helpers = require("config.lualine.helpers")

local M = {}

function M.component(color)
  local component = {
    "mode",
    cond = helpers.is_normal,
  }
  if color then
    component.color = color
  end
  return component
end

return M
