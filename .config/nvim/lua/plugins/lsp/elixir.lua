local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.elixir_lsp() then
  return {}
end

local utils = require("utils")

local elixir_lsp_filetypes = {
  "elixir",
  "eelixir",
  "heex",
  "surface",
}

local none_existing_vim_filetype = { "1" } -- hopefully a filetype that does not exist.

local filetypes = nil

if utils.os_env_not_empty("NVIM_USE_ELIXIR_LS") then
  filetypes = elixir_lsp_filetypes
elseif utils.os_env_not_empty("NVIM_USE_ELIXIR_LEXICAL") then
  filetypes = none_existing_vim_filetype
else
  filetypes = elixir_lsp_filetypes
end

local bin_from_env_var = utils.get_os_env_or_nil("ELIXIR_LS_BIN")

return {
  elixirls = {
    cmd = {
      -- I have a  global ELIXIR_LS_BIN in .bashrc and then project specific in the workspace root.
      bin_from_env_var or "elixir-ls",
    },
    filetypes = filetypes,
  },

  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/lexical/init.lua
  lexical = {
    cmd = {
      -- I have a  global ELIXIR_LEXICAL_BIN in .bashrc and then project specific in the workspace root.
      os.getenv("ELIXIR_LEXICAL_BIN") or "lexical",
    },
    filetypes = utils.get_os_env_or_nil("NVIM_USE_ELIXIR_LEXICAL")
      or none_existing_vim_filetype,
  },
}
