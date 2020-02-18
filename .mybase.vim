" Base settings

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" autoindent when no filetype specified
set autoindent

" Stop certain movements from always going to the first character of a line
set startofline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Display line numbers on the left
set number

" Time out very quickly on keycodes
set ttimeout ttimeoutlen=100
" Time out slowly on mappings
set timeout timeoutlen=1000

" Width of tab character, width of tab key, auto-indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Use spaces, not tabs - easier to copy and paste code to and from the browser
" e.g. chat, wikis, stackoverflow, playgrounds, competitions
set expandtab

" Use sensible regex
set magic

" Make "* the same as the unnamed register
set clipboard=unnamed

" Keep lines below and above the cursor
set scrolloff=10



" Mappings
" --------
map Y y$
inoremap jk <esc>
inoremap kj <esc>
nnoremap ' `
" Auto-indent whole file
nnoremap ,= mzgg=G`z
nnoremap ,m :wa<cr>:!make && make run<cr>
nnoremap ,1 :wa<cr>:!make && make run1<cr>
nnoremap ,2 :wa<cr>:!make && make run2<cr>
nnoremap ,3 :wa<cr>:!make && make run3<cr>
nnoremap ,4 :wa<cr>:!make && make run4<cr>
nnoremap ,5 :wa<cr>:!make && make run5<cr>
