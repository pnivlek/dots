"""""""""""""""""""""""""""""""""""""""""""""""""""
" Neovim Configuration
" Kelvin Porter 2019
"""""""""""""""""""""""""""""""""""""""""""""""""""

" {{{ Plugins
call plug#begin()

" Sensible
Plug 'tpope/vim-sensible'

" Editing
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tommcdo/vim-lion'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'OmniSharp/omnisharp-vim'

" Syntax checking
Plug 'desmap/ale-sensible' | Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'

" Tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" Files
Plug 'Shougo/denite.nvim'
Plug 'xolox/vim-session' | Plug 'xolox/vim-misc'

" UI
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'cocopon/lightline-hybrid.vim'
Plug 'edkolev/tmuxline.vim'

Plug 'moll/vim-bbye'
Plug 'mhinz/vim-startify'
Plug 'IMOKURI/line-number-interval.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'

" Python Plugins
Plug 'cjrh/vim-conda'

" Webdev
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

" Colorscheme
Plug 'w0ng/vim-hybrid'

call plug#end()

" }}}

" {{{ General Settings
set confirm
set number relativenumber
set showcmd " show leader key bindings
set smartcase " case insensitive searching if only lowercase
set visualbell

set background=dark
set termguicolors
colorscheme hybrid

augroup general
	" Create new dirs when writing a file in a non-existent directory.
	autocmd BufWritePre *
    	\ if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) |
        \ call mkdir(expand('<afile>:h'), 'p') |
    	\ endif
augroup end

let g:netrw_liststyle = 3
let g:netrw_banner = 0

" }}}

" {{{ Plugin configuration

" ALE
let g:ale_fixers = {
			\ 'python': ['autopep8', 'yapf', 'remove_trailing_lines', 'trim_whitespace'],
			\ 'java': ['google_java_format', 'remove_trailing_lines', 'trim_whitespace'],
			\ 'javascript': ['prettier'],
			\ 'html': ['prettier'],
			\ 'json': ['prettier'],
			\ '*': ['remove_trailing_lines', 'trim_whitespace']
			\}
let g:ale_linters = {
			\ 'python': ['bandit'],
			\ 'javascript': ['prettier'],
			\ 'java': ['javac'],
			\ 'html': ['prettier'],
			\}
let g:ale_java_javac_executable='/home/yack/.sdkman/candidates/java/current/bin/javac'
let g:ale_java_eclipselsp_path='/usr/bin/'
let g:ale_java_eclipselsp_executable='jdtls'
let g:ale_lint_on_text_changed = 'always'
let g:ale_fix_on_save = 1

" Lightline
let g:lightline = {}

let g:lightline.enable = {
	\ 'statusline': 1,
	\ 'tabline': 1
	\}

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

let g:lightline.component_function = {
	\ 'cocstatus': 'coc#status',
	\ 'currentfunction': 'CocCurrentFunction'
	\ }

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
      				\ [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ],
			\ 'right': [ ['lineinfo'],
				\ ['percent'], ['fileformat', 'fileencoding', 'filetype'],
				\ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }
let g:lightline.colorscheme = 'hybrid'
set noshowmode " Only show mode in lightline

" Coc
" use <Tab> and <S-Tab> to navigate the completion list
" use <tab> for trigger completion and navigate to the next complete item

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Navigate snippet placeholders using tab
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

" Use enter to accept snippet expansion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

" Denite
try

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Open file commands
call denite#custom#map('insert,normal', '<C-t>', '<denite:do_action:tabopen>')
call denite#custom#map('insert,normal', '<C-v>', '<denite:do_action:vsplit>')
call denite#custom#map('insert,normal', '<C-h>', '<denite:do_action:split>')

catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry

" Gutentags
let g:gutentags_cache_dir = '/home/yack/.cache/gutentags'

" Startify
let g:startify_bookmarks = [
			\ {'h': '~/doc/sbu/cse/'},
			\ {'c' : '~/doc/code/'},
			\ {'s': '~/doc/code/cur/opensmash'},
			\ {'v': '~/.config/nvim/init.vim'},
			\]
" Tagbar
" let g:tagbar_ctags_bin = '/home/yack/shr/ctags/bin/ctags'

" Line Number Interval
let g:line_number_interval#enable_at_startup = 1
let g:line_number_interval#use_custom = 1
" set colors of custom lines
highlight HighlightedLineNr guifg=White ctermfg=7
highlight DimLineNr guifg=Magenta ctermfg=5

" }}}

" {{{ Key Bindings

