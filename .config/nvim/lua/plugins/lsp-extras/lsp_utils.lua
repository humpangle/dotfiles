local M = {}

-- Inspired by:
--    https://github.com/neovim/nvim-lspconfig/issues/500
function M.get_python_path(workspace)
  -- `workspace` variable is available from lsp. We use PWD for any other context.
  workspace = workspace or vim.fn.getcwd()

  -- I have a global `PYTHON_BIN` in .bashrc and project specific.
  local python_bin = os.getenv("PYTHON_BIN")

  if python_bin ~= nil and python_bin ~= "" then
    return python_bin
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local poetry_lock_matched =
    vim.fn.glob(vim.fs.joinpath(workspace, "poetry.lock"))

  if poetry_lock_matched ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))

    return vim.fs.joinpath(venv, "bin", "python")
  end

  -- Use activated virtualenv (if it exists).
  if vim.env.VIRTUAL_ENV then
    local python_from_virtualenv =
      vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")

    return python_from_virtualenv
  end

  -- Find and use virtualenv in workspace directory (if one exists).
  for _, pattern in ipairs({ "*", ".*" }) do
    local venv_matched =
      vim.fn.glob(vim.fs.joinpath(workspace, pattern, "pyvenv.cfg"))

    if venv_matched ~= "" then
      return vim.fs.joinpath(
        vim.fs.dirname(venv_matched),
        "bin",
        "python"
      )
    end
  end

  python_bin = os.getenv("GLOBAL_PYTHON_BIN")

  if python_bin ~= nil and python_bin ~= "" then
    return python_bin
  end

  -- Use system python binary if all the above do not work.
  return (vim.fn.exepath("python3") or vim.fn.exepath("python") or "python")
end

return M
