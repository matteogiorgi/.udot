" notewiki-plugin location
if !exists('$plugged')
    let $plugged = 'packed'
endif
"}}}


" NotePandoc{{{
function! s:NotePandoc() abort
    let l:prefix = expand('%:p:h')
    let l:currfile = expand('%:p')

    let $prefix = fnamemodify(l:prefix, ':p')
    let $prefixtail = fnamemodify(l:prefix, ':t')
    let $currfile = fnamemodify(l:currfile, ':p')

	if &filetype ==? 'markdown' || &filetype ==? 'markdown.pandoc' || &filetype ==? 'pandoc'
        let l:pandoc = l:prefix . '/pandoc'
        let $pandoc = fnamemodify(l:pandoc, ':p')
        if !isdirectory($pandoc)
            !cp -R $HOME/.vim/$plugged/notewiki/pandoc $prefix
        endif
        !$pandoc/assets/makenote %:t:r
    else
        echomsg 'I need an md file!'
    endif
endfunction
"}}}


" Commands{{{
nnoremap <silent> <Plug>(NotePandoc) :call <SID>NotePandoc()<cr>
"}}}
