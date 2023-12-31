local keyset = vim.keymap.set

return {
  "tpope/vim-surround",
  "nelstrom/vim-visual-star-search",

  -- Easy motion alternative - jump to any where in the buffer by typing 2 chars
  {
    "ggandor/leap.nvim",
    config = function()
      -- https://github.com/kohane27/nvim-config/blob/main/lua/plugins/leap.lua
      local status_ok, leap = pcall(require, "leap")

      if status_ok then
        leap.set_default_keymaps()

        keyset(
          { "n", "x", "o" },
          "<leader>j",
          "<Plug>(leap-forward-to)"
        )

        keyset(
          { "n", "x", "o" },
          "<leader>J",
          "<Plug>(leap-backward-to)"
        )

        -- mark cursor location before jumping
        vim.api.nvim_create_autocmd("User", {
          pattern = "LeapEnter",
          callback = function()
            vim.cmd("normal m'")
          end,
        })
      end
    end,
  }
}
