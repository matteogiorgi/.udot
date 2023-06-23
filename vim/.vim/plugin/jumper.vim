" __     ___                 _
" \ \   / (_)_ __ ___       | |_   _ _ __ ___  _ __   ___ _ __
"  \ \ / /| | '_ ` _ \   _  | | | | | '_ ` _ \| '_ \ / _ \ '__|
"   \ V / | | | | | | | | |_| | |_| | | | | | | |_) |  __/ |
"    \_/  |_|_| |_| |_|  \___/ \__,_|_| |_| |_| .__/ \___|_|
"                                             |_|
"
" A simple utility to help you jump directories within Vim.




if exists("g:jumper") | finish | endif
let g:jumper = 1


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


command! JumpCurrentDir call <SID>JumpCurrentDir()
command! JumpParentDir call <SID>JumpParentDir()
command! JumpGitDir call <SID>JumpGitDir()

nnoremap <silent><CR> :JumpCurrentDir<CR>
nnoremap <silent><Backspace> :JumpParentDir<CR>
nnoremap <leader><Backspace> :JumpGitDir<CR>
