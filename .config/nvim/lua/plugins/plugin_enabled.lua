local utils = require("utils")

local M = {}

function M.has_vscode()
  if vim.g.vscode then
    return true
  else
    return false
  end
end

function M.install_cmp()
  if M.has_vscode() then
    return false
  end

  return true
end

function M.lsp()
  return (not M.has_vscode())
end

function M.treesitter()
  return (not M.has_vscode())
end

function M.telescope()
  return (not M.has_vscode())
end

function M.dap()
  return not M.has_vscode()
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
  if M.has_vscode() or M.has_termux() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_AI_PLUGINS") == "1"
end

function M.has_official_copilot()
  if M.has_vscode() or M.has_termux() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_OFFICIAL_COPILOT_PLUGIN") == "1"
end

function M.has_unofficial_copilot()
  return not M.has_official_copilot
    and utils.get_os_env_or_nil("NVIM_ENABLE_COMMUNITY_COPILOT_PLUGIN")
      == "1"
end

function M.has_copilot()
  return M.has_official_copilot or M.has_unofficial_copilot
end

function M.has_gpt()
  if M.has_vscode() or M.has_termux() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_GPT_PLUGIN") == "1"
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

function M.fzf_lua_install()
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

  return utils.get_os_env_or_nil("NVIM_ENABLE_PYTHON_ISORT") == "1"
end

function M.bash_lsp()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_BASH_LSP") == "1"
end

function M.json_ls()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_JSON_LSP") == "1"
end

function M.sql_ls()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_SQL_LSP") == "1"
end

function M.python()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_PYTHON_PLUGINS") == "1"
end

function M.isort_auto()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ISORT_PLUGIN_AUTO") == "1"
end

function M.terraform_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_TERRAFORM_LSP") == "1"
end

function M.stylua_lsp_formatter()
  return utils.get_os_env_or_nil("NVIM_ENABLE_STYLUA_LSP_FORMATTER") == "1"
end

function M.tailwindcss_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_TAILWINDCSS_LSP") == "1"
end

function M.emmet_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_EMMET_LSP") == "1"
end

function M.typescript_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_TYPESCRIPT_LSP") == "1"
end

function M.docker_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_DOCKER_LSP") == "1"
end

function M.yaml_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_YAML_LSP") == "1"
end

function M.netrw()
  return utils.get_os_env_or_nil("NVIM_ENABLE_NETRW") == "1"
end

function M.php_lsp()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_PHP_PLUGIN") == "1"
end

function M.elixir_ls()
  if M.has_vscode() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_ELIXIR_LS") == "1"
end

function M.lexical()
  if M.has_vscode() then
    return false
  end

  return not M.elixir_ls()
    and utils.get_os_env_or_nil("NVIM_ENABLE_ELIXIR_LEXICAL") == "1"
end

function M.elixir_lsp()
  if M.has_vscode() then
    return false
  end

  return M.elixir_ls() or M.lexical()
end

function M.image_nvim()
  if M.has_vscode() or M.has_termux() then
    return false
  end

  return utils.get_os_env_or_nil("NVIM_ENABLE_IMAGE_NVIM") == "1"
end

function M.anki()
  return utils.get_os_env_or_nil("NVIM_ENABLE_ANKI") == "1"
end

function M.vim_lsp()
  return utils.get_os_env_or_nil("NVIM_ENABLE_VIM_LSP") == "1"
end

M.firenvim = function()
  if M.has_termux() then
    return false
  end
  if M.has_vscode() then
    return false
  end
  return utils.get_os_env_or_nil("NVIM_ENABLE_FIRE_NVIM") == "1"
end

M.has_web_browsers = function()
  if M.has_termux() then
    return false
  end
  if M.has_vscode() then
    return false
  end
  return true
end

return M
