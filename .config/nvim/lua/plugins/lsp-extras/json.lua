local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.json_ls() then
  return {}
end

return {
  jsonls = {
    settings = {
      json = {
        validate = {
          -- Validation is enabled by default in jsonls. But if an option is overriden (which we have done in order
          -- to use schemastore plugin since jsonls does not download schemas like yamlls) all other options are
          -- unset. Other LSP plugins do not exhibit this behavior (i.e. if you override one, others are left
          -- untouched).
          enable = true,
        },

        schemas = require("schemastore").json.schemas({
          select = {
            "package.json",
            "GitHub Workflow Template Properties",
          },
        }),
      },
    },
  },
}
