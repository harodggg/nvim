vim.g.mapleader = " "

-- 设置1tab = 4 space
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 自动缩进
vim.opt.autoindent = true


vim.cmd('resize -5')
--- 快捷键 ---
vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true })
vim.api.nvim_set_keymap("n", "zz", ":wq<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "zq", ":wqa<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>h", "<CR>wh", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>l", "<CR>wl", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>t", ":NvimTreeOpen<CR>", { noremap = true })

-- vim.o.syntax = 'enable'
vim.o.clipboard = "unnamedplus"
--- vim.o.termguicolors = false
--- vim.o.cursorline = false

--- vim.cmd[["syntax on"]]
--- vim.cmd[["colorscheme onedark"]]
