" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
"                      .
"      ##############..... ##############
"     _#| |####/  _(_).....(_) |#####| |#   _
"    / _` |/ _ \ |#| | '_ \| | __/ _ \ | | | |
"   | (_| |  __/  _| | | | | | |#  __/ | |_| |
"    \__,_|\___|_|#|_|_| |_|_|\__\___|_|\__, |
"        ##########_...._##| ###..      |___/
"        ######| '_ \./ _ \| __|.....
"      ..######| |#| | (#) | |_.........
"    ....######|_|#|_|\___/#\__|..........
"      ..################JJJ............
"        ################.............
"        ##############.JJJ.JJJJJJJJJJ
"        ############...JJ...JJ..JJ  JJ
"        ##########....JJ...JJ..JJ  JJ
"        ########......JJJ..JJJ JJJ JJJ
"        ######    .........
"                    .....
"                      .
"
" Fully XDG base directory spec complaint ".vimrc" (definitely not vimrc)
" configuration aiming for a small footprint, self-contained, declarative and most
" important CLEAN `$HOME`. "Tidy $HOME, Tidy Mind"
"
" Definitely not Vim is a modern adaptation of [spf13/spf13-vim](https://github.com/spf13/spf13-vim).
" Including XDG base directory, updated [plugins](plugins.vim) sources and the
" plugin management with [vim-plug](https://github.com/junegunn/vim-plug)
" }

" Environment {

" XDG base directory specification support {
if empty($XDG_CONFIG_HOME)
    let $XDG_CONFIG_HOME = expand('~/.config')
endif
if empty($XDG_DATA_HOME)
    let $XDG_DATA_HOME = expand('~/.local/share')
endif
if empty($XDG_CACHE_HOME)
    let $XDG_CACHE_HOME = expand('~/.cache')
endif
let g:dnotvim_config_home = expand('<sfile>:p:h')
" Include user plugins and Vim's system runtime without discarding either.
execute 'set runtimepath^=' . escape(g:dnotvim_config_home, ' ,')
execute 'set runtimepath+=' . escape(g:dnotvim_config_home . '/after', ' ,')
let g:xdg_configs = {
    \ 'undo': $XDG_DATA_HOME . '/vim/undo',
    \ 'directory': $XDG_DATA_HOME . '/vim/swap',
    \ 'backup': $XDG_DATA_HOME . '/vim/backup',
    \ 'view': $XDG_CACHE_HOME . '/vim/view',
    \ 'info': $XDG_CACHE_HOME . '/vim/info',
    \ 'after': g:dnotvim_config_home . '/after',
    \ }

if (has('win32') || has('win64')) " Windows bad
    set runtimepath+=$XDG_CONFIG_HOME/vim/vimfiles,$XDG_CONFIG_HOME/vim/vimfiles/after
else
    set shell=/bin/sh
endif

" Arrow key workaround
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
endif
" }

" Use before config if available {
if filereadable(g:dnotvim_config_home . '/before.vim')
    execute 'source ' . fnameescape(g:dnotvim_config_home . '/before.vim')
endif
" }

" Use plugins config {
if filereadable(g:dnotvim_config_home . '/plugins.vim')
    execute 'source ' . fnameescape(g:dnotvim_config_home . '/plugins.vim')
endif
" }

" General {
set background=dark
set nospell

filetype plugin indent on " Automatically detect file types.

syntax on " Syntax highlighting

