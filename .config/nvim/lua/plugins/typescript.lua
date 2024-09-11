local get_vue_lang_server_path = function()
  -- We expect the path here -
  -- os.getenv("HOME") .. "/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server",

  local mason_registry = require("mason-registry")

  local ok, pkg = pcall(mason_registry.get_package, "vue-language-server")

  if not ok then
    return ""
  end

  local vue_language_server_path = pkg:get_install_path()
    .. "/node_modules/@vue/language-server"

  return vue_language_server_path
end

local config = {
  --[[ The state of typescript LSP is unfortunately a sad one. The official tsserver (typescript) from microsoft is
        not compatible with LSP protocol (since the project predates the birth of LSP) and microsoft team is making
        slow progress towards LSP compatibility.

        For now, there is typescript-language-server which sits (as proxy) between LSP clients and tsserver:
               lsp client --> typescript-language-server --> tsserver
        which works, but is claimed to be slow for very large typescript projects. This is what you get by using
        stock nvim-lspconfig.

        There has been various efforts from the community to augment nvim-lspconfig's typescript-language-server
        integration (https://github.com/jose-elias-alvarez/typescript.nvim archived) or bypass
        typescript-language-server completely (https://github.com/pmizio/typescript-tools.nvim -
        does not work well nvim-lspconfig).
      --]]

  -- If you want nvim-lspconfig managed tsserver:
  -- ts_ls = {}, -- see below for actual configuration

  volar = { -- mason: vue-language-server
    -- To enable Take Over Mode, override the default filetypes in `setup{}` as follows:
    -- Take Over Mode will run its own tsserver, unlike hybrid mode which uses your own tsserver
    -- filetypes = {
    --   "typescript",
    --   "javascript",
    --   "javascriptreact",
    --   "typescriptreact",
    --   "vue",
    -- },
    -- hybrid mode setting
    filetypes = {
      "vue",
    },

    -- Using take over mode and want to use custom tsserver? See Volar configuration for on_new_config at:
    -- $HOME/.local/share/nvim/lazy/nvim-lspconfig/doc/server_configurations.txt
    -- on_new_config = function(new_config, new_root_dir) end
  },
}

local typescript_ls_config = { -- mason: typescript-language-server
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        -- *IMPORTANT*: It is crucial to ensure that `@vue/typescript-plugin` and `volar `are of identical versions.
        location = get_vue_lang_server_path(),
        languages = {
          "vue",
        },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue", -- volar hybrid mode
  },
}

-- Somehow my macbook uses tsserver while linux uses ts_ls
if vim.fn.has("mac") == 1 then
  config["tsserver"] = typescript_ls_config
else
  config["ts_ls"] = typescript_ls_config
end

return config
