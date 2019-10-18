""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neovim Configuration
" Kelvin Porter 2019
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins    ---------------------------------{{{
call plug#begin()
" system {{{
Plug 'tpope/vim-sensible'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tommcdo/vim-lion'
Plug 'jiangmiao/auto-pairs'
Plug 'edkolev/tmuxline.vim'
Plug 'Konfekt/FastFold'
" }}}
" completion / tags {{{
Plug 'Shougo/deoplete.nvim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'tweekmonster/deoplete-clang2'
Plug 'Shougo/echodoc.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
" }}}
" code style / linting {{{
Plug 'desmap/ale-sensible' | Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
" }}}
" UI {{{
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'mbbill/undotree'
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'moll/vim-bbye'
Plug 'mhinz/vim-startify'
Plug 'IMOKURI/line-number-interval.nvim'
Plug 'Yggdroot/indentLine'
Plug 'ajmwagar/vim-deus'
Plug 'ajmwagar/lightline-deus'
" }}}
" denite {{{
Plug 'Shougo/denite.nvim'
Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}}
Plug 'Shougo/neomru.vim'
Plug 'neoclide/denite-git'
Plug 'neoclide/denite-extra'
" }}}
" git {{{
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
" }}}
" snippets {{{
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
" }}}
" python {{{
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'tmhedberg/SimpylFold', {'for': 'python'}
" }}}
" javascript {{{
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'Quramy/vison'
" }}}
" html {{{
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
" }}}
" go {{{
Plug 'fatih/vim-go'
Plug 'deoplete-plugins/deoplete-go', {'do': 'make'}
" }}}
" java {{{
" }}}
call plug#end()
" }}}

" System settings ----------------------------{{{
set confirm
set hidden
set number relativenumber
set showcmd " show leader key bindings
set smartcase " case insensitive searching if only lowercase
set visualbell
set termguicolors
set undofile
set undodir="~/.local/share/nvim/undo"
set inccommand=nosplit

set background=dark
colorscheme deus

augroup general
	" Remember cursor position between vim sessions
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line ("'\"") <= line("$") |
		\   exe "normal! g'\"" |
		\ endif
             " center buffer around cursor when opening files
	autocmd BufRead * normal zz
	" Create new dirs when writing a file in a non-existent directory.
	autocmd BufWritePre *
		\ if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) |
		\ call mkdir(expand('<afile>:h'), 'p') |
		\ endif
augroup end

" Initialize this variable for language specifc sections to deal with.
let g:LanguageClient_serverCommands = {}
" leave diagnostics to ALE
let g:LanguageClient_diagnosticsEnable = 0

" Line Number Interval
let g:line_number_interval#enable_at_startup = 1
let g:line_number_interval#use_custom = 1
" set colors of custom lines
highlight HighlightedLineNr guifg=White ctermfg=7
highlight DimLineNr guifg=Magenta ctermfg=5

" Gutentags
let g:gutentags_cache_dir = '/home/yack/.cache/gutentags'

" Startify
let g:startify_bookmarks = [
			\ {'h': '~/doc/code/edu/'},
			\ {'c' : '~/doc/code/cur/'},
			\ {'s': '~/doc/code/cur/opensmash'},
			\ {'d': '~/doc/code/cur/sbso'},
			\ {'v': '~/.config/nvim/init.vim'},
			\]
" }}}

" System mappings ----------------------------{{{
" Space as leader workaround
let mapleader = '\'
map <space> \

" Repeat last macro, instead of ex mode.
nnoremap Q @@

" Window switching
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l


" Undotree
map <Leader>ou :UndotreeToggle<CR>
" toggle
map <Leader>ot :TagbarToggle<CR>
" open and focus
map <Leader>oo :TagbarOpen fj<CR>
" open and close on jump
map <Leader>og :TagbarOpen fjc<CR>

" Highlighting searches
map <Leader>hh :set hlsearch!<CR>

" Tabs
map <Leader>tp :tabp<CR>
map <Leader>tn :tabn<CR>
map <Leader>tq :tabclose<CR>
map <Leader>ti :tabnew<CR>
map <Leader>tt :tabs<CR>
map <Leader>tP :tabfirst<CR>
map <Leader>tN :tablast<CR>

" Neovim terminal mode escape
tmap <esc> <c-\><c-n><esc><esc>

" Align and keep selected
vmap < <gv
vmap > >gv

" Sneak
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" BBYE
map <Leader>bd :Bdelete<CR>
" }}}

