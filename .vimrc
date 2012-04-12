" .vimrc
" http://briancarper.net/vim/vimrc  - Some parts stolen from others.
"
" Don't just copy this.  It has screwy stuff and depends on other stuff.
" There's always a good possibility of there being broken or
" experimental stuff in here.
"

call pathogen#runtime_append_all_bundles()

set nocompatible
syntax on
filetype on
filetype plugin indent on

set encoding=utf-8
set fileencoding=utf-8

set backup
" I want all my backups in one directory
if has('win32')
    let s:homedir = "$HOME/vimfiles"
else
    let s:homedir = "$HOME/.vim"
endif
execute "set backupdir=" . s:homedir . "/backup"

if has('persistent_undo')
    set undofile
    execute "set undodir=" . s:homedir .  "/undo"
endif

set history=5000
set viminfo='1024,<0,s100,f0,r/tmp,r/mnt
" see :h last-position-jump

" Appearance
colorscheme gentooish
if has('win32')
    "set guifont=Terminus:h12:w6
    set guifont=Consolas:h11:w6
    hi StatusLine gui=NONE
    hi User1 gui=NONE
    hi User2 gui=NONE
    hi WildMenu gui=NONE
else
    set guifont=Consolas\ 12
endif
" Remove GUI menu and toolbar
set guioptions-=T
set guioptions-=m

if(has("gui_running"))
    set cursorline
    set cursorcolumn
endif

set backspace=indent,eol,start
set ruler
set showcmd
set number
set wrap

" Search
set incsearch
set hls
set noignorecase

set splitright

" Sane defaults for tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
"set smartindent

set foldtext=FoldText()
set fillchars=fold:·
set foldcolumn=0
set foldmethod=syntax
set foldlevelstart=1

set laststatus=2
set wildmenu

set noballooneval
set ttyfast

" Bouncy parens
set showmatch

" Visual bells give me seizures
set t_vb=''

set nostartofline
"set nowrapscan

let g:loaded_alignmaps=1
let c_curly_error=1

set cmdheight=1

" Stolen from http://github.com/ciaranm/dotfiles-ciaranm/tree/master
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set list listchars=eol:\ ,tab:»-,trail:·,precedes:…,extends:…,nbsp:‗
    else
        set list listchars=eol:\ ,tab:»·,trail:·,extends:…
    endif
else
    if v:version >= 700
        set list listchars=eol:\ ,tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=eol:\ ,tab:>-,trail:.,extends:>
    endif
endif

" Inspired by http://github.com/ciaranm/dotfiles-ciaranm/tree/master
set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)

if has("win32")
    set wildignore+=*.bpk,*.bjk,*.diw,*.bmi,*.bdm,*.bfi,*.bdb,*.bxi
endif

if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif
    autocmd QuickFixCmdPost * :copen
    au VimEnter * :call FixVimpager()
    au BufWritePost *vimrc so %
endif

" The text to return for a fold
function! FoldText()
    let numlines = v:foldend - v:foldstart
    let firstline = getline(v:foldstart)
    "let spaces = 60 - len(firstline)
    return printf("%3d » %s ", numlines, firstline)
endfunction

function! IsDiff(col)
    let hlID = diff_hlID(".", a:col)
    return hlID == 24
endfunction

" Jump to the position in a diff line where the difference starts
function! FindDiffOnLine()
    let c = 1
    while c < col("$")
        if IsDiff(c)
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
    retab
endfunction

" Remove weird keybindings from vimpager; plain Vim is good enough
function! FixVimpager()
    if exists("g:loaded_less") && g:loaded_less
        set nolist
        set nofoldenable
        unmap <Space>
        unmap z
        unmap q
        unmap d
    endif
endfunction

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

function! MarkDuplicateLinesBetweenBuffers(first_time)
    let count_lines = 0
    if a:first_time
        let g:_DupeLines = {}
        for lnum in range(1, line('$'))
            let g:_DupeLines[getline(lnum)] = 1
            let count_lines += 1
        endfor
        echomsg count_lines . " line(s) slurped"
    else
        for lnum in range(1, line('$'))
            let line = getline(lnum)
            if has_key(g:_DupeLines, line)
                exe lnum . 'norm I *****'
                let count_lines += 1
            endif
        endfor
        echomsg count_lines . " dupe(s) found"
    endif
endfunction

function! S(number)
    return submatch(a:number)
endfunction

" http://vim.wikia.com/wiki/Generating_a_column_of_increasing_numbers
let g:I=0
function! INC(increment)
  let g:I = g:I + a:increment
  return g:I
endfunction

function! CopyDiffLines()
    let c = 1
    let @a = ''
    while c <= line('$')
        if diff_hlID(c,1)
            exe 'norm ' . c . 'G"Ayy'
        endif
        let c += 1
    endwhile
    new
    norm V"ap
endfunction

function! Duplicate(repl, start, end, ...) range
    if a:0 == 1
        let format = a:1
    else
        let format = '%02d'
    endif
    let x = a:start
    let txt = getline(a:firstline, a:lastline)
    while x <= a:end
        for line in copy(txt)
            let newline = substitute(line, a:repl, printf(format, x), 'g')
            call append('$', [newline])
        endfor
        let x += 1
    endwhile
endfunction

nnoremap <F5> :GundoToggle<CR>

" S-arrows suck
vnoremap <S-Up> <Up>
inoremap <S-Up> <Up>
nnoremap <S-Up> <Up>
vnoremap <S-Down> <Down>
inoremap <S-Down> <Down>
nnoremap <S-Down> <Down>

" Indent fun
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

