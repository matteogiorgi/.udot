" LongLine{{{
function! utility#LongLine()
    if !exists('g:longline')
        let g:longline = 'none'
    endif
    if g:longline ==? 'none'
        let g:longline = 'all'
        setlocal virtualedit=all
    else
        let g:longline = 'none'
        setlocal virtualedit=
    endif
endfunction
"}}}


" Background{{{
function! utility#ChBackground()
    if &background ==? 'dark'
        set background=light
    else
        set background=dark
    endif
endfunction
"}}}


" ToggleAccent{{{
function! utility#ToggleAccent()
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


" Substitute{{{
function! utility#SSelection(new)
    exec '%s//'.a:new.'/gc'
endfunction
"}}}


" WinMove{{{
function! utility#WinMove(key)
    let t:curwin = winnr()
    exec 'wincmd '.a:key
    if t:curwin ==? winnr()
        if match(a:key,'[jk]')
            wincmd v
        else
            wincmd s
        endif
        exec 'wincmd '.a:key
        " add `exec 'Explore'` here to open Netrw inside
        " new window or aother file explorer as follows:
        " if exists("g:fzf_explore") | exec 'FZFExplore' | endif
    endif
    return bufname('%')
endfunction
"}}}


" Mkdir{{{
function! utility#Mkdir()
    let dir = expand('%:p:h')
    if dir =~ '://' | return | endif
    if !isdirectory(dir)
        call mkdir(dir, 'p')
        echo 'Created non-existing directory: '.dir
    endif
endfunction
"}}}


" Delete{{{
function! utility#Delete()
    delete(expand('%'))
    Bclose
endfunction
"}}}


" Rename{{{
function! utility#Rename(name, bang)
	let l:name    = a:name
	let l:oldfile = expand('%:p')

	if bufexists(fnamemodify(l:name, ':p'))
		if (a:bang ==# '!')
			silent exe bufnr(fnamemodify(l:name, ':p')) . 'bwipe!'
		else
			echohl ErrorMsg
			echomsg 'A buffer with that name already exists (use ! to override).'
			echohl None
			return 0
		endif
	endif

	let l:status = 1

	let v:errmsg = ''
	silent! exe 'saveas' . a:bang . ' ' . l:name

	if v:errmsg =~# '^$\|^E329'
		let l:lastbufnr = bufnr('$')

		if expand('%:p') !=# l:oldfile && filewritable(expand('%:p'))
			if fnamemodify(bufname(l:lastbufnr), ':p') ==# l:oldfile
				silent exe l:lastbufnr . 'bwipe!'
			else
				echohl ErrorMsg
				echomsg 'Could not wipe out the old buffer for some reason.'
				echohl None
				let l:status = 0
			endif

			if delete(l:oldfile) != 0
				echohl ErrorMsg
				echomsg 'Could not delete the old file: ' . l:oldfile
				echohl None
				let l:status = 0
			endif
		else
			echohl ErrorMsg
			echomsg 'Rename failed for some reason.'
			echohl None
			let l:status = 0
		endif
	else
		echoerr v:errmsg
		let l:status = 0
	endif

	return l:status
endfunction
"}}}


" Check if directory{{{
" UNUSED
function! s:isdir(dir) abort
    let l:isempty = !empty(a:dir)
    let l:isdirectory = isdirectory(a:dir)
    let l:systemshit = !empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)
    return l:isempty && (l:isdirectory || l:systemshit)
endfunction
"}}}


" Launch explorer on open{{{
" UNUSED
function! utility#LaunchOnOpen(explorer)
    let l:directory = expand('%:p')
    if <SID>isdir(l:directory)
        execute 'Bclose'
        if len(getbufinfo({'buflisted':1})) !=? 1 || bufname('%') !=? ''
            execute 'tabnew'
        endif
        execute 'cd ' . l:directory
        execute a:explorer
    endif
endfunction
"}}}


" Jump current directory{{{
" UNUSED
function! utility#Current()
    echon 'cwd: '
    cd %:p:h
    echon getcwd()
endfunction
"}}}


" Jump parent directory{{{
" UNUSED
function! utility#Parent()
    echon 'cwd: '
    let l:parent = fnamemodify('getcwd()', ':p:h:h')
    execute 'cd ' . l:parent
    echon getcwd()
endfunction
"}}}


" Jump git directory{{{
" UNUSED
function! utility#GitDir()
    if getcwd() ==? $HOME
        " echon 'Not in a git repository'
        return
    endif

    if isdirectory('.git')
        echon 'cwd: ' . getcwd()
        return
    else
        let l:parent = fnamemodify('getcwd()', ':p:h:h')
        execute 'cd ' . l:parent
        execute 'call utility#GitDir()'
    endif
endfunction
"}}}
