colorscheme gruvbox
if exists('theme') && theme == 'light'
    set background=light
    highlight! Visual       ctermbg='109' guibg='#83a598' cterm=NONE gui=NONE
    highlight! ColorColumn  ctermbg='230' guibg='#f9f5d7'
    highlight! CursorLine   ctermbg='230' guibg='#f9f5d7'
else
    set background=dark
    highlight! Visual       ctermbg='24'  guibg='#076678' cterm=NONE gui=NONE
    highlight! ColorColumn  ctermbg='234' guibg='#1d2021'
    highlight! CursorLine   ctermbg='234' guibg='#1d2021'
endif


highlight! Normal       ctermbg=NONE  guibg=NONE
highlight! CursorLineNr ctermbg=NONE  guibg=NONE
highlight! SignColumn   ctermbg=NONE  guibg=NONE
highlight! VertSplit    ctermbg=NONE  guibg=NONE

highlight! GruvboxRedSign    ctermbg=NONE guibg=NONE
highlight! GruvboxGreenSign  ctermbg=NONE guibg=NONE
highlight! GruvboxYellowSign ctermbg=NONE guibg=NONE
highlight! GruvboxBlueSign   ctermbg=NONE guibg=NONE
highlight! GruvboxPurpleSign ctermbg=NONE guibg=NONE
highlight! GruvboxAquaSign   ctermbg=NONE guibg=NONE
highlight! GruvboxOrangeSign ctermbg=NONE guibg=NONE


if has_key(plugs, "lightline.vim")
    let g:lightline = { 'colorscheme': 'gruvbox' }
endif
