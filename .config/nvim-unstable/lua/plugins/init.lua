local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
  }

  -- GENERAL
  use {
    -- Modify * to also work with visual selections.
    'nelstrom/vim-visual-star-search',
    -- Toggle comments in various ways.
    'b3nj5m1n/kommentary',
    -- A number of useful motions for the quickfix list, pasting and more.
    'tpope/vim-unimpaired',
    'tpope/vim-surround',
    -- Connect to database use vim
    'tpope/vim-dadbod',
    'ntpeters/vim-better-whitespace',
    -- Surround text with quotes, parenthesis, brackets, and more.
    'easymotion/vim-easymotion',
    'diepm/vim-rest-console',
    -- interactive scratchpad  = repl
    'metakirby5/codi.vim',
    -- Align Markdown table
    'godlygeek/tabular',

    {
      'iamcco/markdown-preview.nvim',
      run = 'cd app & yarn install'
    },
    -- let g:mkdp_refresh_slow = 1

    -- MANAGE VIM SESSIONS AUTOMACTICALLY
    'tpope/vim-obsession',
    'dhruvasagar/vim-prosession',
  }

  -- GIT
  use {
    "lewis6991/gitsigns.nvim"
  }

  -- FUZZY FINDER
    -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      -- An implementation of the Popup API from vim in Neovim
      "nvim-lua/popup.nvim" ,
      -- for lua development in NEOVIM - the plugin is not useful outside neovim
      -- This plugin defines re usable functions like those found in
      -- python's batteries included. popup.nvim depends on it.
      "nvim-lua/plenary.nvim" ,
      "nvim-telescope/telescope-fzy-native.nvim" ,
      "nvim-telescope/telescope-media-files.nvim"
    }
  }

  -- View and search LSP symbols, tags in Vim/NeoVim.
  use 'liuchengxu/vista.vim'

  -- THEMES
  use {
    "sainnhe/sonokai",
    "wadackel/vim-dogrun",
    "christianchiarulli/nvcode-color-schemes.vim",
    "Th3Whit3Wolf/one-nvim",
    "Th3Whit3Wolf/space-nvim",
    "sainnhe/edge",
    {
      "npxbr/gruvbox.nvim",
      requires = "rktjmp/lush.nvim"
    }
  }

  -- SYNTAX HIGHLIGHTING
  use {
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    },
    "windwp/nvim-ts-autotag",
    "p00f/nvim-ts-rainbow"
  }

  -- VIM STATUS BAR / TABS / WINDOWS
  use {
    -- tabline plugin with re-orderable, auto-sizing, clickable tabs, etc
    "romgrk/barbar.nvim",
    -- statusline plugin. you can use the api provided by galaxyline to create
    -- the statusline that you want, easily
    "glepnir/galaxyline.nvim",
    -- Floaterm is a floating terminal for Neovim
    "voldikss/vim-floaterm"
  }

  -- SNIPPET ENGINES
  use {
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ'
  }

  -- LANGUAGE SERVERS / SYNTAX CHECKING
  use {
    'neovim/nvim-lspconfig',
    -- COMPLETION
    'hrsh7th/nvim-compe'
  }

  -- CODE FORMATTERS
  use {
    -- Neoformat uses a variety of formatters for many filetypes
    "sbdchd/neoformat",
  }

  -- File manager
  use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons"
      }
  }
end)
