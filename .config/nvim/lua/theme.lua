local theme_file = os.getenv("EBNIS_VIM_THEME")
local bg = os.getenv("EBNIS_VIM_THEME_BG")

if theme_file ~= nil and theme_file ~= "" then
    local new_bg = bg == "d" and "dark" or "light"
    Vimo.background = new_bg
    require("plugins/" .. theme_file)
else
    Vimo.background = "dark"
    require("plugins/vim-gruvbox8")
end
