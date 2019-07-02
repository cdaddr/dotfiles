" Vim color scheme - db32.vim
"
" Author: Brian Carper <brian@carper.ca>
" https://github.com/cdaddr/db32.vim
"
" This is based on Dawnbringer's DB32 color palette from:
"   http://pixeljoint.com/forum/forum_posts.asp?TID=16247_
"
" #08080d #222034 #45283c #663931 #8f563b #df7126 #d9a066 #eec39a
" #fbf236 #99e550 #6abe30 #37946e #4b692f #524b24 #323c39 #3f3f74
" #306082 #5b6ee1 #639bff #5fcde4 #cbdbfc #f3f3f3 #9badb7 #847e87
" #696a6a #595652 #76428a #ac3232 #d95763 #d77bba #8f974a #8a6f30

hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="db32"

" Main
hi Normal         ctermfg=249 ctermbg=235 cterm=none guifg=#aaaaaa guibg=#11101a gui=none
hi Comment        ctermfg=244 ctermbg=235 cterm=none guifg=#595652 guibg=#11101a gui=italic

" Constant
hi Constant       ctermfg=186 ctermbg=235 cterm=none guifg=#76428a guibg=#11101a gui=none
hi String         ctermfg=187 ctermbg=235 cterm=none guifg=#8f563b guibg=#11101a gui=none
hi Character      ctermfg=187 ctermbg=235 cterm=none guifg=#f3f3f3 guibg=#191826 gui=none
hi Boolean        ctermfg=187 ctermbg=235 cterm=none guifg=#d77bba guibg=#11101a gui=bold
hi Number         ctermfg=180 ctermbg=235 cterm=none guifg=#d77bba guibg=#11101a gui=none
hi Float          ctermfg=180 ctermbg=235 cterm=none guifg=#d77bba guibg=#11101a gui=none

" Variable Name
hi Identifier     ctermfg=182 ctermbg=235 cterm=none guifg=#5fcde4 guibg=#11101a gui=none
hi Function       ctermfg=182 ctermbg=235 cterm=none guifg=#639bff guibg=#11101a gui=none

" Statement
hi Statement      ctermfg=110 ctermbg=235 cterm=none guifg=#ac3232 guibg=#11101a gui=none
hi Conditional    ctermfg=110 ctermbg=235 cterm=none guifg=#d95763 guibg=#11101a gui=italic
hi Repeat         ctermfg=110 ctermbg=235 cterm=none guifg=#d77bba guibg=#11101a gui=none
hi Label          ctermfg=110 ctermbg=235 cterm=none guifg=#d77bba guibg=#11101a gui=none
hi Operator       ctermfg=110 ctermbg=235 cterm=none guifg=#5b6ee1 guibg=#11101a gui=none
hi Keyword        ctermfg=110 ctermbg=235 cterm=none guifg=#d9a066 guibg=#11101a gui=none
hi Exception      ctermfg=110 ctermbg=235 cterm=none guifg=#df7126 guibg=#11101a gui=none

" Preprocessor
hi PreProc        ctermfg=150 ctermbg=235 cterm=none guifg=#306082 guibg=#11101a gui=none
hi Include        ctermfg=150 ctermbg=235 cterm=none guifg=#639bff guibg=#11101a gui=none
hi PreCondit      ctermfg=150 ctermbg=235 cterm=none guifg=#99e550 guibg=#11101a gui=none
" hi Macro ctermfg=150 ctermbg=235 cterm=none guifg=#fbf236 guibg=#11101a gui=none

" Type
hi Type           ctermfg=146 ctermbg=235 cterm=none guifg=#37946e guibg=#11101a gui=none
hi StorageClass   ctermfg=146 ctermbg=235 cterm=none guifg=#37946e guibg=#11101a gui=none
hi Structure      ctermfg=146 ctermbg=235 cterm=none guifg=#6abe30 guibg=#11101a gui=none
hi Typedef        ctermfg=146 ctermbg=235 cterm=none guifg=#acff59 guibg=#11101a gui=none

" Special
hi Special        ctermfg=174 ctermbg=235 cterm=none guifg=#639bff guibg=#11101a gui=none
hi SpecialChar    ctermfg=174 ctermbg=235 cterm=none guifg=#eec39a guibg=#11101a gui=none
hi Tag            ctermfg=174 ctermbg=235 cterm=none guifg=#fbf236 guibg=#191826 gui=none
hi Delimiter      ctermfg=174 ctermbg=235 cterm=none guifg=#8f563b guibg=#11101a gui=none
hi SpecialComment ctermfg=174 ctermbg=235 cterm=none guifg=#f3f3f3 guibg=#ac3232 gui=none
hi Debug          ctermfg=174 ctermbg=235 cterm=none guifg=#f3f3f3 guibg=#11101a gui=none
hi Underlined     ctermfg=249 ctermbg=235 cterm=underline guifg=#639bff guibg=#11101a gui=underline
hi Ignore         ctermfg=235 ctermbg=235 cterm=none guifg=#11101a guibg=#08080d gui=none
hi Error          ctermfg=231 ctermbg=167 cterm=none guifg=#f3f3f3 guibg=#ac3232 gui=none
hi Todo           ctermfg=244 ctermbg=235 cterm=none guifg=#cbdbfc guibg=#11101a gui=bold,italic

