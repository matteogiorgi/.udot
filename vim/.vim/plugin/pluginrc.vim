" Lightline {{{
augroup formatgroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! LightlineGitbranch()
    let l:branchname = gitbranch#name()
    return toupper(l:branchname)
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightlineFilename()
    let l:bufname = expand('%')
    if l:bufname ==? '' | return '[No Name]' | endif
    if getcwd() ==? expand('%:p:h') | return l:bufname | endif
    return pathshorten(expand('%:p'))
endfunction

function! LightlineFiletype()
    return &filetype !=# '' ? &filetype : 'none'
endfunction

let g:lightline = {
            \ 'colorscheme': 'powerline',
            \ 'active': {
            \     'left': [
            \         [ 'mode', 'paste' ],
            \         [ 'gitbranch', 'cocstatus', 'currentfunction' ],
            \         [ 'readonly', 'filename', 'modified' ]
            \     ],
            \     'right': [
            \         ['filetype'],
            \         ['lineinfo'],
            \         ['percent']
            \     ],
            \ },
            \ 'component_function': {
            \     'gitbranch': 'LightlineGitbranch',
            \     'cocstatus': 'coc#status',
            \     'currentfunction': 'CocCurrentFunction',
            \     'filename': 'LightlineFilename',
            \     'filetype': 'LightlineFiletype'
            \ },
            \ 'mode_map': {
            \     'n': 'N',
            \     'i': 'I',
            \     'R': 'R',
            \     'v': 'V',
            \     'V': 'VL',
            \     "\<C-v>": 'VB',
            \     'c': 'C',
            \     's': 'S',
            \     'S': 'SL',
            \     "\<C-s>": 'SB',
            \     't': 'T',
            \ }
      \ }
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





" Copilot {{{
if has('nvim')
    function! CocPilot()
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
    nnoremap <leader>q :call CocPilot()<CR>
endif
" }}}
