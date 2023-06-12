setlocal wrap nospell
setlocal conceallevel=2


nmap <buffer> <leader>i <Plug>(NoteWiki)
nmap <buffer> <leader>o <Plug>(NoteOpen)
nmap <buffer> <leader>p <Plug>(NotePandoc)<cr>
nmap <buffer> <leader><Backspace> :echo "No map in here."<cr>

nmap <buffer> <tab> <Plug>(NextLink)
nmap <buffer> <S-tab> <Plug>(PrevLink)
nmap <buffer> <backspace> <Plug>(Back)
nmap <buffer> <return> <Plug>(OpenLink)

nnoremap <buffer> - :HeaderIncrease<cr>
nnoremap <buffer> _ :HeaderDecrease<cr>

noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
