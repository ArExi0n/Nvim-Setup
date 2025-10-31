require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",
        "rust", "python", "javascript", "typescript",
        "json", "toml", "markdown", "markdown_inline"
    },

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}
