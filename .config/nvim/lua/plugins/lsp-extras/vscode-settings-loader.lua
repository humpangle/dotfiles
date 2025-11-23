--[[
  Configure Neovim lsp settings using JSON files (can have comments)
  For settings to put in json file, check:
  https://github.com/fannheyward/coc-pyright
  https://raw.githubusercontent.com/microsoft/pyright/master/packages/vscode-pyright/package.json
]]

return {
  ["codesettings.nvim"] = {
    {
      "mrjones2014/codesettings.nvim",
      opts = {
        -- defaults; .vscode/settings.json is already included
        config_file_paths = {
          ".vscode/settings.json",
          "codesettings.json",
          "lspsettings.json",
        },
      },
      ft = {
        "json",
        "jsonc",
        "lua",
      },
    },
    function()
      -- This must run after you’ve set up your servers / lspconfig
      vim.lsp.config("*", {
        before_init = function(_, config)
          local codesettings = require("codesettings")
          config = codesettings.with_local_settings(config.name, config)
        end,
      })
    end,
  },
  ["neoconf.nvim"] = nil,
}
