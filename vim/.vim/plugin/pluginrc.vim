" Vim-hy {{{
let g:hy_enable_conceal = 1
let g:hy_conceal_fancy = 1
" }}}




" Vim-pandoc {{{
let g:pandoc#syntax#conceal#urls = 1
" }}}




" Vim-surround {{{
let g:surround_{char2nr('o')} = "/*\r*/"
" }}}




" Vim-repeat {{{
nnoremap <silent> <Plug>TransposeCharacters xp
\:call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters
" }}}




" Vim-commentary {{{
nmap <silent><leader><space> gcc
vmap <silent><leader><space> gc

augroup personalcomments
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    autocmd FileType json,jsonc setlocal commentstring=//\ %s
    autocmd FileType toml setlocal commentstring=#\ %s
    autocmd FileType markdown,markdown.pandoc,pandoc setlocal commentstring=<!--\ %s\ -->
augroup end
" }}}




" Undootree {{{
let g:undotree_DiffAutoOpen = 1
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SplitWidth = 30
let g:undotree_DiffpanelHeight = 10
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_HelpLine = 0

function! s:ToggleUT()
    if &filetype ==? 'netrw' || &filetype ==? 'startscreen' || buffer_name() =~ 'term://*' || buffer_name() =~ '!bash' | return | endif
    if !exists('g:toggleUT') | let g:toggleUT = 0 | endif

    if g:toggleUT ==? 0
        let g:toggleUT = 1
        let g:tabn = tabpagenr()
        execute 'tabnew % | UndotreeShow'
    else
        let g:toggleUT = 0
        execute 'UndotreeHide | tabclose |  normal ' . g:tabn . 'gt'
    endif
endfunction

command! ToggleUT call <SID>ToggleUT()
nnoremap <leader>u :ToggleUT<CR>
" }}}
