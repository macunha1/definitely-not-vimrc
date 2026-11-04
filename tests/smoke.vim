" Run after loading init.vim with installed plugins and isolated XDG directories.
set nomore
let s:fixture_directory = $XDG_CACHE_HOME . '/vim/smoke-' . getpid()
call mkdir(s:fixture_directory, 'p')
let s:fixture = s:fixture_directory . '/smoke file.py'
call writefile(['root = true', '[*.py]', 'indent_style = space', 'indent_size = 3'],
            \ fnamemodify(s:fixture, ':h') . '/.editorconfig')
call writefile(['first line', 'second line   '], s:fixture)

call assert_equal('retrowave', g:colors_name)
call assert_equal(2, exists(':Fern'))
call assert_equal(2, exists(':Files'))
call assert_equal(2, exists(':History'))
call assert_equal(2, exists(':BTags'))
call assert_equal(2, exists(':Rg'))
call assert_equal(2, exists(':Git'))
call assert_equal(2, exists(':ALELint'))
call assert_equal(2, exists(':SessionSave'))
call assert_equal(2, exists(':Tabularize'))
call assert_false(exists('g:loaded_goyo'))
call assert_false(exists('g:loaded_undotree'))
call assert_false(exists('g:loaded_neoformat'))
call assert_false(exists('g:loaded_sessionman'))
call assert_false(exists('g:loaded_gist_vim'))
call assert_false(exists('g:loaded_preview'))

execute 'edit ' . fnameescape(s:fixture)
call assert_equal('python', &filetype)
call assert_equal(3, &shiftwidth, 'EditorConfig was not applied')
write
call assert_equal('second line', getline(2))
call cursor(2, 1)
let s:original_directory = getcwd()
let s:original_buffer = bufnr('')
call DnotvimRevealFile()
call assert_equal('fern', &filetype)
call assert_equal(s:original_directory, getcwd())
sleep 300m
call assert_match('smoke file.py', join(getline(1, '$'), '\n'))
Fern . -drawer -toggle
call assert_equal(s:original_buffer, bufnr(''))

let s:repository = fnamemodify(expand('<sfile>:p'), ':h:h')
execute 'lcd ' . fnameescape(s:repository . '/colors')
call assert_equal(s:repository, DnotvimProjectRoot())
execute 'lcd ' . fnameescape(s:original_directory)

call lightline#update()
call assert_false(empty(lightline#statusline(0)))
call assert_false(empty(lightline#tabline()))
call assert_match('smoke file.py', join(DnotvimBufferNames()[1]))
call assert_true(DnotvimCanSaveView())
mkview!
call assert_false(empty(glob(&viewdir . '/*')))
let g:dnotvim_no_views = 1
call assert_false(DnotvimCanSaveView())
unlet g:dnotvim_no_views

for s:filetype in ['json', 'toml', 'yaml', 'terraform', 'nix', 'markdown', 'xml']
    enew!
    execute 'setfiletype ' . s:filetype
    call assert_false(empty(&syntax), s:filetype . ' syntax missing')
    if index(['json', 'toml'], s:filetype) >= 0
        call assert_equal(s:filetype, get(b:, 'current_syntax', ''), 'native syntax was not loaded')
    endif
endfor

call assert_equal(2, exists(':Neoformat'))
setfiletype text
Neoformat
call assert_true(exists('g:loaded_neoformat'))
SessionClose
call assert_true(exists('g:loaded_sessionman'))
if !empty(v:errors)
    for s:error in v:errors
        echomsg s:error
    endfor
    cquit
endif
qa!
