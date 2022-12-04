" you need to have st-terminal installed
" in order to this plugin to execute correctly

function s:FuzzyFind()
    let s:folder = expand("%:p:h")
    if has('nvim')
        exec "silent !urxvt -name scratchpad -e $HOME/.config/nvim/pack/plugins/start/fuzzy/plugin/fuzzyfind s:folder"
    elseif has('gui_running')
        exec "silent !urxvt -name scratchpad -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyfind s:folder"
    else
        exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyfind s:folder"
    endif
    if filereadable('/tmp/vim_fuzzy_current_file')
        exec 'edit ' . system('cat /tmp/vim_fuzzy_current_file')
        call system('rm /tmp/vim_fuzzy_current_file')
    endif
    redraw!
endfun

function s:FuzzyJump()
    let s:folder = expand("%:p:h")
    if has('nvim')
        exec "silent !urxvt -name scratchpad -e $HOME/.config/nvim/pack/plugins/start/fuzzy/plugin/fuzzyjump s:folder"
    elseif has('gui_running')
        exec "silent !urxvt -name scratchpad -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyjump s:folder"
    else
        exec "silent !$HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzyjump s:folder"
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
    if has('nvim')
        exec "silent !urxvt -name scratchpad -e $HOME/.config/nvim/pack/plugins/start/fuzzy/plugin/fuzzygit"
    elseif has('gui_running')
        exec "silent !urxvt -name scratchpad -e $HOME/.vim/pack/plugins/start/fuzzy/plugin/fuzzygit"
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
