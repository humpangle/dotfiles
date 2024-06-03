local theme_fn_map = {
  -- BACKGROUNDS
  d = function()
    vim.o.background = "dark"
  end,
  l = function()
    vim.o.background = "light"
  end,

  -- THEMES
  one = function()
    vim.cmd.colorscheme("one")
    -- use italic for comments
    vim.g.one_allow_italics = 1
  end,

  ---- gruvbox8
  gruvbox8 = function()
    vim.g.one_allow_italics = 1
    vim.cmd.colorscheme("gruvbox8")
  end,
  gruvbox8_hard = function()
    vim.g.one_allow_italics = 1
    vim.cmd.colorscheme("gruvbox8_hard")
  end,
  gruvbox8_soft = function()
    vim.g.one_allow_italics = 1
    vim.cmd.colorscheme("gruvbox8_soft")
  end,
}

local env_vim_theme = os.getenv("EBNIS_VIM_THEME")
local env_vim_bg = os.getenv("EBNIS_VIM_THEME_BG")

if env_vim_theme ~= nil and theme_fn_map[env_vim_theme] ~= nil then
  theme_fn_map[env_vim_theme]()
else
  theme_fn_map.gruvbox8_hard()
end

if env_vim_bg ~= nil and theme_fn_map[env_vim_bg] ~= nil then
  theme_fn_map[env_vim_bg]()
else
  theme_fn_map.d()
end
