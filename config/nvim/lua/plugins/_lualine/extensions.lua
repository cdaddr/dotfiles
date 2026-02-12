local M = {}

M.quickfix = {
  filetypes = { "qf" },
  sections = {
    lualine_a = { function() return "QUICKFIX" end },
    lualine_b = {},
    lualine_c = { "w:quickfix_title" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_c = { "w:quickfix_title" },
  },
}

local oil_dir = function()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  end
  return ""
end

M.oil = {
  filetypes = { "oil" },
  sections = {
    lualine_a = { function() return "OIL" end },
    lualine_b = { oil_dir },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_b = { oil_dir },
  },
}

local diffview_title = function()
  return vim.bo.filetype:gsub("^Diffview", "")
end

M.diffview = {
  filetypes = {
    "DiffviewFiles",
    "DiffviewFileHistory",
    "DiffviewFileHistoryPanel",
    "DiffviewCommitLog",
    "DiffviewOptions",
    "DiffviewHelp",
  },
  sections = {
    lualine_a = { function() return "DIFFVIEW" end },
    lualine_b = {},
    lualine_c = { diffview_title },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_c = { diffview_title },
  },
}

M.nvim_tree = {
  filetypes = { "NvimTree" },
  sections = {
    lualine_a = { function() return "NVIM-TREE" end },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {},
}

M.toggleterm = {
  filetypes = { "toggleterm" },
  sections = {
    lualine_a = { function() return "TERMINAL" end },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {},
}

return M
