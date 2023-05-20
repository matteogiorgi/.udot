"
"                              Simple plugin configuration
"                   [ Pandoc, Surround, Repeat, Commentary, Copilot ]
"




" Vim-pandoc {{{
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#spell#enabled = 0
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




" Copilot {{{
if v:version >= 900 || has('nvim')
    function! s:Pilot()
        let g:copilot = !exists('g:copilot') ? 'disabled' : g:copilot
        if g:copilot ==? 'disabled'
            let g:copilot = 'enabled'
            exec 'Copilot enable'
            exec 'echohl Function | echomsg "Copilot enabled" | echohl None'
        else
            let g:copilot = 'disabled'
            exec 'Copilot disable'
            exec 'echohl Function | echomsg "Copilot disabled" | echohl None'
        endif
    endfunction

    command! Pilot call <SID>Pilot()
    imap <silent><C-O> <Plug>(copilot-suggest)
    imap <silent><C-H> <Plug>(copilot-dismiss)
    imap <silent><C-J> <Plug>(copilot-next)
    imap <silent><C-K> <Plug>(copilot-previous)
    imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")
endif
" }}}
