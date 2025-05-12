local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")

local theme_fn_map = {
  -- BACKGROUNDS
  d = function()
    vim.o.background = "dark"
  end,
  l = function()
    vim.o.background = "light"
  end,

  -- THEMES

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
  tokyonight = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}

if not plugin_enabled.has_termux() then
  -- THEMES not used in termux
  theme_fn_map = vim.tbl_extend("error", theme_fn_map, {
    one = function()
      vim.cmd.colorscheme("one")
      -- use italic for comments
      vim.g.one_allow_italics = 1
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
  })
end

local env_vim_theme = utils.get_os_env_or_nil("EBNIS_VIM_UBER_THEME")
  or utils.get_os_env_or_nil("EBNIS_VIM_THEME")

local env_vim_bg = utils.get_os_env_or_nil("EBNIS_VIM_THEME_BG")

if env_vim_theme ~= nil then
  if theme_fn_map[env_vim_theme] ~= nil then
    theme_fn_map[env_vim_theme]()
  else
    vim.cmd.colorscheme(env_vim_theme)
  end
else
  theme_fn_map.gruvbox8_hard()
end

if env_vim_bg ~= nil and theme_fn_map[env_vim_bg] ~= nil then
  theme_fn_map[env_vim_bg]()
else
  theme_fn_map.d()
end
