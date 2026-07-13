local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
    s("main", fmt([[
int main(int argc, char **argv) {{
    {}
    return 0;
}}
]], { i(1, "// your code") })),

    s("incs", fmt([[
#include <iostream>
using namespace std;
{}
]], { i(0) })),

    s("cls", fmt([[
class {} {{
public:
    {}();
    ~{}();

private:
    {}
}};
]], { i(1, "ClassName"), rep(1), rep(1), i(0, "// members") })),

    s("fun", fmt([[
{} {}({}) {{
    {}
}}
]], { i(1, "void"), i(2, "func"), i(3, "int arg"), i(0, "// code") })),

    s("ctor", fmt([[
{}::{}({}) {{
    {}
}}
]], { i(1, "ClassName"), rep(1), i(2, "args"), i(0, "// ctor body") })),

    s("dtor", fmt([[
{}::~{}() {{
    {}
}}
]], { i(1, "ClassName"), rep(1), i(0, "// dtor body") })),

    s("for", fmt([[
for (int {} = 0; {} < {}; ++{}) {{
    {}
}}
]], { i(1, "i"), rep(1), i(2, "n"), rep(1), i(0, "// code") })),

    s("if", fmt([[
if ({}) {{
    {}
}}
]], { i(1, "condition"), i(0, "// code") })),

    s("cout", fmt([[std::cout << {} << std::endl;]], { i(0, '"text"') })),
    s("cin", fmt([[std::cin >> {};]], { i(0, "var") })),
    s("while", fmt([[
while ({}) {{
    {}
}}
]], { i(1, "condition"), i(0, "// code") })),
    s("ife", fmt([[
if ({}) {{
    {}
}} else {{
    {}
}}
]], { i(1, "condition"), i(2, "// code"), i(0, "// else") })),
    s("nl", t("\\n")),
}
