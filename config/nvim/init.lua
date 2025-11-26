-- nvim config
-- https://github.com/cdaddr/dotfiles
--

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.opts")
require("config.lazy")

local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local cabbrev = vim.cmd.cabbrev
local map = vim.keymap.set

vim.diagnostic.config({virtual_text=true, virtual_lines=false, underline=true})

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

vim.cmd.colorscheme("catppuccin-macchiato")
-- vim.cmd.colorscheme("kanagawa")


local vimrc = aug("vimrc", {})

au({ "BufWritePost" }, {
	pattern = "init.lua",
	command = "source <afile>",
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

cabbrev("<expr>", "E", "(getcmdtype() == ':') ? 'e' : 'E'")
cabbrev("<expr>", "W", "(getcmdtype() == ':') ? 'w' : 'W'")
cabbrev("<expr>", "Q", "(getcmdtype() == ':') ? 'q' : 'Q'")
cabbrev("vrc", ":e $MYVIMRC")

-- insert mode niceties
map({ "i", "c" }, "<M-BS>", "<C-W>", { desc = "Backward delete word" })

map("n", "<esc>", "<cmd>nohls<cr>")

-- move lines
map("i", "<C-j>", "<c-o>:m .+<CR><c-o>==", { silent = true })
map("i", "<C-k>", "<c-o>:m .-2<CR><c-o>==", { silent = true })
map("n", "<C-j>", ":m .+<CR>==", { silent = true })
map("n", "<C-k>", ":m .-2<CR>==", { silent = true })
map("v", "<C-j>", ":m '>+<CR>gv=gv", { silent = true })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true })

map("n", "t", "<cmd>bnext<cr>", {desc = ":bnext"})

map('n', '<leader>o', '<cmd>Oil<cr>', {desc = "Open Oil"}) -- visual mode reselect pasted text
map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

-- map('t', '<esc>', "<C-\\><C-n>", { noremap = true, silent = true, desc = "Toggle terminal" })

-- delete to black hole
-- map("n", "<Leader>d", '"_d')
-- map("n", "<Leader>D", '"_D')
-- map("n", "<Leader>x", '"_x')
-- map("n", "<Leader>s", '"_s')
-- map("n", "<Leader>S", '"_S')
-- map("n", "<Leader>c", '"_c')
-- map("n", "<Leader>C", '"_C')

-- keep indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- cd to dir of file in buffer
map("n", "<Leader>cd", ":cd %:p:h<CR>")

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

vim.cmd([[ autocmd TermOpen * startinsert ]])

-- restore cursor position
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', {buffer = true})
    vim.keymap.set('n', '<f1>', function() require('pretty_hover').hover() end, {buffer=true})
    vim.keymap.set('n', 'K', function() require('pretty_hover').hover() end, {buffer=true})
    vim.keymap.set('n', '<s-f1>', '<C-w>d', {noremap = true, buffer = true})
  end
})

