set background=dark
colorscheme gruvbox


highlight! Normal       ctermbg=NONE  guibg=NONE
highlight! Visual       ctermbg='24'  guibg='#076678' cterm=NONE gui=NONE
highlight! ColorColumn  ctermbg='234' guibg='#1d2021'
highlight! CursorLine   ctermbg='234' guibg='#1d2021'
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
