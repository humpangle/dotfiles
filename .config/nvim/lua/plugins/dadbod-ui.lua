local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.vim_dad_bod() then
  return {}
end

-- Database management
-- https://alpha2phi.medium.com/vim-neovim-managing-databases-d253faf4a0cd

local utils = require("utils")
local map_key = utils.map_key

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
    -- postgres — postgresql://user1:userpwd@localhost:5432/testdb
    -- mysql — mysql://user1:userpwd@127.0.0.1:3306/testdb
    -- sqlite - sqlite:path-to-sqlite-database

    -- :w = execute query in current DBUI buffer

    -- Typical entry in ~/.local/share/db_ui/connections.json:
    -- [
    --   {
    --     "url": "postgresql://username:password@127.0.0.1:5432/db_name",
    --     "name": "folder_name"
    --   },
    --   {
    --     "url": "mysql://username:password@127.0.0.1:5432/db_name",
    --     "name": "folder_name"
    --   }
    -- ]
    --
    -- Create ~/.local/share/db_ui/folder_name/*.sql and write your sql queries.

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
  end,
}
