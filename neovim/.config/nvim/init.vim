""
""                                 NEOVIM PLUGINS
""                    [ https://github.com/junegunn/vim-plug ]
""
""    vim-surround ················· https://github.com/tpope/vim-surround
""    vim-repeat ··················· https://github.com/tpope/vim-repeat
""    vim-commentary ··············· https://github.com/tpope/vim-commentary
""    undotree ····················· https://github.com/mbbill/undotree
""    coc.nvim ····················· https://github.com/neoclide/coc.nvim
""    context.vim ·················· https://github.com/wellle/context.vim
""    vim-gutentags ················ https://github.com/ludovicchabant/vim-gutentags
""
""    For full documentation and other stuff visit https://neovim.io
""




" Plug check (it only works on GNU/Linux) {{{
augroup vimenter
    autocmd VimEnter *
                \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
                \     PlugInstall --sync | q |
                \ endif
    if !filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config/nvim}/autoload/plug.vim"'))
        echo 'Downloading junegunn/vim-plug to manage plugins...'
        silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
                    \ > ${XDG_CONFIG_HOME:-$HOME/.config/nvim}/autoload/plug.vim
        autocmd VimEnter * PlugInstall
    endif
augroup end
" }}}


" Netrw on open {{{
augroup onopen
    autocmd!
    autocmd VimEnter *
                \ if argc() == 0 |
                \     Explore! |
                \ endif
augroup end
" }}}


" Terminal settings {{{
augroup termsettings
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup end
" }}}


" Plugin list {{{
call plug#begin('~/.config/nvim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'mbbill/undotree'
    Plug 'neoclide/coc.nvim', {'branch' : 'release'}
    Plug 'wellle/context.vim'
    Plug 'ludovicchabant/vim-gutentags'
call plug#end()
" }}}


" Some settings to load early {{{
if exists('+termguicolors') | set termguicolors | endif
if has('linebreak') | let &showbreak='⤷ ' | endif
if has('persistent_undo')
    if !isdirectory(expand('~/.config/nvim/undodir'))
        execute "!mkdir ~/.config/nvim/undodir &>/dev/null"
    endif
    set undodir=$HOME/.config/nvim/undodir
    set undofile
endif
" }}}


" Syntax {{{
syntax on
filetype plugin indent on
colorscheme hembox
" }}}


" Dynamic background {{{
if exists('theme') && theme == 'light'
    set background=light
else
    set background=dark
endif
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
set cursorlineopt=number,line
set splitbelow splitright
set noequalalways
set nofoldenable foldmethod=marker
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=2000
set timeoutlen=2000
set termencoding=utf-8 encoding=utf-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=
set cmdheight=1
set fillchars+=vert:\│,eob:\ ,fold:-
set wildchar=<Tab> wildmenu wildmode=full
set nrformats-=alpha
set laststatus=2
set showtabline=1
" }}}

" Set completion {{{
set path+=**
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest,noinsert,noselect
set complete+=k/usr/share/dict/american-english
set complete+=k/usr/share/dict/italian
set complete+=w,b
set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/italian
set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set shortmess+=c
set belloff+=ctrlg
" }}}


" Variables to load early {{{
let g:mapleader = "\<space>"
let g:maplocalleader = ","
let g:coc_node_path = trim(system('which node'))
if has('python3')
    let g:python3_host_prog = '/usr/bin/python3'
endif
" }}}


" Linenumber behaviour {{{
augroup numbertoggle
    autocmd!
    autocmd WinEnter,BufEnter,FocusGained,InsertLeave *
                \ if &number ==? 1 | set relativenumber | endif | set cursorline
    autocmd WinLeave,BufLeave,FocusLost,InsertEnter *
                \ if &number ==? 1 | set norelativenumber | endif | set nocursorline
augroup end
" }}}


" Overlength behaviour {{{
augroup overlengthtoggle
    autocmd!
    autocmd InsertEnter *
                \ if &filetype !=? 'markdown' && &filetype !=? 'markdown.pandoc' && &filetype !=? 'pandoc' |
                \     let &colorcolumn = '121,'.join(range(121,999),',') |
                \ endif
    autocmd InsertLeave *
                \ if &filetype !=? 'markdown' && &filetype !=? 'markdown.pandoc' && &filetype !=? 'pandoc' |
                \     set colorcolumn= |
                \ endif
augroup end
" }}}


" Simple commands {{{
command! Date execute 'r !printf "\n\# " && date && printf "\n"'
command! SelectAll execute "normal \ggVG"
command! IndentAll exe 'setl ts=4 sts=0 et sw=4 sta' | exe "norm gg=G"
command! RemoveSpaces :%s/\s\+$//e
command! Squish execute "normal \ggVGgq"
command! ClearLastSearch :let @/=""
" }}}


" Copy/Pasta commands {{{
command! Copy execute 'visual "+y'
command! Pasta execute 'normal "+p'
" }}}


" Keymaps {{{
xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+1<CR>gv=gv
vnoremap <silent><Tab> >gv
vnoremap <silent><S-Tab> <gv
nnoremap <silent><Tab> :wincmd w<cr>
nnoremap <silent><Backspace> :b#<cr>
nnoremap <silent><C-h> :tabprev<cr>
nnoremap <silent><C-l> :tabnext<cr>
nnoremap <silent><C-p> :tabmove -1<cr>
nnoremap <silent><C-n> :tabmove +1<cr>
nnoremap <silent>Y y$
nnoremap <silent>QQ :qall<CR>
nnoremap <silent>WW :wall<CR>
tnoremap <silent><C-q> <C-\><C-n>
nnoremap <silent><C-d> <C-d>zz
nnoremap <silent><C-u> <C-u>zz
nnoremap <silent><C-j> }
nnoremap <silent><C-k> {
" }}}
