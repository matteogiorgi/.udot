" open in current/path directory
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
" :F
" :F path


" open fff on press of 'f'
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
" nnoremap f :F<CR>


" split size/orientation
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
" let g:fff#split = "10new"
" let g:fff#split = "30vnew"


" split direction
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
" let g:fff#split_direction = "splitbelow splitright"
" let g:fff#split_direction = "nosplitbelow nosplitright"




if exists('g:loaded_fff')
    finish
endif

let g:loaded_fff = 1
let g:fff#split = "30vnew"  " 10new
let g:fff#split_direction = "nosplitbelow nosplitright"
 
command! -nargs=* -complete=dir F call fff#Run(<q-args>)
