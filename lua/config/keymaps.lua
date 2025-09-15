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

-- use for bufferline
vim.api.nvim_set_keymap('n', '<leader>l', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- use for neo-tree
keymap.set("n", "tr", ":Neotree<CR>")
keymap.set("n", "<leader>c", ":bd<CR>")
