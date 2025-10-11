local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

return {
  "allaman/emoji.nvim",
  version = "1.0.0",
  -- ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
  },
  config = function()
    local st = {}
    -- Enable nvim-cmp integration for emoji completion
    st.enable_cmp_integration = true
    local em = require("emoji")
    em.setup(st)
  end,
  keys = {
    map_lazy_key("<leader>ei", function()
      local em = require("emoji")
      local count = vim.v.count1

      if count < 2 then
        em.insert()
        return
      end

      if count == 11 then
        em.insert_by_group()
        return
      end

      if count == 2 then
        em.insert_kaomoji()
        return
      end

      if count == 22 then
        em.insert_kaomoji_by_group()
        return
      end
    end, {
      desc = "Insert emoji 1/ 11/emojiGrp 2/kaomoji 22/kaomoji_grp",
    }, { "n" }),
  },
}
