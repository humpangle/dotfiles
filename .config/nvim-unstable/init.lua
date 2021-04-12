-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Lsp_config = require("lspconfig")

Theming = {
    -- Press <space>fc to see all available themes
    colorscheme = "onebuddy",
    --[[ Some colorscheme have multiple styles to choose from.
      here are the available options:
      For @gruvbox = medium, soft, hard
      For @edge = default, aura, neon
      For @sonokai = default, atlantis, andromeda, shusia, maia ]]
    colorscheme_style = "",
    -- Choose a stulusline:
    -- Options: galaxy, airline, eviline, gruvbox, minimal
    statusline = "eviline",
}

Completion = {
    -- values: true, false
    -- Enable or disable completion globally
    enabled = true,
    -- Choose sources of completion
    snippets = true,
    lsp = true,
    buffer = true,
    path = true,
    calc = true,
    spell = true,
}

LSP = {
    -- values: true, false
    -- Enable or disable LSP globally
    enabled = true,
    -- Choose which servers to start automatically
    bash = true,
    css = true,
    emmet = true,
    json = true,
    lua = true,
    python = true,
    tsserver = true,
}

-- General settings
require("utils/handlers")
require("main/options")
require("main/mappings")
require("main/autocmds")
require("plugins")
require("main/colorscheme")

-- LSP
require("lsp")

-- Plugins settings
require("plugins/gitsigns-nvim")
require("plugins/emmet-vim")
require("plugins/nvim-colorizer")
require("plugins/kommentary")
require("plugins/nvim-autopairs")
require("plugins/nvim-tree")
require("plugins/nvim-compe")
require("plugins/statusline")
require("plugins/terminal")
require("plugins/telescope")
require("plugins/treesitter")
