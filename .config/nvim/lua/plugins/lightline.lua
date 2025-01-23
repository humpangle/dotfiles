local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  "itchyny/lightline.vim",

  init = function()
    require("plugins.lightline-utils")

    vim.g.lightline = {
      colorscheme = "wombat",

      -- shorter mode names
      mode_map = {
        n = "N", -- normal
        i = "I", -- insert
        R = "R", -- replace
        v = "V", -- visual
        V = "VL", -- visual line
        ["<C-v>"] = "VB", -- v-block
        c = "C", -- command
        s = "S", -- select
        S = "SL", -- s-line
        ["<C-s>"] = "SB", -- s-block
        t = "T", -- terminal
      },

      component_function = {
        FilenameLeft = "v:lua.FilenameLeft",
        FilenameRight = "v:lua.FilenameRight",
      },

      component_expand = {
        LightlineObsession = "v:lua.LightlineObsession",
      },

      tab_component_function = {
        FilenameTab = "FilenameTab", -- v:lua.* does not work in tab_component_function
      },

      active = {
        left = {
          { "mode", "paste" },
          {
            "readonly",
            "FilenameLeft",
          },
        },

        right = {
          { "lineinfo" },
          { "percent" },
          { "fileformat", "filetype" },
        },
      },

      inactive = {
        left = { { "FilenameRight" } },

        right = {
          { "lineinfo" },
          { "percent" },
        },
      },

      tab = {
        active = {
          "tabnum",
          "FilenameTab",
        },

        inactive = {
          "tabnum",
          "FilenameTab",
        },
      },

      tabline = {
        left = {
          { "tabs" },
        },
        right = {
          { "close" },
          { "LightlineObsession" },
        },
      },
    }
  end,
}
