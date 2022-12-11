vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'

" nvim-cmp - auto-complete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

call plug#end()

set completeopt=menu,menuone,noselect

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

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition)
vim.keymap.set('n', ',i', vim.lsp.buf.hover)


-- nvim-cmp

local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').pyright.setup {
    capabilities = capabilities
}
require('lspconfig').tsserver.setup {
    capabilities = capabilities
}
