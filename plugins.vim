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

" Definitely not Vim is a modern adaptation of [spf13/spf13-vim](https://github.com/spf13/spf13-vim).
" Including XDG base directory, updated [plugins](plugins.vim) sources and the
" plugin management with [vim-plug](https://github.com/junegunn/vim-plug)
" }

" Bundles {
" Install vim-plug explicitly; missing plugins install on startup.
if !exists('*plug#begin') && empty(globpath(&runtimepath, 'autoload/plug.vim'))
    echo 'vim-plug is not installed; see README.md for setup.'
    finish
endif
call plug#begin($XDG_DATA_HOME . '/vim/plugged')

" In your .vimrc.before.local file
" list only the plugin groups you will use
if !exists('g:dnotvim_plugin_groups')
    let g:dnotvim_plugin_groups=['general', \
    'writing', \
    'neocomplete', \
    'programming', \
    'python', \
    'javascript', \
    'html', \
    'misc',]
endif

" General {
if count(g:dnotvim_plugin_groups, 'general')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

    Plug 'lambdalisue/vim-fern'
    Plug 'lambdalisue/fern-bookmark.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'rhysd/conflict-marker.vim'
    Plug 'cohama/lexima.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'vim-scripts/sessionman.vim', { 'on': [
                \ 'SessionOpen', 'SessionOpenLast', 'SessionClose', 'SessionList',
                \ 'SessionSave', 'SessionSaveAs', 'SessionShowLast'] }
    packadd! matchit

    Plug 'itchyny/lightline.vim'

    Plug 'easymotion/vim-easymotion'
    Plug 'mbbill/undotree', { 'on': ['UndotreeToggle', 'UndotreeShow', 'UndotreeHide', 'UndotreeFocus'] }
    Plug 'nathanaelkane/vim-indent-guides'

    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-abolish'
    Plug 'osyo-manga/vim-over'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-indent'
    Plug 'gcmt/wildfire.vim'
endif
" }

" Writing {
if count(g:dnotvim_plugin_groups, 'writing')
    if !count(g:dnotvim_plugin_groups, 'general')
        Plug 'kana/vim-textobj-user'
    endif
    Plug 'reedes/vim-litecorrect'
    Plug 'reedes/vim-textobj-sentence'
    Plug 'reedes/vim-textobj-quote'
    Plug 'reedes/vim-wordy'
endif
" }

" General Programming {
if count(g:dnotvim_plugin_groups, 'programming')
    " Asynchronous diagnostics; external checkers remain user-installed.
    Plug 'dense-analysis/ale'
    Plug 'tpope/vim-fugitive'
    Plug 'mattn/webapi-vim'
    Plug 'vim-scripts/dbext.vim'

    Plug 'mattn/gist-vim', { 'on': 'Gist' }
    Plug 'tpope/vim-commentary'
    Plug 'godlygeek/tabular'
    Plug 'luochen1990/rainbow'

    if executable('ctags')
        Plug 'preservim/tagbar', { 'on': ['TagbarToggle', 'TagbarOpen', 'TagbarClose'] }
    endif
endif
" }

" Infra {
if count(g:dnotvim_plugin_groups, 'infra')
    Plug 'LnL7/vim-nix'

    Plug 'bracki/vim-prometheus'
    Plug 'hashivim/vim-terraform'
endif
" }

" Snippets & AutoComplete {
if count(g:dnotvim_plugin_groups, 'snippets')
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
elseif count(g:dnotvim_plugin_groups, 'youcompleteme')
    Plug 'ycm-core/YouCompleteMe'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
elseif count(g:dnotvim_plugin_groups, 'neocomplete')
    " Keep the legacy group name for before.vim compatibility.
    Plug 'lifepillar/vim-mucomplete'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
endif
" }

" Python {
if count(g:dnotvim_plugin_groups, 'python')
    if !count(g:dnotvim_plugin_groups, 'programming') && !count(g:dnotvim_plugin_groups, 'haskell')
        Plug 'dense-analysis/ale'
    endif
    Plug 'davidhalter/jedi-vim'
endif
" }

" Javascript {
if count(g:dnotvim_plugin_groups, 'javascript')
    Plug 'pangloss/vim-javascript'
    Plug 'kchmck/vim-coffee-script'
endif
" }

" Scala {
if count(g:dnotvim_plugin_groups, 'scala')
    Plug 'derekwyatt/vim-scala'
    Plug 'derekwyatt/vim-sbt'
endif
" }

" Haskell {
if count(g:dnotvim_plugin_groups, 'haskell')
    Plug 'neovimhaskell/haskell-vim'
    " HLS replaces the retired ghc-mod/hdevtools backends.
    if !count(g:dnotvim_plugin_groups, 'programming')
        Plug 'dense-analysis/ale'
    endif
endif
" }

" HTML {
if count(g:dnotvim_plugin_groups, 'html')
    Plug 'hail2u/vim-css3-syntax'
    Plug 'gorodinskiy/vim-coloresque'
    Plug 'tpope/vim-haml'
    Plug 'mattn/emmet-vim'
endif
" }

" Ruby {
if count(g:dnotvim_plugin_groups, 'ruby')
    Plug 'tpope/vim-rails'

    let g:rubycomplete_buffer_loading = 1
endif
" }

" Go Lang {
if count(g:dnotvim_plugin_groups, 'go')
    Plug 'fatih/vim-go'
endif
" }

" Rust {
if count(g:dnotvim_plugin_groups, 'rust')
    Plug 'rust-lang/rust.vim'
endif
" }

" Elixir {
if count(g:dnotvim_plugin_groups, 'elixir')
    Plug 'elixir-lang/vim-elixir'
    Plug 'carlosgaldino/elixir-snippets'
    Plug 'mattreduce/vim-mix'
endif
" }

" Misc {
if count(g:dnotvim_plugin_groups, 'misc')
    Plug 'sbdchd/neoformat', { 'on': 'Neoformat' }
    Plug 'tpope/vim-markdown'
    Plug 'greyblake/vim-preview', { 'on': [
                \ 'Preview', 'PreviewMarkdown', 'PreviewTextile', 'PreviewRdoc',
                \ 'PreviewHtml', 'PreviewRonn', 'PreviewRst'] }
    Plug 'Glench/Vim-Jinja2-Syntax'
endif
" }
" }

call plug#end()

function! s:InstallMissingPlugins() abort
    let missing = filter(keys(g:plugs), '!isdirectory(g:plugs[v:val].dir)')
    if empty(missing)
        return
    endif
    execute 'PlugInstall --sync ' . join(missing)
    echomsg 'Restart Vim after installation to load the new plugins.'
endfunction

augroup dnotvim_plugin_install
    autocmd!
    autocmd VimEnter * ++once call <SID>InstallMissingPlugins()
augroup END
