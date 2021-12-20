local install_path = vim.fn.stdpath("data") ..
                         "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.cmd("packadd packer.nvim")
end

return require("packer").startup(function()
    use "wbthomason/packer.nvim"

    -- battery included libraries relied upon by several plugins
    use {"nvim-lua/plenary.nvim"}

        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-compe",
            "hrsh7th/vim-vsnip",
            "mattn/emmet-vim",
            -- conveniently install language servers.
            -- Adds `:LspInstall <language>` command
            "kabouzeid/nvim-lspinstall",
        }

    use {
        {"junegunn/fzf", dir = "~/.fzf", run = "./install --all"},
        "junegunn/fzf.vim",
        "stsewd/fzf-checkout.vim",
        "chengzeyi/fzf-preview.vim",
        "voldikss/fzf-floaterm",
        -- sudo apt install bat # Syntax highlighting
        "gfanto/fzf-lsp.nvim",
    }

    -- Treesitter
    use {
        {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
        -- Use treesitter to autoclose and autorename html tag in html,tsx,vue,svelte
        "windwp/nvim-ts-autotag",
    }

    -- Git
    use {"tpope/vim-fugitive", "lewis6991/gitsigns.nvim"}

    -- Markdown
    use {
        {"iamcco/markdown-preview.nvim", run = "cd app && yarn install"},
        -- Align Markdown table
        "godlygeek/tabular",
        "junegunn/goyo.vim",
    }
    -- Statusline
    use "itchyny/lightline.vim"

    -- Terminal
    use {"voldikss/vim-floaterm"}

    -- MANAGE VIM SESSIONS AUTOMACTICALLY
    use {"tpope/vim-obsession", "dhruvasagar/vim-prosession"}

    -- General plugins
    use {
        "simnalamburt/vim-mundo",
        "tomtom/tcomment_vim",
        "tpope/vim-unimpaired",
        -- displaying the colours in the file (#rrggbb, #rgb, rgb(a)
        -- requires golang (asdf plugin-add golang && asdf install golang <version>)
        {"rrethy/vim-hexokinase", run = "make hexokinase"},
        -- color picker
        "KabbAmine/vCoolor.vim",
        "nelstrom/vim-visual-star-search",
        "easymotion/vim-easymotion",
        "szw/vim-maximizer",
        "windwp/nvim-autopairs",
        -- Surround text with quotes, parenthesis, brackets, and more.
        "tpope/vim-surround",
        -- Quickly toggle maximaize a tab
        -- A number of useful motions for the quickfix list, pasting and more.
        -- SYNTAX HIGHLIGHTING
        "elixir-editors/vim-elixir",
        "jparise/vim-graphql",
        "pprovost/vim-ps1",
        "jwalton512/vim-blade",
        "editorconfig/editorconfig-vim",
        "posva/vim-vue",
        "othree/html5.vim",
        "pprovost/vim-ps1",

    -- Themes
        "rakr/vim-one",
        "lifepillar/vim-gruvbox8",
        "lifepillar/vim-solarized8",

    -- FORMATTER
      "sbdchd/neoformat",
      "aeke/vim-phpfmt",

      "dart-lang/dart-vim-plugin",

      "diepm/vim-rest-console",

      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",

      "puremourning/vimspector",

      "mi60dev/image.vim",
    }
end)
