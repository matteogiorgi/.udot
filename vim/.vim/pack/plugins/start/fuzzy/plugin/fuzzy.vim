function s:FuzzyFind()
    exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyfind " . expand("%:p:h")
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyJump()
    exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyjump " . expand("%:p:h")
    if filereadable('/tmp/vim_fuzzy_current_dir')
        exec 'cd ' . system('cat /tmp/vim_fuzzy_current_dir')
        call system('rm /tmp/vim_fuzzy_current_dir')
    endif
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyGit()
    exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzygit"
    redraw!
endfun

function s:FuzzyList()
    let files = filter(map(range(1,bufnr('$')), 'fnamemodify(bufname(v:val), ":p")'), '!empty(v:val)')
    call writefile(files, '/tmp/vim_fuzzy_buffers')
    exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzylist"
    call system('rm /tmp/vim_fuzzy_buffers')
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun


command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyGit call <SID>FuzzyGit()
command! FuzzyList call <SID>FuzzyList()

nnoremap <leader>f :FuzzyFind<CR>
nnoremap <leader>j :FuzzyJump<CR>
nnoremap <leader>g :FuzzyGit<CR>
nnoremap <leader>l :FuzzyList<CR>
