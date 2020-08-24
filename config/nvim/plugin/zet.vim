command! -nargs=* Zet call zet#new(<f-args>)
command! -complete=file -nargs=1 ZetLink call zet#link(<f-args>)
