" set cindent
" set cinoptions=+0

vmap <Leader>qo :s/\v^\s*([a-z0-9]+)\s*[-.]*[ \t=]+(.*)/    \1 = "\2"/<CR>\hgv_<C-V>o_:II 1 0<CR>
vmap <Leader>qm :s/\v^\s*(\w+)\.?\s+(.*)/multi \1 "\2" {/<CR>\h
nmap <Leader>qm V<space>qm
vmap <Leader>qn :s/\v^\s*(\w+)\.?\s+(.*)/num \1 "\2" {/<CR>\h
nmap <Leader>qn V\n
vmap <Leader>ql :s/^\v\s*(\s+_*)*(.{-})\s*$/    label: "\2"/<CR>\h
nmap <Leader>ql V\l
nmap <Leader>q} o}<ESC>
