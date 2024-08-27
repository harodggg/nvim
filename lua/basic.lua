vim.g.mapleader = ' '

--- 快捷键 ---
vim.api.nvim_set_keymap('i', 'jj','<ESC>', {noremap = true})
vim.api.nvim_set_keymap('n', 'zz',':wq<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'zq',':wqa<CR>', {noremap = true})

