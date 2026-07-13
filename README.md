# Neovim 配置说明

这套配置使用 **lazy.nvim** 管理插件，并以 Neovim 原生 LSP、nvim-cmp、LuaSnip 和
Conform 取代原来的 Coc 配置。主要面向 C/C++，同时支持 Python、Web、Lua、LaTeX 和
Markdown。

## 启动流程

```text
init.lua
└── lua/config/lazy.lua
    ├── 设置 leader、Mason PATH
    ├── 加载 config/keymaps.lua
    ├── 加载 config/options.lua
    └── lazy.nvim 导入 lua/plugins/*.lua
        └── 各插件按需加载 lua/config/*.lua
```

`lua/plugins/` 中的文件描述“安装什么插件、何时加载”；`lua/config/` 中的文件描述
“插件具体怎样工作”。扩展一个已有插件时，通常修改后者；增加或删除插件时修改前者。

## 根目录文件

| 文件 | 作用 |
| --- | --- |
| `init.lua` | Neovim 的唯一入口。它只调用 `require("config.lazy")`，把启动工作交给 `lua/config/lazy.lua`。 |
| `lazy-lock.json` | lazy.nvim 自动维护的插件版本锁文件。记录每个插件当前使用的分支和提交，保证不同机器安装到相同版本；一般不要手动编辑。 |
| `README.md` | 本文档，说明配置结构、文件职责和主要依赖。 |
| `codex.txt` | 用户保留的 Codex 会话恢复命令，不参与 Neovim 配置加载。 |
| `nvim.log` | Neovim 运行时留下的日志，目前记录了一次本地 server socket 启动失败；不参与配置加载。 |
| `backups/nvim-config-20260713-162842.tar.gz` | Coc 重构前的完整配置备份，可用于查阅或恢复旧配置。 |

## `lua/config/`：具体配置

### 核心配置

| 文件 | 作用 |
| --- | --- |
| `lua/config/lazy.lua` | 自动安装并启动 lazy.nvim；设置 `<Space>` 为 leader、`\\` 为 localleader；把 Mason 的 `bin` 目录提前加入 `PATH`；加载全局按键和选项；导入整个 `lua/plugins/` 目录。 |
| `lua/config/options.lua` | Neovim 全局编辑选项，包括行号、4 空格缩进、禁用自动换行、光标行、系统剪贴板、分屏方向、智能大小写、真彩色、sign column 和光标上下/左右留白。 |
| `lua/config/keymaps.lua` | 不依赖 LSP 的全局快捷键，包括退出插入模式、保存/退出、移动选区、行首行尾、Bufferline 切换和 Neo-tree 开关。LSP 专属快捷键位于 `lua/config/lsp.lua`。 |

### 编程能力

| 文件 | 作用 |
| --- | --- |
| `lua/config/lsp.lua` | 配置并启用 Neovim 原生 LSP。服务器包括 clangd、basedpyright、ruff、lua_ls、vtsls、html、cssls、jsonls、eslint、tailwindcss 和 texlab；同时配置诊断图标、悬浮信息、代码跳转、重命名、Code Action、引用高亮和 CodeLens。 |
| `lua/config/cmp.lua` | 配置 nvim-cmp、LuaSnip 和 nvim-autopairs。补全来源依次包含 LSP、snippet、路径和当前 buffer，也为搜索命令及 `:` 命令行启用补全。这里定义 `<C-Space>`、`<CR>`、`<Tab>`、`<S-Tab>`、`<C-j>` 等补全/片段按键。 |
| `lua/config/luasnip.lua` | 当前是空文件，也没有被其他配置加载。保留它不会产生作用；实际 LuaSnip 配置在 `lua/config/cmp.lua` 中。 |

### 界面和工具

