-- basedpyright = {

return {
  pyright = {
    on_init = function(client)
      local workspace = client.config.root_dir
      local python_bin =
        require("plugins/lsp_utils").get_python_path(workspace)

      client.config.settings.python.pythonPath = python_bin
      vim.g.python_host_prog = python_bin
      vim.g.python3_host_prog = python_bin
    end,

    -- settings = {
    --   pyright = {
    --     analysis = {
    --       typeCheckingMode = "off", -- off, basic, standard, strict, all
    --     },
    --   },
    -- python = {
    --   analysis = {
    --     diagnosticSeverityOverrides = {
    --       reportMissingImports = "none",
    --     },
    --   },
    -- },
    -- },
  },

  black = {},
  isort = {},
  flake8 = {},
  mypy = {},
  -- pylint = {},
  debugpy = {},
}
