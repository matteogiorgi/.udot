" Utility functions
" -----------------

" List of utility function to simplify your
" vimmer life.




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


" Replace{{{
function! s:ReplaceSearch()
    call inputsave()
    let l:replace = input('Replace searched pattern with: ', '', '')
    call inputrestore()
    if l:replace != ""
        exec '%s//'.l:replace.'/gc'
    else
        redraw
        echo 'No substitution done'
    endif
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


" WinMove{{{
function! s:WinMove(key)
    let t:curwin = winnr()
    exec 'wincmd '.a:key
    if t:curwin ==? winnr()
        if match(a:key,'[jk]')
            wincmd v
        else
            wincmd s
        endif
        exec 'wincmd '.a:key
    endif
    return bufname('%')
endfunction
"}}}


command! JumpCurrentDir call <SID>JumpCurrentDir()
command! JumpParentDir call <SID>JumpParentDir()
command! JumpGitDir call <SID>JumpGitDir()
command! ReplaceSearch call <SID>ReplaceSearch()
command! ToggleAccent call <SID>ToggleAccent()

nnoremap <silent>' :ToggleAccent<CR>
nnoremap <silent>\ :JumpGitDir<CR>
nnoremap <silent><Backspace> :JumpParentDir<CR>
nnoremap <silent><CR> :JumpCurrentDir<CR>

nnoremap <leader>w <C-w>
nnoremap <leader>wh :call <SID>WinMove('h')<CR>
nnoremap <leader>wj :call <SID>WinMove('j')<CR>
nnoremap <leader>wk :call <SID>WinMove('k')<CR>
nnoremap <leader>wl :call <SID>WinMove('l')<CR>
