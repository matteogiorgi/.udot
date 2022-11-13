function s:FuzzyFind()
    if has('gui_running') || has('nvim')
        exec "silent !i3-sensible-terminal -n fuzzy -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyfind " . expand("%:p:h")
    else
        exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyfind " . expand("%:p:h")
    endif
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyJump()
    if has('gui_running') || has('nvim')
        exec "silent !i3-sensible-terminal -n fuzzy -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyjump " . expand("%:p:h")
    else
        exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyjump " . expand("%:p:h")
    endif
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
    if has('gui_running') || has('nvim')
        exec "silent !i3-sensible-terminal -n fuzzy -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzygit"
    else
        exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzygit"
    endif
    redraw!
endfun


command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyGit call <SID>FuzzyGit()


nnoremap <leader>j :FuzzyJump<CR>
nnoremap <leader>J :FuzzyFind<CR>
nnoremap <leader>H :FuzzyGit<CR>
