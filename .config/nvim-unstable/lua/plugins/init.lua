---@diagnostic disable: undefined-global
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " ..
                install_path)
    execute "packadd packer.nvim"
end

return require("packer").startup(function()
    use "wbthomason/packer.nvim"

    -- LSP, Autocomplete and snippets
    use {
        "neovim/nvim-lspconfig",
        "hrsh7th/nvim-compe",
        "sbdchd/neoformat",
        "hrsh7th/vim-vsnip",
        "mattn/emmet-vim",
    }

    -- FUZZY FINDER
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/popup.nvim"},
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-media-files.nvim"},
        },
        "ludovicchabant/vim-gutentags",
    }

    -- Treesitter
    use {
        {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
        "windwp/nvim-ts-autotag",
        "p00f/nvim-ts-rainbow",
    }

    -- Git
    use "lewis6991/gitsigns.nvim"

    -- Markdown
    use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install"}
    use "junegunn/goyo.vim"

    -- Statusline
    -- for icons:
    -- requires = {'kyazdani42/nvim-web-devicons', opt = true}
    use "glepnir/galaxyline.nvim"

    -- Terminal
    use {"akinsho/nvim-toggleterm.lua", "voldikss/vim-floaterm"}

    -- General plugins
    use {
        "kyazdani42/nvim-web-devicons",
        "mbbill/undotree",
        "b3nj5m1n/kommentary",
        "windwp/nvim-autopairs",
        "norcalli/nvim-colorizer.lua",
    }

    -- Themes
    use {"rakr/vim-one", "lifepillar/vim-gruvbox8", "lifepillar/vim-solarized8"}

    -- MANAGE VIM SESSIONS AUTOMACTICALLY
    use {"tpope/vim-obsession", "dhruvasagar/vim-prosession"}
end)
