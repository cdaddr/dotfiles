if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax keyword QEDTypes include types questions rules page endpage otherspecify scale multi string num label open if else defaults
syntax region QEDString start=+#define+ end=+$+ oneline keepend
syntax region QEDString start=+"+ end=+"+ keepend
" `\(define\)\@!` = a `#` not followed by `define`, so #define stays a string, not a comment
syntax region QEDComment start=+#\(define\)\@!+ end=+$+ oneline keepend
hi link QEDTypes keyword
hi link QEDString string
hi link QEDComment comment

" quoted strings can span lines, so redraws must back up to find an open quote;
" bound the lookback so mini.animate frames don't rescan to the top of the file.
" raise minlines if strings longer than this ever mis-highlight mid-scroll.
syntax sync minlines=40 maxlines=80

let b:current_syntax = "qed"

function! RenumberPages()
    let i = 1
    g/\v^\s+(end)?page \zs\d+\s+\{/s//\=i.' {'/ | let i=i+1
endfunction

