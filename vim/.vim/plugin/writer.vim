" __     ___            __        __    _ _
" \ \   / (_)_ __ ___   \ \      / / __(_) |_ ___ _ __
"  \ \ / /| | '_ ` _ \   \ \ /\ / / '__| | __/ _ \ '__|
"   \ V / | | | | | | |   \ V  V /| |  | | ||  __/ |
"    \_/  |_|_| |_| |_|    \_/\_/ |_|  |_|\__\___|_|
"
" Simple functions to easy your life while writing in Vim.




if exists("g:writer") | finish | endif
let g:writer = 1


" VimNote{{{
function! s:VimNote()
    let l:currfile = expand('%:p')
    let l:prefix = expand('%:p:h')
    let l:vimnote = l:prefix . '/vimnote'
    let $currfile = fnamemodify(l:currfile, ':p')
    let $prefix = fnamemodify(l:prefix, ':p')
    let $prefixtail = fnamemodify(l:prefix, ':t')
    let $vimnote = fnamemodify(l:vimnote, ':p')
    if !isdirectory($vimnote)
        !cp -R $HOME/.vim/plugin/vimnote $prefix
    endif
    !$vimnote/assets/makenote %:t:r
endfunction
"}}}


" ScratchBuffer{{{
function! s:ScratchBuffer()
    let target_buffer = bufnr('/tmp/scratchbuffer')
    let target_window = bufwinnr(target_buffer)
    if target_buffer != -1 && target_window != -1
        execute target_window . 'wincmd w'
    else
        execute 'edit /tmp/scratchbuffer'
        setlocal bufhidden=wipe
        setlocal nobuflisted
        setlocal noswapfile
        setlocal filetype=text
        nmap <buffer> <localleader>\ :echo "No map for LOCALLEADER+\\."<CR>
        nmap <buffer> <leader><space> :echo "No map for LEADER+SPACE."<CR>
        nmap <buffer> <silent><CR> :echo "No map for RETURN."<CR>
        nmap <buffer> <silent><Backspace> :echo "No map for BACKSPACE."<CR>
        nmap <buffer> <leader><Backspace> :echo "No map for LEADER+BACKSPACE."<CR>
    endif
endfunction
"}}}


" ToggleAccent{{{
function! s:ToggleAccent()
    let listNoAccent    = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
    let listAccentGrave = ['à', 'è', 'ì', 'ò', 'ù', 'À', 'È', 'Ì', 'Ò', 'Ù']
    let listAccentAcute = ['á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú']
    let character = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let positionNoAccent = match(listNoAccent, character)
    let positionAccentGrave = match(listAccentGrave, character)
    let positionAccentAcute = match(listAccentAcute, character)
    if positionNoAccent != -1
        execute ':normal! r' . listAccentGrave[positionNoAccent]
    endif
    if positionAccentGrave != -1
        execute ':normal! r' . listAccentAcute[positionAccentGrave]
    endif
    if positionAccentAcute != -1
        execute ':normal! r' . listNoAccent[positionAccentAcute]
    endif
endfunction
"}}}


augroup AutoWriteScratchBuffer
    autocmd! TextChanged,TextChangedI /tmp/scratchbuffer silent write
augroup END


command! VimNote call <SID>VimNote()
command! ScratchBuffer call <SID>ScratchBuffer()
command! ToggleAccent call <SID>ToggleAccent()

nnoremap <localleader>\ :ScratchBuffer<CR>
nnoremap <silent>' :ToggleAccent<CR>
