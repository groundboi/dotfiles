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

EOF
