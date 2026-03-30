local util = require("util")

local vimrc_augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })
local au = function(event, opts)
  opts = vim.tbl_extend("keep", opts, { group = vimrc_augroup, nested = true })
  vim.api.nvim_create_autocmd(event, opts)
end

-- use cursorlineopt=number in diff mode to avoid underline issue
-- https://github.com/neovim/neovim/issues/9800
au("OptionSet", {
  pattern = "diff",
  callback = function()
    if vim.wo.diff then
      vim.opt.cursorlineopt = "number"
    end
  end,
  desc = "Use cursorlineopt=number in diff mode",
})

-- silently edit the file even if a swap exists (avoids the prompt)
au("SwapExists", {
  callback = function()
    vim.v.swapchoice = "e"
  end,
  desc = "Always edit when swap file exists",
})

-- flash yanked region
au("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- start in insert mode when opening or re-entering a terminal
au("TermOpen", { pattern = "*", command = [[ startinsert ]] })
au("WinEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- close grug-far with q
au("FileType", {
  pattern = "grug-far",
  callback = function()
    vim.keymap.set("n", "q", function()
      require("grug-far").get_instance(0):close()
    end, { buffer = true, silent = true })
  end,
})

-- set window-local cwd to the buffer's project root on enter
au("BufEnter", {
  callback = vim.schedule_wrap(function(data)
    -- schedule_wrap defers until after other BufEnter handlers run
    if data.buf ~= vim.api.nvim_get_current_buf() then
      return
    end
    if vim.bo[data.buf].buftype ~= "" then
      return
    end
    -- unnamed buffer: reset window-local cwd back to global (process) cwd
    if vim.api.nvim_buf_get_name(data.buf) == "" then
      vim.cmd.lchdir({ args = { vim.fn.getcwd(-1) }, mods = { silent = true } })
      return
    end
    local root = require("mini.misc").find_root(data.buf, { ".git", ".jj", "init.lua" })
    if root then
      vim.cmd.lchdir({ args = { root }, mods = { silent = true } })
    end
  end),
  desc = "Set buffer cwd to project root if possible",
})

-- dim diagnostic virtual text
local function set_dim_diagnostics()
  local error_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticError" })
  local warn_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" })
  local info_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" })
  local hint_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" })

  local function dim(int_color, factor)
    local hex = util.dim(util.int_to_hex(int_color), factor)
    return tonumber(hex:sub(2), 16)
  end

  local err = dim(error_hl.fg, 0.75)
  local warn = dim(warn_hl.fg, 0.50)
  local info = dim(info_hl.fg, 0.50)
  local hint = dim(hint_hl.fg, 0.50)

  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = err })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = warn })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = info })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = hint })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = err })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = warn })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = info })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = hint })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualLinesError", { fg = err })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualLinesWarn", { fg = warn })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualLinesInfo", { fg = info })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualLinesHint", { fg = hint })
end

-- single-pixel split separator; focused=oniViolet, unfocused=sumiInk3 (Normal bg)
local win_sep_fg = nil

local function set_win_separator_focused()
  if win_sep_fg then
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = win_sep_fg })
  end
end

local function set_win_separator_unfocused()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = normal.bg })
end

local function set_win_separator()
  local hl = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
  win_sep_fg = hl.fg
  set_win_separator_focused()
end

au("ColorScheme", { callback = set_dim_diagnostics })
au("ColorScheme", { callback = set_win_separator })
au("FocusGained", { callback = set_win_separator_focused })
au("FocusLost", { callback = set_win_separator_unfocused })
set_dim_diagnostics()
set_win_separator()

-- folding fallbacks: treesitter > lsp > syntax
local function setup_folding(bufnr)
  local win = vim.fn.bufwinid(bufnr)
  if win == -1 then
    return
  end
  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  -- try treesitter first
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  local has_folds = lang and vim.treesitter.query.get(lang, "folds") ~= nil
  if has_folds then
    vim.wo[win].foldmethod = "expr"
    vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<cr>", "za", { desc = "Toggle open/close fold under cursor" })

    return
  end

  -- try LSP
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.server_capabilities.foldingRangeProvider then
      vim.wo[win].foldmethod = "expr"
      vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
      return
    end
  end

  -- fallback to syntax
  vim.wo[win].foldmethod = "syntax"
end

au("FileType", {
  callback = function(args)
    setup_folding(args.buf)
  end,
  desc = "Set up folding: treesitter > lsp > syntax",
})

au("LspAttach", {
  callback = function(args)
    setup_folding(args.buf)
  end,
  desc = "Re-setup folding on lsp attach",
})

-- if a search is currently highlighted, then :nohls, else :close
local nohlsOrClose = function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohlsearch()
  else
    vim.cmd.close()
  end
end

-- close quickfix with q (or clear search highlight if active)
au("FileType", {
  pattern = "qf",
  callback = function(_)
    vim.keymap.set("n", "q", nohlsOrClose, { desc = "Close quickfix list", buffer = true })
  end,
  desc = "Close quickfix list",
})

-- -- add/remove cursorline per buffer; disabled because cursorline is annoying me
-- au("WinLeave", {
--   pattern = "*",
--   callback = function()
--     vim.opt.cursorline = false
--   end,
--   desc = "Remove cursorline when buffer loses focus",
-- })

-- au({ "WinEnter", "BufEnter", "BufNewFile" }, {
--   pattern = "*",
--   callback = function()
--     vim.opt.cursorline = true
--   end,
--   desc = "Enable cursorline when buffer gains focus",
-- })
