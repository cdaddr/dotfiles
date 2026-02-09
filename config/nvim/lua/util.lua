local M = {}

M.MAX_FILENAME = 20

local function clamp(val, min, max)
  return math.max(min, math.min(max, val))
end

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

-- desaturates rgb color by factor (0 = full gray, 1 = original)
-- returns hex string "#RRGGBB"
function M.desaturate_rgb(r, g, b, factor)
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

-- desaturates hex color by factor (0 = full gray, 1 = original)
-- hex_color: "#RRGGBB" or "RRGGBB"
function M.desaturate(hex_color, factor)
  if not hex_color then
    return nil
  end
  local r, g, b = hex_to_rgb(hex_color)
  return M.desaturate_rgb(r, g, b, factor)
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

-- blend two hex colors: "#RRGGBB" strings
-- amount: 0 = all color1, 1 = all color2
function M.blend_colors(color1, color2, amount)
  if not color1 then
    return color2
  end
  if not color2 then
    return color1
  end
  local r1, g1, b1 = hex_to_rgb(color1)
  local r2, g2, b2 = hex_to_rgb(color2)
  local r = math.floor(r1 * (1 - amount) + r2 * amount)
  local g = math.floor(g1 * (1 - amount) + g2 * amount)
  local b = math.floor(b1 * (1 - amount) + b2 * amount)
  return string.format("#%02X%02X%02X", r, g, b)
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
    local hidden_seg
    if hidden_count == 1 then
      hidden_seg = "…"
    else
      hidden_seg = string.format("…×%d", hidden_count)
    end
    return prefix .. first_seg .. "/" .. hidden_seg .. "/" .. last_seg
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
    return M.short_filename("." .. rel_path) .. "/" .. basename, false
  end

  local full_path = vim.fn.fnamemodify(bufname, ":~")
  return M.short_filename(full_path), false
end

return M
