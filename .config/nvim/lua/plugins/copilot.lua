local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")
local map_key = utils.map_key

return {
  {
    "github/copilot.vim",
    cond = true,
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    keys = {
      {
        "<M-cr>",
        "<cmd>Copilot panel<cr>",
        mode = { "n", "i" },
        desc = "Copilot panel",
      },
      {
        "<M-e>",
        function()
          vim.cmd("Copilot enable")
          vim.cmd.echo('"Copilot enabled"')
        end,
        mode = { "n", "i" },
        desc = "Copilot enable",
      },
    },
    init = function()
      map_key({ "n", "i" }, "<M-s>", "<cmd>Copilot status<cr>", {
        desc = "Copilot status",
      })

      map_key({ "n", "i" }, "<M-d>", function()
        vim.cmd("Copilot disable")
        vim.cmd.echo('"Copilot disabled"')
      end, {
        desc = "Copilot disable",
      })
    end,
    config = function()
      vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.g.copilot_no_tab_map = true
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cond = false,
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    init = function()
      map_key({ "n", "i" }, "<M-cr>", function()
        vim.cmd("Copilot panel")
      end, { noremap = true })
    end,
    config = function()
      require("copilot").setup({
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
      })
    end,
  },
}