| 文件 | 作用 |
| --- | --- |
| `lua/config/bufferline.lua` | 配置顶部 buffer 标签栏：编号、图标、诊断数量、关闭按钮、Neo-tree 偏移区、分隔样式、鼠标操作和排序方式。 |
| `lua/config/neo-tree.lua` | Neo-tree 的详细配置。控制文件树、buffer 列表和 Git 状态视图，包括图标、过滤规则、排序、窗口位置、文件操作按键和 Git 操作按键；打开文件后自动关闭文件树。 |
| `lua/config/lualine.lua` | 配置底部状态栏，显示模式、Git 分支和 diff、诊断、文件名、编码、换行格式、文件类型、进度和光标位置。 |
| `lua/config/devicons.lua` | 配置 nvim-web-devicons，启用彩色默认图标，并覆盖 Zsh 与 `.gitignore` 的图标和颜色。 |
| `lua/config/vimtable.lua` | 配置 Markdown 表格模式，包括单元格边距、对齐方式、自动插入表头分隔行，以及表格格式化按键。 |

## `lua/plugins/`：插件声明

lazy.nvim 会自动导入本目录中所有扩展名为 `.lua` 的文件。`.bak` 文件不会被加载。

| 文件 | 插件与职责 |
| --- | --- |
| `lua/plugins/lsp.lua` | 声明 `nvim-lspconfig`、Mason、mason-lspconfig、mason-tool-installer 和 `cmp-nvim-lsp`。负责安装 LSP/格式化工具，并加载 `config.lsp`。`tree-sitter-cli` 固定为 v0.25.10，以兼容当前 nvim-treesitter 的 parser 生成流程。 |
| `lua/plugins/cmp.lua` | 声明 nvim-cmp 及 LSP、buffer、路径、命令行补全源，同时安装 LuaSnip、`cmp_luasnip` 和 nvim-autopairs，进入插入模式时加载 `config.cmp`。 |
| `lua/plugins/formatting.lua` | 使用 Conform 统一格式化。C/C++ 使用 clang-format，Python 使用 Ruff，Lua 使用 StyLua，Web/JSON/Markdown 优先使用 prettierd、回退到 prettier；保存时自动格式化，`<leader>f` 可手动格式化。 |
| `lua/plugins/treesitter.lua` | 安装并配置 Treesitter parser、语法高亮、缩进、增量选择和折叠。支持常见编程语言、Markdown；系统存在兼容的 `tree-sitter` CLI 时也安装 LaTeX parser。 |
| `lua/plugins/render.lua` | 配置 `render-markdown.nvim`，在 Neovim 中渲染 Markdown 标题、列表、表格和 LaTeX 公式。公式转换优先使用 `utftex`，失败时回退到 `latex2text`。 |
| `lua/plugins/vimtex.lua` | 配置 VimTeX。检测到 `latexmk` 时启用编译，检测到 Zathura 时用它预览 PDF；缺少对应程序时安全地关闭该项功能。 |
| `lua/plugins/colorscheme.lua` | 启动时加载 Tokyo Night Night 配色；同一文件也声明 Lualine 并加载 `config.lualine`。 |
| `lua/plugins/bufferline.lua` | 声明 Bufferline 和图标依赖，并加载 `config.bufferline`。 |
| `lua/plugins/neo-tree.lua` | 声明 Neo-tree v3、Plenary、NUI 和图标依赖，并加载 `config.neo-tree`。 |
| `lua/plugins/web-devicons.lua` | 声明 nvim-web-devicons，并加载 `config.devicons`。它为状态栏、Bufferline、Neo-tree 等插件提供文件类型图标。 |
| `lua/plugins/telescope.lua` | 声明 Telescope 0.1.8 与 Plenary，用于查找文件、历史文件等；当前文件未额外定义快捷键。 |
| `lua/plugins/dashbaord.lua` | 配置 alpha-nvim 启动页，包含 ASCII 图案以及新建、查找、最近文件、退出按钮。文件名中的 `dashbaord` 是历史拼写，但因为扩展名是 `.lua`，仍会正常加载。 |
| `lua/plugins/nvim_table_mode.lua` | 声明 Markdown Table Mode 并加载 `config.vimtable`。 |
| `lua/plugins/rainbow.lua` | 配置 rainbow-delimiters，通过 Treesitter 用不同颜色显示嵌套括号。 |
| `lua/plugins/intent_line.lua` | 配置 indent-blankline（`ibl`），显示代码缩进引导线。文件名中的 `intent` 是历史拼写，不影响加载。 |
| `lua/plugins/surround.lua` | 配置 nvim-surround，提供增加、修改和删除包围符号的操作。 |

