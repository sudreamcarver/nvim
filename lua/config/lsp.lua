local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
    "clangd",
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
}

for _, server in ipairs(servers) do
    vim.lsp.config(server, { capabilities = capabilities })
end

vim.lsp.config("clangd", {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
    },
})

vim.lsp.config("basedpyright", {
    capabilities = capabilities,
    settings = {
        basedpyright = {
            analysis = {
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.enable(servers)

vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 2, source = "if_many" },
    float = { border = "rounded", source = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "LSP definition")
        map("n", "gy", vim.lsp.buf.type_definition, "LSP type definition")
        map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
        map("n", "gr", vim.lsp.buf.references, "LSP references")
        map("n", "K", vim.lsp.buf.hover, "LSP hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("n", "[g", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous diagnostic")
        map("n", "]g", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Next diagnostic")

        if client:supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("UserLspHighlight" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
                group = group,
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = group,
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end
    end,
})
