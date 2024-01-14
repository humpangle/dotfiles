local keyset = vim.keymap.set

return {
  -- Surround text with quotes, parenthesis, brackets, and more.
  "tpope/vim-surround",
  -- A number of useful motions for the quickfix list, pasting and more.
  "tpope/vim-unimpaired",
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
          "s",
          "<Plug>(leap-forward-to)"
        )

        keyset(
          { "n", "x", "o" },
          "S",
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
