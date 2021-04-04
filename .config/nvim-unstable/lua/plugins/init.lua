local execute = vim.api.nvim_command
local fn = vim.fn

-- load packer as optional plugin i.e. plugins will be loaded on demand
-- https://stackoverflow.com/questions/48700563/how-do-i-install-plugins-in-neovim-correctly
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- Modify * to also work with visual selections.
  use 'nelstrom/vim-visual-star-search'
  -- Toggle comments in various ways.
  use 'tpope/vim-commentary'
  -- A number of useful motions for the quickfix list, pasting and more.
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  -- Connect to database use vim
  use 'tpope/vim-dadbod'
  use 'ntpeters/vim-better-whitespace'
  -- Surround text with quotes, parenthesis, brackets, and more.
  use 'easymotion/vim-easymotion'
  use 'diepm/vim-rest-console'
  -- interactive scratchpad  = repl
  use 'metakirby5/codi.vim'
  -- Align Markdown table
  use 'godlygeek/tabular'
  use {'iamcco/markdown-preview.nvim',  run = 'cd app & yarn install'}
  -- let g:mkdp_refresh_slow = 1

  -- MANAGE VIM SESSIONS AUTOMACTICALLY
  use 'tpope/vim-obsession'
  use 'dhruvasagar/vim-prosession'

  -- GIT
  -- A git wrapper so awesome it should be illegal.
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'will133/vim-dirdiff'

  -- FUZZY FINDER
  use {'liuchengxu/vim-clap',  run = ':Clap install-binary!'}
  -- View and search LSP symbols, tags in Vim/NeoVim.
  use 'liuchengxu/vista.vim'

  -- THEMES
  use 'rakr/vim-one'
  use 'lifepillar/vim-gruvbox8'
  use 'lifepillar/vim-solarized8'

  -- SYNTAX HIGHLIGHTING
  -- We recommend updating the parsers on update
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- VIM STATUS BAR / TABS / WINDOWS
  -- cool status bar
  use 'itchyny/lightline.vim'
  -- Floaterm is a floating terminal for Neovim
  use 'voldikss/clap-floaterm' -- use clap to search floaterm
  use 'voldikss/vim-floaterm'

  -- SNIPPET ENGINES
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  -- COMPLETION
  use 'hrsh7th/nvim-compe'

  -- LANGUAGE SERVERS / SYNTAX CHECKING
  use 'neovim/nvim-lspconfig'

  -- for lua development in NEOVIM - the plugin is not useful outside neovim
  -- This plugin defines re usable functions like those found in
  -- python's batteries included
  use 'nvim-lua/plenary.nvim'

end)
