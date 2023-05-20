"
"                                 E-VIM PLUGINS
"                    [ https://github.com/junegunn/vim-plug ]
"
"    lightline.vim ················ https://github.com/itchyny/lightline.vim
"    vim-pandoc ··················· https://github.com/vim-pandoc/vim-pandoc
"    vim-pandoc-syntax ············ https://github.com/vim-pandoc/vim-pandoc-syntax
"    vim-surround ················· https://github.com/tpope/vim-surround
"    vim-repeat ··················· https://github.com/tpope/vim-repeat
"    vim-commentary ··············· https://github.com/tpope/vim-commentary
"    vim-fugitive ················· https://github.com/tpope/vim-fugitive
"    undotree ····················· https://github.com/mbbill/undotree
"    context.vim ·················· https://github.com/wellle/context.vim
"    vim-gutentags ················ https://github.com/ludovicchabant/vim-gutentags
"    fzf.vim ······················ https://github.com/junegunn/fzf.vim
"    coc.nvim ····················· https://github.com/neoclide/coc.nvim
"    copilot.vim ·················· https://github.com/github/copilot.vim
"
"    For full documentation and other stuff visit https://www.vim.org
"




" Plug check (it only works on GNU/Linux) {{{
augroup vimenter
    autocmd VimEnter *
                \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
                \     PlugInstall --sync | q |
                \ endif
    if !filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.vim}/autoload/plug.vim"'))
        echo 'Downloading junegunn/vim-plug to manage plugins...'
        silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.vim}/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
                    \ > ${XDG_CONFIG_HOME:-$HOME/.vim}/autoload/plug.vim
        autocmd VimEnter * PlugInstall
    endif
augroup end
" }}}




" Save last session {{{
" a better way would be to check
" buffers on all opened windows
augroup vimleave
    autocmd VimLeave *
                \ if &filetype == 'startscreen' |
                \     execute 'bdelete' |
                \ endif |
                \ if !isdirectory('$HOME/.vim/sessions') |
                \     execute "!mkdir -p $HOME/.vim/sessions" |
                \ endif |
                \ if has('nvim') |
                \     mksession! $HOME/.vim/sessions/last.nvim |
                \ else |
                \     mksession! $HOME/.vim/sessions/last.vim |
                \ endif
augroup end
" }}}




" Terminal settings {{{
if has('nvim')
    augroup termsettings
        autocmd!
        autocmd TermOpen * setlocal nonumber norelativenumber
    augroup end
endif
" }}}




" Plugin list {{{
call plug#begin('~/.vim/plugged')
    " use ../packed/simple-complete as alternative to neoclide/coc.nvim
    " use ../packed/lines as alternative to itchyny/lightline.vim
    " use ../packed/qbuf as a buffer switcher alternative
    Plug '$HOME/.vim/packed/bclose'
    Plug '$HOME/.vim/packed/ezwindow'
    Plug '$HOME/.vim/packed/fuzzy'
    Plug '$HOME/.vim/packed/startscreen'
    Plug '$HOME/.vim/packed/utility'
    Plug '$HOME/.vim/packed/notewiki'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'itchyny/lightline.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'mbbill/undotree'
    Plug 'wellle/context.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'neoclide/coc.nvim', {'branch' : 'release'}
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    if v:version >= 900 || has('nvim')
        let g:copilot_no_tab_map = v:true
        let g:copilot_assume_mapped = v:true
        let g:copilot_enabled = v:false
        Plug 'github/copilot.vim'
    endif
call plug#end()
" }}}




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
if has("gui_running") | colorscheme hemisu | else | colorscheme hembox | endif
if exists('theme') && theme == 'light' | set background=light | else | set background=dark | endif
" }}}




" Set mainstuff {{{
set exrc
set title
set shell=bash  " zsh,bash
set runtimepath+=~/.vim_runtime  " add whatever
set clipboard=unnamedplus
set number relativenumber mouse=a  " a,n,v,i,c
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set ruler scrolloff=8 sidescrolloff=16
set autoindent
set formatoptions+=l
set hlsearch incsearch
set nowrap nospell  " set spell complete+=kspell
set ignorecase smartcase smartindent
set noswapfile nobackup
set showmode showcmd
set cursorline noerrorbells novisualbell
set splitbelow splitright
set equalalways
set nofoldenable foldmethod=marker  "zf zd za zo zc zi zE zR zM
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=2000  " 300,4000
set timeoutlen=2000  " 300,4000
set ttimeoutlen=0    " -1,0,100
set termencoding=utf-8 encoding=utf-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=
set cmdheight=1
set nrformats-=alpha  " alpha,octal,hex,bin,unsigned
set cursorlineopt=number,line
set fillchars+=vert:\│,eob:\ ,fold:-
set laststatus=2
set showtabline=1
if !has('nvim')
    set nocompatible
    set esckeys
endif
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
set wildmenu  " wildoptions+=fuzzy
set wildchar=<Tab> wildmode=full  " wildmode=list:longest,list:full
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




" Cursor mode (line cursor in insert mode) {{{
if ! (has("gui_running") && has('nvim'))
    " Ps=0 -> blinking block.
    " Ps=1 -> blinking block (default).
    " Ps=2 -> steady block.
    " Ps=3 -> blinking underline.
    " Ps=4 -> steady underline.
    " Ps=5 -> blinking bar (xterm).
    " Ps=6 -> steady bar (xterm).
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
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
                \ if &filetype !=? 'markdown' && &filetype !=? 'markdown.pandoc' && &filetype !=? 'pandoc' && &filetype !=? 'tex' |
                \     let &colorcolumn = '121,'.join(range(121,999),',') |
                \ endif
    autocmd InsertLeave *
                \ if &filetype !=? 'markdown' && &filetype !=? 'markdown.pandoc' && &filetype !=? 'pandoc' && &filetype !=? 'tex' |
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
command! LastSession :source $HOME/.vim/sessions/last.vim
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
nnoremap <silent><Tab> :wincmd w<cr>
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
