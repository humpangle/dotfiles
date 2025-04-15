local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")
local map_key = utils.map_key

if plugin_enabled.has_vscode() then
  return {}
end

-- Manage Vim Sessions Manually

local file_session_vim_exists = function()
  return vim.fn.glob("session*.vim") ~= ""
end

local session_name = utils.get_session_file()

local get_session_path_relative = function()
  return vim.fn.fnamemodify(vim.v.this_session, ":.")
end

local start_session_file = function()
  utils.write_to_command_mode(
    "Obsession " .. session_name .. "-.vim" .. "<left><left><left><left>"
  )
end

return {
  "tpope/vim-obsession",
  init = function()
    vim.api.nvim_create_user_command(
      "SessionEbnis",
      get_session_path_relative,
      {}
    )

    map_key("n", "<leader>ob", function()
      if not file_session_vim_exists() then
        start_session_file()
        return
      end

      local count = vim.v.count

      if count == 0 then
        utils.write_to_command_mode("so " .. session_name)
      elseif count == 1 then
        start_session_file()
        return
      elseif count == 5 then
        vim.cmd.echo('"Current session: ' .. get_session_path_relative() .. '"')
        return
      elseif count == 55 then
        local reg = "+"
        local session_path_relative = get_session_path_relative()
        vim.fn.setreg(reg, session_path_relative)
        utils.clip_cmd_exec(session_path_relative)
        vim.notify("Current session copied to + : " .. session_path_relative)
      end
    end, {
      desc = "Obsession */startFile 0/continue 1/startFile 5/list 55/copy",
    })
  end,
}
