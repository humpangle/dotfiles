local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

local fzf_key_map_options = {
  {
    description = "START",
    action = function()
      vim.cmd("ClaudeCode")
    end,
  },
  {
    description = "Send/TreeAdd                                                                                     1",
    action = function()
      local ft = vim.bo.filetype
      if ft == "neo-tree" then
        vim.cmd("ClaudeCodeTreeAdd")
      else
        vim.cmd("ClaudeCodeSend")
      end
    end,
    count = 1,
  },
  {
    description = "Toggle                                                                                          11",
    action = function()
      vim.cmd("ClaudeCode")
      -- require("claudecode").start(false)
      -- require("claudecode").start()
    end,
    count = 11,
  },
  {
    description = "Focus                                                                                           12",
    action = function()
      vim.cmd("ClaudeCodeFocus")
    end,
    count = 12,
  },
  {
    description = "Resume                                                                                           3",
    action = function()
      vim.cmd("ClaudeCode --resume")
    end,
    count = 3,
  },
  {
    description = "Continue                                                                                        33",
    action = function()
      vim.cmd("ClaudeCode --continue")
    end,
    count = 33,
  },
  {
    description = "Models                                                                                           5",
    action = function()
      vim.cmd("ClaudeCodeSelectModel")
    end,
    count = 5,
  },
  {
    description = "Diff Accept                                                                                      6",
    action = function()
      vim.cmd("ClaudeCodeDiffAccept")
    end,
    count = 6,
  },
  {
    description = "Diff Deny                                                                                       61",
    action = function()
      vim.cmd("ClaudeCodeDiffDeny")
    end,
    count = 61,
  },
  {
    description = "Start Attach Integrate",
    action = function()
      vim.cmd("ClaudeCodeStart")
    end,
  },
  {
    description = "Status",
    action = function()
      vim.cmd("ClaudeCodeStatus")
    end,
  },
}

return {
  "coder/claudecode.nvim",
  dir = vim.fn.stdpath("data") .. "/lazy-ebnis-worktree/claudecode.nvim/0",
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeStart", -- Start Claude Code integration
    "ClaudeCodeStop", -- Stop Claude Code integration
    "ClaudeCodeStatus",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    map_lazy_key("<leader>cc", function()
      -- local cc = require("claudecode")
      -- if not cc.state.server then
      --   cc.start(false)
      --   return
      -- end

      utils.create_fzf_key_maps(fzf_key_map_options, {
        prompt = "Calude Code",
        header = "Select a claude code option",
      })
    end, {
      desc = "Claude code 1/Toggle 11/Focus 3/Resume 33/Continue",
    }, {
      "n",
      "x",
      "v",
    }),
  },
  init = function()
    utils.map_key({ "x" }, "<leader>cc", function()
      -- local cc = require("claudecode")
      -- if not cc.state.server then
      --   cc.start(false)
      --   return
      -- end

      utils.create_fzf_key_maps(fzf_key_map_options, {
        prompt = "Calude Code",
        header = "Select a claude code option",
      })
    end)
  end,
  -- config = true,
  config = function()
    local cc = require("claudecode")

    local stu = {}
    -- stu.auto_start = false
    stu.terminal = {}
    stu.terminal.provider = "external"
    stu.terminal.provider_opts = {}
    stu.terminal.provider_opts.external_terminal_cmd1 =
      "alacritty --working-directory %s -e %s"
    stu.terminal.provider_opts.external_terminal_cmd = function(cmd, envs)
      envs["DO_ACTIVATE_PYTHON_VIRTUAL_ENV"] = 1
      local env_exports = ""

      for key, value in pairs(envs) do
        env_exports = env_exports
          .. ("export %s=%s; "):format(key, value)
      end

      -- "tmux kill-pane -t al:4.1 2>/dev/null || true; " ..

      -- Kill existing pane and create new one with fresh environment
      local create_tmux_pane_cmd = ("tmux split-window -t al:4 -c %s 'bash -ic \"%s _pv -d && _pv && %s\"'"):format(
        vim.fn.shellescape(vim.fn.getcwd()),
        env_exports,
        cmd
      )

      vim.print(create_tmux_pane_cmd)
      -- return { "bash", "-c", create_tmux_pane_cmd }

      return ("alacritty --working-directory %s -e %s"):format(
        vim.fn.getcwd(),
        cmd
      )
    end

    cc.setup(stu)
  end,
}
