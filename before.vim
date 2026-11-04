" Commands to execute before the Plugins are loaded
" Customizations are (usually) better suited here.

let g:dnotvim_plugin_groups = ['general', 'programming', 'infra', 'misc']

let g:vim_json_conceal = 0

" Complete brackets without inserting paired spaces.
let g:lexima_enable_space_rules = 0

let g:neoformat_enabled_python = ['autopep8', 'yapf']
let g:neoformat_enabled_ruby = ['rubocop']

let g:terraform_align = 0
let g:terraform_fmt_on_save = 1

" Theme and visual configurations {
let g:lightline = { 'colorscheme': 'retrowave' }

let g:rainbow_active = 1
let g:retrowave_default_termcolors = 1
let g:retrowave_rainbow_colors = 1
" }
