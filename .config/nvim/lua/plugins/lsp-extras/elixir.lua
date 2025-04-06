local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.elixir_lsp() then
  return {}
end

local utils = require("utils")

-- If a lsp client is disabled, nvim can still suggest it (although not started) - we will see:
--    Other clients that match the filetype: elixir
--  The below will silence this message (pre-mature optmization ??)
local none_existing_vim_filetype = { "1" }

local M = {}

-- We want just one of elixirls/lexical running at a time. If elixirls is enabled, lexical is prevented from running.

if plugin_enabled.lexical() then
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/lexical/init.lua
  M.lexical = {
    -- I have a  global ELIXIR_LEXICAL_BIN in .bashrc and then project specific in the workspace root.
    cmd = {
      utils.get_os_env_or_nil("ELIXIR_LEXICAL_BIN") or "lexical",
    },
  }

  M.elixirls = {
    autostart = false,
    filetypes = none_existing_vim_filetype,
  }
elseif plugin_enabled.elixir_ls() then
  M.elixirls = {
    cmd = {
      -- I have a  global ELIXIR_LS_BIN in .bashrc and then project specific in the workspace root.
      utils.get_os_env_or_nil("ELIXIR_LS_BIN") or "elixir-ls",
    },
  }

  M.lexical = {
    autostart = false,
    filetypes = none_existing_vim_filetype,
  }
end

return M
