local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  "callmiy/gdoc.vim",
  branch = "main",
  build = "./install.py",
  init = function()
    local credentials_directory = os.getenv("GOOGLE_DOC_VIM_DIR")
    vim.g.path_to_creds = credentials_directory .. "/google-doc-credentials.json"
    vim.g.token_directory = credentials_directory
    vim.g.gdoc_file_path = "~/projects/google-doc-vim/"
  end,
}