" Defx ---------------------------------------{{{

  set conceallevel=2
  set concealcursor=nc
  map <Leader>of :Defx<cr>
  autocmd FileType defx call s:defx_my_settings()
  call defx#custom#column('icon', {
     \ 'directory_icon': '',
     \ 'opened_icon':  '',
     \ 'root_icon': '',
     \ 'root_marker_highlight': 'Ignore',
     \ })
  call defx#custom#column('filename', {
     \ 'root_marker_highlight': 'Ignore',
     \ })
  call defx#custom#column('mark', {
        \ 'readonly_icon': '✗',
        \ 'selected_icon': '',
        \ })
  call defx#custom#option('_', {
      \ 'winwidth': 45,
      \ 'columns': 'mark:indent:icon:icons:filename:git',
      \ 'split': 'floating',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 1,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ 'root_marker': ':',
      \ })
  function! s:defx_my_settings() abort

    IndentLinesDisable
    setl nospell
    setl signcolumn=no
    setl nonumber
    nnoremap <silent><buffer><expr> <CR> defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('drop')
    nnoremap <silent><buffer><expr> h defx#do_action('close_tree')
    nnoremap <silent><buffer><expr> c defx#do_action('change_vim_cwd')
    nnoremap <silent><buffer><expr> d defx#do_action('move')
    nnoremap <silent><buffer><expr> Y defx#do_action('copy')
    nnoremap <silent><buffer><expr> m defx#do_action('create_directory')
    nnoremap <silent><buffer><expr> P defx#do_action('paste')
    nnoremap <silent><buffer><expr> R defx#do_action('rename')
    nnoremap <silent><buffer><expr> D defx#do_action('remove')
    nnoremap <silent><buffer><expr> a defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> A defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> l defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> U defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select')
    nnoremap <silent><buffer><expr> r defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <Tab> <SID>defx_toggle_zoom()
    nnoremap <silent><buffer><expr> <C-Q> defx#do_action('quit')

  endfunction

  function s:defx_toggle_zoom() abort "{{{
    let b:DefxOldWindowSize = get(b:, 'DefxOldWindowSize', winwidth('%'))
    let size = b:DefxOldWindowSize
    if exists('b:DefxZoomed') && b:DefxZoomed
        exec 'silent vertical resize '. size
        let b:DefxZoomed = 0
    else
        exec 'vertical resize '. get(g:, 'DefxWinSizeMax', '')
        let b:DefxZoomed = 1
    endif
  endfunction "}}}

  let g:defx_git#show_ignored = 0
  let g:defx_git#column_length = 1

  hi def link Defx_filename_directory NERDTreeDirSlash
  hi def link Defx_git_Modified Special
  hi def link Defx_git_Staged Function
  hi def link Defx_git_Renamed Title
  hi def link Defx_git_Unmerged Label
  hi def link Defx_git_Untracked Tag
  hi def link Defx_git_Ignored Comment

  let g:defx_icons_parent_icon = ''
  let g:defx_icons_mark_icon = ''
  let g:defx_icons_enable_syntax_highlight = 1
  let g:defx_icons_column_length = 1
  let g:defx_icons_mark_icon = '*'
  let g:defx_icons_default_icon = ''
  let g:defx_icons_directory_symlink_icon = ''
  " Options below are applicable only when using "tree" feature
  let g:defx_icons_directory_icon = ''
  let g:defx_icons_root_opened_tree_icon = ''
  let g:defx_icons_nested_opened_tree_icon = ''
  let g:defx_icons_nested_closed_tree_icon = ''

"  }}}

" Denite -------------------------------------{{{

call denite#custom#var('file/rec', 'command',
			\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#option('_', {
       \ 'prompt': '>',
       \ 'winheight': 10,
       \ 'updatetime': 1,
       \ 'auto_resize': 0,
       \ 'highlight_matched_char': 'Underlined',
       \ 'highlight_mode_normal': 'CursorLine',
       \ 'reversed': 1,
       \ 'auto-accel': 1,
       \ 'start_filter': 1,
       \})

autocmd FileType denite call s:denite_settings()

function! s:denite_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <C-v>
        \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> <Esc>
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> l
	\ denite#do_map('do_action', 'load')
endfunction

nnoremap <silent> <c-p> :Denite file/rec<CR>
nnoremap <silent> <Leader>db :Denite buffer<CR>
nnoremap <silent> <Leader>dh :Denite help<CR>
nnoremap <silent> <Leader>dv :Denite vison<CR>
nnoremap <silent> <Leader>dg :Denite grep:::!<CR>
nnoremap <silent> <Leader>dl :Denite line<CR>
nnoremap <silent> <Leader>ds :Denite session<CR>
" }}}

" Deoplete/Neosnippets -----------------------{{{

let g:deoplete#enable_at_startup = 1

call deoplete#custom#option({
   \ 'auto_complete_delay': 0,
   \ 'smart_case': v:true,
   \})
  call deoplete#custom#option('omni_patterns', {
   \ 'html': '',
   \ 'css': '',
   \ 'scss': ''
   \})
