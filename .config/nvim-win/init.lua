vim = vim or {}

local plugins_path

if vim.fn.has('win32') == 1 then
  vim.cmd('language en_US')
  vim.cmd('set fileformat=unix')
  vim.g.plugins_path = '~\\AppData\\Local\\nvim\\autoload'
else
  vim.cmd([[
    set runtimepath-=~/.config/nvim
    set runtimepath-=~/.config/nvim/after
    set runtimepath-=~/.local/share/nvim/site
    set runtimepath-=~/.local/share/nvim/site/after
    set runtimepath+=~/.config/nvim-win/after
    set runtimepath^=~/.config/nvim-win
    set runtimepath+=~/.local/share/nvim-win/site/after
    set runtimepath^=~/.local/share/nvim-win/site
  ]])

  vim.opt.packpath = vim.opt.runtimepath:get()

  vim.fn.setenv('MYVIMRC', vim.fn.expand('$HOME/.config/nvim-win/init.lua'))

  plugins_path = vim.fn.expand('$HOME/.local/share/nvim-win/site/autoload')
  local plug_install_path = plugins_path .. '/plug.vim'

  plugins_path = plugins_path .. '/plug'

  if vim.fn.filereadable(plug_install_path) == 0 then
    vim.fn.system(
      'curl -fLo ' ..
      plug_install_path .. ' --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    )

    vim.cmd('autocmd VimEnter * PlugInstall | source ' .. vim.fn.expand('$MYVIMRC'))
  end
end

local Plug = vim.fn['plug#']
vim.fn["plug#begin"](plugins_path)
Plug('tpope/vim-surround')
Plug('nelstrom/vim-visual-star-search')
vim.fn["plug#end"]()

vim.cmd([[
  augroup MyMiscGroup
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]])

vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', {})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true  -- converts tabs to white space
vim.o.shiftwidth = 2    -- default indent = 2 spaces
vim.o.encoding = 'utf8'
vim.o.cc = 80           -- column width
vim.o.incsearch = true  -- Incremental search, search as you type
vim.o.ignorecase = true -- Make searching case insensitive
vim.o.smartcase = true  -- ... unless the query has capital letters
vim.o.gdefault = true   -- Use 'g' flag by default with :s/foo/bar/.
vim.o.hlsearch = true
-- vim.o.nohlsearch = true
-- :%s/term/sub will be highlighted as sub is typed
vim.o.inccommand = 'nosplit'
-- vim.o.inccommand = 'split'

-- Tab Splits
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mouse = 'a'

vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
-- don't fold by default when opening a file.
vim.o.foldenable = false
vim.o.foldlevel = 2

-- reload a file if it is changed from outside vim
vim.o.autoread = true
vim.o.swapfile = false

-- persist undo history even when I quit vim
vim.o.undofile = true
vim.fn.mkdir(vim.fn.expand('$HOME/.vim/undodir'), 'p')
vim.o.undodir = vim.fn.expand('$HOME/.vim/undodir/')

-- Paste text unmodified from other applications.
-- https://vim.fandom.com/wiki/Toggle_auto-indenting_for_code_paste
vim.o.paste = true
vim.o.nopaste = false

vim.api.nvim_set_keymap(
  'n', '<leader>fc', '<Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>',
  { noremap = true, silent = true }
)

-- format paragraphs/lines to 80 chars
vim.api.nvim_set_keymap(
  'n', '<Leader>pp', 'gqap', { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'x', '<Leader>pp', 'gqa', { noremap = true, silent = true }
)

-- ------------------------ Save file
vim.api.nvim_set_keymap(
  'n', '<Leader>ww', ':Write<CR>', { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n', '<Leader>wa', ':Wall<CR>', { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n', '<Leader>wq', ':Wq<CR>', { noremap = true, silent = true }
)
-- ---------------------- END Save file

-- ---------------------- Quit vim
vim.api.nvim_set_keymap(
  'n', '<leader>qq', '<Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n', '<leader>qA', '<Cmd>call VSCodeNotify("workbench.action.closeWindow")<CR>',
  { noremap = true, silent = true }
)
-- ---------------------- END Quit vim

-- ---------------------- better code indentations in visual mode.
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true, silent = true })
-- ---------------------- END better code indentations in visual mode.

-- ---------------------- Yank to system clipboard
vim.api.nvim_set_keymap('n', '"+yy', '0"+yg_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>Y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>x', '"+x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>x', '"+x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>P', '"+P', { noremap = true, silent = true })
-- ---------------------- END Yank to system clipboard

-- ---------------------- Yank all
vim.api.nvim_set_keymap('n', '<Leader>y+', ':%y<bar>:let @+=@"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>YY', ':%y<bar>:let @+=@"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ya', ':%y<bar>:let @a=@"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',yy', 'vgny<bar>:let @+=@"<CR> <bar>"', { noremap = true, silent = true }) -- Yank highlighted
vim.api.nvim_set_keymap('n', ',cc', 'vgny<bar>:let @a=@"<CR> <bar>"', { noremap = true, silent = true }) -- Yank highlighted
-- ---------------------- END Yank all

-- Copy file path
vim.api.nvim_set_keymap('n', ',yr', '<Cmd>call VSCodeNotify("copyRelativeFilePath")<CR>',
  { noremap = true, silent = true })                                                                                 -- Yank relative file path
vim.api.nvim_set_keymap('n', ',yf', '<Cmd>call VSCodeNotify("copyFilePath")<CR>', { noremap = true, silent = true }) -- Yank absolute file path

-- ---------------------- Dump vim register into a buffer in vertical split.
vim.api.nvim_set_keymap('n', '<leader>re', ':reg<CR>', { noremap = true, silent = true })
