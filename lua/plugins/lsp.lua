return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "basedpyright",
                "ruff",
                "lua_ls",
                "vtsls",
                "html",
                "cssls",
                "jsonls",
                "eslint",
                "tailwindcss",
                "texlab",
            },
            automatic_enable = false,
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "basedpyright",
                "ruff",
                "lua_ls",
                "vtsls",
                "html",
                "cssls",
                "jsonls",
                "eslint",
                "tailwindcss",
                "texlab",
                "clang-format",
                "prettierd",
                "stylua",
                { "tree-sitter-cli", version = "v0.25.10" },
            },
            run_on_start = true,
            start_delay = 3000,
            debounce_hours = 24,
        })
        require("config.lsp")
    end,
}
