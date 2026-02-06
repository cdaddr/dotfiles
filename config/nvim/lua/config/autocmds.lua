local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local util = require("util")
local vimrc = aug("vimrc", {})

au("WinLeave", {
  pattern = "*",
  group = vimrc,
  callback = function()
    vim.opt.cursorline = false
  end,
  desc = "Window crosshair: Remove cursorline and colorcolumn when buffer loses focus",
})

au({ "WinEnter", "BufEnter", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = true
  end,
  desc = "Window crosshair: Restore cursorline and colorcolumn when buffer gains focus",
})

au({ "FileType" }, {
  group = vimrc,
  pattern = "ruby",
  command = "setlocal indentkeys-=.",
})

au("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

au("FileType", {
  pattern = { "json", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

au("Filetype", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<esc>", "<cmd>cclose<cr>", { buffer = true })
  end,
})

au("TermOpen", { pattern = "*", command = [[ startinsert ]] })

-- close command-line window with <Esc>
au("CmdwinEnter", {
  callback = function()
    vim.keymap.set("n", "<Esc>", "<cmd>q<cr>", { buffer = true, silent = true })
  end,
})

-- restore cursor position
au("BufRead", {
  callback = function(opts)
    au("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match("commit") and ft:match("rebase"))
          and last_known_line >= 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], "nx", false)
        end
      end,
    })
  end,
})

-- dim diagnostic virtual text
local function set_dim_diagnostics()
  local error_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticError" })
  local warn_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" })
  local info_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" })
  local hint_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" })
  local bg_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  local bg = bg_hl.bg or 0x16161D
  vim.cmd("hi DiagnosticUnderlineError gui=undercurl guisp=#" .. util.blend_hex(error_hl.fg, bg, 0.5))
  vim.cmd("hi DiagnosticUnderlineWarn gui=undercurl guisp=#" .. util.blend_hex(warn_hl.fg, bg, 0.5))
  vim.cmd("hi DiagnosticUnderlineInfo gui=undercurl guisp=#" .. util.blend_hex(info_hl.fg, bg, 0.5))
  vim.cmd("hi DiagnosticUnderlineHint gui=undercurl guisp=#" .. util.blend_hex(hint_hl.fg, bg, 0.5))
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = util.blend(error_hl.fg, bg, 0.5) })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = util.blend(warn_hl.fg, bg, 0.5) })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = util.blend(info_hl.fg, bg, 0.5) })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = util.blend(hint_hl.fg, bg, 0.5) })
end

au("ColorScheme", { callback = set_dim_diagnostics })
set_dim_diagnostics()

-- muted fold column for statuscol
local function set_muted_fold_column()
  local linenr_hl = vim.api.nvim_get_hl(0, { name = "LineNr" })
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  local fg = linenr_hl.fg
  local bg = normal_hl.bg or 0x16161D

  if fg then
    vim.api.nvim_set_hl(0, "StatusColFold", {
      fg = util.blend(fg, bg, 0.5),
      bg = linenr_hl.bg,
    })
  else
    vim.api.nvim_set_hl(0, "StatusColFold", { link = "FoldColumn" })
  end
end

au("ColorScheme", { callback = set_muted_fold_column })
set_muted_fold_column()

-- folding: treesitter > lsp > syntax
local function setup_folding(bufnr)
  local win = vim.fn.bufwinid(bufnr)
  if win == -1 then
    return
  end

  -- try treesitter first
  local has_parser = pcall(vim.treesitter.get_parser, bufnr)
  if has_parser then
    vim.wo[win].foldmethod = "expr"
    vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<cr>", "za", { desc = "Toggle open/close fold under cursor" })

    return
  end

  -- try LSP folding
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
  group = vimrc,
  callback = function(args)
    setup_folding(args.buf)
  end,
  desc = "Set up folding: treesitter > lsp > syntax",
})

au("LspAttach", {
  group = vimrc,
  callback = function(args)
    -- re-evaluate folding when LSP attaches (in case treesitter wasn't available)
    setup_folding(args.buf)
  end,
  desc = "Re-evaluate folding on LSP attach",
})

-- stop q from starting a macro during hit-enter (:h hit-enter)
vim.cmd([[
  fu s:hit_enter_prompt_no_recording() abort
    if has('nvim')
      nno q <c-\><c-n>
      return timer_start(0, {-> execute('nunmap q', 'silent!')})
    endif
    if mode() isnot# 'r' | return | endif
    nno <expr> q execute('nunmap q', 'silent!')[-1]
    if exists('##SafeState')
      au SafeState * ++once sil! nunmap q
    else
      let q = {}
      let q.timer = timer_start(10, {-> mode() isnot# 'r' && q.nunmap()}, {'repeat': -1})
      fu q.nunmap() abort
        call timer_stop(self.timer)
        sil! nunmap q
      endfu
    endif
  endfu
  augroup hit_enter_prompt | au!
    if has('nvim')
      au CmdlineLeave : call s:hit_enter_prompt_no_recording()
    else
      au CmdlineLeave : call timer_start(0, {-> s:hit_enter_prompt_no_recording()})
    endif
  augroup END
]])
