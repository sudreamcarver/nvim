local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_lua").lazy_load({
    paths = vim.fn.stdpath("config") .. "/lua/snippets",
})

luasnip.config.setup({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col > 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local kind_icons = {
    Text = "",
    Method = "ƒ",
    Function = "ƒ",
    Constructor = "",
    Field = "",
    Variable = "v",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "V",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "Operators",
    TypeParameter = "",
}

cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-j>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    formatting = {
        format = function(entry, item)
            item.kind = string.format("%s %s", kind_icons[item.kind] or "", item.kind)
            item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return item
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
    }, {
        { name = "buffer", keyword_length = 3 },
    }),
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    matching = { disallow_symbol_nonprefix_matching = false },
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

local autopairs = require("nvim-autopairs")
autopairs.setup({})
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
