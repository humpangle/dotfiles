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
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-media-files.nvim",
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
    use "glepnir/galaxyline.nvim"

    -- Terminal
    use {"voldikss/vim-floaterm"}

    -- General plugins
    use {
        "mbbill/undotree",
        "terrortylor/nvim-comment",
        "windwp/nvim-autopairs",
        "norcalli/nvim-colorizer.lua",
        "nelstrom/vim-visual-star-search",
    }

    -- Themes
    use {"rakr/vim-one", "lifepillar/vim-gruvbox8", "lifepillar/vim-solarized8"}

    -- MANAGE VIM SESSIONS AUTOMACTICALLY
    use {"tpope/vim-obsession", "dhruvasagar/vim-prosession"}

    -- PLUGIN SETTINGS
    require("plugins/gitsigns-nvim")
    require("plugins/emmet-vim")
    require("plugins/nvim-comment")
    require("plugins/nvim-autopairs")
    require("plugins/nvim-compe")
    require("plugins/telescope")
    require("plugins/treesitter")
    require("plugins/undotree")
    require("plugins/vim-floaterm")

end)
