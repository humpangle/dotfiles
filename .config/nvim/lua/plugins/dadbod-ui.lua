local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.vim_dad_bod() then
  return {}
end

local utils = require("utils")

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
  keys = {
    utils.map_lazy_key("<leader>dbu", function()
      utils.create_fzf_key_maps(require("plugins.dadbod-ui-options"), {
        prompt = "DBUI Options>  ",
        header = "Select a DBUI option",
      })
    end, {
      noremap = true,
      desc = "DBUI options (fzf)",
    }, { "n", "x" }),
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
