local M = {}

function M.int_to_hex(int)
  if not int then return nil end
  return string.format("#%06x", int)
end

-- Convert integer color to RGB components
function M.int_to_rgb(int)
  return bit.rshift(int, 16), bit.band(bit.rshift(int, 8), 0xFF), bit.band(int, 0xFF)
end

-- Convert RGB components to integer color
function M.rgb_to_int(r, g, b)
  return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
end

-- Blend two integer colors together
-- amount: 0 = all fg, 1 = all bg
function M.blend(fg, bg, amount)
  if not fg or not bg then return fg or bg end
  local fr, fg_g, fb = M.int_to_rgb(fg)
  local br, bg_g, bb = M.int_to_rgb(bg)
  local r = math.floor(fr * (1 - amount) + br * amount)
  local g = math.floor(fg_g * (1 - amount) + bg_g * amount)
  local b = math.floor(fb * (1 - amount) + bb * amount)
  return M.rgb_to_int(r, g, b)
end

-- Blend and return as hex string (for vim.cmd highlight commands)
function M.blend_hex(fg, bg, amount)
  local blended = M.blend(fg, bg, amount)
  return blended and string.format("%06x", blended) or nil
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
