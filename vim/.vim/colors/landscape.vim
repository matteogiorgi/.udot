" landscape.vim - Vim color scheme
"
" check Xterm256 color names for console Vim at:
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
"
" ----------------------------------------------------------
" Authors:  Itchyny       (https://github.com/itchyny/)
"           Matteo Giorgi (https://www.geoteo.net/)
" License:  Creative Commons Attribution-NonCommercial
"           3.0 Unported License       (see README.md)
" ----------------------------------------------------------


set background=dark
highlight clear

let g:colors_name = 'landscape'
if exists('syntax_on')
    syntax reset
endif

highlight Normal gui=none guifg=#dddddd guibg=black
highlight Comment term=none ctermfg=243 ctermbg=none gui=none guifg=#767676
highlight Constant term=none ctermfg=111 gui=none guifg=#87afff
highlight String term=none ctermfg=215 ctermbg=none gui=none guifg=#ffaf5f
highlight Character term=none ctermfg=214 ctermbg=none gui=none guifg=#ffaf00
highlight Number term=none ctermfg=81 ctermbg=none gui=none guifg=#5fdfff
highlight Boolean term=none ctermfg=227 ctermbg=none gui=none guifg=#ffff5f
highlight Float term=none ctermfg=85 ctermbg=none gui=none guifg=#5fffaf

highlight Identifier term=none cterm=none ctermfg=117 ctermbg=none gui=none guifg=#87dfff
highlight Function term=none ctermfg=123 ctermbg=none gui=none guifg=#5fffff

highlight Statement term=none ctermfg=76 ctermbg=none gui=none guifg=#5fdf00
highlight Conditional term=none ctermfg=166 ctermbg=none gui=none guifg=#ef7f00
highlight default link Repeat Statement
highlight default link Label Statement
highlight Operator term=none ctermfg=220 ctermbg=none gui=none guifg=#ffdf00
highlight default link Keyword Statement
highlight default link Exception Statement

highlight PreProc term=none ctermfg=39 gui=none guifg=#00afff
highlight Include term=none ctermfg=38 gui=none guifg=#00afdf
highlight Define term=none ctermfg=37 gui=none guifg=#00afaf
highlight Macro term=none ctermfg=36 gui=none guifg=#00af87
highlight PreCondit term=none ctermfg=35 gui=none guifg=#00af5f

highlight Type term=none ctermfg=207 ctermbg=none gui=none guifg=#ff9fff
highlight StorageClass term=none ctermfg=201 ctermbg=none gui=none guifg=#ff7fff
highlight Structure term=none ctermfg=200 ctermbg=none gui=none guifg=#ff7fdf
highlight Typedef term=none ctermfg=199 ctermbg=none gui=none guifg=#ff7faf

highlight Special term=none ctermfg=178 gui=none guifg=orange
highlight SpecialChar term=none ctermfg=208 gui=none guifg=orange
highlight Tag term=none ctermfg=180 gui=none guifg=orange
highlight Delimiter term=none ctermfg=181 gui=none guifg=orange
highlight SpecialComment term=none ctermfg=182 gui=none guifg=violet
highlight Debug term=none ctermfg=183 gui=none guifg=violet

highlight TabLine ctermfg=246 ctermbg=233 cterm=bold guifg=#999999 guibg=#111111 gui=bold
highlight TabLineFill ctermfg=233 ctermbg=233 cterm=none guifg=#111111 guibg=#111111 gui=none
highlight TabLineSel cterm=bold ctermfg=255 guifg=#eeeeee
highlight Visual term=none ctermbg=240 guibg=#585858
highlight default link VisualNOS Visual
highlight Underlined term=underline ctermfg=45 gui=underline guifg=#00dfff
highlight Error term=none ctermfg=15 ctermbg=124 gui=none guifg=#ffffff guibg=#af0000
highlight WarningMsg term=none ctermfg=7 ctermbg=0 gui=none guifg=#c0c0c0 guibg=#000000
highlight WildMenu guibg=#ffaf00 ctermbg=214
highlight Todo cterm=none ctermfg=185 ctermbg=none gui=none guifg=#dfdf5f guibg=NONE
highlight DiffAdd term=none cterm=none ctermfg=none ctermbg=22 guifg=fg guibg=#005f00
highlight DiffChange term=none cterm=none ctermfg=none ctermbg=52 guifg=fg guibg=#5f0000
highlight DiffDelete term=none cterm=none ctermfg=none ctermbg=88 guifg=fg guibg=#870000
highlight DiffText term=none cterm=none ctermfg=none ctermbg=160 guifg=fg guibg=#df0000
highlight DiffFile term=none cterm=none ctermfg=47 ctermbg=none guifg=#00ff5f guibg=bg
highlight DiffNewFile term=none cterm=none ctermfg=199 ctermbg=none guifg=#ff00af guibg=bg
highlight default link DiffRemoved DiffDelete
highlight DiffLine term=none cterm=none ctermfg=129 ctermbg=none guifg=#af00ff guibg=bg
highlight default link DiffAdded DiffAdd
highlight default link ErrorMsg Error
highlight Ignore ctermbg=none gui=none guifg=bg
highlight ModeMsg ctermfg=none guifg=bg guibg=bg

