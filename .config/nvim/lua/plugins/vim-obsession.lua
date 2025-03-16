local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")
local map_key = utils.map_key

if plugin_enabled.has_vscode() then
  return {}
end

-- Manage Vim Sessions Manually

local file_session_vim_exists = function()
  return vim.fn.glob("session.vim") ~= ""
end

local session_name = utils.get_session_file()

return {
  "tpope/vim-obsession",
  init = function()
    map_key("n", "<leader>ob", function()
      local count = vim.v.count

      if count == 0 then
        if file_session_vim_exists() then
          utils.write_to_command_mode("so " .. session_name .. ".vim")
        else
          utils.write_to_command_mode(
            "Obsession " .. session_name .. ".vim"
          )
        end
      elseif count == 1 then
        utils.write_to_command_mode("so " .. session_name)
      elseif count == 2 then
        utils.write_to_command_mode(
          "Obsession " .. session_name .. ".vim"
        )
      else
        utils.write_to_command_mode("Obsession " .. session_name)
      end
    end)
  end,
}
