vim = vim or {}

local plugins_path
local vscode = require('vscode-neovim')
local vcall = vscode.call
local keyset = vim.keymap.set
local noReMapSilentOpts = { noremap = true, silent = true }
local noReMapOpts = { noremap = true }

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

  vim.fn.setenv(
    'MYVIMRC',
    vim.fn.expand('$HOME/.config/nvim-win/init.lua')
  )

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

keyset('n', '<Space>', '<Nop>', {})
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

keyset(
  'n', '<leader>fc', function()
    vcall("editor.action.formatDocument")
  end,
  noReMapSilentOpts
)

-- format paragraphs/lines to 80 chars
keyset(
  'n', '<Leader>pp', 'gqap', noReMapSilentOpts
)

keyset(
  'x', '<Leader>pp', 'gqa', noReMapSilentOpts
)

-- ------------------------ Save file
keyset(
  'n', '<Leader>ww', ':Write<CR>', noReMapSilentOpts
)

keyset(
  'n', '<Leader>wa', ':Wall<CR>', noReMapSilentOpts
)

keyset(
  'n', '<Leader>wq', ':Wq<CR>', noReMapSilentOpts
)
-- ---------------------- END Save file

-- ---------------------- Quit vim
keyset(
  'n',
  '<leader>qq',
  function()
    vcall("workbench.action.closeActiveEditor")
  end,
  noReMapSilentOpts
)

keyset(
  'n',
  '<leader>bd',
  function()
    vcall("workbench.action.closeActiveEditor")
  end,
  noReMapSilentOpts
)

keyset(
  'n',
  '<leader>qA',
  function()
    vcall("workbench.action.closeWindow")
  end,
  noReMapSilentOpts
)

keyset(
  'n',
  '<leader>qg',
  function()
    vcall("workbench.action.closeEditorsInGroup")
  end,
  noReMapSilentOpts
)

keyset(
  'n',
  '<leader>qG',
  function()
    vcall("workbench.action.closeEditorsInOtherGroups")
  end,
  noReMapSilentOpts
)
-- ---------------------- END Quit vim

-- ---------------------- better code indentations in visual mode.
keyset('x', '<', '<gv', noReMapSilentOpts)
keyset('x', '>', '>gv', noReMapSilentOpts)
-- ---------------------- END better code indentations in visual mode.

-- ---------------------- Yank to system clipboard
keyset('n', '"+yy', '0"+yg_', noReMapSilentOpts)
keyset('v', '<Leader>Y', '"+y', noReMapSilentOpts)
keyset('v', '<Leader>x', '"+x', noReMapSilentOpts)
keyset('n', '<Leader>x', '"+x', noReMapSilentOpts)
keyset('n', '<Leader>P', '"+P', noReMapSilentOpts)
keyset('v', '<Leader>P', '"+P', noReMapSilentOpts)
-- ---------------------- END Yank to system clipboard

-- ---------------------- Yank all
keyset('n', '<Leader>y+', ':%y<bar>:let @+=@"<CR>', noReMapSilentOpts)
keyset('n', '<Leader>YY', ':%y<bar>:let @+=@"<CR>', noReMapSilentOpts)
keyset('n', '<Leader>ya', ':%y<bar>:let @a=@"<CR>', noReMapSilentOpts)
-- Yank highlighted
keyset('n', ',yy', 'vgny<bar>:let @+=@"<CR> <bar>"', noReMapSilentOpts)
-- Yank highlighted
keyset('n', ',cc', 'vgny<bar>:let @a=@"<CR> <bar>"', noReMapSilentOpts)
-- ---------------------- END Yank all

-- ------------------------ Copy file path
-- Yank relative file path
keyset(
  'n', ',yr', function()
    vcall("copyRelativeFilePath")
  end,
  noReMapOpts
)

-- Yank absolute file path
keyset(
  'n', ',yf', function()
    vcall("copyFilePath")
  end,
  noReMapOpts
)

-- Yank absolute directory
keyset(
  'n', ',yd', function()
    local absolute_file_path = vcall("copyFilePath")
    return absolute_file_path
  end,
  noReMapOpts
)
-- ------------------------ END Copy file path

-- ---------------------- Dump vim register into a buffer in vertical split.
keyset(
  'n',
  '<leader>re',
  ':reg<CR>',
  noReMapSilentOpts
)

keyset(
  'n',
  ',o',
  function()
    vcall("editor.action.organizeImports")
  end,
  noReMapSilentOpts
)

-- Rename variable
keyset(
  'n',
  '<leader>rn',
  function()
    vcall("editor.action.rename")
  end,
  noReMapSilentOpts
)

-- ------------------------ Go to problem
keyset(
  'n',
  ']d',
  function()
    vcall("editor.action.marker.next")
  end,
  noReMapSilentOpts
)

keyset(
  'n',
  '[d',
  function()
    vcall("editor.action.marker.prev")
  end,
  noReMapSilentOpts
)
-- ------------------------ END Go to problem

keyset(
  'n',
  'gr',
  function()
    vcall("editor.action.referenceSearch.trigger")
  end,
  noReMapSilentOpts
)

keyset(
  'x',
  'gr',
  function()
    vcall("editor.action.referenceSearch.trigger")
  end,
  noReMapSilentOpts
)

-- ------------------------ Folds
keyset(
  'n',
  'zM',
  function()
    vcall("editor.foldAll")
  end,
  noReMapSilentOpts
)

keyset(
  'n',
  'zR',
  function()
    vcall("editor.unfoldAll")
  end,
  noReMapSilentOpts
)
-- ------------------------ END Folds

keyset(
  'n',
  ',ec',
  ":Edit " .. vim.fn.expand("$MYVIMRC") .. '<CR>',
  noReMapSilentOpts
)
