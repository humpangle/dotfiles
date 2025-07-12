local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.vim_dad_bod() then
  return {}
end

-- Database management
-- https://alpha2phi.medium.com/vim-neovim-managing-databases-d253faf4a0cd

local utils = require("utils")
local s_utils = require("settings-utils")
local map_key = utils.map_key

local match_vim_dadbod_ui_temp_query_file = function(str)
  local pattern = "^/tmp/nvim%..+/%d+%.dbout$"
  return string.match(str, pattern) ~= nil
end

--[[
  postgres — postgresql://user1:userpwd@localhost:5432/testdb
  mysql — mysql://user1:userpwd@127.0.0.1:3306/testdb
  sqlite - sqlite:path-to-sqlite-database

  :w = execute query in current DBUI buffer

  Typical entry in ~/.local/share/db_ui/connections.json:
  [
    {
      "url": "postgresql://username:password@127.0.0.1:5432/db_name",
      "name": "folder_name"
    },
    {
      "url": "mysql://username:password@127.0.0.1:5432/db_name",
      "name": "folder_name"
    }
  ]

  Create ~/.local/share/db_ui/folder_name/*.sql and write your sql queries.
--]]

return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    {
      "tpope/vim-dadbod",
      lazy = true,
    },
    -- Optional
    {
      "kristijanhusak/vim-dadbod-completion",
      ft = { "sql", "mysql", "plsql" },
      lazy = true,
    },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1

    map_key(
      "n",
      "<leader>dbi",
      ":tab new<CR>:DBUI<CR><C-w>o<bar><C-w>v<bar>:e ~/.local/share/db_ui/connections.json<CR>",
      {
        noremap = true,
        desc = "Initiialize DBUI",
      }
    )

    map_key({ "n", "x" }, "<leader>dbe", function()
      local count = vim.v.count

      if count ~= 0 then
        vim.cmd({ cmd = "wa", bang = true })
        require("buffer-management").delete_all_buffers("dbui")
        return
      end

      if vim.fn.mode() == "n" then
        vim.cmd.normal({ "vip" })
      end

      local keys = vim.api.nvim_replace_termcodes(
        "<Plug>(DBUI_ExecuteQuery)",
        true,
        true,
        true
      )
      vim.api.nvim_feedkeys(keys, "x", false)
    end, {
      noremap = true,
      desc = "0/exec 1/write 2/delete-buffers",
    })

    map_key("n", "<leader>dbf", function()
      vim.cmd("DBUIFindBuffer")
      vim.bo.filetype = "sql"
    end, {
      noremap = true,
      desc = "DBUIFindBuffer",
    })

    map_key("n", "<leader>dbr", ":DBUIRenameBuffer<CR>", {
      noremap = true,
      desc = "DBUIRenameBuffer",
    })

    map_key("n", "<leader>dbl", ":DBUILastQueryInfo<CR>", {
      noremap = true,
      desc = "DBUILastQueryInfo",
    })

    map_key("n", "<leader>dbw", function()
      local count = vim.v.count

      if count == 1 then
        vim.cmd.normal({ "vip" })

        utils.write_to_command_mode("'<,'>Neoformat! sql<CR>")
        return
      end

      if count == 2 then
        vim.cmd({ cmd = "wa", bang = true })
        require("buffer-management").delete_all_buffers("dbui")
        return
      end

      local buffer_name = vim.fn.expand("%:p")
      if not match_vim_dadbod_ui_temp_query_file(buffer_name) then
        return
      end

      local filename = utils.create_slime_dir()
        .. "/q-"
        .. os.date("%FT%H-%M-%S")
        .. ".md"

      pcall(function()
        vim.cmd("saveas! " .. vim.fn.fnameescape(filename))
      end)

      -- We need to split away otherwise the DbUiDelete below will close the buffer.
      vim.cmd("tab split")

      vim.bo.filetype = "markdown"
      -- The file will be of type 'dbui'. The delete action below will delete all files of this type.
      vim.bo.buftype = ""

      os.execute("rm -rf " .. vim.fn.shellescape(buffer_name))
      vim.cmd("bdelete! " .. buffer_name)
      vim.cmd({ cmd = "wa", bang = true })
      require("buffer-management").delete_all_buffers("dbui")

      -- dbui file is always readonly -  make it modifiable
      vim.bo.modifiable = true
      vim.cmd("e %")

      vim.cmd.normal("gT")
    end, {
      noremap = true,
      desc = "DBUI 0/save result buffer 1/format 2/DbUiDelete",
    })

    map_key("n", "<leader>dbH", function()
      local help_string = "* Help for Vim DadBod UI *"
        .. "\\n\\n"
        .. "** Data Source Name (dns) syntax **"
        .. "\\n"
        .. "postgresql://user1:userpwd@localhost:5432/testdb"
        .. "\\n"
        .. "mysql://user1:userpwd@127.0.0.1:3306/testdb"
        .. "\\n"
        .. "sqlite:path-to-sqlite-database"
        .. "\\n\\n"
        .. "** Settings file **"
        .. "\\n"
        .. "~/.local/share/db_ui/connections.json"
        .. "\\n"
        .. "```json"
        .. "\\n"
        .. "["
        .. "\\n"
        .. "  {"
        .. "\\n"
        .. '    \\"url\\": \\"postgresql://username:password@127.0.0.1:5432/db_name\\",'
        .. "\\n"
        .. '    \\"name\\": \\"folder_name\\"'
        .. "\\n"
        .. "  }"
        .. "\\n"
        .. "]"
        .. "\\n"
        .. "```"
        .. "\\n\\n"
        .. "** folder_name is the `name` key in the Settings object **"
        .. "\\n\\n"
        .. "~/.local/share/db_ui/folder_name/*.sql"
        .. "\\n"
        .. "~/.local/share/db_ui"

      -- vim.cmd('echo "' .. help_string .. '"')
      s_utils.RedirMessages('echo "' .. help_string .. '"', "vnew")
    end, {
      noremap = true,
      desc = "DBUI help information",
    })
  end,
}
