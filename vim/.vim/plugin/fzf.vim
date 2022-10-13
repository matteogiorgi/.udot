" This section is for general FZF,
" it just needs to have FZF installed in the system

function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

function! s:FzfBufName()
    0f
    file [Fzf]
endfunction


" In case you use window mode,
" you'll need a new statusline ;)
augroup fzflines
    autocmd!
    autocmd User FzfStatusLine setlocal statusline=>>\ fzf  " %#Fzf1#
    autocmd BufCreate,BufWinEnter,WinEnter term://*#FZF,term://*/run call s:FzfBufName()
augroup END


let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" 2>/dev/null'
let $FZF_DEFAULT_OPTS='--bind "ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up" --height 100% --margin 0% --reverse --info=hidden --header-first'

" standard colors for FZF with the exception of:
" 'border' : ['fg', 'Ignore'],
let g:fzf_colors = {
            \ 'fg'      : ['fg', 'Normal'],
            \ 'bg'      : ['bg', 'Normal'],
            \ 'hl'      : ['fg', 'Comment'],
            \ 'fg+'     : ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+'     : ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+'     : ['fg', 'Statement'],
            \ 'info'    : ['fg', 'PreProc'],
            \ 'border'  : ['bg', 'StatusLine'],
            \ 'prompt'  : ['fg', 'Conditional'],
            \ 'pointer' : ['fg', 'Exception'],
            \ 'marker'  : ['fg', 'Keyword'],
            \ 'spinner' : ['fg', 'Label'],
            \ 'header'  : ['fg', 'Comment']
            \ }
let g:fzf_action = {
            \ 'ctrl-q' : function('s:build_quickfix_list'),
            \ 'ctrl-t' : 'tab split',
            \ 'ctrl-s' : 'split',
            \ 'ctrl-v' : 'vsplit'
            \ }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_preview_window = ['down:80%,border-sharp', 'ctrl-/']
let g:fzf_layout = { 'window': 'enew' }


" Locate
nnoremap <leader>w :Windows<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>s :GFiles?<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles<CR>
nnoremap <leader>g :BCommits<CR>
nnoremap <leader>G :Commits<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>j :Buffers<CR>
nnoremap <leader>k :Rg<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>L :Lines<CR>
