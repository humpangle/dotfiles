-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Vimg = Vim.g
Vimo = Vim.o
_, Lsp_config = pcall(require, "lspconfig")

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
require("main/settings")
require("main/mappings")
require("main/autocmds")
require("plugins")

-- LSP
require("lsp")

-- Plugins settings
require("plugins/gitsigns-nvim")
require("plugins/emmet-vim")
require("plugins/kommentary")
require("plugins/nvim-autopairs")
require("plugins/nvim-compe")
require("plugins/terminal")
require("plugins/telescope")
require("plugins/treesitter")
require("plugins/undotree")
require("plugins/vim-floaterm")

-- THEME SELECTION
local theme_file = os.getenv("EBNIS_VIM_THEME")
local bg = os.getenv("EBNIS_VIM_THEME_BG")

if theme_file ~= nil and theme_file ~= "" then
    require("plugins/" .. theme_file)
    Vimo.background = bg == "d" and "dark" or "light"
else
    require("plugins/vim-solarized8")
    Vimo.background = "dark"
end
