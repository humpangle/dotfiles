local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")

if plugin_enabled.has_vscode() then
  return {}
end

local map_key = utils.map_key
local obsession_utils = require("plugins.vim-obsession.obsession-utils")

local file_session_vim_exists = function()
  return vim.fn.glob("session*.vim") ~= ""
end

local session_name = obsession_utils.get_session_file()

local start_session_file = function()
  utils.write_to_command_mode(
    "Obsession " .. session_name .. "-.vim" .. "<left><left><left><left>"
  )
end

local pick_session_with_fzf = function()
  local fzf_lua = require("fzf-lua")

  -- Get all session files matching the pattern
  local pattern = session_name .. "*.vim"
  local session_files = vim.fn.glob(pattern, false, true)

  if #session_files == 0 then
    vim.notify(
      "No session files found matching: " .. pattern,
      vim.log.levels.WARN
    )
    return
  end

  -- Sort files by modification time (newest first)
  table.sort(session_files, function(a, b)
    local a_time = vim.fn.getftime(a)
    local b_time = vim.fn.getftime(b)
    return a_time > b_time
  end)

  utils.set_fzf_lua_nvim_listen_address()

  fzf_lua.fzf_exec(session_files, {
    prompt = "Select session to load> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local session_file = selected[1]

        vim.defer_fn(function()
          vim.cmd("source " .. session_file)
          vim.notify(
            "Loaded session: " .. session_file,
            vim.log.levels.INFO
          )
        end, 5)
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--header"] = "Select a session file to load",
    },
    keymap = {
      fzf = {
        ["tab"] = "down",
        ["shift-tab"] = "up",
      },
    },
  })
end

return {
  "tpope/vim-obsession",
  init = function()
    vim.api.nvim_create_user_command(
      "SessionEbnis",
      obsession_utils.get_session_path_relative,
      {}
    )

    map_key("n", "<leader>ob", function()
      if not file_session_vim_exists() then
        start_session_file()
        return
      end

      local count = vim.v.count

      if count == 0 then
        pick_session_with_fzf()
      elseif count == 1 then
        start_session_file()
        return
      elseif count == 5 then
        vim.notify(
          "CURRENT SESSION: " .. utils.get_session_path_relative()
        )
        return
      elseif count == 55 then
        local reg = "+"
        local session_path_relative = utils.get_session_path_relative()
        vim.fn.setreg(reg, session_path_relative)
        utils.clip_cmd_exec(session_path_relative)
        vim.notify(
          "CURRENT SESSION COPIED TO +: " .. session_path_relative
        )
      end
    end, {
      desc = "Obsession */startFile 0/continue 1/startFile 5/list 55/copy",
    })
  end,
}
