local helpers = require("config.lualine.helpers")

local M = {}

function M.component(palette, active)
  local base_color = active and palette.mid_keyword or palette.inactive_outer

  return {
    function()
      local name, _ = helpers.get_display_filename()
      return name
    end,
    color = function()
      local hl = vim.deepcopy(base_color)
      local _, is_italic = helpers.get_display_filename()
      if is_italic or helpers.is_new_file() then
        hl.italic = true
      end
      return hl
    end,
  }
end

return M
