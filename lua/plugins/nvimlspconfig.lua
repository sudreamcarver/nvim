return {
    'neovim/nvim-lspconfig',

    -- 确保 lspconfig 在 mason 之后配置
    dependencies = {
        'williamboman/mason.nvim'
    },

    -- 添加这个 config 函数，这是所有魔法发生的地方
    config = function()
        -- 加载我们为 ccls 编写的、现在位于正确路径的配置文件
        local ccls_config = require('lsp.ccls')

        -- 调用 lspconfig 的 setup 函数来应用您的专属配置
        vim.lsp.config('ccls', ccls_config)
        vim.lsp.config('lua_ls', {})
        vim.lsp.config('pyright', {})
        vim.lsp.config('jsonls', {})

        -- (推荐) 在这里统一配置其他 LSP 服务器
        -- 比如加载您的 lua_ls.lua, pyright.lua 等配置
        --require('lspconfig').lua_ls.setup(require('lsp.lua_ls'))
        --require('lspconfig').pyright.setup(require('lsp.pyright'))
        --require('lspconfig').jsonls.setup(require('lsp.jsonls'))
    end,
}
