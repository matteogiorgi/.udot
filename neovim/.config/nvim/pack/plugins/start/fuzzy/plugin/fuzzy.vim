" you need to have st-terminal installed
" in order to this plugin to execute correctly

function s:FuzzyFind()
    let s:folder = expand("%:p:h")
    if has('nvim')
        exec "silent !st -T SCRATCHPAD -e $HOME/.config/nvim/pack/plugins/start/fuzzy/plugin/fuzzyfind s:folder"
    else
        exec "silent !st -T SCRATCHPAD -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyfind s:folder"
    endif
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
endfun

function s:FuzzyJump()
    let s:folder = expand("%:p:h")
    if has('nvim')
        exec "silent !st -T SCRATCHPAD -e $HOME/.config/nvim/pack/plugins/start/fuzzy/plugin/fuzzyjump s:folder"
    else
        exec "silent !st -T SCRATCHPAD -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyjump s:folder"
    endif
    if filereadable('/tmp/vim_fuzzy_current_dir')
        exec 'cd ' . system('cat /tmp/vim_fuzzy_current_dir')
        call system('rm /tmp/vim_fuzzy_current_dir')
    endif
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
endfun

function s:FuzzyGit()
    if has('nvim')
        exec "silent !st -T SCRATCHPAD -e $HOME/.config/nvim/pack/plugins/start/fuzzy/plugin/fuzzygit"
    else
        exec "silent !st -T SCRATCHPAD -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzygit"
    endif
endfun

function s:FuzzyShell()
    exec "silent !st -T SCRATCHPAD"
endfun


command! FuzzyFind call <SID>FuzzyFind()
command! FuzzyJump call <SID>FuzzyJump()
command! FuzzyGit call <SID>FuzzyGit()
command! FuzzyShell call <SID>FuzzyShell()


nnoremap <leader>jj :FuzzyJump<CR>
nnoremap <leader>jf :FuzzyFind<CR>
nnoremap <leader>jg :FuzzyGit<CR>
nnoremap <leader>js :FuzzyShell<CR>
