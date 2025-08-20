-- nvim config
-- https://github.com/cdaddr/dotfiles

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.opts")
require("config.lazy")

vim.cmd.colorscheme("catppuccin-macchiato")

local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local cabbrev = vim.cmd.cabbrev
local map = vim.keymap.set

local vimrc = aug('vimrc', {})

au({'BufWritePost'}, {
  pattern = 'init.lua',
  command = "source <afile>"
})

au({'FileType'}, {
  group = vimrc,
  pattern = 'ruby',
  command = "setlocal indentkeys-=."
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

-- toggle options
map("n", "<esc>", "<cmd>nohls<cr>")
map("n", "<leader>th", "<cmd>nohls<cr>")
map("n", "<leader>tw", "<cmd>setlocal nowrap!<cr>")

-- move lines
map('i', '<C-j>', "<c-o>:m .+<CR><c-o>==", {silent=true})
map('i', '<C-k>', "<c-o>:m .-2<CR><c-o>==", {silent=true})
map('n', '<C-j>', ":m .+<CR>==", {silent=true})
map('n', '<C-k>', ":m .-2<CR>==", {silent=true})
map('v', '<C-j>', ":m '>+<CR>gv=gv", {silent=true})
map('v', '<C-k>', ":m '<-2<CR>gv=gv", {silent=true})

-- visual mode reselect pasted text
map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

-- delete to black hole
map("n", "<Leader>d", '"_d')
map("n", "<Leader>D", '"_D')
map("n", "<Leader>x", '"_x')
map("n", "<Leader>s", '"_s')
map("n", "<Leader>S", '"_S')
map("n", "<Leader>c", '"_c')
map("n", "<Leader>C", '"_C')

-- keep indenting
map('v', '>', '>gv')
map('v', '<', '<gv')

-- cd to dir of file in buffer
map('n', '<Leader>cd', ':cd %:p:h<CR>')

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

-- restore cursor position
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})
