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
    python = require("plugins/lsp_utils").get_python_path(),
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
    "jfpedroza/neotest-elixir",
    -- /END/ adapters
  },
  init = function()
    -- default pytest args
    vim.g.__ebnis_neotest_python_args = {
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
    map_key("n", "<leader>ntO", function()
      require("neotest").output.open({
        enter = true,
        auto_close = true,
      })
    end, {
      desc = "Neotest Show Output",
    })

    map_key("n", "<leader>nto", function()
      local count = vim.v.count

      if count == 99 then
        require("neotest").output_panel.toggle()
        return
      end

      local search_text = ""

      if count == 1 then
        search_text = "========= test session starts ========"
      elseif count == 2 then
        search_text = "\\.py[^:]*[FE]" -- fail or error
      elseif count == 3 then
        search_text =
          "=========== \\(FAILURES\\|ERRORS\\) ======================"
      elseif count == 4 then
        search_text = "_ .*test_.\\+ _"
      elseif count == 5 then
        search_text = "------- Captured "
      elseif count == 6 then
        search_text = "ERROR\\s\\+"
      elseif count == 7 then
        search_text = "= short test summary info ="
      elseif count == 8 then
        search_text =
          "\\d\\{4\\}-\\d\\{2\\}-\\d\\{2\\}[^\\d]\\d\\{2\\}:\\d\\{2\\}:\\d\\{2\\}"
      end

      local to_call = "N"
      if count == 6 then
        to_call = "n"
      end

      vim.cmd({ cmd = "edit", bang = true })
      vim.fn.setreg("/", search_text)
      vim.cmd("set hlsearch")
      pcall(vim.cmd.normal, { to_call, bang = true })
    end, {
      desc = "99/Toggle-Output-Panel 1/session-start 2/.py FE 3/failures/errors 4/__test__ 5/captured",
    })
  end,
  config = function()
    local neotest = require("neotest")

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup({
      adapters = {
        pytest_adapter(),
        jest_adapter(),
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
      end,
      desc = "<leader>ntt Neotest run 0/nearest 1/file 2/ALL 3/failed 4/last",
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
      "<leader>ntc",
      function()
        do_echo("Clear output panel", "")
        require("neotest").output_panel.clear()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>ntS",
      function()
        do_echo("STOP")
        require("neotest").run.stop()
      end,
      desc = "Stop",
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
