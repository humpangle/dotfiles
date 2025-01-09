local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")
local map_key = utils.map_key

if plugin_enabled.has_vscode() then
  return {}
end

-- Manage Vim Sessions Manually
return {
  "tpope/vim-obsession",
  init = function()
    map_key("n", "<leader>ob", function()
      local count = vim.v.count

      if count == 0 then
        utils.write_to_command_mode("so session.vim")
      elseif count == 1 then
        utils.write_to_command_mode("so session")
      elseif count == 2 then
        utils.write_to_command_mode("Obsession session.vim")
      else
        utils.write_to_command_mode(
          "Obsession session.vim<left><left><left><left>"
        )
      end
    end)
  end,
}
