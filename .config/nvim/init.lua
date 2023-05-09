vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'phaazon/hop.nvim'
" nvim-treesitter requires nightly neovim, and it's buggy
" but it's pretty neat:
"     can format jsx
"     correctly formats multi-line lists in python
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-repeat'
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
" Disable mouse. nvim default is mouse enabled.
set mouse=

source ~/.mytiny.vim

autocmd FileType css setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType html setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType javascript setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType typescript setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType javascriptreact setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType typescriptreact setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType json setlocal expandtab ts=2 sts=2 sw=2
" For python files, vim sets expandtab ts=8 sts=4 sw=4
autocmd FileType python setlocal ts=4

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_re_anywhere = '\v<[A-Za-z0-9]|(^|[ \t]+)@<=[^ \tA-Za-z0-9]([^A-Za-z0-9]|$){4}'

" Mappings
"---------
" Turn off search highlight and redraw screen
nmap gf :Files<cr>
inoremap <c-space> <c-x><c-o>
]])

vim.keymap.set('n', ' .', vim.lsp.buf.code_action)
vim.keymap.set('n', ' r', vim.lsp.buf.rename)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition)
vim.keymap.set('n', ',i', vim.lsp.buf.hover)
vim.keymap.set('n', '<c-l>', function()
    vim.cmd('nohl')
    vim.cmd('exe "norm! \\<c-l>"')
end)

-- Is a floating window open
function is_float_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= '' then
            return true
        end
    end

    return false
end

-- Does basically the same as <c-w>,o
function close_all_floats()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= '' then
            -- Do not force
            vim.api.nvim_win_close(win, false)
        end
    end
end

-- dumps table contents, for debugging
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) == 'string' then k = '"'..k..'"' end
         s = s .. '['..dump(k)..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function is_insert_mode()
    return vim.api.nvim_get_mode()['mode'] == 'i'
end

-- Open diagnostic float, if no other floats open
function open_diagnostic_float()
    local _ = is_float_open() or vim.diagnostic.open_float({border='single'})
end

-- Show line diagnostics automatically in hover window
-- note: vim.o.updatetime is global and should be set only once
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua local _ = is_insert_mode() or open_diagnostic_float()]]

vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = function(args)
        -- Don't want to close autocomplete in insert mode
        if is_insert_mode() then
            return
        end
        close_all_floats()
        open_diagnostic_float()
    end,
})

-- nvim-cmp

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local luasnip = require("luasnip")
local cmp = require'cmp'
local types = require'cmp.types'

cmp.setup({
    -- On autocomplete, don't select first item.
    -- For some reason, completeopt is not respected.
    -- https://www.reddit.com/r/neovim/comments/q66d1p/completeopt_not_being_respected/
    preselect = types.cmp.PreselectMode.None,
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
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
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

-- Set up treesitter
require'nvim-treesitter.configs'.setup {
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}

-- Set up lspconfig.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.denols.setup {
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
}
lspconfig.flow.setup{}
lspconfig.pyright.setup {
    capabilities = capabilities
}
lspconfig.rust_analyzer.setup{}
--lspconfig.tsserver.setup {
--    capabilities = capabilities,
--    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
--}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = "single"
    }
)

--a.a .a...a.a.a
local hop = require('hop')
hop.setup()
vim.keymap.set({'n', 'v'}, ',f', function()
    -- lowercase word, uppercase word, symbol (must not be directly left or right of start of word)
    -- This is the pattern we want to use, but ^ doesn't work correctly: https://github.com/phaazon/hop.nvim/issues/147
    --hop.hint_patterns(nil, '\\v[a-zA-Z0-9]([a-z0-9]+|[A-Z0-9]+|)|(^|[ \\t]+)@<=(.[a-zA-Z0-9])@![^ \\ta-zA-Z0-9]+')
    -- So when matching words, consume any subsequent symbols
    hop.hint_patterns(nil, '\\v[a-zA-Z0-9]([a-z0-9]+|[A-Z0-9]+|)[^ \\ta-zA-Z0-9]*|(^|[ \\t]+)@<=(.[a-zA-Z0-9])@![^ \\ta-zA-Z0-9]+')
end)
