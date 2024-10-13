-- DAP: Debug Adapter Protocol
local plugin_enabled = require("plugins/plugin_enabled")

local utils = require("utils")

local keymap = utils.map_key

return {
  {
    "Joakker/lua-json5",
  },

  {
    "mfussenegger/nvim-dap",
    enabled = plugin_enabled.dap(),
    cmd = {
      "DapClearBreakpoints",
      "DapContinue",
      "DapInstall",
      "DapLoadLaunchJSON",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapUIToggle",
      "DapUiToggle",
      "DapUninstall",
      "DapVirtualTextDisable",
      "DapVirtualTextEnable",
      "DapVirtualTextForceRefresh",
      "DapVirtualTextToggle",
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
      },

      -- Installs the debug adapters binaries for you automatically and provides best effort configuration for such
      -- adapter
      "jay-babu/mason-nvim-dap.nvim",

      -- Creates a beautiful debugger UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          -- Required dependency for nvim-dap-ui
          "nvim-neotest/nvim-nio",
        },
      },

      -- Adds virtual text support to nvim-dap.
      -- nvim-treesitter is used to find variable definitions.
      {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
      },

      -- Some plugins provide *NICER* developer experiences (default config for the speciic language, launching the
      -- debugger binary automatically etc) for nvim-dap. One trick is to read the source of the plugin and *steal*
      -- some of the config into the mason-nvim-dap handlers table.
      -- Some examples are provided
      -- { "leoluz/nvim-dap-go" }, -- golang
      -- See plugins/lsp/python-tools.lua for dap configurations for python.
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_dap = require("mason-nvim-dap")

      -- Use json5 to parse vscode-like launch.json file (with comments)
      require("dap.ext.vscode").json_decode = require("json5").parse

      mason_dap.setup({
        -- Debugger binaries you want mason to install for you.
        -- Check for debug adapters - you want to use the keys:
        --    https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
        ensure_installed = {
          "elixir",
          "python",
          "js",
          -- 'chrome',
          "bash",
        },

        automatic_installation = true,
        handlers = nil,
      })

      -- Basic debugging keymaps, feel free to change to your liking!

      -- STARTING / STOPPING / SHOWING DAP UI
      keymap("n", "<leader>Dcc", dap.continue, {
        desc = "Debug: continue",
      })

      keymap("n", "<leader>Dtt", dapui.toggle, {
        desc = "Debug: UI toggle",
      })

      keymap("n", "<leader>Drr", dap.restart, {
        desc = "Debug: restart",
      })
      -- /END STARTING / STOPPING / SHOWING DAP UI

      keymap("n", "<leader>Dbt", function()
        dap.toggle_breakpoint()
      end, {
        desc = "Debug: Toggle Breakpoint",
      })

      keymap("n", "<leader>DbC", dap.clear_breakpoints, {
        desc = "Debug: Toggle Breakpoint",
      })

      keymap("n", "<leader>Dbc", function()
        local prompt = vim.fn.input("Breakpoint condition: ")
        dap.set_breakpoint(prompt)
      end, {
        desc = "Debug: Set Conditional Breakpoint",
      })

      keymap("n", "<leader>Drc", function()
        dap.run_to_cursor()
      end, {
        desc = "Debug: Run to cursor",
      })

      keymap("n", "<leader>D?", function()
        dapui.eval(nil, { enter = true })
      end, {
        desc = "Debug: Inspect current value - eval under cursor",
      })

      keymap("n", "<leader>Dsi", dap.step_into, {
        desc = "Debug: step_into",
      })

      keymap("n", "<leader>Dso", dap.step_out, {
        desc = "Debug: step_out",
      })

      keymap("n", "<leader>Dsv", dap.step_over, {
        desc = "Debug: step_over",
      })

      keymap("n", "<leader>Dsb", dap.step_back, {
        desc = "Debug: step_back",
      })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup({
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "*",
        },
        ---@diagnostic disable-next-line: missing-fields
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.api.nvim_create_user_command("DapUiToggle", dapui.toggle, {})
      vim.api.nvim_create_user_command("DapUIToggle", dapui.toggle, {})

      vim.api.nvim_create_user_command(
        "DapClearBreakpoints",
        dap.clear_breakpoints,
        {}
      )

      -- You can use nvim-dap events to open and close the windows automatically when DAP starts (:help dap-extensions)
      dap.listeners.after.event_initialized.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

      -- Some attempt at mitigating leaking tokens/secrets
      require("nvim-dap-virtual-text").setup({
        display_callback = function(variable)
          local variable_val = variable.value

          local name_lower = string.lower(variable.name)
          local val_lower = string.lower(variable_val)

          if
            name_lower:match("secret")
            or name_lower:match("api")
            or val_lower:match("secret")
            or val_lower:match("api")
          then
            return "*****"
          end

          if #variable_val > 15 then
            return " " .. string.sub(variable_val, 1, 15) .. "... "
          end

          return " " .. variable_val
        end,
      })
    end,
  },
}
