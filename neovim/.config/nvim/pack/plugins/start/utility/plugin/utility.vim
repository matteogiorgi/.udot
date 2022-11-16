if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()


command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! ChBackground call utility#ChBackground()()
command! ReplaceSearch call utility#ReplaceSearch()
command! JumpCurrentDir call utility#JumpCurrentDir()
command! JumpParentDir call utility#JumpParentDir()
command! JumpGitDir call utility#JumpGitDir()
command! Delete call utility#Delete()
command! -bang Rename call utility#Rename('<bang>')


nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>^ :ChBackground<CR>
nnoremap <leader>x :JumpGitDir<CR>
nnoremap <leader>z :JumpParentDir<CR>
nnoremap <leader>Z :JumpCurrentDir<CR>

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
