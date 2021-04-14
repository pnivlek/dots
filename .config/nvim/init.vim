" Kelvin Porter CURRENT_YEAR
" Large parts taken from pwntester because his init.vim is awesome.

if &compatible
    set nocompatible
endif

" ===== BUILTIN PLUGINS ==================== {{{{{{

" Disable built-in plugins
let g:loaded_2html_plugin      = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_logipat           = 1
let g:loaded_logiPat           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_sql_completion    = 1
let g:loaded_syntax_completion = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:vimsyn_embed             = 1
let g:loaded_matchit           = 1

" }}}}}}

" ===== SETUP FUNCTIONS ==================== {{{

" Creates a floating window with a most recent buffer to be used
function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction
" }}}

" ===== GENERAL SETTINGS =================== {{{

filetype plugin indent on                                           " Enabling filetype support.
syntax on
set hidden                                                          " Hide buffers when unloaded
if &encoding != 'utf-8'                                             " Skip this on resourcing with Neovim (E905).
    set encoding=utf-8
    set fileencoding=utf-8
endif
set nrformats=alpha,hex,octal                                       " Increment/decrement numbers. C-a,a (tmux), C-x
set shell=/bin/zsh                                                  " ZSH good
set visualbell                                                      " Silent please
set inccommand=nosplit                                              " Live preview for :substitute
set updatetime=750                                                  " CursorHold waiting time
set noequalalways                                                   " Do not auto-resize windows when opening/closing them!
" }}}

" ===== UI ================================= {{{
set laststatus=2
set backspace=indent,eol,start					                    " Proper backspace behavior.
set foldmethod=marker                                               " Fold with markers {{{}}}
set foldcolumn=0                                                    " Do not show fold levels in side bar
set cursorline                                                      " Print cursorline
set lazyredraw                                                      " Don't update the display while executing macros
set number                                                          " Print the line number
set relativenumber                                                  " Print the relative line number
set showcmd                                                         " Show partial commands in status line
set noshowmode                                                      " Dont show the mode in the command line
set signcolumn=auto                                                 " Only show sign column if there are signs to be shown
set termguicolors
set wrap                                                            " Wrap lines visually
set sidescroll=5                                                    " Side scroll when wrap is disabled
set linebreak                                                       " Wrap lines at special characters instead of at max width
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:%            " Show trailing whitespace
set diffopt+=vertical                                               " Show vimdiff in vertical splits
set diffopt+=algorithm:patience                                     " Use git diffing algorithm
set diffopt+=context:1000000                                        " Don't fold

" syntax improvements
let g:python_highlight_all = 1
let g:tex_flavor = 'latex'
" }}}

" ===== INDENT AND STYLE =================== {{{
set shiftwidth=4                                                  " Reduntant with above
set tabstop=4                                                     " How many spaces on tab
set softtabstop=4                                                 " One tab = 4 spaces
set expandtab                                                     " Tabs are spaces
set autoindent                                                    " Auto-ident
set smartindent                                                   " Smart ident
set shiftround                                                    " Round indent to multiple of 'shiftwidth'
set smarttab                                                      " Reset autoindent after a blank line
" }}}

" ===== UNDO FILES ========================= {{{
silent !mkdir ~/.nvim/backups > /dev/null 2>&1
set undodir=~/.nvim/backups
set undofile
" }}}

" ===== SEARCH ============================= {{{
set incsearch							  " Incremental search. Search highlighting with this.
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
set ignorecase							  " disable case sensitive searches
set smartcase							  " only search case insensitive if all lowercase
" }}}

" ===== COMPLETION ========================= {{{
set wildmode=longest,full                                         "stuff to ignore when tab completing
set wildmenu
set wildignorecase
set wildignore+=*.swp,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore=*.o,*.obj,*~
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg

set completeopt=menu,menuone,noselect

set shortmess+=c                                                    " suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess-=F
set dictionary+=/usr/share/dict/words
" }}}

