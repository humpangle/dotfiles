local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.codecompanion_ai() then
  return {}
end

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

local default_dapaters = {
  chat = "openai",
  inline = "openai",
  cmd = "openai",
}

-- https://github.com/olimorris/codecompanion.nvim/blob/dbefc41dba2f46720ecb6ecec34c0c5f80022f2b/lua/codecompanion/config.lua#L6
local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

---@param adapter_type "chat"|"inline"|"cmd"
---@return "openai"|"anthropic"|"copilot"|"gemini"
local function get_adapter(adapter_type)
  local adapter = utils.get_os_env_or_nil(
    "NVIM_CODECOMPANION_AI_ADAPTER_" .. adapter_type:upper()
  )

  return adapter or default_dapaters[adapter_type]
end

local generate_commit_message = function()
  return string.format(
    [[Prefer descriptive, sentence case commits with additional context. Generate commit message from git diff below:

```diff
%s
```
]],
    vim.fn.system("git diff --no-ext-diff --staged")
  )
end

return {
  "olimorris/codecompanion.nvim",
  ft = {
    "codecompanion",
  },
  cmd = {
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
    "CodeCompanion",
  },
  init = function()
    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab cca CodeCompanionChat]])
  end,
  opts = {
    adapters = {
      -- LLMs -------------------------------------------------------------------
      anthropic = "anthropic",
      openai = "openai",
      copilot = "copilot",
      gemini = "gemini",
    },
    strategies = {
      -- CHAT STRATEGY ----------------------------------------------------------
      chat = {
        adapter = get_adapter("chat"),
        roles = {
          user = "Ebnis",
        },
        keymaps = {
          options = {
            modes = {
              n = "?",
            },
            description = "Options",
            hide = true,
          },
          completion = {
            modes = {
              i = "<C-_>",
            },
            index = 1,
            callback = "keymaps.completion",
            description = "Completion Menu",
          },
          send = {
            modes = {
              n = { "<CR>", "<C-s>" },
              i = "<C-s>",
            },
            index = 2,
            callback = "keymaps.send",
            description = "Send",
          },
          regenerate = {
            modes = {
              n = "gr",
            },
            index = 3,
            callback = "keymaps.regenerate",
            description = "Regenerate the last response",
          },
          close = {
            modes = {
              n = "<C-c>",
              i = "<C-c>",
            },
            index = 4,
            callback = "keymaps.close",
            description = "Close Chat",
          },
          stop = {
            modes = {
              n = "q",
            },
            index = 5,
            callback = "keymaps.stop",
            description = "Stop Request",
          },
          clear = {
            modes = {
              n = "gx",
            },
            index = 6,
            callback = "keymaps.clear",
            description = "Clear Chat",
          },
          codeblock = {
            modes = {
              n = "gc",
            },
            index = 7,
            callback = "keymaps.codeblock",
            description = "Insert Codeblock",
          },
          yank_code = {
            modes = {
              n = "gy",
            },
            index = 8,
            callback = "keymaps.yank_code",
            description = "Yank Code",
          },
          pin = {
            modes = {
              n = "gp",
            },
            index = 9,
            callback = "keymaps.pin_reference",
            description = "Pin Reference",
          },
          watch = {
            modes = {
              n = "gw",
            },
            index = 10,
            callback = "keymaps.toggle_watch",
            description = "Watch Buffer",
          },
          next_chat = {
            modes = {
              n = "}",
            },
            index = 11,
            callback = "keymaps.next_chat",
            description = "Next Chat",
          },
          previous_chat = {
            modes = {
              n = "{",
            },
            index = 12,
            callback = "keymaps.previous_chat",
            description = "Previous Chat",
          },
          next_header = {
            modes = {
              n = "]]",
            },
            index = 13,
            callback = "keymaps.next_header",
            description = "Next Header",
          },
          previous_header = {
            modes = {
              n = "[[",
            },
            index = 14,
            callback = "keymaps.previous_header",
            description = "Previous Header",
          },
          change_adapter = {
            modes = {
              n = "ga",
            },
            index = 15,
            callback = "keymaps.change_adapter",
            description = "Change adapter",
          },
          fold_code = {
            modes = {
              n = "gf",
            },
            index = 15,
            callback = "keymaps.fold_code",
            description = "Fold code",
          },
          debug = {
            modes = {
              n = "gd",
            },
            index = 16,
            callback = "keymaps.debug",
            description = "View debug info",
          },
          system_prompt = {
            modes = {
              n = "gs",
            },
            index = 17,
            callback = "keymaps.toggle_system_prompt",
            description = "Toggle the system prompt",
          },
          auto_tool_mode = {
            modes = {
              n = "gta",
            },
            index = 18,
            callback = "keymaps.auto_tool_mode",
            description = "Toggle automatic tool mode",
          },
        },
      },
      -- INLINE STRATEGY --------------------------------------------------------
      inline = {
        adapter = get_adapter("inline"),
        keymaps = {
          accept_change = {
            modes = {
              n = "ga",
            },
            index = 1,
            callback = "keymaps.accept_change",
            description = "Accept change",
          },
          reject_change = {
            modes = {
              n = "gr",
            },
            index = 2,
            callback = "keymaps.reject_change",
            description = "Reject change",
          },
        },
        variables = {
          ["buffer"] = {
            callback = "strategies.inline.variables.buffer",
            description = "Share the current buffer with the LLM",
            opts = {
              contains_code = true,
            },
          },
          ["chat"] = {
            callback = "strategies.inline.variables.chat",
            description = "Share the currently open chat buffer with the LLM",
            opts = {
              contains_code = true,
            },
          },
          ["clipboard"] = {
            callback = "strategies.inline.variables.clipboard",
            description = "Share the contents of the clipboard with the LLM",
            opts = {
              contains_code = true,
            },
          },
        },
      },
      -- CMD STRATEGY -----------------------------------------------------------
      cmd = {
        adapter = get_adapter("cmd"),
      },
    },
    -- DISPLAY OPTIONS ----------------------------------------------------------
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        -- provider = providers.action_palette, -- telescope|mini_pick|snacks|default
      },
      chat = {
        icons = {
          pinned_buffer = " ",
          watched_buffer = "👀 ",
        },
        debug_window = {
          ---@return number|fun(): number
          width = vim.o.columns - 5,
          ---@return number|fun(): number
          height = vim.o.lines - 2,
        },
        window = {
          layout = "vertical", -- float|vertical|horizontal|buffer
          position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
          border = "single",
          height = 0.8,
          width = 0.45,
          relative = "editor",
          full_height = true,
        },
      },
    },
    tools = {
      ["cmd_runner_no_approval"] = {
        callback = "strategies.chat.agents.tools.cmd_runner",
        description = "Run shell commands initiated by the LLM",
        opts = {
          requires_approval = false,
        },
      },
    },
    prompt_library = {
      ["Generate a Commit Message"] = {
        prompts = {
          {
            role = "user",
            content = function()
              return generate_commit_message()
            end,
          },
        },
      },
      ["Git Commit"] = {
        strategy = "workflow",
        description = "Use a workflow to guide an LLM in making a git commit",
        opts = {
          index = 12,
          is_default = true,
          short_name = "gc",
        },
        prompts = {
          {
            {
              role = constants.USER_ROLE,
              content = function()
                return string.format(
                  [[Draft a commit message from git diff:
```diff
%s
```

Follow format:
%s

Present the draft commit message to the user for approval.
If I answer 'yes' or 'commit' or 'go ahead' or 'ok' or 'proceed' - it means you have approval to execute the commit.]],
                  vim.fn.system(
                    "git diff --no-ext-diff --staged"
                  ),
                  utils.get_os_env_or_nil(
                    "GIT_COMMIT_MESSAGE_FORMAT"
                  )
                    or [[- Subject: ~120 chars, no trailing period
- Body: Multi-line explanation of why changes were made (wrap ~120 chars)]]
                )
              end,
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = constants.USER_ROLE,
              content = 'Use @cmd_runner tool to execute `git commit -m "<subject>" -m "<body>"` after user confirms',
              opts = {
                auto_submit = true,
              },
            },
          },
        },
      },
    },
  },
  keys = {
    map_lazy_key("<leader>aia", function()
      local count = vim.v.count

      if count == 0 then
        utils.write_to_command_mode("CodeCompanion ")
        return
      end

      if count == 31 then
        if plugin_enabled.is_small_screen() then
          vim.cmd("tab split")
          vim.cmd("CodeCompanion /commit")
          vim.cmd("only")
          return
        end

        vim.cmd("CodeCompanion /commit")
        return
      end

      if count == 313 then
        vim.cmd("tab split")
        vim.cmd("CodeCompanion /commit")
        vim.cmd("only")
        return
      end

      if count == 33 then
        vim.cmd("CodeCompanion /explain")
        return
      end

      if count == 1 then
        vim.cmd("CodeCompanionChat")
        return
      end

      if count == 10 then
        vim.cmd("CodeCompanionChat Toggle")
        return
      end

      -- Add visually selected chat to the current chat buffer
      if count == 11 then
        vim.cmd("CodeCompanionChat Add")
        return
      end

      if count == 12 then
        utils.write_to_command_mode("CodeCompanionChat ")
        return
      end

      if count == 4 then
        vim.cmd("CodeCompanionCmd")
        return
      end

      if count == 5 then
        vim.cmd("CodeCompanionActions")
        return
      end
    end, {
      desc = "CodeCompanion 0/ 10/chat-toggle 11/chat: 3/actions 4/cmd",
    }, { "n", "v" }),
  },
}
