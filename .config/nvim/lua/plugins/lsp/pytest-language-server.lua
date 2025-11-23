vim = vim

-- https://github.com/bellini666/pytest-language-server
-- cargo install pytest-language-server
vim.lsp.config.pytest_lsp = {
  cmd = { "pytest-language-server" },
  filetypes = { "python" },
  root_markers = { -- copied from pyright
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
}
vim.lsp.enable("pytest_lsp")
