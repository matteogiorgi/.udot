# Tokyonight theme

# Colors

# base
declare-option -hidden str fg "a9b1d6"
declare-option -hidden str bg "000000"
declare-option -hidden str comment "565f89"

# syntax
declare-option -hidden str white "c0caf5"
declare-option -hidden str grey "9aa5ce"
declare-option -hidden str red "f7768e"
declare-option -hidden str orange "ff9e64"
declare-option -hidden str yellow "e0af68"
declare-option -hidden str green "9ece6a"
declare-option -hidden str darkcyan "2ac3de"
declare-option -hidden str cyan "73daca"
declare-option -hidden str lightcyan "b4f9f8"
declare-option -hidden str darkblue "7aa2f7"
declare-option -hidden str magenta "bb9af7"
declare-option -hidden str blue "7dcfff"

declare-option -hidden str cursoralpha "80"
declare-option -hidden str selectionalpha "40"

# Menus do not support transparency (hardcoded colors)
declare-option -hidden str menufg "cfc9c2"
declare-option -hidden str menubg "1a1b26"

# HL Syntax
face global attribute "rgb:%opt{magenta}"
face global builtin "rgb:%opt{lightcyan}"
face global comment "rgb:%opt{comment}"
face global documentation "rgb:%opt{comment}"
face global enum "rgb:%opt{red}"
face global function "rgb:%opt{darkblue}"
face global keyword "rgb:%opt{red}"
face global meta "rgb:%opt{fg}"
face global module "rgb:%opt{blue}"
face global operator "rgb:%opt{magenta}"
face global parameter "rgb:%opt{yellow}"
face global string "rgb:%opt{green}"
face global type "rgb:%opt{magenta}"
face global value "rgb:%opt{orange}"
face global variable "rgb:%opt{white}"

# HL Marku
face global block "rgb:%opt{blue}"
face global bullet "rgb:%opt{comment}"
face global header "rgb:%opt{blue}"
face global link "rgb:%opt{cyan}"
face global list "rgb:%opt{fg}"
face global mono "rgb:%opt{fg}"
face global title "rgb:%opt{white}"

# HL Builtin
face global BufferPadding "rgb:%opt{bg},rgb:%opt{bg}"
face global Default "rgb:%opt{fg},rgb:%opt{bg}"
face global PrimarySelection "default,rgba:%opt{magenta}%opt{selectionalpha}"
face global SecondarySelection "default,rgba:%opt{green}%opt{selectionalpha}"
face global PrimaryCursor "default,rgba:%opt{blue}%opt{cursoralpha}"
face global SecondaryCursor "default,rgba:%opt{green}%opt{cursoralpha}"
face global PrimaryCursorEol "default,rgba:%opt{red}%opt{cursoralpha}"
face global SecondaryCursorEol "default,rgba:%opt{orange}%opt{cursoralpha}"
face global LineNumbers "rgb:%opt{comment}"
face global LineNumberCursor "rgb:%opt{orange}"
face global LineNumbersWrapped "rgb:%opt{bg},rgb:%opt{bg}"
face global MenuForeground "rgb:%opt{menubg},rgb:%opt{yellow}"
face global MenuBackground "rgb:%opt{menufg},rgb:%opt{menubg}"
face global MenuInfo "rgb:%opt{green}"
face global Information "rgb:%opt{fg},rgb:%opt{comment}"
face global Error "rgb:%opt{red}"
face global StatusLine "rgb:%opt{fg},rgb:%opt{menubg}"
face global StatusLineMode "rgb:%opt{orange}"
face global StatusLineInfo "rgb:%opt{blue}"
face global StatusLineValue "rgb:%opt{fg}"
face global StatusCursor "default,rgba:%opt{blue}%opt{cursoralpha}"
face global Prompt "rgb:%opt{yellow}"
face global MatchingChar "default,rgb:%opt{comment}"
face global BufferPadding "rgb:%opt{bg},rgb:%opt{bg}"
face global Whitespace "rgb:%opt{comment}"

# HL Infoboxes
face global InfoDefault Information
face global InfoBlock block
face global InfoBlockQuote block
face global InfoBullet bullet
face global InfoHeader header
face global InfoLink link
face global InfoLinkMono header
face global InfoMono mono
face global InfoRule comment
face global InfoDiagnosticError InlayDiagnosticError
face global InfoDiagnosticHint InlayDiagnosticHint
face global InfoDiagnosticInformation InlayDiagnosticInfo
face global InfoDiagnosticWarning InlayDiagnosticWarning

