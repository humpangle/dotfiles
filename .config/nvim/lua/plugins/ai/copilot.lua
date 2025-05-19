local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.has_community_copilot() then
  return {}
end

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

return {
  "zbirenbaum/copilot.lua",
  cmd = {
    "Copilot",
  },
  event = "InsertEnter",
  keys = {
    map_lazy_key("<M-cr>", function()
      vim.cmd("Copilot panel")
    end, {
      noremap = true,
      desc = "Copilot/panel",
    }, { "n", "i" }),
  },
  opts = {
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true, -- false,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = "<M-Right>", -- false,
        accept_line = "<C-S-Right>", -- false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
    server_opts_overrides = {},
  },
}
