if !isdirectory(expand('~/.config/nvim/tagdir'))
    execute "!mkdir ~/.config/nvim/tagdir &>/dev/null"
endif

let g:gutentags_cache_dir = '~/.config/nvim/tagdir'
