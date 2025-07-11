-- DAP: Debug Adapter Protocol
local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.dap() then
  return {}
end

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

local function do_echo(text)
  vim.cmd.echo('"' .. "DAP: " .. text .. '"')
end

local list_breakpoints_in_qickfix = function()
  local breakpoints = require("dap.breakpoints").get()
  local quickfix_list = {}

  for buf_nr, bp_list in pairs(breakpoints) do
    local filename = vim.api.nvim_buf_get_name(buf_nr)
    for _, bp in ipairs(bp_list) do
      table.insert(quickfix_list, {
        filename = filename,
        lnum = bp.line,
        text = "Breakpoint",
      })
    end
  end

  if #quickfix_list == 0 then
    vim.cmd.echo('"' .. "DAP: No breakpoints!" .. '"')
    return
  end

  vim.fn.setqflist({}, " ", {
    title = "Breakpoints",
    items = quickfix_list,
  })

  vim.cmd("copen")
end

---@param dir "next"|"prev"
local function gotoBreakpoint(dir)
  -- https://github.com/mfussenegger/nvim-dap/issues/792#issuecomment-1980921023
  local breakpoints = require("dap.breakpoints").get()
  -- if #breakpoints == 0 then
  --   vim.notify("No breakpoints set", vim.log.levels.WARN)
  --   return
  -- end
  local points = {}
  for bufnr, buffer in pairs(breakpoints) do
    for _, point in ipairs(buffer) do
      table.insert(points, { bufnr = bufnr, line = point.line })
    end
  end

  local current = {
    bufnr = vim.api.nvim_get_current_buf(),
    line = vim.api.nvim_win_get_cursor(0)[1],
  }

  local nextPoint
  for i = 1, #points do
    local isAtBreakpointI = points[i].bufnr == current.bufnr
      and points[i].line == current.line
    if isAtBreakpointI then
      local nextIdx = dir == "next" and i + 1 or i - 1
      if nextIdx > #points then
        nextIdx = 1
      end
      if nextIdx == 0 then
        nextIdx = #points
      end
      nextPoint = points[nextIdx]
      break
    end
  end
  if not nextPoint then
    nextPoint = points[1]
  end

  vim.cmd(("buffer +%s %s"):format(nextPoint.line, nextPoint.bufnr))
end

