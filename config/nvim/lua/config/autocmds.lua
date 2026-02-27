local util = require("util")

local vimrc_augroup = vim.api.nvim_create_augroup("vimrc", {})
local au = function(event, opts)
  opts = vim.tbl_extend("keep", opts, { group = vimrc_augroup })
  vim.api.nvim_create_autocmd(event, opts)
end

au("WinLeave", {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = false
  end,
  desc = "Remove cursorline when buffer loses focus",
})

au({ "WinEnter", "BufEnter", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = true
  end,
  desc = "Enable cursorline when buffer gains focus",
})

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

au("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

au("TermOpen", { pattern = "*", command = [[ startinsert ]] })

-- close floating windows (LSP hover, etc.) with <Esc>
au("WinEnter", {
  callback = function()
    local win_config = vim.api.nvim_win_get_config(0)
    if win_config.relative ~= "" then
      vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = true, silent = true })
    end
  end,
})

au("FileType", {
  pattern = "grug-far",
  callback = function()
    vim.keymap.set("n", "q", function()
      require("grug-far").get_instance(0):close()
    end, { buffer = true, silent = true })
  end,
})

-- restore cursor position
-- BufRead can fire before modelines/filetype are set, which is why the double autocmd
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

au("ColorScheme", { callback = set_dim_diagnostics })
set_dim_diagnostics()

-- folding fallbacks: treesitter > lsp > syntax
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

au("FileType", {
  pattern = "qf",
  callback = function(_)
    vim.keymap.set("n", "q", nohlsOrClose, { desc = "Close quickfix list", buffer = true })
  end,
  desc = "Close quickfix list",
})

au("FileType", {
  pattern = "help",
  callback = function(_)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { desc = "Close help", buffer = true })
  end,
  desc = "Close help",
})

au("CmdwinEnter", {
  callback = function()
    vim.keymap.set("n", "<Esc>", nohlsOrClose, { buffer = true, silent = true })
  end,
})

-- -- cursor color via OSC 12 (highlight groups don't reach the terminal cursor)
-- au({ "VimEnter", "VimResume", "ColorScheme" }, {
--   callback = function()
--     io.write("\27]12;#C8C093\7")
--     io.flush()
--   end,
-- })
--
-- au({ "VimLeave", "VimSuspend" }, {
--   callback = function()
--     io.write("\27]112\7") -- reset, letting zsh precmd restore its color
--     io.flush()
--   end,
-- })