" ===== AUTOCOMMANDS ======================= {{{
augroup active_win
    " dont show column
    autocmd BufEnter *.* :set colorcolumn=0

    " show cursor line only in active windows
    autocmd FocusGained,VimEnter,WinNew,WinEnter,BufWinEnter * setlocal cursorline
    autocmd FocusLost,WinLeave * setlocal nocursorline

    " highlight active window
    autocmd FocusGained,VimEnter,WinNew,WinEnter,BufWinEnter * set winhighlight=Normal:Normal,EndOfBuffer:EndOfBuffer,SignColumn:Normal,VertSplit:EndOfBuffer
    autocmd FocusLost,WinLeave * set winhighlight=Normal:NormalNC,EndOfBuffer:EndOfBufferNC,SignColumn:NormalNC,VertSplit:EndOfBufferNC
augroup END

augroup fileAuto
    autocmd!
    " Create directories before saving if they don't exist.
    autocmd BufWritePre *
		\ if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) |
		\ call mkdir(expand('<afile>:h'), 'p') |
		\ endif
    " Remove all trailing whitepace on save
    autocmd BufWritePre * %s/\s\+$//e
augroup end

augroup disableAutocomments
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup end

" When term starts, auto go into insert mode
autocmd TermOpen * startinsert

" Turn off line numbers etc
autocmd TermOpen * setlocal listchars= nonumber norelativenumber
" }}}

" ===== MAPPINGS =========================== {{{

" center after search
nnoremap n nzz
nnoremap N Nzz

" shifting visual block should keep it selected
vnoremap < <gv
vnoremap > >gv|

" automatically jump to end of text you pasted
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" quickly select text you pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" go up/down on visual line
map j gj
map k gk

" disable keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap <space> <nop>
nnoremap <esc> <nop>

" Repeat last macro instead of ex mode.
nnoremap Q @@

" The opposite of J in normal mode, this splits a line into two and auto
" indents.
nnoremap gS :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

" resize splits
nnoremap <silent> > :execute "vertical resize +5"<Return>
nnoremap <silent> < :execute "vertical resize -5"<Return>
nnoremap <silent> + :execute "resize +5"<Return>
nnoremap <silent> - :execute "resize -5"<Return>

" buffer switching
nnoremap <S-l> :bnext<Return>
nnoremap <S-h> :bprevious<Return>

" window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" leader mappings
let mapleader = "\<Space>"

" navigate faster
nnoremap <Leader>j 12j
nnoremap <Leader>k 12k

" paste keeping the default register
vnoremap <Leader>p "_dP

" copy & paste to system clipboard
vmap <Leader>y "*y

" set the current directory for the window
nnoremap <Leader>d :lcd %:h<CR>
" }}}

" ===== PLUGINS ============================ {{{

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
end

call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'michal-h21/vim-zettel'
Plug 'junegunn/goyo.vim'
Plug 'jaxbot/semantic-highlight.vim'
Plug 'artur-shaik/vim-javacomplete2', {'type': 'opt'}
Plug 'Harenome/vim-mipssyntax', {'type':'opt'}
Plug 'OmniSharp/omnisharp-vim',{'type': 'opt'}
Plug 'romainl/vim-devdocs'
Plug 'moll/vim-bbye'
Plug 'christoomey/vim-tmux-navigator'
Plug 'drzel/vim-scrolloff-fraction'
Plug 'psliwka/vim-smoothie'
Plug 'itchyny/lightline.vim'
Plug 'romainl/Apprentice'
call plug#end()
" }}}

" ===== PLUGIN CONFIG ====================== {{{
" Ultisnips
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'custom-snippets']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"

" Fzf
let g:fzf_command_prefix = 'Fz'

let $FZF_DEFAULT_COMMAND =  'rg --files --hidden -S'

let height = (&lines - 3) * 4 / 6 - 2
let prev_str = '--preview="head -n ' . height . ' {}"'
let $FZF_DEFAULT_OPTS= '--layout=reverse ' . prev_str . '
    \ --color=dark --color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
    \ --color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines - 3
    let width = float2nr(&columns - (&columns * 2 / 10))
    let col = float2nr((&columns - width) / 2)

    let opts = {
		\ 'relative': 'editor',
		\ 'row': height / 6,
		\ 'col': col,
		\ 'width': width,
		\ 'height': height * 4 / 6
		\ }

    call nvim_open_win(buf, v:true, opts)
endfunction

" search current project directory
nmap <Leader><Tab> :FzFiles<CR>
" search home and code directory
nmap <Leader>f :FzFiles ~<CR>
nmap <Leader>c :FzFiles ~/doc/code<CR>
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
nnoremap <leader>n :Rg
" buffers and lines
nmap <Leader>b :FzBuffers<CR>
nmap <Leader>l :FzLines<CR>

