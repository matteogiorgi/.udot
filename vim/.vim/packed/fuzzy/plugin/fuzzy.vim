" you need to have st-terminal installed
" in order to this plugin to execute correctly


function s:FuzzyFind()
    let s:folder = expand("%:p:h")
    exec "silent !nohup xterm -T __fuzzy__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzyfind s:folder >/dev/null 2>&1 &"
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyJump()
    let s:folder = expand("%:p:h")
    exec "silent !nohup xterm -T __fuzzy__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzyjump s:folder >/dev/null 2>&1 &"
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
    exec "silent !nohup xterm -T __fuzzy__ -e $HOME/.vim/packed/fuzzy/plugin/fuzzygit >/dev/null 2>&1 &"
    redraw!
endfun


command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyGit call <SID>FuzzyGit()


nnoremap <leader>jh :FuzzyGit<CR>
nnoremap <leader>jj :FuzzyJump<CR>
nnoremap <leader>jk :FuzzyFind<CR>
