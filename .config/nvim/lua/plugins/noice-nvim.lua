local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.is_small_screen() or (not plugin_enabled.noice()) then
  return {}
end

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    map_lazy_key("<leader><esc>", function()
      vim.cmd("Noice dismiss")
    end, {
      desc = "Noice dismiss",
    }),
    map_lazy_key("<leader>noi", function()
      local noice_options = {
        {
          description = "Show Noice menu                  1",
          action = function()
            vim.cmd("Noice")
          end,
          count = 1,
        },
        {
          description = "Dismiss notifications            2",
          action = function()
            vim.cmd("Noice dismiss")
          end,
          count = 2,
        },
        {
          description = "Search messages with fzf         5",
          action = function()
            vim.cmd("Noice fzf")
          end,
          count = 5,
        },
        {
          description = "Show all messages                55",
          action = function()
            vim.cmd("Noice all")
          end,
          count = 55,
        },
      }

      local fzf_lua = require("fzf-lua")
      local keymap_count = vim.v.count

      local items = {}
      for i, option in ipairs(noice_options) do
        -- Check if count matches any action
        if keymap_count == option.count then
          option.action()
          return
        end

        -- If no count match, show FZF menu
        table.insert(
          items,
          string.format("%d. %s", i, option.description)
        )
      end

      utils.set_fzf_lua_nvim_listen_address()

      fzf_lua.fzf_exec(items, {
        prompt = "Noice Options> ",
        actions = {
          ["default"] = function(selected)
            if not selected or #selected == 0 then
              return
            end

            local selection = selected[1]
            -- Extract option index from selection
            local index = tonumber(selection:match("^(%d+)%."))
            if index and noice_options[index] then
              noice_options[index].action()
            end
          end,
        },
        fzf_opts = {
          ["--no-multi"] = "",
          ["--header"] = "Select a noice option",
        },
      })
    end, {
      desc = "Noice 1/menu 2/dismiss 5/fzf 55/all",
    }),
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    })
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    "hrsh7th/nvim-cmp",
  },
}
