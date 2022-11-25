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
command! SessionSave call utility#SessionSave()
command! SessionLoad call utility#SessionLoad()
command! ReplaceSearch call utility#ReplaceSearch()
command! JumpCurrentDir call utility#JumpCurrentDir()
command! JumpParentDir call utility#JumpParentDir()
command! JumpGitDir call utility#JumpGitDir()
command! Delete call utility#Delete()
command! -bang Rename call utility#Rename('<bang>')


" ALTERNATIVE TO REPLACESEARCH COMMAND:
" nnoremap <leader>s :%s///gc<Left><Left><Left>
" xnoremap <leader>s :s///gc<Left><Left><Left>

nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>^ :ChBackground<CR>
nnoremap <silent><CR> :JumpCurrentDir<CR>
nnoremap <silent><Backspace> :JumpParentDir<CR>
nnoremap <leader><Backspace> :JumpGitDir<CR>

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
