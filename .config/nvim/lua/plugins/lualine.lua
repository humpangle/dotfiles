local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  "nvim-lualine/lualine.nvim",

  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = false,

        component_separators = "",

        section_separators = "",
      },

      sections = {
        lualine_x = {
          require("plugins.yaml_lsp").get_yaml_schema,
          "fileformat",
          "filetype",
        },
      },

      inactive_sections = {
        lualine_c = {
          {
            "filename",

            -- Absolute path, with tilde as the home directory
            path = 3,

            -- Shortens path to leave 40 spaces in the window for other components.
            shorting_target = 10,

            symbols = {
              modified = "[+]",      -- Text to show when the file is modified.
              readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]",     -- Text to show for newly created file before first write
            },
          },
        },

        lualine_x = {
          -- line:column
          "location",
        },
      },

      tabline = {
        lualine_a = {
          {
            "tabs",

            -- Maximum width of tabline.
            max_length = vim.o.columns,

            -- Shows tab_nr + tab_name
            mode = 2,

            -- Automatically updates active tab color to match color of other components
            -- (will be overidden if buffers_color is set)
            use_mode_colors = false,

            tabs_color = {
              active = "lualine_tabline_normal",
              -- inactive = 'lualine_tabline_inactive',
            },

            show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
            symbols = {
              modified = "+",            -- Text to show when the file is modified.
            },

            cond = function()
              return vim.fn.tabpagenr("$") > 1
            end,
          },
        },
      },
    })
  end,
}
