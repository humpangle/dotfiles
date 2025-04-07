local plugin_enabled = require("plugins/plugin_enabled")

local M = {}

function M.yaml_companion_plugin_init()
  if not plugin_enabled.yaml_lsp() then
    return {}
  end

  return {
    "someone-stole-my-name/yaml-companion.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "b0o/schemastore.nvim",
    },

    config = function()
      -- Telescope picker that lets us manually choose the schema for the current buffer. Courtesy yaml-companion plugin.
      require("telescope").load_extension("yaml_schema")
    end,
  }
end

function M.config_from_yaml_companion_plugin()
  if not plugin_enabled.yaml_lsp() then
    return {}
  end

  local yaml_companion_config = require("yaml-companion").setup({
    -- Detect schemas based on file content (e.g. presence of `kind` attribute in k8s and that atribute value matches
    -- some predefined k8s resources values).
    builtin_matchers = {
      kubernetes = {
        enabled = true,
      },

      cloud_init = {
        enabled = true,
      },
    },

    -- Schemas available in Telescope picker and statusline.
    schemas = {
      -- K8s CRDs are not enabled by default by yaml-companion plugin. We need to define them manually and then use:
      --    :Telescope yaml_schema
      -- to enable for appropriate file.
      {
        name = "Argo CD Application",
        uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
      },

      {
        name = "SealedSecret",
        uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
      },
      -- / K8s CRDs

      -- Schemas below are automatically loaded, but added here so they show up in the statusline.
      {
        name = "docker-compose.yml",
        uri = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
      },

      {
        name = "Kustomization",
        uri = "https://json.schemastore.org/kustomization.json",
      },

      {
        name = "GitHub Workflow",
        uri = "https://json.schemastore.org/github-workflow.json",
      },
    },

    -- The lspconfig that will be merged into yamlls LSP config.
    lspconfig = {
      settings = {
        yaml = {
          -- Detects whether the entire file is valid yaml.
          -- Detects errors such as: Node is not found.
          -- Detects warnings such as: Node is an additional property of parent.
          validate = true,

          format = {
            enable = true,
          },

          hover = true,

          schemaStore = {
            -- Schema store is enabled by default. We disable it here and manually enable a few below.
            -- We must disable built-in schemaStore support in order to use `b0o/schemastore.nvim` plugin and
            -- its advanced options like `ignore`.
            enable = false,

            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
            -- url = "https://www.schemastore.org/api/json/catalog.json",
          },

          -- Schemas from store that will be loaded automatically.
          schemas = require("schemastore").yaml.schemas({
            select = {
              "kustomization.yaml",
              "GitHub Workflow",
              "docker-compose.yml",
            },
          }),
        },
      },
    },
  })

  return {
    yamlls = yaml_companion_config,
  }
end

-- Get schema for current buffer (for example: for display in statusline). Add it to lualine plugin configuration.
function M.get_yaml_schema()
  local ok, yaml_companion = pcall(require, "yaml_companion")

  if not ok then
    return ""
  end

  local schema = yaml_companion.get_buf_schema(0)

  if schema.result[1].name == "none" then
    return ""
  end

  local name = schema.result[1].name or ""

  -- For container compose file, we will either receive `docker-compose.yml` or `Compose Specification`.
  -- We normalize both to `Compose`
  if name == "docker-compose.yml" then
    name = "Compose"
  else
    name = string.gsub(name, " Specification", "")
  end

  return "*" .. name
end

return M
