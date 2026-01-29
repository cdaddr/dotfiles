local M = {}

function M.int_to_hex(int)
  if not int then
    return nil
  end
  return string.format("#%06x", int)
end
-- Accepts "#RGB", "RGB", "#RRGGBB", "RRGGBB", "#RGBA", "RRGGBBAA"
-- Returns integer r,g,b (0-255) and optional a (0-255) if present
local function hex_to_rgb(hex)
  hex = (hex or ""):gsub("^#", "")
  if #hex == 3 or #hex == 4 then
    hex = hex:gsub(".", function(c)
      return c .. c
    end)
  end
  if #hex ~= 6 and #hex ~= 8 then
    error("invalid hex: " .. tostring(hex))
  end
  local r = tonumber("0x" .. hex:sub(1, 2))
  local g = tonumber("0x" .. hex:sub(3, 4))
  local b = tonumber("0x" .. hex:sub(5, 6))
  if #hex == 8 then
    local a = tonumber("0x" .. hex:sub(7, 8))
    return r, g, b, a
  end
  return r, g, b
end

-- Convert integer color to RGB components
function M.int_to_rgb(int)
  return bit.rshift(int, 16), bit.band(bit.rshift(int, 8), 0xFF), bit.band(int, 0xFF)
end

-- Convert RGB components to integer color
function M.rgb_to_int(r, g, b)
  return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
end

-- Returns hex string "#RRGGBB"
local function desaturate_rgb(r, g, b, factor)
  factor = factor or 1
  local rf, gf, bf = r / 255, g / 255, b / 255

  local maxc = math.max(rf, gf, bf)
  local minc = math.min(rf, gf, bf)
  local l = (maxc + minc) / 2
  local h, s = 0, 0
  local d = maxc - minc

  if d ~= 0 then
    if maxc == rf then
      h = ((gf - bf) / d) % 6
    elseif maxc == gf then
      h = ((bf - rf) / d) + 2
    else
      h = ((rf - gf) / d) + 4
    end
    h = h * 60
    s = d / (1 - math.abs(2 * l - 1))
  end

  s = clamp(s * factor, 0, 1)

  local c = (1 - math.abs(2 * l - 1)) * s
  local hh = h / 60
  local x = c * (1 - math.abs((hh % 2) - 1))
  local rp, gp, bp = 0, 0, 0
  if 0 <= hh and hh < 1 then
    rp, gp, bp = c, x, 0
  elseif 1 <= hh and hh < 2 then
    rp, gp, bp = x, c, 0
  elseif 2 <= hh and hh < 3 then
    rp, gp, bp = 0, c, x
  elseif 3 <= hh and hh < 4 then
    rp, gp, bp = 0, x, c
  elseif 4 <= hh and hh < 5 then
    rp, gp, bp = x, 0, c
  else
    rp, gp, bp = c, 0, x
  end
  local m = l - c / 2

  local rf2 = clamp(math.floor((rp + m) * 255 + 0.5), 0, 255)
  local gf2 = clamp(math.floor((gp + m) * 255 + 0.5), 0, 255)
  local bf2 = clamp(math.floor((bp + m) * 255 + 0.5), 0, 255)

  return string.format("#%02X%02X%02X", rf2, gf2, bf2)
end

-- Blend two integer colors together
-- amount: 0 = all fg, 1 = all bg
function M.blend(fg, bg, amount)
  if not fg or not bg then
    return fg or bg
  end
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
  return vim.tbl_extend("force", hl, {
    fg = M.int_to_hex(hl.fg),
    bg = M.int_to_hex(hl.bg),
    sp = M.int_to_hex(hl.sp),
  })
end

function M.deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
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
    if src[k] ~= nil then
      out[k] = src[k]
    end
  end
  return out
end

return M
