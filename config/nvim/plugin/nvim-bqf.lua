-- see colorscheme.lua for highlights
vim.pack.add({ 'https://github.com/kevinhwang91/nvim-bqf' })

-- taken from bqf docs - better qf formatting
local fn = vim.fn
function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local maxLen = 64

  -- returns name string and its display width (separate because … is 3 bytes but 1 column)
  local function displayName(bufnr)
    if bufnr <= 0 then return "", 0 end
    local path = fn.bufname(bufnr)
    if path == "" then return "[No Name]", 9 end
    local name = fn.fnamemodify(path, ":.")
    if #name > maxLen then
      return "…" .. name:sub(-(maxLen - 1)), maxLen
    end
    return name, #name
  end

  local allNames = {}
  local allWidths = {}
  local maxWidth = 0
  for i, e in ipairs(items) do
    local name, width = "", 0
    if e.valid == 1 then
      name, width = displayName(e.bufnr)
    end
    allNames[i] = name
    allWidths[i] = width
    if width > maxWidth then maxWidth = width end
  end

  local numFmt = "%5d:%-3d"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local str
    if e.valid == 1 then
      local fname = allNames[i] .. string.rep(" ", maxWidth - allWidths[i])
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = fname .. " │" .. numFmt:format(lnum, col) .. "│" .. qtype .. " " .. e.text
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