set termguicolors
if has('mac') || has('macunix') || has('gui_macvim') ||
            \ (has('unix') && substitute(system('uname -s'), '\n', '', 'g') ==# 'Darwin')
    set clipboard=unnamed
elseif has('unix') && substitute(system('uname -s'), '\n', '', 'g') ==# 'Linux'
    set clipboard=unnamedplus
endif

scriptencoding utf-8
set encoding=utf-8

set mouse=a " Automatically enable mouse usage
set mousehide " Hide the mouse cursor while typing

colorscheme retrowave

" let g:dnotvim_no_autochdir = 1
if !exists('g:dnotvim_no_autochdir')
    augroup dnotvim_directory
        autocmd!
        autocmd BufEnter * if &buftype ==# '' && !empty(expand('%:p')) && bufname('') !~# '^\w\+://'
                    \ | execute 'lcd ' . fnameescape(expand('%:p:h')) | endif
    augroup END
    " Always switch to the current file directory
endif

set autowrite                       " Automatically write a file when leaving a modified buffer
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,cursor,unix,slash " Restore views without overriding filetype/EditorConfig options
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set hidden                          " Allow buffer switching without saving
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
" To disable this, add the following to your .vimrc.before.local file:
"   let g:dnotvim_no_restore_cursor = 1
if !exists('g:dnotvim_no_restore_cursor')
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
endif

" Setting up the directories {
set backup                  " Backups are nice ...
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" To disable views add the following to your .vimrc.before.local file:
"   let g:dnotvim_no_views = 1
if !exists('g:dnotvim_no_views')
    " Add exclusions to mkview and loadview
    " eg: *.*, svn-commit.tmp
    let g:skipview_files = get(g:, 'skipview_files', [])
endif
" }
" }

" Vim UI {
set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode

set cursorline                  " Highlight current line

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
" Remove trailing whitespaces and ^M chars
" To disable the stripping of whitespace, add the following to your
" .vimrc.before.local file:
"   let g:dnotvim_keep_trailing_whitespace = 1

augroup dnotvim_whitespace
    autocmd!
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yaml,perl,sql
                \ autocmd! dnotvim_whitespace BufWritePre <buffer>
                \ if !exists('g:dnotvim_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
augroup END

" following lines would better fit a plugin.
autocmd BufEnter *.html.twig set filetype=html.twig
autocmd BufEnter *.coffee set filetype=coffee syntax=coffee
autocmd BufEnter *.tf,*.tfvars set syntax=terraform
autocmd BufEnter *.kt set syntax=kotlin
autocmd BufEnter *.yaml,*.yml set syntax=yaml

autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType json setlocal conceallevel=2 concealcursor=
autocmd FileType go setlocal ts=4 noexpandtab
autocmd FileType yaml,javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType terraform setlocal commentstring=#%s
autocmd FileType haskell setlocal commentstring=--\ %s
" }

" Key (re)Mappings {
" The default leader is '\', but ',' is prefered, since it's in a standard
" location between keyboard layouts. To overwrite set 'g:dnotvim_leader'.
if !exists('g:dnotvim_leader')
    let mapleader = ','
else
    let mapleader=g:dnotvim_leader
endif

if !exists('g:dnotvim_localleader')
    let maplocalleader = '_'
else
    let maplocalleader=g:dnotvim_localleader
endif

" The default mappings for editing and applying the dnotvim configuration
" are <leader>ev and <leader>sv respectively. Change them in before.vim
"   let g:dnotvim_edit_config_mapping='<leader>ec'
"   let g:dnotvim_apply_config_mapping='<leader>sc'
if !exists('g:dnotvim_edit_config_mapping')
    let s:dnotvim_edit_config_mapping = '<leader>ev'
else
    let s:dnotvim_edit_config_mapping = g:dnotvim_edit_config_mapping
endif
if !exists('g:dnotvim_apply_config_mapping')
    let s:dnotvim_apply_config_mapping = '<leader>sv'
else
    let s:dnotvim_apply_config_mapping = g:dnotvim_apply_config_mapping
endif

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Default vim behaviour is to act relative to text line in both cases
"
" If you prefer the default behaviour, put the following in before.vim
" let g:dnotvim_no_wrapRelMotion = 1
if !exists('g:dnotvim_no_wrapRelMotion')
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>

    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>

    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
endif

" The following two lines conflict with moving to top and
" bottom of the screen
" If you prefer that functionality:
"   let g:dnotvim_no_fastTabs = 1
if !exists('g:dnotvim_no_fastTabs')
    map <S-H> gT
    map <S-L> gt
endif

" Stupid shift key fixes
if !exists('g:dnotvim_no_keyfixes')
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe
endif

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Most prefer to toggle search highlighting rather than clear the current
" search results. To clear search highlighting rather than toggle it on
" and off:
"   let g:dnotvim_clear_search_highlight = 1
if exists('g:dnotvim_clear_search_highlight')
    nmap <silent> <leader>/ :nohlsearch<CR>
else
    nmap <silent> <leader>/ :set invhlsearch<CR>
endif

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting does not exit Visual mode
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier horizontal scrolling
map zl zL
map zh zH

" Easier formatting
nnoremap <silent> <leader>q gwip

" FIXME: Revert this f70be548
" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }

" Plugins {
if count(g:dnotvim_plugin_groups, 'general') && !empty(globpath(&runtimepath, 'autoload/lexima.vim'))
    " Initialize lazy mappings before restoring native Backspace behavior.
    call lexima#init()
    inoremap <BS> <BS>
endif

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
if count(g:dnotvim_plugin_groups, 'haskell')
    let g:ale_linters = extend(get(g:, 'ale_linters', {}), {'haskell': ['hls']}, 'keep')
    autocmd FileType haskell setlocal omnifunc=ale#completion#OmniFunc
endif
if count(g:dnotvim_plugin_groups, 'neocomplete')
    let g:mucomplete#enable_auto_at_startup = 1
    set completeopt=menuone,noinsert,noselect
endif


" GoLang {
if count(g:dnotvim_plugin_groups, 'go')
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = "goimports"
    let g:ale_linters = extend(get(g:, 'ale_linters', {}), {'go': ['gopls']}, 'keep')
    au FileType go nmap <Leader>s <Plug>(go-implements)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>e <Plug>(go-rename)
    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <leader>co <Plug>(go-coverage)
endif
" }

" TextObj Sentence {
if count(g:dnotvim_plugin_groups, 'writing')
    augroup textobj_sentence
        autocmd!
        autocmd FileType markdown call textobj#sentence#init()
        autocmd FileType textile call textobj#sentence#init()
        autocmd FileType text call textobj#sentence#init()
    augroup END
endif
" }

" TextObj Quote {
if count(g:dnotvim_plugin_groups, 'writing')
    augroup textobj_quote
        autocmd!
        autocmd FileType markdown call textobj#quote#init()
        autocmd FileType textile call textobj#quote#init()
        autocmd FileType text call textobj#quote#init({'educate': 0})
    augroup END
endif
" }

" Misc {
if exists('g:loaded_matchit')
    let b:match_ignorecase = 1
endif
" }

" OmniComplete {
" To disable omni complete, add the following to your .vimrc.before.local file:
"   let g:dnotvim_no_omni_complete = 1
if !exists('g:dnotvim_no_omni_complete')
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
    endif

    hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    " Some convenient mappings
    "inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
    if exists('g:dnotvim_map_cr_omni_complete')
        inoremap <expr> <CR>     pumvisible() ? "\<C-y>" : "\<CR>"
    endif
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

    " Automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    if !count(g:dnotvim_plugin_groups, 'neocomplete')
        set completeopt=menu,preview,longest
    endif
endif
" }

" AutoCloseTag {
" Make it so AutoCloseTag works for xml and xhtml files as well
if count(g:dnotvim_plugin_groups, 'html')
    " Emmet supplies the existing tag completion/editing functionality.
    nmap <Leader>ac <Plug>(emmet-update-tag)
endif
" }

" Fern {
if has_key(get(g:, 'plugs', {}), 'vim-fern')
    let g:fern#default_hidden = 1
    let g:fern#default_exclude = '\%(^\|/\)\%(\.git\|\.hg\|\.svn\|\.bzr\)$\|\.py[cd]$\|\~$\|\.sw[op]$'
    let g:fern#disable_drawer_tabpage_isolation = 1
    let g:fern#scheme#bookmark#store#file = $XDG_DATA_HOME . '/vim/fern-bookmarks.json'
    nnoremap <silent> <C-e> :Fern . -drawer -toggle<CR>
    nnoremap <silent> <leader>e :call DnotvimRevealFile()<CR>
    nnoremap <silent> <leader>nt :call DnotvimRevealFile()<CR>
endif
" }

" Tabularize {
if has_key(get(g:, 'plugs', {}), 'tabular')
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    nmap <Leader>a=> :Tabularize /=><CR>
    vmap <Leader>a=> :Tabularize /=><CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif
" }

" Session List {
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
if has_key(get(g:, 'plugs', {}), 'sessionman.vim')
    nmap <leader>sl :SessionList<CR>
    nmap <leader>ss :SessionSave<CR>
    nmap <leader>sc :SessionClose<CR>
endif
" }

" fzf {
if has_key(get(g:, 'plugs', {}), 'fzf.vim')
    if executable('rg') && empty($FZF_DEFAULT_COMMAND)
        let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g !.git'
    endif
    nnoremap <silent> <C-p> :call DnotvimFindFiles()<CR>
    nnoremap <silent> <D-t> :call DnotvimFindFiles()<CR>
    nnoremap <silent> <D-r> :History<CR>
    nnoremap <silent> <leader>fu :BTags<CR>
endif
" }

" Rainbow demiliters {
if has_key(get(g:, 'plugs', {}), 'rainbow')
    let g:rainbow_active = 1
endif
"}

" Fugitive (Git) {
if has_key(get(g:, 'plugs', {}), 'vim-fugitive')
    nnoremap <silent> <leader>gs :Git<CR>
    nnoremap <silent> <leader>gd :Gdiffsplit<CR>
    nnoremap <silent> <leader>gc :Git commit<CR>
    nnoremap <silent> <leader>gb :Git blame<CR>
    nnoremap <silent> <leader>gl :Gclog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
endif
"}

" YouCompleteMe {
if count(g:dnotvim_plugin_groups, 'youcompleteme')
    let g:acp_enableAtStartup = 0

    " enable completion from tags
    let g:ycm_collect_identifiers_from_tags_files = 1

    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = '<C-j>'
    let g:UltiSnipsJumpForwardTrigger = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

    set completeopt-=preview
endif
" }

" Lightline {
if has_key(get(g:, 'plugs', {}), 'lightline.vim')
    let g:lightline = extend({
                \ 'colorscheme': 'retrowave',
                \ 'active': {
                \     'left': [['mode', 'paste'], ['branch', 'readonly', 'filename', 'modified']],
                \     'right': [['lineinfo'], ['percent'], ['diagnostics', 'fileformat', 'fileencoding', 'filetype']],
                \ },
                \ 'component_function': {'branch': 'DnotvimGitBranch', 'diagnostics': 'DnotvimDiagnostics'},
                \ 'tabline': {'left': [['buffers']], 'right': [['tabs']]},
                \ 'component_expand': {'buffers': 'DnotvimBufferNames'},
                \ 'component_type': {'buffers': 'tabsel'},
                \ }, get(g:, 'lightline', {}), 'force')
    set showtabline=2
endif
" }

" Functions {

" Initialize directories {
function! InitializeXDGDirectories()
    for dirname in [g:xdg_configs.directory, g:xdg_configs.backup,
                \ g:xdg_configs.view, fnamemodify(g:xdg_configs.info, ':h'), g:xdg_configs.undo]
        if !isdirectory(dirname)
            call mkdir(dirname, 'p', 0700)
        endif
    endfor
    let &undodir = g:xdg_configs.undo . '//'
    let &directory = g:xdg_configs.directory . '//'
    let &backupdir = g:xdg_configs.backup . '//'
    let &viewdir = g:xdg_configs.view
    let &viminfo = "'1000,n" . g:xdg_configs.info
endfunction
call InitializeXDGDirectories()
" }

" File navigation and statusline helpers {
function! DnotvimProjectRoot()
    let directory = getcwd()
    while 1
        for marker in ['.git', '.hg', '.svn', '.bzr']
            if isdirectory(directory . '/' . marker) || filereadable(directory . '/' . marker)
                return directory
            endif
        endfor
        let parent = fnamemodify(directory, ':h')
        if parent ==# directory
            return getcwd()
        endif
        let directory = parent
    endwhile
endfunction

function! DnotvimFindFiles()
    execute 'Files ' . fnameescape(DnotvimProjectRoot())
endfunction

function! DnotvimRevealFile()
    let current_file = expand('%:p')
    execute 'Fern . -drawer' . (empty(current_file) || &buftype !=# ''
                \ ? '' : ' -reveal=' . fnameescape(current_file))
endfunction

function! DnotvimGitBranch()
    return exists('*FugitiveHead') ? FugitiveHead() : ''
endfunction

function! DnotvimDiagnostics()
    if !exists('*ale#statusline#Count')
        return ''
    endif
    let counts = ale#statusline#Count(bufnr(''))
    return counts.total ? printf('E:%d W:%d', counts.error + counts.style_error,
                \ counts.warning + counts.style_warning) : ''
endfunction

function! DnotvimBufferNames()
    let names = [[], [], []]
    let section = 0
    for buffer in getbufinfo({'buflisted': 1})
        if buffer.name =~# '^fern://'
            continue
        endif
        let current = buffer.bufnr == bufnr('')
        let name = empty(buffer.name) ? '[No Name]' : fnamemodify(buffer.name, ':t')
        call add(names[current ? 1 : section], printf('%d:%s%s', buffer.bufnr, name, buffer.changed ? '+' : ''))
        if current
            let section = 2
        endif
    endfor
    return names
endfunction
" }

" Views use Vim's built-in persistence rather than a wrapper plugin.
function! DnotvimCanSaveView()
    if exists('g:dnotvim_no_views') || &buftype !=# '' || &diff || !&modifiable || !filereadable(expand('%:p'))
        return 0
    endif
    if expand('%') =~# '\[.*\]' || (!empty($TEMP) && expand('%:p:h') ==# $TEMP)
                \ || (!empty($TMP) && expand('%:p:h') ==# $TMP)
        return 0
    endif
    for pattern in get(g:, 'skipview_files', [])
        if expand('%:p') =~# pattern
            return 0
        endif
    endfor
    return 1
endfunction

augroup dnotvim_views
    autocmd!
    autocmd BufWritePre,BufWinLeave ?* if DnotvimCanSaveView() | silent! mkview | endif
    autocmd BufWinEnter ?* if DnotvimCanSaveView() | silent! loadview | endif
augroup END

" Strip whitespace {
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }
" }
