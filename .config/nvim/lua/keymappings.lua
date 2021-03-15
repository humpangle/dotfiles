vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })
vim.g.mapleader = ' '

vim.api.nvim_set_keymap('n', '<leader>ee', ':Vexplore<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>nh', ':noh<CR>', { noremap = true, silent = false })


-- Quit vim
vim.api.nvim_set_keymap('i', '<c-q>', '<esc>:q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-q>', ':q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<c-q>', '<esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qq', ':q<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qf', ':q!<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qa', ':qa<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qF', ':qa!<cr>', { noremap = true, silent = true })

-- Format paragraph (selected or not) to 80 character lines.
vim.api.nvim_set_keymap('n', '<Leader>g', 'gqap', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<Leader>g', 'gqa', { noremap = true, silent = true })

 -- Vim’s :help documentation
vim.api.nvim_set_keymap('n', '<Leader>H', ':Helptags!<cr>', { noremap = true, silent = true })

-- Save file
vim.api.nvim_set_keymap('n', '<Leader>ww', ':w<cr>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Leader>wa', ':wa<cr>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Leader>wq', ':wq<cr>', { noremap = true, silent = false })
-- Save non user file i.e. file that requires root permission by typing :w!!
-- NOTE: you may need to install a utility such as `askpass` in order to input
-- password. On ubuntu, run:
-- sudo apt install ssh-askpass-gnome ssh-askpass -y && \
--  echo "export SUDO_ASKPASS=$(which ssh-askpass)" >> ~/.bashrc
vim.api.nvim_set_keymap('c', 'w!!', 'w !sudo tee > /dev/null %', { noremap = false, silent = false })

-- better code indentations in visual mode.
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

-- yank / Copy and paste from system clipboard (Might require xclip install)
vim.api.nvim_set_keymap('v', '<Leader>Y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>x', '"+x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>P', '"+P', { noremap = true, silent = true })

-- go to buffer number - use like so gb34
vim.api.nvim_set_keymap('n', 'gb', ':ls<cr>:b', { noremap = true, silent = true })
-- Move between windows in a tab
vim.api.nvim_set_keymap('n', '<tab>', '<c-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', { noremap = true, silent = true })

-- TABS
-- Go to tab by number
vim.api.nvim_set_keymap('n', '<leader>1', '1gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', '2gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', '3gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', '4gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>5', '5gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>6', '6gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>7', '7gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>8', '8gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>9',  '9gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tn',  ':tabnew<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ts',  ':tab split<cr>', { noremap = true, silent = true })

-- window
-- split bottom
vim.api.nvim_set_keymap('n', '<leader>_',  ':split<cr>', { noremap = true, silent = true })
-- split right
vim.api.nvim_set_keymap('n', '<leader>|',  ':vsp<cr>', { noremap = true, silent = true })
-- remove all but current window
vim.api.nvim_set_keymap('n', '<leader>0',  ':only<cr>', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', ',md',  ':!mkdir -p %:h<cr>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', ',rm',  ':!trash-put %:p<cr>:bdelete!', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', ',.',  ':e ~/.bashrc<CR>', { noremap = true, silent = false })
