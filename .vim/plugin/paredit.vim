let g:MatchPairs = { '(': ')', '[': ']', '{': '}', '<': '>'}

function! CharacterAfterCursor()
    return getline(line('.'))[col('.') - 1]
endfunction

function! CharacterBeforeCursor()
    return getline(line('.'))[col('.') - 2]
endfunction

function! HasValue(d, x)
    for v in values(a:d)
        if v == a:x
            return 1
        endif
    endfor
    return 0
endfunction

function! MaybeInsert(cb)
    if has_key(g:MatchPairs, a:cb)
        return a:cb . g:MatchPairs[a:cb] . expand("\<Left>")
    else
        return ''
    endif
endfunction

function! MaybeBackspace()
    let c = CharacterBeforeCursor()

    if has_key(g:MatchPairs, c)
        let c2 = g:MatchPairs[c]
        if CharacterBeforeCursor() == c && CharacterAfterCursor() == c2
            return expand("\<Del>\<BS>")
        elseif CharacterBeforeCursor() == c2
            return expand("\<Left>")
        else
            return expand("\<BS>")
        endif
    elseif HasValue(g:MatchPairs, c)
        return expand("\<Left>")
    else
        return expand("\<BS>")
    endif
endfunction

function! MaybeDelete()
    let c = CharacterBeforeCursor()

    if has_key(g:MatchPairs, c)
        let c2 = g:MatchPairs[c]
        if CharacterBeforeCursor() == c && CharacterAfterCursor() == c2
            return expand("\<Del>\<BS>")
        elseif CharacterAfterCursor() == c || CharacterAfterCursor() == c2
            return expand("\<Right>")
        else
            return expand("\<Del>")
        endif
    elseif has_key(g:MatchPairs, CharacterAfterCursor()) || HasValue(g:MatchPairs, CharacterAfterCursor())
        return expand("\<Right>")
    else
        return expand("\<Del>")
    endif
endfunction

function! MaybeRightParen()
    let c2 = CharacterAfterCursor()
    if HasValue(g:MatchPairs, c2)
        return expand("\<Right>")
    else
        return ''
    endif
endfunction


"inoremap ( <C-r>=MaybeInsert('(')<CR>
"inoremap [ <C-r>=MaybeInsert('[')<CR>
"inoremap { <C-r>=MaybeInsert('{')<CR>
"inoremap < <C-r>=MaybeInsert('<')<CR>
"
"inoremap ) <C-r>=MaybeRightParen()<CR>
"inoremap ] <C-r>=MaybeRightParen()<CR>
"inoremap } <C-r>=MaybeRightParen()<CR>
"inoremap > <C-r>=MaybeRightParen()<CR>
"
"inoremap <Del> <C-r>=MaybeDelete()<CR>
"inoremap <BS> <C-r>=MaybeBackspace()<CR>

function! GetChar(coord)
    return strpart(getline(a:coord[0]), a:coord[1] - 1, 1)
endfunction

function! NextCharIgnoringWhitespace(lnum, cnum)
    let nl = a:lnum
    let nc = a:cnum
    while nl <= line('$')
        let last_col = col([nl, '$'])
        while nc < last_col
            let c = GetChar([nl, nc])
            if (match(c, '\s') == -1) && (match(c, '\S') != -1)
                return [nl, nc]
            else
                let nc += 1
            endif
        endwhile
        let nl += 1
        let nc = 0
    endwhile
    return
endfunction


function! NextCloseParen(lstart, cstart, ochar, cchar)
    let delim_count = 0
    let nl = a:lstart
    let nc = a:cstart
    while nl <= line('$')
        let last_col = col([nl, '$'])
        while nc <= last_col
            let c = GetChar([nl, nc])
            if c == a:cchar
               if delim_count == 0
                   return [nl, nc]
               else
                   let delim_count -= 1
               endif
            elseif c == a:ochar
                let delim_count += 1
            endif
            let nc += 1
        endwhile
        let nl += 1
        let nc = 0
    endwhile
    return
endfunction

function! RegexpCoord(coord)
    return '%' . a:coord[0] . 'l%' . a:coord[1] . 'c'
endfunction

function! ForwardSlurp(ochar, cchar)
    let pos = getpos('.')
    try
        let coord = NextCloseParen(line('.'), col('.'), a:ochar, a:cchar)
        if empty(coord)
            echohl WarningMsg
            echo "Error, can't find closing character!"
            echohl None
            return
        else
            let coord2 = NextCharIgnoringWhitespace(line('.'), col('.')+1)
            let c = GetChar(coord2)
            if c == '('
                let coord3 = NextCloseParen(coord2[0], coord2[1], a:ochar, a:cchar)
                exe ':s/\v' . RegexpCoord(coord) . '(.)(\_s*)' . RegexpCoord(coord2) . '(\_.+)' . RegexpCoord(coord3) . '/\2\3\1/'
            else
                exe ':%s/\v' . RegexpCoord(coord) . '(.)(\_s+)(\w+)/\2\3\1/'
            endif
        endif
    finally
        exe 'norm =ap'
        call setpos('.', pos)
        return ''
    endtry
endfunction

function! ForwardBarf(ochar, cchar)
    let pos = getpos('.')
    try
        let coord = NextCloseParen(line('.'), col('.'), a:ochar, a:cchar)
        if empty(coord)
            echohl WarningMsg
            echo "Error, can't find closing character!"
            echohl None
            return
        else
            let coord2 = NextCharIgnoringWhitespace(line('.'), col('.')+1)
            let c = GetChar(coord2)
            if c == '('
                let coord3 = NextCloseParen(coord2[0], coord2[1], a:ochar, a:cchar)
                "exe ':s/\v' . RegexpCoord(coord) . '(.)(\_s*)' . RegexpCoord(coord2) . '(\_.+)' . RegexpCoord(coord3) . '/\2\3\1/'
            else
                exe ':%s/\v(\_s+)(\w+)' . RegexpCoord(coord) . '(.)/\3\1\2/'
            endif
        endif
    finally
        exe 'norm =ap'
        call setpos('.', pos)
        return ''
    endtry
endfunction


"imap <C-Right> <C-r>=ForwardSlurp('(', ')')<CR>
"imap <C-Left> <C-r>=ForwardBarf('(', ')')<CR>
