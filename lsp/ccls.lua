---@brief
---
--- https://github.com/MaskRay/ccls/wiki
---
--- ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
--- as compile_commands.json or, for simpler projects, a .ccls.
--- For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html). Alternatively, you can use [Bear](https://github.com/rizsotto/Bear).
---
--- Customization options are passed to ccls at initialization time via init_options, a list of available options can be found [here](https://github.com/MaskRay/ccls/wiki/Customization#initialization-options). For example:
---

vim.lsp.config("ccls", {
    init_options = {
        compilationDatabaseDirectory = "",
        cache = {
            directory = ".ccls_cache",
            hierarchicalPath = true,
            format = "binary",
        },
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = { "-frounding-math" },
        },
        client = {
            snippetsSupport = true,
            placeholder = true,
        },
    }
})


local function switch_source_header(client, bufnr)
    local method_name = 'textDocument/switchSourceHeader'
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client:request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

-- This function is now active. It solves the issue of system headers not being attached to the LSP client.
local function get_project_root(fname)
    local lsp_util = require('lspconfig.util')

    -- 1. First, try to find the project root using standard markers.
    local root = lsp_util.root_pattern('.ccls', 'compile_commands.json', '.git')(fname)
    if root then
        return root
    end

    -- 2. If that fails (e.g., in a system header), "borrow" the root from an already active ccls client.
    --    Using `get_clients` is the modern way to do this.
    local clients = vim.lsp.get_clients({ name = "ccls", bufnr = 0 })
    if #clients > 0 then
        return clients[1].config.root_dir
    end

    -- 3. If no client is active, let lspconfig handle it by returning nil.
    return nil
end

---@type vim.lsp.Config
return {
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = { 'compile_commands.json', '.ccls', '.git' },
    offset_encoding = 'utf-32',
    -- ccls does not support sending a null root directory
    workspace_required = true,

    -- This line is now activated to use our smart root-finding function.
    root_dir = get_project_root,

    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspCclsSwitchSourceHeader', function()
            switch_source_header(client, bufnr)
        end, { desc = 'Switch between source/header' })
    end,
}
