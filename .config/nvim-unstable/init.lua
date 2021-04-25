-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Vimg = Vim.g
Vimo = Vim.o
Vimw = Vim.wo
Vimf = Vim.fn

require("main/settings")
require("main/mappings")
require("plugins")
require("theme")
require("lsp")

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
require("plugins/neoformat")
