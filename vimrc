" .vimrc
" http://briancarper.net/vim/vimrc  - Some parts stolen from others.
"
" Don't just copy this.  It has screwy stuff and depends on other stuff.
" There's always a good possibility of there being broken or
" experimental stuff in here.

set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'sjl/gundo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
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
Plug 'vim-scripts/paredit.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'udalov/kotlin-vim'
Plug 'morhetz/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'posva/vim-vue'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mattn/emmet-vim' 
Plug 'kshenoy/vim-signature'
Plug 'cespare/vim-toml'
Plug 'JikkuJose/vim-visincr'
" Plug 'srcery-colors/srcery-vim'
" Plug 'romainl/flattened'
Plug 'fatih/vim-go'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'plasticboy/vim-markdown'

" for deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" themes
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
let g:deoplete#enable_at_startup = 1

" for snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

syntax on
filetype on
filetype plugin indent on

set encoding=utf-8
set fileencoding=utf-8

set background=dark
set termguicolors
colorscheme gruvbox


"" plugin configs

let g:user_emmet_leader_key = '<C-h>'

let g:gitgutter_map_keys = 0

let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_fmt_command = "/Users/brian/Code/go/bin/goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_list_autoclose = 1
let g:go_auto_type_info = 1
let g:go_info_mode = 'guru'

let python_highlight_all = 1
let g:lightline = {'colorscheme': 'gruvbox'}

let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_match_current_file = 1
let g:ctrlp_max_depth = 8

let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1

let g:mustache_abbreviations = 1

let g:rainbow_active = 1

let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0

let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1


let NERDTreeMinimalUI=1
let NERDTreeHighlightCursorline = 1
let NerdTreeChDirMode = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "+",
    \ "Staged"    : "++",
    \ "Untracked" : "?",
    \ "Renamed"   : "->",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "D",
    \ "Dirty"     : "×",
    \ "Clean"     : "ok",
    \ 'Ignored'   : 'I',
    \ "Unknown"   : "?"
    \ }
map <C-n> :NERDTreeCWD<CR>:NERDTreeFocus<CR>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap <Enter> <Plug>(EasyAlign)

set hidden
set updatetime=250
set backup
execute "set backupdir=" . $HOME . "/.vim/backup"
if ! isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

let macvim_skip_cmd_opt_movement = 1

set conceallevel=2

set undofile
execute "set undodir=" . $HOME .  "/.vim/undo"
if ! isdirectory(&undodir)
    call mkdir(&undodir)
endif

set history=5000
set viminfo='1024,<0,s100,f0,r/tmp,r/mnt
" see :h last-position-jump

" Appearance
if !has('nvim')
    if has('mac')
        set guifont=SFMono-Regular:h16
    else
        set guifont=FiraCode-Regular:h14
    endif
end
" Remove GUI menu and toolbar
set guioptions=Ac

set backspace=indent,eol,start
set ruler
set showcmd
set number
set wrap
set mouse=a

" Search
set incsearch
set hls
set noignorecase
set nostartofline
set showmatch

" Sane defaults for tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

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

" The text to return for a fold
function! FoldText()
    let numlines = v:foldend - v:foldstart
    let firstline = getline(v:foldstart)
    "let spaces = 60 - len(firstline)
    if has("gui_running")
        return printf("%3d » %s ", numlines, firstline)
    else
        return printf("%3d > %s ", numlines, firstline)
    endif
endfunction
set foldtext=FoldText()

set foldcolumn=0
set foldmethod=syntax
set foldlevelstart=99

if !has('gui_running')
    set t_Co=256
end

" misc
set cmdheight=1
set laststatus=2
set noshowmode
set wildmenu
set autowrite
set splitright
set ttyfast
if !has('nvim')
    set noballooneval
end

set completeopt-=preview
set completeopt+=noinsert

" Visual bells give me seizures
set t_vb=''

let g:netrw_fastbrowse = 0
let g:netrw_liststyle = 3

let &showbreak = '>>> '
set list listchars=eol:\ ,tab:>-,trail:.,extends:>,nbsp:_

if has("win32")
    set wildignore+=*.bpk,*.bjk,*.diw,*.bmi,*.bdm,*.bfi,*.bdb,*.bxi
endif