highlight VertSplit term=none gui=none guifg=#111111 guibg=black gui=bold ctermfg=233 ctermbg=black cterm=bold
highlight Folded term=none ctermfg=247 ctermbg=235 guifg=#9e9e9e guibg=#262626
highlight FoldColumn term=none ctermfg=247 ctermbg=235 guifg=#9e9e9e guibg=#262626
highlight SignColumn term=none ctermfg=247 ctermbg=235 guifg=#9e9e9e guibg=#262626
highlight SpecialKey term=underline ctermfg=237 gui=none guifg=darkgray
highlight NonText term=none ctermfg=black gui=none guifg=black
highlight StatusLine term=none gui=none guifg=#eeeeee guibg=#111111 gui=bold ctermfg=255 ctermbg=233 cterm=bold
highlight StatusLineNC term=none gui=none guifg=#999999 guibg=#111111 gui=bold ctermfg=246 ctermbg=233 cterm=bold
if get(g:, 'landscape_cursorline', 1)
    highlight CursorLine term=none cterm=none ctermbg=233 gui=none guibg=#111111
else
    highlight clear CursorLine
endif
highlight CursorLineNr term=none cterm=bold ctermbg=none gui=bold guibg=NONE
highlight ColorColumn term=none cterm=none ctermbg=239 gui=none guibg=#4e4e4e
highlight Cursor term=reverse cterm=reverse gui=reverse guifg=NONE guibg=NONE
highlight CursorColumn term=none cterm=none ctermbg=235 gui=none guibg=#262626
highlight LineNr term=none ctermfg=58 ctermbg=none guifg=#5f5f00 guibg=bg
highlight MatchParen ctermfg=none ctermbg=238 guibg=#4e4e4e
highlight Pmenu ctermfg=233 ctermbg=249 gui=none guifg=#121212 guibg=#b2b2b2
highlight PmenuSel ctermfg=233 ctermbg=242 gui=none guifg=#121212 guibg=#666666
highlight PmenuSbar ctermfg=233 ctermbg=244 gui=none guifg=#121212 guibg=#808080
highlight PmenuThumb ctermfg=233 ctermbg=239 gui=none guifg=#121212 guibg=#4e4e4e
highlight Search cterm=reverse ctermfg=178 ctermbg=236 gui=reverse guifg=#dfaf00 guibg=#303030
highlight IncSearch cterm=reverse ctermfg=136 ctermbg=236 gui=reverse guifg=#af8700 guibg=#303030
highlight QuickFixLine cterm=bold ctermfg=none ctermbg=none gui=bold guifg=NONE guibg=NONE
highlight SpellBad term=none cterm=none ctermbg=52 gui=none guibg=#5f0000
highlight default link SpellCap SpellBad
highlight default link SpellLocal SpellBad
highlight default link SpellRare SpellBad

if exists('##CmdlineEnter')
    highlight IncSearch cterm=reverse ctermfg=178 ctermbg=236 gui=reverse guifg=#dfaf00 guibg=#303030
    augroup landscape-highlight-search
        autocmd!
        autocmd CmdlineEnter /,\? :highlight Search cterm=reverse ctermfg=100 ctermbg=236 gui=reverse guifg=#878700 guibg=#303030
        autocmd CmdlineLeave /,\? :highlight Search cterm=reverse ctermfg=178 ctermbg=236 gui=reverse guifg=#dfaf00 guibg=#303030
    augroup END
endif

" Conceal
" CursorIM
" Directory
" ModeMsg
" MoreMsg
" Question
