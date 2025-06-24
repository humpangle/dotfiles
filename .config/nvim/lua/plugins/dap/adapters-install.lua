local mason_dap = require("mason-nvim-dap")

mason_dap.setup({
  -- Debugger binaries you want mason to install for you.
  -- Check for debug adapters - you want to use the keys:
  --    https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
  ensure_installed = {
    "elixir",
    "python",
    "js",
    -- 'chrome',
    "bash",
    "php",
  },

  automatic_installation = true,
  handlers = nil,
})
