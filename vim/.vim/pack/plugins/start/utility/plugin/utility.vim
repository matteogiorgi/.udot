" Load Mkdir
if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()


command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! ChBackground call utility#ChBackground()
command! -nargs=1 -complete=file SaveSession call utility#SaveSession(<f-args>)
command! -nargs=1 -complete=file LoadSession call utility#LoadSession(<f-args>)
command! -nargs=1 SSelection call utility#SSelection(<f-args>)
command! CurrentDir call utility#CurrentDir()
command! ParentDir call utility#ParentDir()
command! GitDir call utility#GitDir()
command! Delete call utility#Delete()
command! -nargs=* -complete=file -bang Rename call utility#Rename(<q-args>, '<bang>')


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


" I am already using ezwindow that does the same thing
" nnoremap <C-w>h :call utility#WinMove('h')<CR>
" nnoremap <C-w>j :call utility#WinMove('j')<CR>
" nnoremap <C-w>k :call utility#WinMove('k')<CR>
" nnoremap <C-w>l :call utility#WinMove('l')<CR>

" Alternative to Delete command:
" command! Delete :call delete(expand('%'))|Bclose

" Alternative to SSelection command:
" nnoremap <leader>s :%s///gc<Left><Left><Left>
" xnoremap <leader>s :s///gc<Left><Left><Left>
