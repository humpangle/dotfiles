local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.elixir_lsp() then
  return {}
end

local utils = require("utils")

local none_existing_vim_filetype = { "1" } -- hopefully a filetype that does not exist.

local M = {}

if plugin_enabled.lexical() then
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/lexical/init.lua
  M.lexical = {
    cmd = {
      -- I have a  global ELIXIR_LEXICAL_BIN in .bashrc and then project specific in the workspace root.
      os.getenv("ELIXIR_LEXICAL_BIN") or "lexical",
    },
    filetypes = none_existing_vim_filetype,
  }
else
  M.elixirls = {
    cmd = {
      -- I have a  global ELIXIR_LS_BIN in .bashrc and then project specific in the workspace root.
      utils.get_os_env_or_nil("ELIXIR_LS_BIN") or "elixir-ls",
    },
    filetypes = {
      "elixir",
      "eelixir",
      "heex",
      "surface",
    },
  }
end

return M
