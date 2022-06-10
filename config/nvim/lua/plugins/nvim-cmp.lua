local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local kind_icons_map = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),

    ["<UP>"] = cmp.mapping.select_prev_item(),

    ["<C-j>"] = cmp.mapping.select_next_item(),

    ["<DOWN>"] = cmp.mapping.select_next_item(),

    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),

    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),

    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),

    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-y>"] = cmp.config.disable,

    ["<C-e>"] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),

    -- Accept currently selected item. Set `selec
    ["<CR>"] = cmp.mapping.confirm({select = true}),

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
    end, {"i", "s"}),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {"i", "s"}),
  },

  sources = {
    {name = "nvim_lsp"},

    {name = "nvim_lua"},

    {name = "luasnip"},

    {name = "buffer"},

    {name = "path"},

    {
      name = "look",
      keyword_length = 2,
      option = {convert_case = true, loud = true},
    },
  },

  formatting = {
    fields = {"abbr", "kind", "menu"},

    format = function(entry, vim_item)
      -- Kind icons only
      -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

      -- Kind icons + label
      vim_item.kind = string.format("%s %s", kind_icons_map[vim_item.kind],
                                    vim_item.kind)

      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA_LSP]",
        luasnip = "[Snippet]",
        look = "[DICT]",
        buffer = "[BUFFER]",
        path = "[Path]",
        ["vim-dadbod-completion"] = "[DB]",
      })[entry.source.name]

      return vim_item
    end,
  },

  window = {
    documentation = {
      border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
    },
  },

  view = {ghost_text = false, entries = "native"},
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--     sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}}),
-- })
