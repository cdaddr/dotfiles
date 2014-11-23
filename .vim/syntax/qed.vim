if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax keyword QEDTypes include types questions rules page otherspecify scale multi string num label open if else
syntax region QEDString start=+"+ end=+"+
syntax region QEDComment start=+#+ end=+$+
hi link QEDTypes keyword
hi link QEDString string
hi link QEDComment comment

let b:current_syntax = "qed"
