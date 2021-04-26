-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Vimg = Vim.g
Vimo = Vim.o
Vimw = Vim.wo
Vimf = Vim.fn

local vim_use_coc_env = os.getenv("VIM_USE_COC")
NO_USE_COC_LSP = vim_use_coc_env == nil or vim_use_coc_env == ""

local install_path = Vimf.stdpath("data") ..
                         "/site/pack/packer/start/packer.nvim"

if Vimf.empty(Vimf.glob(install_path)) > 0 then
    Cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    Cmd "packadd packer.nvim"
end

return require("packer").startup(function()
    use "wbthomason/packer.nvim"

    -- battery included libraries relied upon by several plugins
    use {"nvim-lua/plenary.nvim"}

    if NO_USE_COC_LSP then
        -- LSP, Autocomplete and snippets
        use {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-compe",
            "hrsh7th/vim-vsnip",
            "mattn/emmet-vim",
        }
    end

    use {
        {"junegunn/fzf", dir = "~/.fzf", run = "./install --all"},
        "junegunn/fzf.vim",
        "stsewd/fzf-checkout.vim",
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
    use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install"}
    use "junegunn/goyo.vim"

    -- Statusline
    use "itchyny/lightline.vim"

    -- Terminal
    use {"voldikss/vim-floaterm"}

    -- General plugins
    use {
        "mbbill/undotree",
        "terrortylor/nvim-comment",
        "windwp/nvim-autopairs",
        "norcalli/nvim-colorizer.lua",
        "nelstrom/vim-visual-star-search",
        -- Surround text with quotes, parenthesis, brackets, and more.
        "tpope/vim-surround",
        -- Quickly toggle maximaize a tab
        "szw/vim-maximizer",
        -- A number of useful motions for the quickfix list, pasting and more.
        "tpope/vim-unimpaired",
        -- displaying the colours in the file (#rrggbb, #rgb, rgb(a)
        -- requires golang (asdf plugin-add golang && asdf install golang <version>)
        {"rrethy/vim-hexokinase", run = "make hexokinase"},
        -- color picker
        "KabbAmine/vCoolor.vim",
    }

    -- Themes
    use {"rakr/vim-one", "lifepillar/vim-gruvbox8", "lifepillar/vim-solarized8"}

    -- MANAGE VIM SESSIONS AUTOMACTICALLY
    use {"tpope/vim-obsession", "dhruvasagar/vim-prosession"}

    -- FORMATTER
    use {"sbdchd/neoformat"}
end)
