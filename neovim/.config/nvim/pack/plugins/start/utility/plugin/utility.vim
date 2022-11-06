if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()


command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! ResetGruvbox call utility#ResetGruvbox()
command! ReplaceSearch call utility#ReplaceSearch()
command! JumpCurrentDir call utility#JumpCurrentDir()
command! JumpParentDir call utility#JumpParentDir()
command! JumpGitDir call utility#JumpGitDir()
command! Delete call utility#Delete()
command! -bang Rename call utility#Rename('<bang>')


nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>^ :ResetGruvbox<CR>
nnoremap <leader>o :JumpGitDir<CR>
nnoremap <leader>j :JumpParentDir<CR>
nnoremap <leader>J :JumpCurrentDir<CR>
