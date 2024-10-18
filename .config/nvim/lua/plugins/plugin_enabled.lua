local utils = require("utils")

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
  return vim.fn.isdirectory("/data/data/com.termux/files/home") ~= 0
end

function M.is_small_screen()
  local env = os.getenv("___EBNIS_SMALL_SCREEN___")

  return env ~= nil and env ~= ""
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

function M.ai_enabled()
  if M.has_vscode() then
    return false
  end

  if M.has_termux() then
    return false
  end

  return utils.os_env_not_empty("NVIM_ENABLE_AI_PLUGINS")
end

function M.has_official_copilot()
  return utils.os_env_not_empty("NVIM_ENABLE_OFFICIAL_COPILOT_PLUGIN")
end

function M.has_unofficial_copilot()
  return not M.has_official_copilot
    and utils.os_env_not_empty("NVIM_ENABLE_COMMUNITY_COPILOT_PLUGIN")
end

function M.has_copilot()
  return M.has_official_copilot or M.has_unofficial_copilot
end

function M.has_gpt()
  return utils.os_env_not_empty("NVIM_ENABLE_GPT_PLUGIN")
end

function M.has_lua_json5()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.has_big_file_nvim()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.render_markdown_nvim()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.nvim_autopairs()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.colorizer()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.vim_dad_bod()
  if M.has_vscode() then
    return false
  end

  return true
end

return M