" Window
hi StatusLine     ctermfg=249 ctermbg=237 cterm=none guifg=#847e87 guibg=#000000 gui=none
hi StatusLineNC   ctermfg=244 ctermbg=237 cterm=none guifg=#08080d guibg=#000000  gui=none
hi VertSplit      ctermfg=237 ctermbg=237 cterm=none guifg=#3A3A3A guibg=#11101a gui=none
hi TabLine        ctermfg=249 ctermbg=237 cterm=none guifg=#847e87 guibg=#000000 gui=none
hi TabLineSel     ctermfg=253 ctermbg=238 cterm=none guifg=#11101a guibg=#df7126 gui=none
hi TabLineFill    ctermfg=253 ctermbg=237 cterm=none guifg=#00ff00 guibg=#000000 gui=none

" Menu
hi Pmenu          ctermfg=249 ctermbg=237 cterm=none guifg=#847e87 guibg=#222034 gui=none
hi PmenuSel       ctermfg=231 ctermbg=244 cterm=none guifg=#f3f3f3 guibg=#222034 gui=none
hi PmenuSbar      ctermbg=59 cterm=none guibg=#222034 gui=none
hi PmenuThumb     ctermbg=246 cterm=none guibg=#847e87 gui=none
hi WildMenu       ctermfg=232 ctermbg=98 cterm=none guifg=#d9a066 guibg=#08080d gui=none

" Selection
hi Visual         ctermfg=235 ctermbg=117 cterm=none guifg=#11101a guibg=#df7126 gui=none
hi VisualNOS      ctermfg=235 ctermbg=80 cterm=none guifg=#11101a guibg=#5FD7D7 gui=none

" Message
hi ErrorMsg       ctermfg=210 ctermbg=235 cterm=none guifg=#ac3232 guibg=#11101a gui=none
hi WarningMsg     ctermfg=140 ctermbg=235 cterm=none guifg=#ac3232 guibg=#11101a gui=none
hi MoreMsg        ctermfg=72 ctermbg=235 cterm=none guifg=#37946e guibg=#11101a gui=none
hi ModeMsg        ctermfg=222 ctermbg=235 cterm=bold guifg=#37946e guibg=#11101a gui=bold
hi Question       ctermfg=38 ctermbg=235 cterm=none guifg=#df7126 guibg=#11101a gui=none

" Mark
hi Folded         ctermfg=244 ctermbg=235 cterm=none guifg=#d9a066 guibg=#08080d gui=none
hi FoldColumn     ctermfg=79 ctermbg=237 cterm=none guifg=#d9a066 guibg=#08080d gui=none
hi SignColumn     ctermfg=184 ctermbg=237 cterm=none guifg=#d9a066 guibg=#08080d gui=none
hi ColorColumn    ctermbg=237 cterm=none guibg=#08080d gui=none
hi LineNr         ctermfg=244 ctermbg=237 cterm=none guifg=#847e87 guibg=#08080d gui=none
hi MatchParen     ctermfg=16 ctermbg=215 cterm=none guifg=#11101a guibg=#df7126 gui=none

" Search
hi Search         ctermfg=16 ctermbg=179 cterm=none guifg=#000000 guibg=#fbf236 gui=bold
hi IncSearch      ctermfg=231 ctermbg=168 cterm=none guifg=#000000 guibg=#aaaa00 gui=none

" Diff Mode
hi DiffAdd        ctermfg=16 ctermbg=149 cterm=none guifg=#08080d guibg=#4b692f gui=none
hi DiffChange     ctermfg=16 ctermbg=217 cterm=none guifg=#08080d guibg=#306082 gui=none
hi DiffText       ctermfg=16 ctermbg=211 cterm=bold guifg=#08080d guibg=#df7126 gui=italic
hi DiffDelete     ctermfg=16 ctermbg=249 cterm=none guifg=#08080d guibg=#ac3232 gui=none

" Spell
hi SpellBad       ctermfg=210 ctermbg=235 cterm=underline guibg=#11101a gui=undercurl guisp=#ac3232
hi SpellCap       ctermfg=174 ctermbg=235 cterm=underline guibg=#11101a gui=undercurl guisp=#5fcde4
hi SpellRare      ctermfg=181 ctermbg=235 cterm=underline guibg=#11101a gui=undercurl guisp=#76428a
hi SpellLocal     ctermfg=180 ctermbg=235 cterm=underline guibg=#11101a gui=undercurl guisp=#76428a

" Misc
hi SpecialKey     ctermfg=114 ctermbg=235 cterm=none guifg=#212826 guibg=#11101a gui=none
hi NonText        ctermfg=244 ctermbg=235 cterm=none guifg=#212826 guibg=#11101a gui=none
hi Directory      ctermfg=103 ctermbg=235 cterm=none guifg=#df7126 guibg=#11101a gui=none
hi Title          ctermfg=109 cterm=none guifg=#ac3232 gui=none
hi Conceal        ctermfg=77 ctermbg=235 cterm=none guifg=#5FD75F guibg=#11101a gui=none

" Cursor
hi CursorColumn   ctermbg=237 cterm=none guibg=#000000 gui=none
hi CursorLine     ctermbg=237 cterm=none guibg=#08080d gui=none
hi CursorLineNr   ctermfg=249 ctermbg=237 cterm=none guifg=#f3f3f3 guibg=#08080d gui=none

hi Cursor         guifg=#08080d guibg=#99e550
hi User1          guifg=#fff000
hi User2          guifg=#fff000

" hi rubyInterpolation guifg=#11101a
hi rubyStringEscape guifg=#df7126 guibg=#222034 gui=italic
hi rubyInterpolationDelimiter guifg=#8f563b guibg=#191826

hi htmlTagName ctermfg=174 ctermbg=235 cterm=none guifg=#639bff guibg=#11101a gui=none

hi link vimHiKeyList Operator

" for Plugin 'luochen1990/rainbow'
let g:rainbow_conf = {
            \ 'guifgs': ['#ac3232', '#8f563b', '#8f974a', '#4b692f', '#5fcde4', '#76428a']
            \}
