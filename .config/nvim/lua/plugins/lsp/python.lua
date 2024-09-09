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
  },

  black = {},
  isort = {},
  flake8 = {},
  mypy = {},
  pylint = {},
  debugpy = {},
}