### 不会加载的历史文件

| 文件 | 状态与内容 |
| --- | --- |
| `lua/plugins/dashbaordd.bak` | 另一版 alpha-nvim 启动页配置备份。因扩展名为 `.bak`，lazy.nvim 不会导入。 |
| `lua/plugins/devcontainer.bak` | `nvim-dev-container` 的旧插件声明，当前未启用。 |
| `lua/plugins/markdown.bak` | `markdown-preview.nvim` 的旧声明，当前由 `render-markdown.nvim` 承担终端内 Markdown 渲染。 |

## `lua/snippets/`：当前代码片段

这些文件由 `lua/config/cmp.lua` 通过 LuaSnip 的 Lua loader 自动加载。

| 文件 | 作用 |
| --- | --- |
| `lua/snippets/cpp.lua` | C/C++ 代码片段，包含 `main`、include 模板、class、函数、构造/析构、for/while、if/else、cout/cin 等常用结构。 |
| `lua/snippets/markdown.lua` | Markdown 代码片段；当前提供 `b` 触发的粗体模板。 |

## `lua/snipppets/`：旧示例目录

| 文件 | 状态与内容 |
| --- | --- |
| `lua/snipppets/snippets.txt` | 一份较长的 LuaSnip API/动态 snippet 示例。目录名是 `snipppets`（多了一个 `p`），扩展名也是 `.txt`，当前 loader 不会加载它。 |

## 常用修改入口

| 想修改的功能 | 文件 |
| --- | --- |
| 增删 LSP、调整 clangd/Python 设置 | `lua/config/lsp.lua`、`lua/plugins/lsp.lua` |
| 修改补全来源或 Tab/Enter 行为 | `lua/config/cmp.lua` |
| 增加 C/C++ 或 Markdown snippet | `lua/snippets/cpp.lua`、`lua/snippets/markdown.lua` |
| 修改保存时格式化工具 | `lua/plugins/formatting.lua` |
| 增删 Treesitter 语言 | `lua/plugins/treesitter.lua` |
| 修改 Markdown/公式渲染 | `lua/plugins/render.lua` |
| 修改 LaTeX 编译器或 PDF 阅读器 | `lua/plugins/vimtex.lua` |
| 修改全局快捷键 | `lua/config/keymaps.lua` |
| 修改 LSP 快捷键 | `lua/config/lsp.lua` 中的 `LspAttach` 回调 |
| 修改配色和状态栏 | `lua/plugins/colorscheme.lua`、`lua/config/lualine.lua` |
| 修改文件树 | `lua/config/neo-tree.lua` |

## 外部程序

插件本身由 lazy.nvim 管理；语言服务器和部分命令行工具由 Mason 管理。以下程序来自系统或
用户本地环境：

| 程序 | 用途 |
| --- | --- |
| `clangd` | C/C++ LSP。 |
| `latexmk`、TeX Live | VimTeX 的 LaTeX 编译链。 |
| `zathura`、`zathura-pdf-mupdf` | PDF 预览及 PDF 后端。 |
| `utftex` | 将 LaTeX 公式转换成适合终端显示的 Unicode 排版。安装在 `~/.local/bin`。 |
| `latex2text` | Markdown 公式转换的备用程序，由 pylatexenc 提供。 |

## 维护建议

- 使用 `:Lazy` 查看、安装和更新插件。
- 使用 `:Mason` 查看语言服务器与格式化工具。
- 使用 `:ConformInfo` 检查当前 buffer 选择了哪个格式化器。
- 使用 `:LspInfo` 或 `:checkhealth vim.lsp` 检查当前 LSP。
- 使用 `:checkhealth` 做整体健康检查。
- 修改 `lua/plugins/*.lua` 后重启 Neovim，再由 lazy.nvim 更新 `lazy-lock.json`。
- `.bak`、空文件及旧 `snipppets` 目录当前都不是运行时依赖；确认不再需要后可以单独清理。
