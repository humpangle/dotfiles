-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Vimg = Vim.g
Vimo = Vim.o
Vimf = Vim.fn

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

require("main/settings")
require("main/mappings")
require("main/autocmds")
require("plugins")
require("lsp")

-- THEME SELECTION
local theme_file = os.getenv("EBNIS_VIM_THEME")
local bg = os.getenv("EBNIS_VIM_THEME_BG")

if theme_file ~= nil and theme_file ~= "" then
    require("plugins/" .. theme_file)
    Vimo.background = bg == "d" and "dark" or "light"
else
    require("plugins/vim-gruvbox8")
    Vimo.background = "dark"
end
