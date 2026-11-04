" Run with -Nu NONE, vim-plug on runtimepath, and isolated XDG_DATA_HOME.
set nomore
let g:dnotvim_plugin_groups = []
let s:repository = fnamemodify(expand('<sfile>:p'), ':h:h')
let s:fixture = tempname()
call mkdir(s:fixture, 'p')
execute 'source ' . fnameescape(s:repository . '/plugins.vim')
let g:install_calls = []
command! -nargs=* PlugInstall call add(g:install_calls, <q-args>)

" Existing plugins do not trigger installation.
let g:plugs = {'present': {'dir': s:fixture}}
doautocmd VimEnter
call assert_equal([], g:install_calls)

" Registering again replaces the hook; only missing plugins are requested.
execute 'source ' . fnameescape(s:repository . '/plugins.vim')
execute 'source ' . fnameescape(s:repository . '/plugins.vim')
command! -nargs=* PlugInstall call add(g:install_calls, <q-args>)
let g:plugs = {'present': {'dir': s:fixture}, 'missing': {'dir': s:fixture . '/missing'}}
doautocmd VimEnter
call assert_equal(['--sync missing'], g:install_calls)

" An unsuccessful installation cannot repeat during the same startup.
doautocmd VimEnter
call assert_equal(['--sync missing'], g:install_calls)
call delete(s:fixture, 'd')
if !empty(v:errors)
    for s:error in v:errors
        echomsg s:error
    endfor
    cquit
endif
qa!
