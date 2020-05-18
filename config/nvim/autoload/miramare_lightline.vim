function! miramare_lightline#load()
    let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'command': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

    let s:black = [ '#231f22', 235 ]
    let s:grey = [ '#242021', 240 ]
    let s:darkgrey = [ '#1c1a1a', 236 ]
    let s:white = [ '#e6d6ac', 223 ]
    let s:golden = [ '#d8caac', 223 ]
    let s:green = [ '#a7c080', 142 ]
    let s:blue = [ '#89beba', 109 ]
    let s:red = [ '#e68183', 167 ]
    let s:bg_red = ['#392f32',   '52']
    let s:orange = [ '#e39b7b', 208 ]
    let s:purple = ['#d3a0bc',   '175']
    let s:light_grey = ['#5b5b5b', '245']

    let s:p.normal.left = [ [ s:black, s:blue ], [ s:golden, s:darkgrey ] ]
    let s:p.normal.middle = [ [ s:light_grey, s:darkgrey ] ]
    let s:p.normal.right = [ [ s:golden, s:darkgrey ], [ s:golden, s:darkgrey ], [ s:golden, s:darkgrey ] ]
    let s:p.normal.warning = [ [ s:black, s:orange ] ]
    let s:p.normal.error = [ [ s:black, s:red ] ]

    let s:p.inactive.left =  [ [ s:light_grey, s:grey ], [ s:light_grey, s:grey ] ]
    let s:p.inactive.middle = [ [ s:light_grey, s:grey ] ]
    let s:p.inactive.right = [ [ s:light_grey, s:grey ], [ s:light_grey, s:grey ] ]

    let s:p.insert.left = [ [ s:black, s:orange ], [ s:white, s:black ] ]
    let s:p.command.left = [ [ s:black, s:orange ], [ s:white, s:black ] ]
    let s:p.replace.left = [ [ s:black, s:red ], [ s:white, s:black ] ]
    let s:p.visual.left = [ [ s:black, s:green ], [ s:white, s:black ] ]

    let s:p.tabline.left = [ [ s:white, s:darkgrey ] ]
    let s:p.tabline.middle = [ [ s:white, s:darkgrey ] ]
    let s:p.tabline.right = [ [ s:white, s:darkgrey ] ]
    let s:p.tabline.tabsel = [ [ s:black, s:blue ] ]

    let g:lightline#colorscheme#miramare#palette = lightline#colorscheme#flatten(s:p)
endfunction
