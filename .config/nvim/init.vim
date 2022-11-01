set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

lua << EOF
-- To install, simply copy repo into ~/.config/nvim/pack/vendor/start/
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "help" },
    sync_install = false,
    auto_install = true,
    ignore_install = { "javascript" },
    indent = { enable = true },
    highlight = { enable = true }
}

-- Below is an example of how to setup a treesitter parser offline
-- Make sure you use the correct git commit in the nvim-treesitter lockfile
--
--local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--parser_config.kotlin = {
--    install_info = {
--        url = "~/software/tree-sitter-kotlin",
--        files = {"src/parser.c", "src/scanner.c"},
--        generate_requires_npm = false,
--        requires_generate_From_grammar = false,
--    },
--    filetype = "kt"
--}
--local ft_to_parser = require "nvim-treesitter.parsers".filetype_to_parsername
--ft_to_parser.kt = "kotlin"

-- Some sample LSP stuff
-- Just clone nvim-lspconfig in the usual place
-- TODO: Cleanup to only have stuff I use...
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.diagnostic.config { signs = true, underline = true, virtual_text = false}
vim.fn.sign_define("DiagnosticSignError", {text="", numhl="DiagnosticError"})
vim.fn.sign_define("DiagnosticSignWarn", {text="", numhl="DiagnosticWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text="", numhl="DiagnosticInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text="", numhl="DiagnosticHint"})

local func_copy = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return func_copy(contents, syntax, opts, ...)
end

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig')['clangd'].setup{
    on_attach = on_attach
}
EOF