let g:echodoc_enable_at_startup=1
let g:echodoc#type='virtual'
set splitbelow
set completeopt+=menuone,noinsert,noselect
set completeopt-=preview
autocmd CompleteDone * pclose

function g:Multiple_cursors_before()
	call deoplete#custom#buffer_option('auto_complete', v:false)
endfunction
function g:Multiple_cursors_after()
	call deoplete#custom#buffer_option('auto_complete', v:true)
endfunction

call deoplete#custom#source('jedi', 'mark', '')
call deoplete#custom#source('LanguageClient', 'mark', '')
call deoplete#custom#source('file', 'mark', '')
call deoplete#custom#source('buffer', 'mark', 'ℬ')

let g:neosnippet#snippets_directory = ['~/.config/nvim/plugged/vim-snippets/snippets',
				     \ '~/.config/nvim/custom_snippets']
let g:neosnippet#enable_snipmate_compatibility = 1

" AutoPairs + Neosnippets + Deoplete hotkeys
let g:AutoPairsMapCR = 0
imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
imap <expr><CR> pumvisible() ? deoplete#close_popup() : "\<CR>\<Plug>AutoPairsReturn"
" }}}

" Linting ------------------------------------{{{

let g:ale_linters = {}
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }
let g:ale_lint_on_text_changed = 'always'
let g:ale_fix_on_save = 1

map <Leader>ai :ALEInfo<CR>
map <Leader>at :ALEToggle<CR>
map <Leader>ab :ALEToggle<CR>

" }}}

" Lightline/Tmuxline -------------------------{{{

let g:lightline = {}

let g:lightline.enable = {
	\ 'statusline': 1,
	\ 'tabline': 1
	\}

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
let g:lightline.active = {
			\ 'left': [ [ 'mode', 'paste' ],
      				\ [ 'readonly', 'filename', 'modified' ] ],
			\ 'right': [ ['lineinfo'],
				\ ['percent'], ['fileformat', 'fileencoding', 'filetype'],
				\ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }
let g:lightline.colorscheme = 'deus'
set noshowmode " Only show mode in lightline

let g:tmuxline_powerline_separators = 0
" }}}

" Git ----------------------------------------{{{
map <Leader>gg :Git<CR>
map <Leader>gc :Git
nnoremap <Leader>gf :Denite gitfiles<CR>
nnoremap <Leader>gl :Denite gitlog<CR>
nnoremap <Leader>gh :Denite gitlog<CR>
nnoremap <Leader>gs :Denite gitfiles:
nnoremap <Leader>gb :Denite gitbranch<CR>
nnoremap <Leader>ge :Denite gitchanged<CR>
" }}}

" Python -------------------------------------{{{
let g:ale_linters.python = ['bandit']
let g:ale_fixers.python = ['autopep8']
let g:LanguageClient_serverCommands.python = ['/usr/bin/pyls']
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python3'
let g:jedi#auto_vim_configuration = 0
let g:jedi#documentation_command = '<leader>k'
let g:jedi#completions_enabled = 0
let g:jedi#force_py_version=3
augroup python
	au Filetype python setl et ts=4 sw=4
augroup end
" }}}

" Java ---------------------------------------{{{
let g:ale_linters.java = ['javac']
let g:ale_fixers.java = ['google_java_format']
let g:LanguageClient_serverCommands.java = ['/usr/bin/jdtls']
augroup java
	au Filetype java setl et ts=2 sw=2
	autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup end
let g:ale_java_javac_executable='/home/yack/.sdkman/candidates/java/current/bin/javac'
let g:ale_java_eclipselsp_path='/usr/bin/'
let g:ale_java_eclipselsp_executable='jdtls'
" }}}

" Javascript ---------------------------------{{{
let g:vim_jsx_pretty_colorful_config = 1
let g:ale_linters.javascript = ['prettier']
let g:ale_fixers.javascript = ['prettier']
let g:ale_linters.javascriptreact = ['prettier']
let g:ale_fixers.javascriptreact = ['prettier']
" }}}

" HTML ---------------------------------------{{{
let g:ale_linters.html = ['prettier']
let g:ale_fixers.html = ['prettier']
" }}}

" JSON ---------------------------------------{{{
let g:ale_linters.json = ['prettier']
let g:ale_fixers.json = ['prettier']
augroup json
	au FileType json syntax match Comment +\/\/.\+$+
augroup end
" }}}

" Go -----------------------------------------{{{
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:ale_linters.go = ['golint']
let g:ale_fixers.go = ['gofmt']
" }}}

" Vimscript ----------------------------------{{{
augroup vimscript
	au Filetype vim setl foldmethod=marker
augroup end
" }}}
