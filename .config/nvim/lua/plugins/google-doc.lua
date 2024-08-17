local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local plugin_dir = os.getenv("GOOGLE_DOC_PLUGIN_DIR")

return {
  plugin_dir,
  dir = "/Users/kanmii/projects/nvim/gdoc.vim",
  build = "./install.py",
  branch = "main",
  init = function()
    local credentials_directory = os.getenv("GOOGLE_DOC_VIM_DIR")
    vim.g.path_to_creds = credentials_directory .. "/google-doc-credentials.json"
    vim.g.token_directory = credentials_directory
    vim.g.gdoc_file_path = "~/projects/google-doc/.vim/"
  end,
}
