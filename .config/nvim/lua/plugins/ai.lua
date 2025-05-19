local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.ai_enabled() then
  return {}
end

local utils = require("utils")
local map_key = utils.map_key

return {
  {
    "github/copilot.vim",
    cond = plugin_enabled.has_official_copilot(),
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    keys = {
      {
        "<M-cr>",
        "<cmd>Copilot panel<cr>",
        mode = { "n", "i" },
        desc = "Copilot panel",
      },
      {
        "<M-e>",
        function()
          vim.cmd("Copilot enable")
          vim.cmd.echo('"Copilot enabled"')
        end,
        mode = { "n", "i" },
        desc = "Copilot enable",
      },
    },
    init = function()
      map_key({ "n", "i" }, "<M-s>", "<cmd>Copilot status<cr>", {
        desc = "Copilot status",
      })

      map_key({ "n", "i" }, "<M-d>", function()
        vim.cmd("Copilot disable")
        vim.cmd.echo('"Copilot disabled"')
      end, {
        desc = "Copilot disable",
      })
    end,
    config = function()
      vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.g.copilot_no_tab_map = true
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cond = plugin_enabled.has_community_copilot(),
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    init = function()
      map_key({ "n", "i" }, "<M-cr>", function()
        vim.cmd("Copilot panel")
      end, { noremap = true })
    end,
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true, -- false,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = "<M-Right>", -- false,
            accept_line = "<C-S-Right>", -- false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end,
  },

  -- Inspired by https://github.com/jellydn/my-nvim-ide
  -- IMPORTANT: sudo luarocks install --lua-version 5.1 tiktoken_core
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- Do not use branch and version together, either use branch or version
    version = "v2.14.2",
    -- branch = "canary", -- Use the canary branch if you want to test the latest features but it might be unstable
    cond = plugin_enabled.has_copilot(),
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          -- calling `setup` is optional for customization
          require("fzf-lua").setup({})
        end,
      },
    },
    opts = {
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      -- prompts = prompts,
      auto_follow_cursor = false, -- Don't follow the cursor after getting response
      show_help = false, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        -- Close the chat
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        -- Reset the chat buffer
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
        -- Submit the prompt to Copilot
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        -- Accept the diff
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        -- Yank the diff in the response to register
        yank_diff = {
          normal = "gmy",
        },
        -- Show the diff
        show_diff = {
          normal = "gmd",
        },
        -- Show the prompt
        show_system_prompt = {
          normal = "gmp",
        },
        -- Show the user selection
        show_user_selection = {
          normal = "gms",
        },
        -- Show help
        show_help = {
          normal = "gmh",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      opts.prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
          callback = function(response, source)
            local ns =
              vim.api.nvim_create_namespace("copilot_review")
            local diagnostics = {}
            for line in response:gmatch("[^\r\n]+") do
              if line:find("^line=") then
                local start_line = nil
                local end_line = nil
                local message = nil
                local single_match, message_match =
                  line:match("^line=(%d+): (.*)$")
                if not single_match then
                  local start_match, end_match, m_message_match =
                    line:match("^line=(%d+)-(%d+): (.*)$")
                  if start_match and end_match then
                    start_line = tonumber(start_match)
                    end_line = tonumber(end_match)
                    message = m_message_match
                  end
                else
                  start_line = tonumber(single_match)
                  end_line = start_line
                  message = message_match
                end

                if start_line and end_line then
                  table.insert(diagnostics, {
                    lnum = start_line - 1,
                    end_lnum = end_line - 1,
                    col = 0,
                    message = message,
                    severity = vim.diagnostic.severity.WARN,
                    source = "Copilot Review",
                  })
                end
              end
            end
            vim.diagnostic.set(ns, source.bufnr, diagnostics)
          end,
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Please generate tests for my code.",
        },
        FixDiagnostic = {
          prompt = "Please assist with the following diagnostic issue in file:",
          selection = select.diagnostics,
        },
        Commit = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = select.gitdiff,
        },
        CommitStaged = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return select.gitdiff(source, true)
          end,
        },
      }

      -- Use unnamed register for the selection
      opts.selection = select.unnamed

      local hostname = io.popen("hostname"):read("*a"):gsub("%s+", "")
      local user = hostname or vim.env.USER or "User"
      opts.question_header = "  " .. user .. " "
      opts.answer_header = "  Copilot "
      -- Override the git prompts message
      opts.prompts.Commit = {
        prompt = 'Write commit message with commitizen convention. Write clear, informative commit messages that explain the "what" and "why" behind changes, not just the "how".',
        selection = select.gitdiff,
      }
      opts.prompts.CommitStaged = {
        prompt = 'Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the "what" and "why" behind changes, not just the "how".',
        selection = function(source)
          return select.gitdiff(source, true)
        end,
      }

      chat.setup(opts)
      -- Setup CMP integration
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })
    end,
    keys = {
      -- Show help actions
      {
        "<leader>ah",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(
            actions.help_actions()
          )
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(
            actions.prompt_actions()
          )
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>ap",
        ":lua require('CopilotChat.integrations.fzflua').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
        mode = "x",
        desc = "CopilotChat - Prompt actions",
        silent = true,
      },

      -- Code related commands
      {
        "<leader>ae",
        "<cmd>CopilotChatExplain<cr>",
        desc = "CopilotChat - Explain code",
      },
      {
        "<leader>at",
        "<cmd>CopilotChatTests<cr>",
        desc = "CopilotChat - Generate tests",
      },
      {
        "<leader>ar",
        "<cmd>CopilotChatReview<cr>",
        desc = "CopilotChat - Review code",
      },
      {
        "<leader>aR",
        "<cmd>CopilotChatRefactor<cr>",
        desc = "CopilotChat - Refactor code",
      },
      {
        "<leader>an",
        "<cmd>CopilotChatBetterNamings<cr>",
        desc = "CopilotChat - Better Naming",
      },
      -- Chat with Copilot in visual mode
      {
        "<leader>av",
        "<cmd>CopilotChatVisual<cr>",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ax",
        ":CopilotChatInline<cr>",
        mode = "x",
        desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "CopilotChat - Ask input",
      },
      -- Generate commit message based on the git diff
      {
        "<leader>am",
        "<cmd>CopilotChatCommit<cr>",
        desc = "CopilotChat - Generate commit message for all changes",
      },
      {
        "<leader>aM",
        "<cmd>CopilotChatCommitStaged<cr>",
        desc = "CopilotChat - Generate commit message for staged changes",
      },
      -- Quick chat with Copilot
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Debug
      {
        "<leader>ad",
        "<cmd>CopilotChatDebugInfo<cr>",
        desc = "CopilotChat - Debug Info",
      },
      -- Fix the issue with diagnostic
      {
        "<leader>af",
        "<cmd>CopilotChatFixDiagnostic<cr>",
        desc = "CopilotChat - Fix Diagnostic",
      },
      -- Clear buffer and chat history
      {
        "<leader>al",
        "<cmd>CopilotChatReset<cr>",
        desc = "CopilotChat - Clear buffer and chat history",
      },
      -- Toggle Copilot Chat Vsplit
      {
        "<leader>av",
        "<cmd>CopilotChatToggle<cr>",
        desc = "CopilotChat - Toggle",
      },
      -- Copilot Chat Models
      {
        "<leader>a?",
        "<cmd>CopilotChatModels<cr>",
        desc = "CopilotChat - Select Models",
      },
    },
  },

  -- OS dependencies `sudo apt-get install sox libsox-fmt-mp3`
  {
    "robitx/gp.nvim",
    cond = plugin_enabled.has_gpt(),
    config = function()
      local conf = {
        -- For customization, refer to Install > Configuration in the Documentation/Readme
      }
      require("gp").setup(conf)

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },
}
