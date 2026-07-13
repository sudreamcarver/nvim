local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet("b", fmt("**{}**{}", {
        ls.insert_node(1, "text"),
        ls.insert_node(0),
    })),
}
