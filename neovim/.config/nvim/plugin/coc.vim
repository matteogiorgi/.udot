
"                              COC-EXTENSIONS
"                  [ https://github.com/neoclide/coc.nvim ]
"
"     coc-marketplace ········· https://github.com/fannheyward/coc-marketplace
"     coc-dictionary ·········· https://github.com/neoclide/coc-sources
"     coc-snippets  ··········· https://github.com/neoclide/coc-sources
"     coc-highlight ··········· https://github.com/neoclide/coc-highlight
"     coc-pairs ··············· https://github.com/neoclide/coc-highlight
"     coc-lists ··············· https://github.com/neoclide/coc-lists
"     coc-git ················· https://github.com/neoclide/coc-git
"     coc-yank ················ https://github.com/neoclide/coc-yank
"
"
"     If you want an extension to work on top of the ones already
"     configured in coc-settings.json, use the marketplace or add:
"     let g:coc_global_extensions = add(g:coc_global_extensions, 'somesomething')




"" Coc configuration file path and main extensions list
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_config_home = '~/.config/nvim'
let g:coc_global_extensions = [
            \ 'coc-marketplace',
            \ 'coc-dictionary',
            \ 'coc-snippets',
            \ 'coc-highlight',
            \ 'coc-pairs',
            \ 'coc-lists',
            \ 'coc-git',
            \ 'coc-yank',
            \ ]




"" Autogroups
"""""""""""""

if empty(glob("$HOME/.config/nvim/coc-settings.json"))
    augroup cocsettings
        autocmd!
        autocmd VimEnter *
                    \ if !empty(glob("$HOME/.config/nvim/cocsettings")) |
                    \     execute "!$HOME/.config/nvim/cocsettings" |
                    \ endif
    augroup end
endif

augroup hlcursor
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

augroup formatgroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end




"" Funcions
"""""""""""

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




"" Commands
"""""""""""

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')




"" Keymaps
""""""""""
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent>K :call ShowDocumentation()<CR>
nnoremap <leader><Tab> :CocList buffers<CR>
nnoremap <leader>w :CocList windows<CR>
nnoremap <leader>t :CocList tags<CR>
nnoremap <leader>T :CocCommand tags.generate<CR>
nnoremap <leader>r :CocList grep<CR>
nnoremap <leader>y :CocList yank<CR>
nmap     <leader>i <Plug>(coc-references)
nmap     <leader>I <Plug>(coc-implementation)
nmap     <leader>a <Plug>(coc-diagnostic-next)
nmap     <leader>A <Plug>(coc-diagnostic-prev)
nnoremap <leader>s :CocList gstatus<CR>
nmap     <leader>d <Plug>(coc-definition)
nnoremap <leader>D :CocList diagnostics<CR>
nnoremap <leader>f :CocList files<CR>
nnoremap <leader>F :CocList gfiles<CR>
nnoremap <leader>g :CocList bcommits<CR>
nnoremap <leader>G :CocList commits<CR>
nnoremap <leader>h :CocList mru<CR>
nnoremap <leader>j :CocList<CR>
nnoremap <leader>k :close<CR>
nnoremap <leader>K :bdelete<CR>
nnoremap <leader>l :CocList words<CR>
nnoremap <leader>c :CocList changes<CR>
nnoremap <leader>m :CocList marks<CR>

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
