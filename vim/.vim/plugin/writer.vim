" __     ___            __        __    _ _
" \ \   / (_)_ __ ___   \ \      / / __(_) |_ ___ _ __
"  \ \ / /| | '_ ` _ \   \ \ /\ / / '__| | __/ _ \ '__|
"   \ V / | | | | | | |   \ V  V /| |  | | ||  __/ |
"    \_/  |_|_| |_| |_|    \_/\_/ |_|  |_|\__\___|_|
"
" Simple functions to easy your life while writing in Vim.




if exists("g:writer") | finish | endif
let g:writer = 1


" NoteVI{{{
function! s:NoteVI()
    let l:pathFile    = expand('%:p')
    let l:pathParent  = expand('%:p:h')
    let l:pathNoteVI  = l:pathParent . '/notevi'

    let $FILE   = fnamemodify(l:pathFile, ':p')
    let $PARENT = fnamemodify(l:pathParent, ':p')
    let $PREFIX = fnamemodify(l:pathParent, ':t')
    let $NOTEVI = fnamemodify(l:pathNoteVI, ':p')

    if !isdirectory($NOTEVI)
        !cp -R $HOME/.vim/plugin/notevi $PARENT
    endif
    !$NOTEVI/assets/makenote %:t:r
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
    endif
endfunction
"}}}


" ToggleAccent{{{
function! s:ToggleAccent()
    let accentNone  = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
    let accentGrave = ['à', 'è', 'ì', 'ò', 'ù', 'À', 'È', 'Ì', 'Ò', 'Ù']
    let accentAcute = ['á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú']

    let character = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let positionNone  = match(accentNone, character)
    let positionGrave = match(accentGrave, character)
    let positionAcute = match(accentAcute, character)

    if positionNone != -1
        execute ':normal! r' . accentGrave[positionNone]
    endif
    if positionGrave != -1
        execute ':normal! r' . accentAcute[positionGrave]
    endif
    if positionAcute != -1
        execute ':normal! r' . accentNone[positionAcute]
    endif
endfunction
"}}}


augroup AutoWriteScratchBuffer
    autocmd! TextChanged,TextChangedI /tmp/scratchbuffer silent write
augroup END


command! NoteVI call <SID>NoteVI()
command! ScratchBuffer call <SID>ScratchBuffer()
command! ToggleAccent call <SID>ToggleAccent()

nnoremap <localleader>\ :ScratchBuffer<CR>
nnoremap <silent>' :ToggleAccent<CR>
