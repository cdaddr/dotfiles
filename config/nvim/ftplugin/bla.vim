vnoremap <Leader>ii >'>oENDIF<ESC><<'<OIF THEN<ESC><<<Up>_yiw<Down>_wPa 
nmap <Leader>p :!"c:\Program Files\StatNeth\Blaise 4.8 Enterprise\Bin\B4CPars.exe" %:t:r.bpf<CR><CR>
nmap <Leader>r :silent !RUNME.BAT<CR>
nmap <Leader>d :silent !del %:t:r.bdb<CR>

vmap <Leader>c I"<ESC>A" / "@YPress Enter to continue.": T_PressAnyKey<ESC>I

nmap <Leader>t :s/\v(\S+)\.?\s*(.*)/\1 "\2" / "Response:":<CR>:nohls<CR>

vmap <Leader>o <ESC>:'<,'>g/^$/d<CR>'<<C-V>'>I1 <ESC>'<<C-V>'>:I<CR>:'<,'>s:^\(\s*\)\(\d\+\) \(.*\):\1    C\2 (\2) "\3",:<CR>'<kA (<ESC>'>$s<CR>)<ESC><<

