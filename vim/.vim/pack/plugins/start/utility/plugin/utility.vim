if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()


" REMAINDER FOR THE BLOCKHEADS:
" one argument command    -> -nargs=1
" multi argument command  -> -nargs=*
" file-completion command -> -complete=file
" override command (!)    -> -bang
" function arguments      -> <f-args>
" quoted arguments        -> <q-args>

command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! ChBackground call utility#ChBackground()
command! SaveSession call utility#SaveSession()
command! LoadSession call utility#LoadSession()
command! ReplaceSelection call utility#ReplaceSelection()
command! CurrentDir call utility#CurrentDir()
command! ParentDir call utility#ParentDir()
command! GitDir call utility#GitDir()
command! Delete call utility#Delete()
command! -bang Rename call utility#Rename('<bang>')


nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>^ :ChBackground<CR>
nnoremap <leader>i :GitDir<CR>
nnoremap <leader>d :ParentDir<CR>
nnoremap <leader>D :CurrentDir<CR>
nnoremap <leader>p :echon 'CWD: '.getcwd()<CR>

nnoremap <leader>0 0gt
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
