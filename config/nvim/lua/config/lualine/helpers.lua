local util = require("util")

local M = {}

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

-- cached per-cwd jj repo detection
local jj_cache = {}
function M.is_jj_repo()
  local cwd = vim.fn.getcwd()
  if jj_cache[cwd] == nil then
    jj_cache[cwd] = vim.fn.finddir(".jj", cwd .. ";") ~= ""
  end
  return jj_cache[cwd]
end

-- invalidate cache on dir change
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    jj_cache = {}
  end,
})

return M
