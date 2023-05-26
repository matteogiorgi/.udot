" Fuzzy finder
" ------------

" Finder plugin (with fzf) that lets you jump between
" file and directories and screen git commits.




function s:FuzzyJump()
    let s:folder = expand("%:p:h")
    exec "silent !$HOME/.vim/utility/fuzzyjump s:folder"
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
    exec "silent !$HOME/.vim/utility/fuzzyfind s:folder"
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyGit()
    exec "silent !$HOME/.vim/utility/fuzzygit"
    redraw!
endfun


command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyGit call <SID>FuzzyGit()

nnoremap <leader>j :FuzzyJump<CR>
nnoremap <leader>f :FuzzyFind<CR>
nnoremap <leader>g :FuzzyGit<CR>
