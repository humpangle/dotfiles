local install_path = Vimf.stdpath("data") ..
                         "/site/pack/packer/start/packer.nvim"

if Vimf.empty(Vimf.glob(install_path)) > 0 then
    Cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    Cmd "packadd packer.nvim"
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
    }

    -- Treesitter
    use {
        {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
        -- Use treesitter to autoclose and autorename html tag in html,tsx,vue,svelte
        "windwp/nvim-ts-autotag",
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
end)
