" Kelvin Porter CURRENT_YEAR

" Plugins {{{
packadd minpac
let s:plugins = exists('*minpac#init')

if !s:plugins 
	fun! InstallPlug() " Bootstrap plugin manager on new systems.
		exe '!git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac'
	endfun
	call InstallPlug()
else

	call minpac#init()

	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')
	let g:UltiSnipsSnippetDirectories=['UltiSnips', 'custom-snippets']
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpForwardTrigger="<tab>"
	let g:UltiSnipsJumpBackwardTrigger="<S-tab>"


	call minpac#add('Shougo/vimproc.vim', { 'do': 'make'} )
	call minpac#add('idanarye/vim-vebugger')
	call minpac#add('tpope/vim-dispatch')

	call minpac#add('tpope/vim-dadbod')

	call minpac#add('tpope/vim-fugitive')
	call minpac#add('junegunn/gv.vim')

	call minpac#add('justinmk/vim-sneak')
	call minpac#add('tpope/vim-surround')
	call minpac#add('tommcdo/vim-lion')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('tpope/vim-eunuch')

	call minpac#add('junegunn/fzf', { 'do': '!yes n | ./install' })
	call minpac#add('junegunn/fzf.vim')
	let g:fzf_command_prefix = 'Fz'
	
	call minpac#add('artur-shaik/vim-javacomplete2', {'type': 'opt'})
	augroup javaPlugins
		autocmd FileType java packadd vim-javacomplete2
		autocmd FileType java setlocal omnifunc=javacomplete#Complete
		autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
	augroup end

	call minpac#add('lervag/vimtex', {'type': 'opt'})
	let g:tex_flavor='latex'
	augroup texPlugins
		autocmd FileType tex packadd vimtex
		autocmd Filetype tex setlocal spell
		autocmd FileType tex let g:vimtex_view_method='zathura'
		autocmd FileType tex let g:vimtex_compiler_method='latexmk'
		autocmd FileType tex let g:vimtex_quickfix_mode=0
		autocmd Filetype tex autocmd BufWritePost lec*.tex :Dispatch!
	augroup end

	call minpac#add('moll/vim-bbye')
	call minpac#add('christoomey/vim-tmux-navigator')
	call minpac#add('drzel/vim-scrolloff-fraction')
	let g:scrolloff_fraction=0.2

	call minpac#add('dylanaraps/wal.vim')
	call minpac#add('itchyny/lightline.vim')
	let g:lightline = {'colorscheme': 'wal'}
endif " }}}

" Set leader key to space
let mapleader = '\'
map <space> \

" Enabling filetype support provides filetype-specific indenting,
" syntax highlighting, omni-completion and other useful settings.
filetype plugin indent on
set omnifunc+=syntaxcomplete#Complete
syntax on

" `matchit.vim` is built-in so let's enable it!
" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim

" various settings
set autoindent                 " Minimal automatic indenting for any filetype.
set backspace=indent,eol,start " Proper backspace behavior.
set hidden                     " Possibility to have more than one unsaved buffers.
set splitright		       " Vertical split buffers open on the right
set incsearch                  " Incremental search.
set foldmethod=marker
set smartcase 		       " Both cases if search term is all lowercase, ignores ignorecase command.
set ruler                      " Shows the current line number at the bottom-right of the screen.
set wildmenu                   " Great command-line completion, use `<Tab>` to move
" around and `<CR>` to validate.
set wildignore+=tags,*/__pycache__/*,build/*,build.?/*
set suffixes+=.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,
			\,.o,.obj,.dll,.class,.pyc,.ipynb,.so,.swp,.zip,.exe,.jar,.gz
set suffixesadd=.java
set relativenumber 	  " set line number = distance from currently selected one
set number 		" set current line number to not 0.
set dictionary+=/usr/share/dict/words

augroup fileAuto
	" Create directories before saving if they don't exist.
	autocmd BufWritePre *
		\ if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) |
		\ call mkdir(expand('<afile>:h'), 'p') |
		\ endif
augroup end

" Repeat last macro, instead of ex mode.
nnoremap Q @@
" The opposite of J in normal mode, this splits a line into two and auto
" indents.
nnoremap gS :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

" NetRW settings/UI stuff
let g:netrw_banner=0
let g:netrw_winsize=25
silent! colorscheme wal
let $FZF_DEFAULT_COMMAND =  'rg --files --hidden -S'
" search current project directory
nmap <Leader><Tab> :FzFiles<CR>
" search home directory
nmap <Leader>h :FzFiles ~<CR>
nmap <Leader>c :FzFiles ~/doc/code<CR>
" buffers and lines
nmap <Leader>b :FzBuffers<CR>
nmap <Leader>l :FzLines<CR>

" LSP/Language Formatting
silent! call lsp#add_filetype_config({
			\'filetype': 'java',
			\'name':'jdtls',
			\'cmd':'jdtls'
			\})
augroup javaFormat
	autocmd Filetype java setl formatprg=google-java-format\ -
	autocmd Filetype java setl softtabstop=2 shiftwidth=2
augroup end

silent! call lsp#add_filetype_config({
			\'filetype': 'python',
			\'name':'pyls',
			\'cmd':'pyls'
			\})

augroup pythonFMT 
	autocmd Filetype python setl formatprg=flake8
augroup end

" Debugging
let g:vebugger_use_tags=1
function! VBGstartJDB(main) abort
	call vebugger#jdb#start(a:main, {
				\'classpath':'build',
				\'srcpath':'src',
				\})
endfunction
let g:vebugger_leader = '<Leader>d'

" Tags
set tags=./tags;~
command! Tags !ctags -R -I EXTERN -I INIT --exclude='build*' --exclude='.vim-src/**' --exclude='node_modules/**' --exclude='venv/**' --exclude='**/site-packages/**' 
			\--exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**'
			\--exclude=.git --exclude=.svn --exclude=.hg --exclude="*.cache.html" --exclude="*.nocache.js" --exclude="*.min.*" --exclude="*.map" --exclude="*.swp" 
			\--exclude="*.bak" --exclude="*.pyc" --exclude="*.class" --exclude="*.sln" --exclude="*.Master" --exclude="*.csproj" --exclude="*.csproj.user" 
			\--exclude="*.cache" --exclude="*.dll" --exclude="*.pdb" --exclude=tags --exclude="cscope.*" --exclude="*.tar.*"
