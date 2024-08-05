-- NATIVE NEOVIM LSP

local utils = require("utils")
local plugin_enabled = require("plugins/plugin_enabled")
local yamlls_config = require("plugins.yaml_lsp")

return {
  {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    "williamboman/mason.nvim",
    enabled = not plugin_enabled.has_vscode(),
    dependencies = {
      -- Install or upgrade all of your third-party tools with mason.
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },

  {
    "neovim/nvim-lspconfig",
    enabled = plugin_enabled.lsp(),
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
      local lspconfig = require("lspconfig")

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
      utils.map_key(
        "n",
        "<leader>q",
        vim.diagnostic.setloclist,
        { desc = "Open diagnostic [Q]uickfix list" }
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

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map(
            "gd",
            require("telescope.builtin").lsp_definitions,
            "[G]oto [D]efinition"
          )

          -- Find references(places where identifiers are used/referenced) for the word under your cursor.
          map(
            "gr",
            require("telescope.builtin").lsp_references,
            "[G]oto [R]eferences"
          )

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map(
            "gI",
            require("telescope.builtin").lsp_implementations,
            "[G]oto [I]mplementation"
          )

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map(
            "<leader>D",
            require("telescope.builtin").lsp_type_definitions,
            "Type [D]efinition"
          )

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map(
            "<leader>bs",
            require("telescope.builtin").lsp_document_symbols,
            "[B]uffer [S]ymbols"
          )

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map(
            "<leader>ws",
            require("telescope.builtin").lsp_dynamic_workspace_symbols,
            "[W]orkspace [S]ymbols"
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

          -- Format the code using builtin LSP code formatter
          map("<leader>fc", function()
            vim.lsp.buf.format({ timeout_ms = 500000 })
          end, "[F]ormat [C]ode")

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
          local client =
            vim.lsp.get_client_by_id(event.data.client_id)

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

      local elixir_lsp_filetypes = {
        "elixir",
        "eelixir",
        "heex",
        "surface",
      }

      local none_existing_vim_filetype = { "1" } -- hopefully a filetype that does not exist.

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

        pyright = {
          on_init = function(client)
            local workspace = client.config.root_dir
            local python_bin =
              require("plugins/lsp_utils").get_python_path(
                workspace
              )

            client.config.settings.python.pythonPath = python_bin
            vim.g.python_host_prog = python_bin
            vim.g.python3_host_prog = python_bin
          end,
        },

        -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/lexical/init.lua
        lexical = {
          cmd = {
            -- I have a  global ELIXIR_LEXICAL_BIN in .bashrc and then project specific in the workspace root.
            os.getenv("ELIXIR_LEXICAL_BIN") or "lexical",
          },
          filetypes = utils.os_env_not_empty(
            "NVIM_USE_ELIXIR_LEXICAL"
          ) and elixir_lsp_filetypes or none_existing_vim_filetype,
        },

        bashls = {},

        yamlls = yamlls_config.config_from_yaml_companion_plugin(),

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

        tailwindcss = {},

        emmet_language_server = {}
      }

      local elixir_ls_config_fn = function()
        local filetypes = nil

        if utils.os_env_not_empty("NVIM_USE_ELIXIR_LS") then
          filetypes = elixir_lsp_filetypes
        elseif utils.os_env_not_empty("NVIM_USE_ELIXIR_LEXICAL") then
          filetypes = none_existing_vim_filetype
        else
          filetypes = elixir_lsp_filetypes
        end

        local bin_from_env_var = utils.os_env_not_empty("ELIXIR_LS_BIN")
          and os.getenv("ELIXIR_LS_BIN")

        return {
          elixirls = {
            cmd = {
              -- I have a  global ELIXIR_LS_BIN in .bashrc and then project specific in the workspace root.
              bin_from_env_var or "elixir-ls",
            },
            filetypes = filetypes,
          },
        }
      end

      servers = vim.tbl_extend("error", servers, elixir_ls_config_fn())

      if not plugin_enabled.has_termux() then
        servers = vim.tbl_extend("error", servers, {
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

          -- If you want nvim-lspconfig managed tsserver, uncomment the below:
          tsserver = {},

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

          dockerls = {},

          terraformls = {},
        })
      end
      -- /END/ servers variable

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})

      if not plugin_enabled.has_termux() then
        -- stylua does noot work onn android.
        vim.list_extend(ensure_installed, {
          "stylua", -- Used to format Lua code
        })
      end

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend(
              "force",
              {},
              lsp_extended_capabilities,
              server.capabilities or {}
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
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#nginx_language_server
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
}
