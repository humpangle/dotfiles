local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  {
    "rakr/vim-one",
    enabled = plugin_enabled.enable_vim_one_color_scheme(),
    lazy = false,
    priority = 1000,
  },

  {
    "lifepillar/vim-gruvbox8",
    lazy = false,
    priority = 1000,
  },

  {
    "lifepillar/vim-solarized8",
    enabled = plugin_enabled.enable_solarized_color_scheme(),
    cond = true, -- conditionally load
    priority = 1000,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
}
