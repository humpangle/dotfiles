-- DAP: Debug Adapter Protocol
local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.dap() then
  return {}
end

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

local function defer_notify(message)
  vim.defer_fn(function()
    vim.notify("[DAP]: " .. message)
  end, 5)
end

local function clear_breakpoints()
  local dap = require("dap")
  dap.clear_breakpoints()

  local ok, dap_helper_internals = pcall(require, "dap-helper.internals")
  if ok then
    dap_helper_internals.clear_json_file_content()
  end
end

---@param breakpoints table
---@param items table
---@param seen_breakpoints table
---@param relative_path? string
local function format_breakpoints_for_fzf_lua(
  breakpoints,
  items,
  seen_breakpoints,
  relative_path
)
  for buf_nr, bp_list in pairs(breakpoints) do
    relative_path = relative_path
      or utils.strip_cwd(vim.api.nvim_buf_get_name(buf_nr))
    for _, bp in ipairs(bp_list) do
      local key = relative_path .. bp.line
      if not seen_breakpoints[key] then
        seen_breakpoints[key] = true
        table.insert(
          items,
          string.format("%s:%d:1", relative_path, bp.line)
        )
      end
    end
  end
  return items, seen_breakpoints
end

local list_breakpoints_in_fzf_lua = function()
  local fzf_lua = require("fzf-lua")
  local fzf_actions = require("fzf-lua.actions")
  local items = {}
  local seen_breakpoints = {} -- Tracking to avoid duplicates

  -- Format breakpoints for currently loaded buffers
  local breakpoints = require("dap.breakpoints").get()
  format_breakpoints_for_fzf_lua(breakpoints, items, seen_breakpoints)

  -- Format breakpoints from dap-helper JSON file
  local ok, dap_helper_internals = pcall(require, "dap-helper.internals")
  if ok then
    local json_data = dap_helper_internals.load_data_from_json_file(
      dap_helper_internals.compute_json_filename_for_cwd()
    )

    for relative_path, file_data in pairs(json_data) do
      breakpoints = file_data.breakpoints
      if breakpoints and #breakpoints > 0 then
        -- Make breakpoints consistent with require("dap.breakpoints").get() which is keyed by buffer number:
        -- {
        --   [2] = { {
        --       line = 31
        --     }, {
        --       line = 40
        --     } }
        -- }
        breakpoints = {
          [relative_path] = file_data.breakpoints,
        }

        format_breakpoints_for_fzf_lua(
          breakpoints,
          items,
          seen_breakpoints,
          relative_path
        )
      end
    end
  end

  if #items == 0 then
    defer_notify("No breakpoints!")
    return
  end

  -- We sort items for consistent ordering of file names
  table.sort(items)

  utils.set_fzf_lua_nvim_listen_address()
  fzf_lua.fzf_exec(items, {
    prompt = "Breakpoints> ",
    actions = {
      ["default"] = fzf_actions.file_edit,
      ["ctrl-s"] = fzf_actions.file_split,
      ["ctrl-v"] = fzf_actions.file_vsplit,
      ["ctrl-t"] = fzf_actions.file_tabedit,
      ["alt-q"] = fzf_actions.file_sel_to_qf,
    },
    fzf_opts = {
      ["--header"] = string.format("Breakpoints (%d)", #items),
    },
    previewer = "builtin",
  })
end

---@param dir "next"|"prev"
---@param current_buffer_only? boolean
local function goto_breakpoint(dir, current_buffer_only)
  -- https://github.com/mfussenegger/nvim-dap/issues/792#issuecomment-1980921023
  local buf_nr = vim.api.nvim_get_current_buf()

  local breakpoints = require("dap.breakpoints").get()

  if current_buffer_only then
    breakpoints = {
      [buf_nr] = breakpoints[buf_nr] or {},
    }
  end

  local points = {}
  for bufnr, buffer in pairs(breakpoints) do
    for _, point in ipairs(buffer) do
      table.insert(points, {
        bufnr = bufnr,
        line = point.line,
      })
    end
  end

  local current = {
    bufnr = buf_nr,
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

-- Define breakpoint actions with descriptions
local function make_breakpoint_actions(dap)
  return {
    {
      description = "Toggle breakpoint 1",
      handler = function()
        dap.toggle_breakpoint()
        defer_notify("Breakpoint Toggled")
      end,
      count = 1,
    },
    {
      description = "Set Conditional breakpoint 11",
      handler = function()
        local prompt = vim.fn.input("Breakpoint condition: ")
        dap.set_breakpoint(prompt)
      end,
      count = 11,
    },
    {
      description = "Clear/Delete all breakpoints 2",
      handler = function()
        clear_breakpoints()
        defer_notify("All Breakpoints Cleared!")
      end,
      count = 2,
    },
    {
      description = "Clear/Delete all & set breakpoint 21",
      handler = function()
        clear_breakpoints()
        vim.defer_fn(function()
          dap.toggle_breakpoint()
        end, 100)
        defer_notify("All Breakpoints Cleared and Set!")
      end,
      count = 21,
    },
    {
      description = "Clear/Delete all & set conditional breakpoint 22",
      handler = function()
        clear_breakpoints()

        vim.defer_fn(function()
          local prompt = vim.fn.input("Breakpoint condition: ")
          dap.set_breakpoint(prompt)
        end, 500)
        defer_notify("All Breakpoints Cleared and Set!")
      end,
      count = 22,
    },
    {
      description = "Go to Next breakpoint FILE 3",
      handler = function()
        goto_breakpoint("next", true)
      end,
      count = 3,
    },
    {
      description = "Go to Previous breakpoint FILE 31",
      handler = function()
        goto_breakpoint("prev", true)
      end,
      count = 31,
    },
    {
      description = "Go to Next breakpoint GLOBAL 4",
      handler = function()
        goto_breakpoint("next")
      end,
      count = 4,
    },
    {
      description = "Previous breakpoint GLOBAL",
      handler = function()
        goto_breakpoint("prev")
      end,
      count = 41,
    },
    {
      description = "List breakpoints FZF-LUA 5",
      handler = function()
        list_breakpoints_in_fzf_lua()
      end,
      count = 5,
    },
  }
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
      "DapUninstall",
      "DapVirtualTextDisable",
      "DapVirtualTextEnable",
      "DapVirtualTextForceRefresh",
      "DapVirtualTextToggle",
    },
    keys = {
      map_lazy_key("<leader>daa", function()
        local dap = require("dap")
        local session = dap.session()
        local session_adapter_name = nil
        local count = vim.v.count

        if session then
          session_adapter_name = session.config.type
        end

        if count == 0 then
          if not session then
            dap.continue()
            defer_notify("Started")
            return
          end

          -- We must first disconnect otherwise the session will terminate (is this some kind of bug?)
          dap.disconnect()

          vim.defer_fn(function()
            session.config.terminateDebugee = false
            dap.restart(session.config)
            defer_notify(
              "Restarting Session for " .. session_adapter_name
            )
          end, 100)
          return
        end

        -- count > 0
        -- Check session status
        -- TODO: What about multiple sessions

        if session then
          local disconnected_str = ""

          if not session.parent then
            disconnected_str = " [DISCONNECTED]"
          end
          vim.notify(
            "Session running: "
              .. session_adapter_name
              .. disconnected_str
          )
        else
          vim.notify("No session running")
        end
      end, {
        desc = "continue",
      }),

      map_lazy_key("<leader>dab", function()
        local dap = require("dap")
        local fzf_lua = require("fzf-lua")
        local breakpoint_actions = make_breakpoint_actions(dap)
        local keymap_count = vim.v.count

        -- Format actions for display
        local items = {}
        for i, action in ipairs(breakpoint_actions) do
          if keymap_count == action.count then
            action.handler()
            return
          end

          table.insert(
            items,
            string.format("%d. %s", i, action.description)
          )
        end

        utils.set_fzf_lua_nvim_listen_address()

        fzf_lua.fzf_exec(items, {
          prompt = "Breakpoint Actions> ",
          actions = {
            ["default"] = function(selected)
              if not selected or #selected == 0 then
                return
              end

              local selection = selected[1]
              -- Extract action index from selection
              local index = tonumber(selection:match("^(%d+)%."))
              if index and breakpoint_actions[index] then
                breakpoint_actions[index].handler()
              end
            end,
          },
          fzf_opts = {
            ["--no-multi"] = "",
            ["--header"] = "Select a breakpoint action",
          },
        })
      end, {
        desc = "DAP: breakpoint actions menu",
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
        defer_notify("close")
        require("dap").close()
      end, {
        desc = "close",
      }),

      map_lazy_key("<leader>dat", function()
        local dap = require("dap")
        local dapui = require("dapui")
        local session = dap.session()
        local count = vim.v.count

        if count == 0 then
          local session_adapter_name = ""

          if session then
            session_adapter_name = ": "
              .. session.config.type
              .. " running"
          end

          dapui.toggle()
          defer_notify("UI Toggle" .. session_adapter_name)
          return
        end

        if count == 1 then
          dap.disconnect()
          defer_notify("Disconnected")
          return
        end

        require("dap").terminate()
        defer_notify("Terminated")
      end, {
        desc = "0/UiToggle 1/Disconnect 2/Terminate",
      }),

      map_lazy_key("<leader>dar", function()
        require("dap").restart()
      end, {
        desc = "restart",
      }),

      map_lazy_key("<leader>da0", function()
        require("dap").run_to_cursor()
        defer_notify("run to cursor")
      end, {
        desc = "DAP: Run to cursor",
      }),

      map_lazy_key("<leader>da1", function()
        require("dap").step_into()
        defer_notify("step into")
      end, {
        desc = "DAP: step_into",
      }),

      map_lazy_key("<leader>da2", function()
        require("dap").step_over()
        defer_notify("step over")
      end, {
        desc = "DAP: step_over",
      }),

      map_lazy_key("<leader>da3", function()
        require("dap").step_out()
        defer_notify("step out")
      end, {
        desc = "DAP: step_out",
      }),

      map_lazy_key("<leader>da4", function()
        require("dap").step_back()
        defer_notify("step back")
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
          local filter_names = {
            "node_modules",
            ".___scratch",
            "^fugitive:///",
            "^term://",
          }

          require("dap-helper").setup({
            is_invalid_filename = function(name)
              for _, fname in ipairs(filter_names) do
                if name:match(fname) then
                  return true
                end
              end

              return false
            end,
          })
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
      else
        vim.print("json5 does not exist for DAP vscode parsing")
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
            pause = "",
            play = "",
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
        list_breakpoints_in_fzf_lua,
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
