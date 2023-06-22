" UTILITY
" -------

" List of utility function to simplify
" your vimmer life.




if exists("g:loaded_utility") | finish | endif
let g:loaded_utility = 1


" Jump current directory{{{
function! s:JumpCurrentDir()
    echon 'CWD: '
    cd %:p:h
    echon getcwd()
endfunction
"}}}


" Jump parent directory{{{
function! s:JumpParentDir()
    if getcwd() ==? $HOME
        echon 'No more jumping -- CWD: ' . getcwd()
        return
    endif

    echon 'CWD: '
    let l:parent = fnamemodify('getcwd()', ':p:h:h')
    execute 'cd ' . l:parent
    echon getcwd()
endfunction
"}}}


" Jump git directory{{{
function! s:JumpGitDir()
    if getcwd() ==? $HOME
        echon 'Not in git repository -- CWD: ' . getcwd()
        return
    endif

    if isdirectory('.git')
        echon 'CWD: ' . getcwd()
        return
    else
        let l:parent = fnamemodify('getcwd()', ':p:h:h')
        execute 'cd ' . l:parent
        execute 'call s:JumpGitDir()'
    endif
endfunction
"}}}


" Scratch buffer{{{
function s:ScratchBuffer()
    execute 'tabnew '
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal filetype=text
endfunction
"}}}


" ToggleAccent{{{
function! s:ToggleAccent()
    let withAccentGrave = ['à', 'è', 'ì', 'ò', 'ù', 'À', 'È', 'Ì', 'Ò', 'Ù']
    let withAccentAcute = ['á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú']
    let withNoAccent    = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
    let character = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let positionG = match(withAccentGrave, character)
    let positionA = match(withAccentAcute, character)
    let positionN = match(withNoAccent, character)
    if positionN != -1
        execute ':normal! r' . withAccentGrave[positionN]
    endif
    if positionG != -1
        execute ':normal! r' . withAccentAcute[positionG]
    endif
    if positionA != -1
        execute ':normal! r' . withNoAccent[positionA]
    endif
endfunction
"}}}


" ToggleUndoTree {{{
function! s:ToggleUT()
    if &filetype ==? 'netrw' || &filetype ==? '' | return | endif
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

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1
" }}}


command! JumpCurrentDir call <SID>JumpCurrentDir()
command! JumpParentDir call <SID>JumpParentDir()
command! JumpGitDir call <SID>JumpGitDir()
command! ScratchBuffer call <SID>ScratchBuffer()
command! ToggleAccent call <SID>ToggleAccent()
command! ToggleUndoTree call <SID>ToggleUT()

nnoremap <silent><CR> :JumpCurrentDir<CR>
nnoremap <silent><Backspace> :JumpParentDir<CR>
nnoremap <leader><Backspace> :JumpGitDir<CR>
nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>U :ToggleUndoTree<CR>
