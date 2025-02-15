vim.g.mapleader = " "

local keymap = vim.keymap
keymap.set("i", "ds", "<Esc>")
keymap.set("v", "ds", "<Esc>")
keymap.set("n", "<leader>b", ":buffers<cr>:b<leader>")
keymap.set("n", "<leader>e", ":w !sudo tee % > /dev/null")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("n", "H", "^")
keymap.set("v", "H", "^")
keymap.set("n", "L", "$")
keymap.set("v", "L", "$")
keymap.set("n", " q", ":q<CR>")
keymap.set("n", " w", ":w<CR>")
keymap.set("n", "<leader>x", ":q!<CR>")
keymap.set("n", "<leader>t", ":Ntree<CR>")
keymap.set("n", "<leader>ra", ":RnvimrToggle<CR>")
-- 在 Neovim Lua 配置文件中的示例
vim.api.nvim_set_var('rnvimrtoggle_picker', 1)
