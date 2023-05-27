" Notewiki
" --------

" Note plugin system useful to create
" wiki-style notes.




let $wikipages = fnamemodify('~/notewiki', ':p')
let $pdfpages = fnamemodify('~/notewiki/pdf', ':p')
let $beamerpages = fnamemodify('~/notewiki/beamer', ':p')
let $htmlpages = fnamemodify('~/notewiki/html', ':p')

if !exists('g:noteopen')
    let g:noteopen = 'nohup xdg-open'
endif


if !isdirectory($wikipages)
    execute '!mkdir ' . $wikipages
endif


" CreateLink{{{
function s:CreateLink() abort
    let @z = ''
	execute 'normal ' . '"zyiw'
	if @z !=? ''
		execute 'normal ' . 'ciw[]()'
		execute 'normal ' . 'F[p'
		execute 'normal ' . 'f(p'
		execute 'normal ' . 'a.md'
		execute 'normal ' . 'F['
	endif
endfunction
"}}}

" NextLink{{{
function! s:NextLink() abort
    let link_regex = '\[[^]]*\]([^)]\+)'
    call search(link_regex)
endfunction
"}}}

" PrevLink{{{
function! s:PrevLink() abort
    let link_regex = '\[[^]]*\]([^)]\+)'
    call search(link_regex, 'b')
endfunction
"}}}

" OpenLink{{{
function! s:OpenLink() abort
	let fulllink = <SID>GetLink()
	if fulllink !=? ''
		execute 'normal ' . 'lT[f('
		execute 'normal ' . '"zyi('
		let splitname = split(@z, '\.')
		if len(splitname) ==? 0
			" do nothing
		elseif len(splitname) ==? 1
			if !exists('w:parents') | let w:parents = [] | endif
			let w:parents = [expand('%:t')] + w:parents
			execute 'edit ' . '%:p:h/' . @z . '.md'
		else
			if !exists('w:parents') | let w:parents = [] | endif
			let w:parents = [expand('%:t')] + w:parents
			execute 'edit ' . '%:p:h/' . @z
		endif
		call setreg('z', [])
	else
		call <SID>CreateLink()
	endif
endfunction
"}}}

" GetLink{{{
function! s:GetLink() abort
    let link_regex = '\[[^]]*\]([^)]\+)'
    let line = getline('.')
    let link = matchstr(line, '\%<'.(col('.')+1).'c'.link_regex.'\%>'.col('.').'c')
    return link
endfunction
"}}}

" GetWordLink(UNUSED){{{
function! s:GetWordLink() abort
    let word_regex = '[-+0-9A-Za-z_]\+'
    let line = getline('.')
    let word = matchstr(line, '\%<'.(col('.')+1).'c'.word_regex.'\%>'.col('.').'c')
    return word
endfunction
"}}}

" Back{{{
function! s:Back() abort
	if exists('w:parents') && len(w:parents) !=? 0
		let lastparent = w:parents[0]
		let w:parents = w:parents[1:]
		execute 'edit ' . '%:p:h/' . lastparent
	else
		echomsg 'You might be inside the root wiki already.'
	endif
endfunction
"}}}

" Scratch buffer{{{
function s:ScratchBuffer()
    execute 'tabnew '
    file! SCRATCH
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal filetype=markdown.pandoc
endfunction
"}}}

" Edit main notes index{{{
function s:NoteWikiIndex()
    execute 'edit ' . $wikipages . '/index.md'
endfunction
"}}}

" Edit current notes index{{{
function s:NoteWiki()
    execute 'edit ' . '%:p:h' . '/index.md'
endfunction
"}}}

" Browse main notes directory{{{
function s:NoteOpenIndex()
    execute '!' . g:noteopen . ' ' . $wikipages . ' >/dev/null 2>&1 &'
    execute 'redraw!'
endfunction
"}}}

" Browse current notes directory{{{
function s:NoteOpen()
    execute '!' . g:noteopen . ' ' . '%:p:h' . ' >/dev/null 2>&1 &'
    execute 'redraw!'
endfunction
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
            !cp -R $HOME/.vim/pandoc $prefix
        endif
        !$pandoc/assets/makenote %:t:r
    else
        echomsg 'I need an md file!'
    endif
endfunction
"}}}


" Commands{{{
command! -nargs=0 ScratchBuffer call <SID>ScratchBuffer()
command! NoteWikiIndex call <SID>NoteWikiIndex()
command! NoteOpenIndex call <SID>NoteOpenIndex()
"}}}

" Plug{{{
nnoremap <silent> <Plug>(NoteWiki)   :call <SID>NoteWiki()<cr>
nnoremap <silent> <Plug>(NoteOpen)   :call <SID>NoteOpen()<cr>
nnoremap <silent> <Plug>(NotePandoc) :call <SID>NotePandoc()<cr>
nnoremap <silent> <Plug>(NextLink)   :call <SID>NextLink()<cr>
nnoremap <silent> <Plug>(PrevLink)   :call <SID>PrevLink()<cr>
nnoremap <silent> <Plug>(OpenLink)   :call <SID>OpenLink()<cr>
nnoremap <silent> <Plug>(Back)       :call <SID>Back()<cr>
"}}}
