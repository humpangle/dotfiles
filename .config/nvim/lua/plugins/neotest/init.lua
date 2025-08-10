local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.notest() then
  return {}
end

local utils = require("utils")
local map_key = utils.map_key
local s_utils = require("settings-utils")

local function do_echo(text, on_going)
  on_going = on_going == nil and " ONGOING..." or ""
  vim.cmd.echo('"' .. "NETOTEST " .. text .. on_going .. '"')
end

local pytest_adapter = function()
  return require("neotest-python")({
    -- Extra arguments for nvim-dap configuration
    -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
    dap = {
      -- justMyCode = true,
      justMyCode = false,
    },
    -- Command line arguments for runner
    -- Can also be a function to return dynamic values
    -- args = {}, -- vim.g.__ebnis_neotest_python_args,
    -- putting in a function allows us to change the configuration on the fly (instead of needing to restart nvim
    -- just to change configuration).
    args = function()
      return vim.g.__ebnis_neotest_python_args
    end,
    -- Runner to use. Will use pytest if available by default.
    -- Can be a function to return dynamic value.
    runner = "pytest",
    -- Custom python path for the runner.
    -- Can be a string or a list of strings.
    -- Can also be a function to return dynamic value.
    -- If not provided, the path will be inferred by checking for
    -- virtual envs in the local directory and for Pipenev/Poetry configs
    python = require("plugins/lsp-extras/lsp_utils").get_python_path(),
    -- Returns if a given file path is a test file.
    -- NB: This function is called a lot so don't perform any heavy tasks within it.
    -- is_test_file = function(_file_path)
    --   return nil
    -- end,
    -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
    -- instances for files containing a parametrize mark (default: false)
    pytest_discover_instances = false, -- true, -- true makes neotest-python very slow
  })
end

local jest_adapter = function()
  local jest_cmd = "npm test --"
  -- See https://github.com/nvim-neotest/neotest-jest/issues/84
  -- for issue with trailing --

  local config = {
    jestCommand = jest_cmd,
    -- jestConfigFile = "custom.jest.config.ts",
    -- env = {
    --   CI = true,
    -- },
    cwd = function()
      return vim.fn.getcwd()
    end,
  }

  return require("neotest-jest")(config)
end

local vitest_adapter = function()
  local filter_names = {
    "node_modules",
    "___scratch",
  }

  local vitest_cmd = "vitest"
  local config = {
    vitestCommand = vitest_cmd,
    -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
    filter_dir = function(name)
      for _, fname in ipairs(filter_names) do
        if name:match(fname) then
          return false
        end
      end
      return true
    end,
    env = function()
      local vitest_environments = {}
      local env_var =
        utils.get_os_env_or_nil("EBNIS_VITEST_ENVIRONMENT_VARIABLES")
      if env_var then
        for line in env_var:gmatch("[^\n]+") do
          local key, value = line:match("^([^=]+)=(.*)$")
          if key and value then
            vitest_environments[vim.trim(key)] = vim.trim(value)
          end
        end
      end
      return vitest_environments
    end,
  }

  return require("neotest-vitest")(config)
end

