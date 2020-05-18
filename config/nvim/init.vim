" .vimrc
" http://github.com/cdaddr/dotfiles/

" welcome to vim {{{1 
set nocompatible
set encoding=utf-8
scriptencoding utf-8

syntax on
filetype on
filetype plugin indent on

" plugins {{{1
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'sjl/gundo.vim'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-signify'
Plug 'chrisbra/NrrwRgn'
Plug 'xolox/vim-misc'
Plug 'cdaddr/gentooish.vim'
Plug 'tpope/vim-salve'
Plug 'jmcantrell/vim-virtualenv'
Plug 'mustache/vim-mustache-handlebars'
Plug 'cespare/vim-toml'
Plug 'robertbasic/vim-hugo-helper'
Plug 'w0rp/ale'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'udalov/kotlin-vim'
Plug 'rust-lang/rust.vim'
Plug 'mattn/emmet-vim' 
Plug 'kshenoy/vim-signature'
Plug 'cespare/vim-toml'
Plug 'JikkuJose/vim-visincr'
Plug 'farmergreg/vim-lastplace'
Plug 'fatih/vim-go'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
" Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-commentary'
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular'
Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte'
Plug 'FooSoft/vim-argwrap'
Plug 'markonm/traces.vim'
Plug 'wellle/targets.vim'
Plug 'gko/vim-coloresque'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'kovisoft/paredit'
Plug 'dkarter/bullets.vim'

" themes
Plug 'franbach/miramare'
Plug 'chriskempson/base16-vim'
Plug 'arcticicestudio/nord-vim'

" for snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()
" }}}

" plugin configs {{{1
let g:bullets_enabled_file_types = ['markdown', 'text']
let g:netrw_fastbrowse = 0
let g:netrw_liststyle = 3
let g:user_emmet_leader_key = '<C-t>'
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

