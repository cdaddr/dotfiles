local M = {}

function M.component(palette)
  return {
    function()
      return "······"
    end,
    color = palette.inactive_badge,
  }
end

return M
