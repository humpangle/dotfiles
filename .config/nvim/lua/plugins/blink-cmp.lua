-- Autocompletion with blink.cmp
local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.install_cmp() then
  return {}
end

local is_buffer_source = function(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  if filename:match("Neotest Output Panel") then
    return false
  end

  if filename:sub(-4) == ".log" then
    return false
  end

  return true
end

return {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine
    require("plugins.luasnip"),
    "rafamadriz/friendly-snippets",
  },
  opts = {
    -- 'default' for mappings preset only when no mapping is set
    keymap = {
      preset = "none",
      -- Accept currently selected item
      ["<CR>"] = { "accept", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      -- Manually trigger completion
      ["<C-Space>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
      },
      -- Scroll documentation
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      -- Arrow keys for navigation
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      -- Navigate completion menu
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_next()
          end

          -- Handle LuaSnip expansion/jumping
          local luasnip = require("luasnip")
          if luasnip.expandable() then
            return luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            return luasnip.expand_or_jump()
          end

          return cmp.fallback()
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_prev()
          end

          -- Handle LuaSnip backward jumping
          local luasnip = require("luasnip")
          if luasnip.jumpable(-1) then
            return luasnip.jump(-1)
          end

          return cmp.fallback()
        end,
        "fallback",
      },
      -- LuaSnip-specific navigation
      ["<C-l>"] = {
        function()
          local luasnip = require("luasnip")
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end,
      },
      ["<C-h>"] = {
        function()
          local luasnip = require("luasnip")
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end,
      },
    },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        -- Auto show the completion menu
        auto_show = true,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
    },
    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = {
        "lsp",
        "snippets",
        "path",
        "buffer",
      },
      providers = {
        buffer = {
          -- Custom buffer filtering
          opts = {
            -- Only complete from visible buffers
            get_bufnrs = function()
              local bufnrs = {}

              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf_no = vim.api.nvim_win_get_buf(win)

                if is_buffer_source(buf_no) then
                  table.insert(bufnrs, buf_no)
                end
              end

              return bufnrs
            end,
          },
          min_keyword_length = 3,
        },
      },
    },
    snippets = {
      -- Use the luasnip preset
      preset = "luasnip",
    },
    signature = {
      enabled = true,
    },
    -- Cmdline completion configuration
    cmdline = {
      enabled = true,
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" then
          return { "cmdline", "path" }
        end
        return {}
      end,
    },
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
