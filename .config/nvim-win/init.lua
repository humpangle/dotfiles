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

  vim.g.MYVIMRC = "$HOME/.config/nvim-win/init.vim"

  vim.g.plugins_path = "$HOME/.local/share/nvim-win/site/autoload"
  vim.g.plug_install_path = vim.g.plugins_path .. '/plug.vim'
  vim.g.plugins_path = vim.g.plugins_path .. '/plug'

  if vim.fn.filereadable(vim.g.plug_install_path) == 0 then
    vim.cmd('silent !curl -fLo ' ..
    vim.g.plug_install_path .. ' --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    vim.cmd('autocmd VimEnter * PlugInstall | source $MYVIMRC')
  end
end

vim.cmd([[
  augroup MyMiscGroup
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]])

vim.cmd('call plug#begin(' .. vim.g.plugins_path .. ')')
vim.cmd('Plug \'tpope/vim-surround\'')
vim.cmd('Plug \'nelstrom/vim-visual-star-search\'')
vim.cmd('call plug#end()')

vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', {})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.cmd([[
  set tabstop=2
  set softtabstop=2
  set expandtab
  set shiftwidth=2
  set encoding=utf8
  set cc=80
  set incsearch
  set ignorecase
  set smartcase
  set gdefault
  set hlsearch
  set inccommand=nosplit
  set splitbelow
  set splitright
  set mouse=a
  set foldmethod=indent
  set foldnestmax=10
  set nofoldenable
  set foldlevel=2
  set autoread
  set noswapfile
  set undofile
  set undodir=$HOME/.vim/undodir/
  set paste
  set nopaste
]])

vim.api.nvim_set_keymap('n', '<leader>fc', '<Cmd>call VSCodeNotify(\'editor.action.formatDocument\')<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>pp', 'gqap', {})
vim.api.nvim_set_keymap('x', '<Leader>pp', 'gqa', {})
vim.api.nvim_set_keymap('n', '<Leader>ww', ':Write<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>wa', ':Wall<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>wq', ':Wq<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>qq', '<Cmd>call VSCodeNotify(\'workbench.action.closeActiveEditor\')<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>qA', '<Cmd>call VSCodeNotify(\'workbench.action.closeWindow\')<CR>', {})
vim.api.nvim_set_keymap('v', '<', '<gv', {})
vim.api.nvim_set_keymap('v', '>', '>gv', {})
vim.api.nvim_set_keymap('n', '"+yy', '0"+yg_', {})
vim.api.nvim_set_keymap('v', '<Leader>Y', '"+y', {})
vim.api.nvim_set_keymap('v', '<Leader>x', '"+x', {})
vim.api.nvim_set_keymap('n', '<Leader>x', '"+x', {})
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', {})
vim.api.nvim_set_keymap('v', '<Leader>P', '"+P', {})
vim.api.nvim_set_keymap('n', '<Leader>y+', ':%y<bar>:let @+=@"<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>YY', ':%y<bar>:let @+=@"<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>ya', ':%y<bar>:let @a=@"<CR>', {})
vim.api.nvim_set_keymap('n', ',yy', 'vgny<bar>:let @+=@"<CR> <bar>', {})
vim.api.nvim_set_keymap('n', ',cc', 'vgny<bar>:let @a=@"<CR> <bar>', {})
vim.api.nvim_set_keymap('n', ',yr', '<Cmd>call VSCodeNotify(\'copyRelativeFilePath\')<CR>', {})
vim.api.nvim_set_keymap('n', ',yf', '<Cmd>call VSCodeNotify(\'copyFilePath\')<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>re', ':reg<CR>', {})
