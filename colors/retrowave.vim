" Colorscheme inspired on thor. Best dark theme ever.
" Functions and code design inspired on nord-vim.

set background=dark

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

let g:colors_name = "retrowave"

let s:black_hex		 = "#111111"
let s:red_hex		 = "#F84672"
let s:blue_hex		 = "#00AAF9"
let s:magenta_hex	 = "#FC71FF"
let s:cyan_hex		 = "#00FCF8"
let s:lightgray_hex  = "#949C94"
let s:darkgray_hex	 = "#666666"
let s:lightgreen_hex = "#00FFBB"
let s:lightblue_hex  = "#00FCF8"
let s:lightcyan_hex  = "#4DEEDD"
let s:white_hex		 = "#FBF1C7"

if (exists("g:retrowave_default_termcolors") && g:retrowave_default_termcolors)
	let s:black_term		= "0"
	let s:red_term			= "1"
	let s:blue_term			= "4"
	let s:magenta_term		= "5"
	let s:cyan_term			= "6"
	let s:lightgray_term	= "7"
	let s:darkgray_term		= "8"
	let s:lightgreen_term	= "10"
	let s:lightblue_term	= "12"
	let s:lightcyan_term	= "14"
	let s:white_term		= "15"
else
	let s:black_term		= "234"
	let s:red_term			= "204"
	let s:blue_term			= "39"
	let s:magenta_term		= "207"
	let s:cyan_term			= "87"
	let s:lightgray_term	= "230"
	let s:darkgray_term		= "241"
	let s:lightgreen_term	= "49"
	let s:lightblue_term	= "87"
	let s:lightcyan_term	= "87"
	let s:white_term		= "255"
endif

"+- Neovim Terminal Colors -+
if has('nvim')
	let g:terminal_color_0	= s:black_hex
	let g:terminal_color_1	= s:red_hex
	let g:terminal_color_2	= s:red_hex
	let g:terminal_color_3	= s:cyan_hex
	let g:terminal_color_4	= s:blue_hex
	let g:terminal_color_5	= s:magenta_hex
	let g:terminal_color_6	= s:cyan_hex
	let g:terminal_color_7	= s:lightgreen_hex
	let g:terminal_color_8	= s:darkgray_hex
	let g:terminal_color_9	= s:red_hex
	let g:terminal_color_10 = s:lightgreen_hex
	let g:terminal_color_11 = s:lightgreen_hex
	let g:terminal_color_12 = s:lightblue_hex
	let g:terminal_color_13 = s:magenta_hex
	let g:terminal_color_14 = s:lightcyan_hex
	let g:terminal_color_15 = s:white_hex
endif

"+- Vim 8 Terminal Colors -+
if has('terminal')
	let g:terminal_ansi_colors = [
				\ s:black_hex,
				\ s:red_hex,
				\ s:red_hex,
				\ s:cyan_hex,
				\ s:blue_hex,
				\ s:magenta_hex,
				\ s:cyan_hex,
				\ s:lightgreen_hex,
				\ s:darkgray_hex,
				\ s:red_hex,
				\ s:lightgreen_hex,
				\ s:lightgreen_hex,
				\ s:lightblue_hex,
				\ s:magenta_hex,
				\ s:lightcyan_hex,
				\ s:white_hex,
				\ ]
endif

set t_Co=256 " Enable 256 colors

function! s:hi(group, guifg, guibg, ctermfg, ctermbg, attr)
	if a:guifg != ""
		exec "hi " . a:group . " guifg=" . a:guifg
	endif
	if a:guibg != ""
		exec "hi " . a:group . " guibg=" . a:guibg
	endif
	if a:ctermfg != ""
		exec "hi " . a:group . " ctermfg=" . a:ctermfg
	endif
	if a:ctermbg != ""
		exec "hi " . a:group . " ctermbg=" . a:ctermbg
	endif
	if a:attr != ""
		exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
	endif
endfunction

