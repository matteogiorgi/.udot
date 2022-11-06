" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
" Licensed under CC-BY-SA

if v:version < 700 || exists('loaded_bclose') || &cp | finish | endif
if !exists('bclose_multiple') | let bclose_multiple = 1 | endif
let loaded_bclose = 1


" Display an error message.
function! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
endfunction


command! -bang -complete=buffer -nargs=? Bclose call bclose#Bclose('<bang>', '<args>')


nnoremap <leader>k :close<CR>
nnoremap <leader>K :Bclose<CR>
