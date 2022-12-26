" Set statusline{{{
set statusline=
set statusline+=%{lines#StatuslineGit()}
set statusline+=%{lines#Path()}  " set statusline+=%f
set statusline+=%{lines#Spaces(1)}
set statusline+=%{lines#BufferStatus()}
set statusline+=%=
set statusline+=%{lines#LineInfo()}
set statusline+=%{lines#Spaces(1)}
set statusline+=--
set statusline+=%{lines#Spaces(1)}
set statusline+=%{lines#LinePercent()}
set statusline+=%{lines#Spaces(10)}
set statusline+=%{&filetype!=#''?&filetype:'none'}
"}}}


" Set tabline{{{
set tabline=%!lines#TabStatus()
"}}}
