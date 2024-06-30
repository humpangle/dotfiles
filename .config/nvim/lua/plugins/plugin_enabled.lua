local M = {}

local has_coc = function()
  if vim.g.vscode or M.has_termux() then
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

function M.coc()
  return has_coc()
end

function M.has_termux()
  return os.getenv("HOME") == "/data/data/com.termux/files/home"
end

function M.enable_vim_one_color_scheme()
  if M.has_termux() then
    return false
  end

  return not M.has_vscode()
end

function M.enable_solarized_color_scheme()
  return M.enable_vim_one_color_scheme()
end

return M
