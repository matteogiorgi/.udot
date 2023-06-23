" __     ___             _   _      _
" \ \   / (_)_ __ ___   | \ | | ___| |_ _ ____      __
"  \ \ / /| | '_ ` _ \  |  \| |/ _ \ __| '__\ \ /\ / /
"   \ V / | | | | | | | | |\  |  __/ |_| |   \ V  V /
"    \_/  |_|_| |_| |_| |_| \_|\___|\__|_|    \_/\_/
"
" Vim file-navigation tree configuration variables.




let g:netrw_banner = 0
let g:netrw_keepdir = 0
let g:netrw_liststyle = 4
let g:netrw_sort_options = 'i'
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_browsex_viewer = 'xdg-open'
let g:ghregex = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide = g:ghregex
let g:netrw_preview = 0
let g:netrw_alto = 1
let g:netrw_altv = 0


highlight! default link netrwMarkFile Search