" Goyo
let g:goyo_width = '80%'
let g:goyo_height = '80%'

" Notetaking
function! s:goyo_enter()
    if exists('$TMUX')
    endif
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    set noshowcmd
endfunction
function! s:goyo_leave()
    if exists('$TMUX')
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
" Goyo down, time for zettel
" Filename format. The filename is created using strftime() function
let g:zettel_format = "%y%m%d-%H%M"
" Disable default keymappings
let g:zettel_default_mappings = 0
" This is basically the same as the default configuration
augroup filetype_markdown
  autocmd!
  autocmd Filetype markdown
              \ if expand('%:h:t') == 'notes' |
              \     set path+=/home/yack/doc/notes |
              \ endif
  autocmd FileType markdown imap <silent> [[ [[<esc><Plug>ZettelSearchMap
  autocmd FileType markdown nmap T <Plug>ZettelYankNameMap
  autocmd FileType markdown xmap z <Plug>ZettelNewSelectedMap
  autocmd FileType markdown nmap gZ <Plug>ZettelReplaceFileWithLink
augroup END

nnoremap <Leader>s :SemanticHighlightToggle<cr>

augroup javaPlugins
    autocmd FileType java packadd vim-javacomplete2
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
augroup end

augroup mipsPlugins
    autocmd Filetype asm packadd vim-mipssyntax
    autocmd Filetype asm setlocal syntax="mips"
augroup end

augroup csharpPlugins
    autocmd Filetype cs packadd omnisharp-vim
augroup end

let g:vebugger_use_tags=1
let g:vebugger_leader = '<Leader>d'

let g:scrolloff_fraction=0.2
" }}}

" ===== LSP ================================ {{{
lua <<EOF
require('lspconfig').ccls.setup{}
require('lspconfig').pyls.setup{}
require('lspconfig').texlab.setup{}
require('lspconfig').omnisharp.setup{}
EOF
" }}}

" ===== LANGUAGE FORMATTING ================ {{{
augroup javaFMT
    autocmd Filetype java setlocal softtabstop=2 shiftwidth=2
    autocmd Filetype java let g:java_highlight_all = 1
    autocmd Filetype java let g:java_space_errors = 1
    autocmd Filetype java let g:java_comment_strings = 1
    autocmd Filetype java let g:java_highlight_functions = 1
    autocmd Filetype java let g:java_highlight_debug = 1
    autocmd Filetype java let g:java_mark_braces_in_parens_as_errors = 1
augroup end

augroup pythonFMT
    autocmd Filetype python setlocal formatprg=yapf
    autocmd FileType python let g:python_highlight_all = 1
    autocmd FileType python let g:semshi#error_sign=v:false
    autocmd FileType python let g:semshi#always_update_all_highlights=v:true
augroup end

augroup webFMT
    autocmd FileType javascript,css,javascriptreact setlocal formatprg=prettier\ --stdin\ --stdin-filepath\ %
augroup end

augroup csharpFMT
    autocmd Filetype cs let g:OmniSharp_server_stdio = 1
    autocmd Filetype cs let g:OmniSharp_highlight_types = 3
augroup end
" }}}

" ===== TERMINAL =========================== {{{

function! OpenTerm(cmd)
    call CreateCenteredFloatingWindow()
    call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
endfunction

" Open Project
let s:project_open = 0
function! ToggleProject()
    if s:project_open
        bd!
        let s:project_open = 0
    else
        call OpenTerm('tmuxinator-fzf-start.sh')
        let s:project_open = 1
    endif
endfunction
let s:scratch_open = 0
function! ToggleScratchTerm()
    if s:scratch_open
        bd!
        let s:scratch_open = 0
    else
        call OpenTerm('bash')
        let s:scratch_open = 1
    endif
endfunction

let s:lazygit_open = 0
function! ToggleLazyGit()
    if s:lazygit_open
        bd!
        let s:lazygit_open = 0
    else
        call OpenTerm('lazygit')
        let s:lazygit_open = 1
    endif
endfunction

function! OnTermExit(job_id, code, event) dict
    if a:code == 0
        bd!
    endif
endfunction
" }}}

" ===== COLORS ============================= {{{
set background=dark
colorscheme apprentice
" }}}


