-- nvim config
-- https://github.com/cdaddr/dotfiles


-- Load theme from generated config
local theme_file = vim.fn.expand('~/.dotfiles/config/current-theme.lua')
local theme = dofile(theme_file)
_G.theme = theme

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.opts")
require("config.lazy")
require("config.lsp")

local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local vimrc = aug("vimrc", {})

local cabbrev = vim.cmd.cabbrev
local map = vim.keymap.set

vim.diagnostic.config({virtual_text=true, virtual_lines=false, underline=true, signs=false})

-- dim diagnostic virtual text
local function set_dim_diagnostics()
  local error_hl = vim.api.nvim_get_hl(0, {name = 'DiagnosticError'})
  local warn_hl = vim.api.nvim_get_hl(0, {name = 'DiagnosticWarn'})
  local info_hl = vim.api.nvim_get_hl(0, {name = 'DiagnosticInfo'})
  local hint_hl = vim.api.nvim_get_hl(0, {name = 'DiagnosticHint'})
  local bg_hl = vim.api.nvim_get_hl(0, {name = 'Normal'})

  local function dim_color(fg, bg, percent)
    percent = percent or 0.5
    if not fg or not bg then return nil end
    local function hex_to_rgb(hex)
      return tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16)
    end
    local function rgb_to_hex(r, g, b)
      return string.format("%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
    end
    local fr, fg_val, fb = hex_to_rgb(string.format("%06x", fg))
    local br, bg_val, bb = hex_to_rgb(string.format("%06x", bg))
    local r = br * percent + fr * percent
    local g = bg_val * percent + fg_val * percent
    local b = bb * percent + fb * percent
    return rgb_to_hex(r, g, b)
  end

  local bg = bg_hl.bg or 0x16161D
  vim.cmd("hi DiagnosticUnderlineError gui=undercurl guisp=#" .. dim_color(error_hl.fg, bg))
  vim.cmd("hi DiagnosticUnderlineWarn gui=undercurl guisp=#" .. dim_color(warn_hl.fg, bg))
  vim.cmd("hi DiagnosticUnderlineInfo gui=undercurl guisp=#" .. dim_color(info_hl.fg, bg))
  vim.cmd("hi DiagnosticUnderlineHint gui=undercurl guisp=#" .. dim_color(hint_hl.fg, bg))
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = tonumber(dim_color(error_hl.fg, bg), 16) })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = tonumber(dim_color(warn_hl.fg, bg), 16) })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = tonumber(dim_color(info_hl.fg, bg), 16) })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = tonumber(dim_color(hint_hl.fg, bg), 16) })
end

au("ColorScheme", { callback = set_dim_diagnostics })
set_dim_diagnostics()

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

vim.cmd.colorscheme(theme.nvim)

au({ "BufWritePost" }, {
	pattern = "init.lua",
  group = vimrc,
  callback = function()
    vim.cmd("source %")
    vim.schedule(function() vim.cmd.colorscheme(theme.nvim) end)
  end
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
    vim.keymap.set("n", "<esc>", "<cmd>cclose<cr>", {buffer = true})
  end
})

cabbrev("<expr>", "E", "(getcmdtype() == ':') ? 'e' : 'E'")
cabbrev("<expr>", "W", "(getcmdtype() == ':') ? 'w' : 'W'")
cabbrev("<expr>", "Q", "(getcmdtype() == ':') ? 'q' : 'Q'")
cabbrev("<expr>", "Qa", "(getcmdtype() == ':') ? 'qa' : 'Qa'")
cabbrev("vrc", ":e $MYVIMRC")

-- insert mode niceties
map({ "i", "c" }, "<M-BS>", "<C-W>", { desc = "Backward delete word" })

map("n", "<esc>", "<cmd>nohls<cr>")

-- move lines
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "select window down <C-w>j" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "select window up <C-w>k" })
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "select window left <C-w>h" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "select window right <C-w>l" })
map("i", "<C-j>", "<C-o><C-j>", { silent = true })
map("i", "<C-k>", "<C-o><C-k>", { silent = true })
map("i", "<C-h>", "<C-o><C-h>", { silent = true })
map("i", "<C-l>", "<C-o><C-l>", { silent = true })

map("n", "t", "<cmd>bnext<cr>", {desc = ":bnext"})

map('n', '<leader>o', '<cmd>Oil<cr>', {desc = "Open Oil"}) -- visual mode reselect pasted text
map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

-- map('t', '<esc>', "<C-\\><C-n>", { noremap = true, silent = true, desc = "Toggle terminal" })

-- delete to black hole

-- keep indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

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

au("TermOpen", {pattern = "*", command = [[ startinsert ]] })

-- close command-line window with <Esc>
au("CmdwinEnter", {
  callback = function()
    vim.keymap.set('n', '<Esc>', '<cmd>q<cr>', { buffer = true, silent = true })
  end
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
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})

