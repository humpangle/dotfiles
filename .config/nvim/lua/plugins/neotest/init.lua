local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.notest() then
  return {}
end

local utils = require("utils")
local s_utils = require("settings-utils")

local function do_echo(text, on_going)
  on_going = on_going == nil and " ONGOING..." or ""
  vim.cmd.echo('"' .. "NETOTEST " .. text .. on_going .. '"')
end

return {
  {
    {
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
                do_echo("Debug")
                ---@diagnostic disable-next-line: missing-fields
                require("neotest").run.run({ strategy = "dap" })
              end,
              desc = "Neotest Debug At Cursor"
            },
          },
        },
      },
      init = function()
        vim.g.__ebnis_neotest_python_args =
          { "--disable-warnings", "-vvv" }

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
            .. table.concat(
              vim.g.__ebnis_neotest_python_args,
              '", "'
            )
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
      end,
      config = function()
        local neotest = require("neotest")

        local pytest_adapter = require("neotest-python")({
          -- Extra arguments for nvim-dap configuration
          -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          dap = {
            justMyCode = true,
          },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          -- args = {}, -- vim.g.__ebnis_neotest_python_args,
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

        ---@diagnostic disable-next-line: missing-fields
        neotest.setup({
          adapters = {
            pytest_adapter,
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
        })
      end,

      keys = {
        {
          "<leader>ntf",
          function()
            do_echo("failed")
            ---@diagnostic disable-next-line: missing-fields
            require("neotest").run.run({ status = "failed" })
          end,
          desc = "Neotest Failed",
        },
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

            if count == 1 then
              do_echo("ALL TESTS")
              require("neotest").run.run(vim.uv.cwd())
              return
            end
          end,
          desc = "Neotest at cursor/file/ALL",
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
          "<leader>ntl",
          function()
            do_echo("RNNING LAST")
            require("neotest").run.run_last()
          end,
          desc = "Neotest Run Last",
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
          "<leader>ntO",
          function()
            require("neotest").output.open({
              enter = true,
              auto_close = true,
            })
          end,
          desc = "Neotest Show Output",
        },
        {
          "<leader>nto",
          function()
            local count = vim.v.count

            if count == 0 then
              require("neotest").output_panel.toggle()
              return
            end

            local search_text = ""

            if count == 1 then
              search_text =
                "========= test session starts ========"
            elseif count == 2 then
              search_text = ".py F"
            elseif count == 3 then
              search_text =
                "=========== FAILURES ======================"
            elseif count == 4 then
              search_text = "_ test_.\\+ _"
            elseif count == 5 then
              search_text = "------- Captured "
            elseif count == 6 then
              search_text = "= short test summary info ="
            elseif count == 7 then
              search_text =
                "^\\d\\{4\\}-\\d\\{2\\}-\\d\\{2\\}.\\d\\{2\\}:\\d\\{2\\}:\\d\\{2\\}"
            end

            vim.fn.setreg("/", search_text)
            vim.cmd("set hlsearch")
            pcall(vim.cmd.normal, { "N", bang = true })
          end,
          desc = "Toggle Output Panel",
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
    },
  },
}
