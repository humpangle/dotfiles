local utils = require("utils")

local get_vue_typescript_plugin_path = function()
  local mason_registry = require("mason-registry")

  if not mason_registry.has_package("vue-language-server") then
    vim.notify("[LSP] vue-language-server not installed in Mason", vim.log.levels.WARN)
    return ""
  end

  local path = utils.mason_install_path .. "/vue-language-server/node_modules/@vue/language-server"

  if vim.fn.glob(path) == "" then
    vim.notify("[LSP] vue typescript plugin not installed in Mason. Does not exist " .. path, vim.log.levels.WARN)
    return ""
  end

  return path
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
  -- ts_ls = {}, -- but vtsls claims it's better

  vue_ls = {},
  vtsls = {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = get_vue_typescript_plugin_path(),
              languages = { "vue" },
              configNamespace = "typescript",
            },
          },
        },
      },
    },
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
    },
  },
}

return config
