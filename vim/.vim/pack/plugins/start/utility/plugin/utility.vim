" Load Mkdir
if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()


command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! ChBackground call utility#ChBackground()
command! -nargs=1 -complete=file SaveSession call utility#SaveSession(<f-args>)
command! -nargs=1 -complete=file LoadSession call utility#LoadSession(<f-args>)
command! -nargs=1 SSelection call utility#SSelection(<f-args>)
command! Current call utility#Current()
command! Parent call utility#Parent()
command! GitDir call utility#GitDir()
command! Delete call utility#Delete()
command! -nargs=* -complete=file -bang Rename call utility#Rename(<q-args>, '<bang>')


nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>^ :ChBackground<CR>


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
