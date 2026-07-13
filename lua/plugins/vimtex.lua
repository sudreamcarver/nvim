return {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
        vim.g.vimtex_quickfix_mode = 0

        if vim.fn.executable("zathura") == 1 then
            vim.g.vimtex_view_method = "zathura"
        else
            vim.g.vimtex_view_enabled = 0
        end

        if vim.fn.executable("latexmk") == 1 then
            vim.g.vimtex_compiler_method = "latexmk"
        else
            vim.g.vimtex_compiler_enabled = 0
        end
    end
}
