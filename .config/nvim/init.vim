" Kelvin Porter CURRENT_YEAR

" Plugins {{{
packadd minpac
let s:plugins = exists('*minpac#init')

if !s:plugins
	echo 'Downloading minpac to manage plugins...'
	exe '!mkdir -p ~/.config/nvim/pack/minpac/opt/minpac'
	exe '!git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac'
	autocmd VimEnter * call minpac#update()
endif

call minpac#init()

call minpac#add('neovim/nvim-lsp', {'type': 'opt'})

call minpac#add('SirVer/ultisnips')
call minpac#add('honza/vim-snippets')
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'custom-snippets']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"


call minpac#add('tpope/vim-dispatch')

call minpac#add('tpope/vim-fugitive')
call minpac#add('junegunn/gv.vim')

call minpac#add('tpope/vim-surround')

call minpac#add('justinmk/vim-sneak')
call minpac#add('tommcdo/vim-lion')
call minpac#add('tpope/vim-repeat')

call minpac#add('junegunn/fzf', { 'do': '!yes n | ./install' })
call minpac#add('junegunn/fzf.vim')
let g:fzf_command_prefix = 'Fz'

" note taking in class
call minpac#add('vimwiki/vimwiki')
call minpac#add('junegunn/goyo.vim')
let g:goyo_width = '80%'
let g:goyo_height = '80%'


call minpac#add('numirias/semshi', {'do': ':UpdateRemotePlugins'})
augroup pythonPlugins
	autocmd FileType python let g:python_highlight_all = 1
augroup end

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

call minpac#add('Harenome/vim-mipssyntax', {'type':'opt'})
augroup mips
	autocmd Filetype asm packadd vim-mipssyntax
	autocmd Filetype asm setlocal syntax="mips"
augroup end

call minpac#add('moll/vim-bbye')
call minpac#add('christoomey/vim-tmux-navigator')
call minpac#add('drzel/vim-scrolloff-fraction')
let g:scrolloff_fraction=0.2

call minpac#add('arcticicestudio/nord-vim')
call minpac#add('romainl/apprentice')
call minpac#add('rakr/vim-one')
call minpac#add('dikiaap/minimalist')
call minpac#add('dylanaraps/wal.vim')
call minpac#add('itchyny/lightline.vim')
" }}}

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

" Various settings
set autoindent                 " Minimal automatic indenting for any filetype.
set backspace=indent,eol,start " Proper backspace behavior.
set hidden                     " Possibility to have more than one unsaved buffers.
set incsearch                  " Incremental search.
" Search highlighting with this.
augroup vimrc-incsearch-highlight
	autocmd!
	autocmd CmdlineEnter /,\? :set hlsearch
	autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
set foldmethod=marker
set ignorecase
set smartcase 		       " Both cases if search term is all lowercase, requires ignorecase command.
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
	" Remove all trailing whitepace on save
	autocmd BufWritePre * %s/\s\+$//e
augroup end

" Notes
function! s:goyo_enter()
	if exists('$TMUX')
		silent !tmux set status off
	endif
	let b:quitting = 0
	let b:quitting_bang = 0
	autocmd QuitPre <buffer> let b:quitting = 1
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
	set noshowcmd
endfunction
function! s:goyo_leave()
	if exists('$TMUX')
		silent !tmux set status on
	endif
	set showcmd
	" Quit neovim if this is the only remaining buffer
	if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
		if b:quitting_bang
			qa!
		else
			qa
		endif
	endif
endfunction
augroup GoyoNotes
	autocmd! User GoyoEnter call <SID>goyo_enter()
	autocmd! User GoyoLeave call <SID>goyo_leave()
augroup end
let g:vimwiki_list = [{'path': '~/doc/edu/notes/text/',
			\'path_html': '~/doc/edu/notes/html/',
			\'template_path': '~/doc/edu/notes/templates/',
			\'template_default': 'def_template',
			\'template_ext': '.html'},
			\{'path': '~/doc/rpg/notes/text/',
			\'path_html': '~/doc/rpg/notes/html/',
			\'template_path': '~/doc/rpg/notes/templates/',
			\'template_default': 'def_template',
			\'template_ext': '.html'}]
let g:vimwiki_auto_chdir = 1
let g:vimwiki_table_mappings = 0 " use tab for ultisnips, not the table mappings.
let g:vimwiki_text_ignore_newline = 0

" Repeat last macro, instead of ex mode.
nnoremap Q @@
" The opposite of J in normal mode, this splits a line into two and auto
" indents.
nnoremap gS :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

let $FZF_DEFAULT_COMMAND =  'rg --files --hidden -S'
set notermguicolors
silent! colorscheme custom-wal
let g:lightline = {'colorscheme': 'wal'}
set background=dark
" search current project directory
nmap <Leader><Tab> :FzFiles<CR>
" search home and code directory
nmap <Leader>h :FzFiles ~<CR>
nmap <Leader>c :FzFiles ~/doc/code<CR>
" buffers and lines
nmap <Leader>b :FzBuffers<CR>
nmap <Leader>l :FzLines<CR>

" Code Formatting
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" LSP/Language Formatting
"augroup lspVIM
"	autocmd Filetype python,tex,java lua require('lsp_local')
"	autocmd Filetype python,tex packadd nvim-lsp
"	autocmd FileType python lua setupPythonServer()
"	autocmd FileType tex lua setupTexlabServer()
"	autocmd FileType python,tex setlocal omnifunc=lsp#omnifunc
"augroup end

" call nvim_lsp#setup("jdtls") " - no support yet


augroup javaFMT
	autocmd Filetype java setl formatprg=google-java-format\ -
	autocmd Filetype java setl softtabstop=2 shiftwidth=2
	autocmd Filetype java let b:java_highlight_all=1
augroup end

augroup pythonFMT
	autocmd Filetype python setlocal formatprg=yapf
augroup end

augroup webFMT
	" this is terrible but its legitimately the only thing that works apparently.
	autocmd FileType javascript,css setlocal formatprg=prettier\ %
augroup end

" Debugging
let g:vebugger_use_tags=1
let g:vebugger_leader = '<Leader>d'

" Tags
set tags=./tags;~
command! Tags !ctags -R -I EXTERN -I INIT --exclude='build*' --exclude='.vim-src/**' --exclude='node_modules/**' --exclude='venv/**' --exclude='**/site-packages/**'
			\--exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**'
			\--exclude=.git --exclude=.svn --exclude=.hg --exclude="*.cache.html" --exclude="*.nocache.js" --exclude="*.min.*" --exclude="*.map" --exclude="*.swp"
			\--exclude="*.bak" --exclude="*.pyc" --exclude="*.class" --exclude="*.sln" --exclude="*.Master" --exclude="*.csproj" --exclude="*.csproj.user"
			\--exclude="*.cache" --exclude="*.dll" --exclude="*.pdb" --exclude=tags --exclude="cscope.*" --exclude="*.tar.*"
