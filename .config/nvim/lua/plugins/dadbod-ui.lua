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

    map_key("n", "<leader>dbf", ":DBUIFindBuffer<CR>", {
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
      local buffer_name = vim.fn.expand("%:p")
      if not match_vim_dadbod_ui_temp_query_file(buffer_name) then
        return
      end

      vim.bo.modifiable = true
      vim.bo.filetype = "markdown"

      local slime_dir = "~/.local/share/db_ui"
      vim.fn.mkdir(slime_dir, "p")

      local timestamp = os.date("%s")
      local new_name = slime_dir
        .. "/zz_query-result--"
        .. timestamp
        .. ".md"

      pcall(function()
        vim.cmd("saveas " .. vim.fn.fnameescape(new_name))
      end)

      -- vim.cmd("tab split")
      vim.cmd("e %")

      vim.cmd("bdelete! " .. buffer_name)
    end, {
      noremap = true,
      desc = "DBUI xxxx",
    })

    map_key("n", "<leader>dbW", function()
      vim.cmd("w!")
      vim.cmd("DbUiDelete")
    end, {
      noremap = true,
      desc = "DBUI Write And Delete",
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
