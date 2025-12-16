local M = {}

function M.int_to_hex(int)
  if not int then return nil end
  return string.format("#%06x", int)
end

function M.copy_hl(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  return vim.tbl_extend('force', hl, {
    fg = M.int_to_hex(hl.fg),
    bg = M.int_to_hex(hl.bg),
    sp = M.int_to_hex(hl.sp),
  })
end

function M.deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
    end
    setmetatable(copy, M.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function M.pick(src, keys)
  local out = {}
  for _, k in ipairs(keys) do
    if src[k] ~= nil then out[k] = src[k] end
  end
  return out
end

return M
