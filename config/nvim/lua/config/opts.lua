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
vim.opt.clipboard:append {'unnamedplus'}
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]
vim.go.background = "dark"
vim.opt.termguicolors = true
vim.opt.relativenumber = false
