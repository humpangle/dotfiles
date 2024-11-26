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

  return utils.get_os_env_or_nil("NVIM_ENABLE_AI_PLUGINS") ~= "0"
end

function M.has_official_copilot()
  if M.has_vscode() then
    return false
  end

  if M.has_termux() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_OFFICIAL_COPILOT_PLUGIN") ~= "0"
end

function M.has_unofficial_copilot()
  return not M.has_official_copilot
    and utils.get_os_env_or_nil("NVIM_ENABLE_COMMUNITY_COPILOT_PLUGIN")
      ~= "0"
end

function M.has_copilot()
  return M.has_official_copilot or M.has_unofficial_copilot
end

function M.has_gpt()
  if M.has_vscode() then
    return false
  end

  if M.has_termux() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_GPT_PLUGIN") ~= "0"
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

function M.fzf()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.floaterm()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.notest()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.isort()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_PYTHON_ISORT") ~= "0"
end

function M.isort_auto()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ISORT_PLUGIN_AUTO") ~= "0"
end

function M.elixir_lsp()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_ELIXIR_PLUGINS") ~= "0"
end

function M.terraform_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_TERRAFORM_LSP") ~= "0"
end

function M.stylua_lsp_formatter()
  return utils.get_os_env_or_nil("NVIM_ENABLE_STYLUA_LSP_FORMATTER") ~= "0"
end

function M.tailwindcss_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_TAILWINDCSS_LSP") ~= "0"
end

function M.emmet_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_EMMET_LSP") ~= "0"
end

function M.typescript_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_TYPESCRIPT_LSP") ~= "0"
end

function M.docker_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_DOCKER_LSP") ~= "0"
end

function M.yaml_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_YAML_LSP") ~= "0"
end

function M.netrw()
  return utils.get_os_env_or_nil("NVIM_ENABLE_NETRW") ~= "0"
end

return M
