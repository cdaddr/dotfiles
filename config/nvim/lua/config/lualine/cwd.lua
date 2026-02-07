local helpers = require("config.lualine.helpers")

local M = {}

function M.component(palette, active)
  local color = active and palette.mid_keyword or palette.inactive_mid

  return {
    function()
      local cwd = vim.fn.getcwd()
      local short_cwd = helpers.short_filename(cwd)
      return "cwd: " .. short_cwd
    end,
    icon = "\u{eaf7}",
    color = color,
    on_click = function()
      vim.cmd("Oil")
    end,
    cond = helpers.is_normal,
  }
end

return M
