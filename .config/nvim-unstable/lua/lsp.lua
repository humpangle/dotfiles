local function on_attach(client, bufnr)

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {noremap = true, silent = true}
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                   opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
                   opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>law",
                   "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>lrw",
                   "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>llw",
                   "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                   opts)
    buf_set_keymap("n", "<leader>lt",
                   "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>lrf", "<cmd>lua vim.lsp.buf.references()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>ld",
                   "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>ll",
                   "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<leader>lca", "<cmd>lua vim.lsp.buf.code_action()<CR>",
                   opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf",
                       "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>lf",
                       "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        Cmd([[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
          hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646

          augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd cursorhold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd cursormoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
    end
end

local nvim_lsp = require("lspconfig")
local lsp_configs = require("lspconfig/configs")
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true;

-- Emmet
-- https://github.com/aca/emmet-ls
-- npm i -g emmet-ls
-- no need for hmtl server having emmet-ls and snippets working
-- npm i -g vscode-html-languageserver-bin
-- nvim_lsp.html.setup {}
lsp_configs.emmet_ls = {
    default_config = {
        cmd = {"emmet-ls", "--stdio"},
        filetypes = {"html", "css"},
        root_dir = function()
            return Vim.loop.cwd()
        end,
        settings = {},
    },
}
nvim_lsp.emmet_ls.setup {capabilities = capabilities, on_attach = on_attach}

-- python
-- npm i -g pyright
nvim_lsp.pyright.setup {capabilities = capabilities, on_attach = on_attach}

-- json
-- npm i -g vscode-json-languageserver
nvim_lsp.jsonls.setup {capabilities = capabilities, on_attach = on_attach}

-- bash
-- npm i -g bash-language-server
nvim_lsp.bashls.setup {capabilities = capabilities, on_attach = on_attach}

-- CSS
-- npm i -g vscode-css-languageserver-bin
nvim_lsp.cssls.setup {capabilities = capabilities, on_attach = on_attach}

-- TypeScript
-- npm i -g typescript typescript-language-server
nvim_lsp.tsserver.setup {capabilities = capabilities, on_attach = on_attach}

-- LUA
-- install instructions from
-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone):
-- git clone https://github.com/sumneko/lua-language-server $HOME/.local/share/nvim/lua/sumneko_lua
-- cd ~/.local/share/nvim/lua/sumneko_lua
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ninja -f ninja/linux.ninja
-- cd ../..
-- ./3rd/luamake/luamake rebuild
local luapath = "/home/" .. os.getenv("USER") ..
                    "/.local/share/nvim/lua/sumneko_lua"
local luabin = luapath .. "/bin/Linux/lua-language-server"

nvim_lsp.sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {luabin, "-E", luapath .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = Vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim", "use", "run", "Theming", "LSP", "Completion"},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [Vimf.expand("$VIMRUNTIME/lua")] = true,
                    [Vimf.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 10000,
            },
            telemetry = {enable = false},
            completion = {snippetSupport = true},
        },
    },
}
