" you need to have st-terminal installed
" in order to this plugin to execute correctly


function s:FuzzyFind()
    let s:folder = expand("%:p:h")
    call system('xterm -T __fuzzy__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzyfind s:folder')
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyJump()
    let s:folder = expand("%:p:h")
    call system('xterm -T __fuzzy__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzyjump s:folder')
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
    call system('xterm -T __fuzzy__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzygit')
    redraw!
endfun


command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyGit call <SID>FuzzyGit()


nnoremap <leader>jf :FuzzyFind<CR>
nnoremap <leader>jg :FuzzyGit<CR>
nnoremap <leader>jj :FuzzyJump<CR>
