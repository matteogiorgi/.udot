" You need to have TERMINAL variable set in
" order for this plugin to be executed correctly


function s:FuzzyJump()
    let s:folder = expand("%:p:h")
    call system('$TERMINAL --title __scratch_1__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzyjump s:folder')
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

function s:FuzzyFind()
    let s:folder = expand("%:p:h")
    call system('$TERMINAL --title __scratch_1__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzyfind s:folder')
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyGit()
    call system('$TERMINAL --title __scratch_1__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzygit')
    redraw!
endfun


command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyGit call <SID>FuzzyGit()


nnoremap <leader>jj :FuzzyJump<CR>
nnoremap <leader>jf :FuzzyFind<CR>
nnoremap <leader>jg :FuzzyGit<CR>
