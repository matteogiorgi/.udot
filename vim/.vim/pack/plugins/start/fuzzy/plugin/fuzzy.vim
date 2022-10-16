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


command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyGit call <SID>FuzzyGit()


nnoremap <leader>j :FuzzyJump<CR>
