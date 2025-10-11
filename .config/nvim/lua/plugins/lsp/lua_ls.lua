local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_termux() then
  return {}
end

return {
  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  -- stylua does not work on android.
  stylua = {},
}
