" set cindent
" set cinoptions=+0

vmap <Leader>o :s/\v^\s*([a-z0-9]+)\s*[-.]*[ \t=]+(.*)/    \1 = "\2"/<CR>\hgv_<C-V>o_:II 1 0<CR>
vmap <Leader>m :s/\v^\s*(\w+)\.?\s+(.*)/multi \1 "\2" {/<CR>\h
nmap <Leader>m V\m
vmap <Leader>n :s/\v^\s*(\w+)\.?\s+(.*)/num \1 "\2" {/<CR>\h
nmap <Leader>n V\n
vmap <Leader>l :s/^\v\s*(\s+_*)*(.{-})\s*$/    label: "\2"/<CR>\h
nmap <Leader>l V\l
nmap <Leader>} o}<ESC>
nmap <Leader>p :s@.*@<p>\0</p>@g<CR>\h
vmap <Leader>p :s@.*@<p>\0</p>@g<CR>\h
vmap <Leader>h1 :s/.*/<h1>\0<\/h1>/<CR>\h
