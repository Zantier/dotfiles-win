" This file should be sourced from .vimrc

" Example .vimrc:

"set nocompatible
"
"" Install vim-plug, if it isn't already
"" Call :PlugInstall to install plugins
"if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif
"
"call plug#begin('~/.vim/plugged')
"Plug 'easymotion/vim-easymotion'
"Plug 'tpope/vim-surround'
"call plug#end()
"
"autocmd FileType html setlocal ts=2 sts=2 sw=2
"autocmd FileType css setlocal ts=2 sts=2 sw=2
"autocmd FileType javascript setlocal ts=2 sts=2 sw=2
"
"source ~/.my.vim


" http://vim.wikia.com/wiki/Example_vimrc

"------------------------------------------------------------
" Essential
filetype plugin indent on
syntax on

"------------------------------------------------------------
" Must have options

" Sensible behaviour when switching buffers
set hidden
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch


"------------------------------------------------------------
" Usability options

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line
set startofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell
" Don't output any visual bell character
set t_vb=

" Enable use of the mouse for all modes
"set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Time out very quickly on keycodes
set ttimeout ttimeoutlen=100
" Time out slowly on mappings
set timeout timeoutlen=1000

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

"------------------------------------------------------------

" Cursor
let &t_SI.="\e[5 q"
let &t_SR.="\e[3 q"
let &t_EI.="\e[1 q"
" Enter/exit termcap
"let &t_ti.="\e[1 q"
"let &t_te.="\e[0 q"

" Width of tab character, width of tab key, auto-indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Use spaces, not tabs - easier to copy and paste code to and from the browser
" e.g. chat, wikis, stackoverflow, playgrounds, competitions
set expandtab
" For python files, vim sets expandtab ts=8 sts=4 sw=4
autocmd FileType python setlocal ts=4

let mapleader=","
" Allow loading local .vimrc
set exrc
" Use sensible regex
set magic
" Stop using dark colours against black background:
set bg=dark
set clipboard=unnamed " Use the Windows clipboard i.e. "*
set scrolloff=10 " Keep lines below and above the cursor
inoremap jk <esc>
inoremap kj <esc>
nnoremap ' `
" Auto-indent whole file
nnoremap <leader>= mzgg=G`z

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_re_anywhere = '\v<[A-Za-z0-9]|(^|[ \t]+)@<=[^ \tA-Za-z0-9]([^A-Za-z0-9]|$){4}'
nmap ,f <Plug>(easymotion-jumptoanywhere)
vmap ,f <Plug>(easymotion-jumptoanywhere)

" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"set completeopt=longest,menuone
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

set cursorline
hi CursorLine cterm=NONE ctermbg=Black guibg=Black

" pl == prolog
let g:filetype_pl="prolog"

nnoremap <leader>m :wa<cr>:!make && make run<cr>
nnoremap <leader>1 :wa<cr>:!make && make run1<cr>
nnoremap <leader>2 :wa<cr>:!make && make run2<cr>
nnoremap <leader>3 :wa<cr>:!make && make run3<cr>
nnoremap <leader>4 :wa<cr>:!make && make run4<cr>
nnoremap <leader>5 :wa<cr>:!make && make run5<cr>
