if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax keyword QEDTypes include types questions rules page endpage otherspecify scale multi string num label open if else defaults
syntax region QEDString start=+#define+ end=+$+
syntax region QEDString start=+"+ end=+"+
syntax region QEDComment start=+#+ end=+$+
hi link QEDTypes keyword
hi link QEDString string
hi link QEDComment comment

let b:current_syntax = "qed"

function! RenumberPages()
    let i = 1
    g/\v^\s+(end)?page \zs\d+\s+\{/s//\=i.' {'/ | let i=i+1
endfunction

