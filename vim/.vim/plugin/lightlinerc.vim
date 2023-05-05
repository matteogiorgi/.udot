"
"                                  LIGHTLINE
"                 [ https://github.com/itchyny/lightline.vim ]
"




" Functions {{{
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
" }}}




" Autogroups {{{
augroup formatgroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" }}}




" Variables {{{
let g:lightline = {
            \ 'colorscheme': 'powerline',
            \ 'active': {
            \     'left': [
            \         [ 'mode', 'paste' ],
            \         [ 'gitbranch', 'cocstatus', 'currentfunction' ],
            \         [ 'readonly', 'filename', 'modified' ]
            \     ],
            \     'right': [
            \         [ 'filetype' ],
            \         [ 'lineinfo' ],
            \         [ 'percent' ]
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
            \     'n': 'NOR',
            \     'i': 'INS',
            \     'R': 'REP',
            \     'v': 'VIS',
            \     'V': 'VSL',
            \     "\<C-v>": 'VSB',
            \     'c': 'CMD',
            \     's': 'SEL',
            \     'S': 'SLL',
            \     "\<C-s>": 'SLB',
            \     't': 'TER',
            \ }
      \ }
" }}}
