function! zet#new(...)
    let l:zetdir = expand('~/Sync/brisync/zettelkasten/')
    exec 'cd ' . l:zetdir

    if len(a:000) == 0
        return
    endif

    let l:filename = l:zetdir . strftime('%Y%m%dT%H%M%S') . '-' . join(a:000, '-') . '.md'
    exec 'e ' . l:filename
    exec "silent! norm ggO\<c-r>=strftime('%Y%m%dT%H%M%S')\<cr>\<cr>\<esc>GI# " . join(a:000, ' ') . "\<cr>\<cr>\<esc>"
endfunction
