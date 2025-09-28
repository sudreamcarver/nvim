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


--local function get_project_root(fname)
  --local lsp_util = require('lspconfig.util')
--
  ---- 1. 首先，尝试使用 lspconfig 的标准方法寻找项目根目录
  --local root = lsp_util.root_pattern('.ccls', 'compile_commands.json', '.git')(fname)
  --if root then
    --return root
  --end
--
  ---- 2. 如果失败了（比如我们在一个系统头文件里），就去“借用”已激活的 ccls 客户端的根目录
  --local clients = vim.lsp.get_active_clients({ name = "ccls" })
  --if #clients > 0 then
    --return clients[1].root_dir
  --end
--
  ---- 3. 作为最后的备用方案，返回当前工作目录
  --return vim.fn.getcwd()
--end



---@type vim.lsp.Config
return {
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = { 'compile_commands.json', '.ccls', '.git' },
    offset_encoding = 'utf-32',
    -- ccls does not support sending a null root directory
    workspace_required = true,
    --root_dir = get_project_root,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspCclsSwitchSourceHeader', function()
            switch_source_header(client, bufnr)
        end, { desc = 'Switch between source/header' })
    end,
}
