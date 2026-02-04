vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.number = true
vim.o.numberwidth = 1
vim.o.splitright = true
vim.o.undofile = true
vim.o.showmatch = false
vim.o.cursorline = true
vim.o.cursorlineopt = "both"
vim.o.winheight = 3
vim.o.winminheight = 3
vim.o.scrolloff = 5
vim.o.suffixesadd = ".md"
vim.o.timeout = true
-- vim.o.timeoutlen = 1000
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.title = true
vim.o.titlestring = "%t - Nvim"
vim.o.showmode = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = true
vim.o.listchars = "tab: ,trail:·,nbsp:␣"
vim.opt.nrformats:append({ "alpha" })
vim.opt.clipboard:append({ "unnamedplus" })
vim.o.winborder = "rounded"
-- vim.o.textwidth = 120
-- vim.o.colorcolumn = "+1"
-- vim.opt.laststatus = 0

-- _G.FoldColumn = function()
--   local foldsigns = {
--     open = '-',
--     close = '+',
--     seps = { '┊', '┆', },
--   }
--   local lnum = vim.v.lnum
--   local foldlevel = vim.fn.foldlevel(vim.v.lnum)
--   local prev_foldlevel = lnum > 1 and vim.fn.foldlevel(lnum - 1) or 0
--
--   local foldtext = ' '
--   if foldlevel > 0 then
--     if vim.fn.foldclosed(vim.v.lnum) == lnum then
--       foldtext = foldsigns.open
--     elseif foldlevel > prev_foldlevel then
--       foldtext = foldsigns.close
--     else
--       foldtext = foldsigns.seps[foldlevel] or foldsigns.seps[#foldsigns.seps]
--     end
--   end
--   return foldtext
-- end
-- _G.Signs = function()
--   local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {lnum = vim.v.lnum})[1].signs
--   if #signs > 0 then
--     return vim.fn.sign_getdefined(signs[1].name)[1].text or ' '
--   end
--   return ' '
-- end

vim.opt.signcolumn = "yes"
-- vim.opt.statuscolumn = '%{v:lua.Signs()}%#FoldColumn#%{v:lua.FoldColumn()}%#LineNr#%{v:virtnum < 0 ? "↳" : v:lnum}'
vim.opt.foldtext = ""

-- Folding defaults (treesitter as fallback)
local function formatFold(txt)
  txt = txt:gsub("^%s+", "")
  if #txt > 16 then
    txt = txt:sub(1, 16)
  end
  return txt
end

function _G.FoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_end = formatFold(vim.fn.getline(vim.v.foldend + 1))
  local count = vim.v.foldend - vim.v.foldstart
  --local icon = ""

  return string.format("%s ⋯", (line or "Fold"))
end
vim.opt.foldtext = "v:lua.FoldText()"

-- foldmethod is set per-buffer in autocmds.lua (treesitter > lsp > syntax)

vim.opt.foldenable = true
vim.opt.foldlevel = 99
-- vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]

vim.go.background = "dark"
vim.opt.termguicolors = true
vim.opt.relativenumber = false
vim.opt.exrc = true

-- Custom tabline: show basename, "CodeDiff" for codediff tabs
function _G.Tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local winid = vim.fn.win_getid(winnr, i)

    -- Highlight for current vs other tabs
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- Tab number (clickable)
    s = s .. "%" .. i .. "T"

    -- Determine label
    local label
    if vim.w[winid] and vim.w[winid].codediff_restore then
      label = "CodeDiff"
    elseif bufname == "" then
      label = "[No Name]"
    else
      label = vim.fn.fnamemodify(bufname, ":t")
    end

    s = s .. " " .. label .. " "
  end

  -- Fill the rest and reset click handler
  s = s .. "%#TabLineFill#%T"
  return s
end

vim.o.tabline = "%!v:lua.Tabline()"
vim.o.showtabline = 1
