-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter
-- ================================================================================================

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    lazy = false,
    config = function()
        local parsers = {
            "bash",
            "c",
            "cpp",
            "css",
            "dockerfile",
            "go",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "rust",
            "svelte",
            "typescript",
            "vue",
            "vimdoc",
            "yaml",
        }

        -- The current LaTeX grammar must be generated locally by tree-sitter-cli.
        if vim.fn.executable("tree-sitter") == 1 then
            table.insert(parsers, "latex")
        end

        require("nvim-treesitter.configs").setup({
            -- language parsers that MUST be installed
            ensure_installed = parsers,
            -- Grammar generation requires tree-sitter-cli. Avoid runtime errors
            -- when opening a file whose parser is not installed yet.
            auto_install = vim.fn.executable("tree-sitter") == 1,
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "<TAB>",
                    node_decremental = "<S-TAB>",
                },
            },
        })

        local query = require("vim.treesitter.query")
        local directive_opts = vim.fn.has("nvim-0.10") == 1 and { force = true, all = false } or true
        local markdown_aliases = {
            ex = "elixir",
            pl = "perl",
            sh = "bash",
            ts = "typescript",
            uxn = "uxntal",
        }

        local function first_node(value)
            if type(value) == "table" then
                return value.node or value[1]
            end
            return value
        end

        query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
            local node = first_node(match[pred[2]])
            if not node or type(node.range) ~= "function" then
                return
            end

            local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
            if not ok or not text or text == "" then
                return
            end

            local alias = text:lower()
            metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
                or markdown_aliases[alias]
                or alias
        end, directive_opts)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("UserTreesitterFolding", { clear = true }),
            callback = function(args)
                local ok = pcall(vim.treesitter.get_parser, args.buf)
                if not ok then
                    return
                end

                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldlevelstart = 99
            end,
        })
    end,
}
