----------------------
-- Basic configuration
----------------------
vim.opt.tabstop = 4                         -- width that a <TAB> char displays as
vim.opt.softtabstop = 4                     -- backspace after pressing <TAB> will remove up to this many spaces
vim.opt.shiftwidth = 4                      -- number of spaces to use for auto-indent
vim.opt.expandtab = true                    -- convert <TAB> keypress to spaces
vim.opt.number = true                       -- show line numbers
vim.opt.relativenumber = true               -- use relative line numbers for easier jumps
vim.opt.cursorline = true                   -- highlight current line
vim.opt.wildmenu = true                     -- autocomplete menu for commands
vim.opt.wildmode = 'longest:full'           -- don't auto-fill the first match when tab completing in commands
vim.opt.completeopt = 'menu,longest,menuone,popup' -- similar as above, but for ins-mode completion
vim.opt.wildoptions = 'pum'                 -- use popup menu for completion
vim.opt.splitbelow = true                   -- horizontal splits are added below
vim.opt.splitright = true                   -- vertical splits are added to right
vim.opt.ignorecase = true                   -- ignore case in search results
vim.opt.smartcase = true                    -- ...unless there is a capital in the search
vim.opt.mouse = 'a'                         -- mouse support, nice for resizing splits
vim.opt.scrolloff = 5                       -- have a few context lines when scrolling
vim.opt.listchars = {trail="-", tab="> "}   -- show trailing whitespace with this char
vim.opt.list = true                         -- needed for the above setting
vim.opt.undofile = true                     -- persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undodir') -- persistent undo dir. Note that this dir must exist already
vim.opt.signcolumn = "yes:1"                -- with gitsigns, makes for nicer number/status column
vim.opt.numberwidth = 2                     -- with gitsigns, makes for nicer number/status column
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum?v:relnum:v:lnum) : ''}%s" -- same comment as above
vim.opt.termguicolors = true                -- enable 24-bit RGB colors
vim.g.mapleader = ' '                       -- set space to leader key
vim.g.maplocalleader = ' '                  -- ...and local leader key, just in case for ft plugins

---------------------------
-- Normal mode key mappings
---------------------------
vim.keymap.set('n', '<Esc>', ':nohl | cclose | lclose | helpclose<CR>')     -- clear highlighting, quickfix, loclist, help
vim.keymap.set('n', '<leader>s', ':setlocal spell! spelllang=en_us<CR>')    -- spell check
vim.keymap.set('n', '<C-X>', ':close<CR>')                                  -- close current split
vim.keymap.set('n', '<Tab>', ':cnext<CR>zz', { silent = true })             -- cycle forward in qfix list
vim.keymap.set('n', '<S-Tab>', ':cprev<CR>zz', { silent = true })           -- cycle backwards in qfix list
vim.keymap.set('n', '<leader>y', '"+y')                                     -- yank to system clipboard
vim.keymap.set('n', '<leader>d', '"_d')                                     -- delete into null register
vim.keymap.set('n', '<leader>r', ':%s/<<C-r><C-w>>/')                       -- search/replace word under cursor for current buffer
vim.keymap.set('n', '<C-d>', '<C-d>zz')                                     -- nicer move down in buffer
vim.keymap.set('n', '<C-u>', '<C-u>zz')                                     -- nicer move up in buffer

---------------------------
-- Insert mode key mappings
---------------------------
vim.keymap.set('i', '<C-]>', '<C-X><C-]>')                          -- tag completion
vim.keymap.set('i', '<C-F>', '<C-X><C-F>')                          -- filename completion
vim.keymap.set('i', '<C-D>', '<C-X><C-D>')                          -- def/macro completion
vim.keymap.set('i', '<C-L>', '<C-X><C-L>')                          -- line completion
vim.keymap.set('i', '<C-O>', '<C-X><C-O>')                          -- omni-completion, likely via LSP
vim.keymap.set({'i','s'}, '<Tab>', 'v:lua.smart_tab_complete()', {  -- nicer use of tab in several scenarios
    expr=true, noremap=false
})

---------------------------
-- Visual mode key mappings
---------------------------
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")    -- move block down, auto-indenting along the way
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")    -- move block up, auto-indenting along the way

----------------------------------------------------
-- A few useful autocommands for minor visual things
----------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', {clear = true}),
    callback = function()
        vim.highlight.on_yank()
    end
})
vim.api.nvim_create_autocmd("WinEnter", {
    group = vim.api.nvim_create_augroup('enter-cursor', {clear = true}),
    command = "setl cursorline"
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = vim.api.nvim_create_augroup('leave-nocursor', {clear = true}),
    command = "setl nocursorline"
})

