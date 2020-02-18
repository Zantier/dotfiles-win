" Source this file from .vimrc

set nocompatible

" Install vim-plug, if it isn't already
" Call :PlugInstall to install plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
call plug#end()

source ~/.mytiny.vim

" Essential
filetype plugin indent on
syntax on

" Cursor
let &t_SI.="\e[5 q"
let &t_SR.="\e[3 q"
let &t_EI.="\e[1 q"
" Enter/exit termcap
"let &t_ti.="\e[1 q"
"let &t_te.="\e[0 q"

autocmd FileType css setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType html setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType javascript setlocal expandtab ts=2 sts=2 sw=2
" For python files, vim sets expandtab ts=8 sts=4 sw=4
autocmd FileType python setlocal ts=4

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_re_anywhere = '\v<[A-Za-z0-9]|(^|[ \t]+)@<=[^ \tA-Za-z0-9]([^A-Za-z0-9]|$){4}'



" Mappings
"---------
" Turn off search highlight and redraw screen
nnoremap <C-L> :nohl<CR><C-L>
nmap ,f <Plug>(easymotion-jumptoanywhere)
vmap ,f <Plug>(easymotion-jumptoanywhere)
