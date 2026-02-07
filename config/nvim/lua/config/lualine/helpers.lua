local util = require("util")

local M = {}

M.MAX_FILENAME = 20

-- copies specified attrs from source hl group onto base hl group
-- source_hl: hl group name to copy attrs from (or nil)
-- base_hl: hl group name to use as base (or nil for empty)
-- attrs: list of attribute names, e.g. {"bg"} or {"fg", "bold"}
function M.apply_hl(source_hl, base_hl, attrs)
  local source = source_hl and util.copy_hl(source_hl) or {}
  local result = base_hl and util.copy_hl(base_hl) or {}
  for _, attr in ipairs(attrs) do
    result[attr] = source[attr]
  end
  return result
end

function M.is_special(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local fn = vim.api.nvim_buf_get_name(bufnr)
  return fn:match("^plugin://") ~= nil
end

function M.is_normal(bufnr)
  return not M.is_special(bufnr)
end

function M.is_unnamed(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local fn = vim.api.nvim_buf_get_name(bufnr)
  return fn == ""
end

function M.is_new_file(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return false
  end
  if filename:match("^%a+://") then
    return false
  end
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end
  return vim.fn.filereadable(filename) == 0
end

function M.is_readonly(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly
end

-- collapses middle path segments: ~/foo/bar/baz/qux.lua -> ~/foo/…x2/qux.lua
function M.short_filename(path)
  if not path or path == "" then
    return ""
  end

  local home = vim.fn.expand("$HOME")
  if path:sub(1, #home) == home then
    path = "~" .. path:sub(#home + 1)
  end

  if #path <= M.MAX_FILENAME then
    return path
  end

  local segments = {}
  for seg in path:gmatch("[^/]+") do
    table.insert(segments, seg)
  end

  if #segments <= 2 then
    return path
  end

  local first_idx = 1
  local prefix = ""

  if path:sub(1, 1) == "~" then
    prefix = "~/"
    first_idx = 2
  elseif path:sub(1, 1) == "/" then
    prefix = "/"
  end

  local hidden_count = #segments - first_idx - 1
  if hidden_count > 0 then
    local first_seg = segments[first_idx]
    local last_seg = segments[#segments]
    return prefix .. first_seg .. "/\u{2026}x" .. hidden_count .. "/" .. last_seg
  end

  return path
end

-- returns: display_name, is_italic
function M.get_display_filename(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if bufname == "" then
    return "NEW FILE", true
  end

  local plugin_match = bufname:match("^plugin://([^/]+)")
  if plugin_match then
    local basename = vim.fn.fnamemodify(bufname, ":t")
    return plugin_match .. ":" .. basename, true
  end

  local protocol = bufname:match("^([%w]+)://")
  if protocol then
    local basename = vim.fn.fnamemodify(bufname, ":t")
    return protocol .. ":" .. basename, true
  end

  local cwd = vim.fn.getcwd()
  local buf_dir = vim.fn.fnamemodify(bufname, ":p:h")
  local basename = vim.fn.fnamemodify(bufname, ":t")

  if buf_dir == cwd then
    return basename, false
  end

  if buf_dir:sub(1, #cwd) == cwd and buf_dir:sub(#cwd + 1, #cwd + 1) == "/" then
    local rel_path = buf_dir:sub(#cwd + 1)
    return "." .. rel_path .. "/" .. basename, false
  end

  local full_path = vim.fn.fnamemodify(bufname, ":~")
  return M.short_filename(full_path), false
end

return M
