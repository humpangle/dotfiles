-- Autocompletion
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
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    luasnip.config.setup({})

    local check_backspace = function()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    cmp.setup({
      -- REQUIRED - you must specify a snippet engine
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert({
        -- Accept currently selected item.
        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ["<C-Space>"] = cmp.mapping.complete({}),

        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Use tab to navigate the completion plumvisible
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Use shift-tab to navigate backwards the completion plumvisible
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        {
          name = "buffer",
          -- See also
          -- https://github.com/hrsh7th/nvim-cmp/issues/1522#issuecomment-1986818011
          -- on how to disable CMP
          option = {
            -- https://github.com/hrsh7th/cmp-buffer#get_bufnrs-type-fun-number
            -- https://github.com/hrsh7th/cmp-buffer#visible-buffers
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
        },
        { name = "path" },
      },
    })
  end,
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if
          vim.fn.has("win32") == 1
          or vim.fn.executable("make") == 0
        then
          return
        end
        return "make install_jsregexp"
      end)(),
      config = function()
        -- load snippets from path/of/your/nvim/config/my-cool-snippets
        -- lazy_load seems to be problematic (sometimes shows and then does not show other times)
        -- but load affects performance (so...)
        require("luasnip.loaders.from_vscode").load({
          paths = { "./snippets" }, -- relative to the directory of $MYVIMRC
        })
      end,
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
    },

    -- COMPLETION SOURCES
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    --
    -- snippet completions
    "saadparwaiz1/cmp_luasnip",
    -- buffer completions
    "hrsh7th/cmp-buffer",
    -- path completions
    "hrsh7th/cmp-path",
    -- lSP completions
    "hrsh7th/cmp-nvim-lsp",
    -- / COMPLETION SOURCES
  },
}
