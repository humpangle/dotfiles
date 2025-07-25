-- NATIVE NEOVIM LSP

local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")
local yamlls_config = require("plugins.lsp-extras.yaml_lsp")

---@param conditon string
---@param lsp string
local conditionally_install = function(conditon, lsp)
  local config = {}
  if plugin_enabled[conditon]() then
    config[lsp] = {}
  end
  return config
end

--[[ default keymaps; https://gpanders.com/blog/whats-new-in-neovim-0-11/#more-default-mappings
  grn
    in Normal mode maps to vim.lsp.buf.rename()
  grr
    in Normal mode maps to vim.lsp.buf.references()
  gri
    in Normal mode maps to vim.lsp.buf.implementation()
  gO
    in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and
    :Man page buffers to show a “table of contents”)
  gra
    in Normal and Visual mode maps to vim.lsp.buf.code_action()
  CTRL-S
    in Insert and Select mode maps to vim.lsp.buf.signature_help()
  [d and ]d
    move between diagnostics in the current buffer
  [D
    jumps to the first diagnostic, ]D jumps to the last)
]]

return {
  {
    --[[
        configure Neovim using JSON files (can have comments)
        for settings to put in json file, check:
        https://github.com/fannheyward/coc-pyright
        https://raw.githubusercontent.com/microsoft/pyright/master/packages/vscode-pyright/package.json

        create at the root of project .neoconf.json (invoke :Neoconf local) and put (for example):
        {
          "lspconfig": {
            "pyright": {
              "python.analysis.diagnosticSeverityOverrides": {
                "reportUnusedVariable": "none"
              },
              "python.analysis.typeCheckingMode": "off"
            }
          }
        }
    ]]

    "folke/neoconf.nvim",
  },
  {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    "williamboman/mason.nvim",
    enabled = true,
    dependencies = {
      -- Install or upgrade all of your third-party tools (linters, formatters etc) with mason.
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },

  {
    "neovim/nvim-lspconfig",
    enabled = true,
    dependencies = {
      -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim.
      -- Use lspconfig names instead of Mason names.
      "williamboman/mason-lspconfig.nvim",

      -- UI for Neovim notifications and LSP progress messages at the right hand corner of the buffer window.
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        "j-hui/fidget.nvim",
        opts = {},
      },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },

      -- Highlight todo, notes, etc in comments
      {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        opts = {
          signs = false,
        },
      },

      -- Dim inactive portions of the code you're editing. Uses TreeSitter for better dimming.
      -- Does not seem to work for now.
      {
        "folke/twilight.nvim",
        opts = {
          dimming = {
            alpha = 0.6, -- amount of dimming
          },
        },
      },

      -- Allows us to use the schemastore catalog
      -- (https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json)
      -- in jsonls and yamlls by referencing only the *name*.
      "b0o/schemastore.nvim",

      yamlls_config.yaml_companion_plugin_init(),
    },
    config = function()
      -- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.
      -- https://github.com/folke/neoconf.nvim?tab=readme-ov-file#-setup
      require("neoconf").setup({
        -- override any of the default settings here
      })

      local lspconfig = require("lspconfig")

      utils.map_key("n", "<leader>ls0", function()
        local count = vim.v.count

        if count == 0 then
          vim.cmd("LspInfo")
          return
        end

        if count == 1 then
          vim.cmd("LspLog")
          return
        end

        if count == 2 then
          vim.cmd("LspStop")
          vim.cmd.echo('"LspStopped 3<leader>ls0 to start"')
          return
        end

        if count == 3 then
          vim.cmd("LspStart")
          vim.cmd.echo('"LspStart"')
          return
        end

        if count == 44 then
          vim.cmd("TSContext toggle")
          print("TSContext toggle")
          return
        end

        if count == 4 then
          -- TODO: implement dynamic level up
          -- 40 == 1, 41 == 1, 42 == 2
          local level_up = 1
          require("treesitter-context").go_to_context(level_up)
          return
        end

        if count == 45 then
          local twilight_view = require("twilight.view")
          if twilight_view.enabled then
            twilight_view.disable()
            vim.notify("Twilight disabled")
          else
            twilight_view.enable()
            vim.notify("Twilight enabled")
          end
          return
        end
      end, {
        desc = "0/info 1/log 2/stop 3/start 44/TSContextToggle 45/twilightToggle 4*/trsGoToContext",
      })

      --  This function gets run when an LSP attaches to a particular buffer. That is to say, every time a new file is
      --  opened that is associated with an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --  function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "ebnis-lsp-attach",
          { clear = true }
        ),
        callback = function(event)
          -- TODO:keymaps not working
          local map = function(keys, func, desc)
            utils.map_key("n", keys, func, {
              buffer = event.buf,
              desc = "LSP: " .. desc,
            })
          end

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map(
            "<leader>D",
            require("telescope.builtin").lsp_type_definitions,
            "Type [D]efinition"
          )

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map(
            "<leader>ca",
            vim.lsp.buf.code_action,
            "[C]ode [A]ction"
          )

          local client =
            vim.lsp.get_client_by_id(event.data.client_id)

          -- Servers like pyright do not support formatting.
          if
            client ~= nil
            and client:supports_method("textDocument/formatting")
          then
            -- Format the code using builtin LSP code formatter
            map("<leader>fc", function()
              vim.lsp.buf.format({
                timeout_ms = 500000,
              })
            end, "[F]ormat [C]ode")
          end

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration. - import statement in current buffer?
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).

          if
            client
            and client.server_capabilities.documentHighlightProvider
          then
            vim.api.nvim_create_autocmd(
              { "CursorHold", "CursorHoldI" },
              {
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
              }
            )

            vim.api.nvim_create_autocmd({
              "CursorMoved",
              "CursorMovedI",
            }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()

      local lsp_extended_capabilities = lsp_capabilities

      -- Augment neovim LSP capabilities with those from nvim cmp.
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_nvim_lsp_ok then
        lsp_extended_capabilities = vim.tbl_deep_extend(
          "force",
          lsp_capabilities,
          cmp_nvim_lsp.default_capabilities()
        )
      end

      -- Ensure the servers and tools below are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require("mason").setup() -- we need this here so we can mason related functions

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs

        html = {},
        nginx_language_server = {},
      }

      servers = vim.tbl_extend(
        "error",
        servers,
        conditionally_install("bash_lsp", "bashls"),
        conditionally_install("terraform_lsp", "terraformls"),
        conditionally_install("tailwindcss_lsp", "tailwindcss"),
        yamlls_config.config_from_yaml_companion_plugin(),
        require("plugins.lsp-extras.json"),
        require("plugins.lsp-extras.python-lsp"),
        require("plugins.lsp-extras.elixir"),
        require("plugins.lsp-extras.docker"),
        require("plugins.lsp-extras.emmet"),
        require("plugins.lsp-extras.typescript"),
        require("plugins.lsp-extras.php"),
        require("plugins.lsp-extras.sql")
      )

      if not plugin_enabled.has_termux() then
        servers = vim.tbl_extend("error", servers, {
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
        })
      end

      if plugin_enabled.stylua_lsp_formatter() then
        -- stylua does not work on android.
        vim.list_extend(servers, {
          -- Used to format Lua code
          stylua = {},
        })
      end

      -- /END/ servers variable

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      ---@diagnostic disable-next-line: missing-fields
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        automatic_enable = false,
      })

      -- mason does not know how to setup lua_ls on termux, so we do it manually.
      ---@diagnostic disable:missing-fields
      if plugin_enabled.has_termux() then
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        })
      end

      local non_lsps = {
        debugpy = true,
        hadolint = true,
        black = true,
        ["sql-formatter"] = true,
        flake8 = true,
        isort = true,
      }

      local to_enable = {}

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          server.capabilities or {},
          lsp_extended_capabilities
        )
        vim.lsp.config(server_name, server)

        if not non_lsps[server_name] then
          table.insert(to_enable, server_name)
        end
      end

      vim.lsp.enable(to_enable)
    end,
  },

  require("plugins.lsp-extras.barbecue-nvim"),
  require("plugins.lsp-extras.python-tools"),
  require("plugins.lsp-extras.nvim-lint"),
}
