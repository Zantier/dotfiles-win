" For vim.tiny

set nocompatible

source ~/.mybase.vim

" Sensible behaviour when switching buffers
set hidden

" Better command-line completion
set wildmenu

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files
set confirm

" No beep or flash
set vb t_vb=

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Use light colours
set bg=dark

set cursorline
" Commented out because the default is fine
"hi CursorLine cterm=none ctermbg=none guibg=#404040
"hi Pmenu ctermfg=Gray ctermbg=Black
"hi FloatBorder ctermfg=Gray ctermbg=Black

" Allow loading local .vimrc
set exrc