" General colors
call s:hi("Normal", s:white_hex, "NONE", s:white_term, "NONE", "")
call s:hi("NonText", s:black_hex, "NONE", s:black_term, "NONE", "")
call s:hi("Cursor", "NONE", "NONE", "NONE", "NONE", "REVERSE")
call s:hi("LineNr", s:darkgray_hex, "NONE", s:darkgray_term, "NONE", "")
call s:hi("VertSplit", s:red_hex, s:black_hex, s:red_term, s:black_term, "BOLD")

call s:hi("StatusLine", s:black_hex, s:lightcyan_hex, s:black_term, s:lightcyan_term, "BOLD,REVERSE")
call s:hi("StatusLineNC", s:black_hex, s:red_hex, s:black_term, s:red_term, "REVERSE")
call s:hi("StatusLineTerm", s:lightcyan_hex, s:black_hex, s:lightcyan_term, s:black_term, "BOLD,REVERSE")
call s:hi("StatusLineTermNC", s:black_hex, s:red_hex, s:black_term, s:red_term, "REVERSE")

call s:hi("Directory", s:lightblue_hex, "NONE", s:lightblue_term, "NONE", "NONE")
call s:hi("Folded", s:white_hex, s:darkgray_hex, s:white_term, s:darkgray_term, "BOLD")
call s:hi("Visual", "NONE", "NONE", "NONE", "NONE", "REVERSE")
call s:hi("Search", "NONE", "NONE", "NONE", "NONE", "REVERSE,BOLD")
call s:hi("MatchParen", "NONE", "NONE", "NONE", "NONE", "REVERSE,BOLD")
call s:hi("SpecialKey", s:darkgray_hex, "NONE", s:darkgray_term, "NONE", "NONE")

call s:hi("PMenu", s:red_hex, s:black_hex, s:red_term, s:black_term, "NONE")
call s:hi("PmenuSbar", s:black_hex, s:white_hex, s:black_term, s:white_term, "NONE")
call s:hi("PmenuThumb", s:black_hex, s:lightcyan_hex, s:black_term, s:lightcyan_term, "NONE")
call s:hi("PMenuSel", s:lightcyan_hex, "", s:lightcyan_term, "", "REVERSE,BOLD")

call s:hi("Error", s:white_hex, s:red_hex, s:white_term, s:red_term, "UNDERCURL")
call s:hi("ErrorMsg", s:white_hex, s:red_hex, s:white_term, s:red_term, "BOLD")
call s:hi("WarningMsg", s:magenta_hex, s:black_hex, s:magenta_term, s:black_term, "BOLD")
call s:hi("WildMenu", s:black_hex, s:lightcyan_hex, s:black_term, s:lightcyan_term, "NONE")
call s:hi("ModeMsg", s:red_hex, s:black_hex, s:red_term, s:black_term, "BOLD")
call s:hi("MoreMsg", s:red_hex, s:black_hex, s:red_term, s:black_term, "BOLD")

"+- Neovim Support -+
call s:hi("healthError", s:red_hex, s:black_hex, s:red_term, s:black_term, "BOLD")
call s:hi("healthSuccess", s:lightcyan_hex, s:black_hex, s:lightcyan_term, s:black_term, "BOLD")
call s:hi("healthWarning", s:magenta_hex, s:black_hex, s:magenta_term, s:black_term, "BOLD")
call s:hi("TermCursorNC", "NONE", s:black_hex, "NONE", s:black_term, "NONE")

if version >= 700 " Vim 7.x specific colors
	call s:hi("CursorLine", "NONE", "NONE", "NONE", "NONE", "BOLD")
	call s:hi("CursorLineNr", s:lightcyan_hex, s:black_hex, s:lightcyan_term, s:black_term, "BOLD")
	call s:hi("CursorColumn", "NONE", "NONE", "NONE", "NONE", "BOLD")
	call s:hi("TabLine", s:black_hex, s:red_hex, s:black_term, s:red_term, "NONE")

	hi! link CursorColumn CursorLine
endif

