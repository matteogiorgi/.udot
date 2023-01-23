" Complete Words{{{
function! utility#CompleteWords(ArgLead, CmdLine, ...)
  return getline(1, '$')->join(' ')->split('\s\+')
              \ ->filter({_,x->match(x, '^\h\w\+$') > -1})
              \ ->filter({_,x->match(x, '^' . a:CmdLine) > -1})
              \ ->sort()->uniq()
endfunction
"}}}


" LongLine{{{
function! utility#LongLine()
    let g:longline = !exists('g:longline') ? 'none' : g:longline
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


" Replace{{{
function! utility#ReplaceSearch()
    call inputsave()
    let l:replace = input('Replace searched pattern with: ', '', 'customlist,utility#CompleteWords')
    call inputrestore()
    if l:replace != ""
        exec '%s//'.l:replace.'/gc'
    else
        redraw
        echo 'No substitution done'
    endif
endfunction
"}}}


" Save Session{{{
function! utility#SessionSave()
    call inputsave()
    let l:session = input('Save session as: ', '', 'customlist,utility#CompleteWords')
    call inputrestore()
    if l:session != ""
        exec 'mksession! ~/.vim/sessions/'.l:session
        redraw
        echo 'Session saved as '.l:session
    else
        redraw
        echo 'No session saved'
    endif
endfunction
"}}}


" Load Session{{{
function! utility#SessionLoad()
    call inputsave()
    let l:session = input('Load session: ', '', 'customlist,utility#CompleteWords')
    call inputrestore()
    if l:session != ""
        exec 'source ~/.vim/sessions/'.l:session
        redraw
        echo 'Loaded session '.l:session
    else
        redraw
        echo 'No session loaded'
    endif
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


" Jump current directory{{{
function! utility#JumpCurrentDir()
    echon 'CWD: '
    cd %:p:h
    echon getcwd()
endfunction
"}}}


" Jump parent directory{{{
function! utility#JumpParentDir()
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
function! utility#JumpGitDir()
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
        execute 'call utility#JumpGitDir()'
    endif
endfunction
"}}}


" Delete{{{
function! utility#Delete()
    call inputsave()
    let l:file = expand('%:p:t')
    let l:answer = input('Delete '.l:file.'? (Y/n)')
    call inputrestore()
    if l:answer ==? "Y"
        call delete(expand('%'))
        if exists(':Bclose')
            Bclose
        endif
        redraw
        echo l:file.' is dead'
    else
        redraw
        echo l:file.' is still alive'
    endif
endfunction
"}}}


" Rename{{{
function! utility#Rename(bang)
    call inputsave()
    let l:file = expand('%:p:t')
    let l:name = input('Rename '.expand('%:p:t').' as: ')
    call inputrestore()
    if l:name ==? ""
        redraw
        echo l:file.' hasnt been renamed'
        return 1
    endif
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

    redraw
    echo l:file.' is now '.l:name
	return l:status
endfunction
"}}}


" WinMove{{{
" UNUSED
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


" Confirm{{{
" UNUSED
function! utility#Confirm(msg)
    echo a:msg . ' '
    let l:answer = nr2char(getchar())
    if l:answer ==? 'y'
        return 1
    elseif l:answer ==? 'n'
        return 0
    else
        return utility#Confirm(a:msg)
    endif
endfun
"}}}