local elixir_adapter = function()
  return require("neotest-elixir")({
    -- The Mix task to use to run the tests
    -- Can be a function to return a dynamic value.
    -- Default: "test"
    mix_task = {
      "test",
      -- "my_custom_task",
    },
    -- Other formatters to pass to the test command as the formatters are overridden
    -- Can be a function to return a dynamic value.
    -- Default: {"ExUnit.CLIFormatter"}
    extra_formatters = {
      -- "ExUnit.CLIFormatter",
      -- "ExUnitNotifier",
    },
    -- Extra test block identifiers
    -- Can be a function to return a dynamic value.
    -- Block identifiers "test", "feature" and "property" are always supported by default.
    -- Default: {}
    extra_block_identifiers = {
      -- "test_with_mock",
    },
    -- Extra arguments to pass to mix test
    -- Can be a function that receives the position, to return a dynamic value
    -- Default: {}
    args = {
      "--trace",
    },
    -- Command wrapper
    -- Must be a function that receives the mix command as a table, to return a dynamic value
    -- Default: function(cmd) return cmd end
    post_process_command = function(cmd)
      -- return vim.tbl_flatten({ { "env", "FOO=bar" }, cmd })
      return cmd
    end,
    -- Delays writes so that results are updated at most every given milliseconds
    -- Decreasing this number improves snappiness at the cost of performance
    -- Can be a function to return a dynamic value.
    -- Default: 1000
    write_delay = 1000,
  })
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- adapters
    "nvim-neotest/neotest-python",
    {
      "mfussenegger/nvim-dap",
      optional = true,
          -- stylua: ignore
          keys = {
            {
              "<leader>ntd",
              function()
                vim.o.background = "dark"
                do_echo("Debug")
                ---@diagnostic disable-next-line: missing-fields
                require("neotest").run.run({ strategy = "dap" })
              end,
              desc = "Neotest Debug At Cursor"
            },
          },
    },
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "jfpedroza/neotest-elixir",
    -- /END/ adapters
  },
  init = function()
    -- default pytest args
    local default_pytest_args = utils.get_os_env_or_nil("EBNIS_PYTEST_ARGS")

    default_pytest_args = default_pytest_args
      and vim.json.decode(default_pytest_args)

    vim.g.__ebnis_neotest_python_args = default_pytest_args
      or {
        "--disable-warnings",
        "-vvv",
        "--log-level",
        "INFO",
        "--capture",
        "no",
      }

    vim.api.nvim_create_user_command("NeoPyArgs", function(opts)
      local count = opts.fargs[1]

      if count == "1" then
        utils.write_to_command_mode(
          "lua vim.g.__ebnis_neotest_python_args = {}"
        )
        return
      end

      local args_text = "lua vim.g.__ebnis_neotest_python_args = "
        .. "\\n"
        .. "{"
        .. "\\n"
        .. "}"
        .. "\\n"
        .. "\\n"
        .. '\\"--log-level\\", \\"DEBUG\\",'
        .. "\\n"
        .. '\\"--log-level\\", \\"INFO\\",'
        .. "\\n"
        .. '\\"-vvv\\",'
        .. "\\n"
        .. '\\"--capture\\", \\"no\\",'
        .. "\\n"
        .. '\\"--disable-warnings\\",'
        .. "\\n"
        .. '\\"--ignore\\",'
        .. "\\n"
        .. '\\"--verbosity\\", \\"0\\",'

      local current_args_value_string = '{ "'
        .. table.concat(vim.g.__ebnis_neotest_python_args, '", "')
        .. '" }'

      current_args_value_string =
        current_args_value_string:gsub('"', '\\"')

      s_utils.RedirMessages(
        'echo "'
          .. args_text
          .. "\\n\\\n"
          .. current_args_value_string
          .. '"',
        "new"
      )
    end, { nargs = "*" })

    -- keymaps
    map_key("n", "<leader>nto", function()
      local count = vim.v.count

      if count == 0 then
        require("neotest").output.open({
          enter = true,
          auto_close = true,
        })
      end

      if count == 1 then
        require("neotest").output_panel.toggle()
        return
      end

      if count == 2 then
        do_echo("Clear output panel", "")
        require("neotest").output_panel.clear()
        return
      end
    end, {
      desc = "0/inline-output 1/Toggle-Tab-Output-Panel 2/out-panel-clear",
    })
  end,
  config = function()
    local neotest = require("neotest")

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup({
      adapters = {
        pytest_adapter(),
        jest_adapter(),
        vitest_adapter(),
        elixir_adapter(),
      },
      discovery = {
        -- Number of workers to parse files concurrently. A value of 0 automatically assigns number based on CPU.
        -- Set to 1 if experiencing lag.
        concurrent = 12,
        -- Drastically improve performance in ginormous projects by only AST-parsing the currently opened buffer.
        enabled = false,
        -- enabled = true,
      },
      running = {
        -- Run tests concurrently when an adapter provides multiple commands to run.
        concurrent = true,
      },
      ---@diagnostic disable-next-line: missing-fields
      summary = {
        -- Enable/disable animation of icons.
        animated = false,
      },
      -- Set to true to open quickfix window on test failure
      quickfix = {
        enabled = false,
        -- enabled = true,
        -- open = true,
        open = false,
      },
      ---@diagnostic disable-next-line: missing-fields
      output_panel = {
        open = "tab split",
      },

      -- icons = {
      --   running = "🏃",
      --   failed = "✖",
      --   passed = "✔",
      --   skipped = "⤵",
      --   unknown = "",
      -- },
    })
  end,

  keys = {
    {
      "<leader>ntt",
      function()
        vim.o.background = "dark"
        local count = vim.v.count

        if count == 0 then
          do_echo("At Cursor")
          require("neotest").run.run()
          return
        end

        if count == 1 then
          do_echo("current file")
          require("neotest").run.run(vim.fn.expand("%"))
          return
        end

        if count == 2 then
          do_echo("ALL TESTS")
          require("neotest").run.run(vim.uv.cwd())
          return
        end

        if count == 3 then
          do_echo("failed")
          ---@diagnostic disable-next-line: missing-fields
          require("neotest").run.run({ status = "failed" })
          return
        end

        if count == 4 then
          do_echo("RNNING LAST")
          require("neotest").run.run_last()
          return
        end

        if count == 5 then
          do_echo("STOP")
          require("neotest").run.stop()
          return
        end
      end,
      desc = "<leader>ntt Neotest run 0/nearest 1/file 2/ALL 3/failed 4/last 5/stop",
    },
    {
      "<leader>nta",
      function()
        do_echo("Attach to floating output.", "")
        require("neotest").run.attach()
      end,
      desc = "Netotest Running?",
    },
    {
      "<leader>nts",
      function()
        do_echo("Summary toggle", "")
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>ntw",
      function()
        do_echo("toggle watch", "")
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Neoetst Toggle Watch",
    },
  },
}
