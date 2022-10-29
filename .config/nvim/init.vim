set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

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
EOF
