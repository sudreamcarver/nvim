--vim.lsp.enable 'clangd'
--vim.lsp.enable 'jsonls'
--vim.lsp.enable 'ccls'
--vim.lsp.enable 'lua_ls'
--vim.lsp.enable 'pyright'

--vim.lsp.set_log_level("debug")

local group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local opts = { buffer = bufnr, silent = true }
        local km = vim.keymap.set

        if client.server_capabilities.definitionProvider then
            km("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: goto definition" }))
        end
        if client.server_capabilities.declarationProvider then
            km("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP: goto declaration" }))
        end
        if client.server_capabilities.implementationProvider then
            km("n", "gi", vim.lsp.buf.implementation, opts)
        end
        if client.server_capabilities.referencesProvider then
            km("n", "gr", vim.lsp.buf.references, opts)
        end
        if client.server_capabilities.hoverProvider then
            km("n", "K", vim.lsp.buf.hover, opts)
        end

        km("n", "<leader>rn", vim.lsp.buf.rename, opts)
        km({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        km("n", "[g", vim.diagnostic.goto_prev, opts)
        km("n", "]g", vim.diagnostic.goto_next, opts)
        km("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})
