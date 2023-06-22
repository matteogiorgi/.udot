" __     ___
" \ \   / (_)_ __ ___
"  \ \ / /| | '_ ` _ \
"   \ V / | | | | | | |
"    \_/  |_|_| |_| |_|
"
" Vim editor - https://www.vim.org.




" Some settings to load early {{{
if exists('+termguicolors') | set termguicolors | endif
if has('linebreak') | let &showbreak='⤷ ' | endif
if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        execute "!mkdir ~/.vim/undodir &>/dev/null"
    endif
    set undodir=$HOME/.vim/undodir
    set undofile
endif
" }}}




" Syntax and colors {{{
syntax on
filetype plugin indent on
set background=dark
colorscheme hembox
" }}}




" Set mainstuff {{{
set exrc
set title
set shell=bash
set runtimepath+=~/.vim_runtime
set clipboard=unnamedplus
set number relativenumber mouse=a
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set ruler scrolloff=8 sidescrolloff=16
set autoindent
set formatoptions+=l
set hlsearch incsearch
set nowrap nospell
set ignorecase smartcase smartindent
set noswapfile nobackup
set showmode showcmd
set cursorline noerrorbells novisualbell
set splitbelow splitright
set equalalways
set nofoldenable foldmethod=marker
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=2000
set timeoutlen=2000
set ttimeoutlen=0
set termencoding=utf-8 encoding=utf-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=
set cmdheight=1
set nrformats-=alpha
set cursorlineopt=number,line
set fillchars+=vert:\┃
set laststatus=2
set showtabline=1
set nocompatible
set esckeys
" }}}




" Set completion {{{
set path+=**
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest,noinsert,noselect
set complete+=k/usr/share/dict/american-english
set complete+=k/usr/share/dict/italian
set complete+=.,w,b,u,t,i,kspell
set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/italian
set wildmenu
set wildchar=<Tab> wildmode=full
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set shortmess+=c
set belloff+=ctrlg
" }}}




" Variables to load early {{{
let g:mapleader = "\<space>"
let g:maplocalleader = "\\"
if has('python3')
    let g:python3_host_prog = '/usr/bin/python3'
endif
" }}}




" Cursor mode {{{
" Ps=0 -> blinking block.
" Ps=1 -> blinking block (default).
" Ps=2 -> steady block.
" Ps=3 -> blinking underline.
" Ps=4 -> steady underline.
" Ps=5 -> blinking bar (xterm).
" Ps=6 -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" }}}




" Linenumber behaviour {{{
augroup numbertoggle
    autocmd! WinEnter,BufEnter,FocusGained,InsertLeave *
                \ if &number ==? 1 | set relativenumber | endif | set cursorline
    autocmd! WinLeave,BufLeave,FocusLost,InsertEnter *
                \ if &number ==? 1 | set norelativenumber | endif | set nocursorline
augroup end
" }}}




" Overlength behaviour {{{
augroup overlengthtoggle
    autocmd! InsertEnter *
                \ if &filetype !=? 'text' && &filetype !=? 'markdown' && &filetype !=? 'tex' |
                \     let &colorcolumn = '121,'.join(range(121,999),',') |
                \ endif
    autocmd! InsertLeave *
                \ if &filetype !=? 'text' && &filetype !=? 'markdown' && &filetype !=? 'tex' |
                \     set colorcolumn= |
                \ endif
augroup end
" }}}




" Netrw auto-start {{{
augroup initnetrw
    autocmd! VimEnter * if expand("%") == "" | edit . | endif
augroup END
" }}}




" Simple commands {{{
command! ToggleWordWrap if &wrap | set nowrap | else | set wrap | endif
command! ToggleBackground if &background ==# 'light' | set background=dark | else | set background=light | endif
command! ToggleVirtualEdit if &virtualedit ==# 'all' | setlocal virtualedit= | else | setlocal virtualedit=all | endif
command! IndentAll exe 'setl ts=4 sts=0 et sw=4 sta' | exe "norm gg=G"
command! RemoveSpaces :%s/\s\+$//e
command! ClearLastSearch :let @/=""
" }}}




" Copy/Pasta commands {{{
"(`apt intall -yy vim-gtk3`)
command! Copy execute 'visual "+y'
command! Pasta execute 'normal "+p'
" }}}




" Keymaps {{{
xnoremap <silent>K :move '<-2<CR>gv=gv
xnoremap <silent>J :move '>+1<CR>gv=gv
vnoremap <silent><Tab> >gv
vnoremap <silent><S-Tab> <gv
nnoremap <silent><C-h> :tabprev<CR>
nnoremap <silent><C-l> :tabnext<CR>
nnoremap <silent><C-n> :bnext<CR>
nnoremap <silent><C-p> :bprev<CR>
nnoremap <silent><Tab> :buffer#<CR>
nnoremap <silent><CR> :echo getcwd()<CR>
nnoremap <silent><C-j> }
nnoremap <silent><C-k> {
vnoremap <silent><C-j> }
vnoremap <silent><C-k> {
nnoremap <silent>Y y$
nnoremap <leader>w <C-w>
nnoremap <leader>a :execute "normal \ggVG"<CR>
xnoremap <leader>s :s///gc<Left><Left><Left>
vnoremap <leader>e :!<space>
nnoremap <leader><space> :Explore<CR>
nnoremap <leader>0 0gt
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
" }}}
