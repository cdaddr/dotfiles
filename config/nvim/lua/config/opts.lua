local util = require("util")

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
-- vim.o.guicursor = "a:blinkon0,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor"
vim.o.winheight = 3
vim.o.winminheight = 3
vim.o.scrolloff = 2
vim.o.suffixesadd = ".md"
vim.o.timeout = true
vim.o.background = "dark"
vim.o.termguicolors = true
vim.o.relativenumber = false
vim.o.exrc = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.title = true
vim.o.titlestring = "%t - Nvim"
vim.o.showmode = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = true
vim.o.listchars = "tab: ,trail:·,nbsp:␣"
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.opt.nrformats:append({ "alpha" })
vim.opt.clipboard:append({ "unnamedplus" })

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  underline = true,
  signs = false,
  severity_sort = true,
})

-- foldmethod is set per-buffer in autocmds.lua (treesitter > lsp > syntax)
function _G.FoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  return string.format("%s ⋯", (line or "Fold"))
end
vim.o.foldtext = "v:lua.FoldText()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99

-- vim.o.timeoutlen = 1000  -- don't: this messes with which-key and other plugins

-- tabline:
function _G.Tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local winid = vim.fn.win_getid(winnr, i)

    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- keep tabs clickable
    s = s .. "%" .. i .. "T"

    local label
    if vim.w[winid] and vim.w[winid].codediff_restore then
      label = " CodeDiff: " .. vim.fn.fnamemodify(bufname, ":t")
    elseif bufname == "" then
      label = "[No Name]"
    else
      label = util.get_display_filename(bufnr)
    end

    s = s .. " " .. label .. " "
  end

  -- Fill the rest and reset click handler
  s = s .. "%#TabLineFill#%T"
  return s
end

vim.o.tabline = "%!v:lua.Tabline()"
vim.o.showtabline = 1
