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
      -- Install or upgrade all of your third-party tools with mason.
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
      { "folke/neodev.nvim", opts = {} },

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
        opts = {},
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
          vim.cmd.echo('"LspStopped 1<leader>ls1 to start"')
          return
        end

        if count == 3 then
          vim.cmd("LspStart")
          vim.cmd.echo('"LspStart"')
          return
        end

        if count == 4 then
          vim.cmd("TSContextToggle")
          vim.cmd.echo('"TSContextToggle"')
        end
      end, { desc = "0/info 1/log 2/stop 3/start 4/tscontext" })

      -- Diagnostic keymaps
      utils.map_key(
        "n",
        "[d",
        vim.diagnostic.goto_prev,
        { desc = "Go to previous [D]iagnostic message" }
      )
      utils.map_key(
        "n",
        "]d",
        vim.diagnostic.goto_next,
        { desc = "Go to next [D]iagnostic message" }
      )
      utils.map_key(
        "n",
        "<leader>e",
        vim.diagnostic.open_float,
        { desc = "Show diagnostic [E]rror messages" }
      )

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

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map(
            "<leader>ca",
            vim.lsp.buf.code_action,
            "[C]ode [A]ction"
          )

          map("<leader>lse", function()
            local count = vim.v.count

            if count == 1 then
              vim.diagnostic.open_float({ focusable = true })
              vim.diagnostic.open_float({ focusable = true }) -- second invocation is to focus the popup
            elseif count == 2 then
              require("treesitter-context").go_to_context(
                vim.v.count1
              )
            else
              vim.diagnostic.setloclist()
            end
          end, "Open diagnostics 0/qf 1/popup")

          local client =
            vim.lsp.get_client_by_id(event.data.client_id)

          -- Servers like pyright do not support formatting.
          if
            client ~= nil
            and client.supports_method("textDocument/formatting")
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
      -- /END/ servers variable

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})

      if plugin_enabled.stylua_lsp_formatter() then
        -- stylua does not work on android.
        vim.list_extend(ensure_installed, {
          "stylua", -- Used to format Lua code
        })
      end

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      ---@diagnostic disable-next-line: missing-fields
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend(
              "force",
              server.capabilities or {},
              lsp_extended_capabilities
            )

            pcall(lspconfig[server_name].setup, server)
          end,
        },
      })

      -- Mason does not support nginx language server - so we do it ourselves:
      --
      -- Latest supported python version for nginx-language-server is 3.11.9
      --
      -- Install language server binary: https://pypi.org/project/nginx-language-server/
      --  pip install -U nginx-language-server
      --
      -- Install nginx-language-server lsp:
      --  :LspInstall nginx

      if vim.fn.executable("nginx-language-server") == 1 then
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#nginx_language_server
        lspconfig.nginx_language_server.setup({
          capabilities = lsp_extended_capabilities,
        })
      end

      -- mason does not know how to setup lua_ls on termux, so we do it manually.
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
    end,
  },

  require("plugins.lsp-extras.barbecue-nvim"),
  require("plugins.lsp-extras.python-tools"),
  require("plugins.lsp-extras.nvim-lint"),
}
