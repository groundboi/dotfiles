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
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>"
        }
    }
}

----------------------------------------------------------
-- LSP stuff
-- Note: Additional keybindings can use type_definition, implementation
----------------------------------------------------------
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
vim.keymap.set('n', '<leader>l', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>i', vim.diagnostic.setqflist, opts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>h', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Clangd for C and C++
require('lspconfig')['clangd'].setup{
    on_attach = on_attach,
}

----------------------------------------------------------
-- Theme
----------------------------------------------------------
require('nightfox').setup({
    options = {
        styles = {
            comments = "italic",
            keywords = "bold",
            functions = "bold",
        }
    }
})
vim.cmd("colorscheme nightfox")

----------------------------------------------------------
-- Plugins
----------------------------------------------------------
-- nvim-tree and its deps. Note, need a patched nerdfont installed
require("nvim-web-devicons").setup()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>m', ':NvimTreeFindFileToggle<CR>')

-- nvim-illuminate and autopairs
require('illuminate').configure()
require('nvim-autopairs').setup({fast_wrap = {}})

-- gitsigns (needs nvim 0.9.0+ for statuscolumn feature)
require('gitsigns').setup()
vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<CR>')
-- Note, would be even nicer to use `git merge-base --fork-point main` instead of `main`
vim.keymap.set('n', '<leader>gd', ':Gitsigns diffthis main<CR>')
vim.keymap.set('n', ']c', ':Gitsigns next_hunk<CR>')
vim.keymap.set('n', '[c', ':Gitsigns prev_hunk<CR>')
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum?v:relnum:v:lnum) : ''}%s"
vim.opt.signcolumn = "yes:1"
vim.opt.numberwidth = 2
EOF

" Because we have additional_vim_regex_highlighting as false (default), 'syntax'
" highlighting will NOT be used for vimscript, instead using treesitter syntax
" highlighting. But, vims regex syntax highlighting actually looks better for
" vimscript when combined with treesitter. Though for embedded heredoc lua,
" vim regex hl freaks out...so, we syntax enable on ONLY vimrc.
autocmd BufReadPost * if (expand('%') == '.vimrc')
           \ | :setl syntax=ON
           \ | endif
