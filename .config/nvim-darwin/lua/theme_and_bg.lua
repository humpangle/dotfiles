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

  ---- solarized8
  solarized8 = function()
    vim.cmd.colorscheme("solarized8")
  end,
  solarized8_low = function()
    vim.cmd.colorscheme("solarized8_low")
  end,
  solarized8_flat = function()
    vim.cmd.colorscheme("solarized8_flat")
  end,
  solarized8_high = function()
    vim.cmd.colorscheme("solarized8_high")
  end,
}

local env_vim_theme = os.getenv("EBNIS_VIM_THEME")
local env_vim_bg = os.getenv("EBNIS_VIM_THEME_BG")

if env_vim_theme ~= nil and theme_fn_map[env_vim_theme] ~= nil then
  theme_fn_map[env_vim_theme]()
else
  theme_fn_map.solarized8_high()
end

if env_vim_bg ~= nil and theme_fn_map[env_vim_bg] ~= nil then
  theme_fn_map[env_vim_bg]()
else
  theme_fn_map.d()
end