------------------------------------------------
-- Bootstrapping lazy.nvim for plugin management
-- Note, `:Lazy update` will update all plugins
------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------
-- Plugins, managed by lazy.nvim
--------------------------------
require("lazy").setup({
{
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = {'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc'},
        auto_install = true,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex hl system for indents.
            -- If experiencing weird indenting, add language below
            additional_vim_regex_highlighting = {'ruby'},
        },
        indent = {enable = true, disable = {'ruby'}},
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",        -- enter will incrementally visually select higher scopes
                node_incremental = "<CR>",      -- enter will incrementally visually select higher scopes
                scope_incremental = "<S-CR>",   -- enter will incrementally visually select higher scopes
                node_decremental = "<BS>"       -- backspace will decrementally visually select lower scopes
            }
        }
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end
},
{
    'neovim/nvim-lspconfig',
    config = function()
        require("lspconfig")['gopls'].setup{
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    completeUnimported = true,
                }
            }
        }
        require("lspconfig")['clangd'].setup{}

        vim.diagnostic.config{signs = true, underline = true, virtual_text = true, float = {border = "rounded"}}
        vim.fn.sign_define("DiagnosticSignError", {text="", numhl="DiagnosticError"})
        vim.fn.sign_define("DiagnosticSignWarn", {text="", numhl="DiagnosticWarn"})
        vim.fn.sign_define("DiagnosticSignInfo", {text="", numhl="DiagnosticInfo"})
        vim.fn.sign_define("DiagnosticSignHint", {text="", numhl="DiagnosticHint"})
    end
},
{
    'RRethy/vim-illuminate',
    -- We have to do this because plugin annoyingly calls this "configure" rather than "setup"
    config = function()
        require('illuminate').configure({})
    end
},
{
    'lewis6991/gitsigns.nvim',
    config = true,
    lazy = false,
    keys = {
        -- Note, would be nicer to use `git merge-base --fork-point main` instead of `main`
        {'<leader>gd', ':Gitsigns diffthis main<CR>'},  -- diff current buffer with counterpart in main
        {'<leader>gb', ':Gitsigns blame_line<CR>'},     -- git blame on current line
        {']c', ':Gitsigns next_hunk<CR>'},              -- go to next git change
        {'[c', ':Gitsigns prev_hunk<CR>'},              -- go to prev git change
    }
},
{
    'nvim-tree/nvim-tree.lua',
    dependencies = {"nvim-tree/nvim-web-devicons"},     -- optional
    config = true,
    keys = {
        {'<leader>n', ':NvimTreeToggle<CR>'},           -- Toggle file tree for cwd
        {'<leader>m', ':NvimTreeFindFileToggle<CR>'},   -- Toggle file tree for dir of current file
    }
} ,
{
    "ibhagwan/fzf-lua",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},     -- optional
    opts = {keymap = {
        fzf = {["ctrl-q"] = "select-all+accept"}},      -- ctrl-q sends all fzf results to qf list
        winopts = {preview = {default = 'bat'}}         -- can also use bat_native
    },
    keys = {
        {'<leader><SPACE>', ':FzfLua files<CR>'},       -- open fzf search for files to open
        {'\\', ':FzfLua live_grep_native<CR>'},         -- live grep over current project
        {'S', ':FzfLua grep_cword<CR>'},                -- grep word under cursor
        {'S', ':FzfLua grep_visual<CR>', mode = 'v'},   -- grep visual selection
        {'<leader>b', ':FzfLua buffers<CR>'}            -- list buffers
    }
},
{
    "sindrets/diffview.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},     -- optional
    config = true
},
{
    'jinh0/eyeliner.nvim',
    opts = {highlight_on_key = true, dim = true}
},
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
},
{
    'EdenEast/nightfox.nvim',
    lazy = false, -- load at startup
    priority = 1000, -- load colorscheme before all other plugins, otherwise things get screwy
    opts = {options = {styles = {comments = "italic", keywords = "bold", functions = "bold"}}},
    init = function()
        vim.cmd.colorscheme 'nightfox'
    end
},
{
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
  },
},
})

--------------------------
-- Generic LSP keymappings
--------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufopts = {noremap = true, silent = true, buffer = args.buf}
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)            -- go to definition
        -- Note, CTRL-] also goes to definition by default!
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)            -- populate qflist with references
        -- As of nvim 0.10.0, 'K' by default maps to vim.lsp.buf.hover        -- popup hover information on symbol
        vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)        -- signature help on function args
        vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, bufopts)     -- ins-mode signature help on function args
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, bufopts)        -- rename symbol
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)   -- view/take possible code actions
        vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, bufopts) -- view diagnostic for line
        vim.keymap.set('n', '<leader>cq', vim.diagnostic.setqflist, bufopts)  -- populate qflist with all diagnostic issues
        -- As of nvim 0.10.0, '[d' and ']d' go to diagnostics by default!     -- go to previous/next diagnostic in buffer
        vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.api.nvim_buf_set_option(args.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
})

-------------------------------
-- Our own basic tab-completion
-- Used by a keymap above
-------------------------------
function smart_tab_complete()
    local omnifunc = vim.api.nvim_buf_get_option(0, 'omnifunc')
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local linetext = vim.api.nvim_get_current_line()
    local should_tab = col == 0 or string.match(linetext:sub(col, col), '%s') ~= nil

    if vim.fn.pumvisible() == 1 then
        return "<C-N>"      -- advance to next option in popup menu
    elseif should_tab then
        return "<Tab>"      -- do an actual tab
    elseif omnifunc ~= nil and omnifunc ~= '' then
        return "<C-X><C-O>" -- do omni-completion, likely via LSP
    else
        return "<C-X><C-N>" -- do built-in buffer-based word completion
    end
end

-----------------------------------
-- Highlighting trailing whitespace
-----------------------------------
vim.cmd([[match TrailingWhitespace /\s\+$/]])
vim.api.nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })

-- The below autocmds are so we don't highlight in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.api.nvim_set_hl(0, "TrailingWhitespace", { link = "Whitespace" })
    end
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        vim.api.nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })
    end
})

-----------------------------------
-- Use tabs for Go, not spaces
-----------------------------------
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"go"},
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-------------
-- Statusline
-------------
vim.opt.statusline = string.format(
    "%s %s%s%s%s%s",
    "%#MatchParen#%{get(b:,'gitsigns_head','')}%*",
    "%f %m %r",
    "%=",
    " %y",
    " %{&fileencoding?&fileencoding:&encoding}",
    " %l/%L %p%% "
)
