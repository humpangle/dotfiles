-- Snippet Engine & its associated nvim-cmp source

return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
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
}
