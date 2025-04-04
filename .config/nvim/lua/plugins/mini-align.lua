return {
  "echasnovski/mini.align",
  version = "*",
  config = function()
    require("mini.align").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        start = "<leader>al0",
        start_with_preview = "<leader>al1",
      },
    })
    -- Usage:
    -- Start with `<leader>alip`
  end,
}