call s:hi("Comment", s:darkgray_hex, "NONE", s:darkgray_term, "NONE", "NONE")
call s:hi("String", s:red_hex, "NONE", s:red_term, "NONE", "NONE")
call s:hi("Number", s:lightgreen_hex, "NONE", s:lightgreen_term, "NONE", "NONE")
call s:hi("Keyword", s:lightgreen_hex, "NONE", s:lightgreen_term, "NONE", "NONE")
call s:hi("PreProc", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("Conditional", s:red_hex, "NONE", s:red_term, "NONE", "NONE")

call s:hi("Todo", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("Constant", s:lightgreen_hex, "NONE", s:lightgreen_term, "NONE", "NONE")

call s:hi("Identifier", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("Function", s:lightgreen_hex, "NONE", s:lightgreen_term, "NONE", "BOLD")
call s:hi("Type", s:lightgreen_hex, "NONE", s:lightgreen_term, "NONE", "NONE")
call s:hi("Statement", s:red_hex, "NONE", s:red_term, "NONE", "NONE,BOLD")

call s:hi("Special", s:lightgray_hex, "NONE", s:lightgray_term, "NONE", "NONE")
call s:hi("Delimiter", s:lightblue_hex, "NONE", s:lightblue_term, "NONE", "NONE")
call s:hi("Operator", s:darkgray_hex, "NONE", s:darkgray_term, "NONE", "BOLD")

hi! link Character Constant
hi! link Boolean Constant
hi! link Float Number
hi! link Repeat Statement
hi! link Label Statement
hi! link Exception Statement
hi! link Include PreProc
hi! link Define PreProc
hi! link Macro PreProc
hi! link PreCondit PreProc
hi! link StorageClass Type
hi! link Structure Type
hi! link Typedef Type
hi! link Tag Special
hi! link SpecialChar Special
hi! link SpecialComment Special
hi! link Debug Special

if (exists("g:retrowave_rainbow_colors") && g:retrowave_rainbow_colors)
	" https://github.com/frazrepo/vim-rainbow
	let g:rainbow_guifgs = [ s:lightgreen_hex, s:red_hex, s:cyan_hex, s:magenta_hex ]
	let g:rainbow_ctermfgs = [ s:lightgreen_term, s:red_term, s:cyan_term, s:magenta_term ]

	" https://github.com/luochen1990/rainbow
	let g:rainbow_conf = {}
	let g:rainbow_conf.guifgs = g:rainbow_guifgs
	let g:rainbow_conf.ctermfgs = g:rainbow_ctermfgs
endif

" Ruby
let ruby_operators = 1

call s:hi("rubyEscape", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("rubyInterpolationDelimiter", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("rubyInterpolation", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("rubyControl", s:blue_hex, "NONE", s:blue_term, "NONE", "NONE")
call s:hi("rubyStringDelimiter", s:lightgreen_hex, "NONE", s:lightgreen_term, "NONE", "NONE")
call s:hi("rubyPredefinedVariable", s:white_hex, "NONE", s:white_term, "NONE", "NONE")
call s:hi("rubySymbol", s:lightcyan_hex, "NONE", s:lightcyan_term, "NONE", "NONE")
call s:hi("railsMethod", s:white_hex, "NONE", s:white_term, "NONE", "NONE")

hi! link rubyRegexp				Keyword
hi! link rubyRegexpDelimiter	Keyword
hi! link rubyClass				Keyword
hi! link rubyModule				Keyword
hi! link rubyKeyword			Keyword
hi! link rubyOperator			Operator
hi! link rubyIdentifier			Identifier
hi! link rubyInstanceVariable	Identifier
hi! link rubyGlobalVariable		Identifier
hi! link rubyClassVariable		Identifier

" Java
hi! link javaScopeDecl			Identifier
hi! link javaDocSeeTag			SpecialKey
hi! link javaCommentTitle		javaDocSeeTag
hi! link javaDocTags			javaDocSeeTag
hi! link javaDocParam			javaDocSeeTag
hi! link javaDocSeeTagParam		javaDocSeeTag