" Emacs-ish keybindings, oops
noremap! <M-Backspace> <C-W>
noremap! <M-Left> <C-Left>
noremap! <M-Right> <C-Right>
noremap! <C-A> <Home>
noremap! <C-E> <End>

" Annoying
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

nnoremap <silent> ]c ]c:call FindDiffOnLine()<CR>
nnoremap <silent> [c [c:call FindDiffOnLine()<CR>

" nnoremap <Leader>l :call CountLines()<CR>

" Window movements; I do this often enough to warrant using up M-arrows
nnoremap <M-Right> <C-W><Right>
nnoremap <M-Left> <C-W><Left>
nnoremap <M-Up> <C-W><Up><C-W>_
nnoremap <M-Down> <C-W><Down><C-W>_

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

" I used this to record all of my :w's over the course of a day, for fun
"cabbrev w <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'W' : 'w')<CR>
"command! -nargs=* W :execute("silent !echo " . strftime("%Y-%m-%d %H:%M:%S") . " >> ~/timestamps")|w <args>

" Cut all lines matching a pattern and move them to the end of the file
nnoremap <Leader>fg :execute 'g/'.input("Search term: > ").'/norm ddGp'<CR>

" Lining up code into columns using the nice Align plugin
let g:loaded_alignmaps=1
vnoremap <silent> <Leader>i" <ESC>:AlignPush<CR>:AlignCtrl lp0P0<CR>:'<,'>Align "<CR>:AlignPop<CR>
vnoremap <silent> <Leader>i= <ESC>:AlignPush<CR>:AlignCtrl lp1P1<CR>:'<,'>Align =<CR>:AlignPop<CR>
vnoremap <silent> <Leader>i, <ESC>:AlignPush<CR>:AlignCtrl lp0P1<CR>:'<,'>Align ,<CR>:AlignPop<CR>
vnoremap <silent> <Leader>i( <ESC>:AlignPush<CR>:AlignCtrl lp0P0<CR>:'<,'>Align (<CR>:AlignPop<CR>
vnoremap <silent> <Leader>i@ <ESC>:AlignPush<CR>:AlignCtrl lp0P0<CR>:'<,'>Align @<CR>:AlignPop<CR>

nnoremap <silent> <Leader>al vi(yo<ESC>p==:s/\</@/g<CR>A = <ESC>$p:nohls<CR>
nnoremap <Leader>"" :s/\v(^[^"]*)@<!"@<!""@!([^"]*$)@!/""/g<CR>
vnoremap <Leader>ra <ESC>:'<,'>s/\w\+/@\1 = \1/<CR>:set nohls<CR>

vnoremap <Leader>n 99<:'<,'>g/^$/d<CR>'<<C-V>'>I1 <ESC>'<<C-V>'>:I<CR>:'<,'>s/\v^(\d+) (.*)/    "\1": "\2"/<CR>'<V'>><ESC>'<O:opts:<ESC><<
nnoremap <Leader>n :s/\v^(\d+\S{-})\.\s+(.*)/      :number: "\1"\r      :text: "\2"/<CR>
nnoremap <Leader>t :s/\v\s*(\S+)\s*(.*)/  - :name: \1\r    :text: "\2"/<CR>\h

vnoremap <Leader>ii >'>oENDIF<ESC><<'<OIF THEN<ESC><<<Up>_yiw<Down>_wPa 

" Lines of strings => a paren-surrounded list of comma-separated strings on
" one line
nnoremap <Leader>ll gg_<C-v>G$A,ggVGJI($s)\h

" Delete blank lines
nnoremap <Leader>db :%g/^$/d<CR>\h

" Surround every line in the file with quotes
nnoremap <Leader>'' :%s/.*/'\0'<CR>:setlocal nohls<CR>
nnoremap <Leader>"" :%s/.*/"\0"<CR>:setlocal nohls<CR>

vnoremap <Leader>nn :s/.*/"1": "\0"/<CR>'<l<C-V>'>_l:I<CR>:nohls<CR>

function! ToggleNumber()
    if &nu
        set rnu
    else
        set nu
    endif
endfunction
nnoremap <silent> <leader>r :call ToggleNumber()<CR>

"nnoremap <Leader>rr :ruby x={}<CR>:rubydo x[$_] = true<CR>
"nnoremap <Leader>rt :rubydo $_ += ' ****' if x[$_]<CR>

vmap <Leader>y :s/^/    /<CR>gv"+ygv:s/^    //<CR>

" Nasty, I used these at work for something.  I forget why, but I may need them again
"nnoremap <silent> <Leader>al vi(yo<ESC>p==:s/\</@/g<CR>A = <ESC>$p:nohls<CR>
"nnoremap <Leader>"" :s/\v(^[^"]*)@<!"@<!""@!([^"]*$)@!/""/g<CR>
"vnoremap <Leader>ra <ESC>:'<,'>s/\w\+/@\1 = \1/<CR>:set nohls<CR>
"vnoremap <Leader>n 99<:'<,'>g/^$/d<CR>'<<C-V>'>I1 <ESC>'<<C-V>'>:I<CR>:'<,'>s/\v^(\d+) (.*)/    "\1": "\2"/<CR>'<V'>><ESC>'<O:opts:<ESC><<
"nnoremap <Leader>n :s/\v^(\d+\S{-})\.\s+(.*)/      :number: "\1"\r      :text: "\2"/<CR>
"nnoremap <Leader>t :s/\v\s*(\S+)\s*(.*)/  - :name: \1\r    :text: "\2"/<CR>\h

let g:loaded_AlignMapsPlugin = 1

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

" nmap ee :NERDTree<CR>
" let NERDChristmasTree=1

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

function! AppendSingleLetter()
    rubydo $_ = $_ + ('A'..'Z').to_a[rand(26)]
endfunction
