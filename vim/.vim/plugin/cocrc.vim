"
"                              COC-EXTENSIONS
"                  [ https://github.com/neoclide/coc.nvim ]
"
"     coc-marketplace ········· https://github.com/fannheyward/coc-marketplace
"     coc-dictionary ·········· https://github.com/neoclide/coc-sources
"     coc-snippets  ··········· https://github.com/neoclide/coc-snippets
"     coc-git ················· https://github.com/neoclide/coc-git
"     coc-pairs ··············· https://github.com/neoclide/coc-pairs
"
"
"     If you want an extension to work on top of the ones already
"     configured in coc-settings.json, use the marketplace or add:
"     let g:coc_global_extensions = add(g:coc_global_extensions, 'somesomething')
"




" Funcions {{{
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction
" }}}




" Autogroups {{{
if empty(glob("$HOME/.vim/coc-settings.json"))
    augroup cocsettings
        autocmd!
        autocmd VimEnter *
                    \ if !empty(glob("$HOME/.vim/cocsettings")) |
                    \     execute "!$HOME/.vim/cocsettings" |
                    \ endif
    augroup end
endif

augroup hlcursor
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

augroup redrawstatusline
    autocmd!
    autocmd User CocStatusChange redrawstatus
augroup end
" }}}




" File-Path and Extensions-List {{{
let g:coc_config_home = '~/.vim'
let g:coc_global_extensions = [
            \ 'coc-marketplace',
            \ 'coc-dictionary',
            \ 'coc-snippets',
            \ 'coc-git',
            \ 'coc-pairs',
            \ ]
" }}}




" Commands {{{
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" }}}




" Keymaps {{{
inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <backspace> coc#pum#visible() ? "\<bs>\<c-r>=coc#start()\<CR>" : "\<bs>"
inoremap <silent><expr> <c-space> coc#refresh()

nnoremap <silent>K :call ShowDocumentation()<CR>
nnoremap <leader>a :CocList<CR>

nmap <leader>d <Plug>(coc-definition)
nmap <leader>r <Plug>(coc-references)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>n <Plug>(coc-diagnostic-next)
nmap <leader>p <Plug>(coc-diagnostic-prev)
" }}}
