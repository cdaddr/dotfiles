let s:zetdir = expand('~/zettelkasten/')

function! zet#new(...)
    exec 'cd ' . s:zetdir

    if len(a:000) == 0
        return
    endif

    let l:filename = s:zetdir . strftime('%Y%m%dT%H%M%S') . ' ' . join(a:000, ' ') . '.md'
    exec 'e ' . l:filename
    exec "silent! norm! ggO#" . join(a:000, ' ') . "\<cr>\<esc>G"
endfunction


function s:linkto(filename)
    call setpos('.', [0, line('$'), 0, 0])
    silent! norm! ?^[[?
    call append(line('.'), '[[' . a:filename . ']]')
endfunction

function! zet#link(otherfile)
    exec 'cd ' . s:zetdir
    let l:thisfile = expand('%')
    if l:thisfile == a:otherfile
        echoerr "Can't link a file to itself"
    endif

    call s:linkto(a:otherfile)
    exec 'split ' . a:otherfile
    call s:linkto(l:thisfile)
endfunction

