local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")

local credentials_directory = utils.get_os_env_or_nil("GOOGLE_DOC_VIM_DIR")

if not credentials_directory then
  return {}
end

local path_to_creds = credentials_directory .. "/google-doc-credentials.json"

if not utils.file_exists_and_not_empty(path_to_creds) then
  return {}
end

vim.g.token_directory = credentials_directory
vim.g.path_to_creds = path_to_creds

vim.g.gdoc_file_path = "~/projects/google-doc/.vim/"

return {
  "callmiy/gdoc.vim",
  branch = "main",
  build = "./install.py",
}
