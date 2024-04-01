local M = {}

local has_coc = function()
  if vim.g.vscode then
    return false
  end

  local coc_env = os.getenv("COC")

  return coc_env ~= nil and coc_env ~= ""
end

function M.has_vscode()
  if vim.g.vscode then
    return true
  else
    return false
  end
end

function M.cmp()
  return (not M.has_vscode() and not has_coc())
end

function M.lsp()
  return (not M.has_vscode() and not has_coc())
end

function M.treesitter()
  return (not M.has_vscode() and not has_coc())
end

function M.telescope()
  return (not M.has_vscode() and not has_coc())
end

function M.dap()
  return not M.has_vscode()
end

return M
