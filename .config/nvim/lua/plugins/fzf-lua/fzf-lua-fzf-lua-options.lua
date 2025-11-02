local utils = require("utils")

return {
  {
    description = "Git branches list branch",
    action = function()
      utils.set_fzf_lua_nvim_listen_address()
      require("fzf-lua").git_branches()
    end,
  },
}