augroup custom
    au!
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif
    au QuickFixCmdPost * :copen
    au BufWritePost ~/.vimrc so ~/.vimrc

    autocmd FileType netrw setl bufhidden=wipe

    function! s:buildGo()
        let fn = expand('%:r')
        let &cmdheight = 10
        if fn =~ '_test'
            GoTestCompile
        else
            GoBuild
        endif
        let &cmdheight = 1
    endfunction
    autocmd BufWritePost *.go call s:buildGo()

    function! SetLovePrefs()
        let dir = "$HOME/Documents/GitHub/dotfiles/.vim/love.dict"
        if has("win32") || has("win64")
            command! -nargs=* Love  :silent !"C:\Program Files (x86)\LOVE\love.exe" . <args>
            nnoremap <F12> = :Love<CR>
            exe 'setlocal dictionary-=' . dir . ' dictionary+=' . dir
            setlocal dictionary-=~/vimfiles/lua.dict dictionary+=~/vimfiles/lua.dict
            setlocal iskeyword+=.
            setlocal iskeyword+=:
        end
    endfunction
    autocmd FileType lua call SetLovePrefs()

    au BufWritePost */colors/* exe 'colorscheme ' . expand('%:t:r')

    " Hugo project editing
    function! s:isHugoDir()
        if getftype('config.toml') ==# 'file'
            return 1
        end
    endfunction
    function! s:maybeHugoHtml()
        if s:isHugoDir()
            setlocal filetype=gohtmltmpl
        end
    endfunction
    function! s:maybeHugoIgnore()
        if s:isHugoDir()
            let g:ctrlp_custom_ignore = '\v(dev|static|public)'
        end
    endfunction
    autocmd Filetype html call s:maybeHugoHtml()
    autocmd BufReadPre * call s:maybeHugoIgnore()

    " autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    " autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif

    au FileType go nmap <leader>bb <Plug>(go-build)
    au FileType go nmap <leader>rr <Plug>(go-run)
    au FileType go nmap <leader>tt <Plug>(go-test)
    au FileType go nmap <leader>tf <Plug>(go-test-func)
    au FileType go nmap <leader>aa <Plug>(go-alternate-vertical)
augroup END

function! IsDiff(col)
endfunction

" Jump to the position in a diff line where the difference starts
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

" Use `:match none` to turn off the matches afterwards.
function! CountLines()
    let i = 0
    let s:regex = input("Regex>")
    execute('silent g/' . s:regex . '/let i = i + 1')
    execute("match Search /^.*" . s:regex . ".*$/")
    echo i . " lines match."
    norm ''
endfunction

" Copy/pasting from Word DOC files (uggggggh) results in a horrid mess
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

" Mark lines in current buffer that are exactly the same as a previous line
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

"" Mappings
vnoremap <S-Up> <Up>
inoremap <S-Up> <Up>
nnoremap <S-Up> <Up>
vnoremap <S-Down> <Down>
inoremap <S-Down> <Down>
nnoremap <S-Down> <Down>

nmap <Space> <PageDown>
nmap <C-Space> <PageUp>

" visual mode indenting
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >
vnoremap <S-Tab> <

" Delete all buffers
nnoremap <Leader>bd :silent bufdo! bd<CR>
nnoremap <Leader>BD :silent bufdo! bd!<CR>

"Change cwd to the path of the current file
nnoremap <Leader>c :lcd %:h<CR>

" Toggle wrapping, highlights
nnoremap <Leader>w :setlocal nowrap!<CR>
nnoremap <Leader>h :nohls<CR>

" Close quickfix
nnoremap <Leader>q :cclose<CR>

" open location list
nnoremap <Leader>l :lopen<CR>

" Emacs-ish keybindings
noremap! <M-Backspace> <C-W>
noremap! <M-Left> <C-Left>
noremap! <M-Right> <C-Right>
noremap! <C-A> <Home>
noremap! <C-E> <End>

" Annoying
silent! unmap q:
silent! unmap q/
silent! unmap q?

" fat fingers :(
cabbrev E <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'e' : 'E')<CR>
cabbrev W <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w' : 'W')<CR>
cabbrev Q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'q' : 'Q')<CR>

nnoremap <silent> ]c ]c:call FindDiffOnLine()<CR>
nnoremap <silent> [c [c:call FindDiffOnLine()<CR>

" nnoremap <Leader>l :call CountLines()<CR>

" imap <expr><tab> pumvisible() ? "<C-y>" : "<tab>"
inoremap <expr> <CR> (pumvisible() ? "\<C-e><CR>" : "\<CR>")

inoremap <M-Up> <Esc>:m .-2<CR>==gi
inoremap <M-Down> <Esc>:m .+1<CR>==gi
nnoremap <M-Up> :m-2<CR>==
nnoremap <M-Down> :m+<CR>==
vnoremap <M-Up> :m '<-2<CR>gv=gv
vnoremap <M-Down> :m '>+<CR>gv=gv
inoremap <M-k> <Esc>:m .-2<CR>==gi
inoremap <M-j> <Esc>:m .+1<CR>==gi
nnoremap <M-k> :m-2<CR>==
nnoremap <M-j> :m+<CR>==
vnoremap <M-k> :m '<-2<CR>gv=gv
vnoremap <M-j> :m '>+<CR>gv=gv
" wtf
if has('mac')
    inoremap ˚ <Esc>:m .-2<CR>==gi
    inoremap ∆ <Esc>:m .+1<CR>==gi
    nnoremap ˚ :m-2<CR>==
    nnoremap ∆ :m+<CR>==
    vnoremap ˚ :m '<-2<CR>gv=gv
    vnoremap ∆ :m '>+<CR>gv=gv
endif

" Window movements
nnoremap <M-l> <C-W><Right>
nnoremap <M-h> <C-W><Left>
nnoremap <M-k> <C-W><Up><C-W>_
nnoremap <M-j> <C-W><Down><C-W>_

" Open window below instead of above
nnoremap <silent> <C-W>N :let sb=&sb<BAR>set sb<BAR>new<BAR>let &sb=sb<CR>

" Vertical equivalent of C-w-n and C-w-N
nnoremap <C-w>v :vnew<CR>
nnoremap <C-w>V :let spr=&spr<BAR>set nospr<BAR>vnew<BAR>let &spr=spr<CR>

" I open new windows to warrant using up C-M-arrows on this
nmap <C-M-Up> <C-w>n
nmap <C-M-Down> <C-w>N
nmap <C-M-Right> <C-w>v
nmap <C-M-Left> <C-w>V

" Horizontal window scrolling
nnoremap <C-S-Right> zL
nnoremap <C-S-Left> zH

" select text that was just pasted
nnoremap gp `[v`]

" I used this to record all of my :w's over the course of a day, for fun
"cabbrev w <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'W' : 'w')<CR>
"command! -nargs=* W :execute("silent !echo " . strftime("%Y-%m-%d %H:%M:%S") . " >> ~/timestamps")|w <args>

vnoremap <Leader>n 99<:'<,'>g/^$/d<CR>'<<C-V>'>I1 <ESC>'<<C-V>'>:I<CR>:'<,'>s/\v^(\d+) (.*)/    "\1": "\2"/<CR>'<V'>><ESC>'<O:opts:<ESC><<
nnoremap <Leader>n :s/\v^(\d+\S{-})\.\s+(.*)/      :number: "\1"\r      :text: "\2"/<CR>
nnoremap <Leader>t :s/\v\s*(\S+)\s*(.*)/  - :name: \1\r    :text: "\2"/<CR>\h

vnoremap <Leader>ii >'>oENDIF<ESC><<'<OIF THEN<ESC><<<Up>_yiw<Down>_wPa

" Lines of strings => a paren-surrounded list of comma-separated strings on one line
nnoremap <Leader>ll gg_<C-v>G$A,ggVGJI($s)\h

" Delete blank lines
nnoremap <Leader>db :%g/^$/d<CR>\h
vnoremap <Leader>db :g/^$/d<CR>\h

" Surround every line in the file with quotes
nnoremap <Leader>'' :%s/.*/'\0'<CR>:setlocal nohls<CR>
nnoremap <Leader>"" :%s/.*/"\0"<CR>:setlocal nohls<CR>


