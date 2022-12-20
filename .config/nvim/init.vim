set runtimepath^=~/.vim
let &packpath = &runtimepath
source ~/.vimrc

" Quick highlight of what was just yanked
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

lua << EOF
----------------------------------------------------------
-- Treesitter config for syntax highlighting, indent, etc.
----------------------------------------------------------
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "kotlin" },
    sync_install = false,
    auto_install = false,
    -- Maybe set below to true? Says experimental feature...
    indent = { enable = false },
    highlight = { enable = true }
}

----------------------------------------------------------
-- LSP stuff
----------------------------------------------------------
-- Keybindings
-- Note: Can additionally set keymaps for type_definition, implementation, signature_help
--
-- <leader>e        Display popup diagnostic
-- [d               Jump to next diagnostic
-- ]d               Jump to prev diagnostic
-- <leader>q        Show all diagnostics in location list
-- CTRL-o           (ins mode) LSP-powered omni completion
-- gD               Jump to declaration (many servers dont implement)
-- gd               Jump to definition of symbol/type
-- K                Display popup of info on symbol under cursor
-- <leader>rn       Rename symbol
-- <leader>ca       Take suggested "code action" on diagnostic
-- <leader>f        Format buffer according to LSP

-- Nicer border for LSP popup windows
local func_copy = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return func_copy(contents, syntax, opts, ...)
end

-- LSP diagnostic display settings. Can turn off virtual_text if too annoying
vim.diagnostic.config { signs = true, underline = true, virtual_text = true }
vim.fn.sign_define("DiagnosticSignError", {text="", numhl="DiagnosticError"})
vim.fn.sign_define("DiagnosticSignWarn", {text="", numhl="DiagnosticWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text="", numhl="DiagnosticInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text="", numhl="DiagnosticHint"})

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Clangd for C and C++
require('lspconfig')['clangd'].setup{
    on_attach = on_attach,
}
EOF

" Because we have additional_vim_regex_highlighting as false (default), 'syntax'
" highlighting will NOT be used for vimscript, instead using treesitter syntax
" highlighting. But, vims regex syntax highlighting actually looks better for
" vimscript when combined with treesitter. Though for embedded heredoc lua,
" vim regex hl freaks out...so, we syntax enable on ONLY vimrc.
autocmd BufReadPost * if (expand('%') == '.vimrc')
           \ | :setl syntax=ON
           \ | endif
