-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- npm install -g typescript typescript-language-server

local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
local util = require 'lspconfig/util'
-- Check if it's already defined for when reloading this file.
if not lspconfig.tsserver then
  -- configuration code taken from:
  -- https://github.com/neovim/nvim-lspconfig/blob/f9785053a4ef4aaa2d0aac958bc09a1a289d2fbf/lua/lspconfig/tsserver.lua
  configs.tsserver = {
    default_config = {
      cmd = {
       "typescript-language-server",
       "--stdio"
      };
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
      };
      root_dir = function(fname)
        return util.root_pattern("tsconfig.json")(fname) or
          util.root_pattern("package.json", "jsconfig.json", ".git")(fname);
      end
    };
  }
end
lspconfig.tsserver.setup{}
