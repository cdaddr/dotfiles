" Color palette
let s:cterm_blue = 110
let s:cterm_dark_gray = 236
let s:cterm_green = 150
let s:cterm_light_gray = 249
let s:cterm_med_gray_hi = 238
let s:cterm_med_gray_lo = 237
let s:cterm_orange = 179
let s:cterm_pink = 182
let s:cterm_purple = 146
let s:cterm_red = 174
let s:gui_white = '#FFFFFF'
let s:gui_black = '#000000'
let s:gui_blue = '#5fcde4'
let s:gui_blue2 = '#5b6ee1'
let s:gui_green = '#4b692f'
let s:gui_green2 = '#99e550'
let s:gui_light_gray = '#9badb7'
let s:gui_dark_gray = '#000000'
let s:gui_gray = '#060509'
let s:gui_orange = '#df7126'
let s:gui_orange2 = '#8f563b'
let s:gui_light_orange = '#d9a066'
let s:gui_pink = '#d77bba'
let s:gui_pink2 = '#d95763'
let s:gui_purple = '#76428a'
let s:gui_purple2 = '#45283c'
let s:gui_red = '#d95763'
let s:gui_red2 = '#ac3232'
let s:gui_maroon = '#663931'

let g:airline#themes#db32#palette = {}
let g:airline#themes#db32#palette.accents = {
      \ 'red': [ s:gui_red2, '' , 231 , '' , '' ],
      \ }

" Normal mode
let s:N1 = [s:gui_black, s:gui_red2, s:cterm_dark_gray, s:cterm_green]
let s:N2 = [s:gui_black, s:gui_orange, s:cterm_light_gray, s:cterm_med_gray_lo]
let s:N3 = [s:gui_white, s:gui_dark_gray, s:cterm_green, s:cterm_med_gray_hi]
let g:airline#themes#db32#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#db32#palette.normal_modified = {
      \ 'airline_c': [s:gui_orange, s:gui_dark_gray, s:cterm_orange, s:cterm_med_gray_hi, ''],
      \ }

" Insert mode
let s:I1 = [s:gui_dark_gray, s:gui_blue2, s:cterm_med_gray_hi, s:cterm_blue]
let s:I2 = [s:gui_dark_gray, s:gui_blue, s:cterm_med_gray_hi, s:cterm_blue]
let s:I3 = [s:gui_blue, s:gui_dark_gray, s:cterm_blue, s:cterm_med_gray_hi]
let g:airline#themes#db32#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#db32#palette.insert_modified = copy(g:airline#themes#db32#palette.normal_modified)
let g:airline#themes#db32#palette.insert_paste = {
      \ 'airline_a': [s:gui_dark_gray, s:gui_orange, s:cterm_dark_gray, s:cterm_orange, ''],
      \ }

" Replace mode
let g:airline#themes#db32#palette.replace = {
      \ 'airline_a': [s:gui_dark_gray, s:gui_red2, s:cterm_dark_gray, s:cterm_red, ''],
      \ 'airline_b': [s:gui_dark_gray, s:gui_red, s:cterm_dark_gray, s:cterm_red, ''],
      \ 'airline_c': [s:gui_red, s:gui_dark_gray, s:cterm_red, s:cterm_med_gray_hi, ''],
      \ }
let g:airline#themes#db32#palette.replace_modified = copy(g:airline#themes#db32#palette.insert_modified)

" Visual mode
let s:V1 = [s:gui_dark_gray, s:gui_purple, s:cterm_dark_gray, s:cterm_pink]
let s:V2 = [s:gui_dark_gray, s:gui_pink, s:cterm_dark_gray, s:cterm_pink]
let s:V3 = [s:gui_pink, s:gui_dark_gray, s:cterm_pink, s:cterm_med_gray_hi]
let g:airline#themes#db32#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#db32#palette.visual_modified = copy(g:airline#themes#db32#palette.insert_modified)

" Inactive window
let s:IA = [s:gui_light_gray, s:gui_gray, s:cterm_light_gray, s:cterm_med_gray_hi, '']
let g:airline#themes#db32#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#db32#palette.inactive_modified = {
      \ 'airline_c': [s:gui_orange, '', s:cterm_orange, '', ''],
      \ }

let g:airline#themes#db32#palette.tabline = {
      \ 'airline_tab':  [s:gui_black, s:gui_orange,  231, 29, ''],
      \ 'airline_tabsel':  [s:gui_black, s:gui_red2,  231, 36, 'bold'],
      \ 'airline_tablabel': [s:gui_white, s:gui_black,  231, 36, ''],
      \ 'airline_tabfill':  ['#ffffff', s:gui_dark_gray,  231, 23, ''],
      \ 'airline_tabmod':  [s:gui_black, s:gui_red2,  231, 88, 'bold'],
      \ 'airline_tabmod_unsel':  [s:gui_black, s:gui_red2,  231, 88, 'bold'],
      \ 'airline_tab_right':  [s:gui_black, s:gui_orange,  231, 29, ''],
      \ 'airline_tabsel_right':  [s:gui_black, s:gui_red2,  231, 36, 'bold'],
      \ 'airline_tablabel_right': [s:gui_white, s:gui_black,  231, 36, ''],
      \ 'airline_tabfill_right':  ['#ffffff', s:gui_dark_gray,  231, 23, ''],
      \ 'airline_tabmod_right':  [s:gui_black, s:gui_red2,  231, 88, 'bold'],
      \ 'airline_tabmod_unsel_right':  [s:gui_black, s:gui_red2,  231, 88, 'bold'],
      \ }

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#db32#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ s:gui_orange, s:gui_dark_gray, s:cterm_orange, s:cterm_med_gray_hi, '' ] ,
      \ [ s:gui_orange, s:gui_dark_gray, s:cterm_orange, s:cterm_med_gray_lo, '' ] ,
      \ [ s:gui_dark_gray, s:gui_green, s:cterm_dark_gray, s:cterm_green, 'bold' ] )

