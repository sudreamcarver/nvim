return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = { "n", "v" },
            desc = "Format buffer or selection",
        },
    },
    opts = {
        formatters = {
            -- clang-format 23 no longer falls back to ~/.clang-format when no
            -- project .clang-format is found, so point it at the global file
            -- explicitly.
            ["clang-format"] = {
                prepend_args = { "--style=file:/home/carver/.clang-format" },
            },
        },
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            objc = { "clang-format" },
            objcpp = { "clang-format" },
            python = { "ruff_format" },
            lua = { "stylua" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            javascriptreact = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            vue = { "prettierd", "prettier", stop_after_first = true },
            html = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettierd", "prettier", stop_after_first = true },
            scss = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            jsonc = { "prettierd", "prettier", stop_after_first = true },
            markdown = { "prettierd", "prettier", stop_after_first = true },
        },
        format_on_save = {
            timeout_ms = 1000,
            lsp_format = "fallback",
        },
    },
}
