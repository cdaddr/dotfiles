local helpers = require("plugins._lualine.helpers")
local util = require("util")

local mode = require("plugins._lualine.mode")
local file_icon = require("plugins._lualine.file_icon")
local grapple = require("plugins._lualine.grapple")
local filename = require("plugins._lualine.filename")
local modified = require("plugins._lualine.modified")
local git_status = require("plugins._lualine.git_status")
local lsp_status = require("plugins._lualine.lsp_status")
local format_indicator = require("plugins._lualine.format_indicator")
local unicode = require("plugins._lualine.unicode")
local cwd = require("plugins._lualine.cwd")
local filetype = require("plugins._lualine.filetype")
local position = require("plugins._lualine.position")
local inactive_badge = require("plugins._lualine.inactive_badge")

local M = {}

local INACTIVE_BLEND = 0.8

local function mute(color)
  local comment_fg = util.copy_hl("Comment").fg
  local input_fg = color.fg or comment_fg
  local result = {
    bg = util.copy_hl("StatusLineNC").bg,
    fg = util.blend_colors(input_fg, comment_fg, INACTIVE_BLEND),
  }
  for k, v in pairs(color) do
    if k ~= "fg" and k ~= "bg" then
      result[k] = v
    end
  end
  return result
end

local function build_palette()
  local mid_keyword = helpers.apply_hl("DiffChange", "Keyword", { "bg" })
  local mid_warning = helpers.apply_hl("DiffChange", "WarningMsg", { "bg" })
  local mid_diff = helpers.apply_hl("DiffChange", "diffNewFile", { "bg" })
  local mid_default = helpers.apply_hl("DiffChange", nil, { "bg" })
  local dark_comment = helpers.apply_hl("SignColumn", "Comment", { "bg" })
  local outer = helpers.apply_hl("StatusLineNC", "Normal", { "bg" })

  local statusline = util.copy_hl("StatusLineNC")

  return {
    mid_keyword = mid_keyword,
    mid_warning = mid_warning,
    mid_diff = mid_diff,
    mid_default = mid_default,
    dark_comment = dark_comment,
    outer = outer,

    inactive_badge = { fg = statusline.bg, bg = statusline.fg },
    inactive_outer = mute(outer),
    inactive_mid = mute(mid_default),
    inactive_dark = mute(dark_comment),
  }
end

function M.sections()
  local p = build_palette()

  local active = {
    lualine_a = {
      mode.component(),
    },
    lualine_b = {
      file_icon.component(p, true),
      filename.component(p, true),
      modified.component(p, true),
      git_status.buffer_diff(p, true),
    },
    lualine_c = {
      grapple.component(p, true),
      git_status.branch(p, true),
      git_status.repo_status(p, true),
    },
    lualine_x = {
      unicode.component(p, true),
      lsp_status.component(p, true),
      format_indicator.component(p, true),
    },
    lualine_y = {
      cwd.component(p, true),
      filetype.component(p, true),
    },
    lualine_z = {
      position.component(p, true),
    },
  }

  local inactive = {
    lualine_a = {
      inactive_badge.component(p),
      filename.component(p, false),
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      lsp_status.component(p, false),
      format_indicator.component(p, false),
    },
    lualine_y = {
      filetype.component(p, false),
    },
    lualine_z = {
      position.component(p, false),
    },
  }

  return active, inactive
end

return M
