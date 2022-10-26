if !isdirectory(expand('~/.vim/tagdir'))
    execute "!mkdir ~/.vim/tagdir &>/dev/null"
endif

let g:gutentags_cache_dir = '~/.vim/tagdir'