return {
  {
    "Joakker/lua-json5",
    --[[ for macos, add to $CARGO_HOME/config ($HOME/.cargo by deafult)
         https://doc.rust-lang.org/cargo/reference/environment-variables.html
         https://github.com/Joakker/lua-json5/blob/d8e962a98b9c66bda02b20df02868a72ef4c8803/README.md?plain=1#L7
    ]]
  },

  {
    "mfussenegger/nvim-dap",
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
    keys = {
      map_lazy_key("<leader>daa", function()
        do_echo("continue")
        require("dap").continue()
      end, {
        desc = "continue",
      }),

      map_lazy_key("<leader>dab", function()
        local dap = require("dap")
        local count = vim.v.count

        if count == 0 then
          dap.toggle_breakpoint()
        elseif count == 1 then
          local prompt = vim.fn.input("Breakpoint condition: ")
          dap.set_breakpoint(prompt)
        elseif count == 2 then
          dap.clear_breakpoints()
          vim.notify("All Breakpoints Cleared!")
        elseif count == 20 then
          dap.clear_breakpoints()

          dap.toggle_breakpoint()

          vim.notify("All Breakpoints Cleared and Set!")
        elseif count == 21 then
          dap.clear_breakpoints()

          local prompt = vim.fn.input("Breakpoint condition: ")
          dap.set_breakpoint(prompt)

          vim.notify("All Breakpoints Cleared and Set!")
        elseif count == 3 then
          gotoBreakpoint("next")
        elseif count == 4 then
          gotoBreakpoint("prev")
        elseif count == 5 then
          list_breakpoints_in_qickfix()
        end
      end, {
        desc = "DAP: breakpoints 0/toggle 1/cond 2/clear 3/next 4/prev 5/list",
      }),

      map_lazy_key("<leader>da=", function()
        local dap = require("dap")
        local dapui = require("dapui")

        if vim.v.count == 0 then
          ---@diagnostic disable: missing-fields
          dapui.eval(nil, { enter = true })
          return
        end

        local lines = ""
        local mode = vim.fn.mode()

        if mode == "n" then
          vim.cmd("normal! vgny")
          lines = vim.fn.getreg('"')
        else
          local lines_table =
            vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
          lines = table.concat(lines_table, "\n")
        end

        dap.repl.open()
        dap.repl.execute(lines)
      end, {
        desc = "DAP: 0/eval under cursor 2/send region to repl",
      }, { "n", "x" }),

      map_lazy_key("<leader>dax", function()
        do_echo("close")
        require("dap").close()
      end, {
        desc = "close",
      }),

      map_lazy_key("<leader>dat", function()
        do_echo("UI Toggle")
        require("dapui").toggle()
      end, {
        desc = "UI toggle",
      }),

      map_lazy_key("<leader>daT", function()
        do_echo("terminate")
        require("dap").terminate()
      end, {
        desc = "Terminate",
      }),

      map_lazy_key("<leader>dar", function()
        require("dap").restart()
      end, {
        desc = "restart",
      }),

      map_lazy_key("<leader>da0", function()
        do_echo("run to cursor")
        require("dap").run_to_cursor()
      end, {
        desc = "DAP: Run to cursor",
      }),

      map_lazy_key("<leader>da1", function()
        do_echo("step into")
        require("dap").step_into()
      end, {
        desc = "DAP: step_into",
      }),

      map_lazy_key("<leader>da2", function()
        do_echo("step over")
        require("dap").step_over()
      end, {
        desc = "DAP: step_over",
      }),

      map_lazy_key("<leader>da3", function()
        do_echo("step out")
        require("dap").step_out()
      end, {
        desc = "DAP: step_out",
      }),

      map_lazy_key("<leader>da4", function()
        do_echo("step back")
        require("dap").step_back()
      end, {
        desc = "DAP: step_back",
      }),
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

      {
        -- Easy modification of command line arguments passed to the debuggee
        -- Saving/restoring of breakpoints and watches across sessions
        "humpangle/dap-helper.nvim",
        -- dependencies = {
        --   "rcarriga/nvim-dap-ui",
        --   "mfussenegger/nvim-dap",
        -- },
        config = function()
          require("dap-helper").setup()
        end,
      },

      -- simple plugin to find the nearest package.json and read all the scripts from package.json file
      -- https://banjocode.com/post/nvim/debug-node
      {
        "banjo/package-pilot.nvim",
      },

      -- Some plugins provide *NICER* developer experiences (default config for the speciic language, launching the
      -- debugger binary automatically etc) for nvim-dap. One trick is to read the source of the plugin and *steal*
      -- some of the config into the mason-nvim-dap handlers table.
      -- Some examples are provided
      -- { "leoluz/nvim-dap-go" }, -- golang

      {
        -- https://github.com/mfussenegger/nvim-dap-python
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          local python_bin =
            require("plugins/lsp-extras/lsp_utils").get_python_path()

          require("dap-python").setup(python_bin)
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("plugins.dap.adapters-install")

      -- Use json5 to parse vscode-like launch.json file (with comments)
      local json5_exists, json5 = pcall(require, "json5")
      if json5_exists then
        -- https://github.com/mfussenegger/nvim-dap/blob/2edd6375692d9ac1053d50acfe415c1eb2ba92d0/doc/dap.txt#L338
        require("dap.ext.vscode").json_decode = json5.parse
      end

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
            pause = "P",
            play = "-0-", -- run to cursor
            step_into = "-1-",
            step_over = "-2-",
            step_out = "-3-",
            step_back = "-4-",
            run_last = "-L-",
            terminate = "-T-",
            disconnect = "-D-",
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

      vim.api.nvim_create_user_command(
        "DAPListBreakpoints",
        list_breakpoints_in_qickfix,
        { nargs = "*" }
      )

      -- ADAPTERS --
      -- https://github.com/mfussenegger/nvim-dap-python
      require("plugins.dap.php")
      require("plugins.dap.pwa-node")
      -- /END ADAPTERS --
    end,
  },
}