"nnoremap <Leader>rr :ruby x={}<CR>:rubydo x[$_] = true<CR>
"nnoremap <Leader>rt :rubydo $_ += ' ****' if x[$_]<CR>

vmap <Leader>y :s/^/    /<CR>gv"+ygv:s/^    //<CR>

iab <expr> dts strftime("%Y-%m-%dT%I:%M:%S")

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

" MacOS mappings
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
end

" Nasty, I used these at work for something.  I forget why, but I may need them again
"nnoremap <silent> <Leader>al vi(yo<ESC>p==:s/\</@/g<CR>A = <ESC>$p:nohls<CR>
"nnoremap <Leader>"" :s/\v(^[^"]*)@<!"@<!""@!([^"]*$)@!/""/g<CR>
"vnoremap <Leader>ra <ESC>:'<,'>s/\w\+/@\1 = \1/<CR>:set nohls<CR>
"vnoremap <Leader>n 99<:'<,'>g/^$/d<CR>'<<C-V>'>I1 <ESC>'<<C-V>'>:I<CR>:'<,'>s/\v^(\d+) (.*)/    "\1": "\2"/<CR>'<V'>><ESC>'<O:opts:<ESC><<
"nnoremap <Leader>n :s/\v^(\d+\S{-})\.\s+(.*)/      :number: "\1"\r      :text: "\2"/<CR>
"nnoremap <Leader>t :s/\v\s*(\S+)\s*(.*)/  - :name: \1\r    :text: "\2"/<CR>\h
"nnoremap <Leader>"" :s/\v(^[^"]*)@<!"@<!""@!([^"]*$)@!/""/g<CR>
"vnoremap <Leader>ra <ESC>:'<,'>s/\w\+/@\1 = \1/<CR>:set nohls<CR>

function! Mirror(dict)
    for [key, value] in items(a:dict)
        let a:dict[value] = key
    endfor
    return a:dict
endfunction

function! SwapWords(dict, ...)
    let words = keys(a:dict) + values(a:dict)
    let words = map(words, 'escape(v:val, "|")')
    if(a:0 == 1)
        let delimiter = a:1
    else
        let delimiter = '/'
    endif
    let pattern = '\v(' . join(words, '|') . ')'
    exe '%s' . delimiter . pattern . delimiter
        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
        \ . delimiter . 'g'
endfunction

" Randomize order of lines in file
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

" append n random letters to each line
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

" find and highlight all lines longer than the current line
function! FindLongerLines()
    let @/ = '^.\{' . col('$') . '}'
    norm n$
endfunction

" show syntax highlighting info of character under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

call lightline#init()
call lightline#colorscheme()
call lightline#update()

