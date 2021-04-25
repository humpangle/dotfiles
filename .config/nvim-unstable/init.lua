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

require("plugins")
require("theme")

if NO_USE_COC_LSP then
    require("lsp")
    require("plugins/emmet-vim")
    require("plugins/nvim-comment")
    require("plugins/nvim-autopairs")
    require("plugins/nvim-compe")
    require("plugins/telescope")
    require("plugins/treesitter")
    require("plugins/undotree")
    require("plugins/vim-floaterm")
    require("nvim-ts-autotag").setup()
end

-- PLUGIN SETTINGS
require("plugins/neoformat")
require("plugins/gitsigns-nvim")
require("plugins/vim-fugitive")
require("plugins/lightline")
