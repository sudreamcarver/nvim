-- ~/.config/nvim/lua/config/diagnostic.lua

print("✅ Loading simplified diagnostics config...")

vim.o.signcolumn = 'yes'


local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
end

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})


-- CursorHold
vim.o.updatetime = 300
local group = vim.api.nvim_create_augroup("CoreDiagnosticsAutocmds", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            scope = "cursor",
            border = "rounded",
            source = "always",
        })
    end,
})