call miramare_lightline#load()
let g:lightline = {
            \ 'colorscheme': 'nord',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ],
            \  'right': [ [ 'lineinfo' ],
            \             [ 'percent' ],
            \             [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'inactive': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ],
            \  'right': [ [ 'lineinfo' ],
            \             [ 'percent' ],
            \             [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'cocstatus': 'coc#status',
            \   'currentfunction': 'CocCurrentFunction'
            \ },
        \ }

let g:mustache_abbreviations = 1
let g:rainbow_active = 1
let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1
let g:AutoPairsShortcutFastWrap='<C-Right>'
let g:splitjoin_ruby_curly_braces=0

let g:indentLine_concealcursor=''

" set before choosing color scheme
let g:miramare_enable_italic=1
let g:nord_cursor_line_number_background = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 0
let g:nord_bold = 1
" }}}1
"
" appearance {{{1
if !has('nvim')
    if has('mac')
        set guifont=SFMono-Regular:h16
    else
        set guifont=FiraCode-Regular:h14
    endif
end
" Remove GUI menu and toolbar
set guioptions=Ac
set ruler
set showcmd
set number
set conceallevel=0
set incsearch
set hlsearch
set showmatch
set wildmenu
set cursorline
set winheight=3
set winminheight=3

set background=dark
set termguicolors
colorscheme nord

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
" fix insert mode cursor
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"

function! Foldtext()
    let line = getline(v:foldstart)
    let sub = substitute(line, '\v^("|/\*|//)\s*|\s*(\{{3}\d?\s*)', '', 'g')
    let format = ' %s (%d lines) '
    return v:folddashes . printf(format, sub, (v:foldend - v:foldstart))
endfunction
set foldtext=Foldtext()
set fillchars=vert:\┃,fold:-,stl:-

if ! has('nvim')
    set cursorlineopt=number
end

let g:indentLine_char_list = ['┆']

" Visual bells give me seizures
set t_vb=''

let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'DiffAdd', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'Normal', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Normal'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Typedef'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Normal'] }
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" wrapping {{{1
set formatoptions+=tc
set textwidth=99
" set colorcolumn=100
set wrap

" backup/undo/history/viminfo {{{1
let $NVIM = stdpath('config')

function! s:mkdir_p(dir)
    if !isdirectory(a:dir)
        call mkdir(a:dir, 'p')
    endif
endfunction

let s:cache_home = ($XDG_CACHE_HOME ? $XDG_CACHE_HOME : $HOME . '/.cache')
let &directory = s:cache_home . '/vim/swap'
call s:mkdir_p(&directory)

set backup
let &backupdir = s:cache_home . '/vim/backup'
call s:mkdir_p(&backupdir)

set undofile
let &undodir = s:cache_home . '/vim/undo'
call s:mkdir_p(&undodir)

let &spellfile = s:cache_home . '/vim/spell.utf-8.add'
set spellcapcheck=

set history=5000
let &shada="'100,<50,s10,h,r/tmp,r/mnt,r" . s:cache_home
let &shadafile = s:cache_home . '/vim/main.shada'

let g:fzf_history_dir = s:cache_home . '/vim/fzf-history'

set backspace=indent,eol,start
set mouse=a

" search {{{1
set noignorecase
set nostartofline

" sane defaults for tabs {{{1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" folds {{{1
set foldcolumn=1
set foldmethod=marker
set foldlevelstart=1

" misc {{{1
set cmdheight=1
set laststatus=2
set noshowmode
set autowrite
set splitright
if !has('nvim')
    set ttyfast
    set noballooneval
end

let macvim_skip_cmd_opt_movement = 1

set hidden
set updatetime=100
if has("nvim")
    set diffopt+=internal,algorithm:patience
endif

set completeopt=noinsert,menuone,

let &showbreak = '>>> '
set list listchars=eol:\ ,tab:>-,trail:.,extends:>,nbsp:_

" autocommands {{{1
augroup custom
    au!
    au TermOpen * startinsert
    " :h restore-cursor
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

    au QuickFixCmdPost * :copen
    au BufWritePost $MYVIMRC so $MYVIMRC

    autocmd FileType netrw setl bufhidden=wipe

    au FileType text setlocal formatoptions+=a

    au FileType markdown setlocal comments=fb:> formatoptions-=q spell

    au BufWritePost */colors/* exe 'colorscheme ' . expand('%:t:r')
augroup END
" }}}1
" functions {{{1
" Randomize order of lines in file {{{2
if has("ruby")
    function! ShuffleLines()
ruby << EOF
        buf = VIM::Buffer.current
        nlines = buf.count
        firstnum =  VIM::evaluate('a:firstline')
        lastnum = VIM::evaluate('a:lastline')
        lines = []
        firstnum.upto(lastnum) do |lnum|
          lines << buf[lnum]
        end
        lines.shuffle!
        firstnum.upto(lastnum) do |lnum|
          buf[lnum] = lines[lnum-firstnum]
        end
EOF
    endfunction
end

" append n random letters to each line {{{2
function! AppendRandomLetter(n)
    if a:n > 0
        let n = a:n
    else
        let n = 1
    end
    for _ in range(0, n-1)
        rubydo $_ = $_ + (('A'..'Z').to_a.reject{|x| %w{I O}.include?(x)})[rand 24]
    endfor
endfunction

" find and highlight all lines longer than the current line {{{2
function! FindLongerLines()
    let @/ = '^.\{' . col('$') . '}'
    norm n$
endfunction

"
" Jump to the position in a diff line where the difference starts {{{2
function! FindDiffOnLine()
    let c = 1
    while c < col("$")
        let hlID = diff_hlID(".", c)
        if hlID == 24
            call cursor(".", c)
            return
        endif
        let c += 1
    endwhile
endfunction

" Use `:match none` to turn off the matches afterwards. {{{2
function! CountLines()
    let i = 0
    let s:regex = input("Regex>")
    execute('silent g/' . s:regex . '/let i = i + 1')
    execute("match Search /^.*" . s:regex . ".*$/")
    echo i . " lines match."
    norm ''
endfunction

" Copy/pasting from Word DOC files (uggggggh) results in a horrid mess {{{2
function! FixInvisiblePunctuation()
    silent! %s/\%u2018/'/g
    silent! %s/\%u2019/'/g
    silent! %s/\%u2026/.../g
    silent! %s/\%uf0e0/->/g
    silent! %s/\%u0092/'/g
    silent! %s/\%u2013/--/g
    silent! %s/\%u2014/--/g
    silent! %s/\%u201C/"/g
    silent! %s/\%u201D/"/g
    silent! %s/\%u0052\%u20ac\%u2122/'/g
    silent! %s/\%ua0/ /g
    silent! %s/\%u93/'/g
    silent! %s/\%u94/'/g
    retab
endfunction

" Mark lines in current buffer that are exactly the same as a previous line {{{2
function! MarkDuplicateLines()
    let x = {}
    let count_dupes = 0
    for lnum in range(1, line('$'))
        let line = getline(lnum)
        if has_key(x, line)
            exe lnum . 'norm I *****'
            let count_dupes += 1
        else
            let x[line] = 1
        endif
    endfor
    echomsg count_dupes . " dupe(s) found"
endfunction

" quickfix {{{2
" https://vim.fandom.com/wiki/Toggle_to_open_or_close_the_quickfix_window
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    copen 8
  endif
endfunction

augroup QFixToggle
 autocmd!
 autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
 autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win |
             \ unlet! g:qfix_win |
             \ endif
augroup END

" abbrs {{{1
func Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunc
iab <silent> tts <C-R>=strftime("%Y-%m-%dT%I:%M:%S")<CR><C-R>=Eatchar('\s')<CR>
iab <silent> ttd <C-R>=strftime("%Y-%m-%d")<CR><C-R>=Eatchar('\s')<CR>
iab _-- —

" fat fingers :(
cabbrev E <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'e' : 'E')<CR>
cabbrev W <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w' : 'W')<CR>
cabbrev Q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'q' : 'Q')<CR>


" mappings {{{1
" terminal {{{2

" tnoremap <Esc> <C-\><C-n>
" tmap <C-j> <Esc><C-j>
" tmap <C-k> <Esc><C-k>
" tmap <C-h> <Esc><C-h>
" tmap <C-l> <Esc><C-l>


" movement {{{2
vnoremap <S-Up> <Up>
inoremap <S-Up> <Up>
nnoremap <S-Up> <Up>
vnoremap <S-Down> <Down>
inoremap <S-Down> <Down>
nnoremap <S-Down> <Down>

" visual mode indenting {{{2
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >
vnoremap <S-Tab> <

" Delete all buffers {{{2
nnoremap <Leader>bd :silent bufdo! bd<CR>
nnoremap <Leader>BD :silent bufdo! bd!<CR>

nnoremap <silent> <Leader>a :ArgWrap<CR>

"Change cwd to the path of the current file {{{2
nnoremap <Leader>c :lcd %:h<CR>

" Toggle wrapping, highlights {{{2
nnoremap <Leader>w :setlocal nowrap!<CR>
nnoremap <Leader>h :nohls<CR>

nnoremap <Leader>q :QFix<CR>

nnoremap p ]p

" location list {{{2
nnoremap <Leader>l :lopen<CR>

" Emacs-ish keybindings {{{2
noremap! <M-Backspace> <C-W>
noremap! <M-Left> <C-Left>
noremap! <M-Right> <C-Right>
noremap! <C-a> <Home>
nnoremap <C-a> <Home>
noremap! <C-e> <End>
nnoremap <C-e> <End>
imap <M-l> <M-right>
imap <M-h> <M-left>
inoremap <M-right> <C-o>E<C-o>a
inoremap <M-left> <C-o>B
imap <C->> <C-o>:BulletDemote<CR>

nnoremap <silent> ]c ]c:call FindDiffOnLine()<CR>
nnoremap <silent> [c [c:call FindDiffOnLine()<CR>

" nnoremap <Leader>l :call CountLines()<CR> {{{2

imap <silent> <expr> <C-j> (pumvisible() ? "\<C-n>" : "\<C-j>")
imap <silent> <expr> <C-k> (pumvisible() ? "\<C-p>" : "\<C-k>")
imap <C-j> <Esc><C-j>
imap <C-k> <Esc><C-k>
imap <C-h> <Esc><C-h>
imap <C-l> <Esc><C-l>
" handled by tmux plugin
" nmap <C-h> <C-w>h
" nmap <C-k> <C-w>k
" nmap <C-j> <C-w>j
" nmap <C-l> <C-w>l
function! EnterInsideTag()
    if strcharpart(getline('.'), getpos('.')[2]-1, 1) == '<'
        return "\<CR>\<Esc>O"
    else
        return "\<CR>"
    endif
endfunction
imap <expr> <CR> EnterInsideTag()
inoremap (<CR> (<CR>)<C-c>O
inoremap [<CR> [<CR>]<C-c>O
inoremap {<CR> {<CR>}<C-c>O

" move lines up/down
inoremap <M-k> <Esc>:m .-2<CR>==gi
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-Up> <Esc>:m .-2<CR>==gi
inoremap <M-Down> <Esc>:m .+1<CR>==gi
nnoremap <M-Up> :m-2<CR>==
nnoremap <M-Down> :m+<CR>==
vnoremap <M-Up> :m '<-2<CR>gv=gv
vnoremap <M-Down> :m '>+<CR>gv=gv
nnoremap <M-k> :m-2<CR>==
nnoremap <M-j> :m+<CR>==
vnoremap <M-k> :m '<-2<CR>gv=gv
vnoremap <M-j> :m '>+<CR>gv=gv

" move words left-right (https://vim.fandom.com/wiki/Swapping_characters,_words_and_lines)
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
nnoremap <silent> gl "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR><Paste>
nmap <M-h> gl
nmap <M-l> gw
imap <M-l> <C-o>gw
imap <M-h> <C-o>gl

set pastetoggle=<Leader>p

" Open window below instead of above {{{2
nnoremap <silent> <C-W>N :let sb=&sb<BAR>set sb<BAR>new<BAR>let &sb=sb<CR>

" Vertical equivalent of C-w-n and C-w-N {{{2
nnoremap <C-w>v :vnew<CR>
nnoremap <C-w>V :let spr=&spr<BAR>set nospr<BAR>vnew<BAR>let &spr=spr<CR>

" Horizontal window scrolling {{{2
nnoremap <C-S-Right> zL
nnoremap <C-S-Left> zH

" select text that was just pasted {{{2
nnoremap gp `[v`]

" I used this to record all of my :w's over the course of a day, for fun {{{2
"cabbrev w <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'W' : 'w')<CR>
"command! -nargs=* W :execute("silent !echo " . strftime("%Y-%m-%d %H:%M:%S") . " >> ~/timestamps")|w <args>

" Lines of strings => a paren-surrounded list of comma-separated strings on one line {{{2
nnoremap <Leader>ll gg_<C-v>G$A,ggVGJI($s)\h

" Delete blank lines {{{2
nnoremap <Leader>db :%g/^$/d<CR>\h
vnoremap <Leader>db :g/^$/d<CR>\h

" Surround every line in the file with quotes {{{2
nnoremap <Leader>'' :%s/.*/'\0'<CR>:setlocal nohls<CR>
nnoremap <Leader>"" :%s/.*/"\0"<CR>:setlocal nohls<CR>

" fzf {{{2
nnoremap <C-p> :Files<CR>
nnoremap <Space>p :Files<CR>
nnoremap <C-g> :Rg<CR>
nnoremap <Space>b :Buffers<CR>
nnoremap <Space>c :History:<CR>
nnoremap <Space>l :BLines<CR>
nnoremap <Space>g :Rg<CR>
nnoremap <Space>h :History<CR>
nnoremap <Space>s :Snippets<CR>

nnoremap <silent> <Space>y :<C-u>CocList -A --normal --number-select yank<cr>

" ultisnips {{{2
let g:UltiSnipsListSnippets="<c-u>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
" MacOS mappings {{{2
if has('mac')
    noremap <D-Up> <PageUp>
    noremap <D-Down> <PageDown>
    noremap <D-Left> _
    noremap <D-Right> $

    noremap <D-k> <PageUp>
    noremap <D-j> <PageDown>
    noremap <D-h> _
    noremap <D-l> $

    inoremap <D-k> <PageUp>
    inoremap <D-j> <PageDown>
    inoremap <D-h> <Esc>I
    inoremap <D-l> <Esc>A

    " wtf
    inoremap ˚ <Esc>:m .-2<CR>==gi
    inoremap ∆ <Esc>:m .+1<CR>==gi
    nnoremap ˚ :m-2<CR>==
    nnoremap ∆ :m+<CR>==
    vnoremap ˚ :m '<-2<CR>gv=gv
    vnoremap ∆ :m '>+<CR>gv=gv
    nmap ˙ <M-h>
    nmap ¬ <M-l>
    imap ˙ <M-h>
    imap ¬ <M-l>
end

" show syntax highlighting info of character under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

function! HugoServe()
    below new
    terminal hugo serve --disableFastRender --bind 0.0.0.0 --buildDrafts
endfunction

nnoremap <F5> :call HugoServe()<CR>

" refresh highlighting after sourcing {{{1
call lightline#init()
call lightline#colorscheme()
