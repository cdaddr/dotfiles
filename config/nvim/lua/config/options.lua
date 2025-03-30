-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.o.number = true
vim.o.numberwidth = 1
vim.o.splitright = true
vim.o.undofile = true
vim.o.showmatch = true
vim.o.cursorline = true
vim.o.winheight = 3
vim.o.winminheight = 3
vim.o.scrolloff = 5
vim.o.suffixesadd = ".md"
vim.o.signcolumn = "yes:2"
vim.o.timeoutlen = 1000
vim.o.mouse = "a"
vim.o.breakindent = true
vim.opt.nrformats:append({ "alpha" })
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]
vim.go.background = "dark"
vim.opt.termguicolors = true
vim.g.loaded_perl_provider = 0
vim.opt.relativenumber = false

vim.g.snacks_animate = false

vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

vim.cmd.cabbrev("<expr>", "E", "(getcmdtype() == ':') ? 'e' : 'E'")
vim.cmd.cabbrev("<expr>", "W", "(getcmdtype() == ':') ? 'W' : 'W'")
vim.cmd.cabbrev("Q", "q")
vim.cmd.cabbrev("vrc", ":e $MYVIMRC")
