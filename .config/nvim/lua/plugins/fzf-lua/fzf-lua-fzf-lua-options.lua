local fzf_lua = require("fzf-lua")

return {
  {
    description = "Git branches list branch",
    action = function()
      -- utils.set_fzf_lua_nvim_listen_address()
      fzf_lua.git_branches()
    end,
  },
  {
    description = "List registers neovim registers list",
    action = function()
      -- utils.set_fzf_lua_nvim_listen_address()
      fzf_lua.registers()
    end,
  },
  {
    description = "Git list Git Worktrees list",
    action = function()
      -- utils.set_fzf_lua_nvim_listen_address()
      fzf_lua.git_worktrees() -- use ctr-e to add because ctr-a is used by tmux
    end,
  },
}
