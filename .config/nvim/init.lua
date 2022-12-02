vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'neovim/nvim-lspconfig'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

source ~/.mytiny.vim

autocmd FileType css setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType html setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType javascript setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType typescript setlocal expandtab ts=2 sts=2 sw=2
" For python files, vim sets expandtab ts=8 sts=4 sw=4
autocmd FileType python setlocal ts=4
autocmd BufNewFile,BufRead *.tsx set filetype=typescript

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_re_anywhere = '\v<[A-Za-z0-9]|(^|[ \t]+)@<=[^ \tA-Za-z0-9]([^A-Za-z0-9]|$){4}'


" Mappings
"---------
" Turn off search highlight and redraw screen
nnoremap <C-L> :nohl<CR><C-L>
nmap ,f <Plug>(easymotion-jumptoanywhere)
vmap ,f <Plug>(easymotion-jumptoanywhere)
nmap gf :Files<cr>
inoremap <c-space> <c-x><c-o>
]])

require'lspconfig'.pyright.setup{}
require'lspconfig'.tsserver.setup{}
-- Doesn't work with nvim_set_option
vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition)
vim.keymap.set('n', ',i', vim.lsp.buf.hover)
