local M = {}

function M.component(palette, active)
  local component = {
    "%-2P 󰕱 %-3l 󰕭 %-2c",
    fmt = function(item)
      return " " .. item
    end,
  }
  if not active then
    component.color = palette.inactive_badge
  end
  return component
end

return M