" Space as leader workaround
let mapleader = '\'
map <space> \

" Files
map <Leader>of :Explore<CR>
" toggle
map <Leader>ot :TagbarToggle<CR>
" open and focus
map <Leader>oo :TagbarOpen fj<CR>
" open and close on jump
map <Leader>og :TagbarOpen fjc<CR>

" Tabs
map <Leader>tj :tabn<CR>
map <Leader>tk :tabp<CR>
map <Leader>td :tabclose<CR>
map <Leader>ti :tabnew<CR>
map <Leader>tt :tabs<CR>
map <Leader>tK :tabfirst<CR>
map <Leader>tJ :tablast<CR>

" Git
map <Leader>gg :Git<CR>
map <Leader>gc :Git

" Sessions
map <Leader>pw :SaveSession
map <Leader>po :OpenSession
map <Leader>pv :ViewSession
map <Leader>pd :DeleteSession
map <Leader>pq :CloseSession

map <Leader>pto :OpenTabSession
map <Leader>pts :SaveTabSession
map <Leader>pta :AppendTabSession
map <Leader>ptc :CloseTabSession

" Highlighting searches
map <Leader>hh :set hlsearch<CR>
map <Leader>hn :set nohlsearch<CR>

" Coc Stuff
map <Leader>ci :CocInstall
map <Leader>ce :CocConfig<CR>
map <Leader>cc :CocCommand<CR>
map <Leader>cu :CocUpdate<CR>
map <Leader>cl :CocList<CR>

" rename current name with coc
map <Leader>rn <Plug>(coc-rename)

" ALE stuff
map <Leader>ai :ALEInfo<CR>
map <Leader>at :ALEToggle<CR>
map <Leader>ab :ALEToggle<CR>

" BBYE
map <Leader>bd :Bdelete<CR>

" Denite - stolen from https://github.com/ctaylo21/jarvis/blob/master/config/nvim/init.vim
nmap <Leader>ps :Denite buffer<CR>
nmap <leader>pt :DeniteProjectDir file/rec<CR>
nnoremap <leader>pg :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>pj :<C-u>DeniteCursorWord grep:.<CR>

augroup denite
	" Define mappings while in 'filter' mode
	"   <C-o>         - Switch to normal mode inside of search results
	"   <Esc>         - Exit denite window in any mode
	"   <CR>          - Open currently selected file in any mode
	autocmd FileType denite-filter call s:denite_filter_my_settings()
	function! s:denite_filter_my_settings() abort
	  imap <silent><buffer> <C-o>
	  \ <Plug>(denite_filter_quit)
	  inoremap <silent><buffer><expr> <Esc>
	  \ denite#do_map('quit')
	  nnoremap <silent><buffer><expr> <Esc>
	  \ denite#do_map('quit')
	  inoremap <silent><buffer><expr> <CR>
	  \ denite#do_map('do_action')
	endfunction

	" Define mappings while in denite window
	"   <CR>        - Opens currently selected file
	"   q or <Esc>  - Quit Denite window
	"   d           - Delete currenly selected file
	"   p           - Preview currently selected file
	"   <C-o> or i  - Switch to insert mode inside of filter prompt
	autocmd FileType denite call s:denite_my_settings()
	function! s:denite_my_settings() abort
	  nnoremap <silent><buffer><expr> <CR>
	  \ denite#do_map('do_action')
	  nnoremap <silent><buffer><expr> q
	  \ denite#do_map('quit')
	  nnoremap <silent><buffer><expr> <Esc>
	  \ denite#do_map('quit')
	  nnoremap <silent><buffer><expr> d
	  \ denite#do_map('do_action', 'delete')
	  nnoremap <silent><buffer><expr> p
	  \ denite#do_map('do_action', 'preview')
	  nnoremap <silent><buffer><expr> i
	  \ denite#do_map('open_filter_buffer')
	  nnoremap <silent><buffer><expr> <C-o>
	  \ denite#do_map('open_filter_buffer')
	endfunction
augroup END

" Sneak - replace built in f and t
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" }}}

" {{{ Filetype configuration

" Python
augroup python
	au Filetype python setl et ts=4 sw=4
augroup end
let g:python_host_prog = '/usr/bin/python'

" Java
augroup java
	au Filetype java setl et ts=2 sw=2
augroup end

" Vimscript
augroup vimscript
	au Filetype vim setl foldmethod=marker
augroup end

" JSON
augroup json
	au FileType json syntax match Comment +\/\/.\+$+
augroup end

" }}}
